Date: Fri, 2 Oct 2020 14:13:14 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201002211314.GE24460@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
	<20200929043700.GL31514@linux.intel.com>
	<20201001215508.GD3522@redhat.com>
	<20201001223320.GI7474@linux.intel.com>
	<20201002153854.GC3119@redhat.com>
	<20201002183036.GB24460@linux.intel.com>
	<20201002192734.GD3119@redhat.com>
	<20201002194517.GD24460@linux.intel.com>
	<20201002200214.GB10232@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201002200214.GB10232@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4] kvm,
	x86: Exit to user space in case page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, vkuznets@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 04:02:14PM -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2020 at 12:45:18PM -0700, Sean Christopherson wrote:
> > On Fri, Oct 02, 2020 at 03:27:34PM -0400, Vivek Goyal wrote:
> > > On Fri, Oct 02, 2020 at 11:30:37AM -0700, Sean Christopherson wrote:
> > > > On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> > > > I don't think it's necessary to provide userspace with the register state of
> > > > the guest task that hit the bad page.  Other than debugging, I don't see how
> > > > userspace can do anything useful which such information.
> > > 
> > > I think debugging is the whole point so that user can figure out which
> > > access by guest task resulted in bad memory access. I would think this
> > > will be important piece of information.
> > 
> > But isn't this failure due to a truncation in the host?  Why would we care
> > about debugging the guest?  It hasn't done anything wrong, has it?  Or am I
> > misunderstanding the original problem statement.
> 
> I think you understood problem statement right. If guest has right
> context, it just gives additional information who tried to access
> the missing memory page. 

Yes, but it's not actionable, e.g. QEMU can't do anything differently given
a guest RIP.  It's useful information for hands-on debug, but the information
can be easily collected through other means when doing hands-on debug.
 
> > > > To fully handle the situation, the guest needs to remove the bad page from
> > > > its memory pool.  Once the page is offlined, the guest kernel's error
> > > > handling will kick in when a task accesses the bad page (or nothing ever
> > > > touches the bad page again and everyone is happy).
> > > 
> > > This is not really a case of bad page as such. It is more of a page
> > > gone missing/trucated. And no new user can map it. We just need to
> > > worry about existing users who already have it mapped.
> > 
> > What do you mean by "no new user can map it"?  Are you talking about guest
> > tasks or host tasks?  If guest tasks, how would the guest know the page is
> > missing and thus prevent mapping the non-existent page?
> 
> If a new task wants mmap(), it will send a request to virtiofsd/qemu
> on host. If file has been truncated, then mapping beyond file size
> will fail and process will get error.  So they will not be able to
> map a page which has been truncated.

Ah.  Is there anything that prevents the notification side of things from
being handled purely within the virtiofs layer?  E.g. host notifies the guest
that a file got truncated, virtiofs driver in the guest invokes a kernel API
to remove the page(s).

> > > > Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
> > > > to handle this, but I suspect the resulting behavior will look quite similar,
> > > > e.g. notify the virtiofs driver in the guest, which does some magic to take
> > > > the offending region offline, and then guest tasks get SIGBUS or whatever.
> > > > 
> > > > I also don't think it's KVM's responsibility to _directly_ handle such a
> > > > scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
> > > > page fault came back with -EFAULT, only userspace can connect the dots of
> > > > GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
> > > > exit to userspace on the -EFAULT instead of hanging the guest, but that can
> > > > be done via a new request, as suggested.
> > > 
> > > KVM atleast should have the mechanism to report this back to guest. And
> > > we don't have any. There only seems to be #MC stuff for poisoned pages.
> > > I am not sure how much we can build on top of #MC stuff to take care
> > > of this case. One problem with #MC I found was that it generates
> > > synchronous #MC only on load and not store. So all the code is
> > > written in such a way that synchronous #MC can happen only on load
> > > and hence the error handling. 
> > > 
> > > Stores generate different kind of #MC that too asynchronously and
> > > caller will not know about it immiditely. But in this case we need
> > > to know about error in the context of caller both for loads and stores.
> > > 
> > > Anyway, I agree that this patch does not solve the problem of race
> > > free synchronous event inject into the guest. That's something yet
> > > to be solved either by #VE or by #MC or by #foo.
> > > 
> > > This patch is only doing two things.
> > > 
> > > - Because we don't have a mechanism to report errors to guest, use
> > >   the second best method and exit to user space.
> > 
> > Not that it matters at this point, but IMO exiting to userspace is the
> > correct behavior, not simply "second best method".  Again, KVM by design
> > does not know what lies behind any given HVA, and therefore should not be
> > making decisions about how to handle bad HVAs.
> >  
> > > - Make behavior consistent between synchronous fault and async faults.
> > >   Currently sync faults exit to user space on error while async
> > >    faults spin infinitely.
> > 
> > Yes, and this part can be done with a new request type.  Adding a new
> > request doesn't commit KVM to any ABI changes, e.g. userspace will still
> > see an -EFAULT return, and nothing more.  I.e. handling this via request
> > doesn't prevent switching to synchronous exits in the future, if such a
> > feature is required.
> 
> I am really not sure what benfit this kvm request is bringing to the
> table. To me maintaining a hash table and exiting when guest retries
> is much nicer desgin.

8 bytes pre vCPU versus 512 bytes per vCPU, with no guesswork.  I.e. the
request can guarantee the first access to a truncated file will be reported
to userspace.

> In fact, once we have the mechanism to inject error into the guest using an
> exception, We can easily plug that into the same path.

You're blurring the two things together.  The first step is to fix the
infinite loop by exiting to userspace with -EFAULT.  Notifying the guest of
the truncated file is a completely different problem to solve.  Reporting
-EFAULT to userspace is a pure bug fix, and is not unique to DAX.

> If memory usage is a concern, we can reduce the hash table size to say
> 4 or 8.
> 
> How is this change commiting KVM to an ABI?

I didn't mean to imply this patch changes the ABI.  What I was trying to say
is that going with the request-based implementation doesn't commit KVM to
new behavior, e.g. we can yank out the request implementation in favor of
something else if the need arises.

> > > Once we have a method to report errors back to guest, then we first
> > > should report error back to guest. And only in the absense of such
> > > mechanism we should exit to user space.
> > 
> > I don't see the value in extending KVM's ABI to avoid the exit to userspace.
> > E.g. we could add a memslot flag to autoreflect -EFAULT as an event of some
> > form, but this is a slow path, the extra time should be a non-issue.
> 
> IIUC, you are saying that this becomes the property of memory region. Some
> memory regions can choose their errors being reported back to guest
> (using some kind of flag in memslot). And in the absense of such flag,
> default behavior will continue to be exit to user space?
> 
> I guess that's fine if we don't want to treat all the memory areas in
> same way. I can't think why reporting errors for all areas to guest
> is a bad idea.

Because it'd be bleeding host information to the guest.  E.g. if there's a
a host kernel bug that causes gup() to fail, then KVM would inject a random
fault into the guest, which is all kinds of bad.

> Let guest either handle the error or die if it can't
> handle it. But that discussion is for some other day. Our first problem
> is that we don't have a race free mechanism to report errors.
> 
> Thanks
> Vivek
> 

