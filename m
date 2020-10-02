Date: Fri, 2 Oct 2020 12:45:18 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201002194517.GD24460@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
	<20200929043700.GL31514@linux.intel.com>
	<20201001215508.GD3522@redhat.com>
	<20201001223320.GI7474@linux.intel.com>
	<20201002153854.GC3119@redhat.com>
	<20201002183036.GB24460@linux.intel.com>
	<20201002192734.GD3119@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201002192734.GD3119@redhat.com>
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

On Fri, Oct 02, 2020 at 03:27:34PM -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2020 at 11:30:37AM -0700, Sean Christopherson wrote:
> > On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> > > On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> > > > Alternatively, what about adding a new KVM request type to handle this?
> > > > E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> > > > request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> > > > to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> > > > simply get if error_gfn is "valid", i.e. there's a pending request.
> > > 
> > > Sorry, I did not understand the above proposal. Can you please elaborate
> > > a bit more. Part of it is that I don't know much about KVM requests.
> > > Looking at the code it looks like that main loop is parsing if some
> > > kvm request is pending and executing that action.
> > > 
> > > Don't we want to make sure that we exit to user space when guest retries
> > > error gfn access again.
> > 
> > > In this case once we get -EFAULT, we will still inject page_ready into
> > > guest. And then either same process or a different process might run. 
> > > 
> > > So when exactly code raises a kvm request. If I raise it right when
> > > I get -EFAULT, then kvm will exit to user space upon next entry
> > > time. But there is no guarantee guest vcpu is running the process which
> > > actually accessed the error gfn. And that probably means that register
> > > state of cpu does not mean much and one can not easily figure out
> > > which task tried to access the bad memory and when.
> > > 
> > > That's why we prepare a list of error gfn and only exit to user space
> > > when error_gfn access is retried so that guest vcpu context is correct.
> > > 
> > > What am I missing?
> > 
> > I don't think it's necessary to provide userspace with the register state of
> > the guest task that hit the bad page.  Other than debugging, I don't see how
> > userspace can do anything useful which such information.
> 
> I think debugging is the whole point so that user can figure out which
> access by guest task resulted in bad memory access. I would think this
> will be important piece of information.

But isn't this failure due to a truncation in the host?  Why would we care
about debugging the guest?  It hasn't done anything wrong, has it?  Or am I
misunderstanding the original problem statement.

> > To fully handle the situation, the guest needs to remove the bad page from
> > its memory pool.  Once the page is offlined, the guest kernel's error
> > handling will kick in when a task accesses the bad page (or nothing ever
> > touches the bad page again and everyone is happy).
> 
> This is not really a case of bad page as such. It is more of a page
> gone missing/trucated. And no new user can map it. We just need to
> worry about existing users who already have it mapped.

What do you mean by "no new user can map it"?  Are you talking about guest
tasks or host tasks?  If guest tasks, how would the guest know the page is
missing and thus prevent mapping the non-existent page?

> > Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
> > to handle this, but I suspect the resulting behavior will look quite similar,
> > e.g. notify the virtiofs driver in the guest, which does some magic to take
> > the offending region offline, and then guest tasks get SIGBUS or whatever.
> > 
> > I also don't think it's KVM's responsibility to _directly_ handle such a
> > scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
> > page fault came back with -EFAULT, only userspace can connect the dots of
> > GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
> > exit to userspace on the -EFAULT instead of hanging the guest, but that can
> > be done via a new request, as suggested.
> 
> KVM atleast should have the mechanism to report this back to guest. And
> we don't have any. There only seems to be #MC stuff for poisoned pages.
> I am not sure how much we can build on top of #MC stuff to take care
> of this case. One problem with #MC I found was that it generates
> synchronous #MC only on load and not store. So all the code is
> written in such a way that synchronous #MC can happen only on load
> and hence the error handling. 
> 
> Stores generate different kind of #MC that too asynchronously and
> caller will not know about it immiditely. But in this case we need
> to know about error in the context of caller both for loads and stores.
> 
> Anyway, I agree that this patch does not solve the problem of race
> free synchronous event inject into the guest. That's something yet
> to be solved either by #VE or by #MC or by #foo.
> 
> This patch is only doing two things.
> 
> - Because we don't have a mechanism to report errors to guest, use
>   the second best method and exit to user space.

Not that it matters at this point, but IMO exiting to userspace is the
correct behavior, not simply "second best method".  Again, KVM by design
does not know what lies behind any given HVA, and therefore should not be
making decisions about how to handle bad HVAs.
 
> - Make behavior consistent between synchronous fault and async faults.
>   Currently sync faults exit to user space on error while async
>    faults spin infinitely.

Yes, and this part can be done with a new request type.  Adding a new
request doesn't commit KVM to any ABI changes, e.g. userspace will still
see an -EFAULT return, and nothing more.  I.e. handling this via request
doesn't prevent switching to synchronous exits in the future, if such a
feature is required.

> Once we have a method to report errors back to guest, then we first
> should report error back to guest. And only in the absense of such
> mechanism we should exit to user space.

I don't see the value in extending KVM's ABI to avoid the exit to userspace.
E.g. we could add a memslot flag to autoreflect -EFAULT as an event of some
form, but this is a slow path, the extra time should be a non-issue.

