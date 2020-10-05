Date: Mon, 5 Oct 2020 09:16:20 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201005161620.GC11938@linux.intel.com>
References: <20200929043700.GL31514@linux.intel.com>
	<20201001215508.GD3522@redhat.com>
	<20201001223320.GI7474@linux.intel.com>
	<20201002153854.GC3119@redhat.com>
	<20201002183036.GB24460@linux.intel.com>
	<20201002192734.GD3119@redhat.com>
	<20201002194517.GD24460@linux.intel.com>
	<20201002200214.GB10232@redhat.com>
	<20201002211314.GE24460@linux.intel.com>
	<20201005153318.GA4302@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201005153318.GA4302@redhat.com>
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

On Mon, Oct 05, 2020 at 11:33:18AM -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2020 at 02:13:14PM -0700, Sean Christopherson wrote:
> Now I have few questions.
> 
> - If we exit to user space asynchronously (using kvm request), what debug
>   information is in there which tells user which address is bad. I admit
>   that even above trace does not seem to be telling me directly which
>   address (HVA?) is bad.
> 
>   But if I take a crash dump of guest, using above information I should
>   be able to get to GPA which is problematic. And looking at /proc/iomem
>   it should also tell which device this memory region is in.
> 
>   Also using this crash dump one should be able to walk through virtiofs data
>   structures and figure out which file and what offset with-in file does
>   it belong to. Now one can look at filesystem on host and see file got
>   truncated and it will become obvious it can't be faulted in. And then
>   one can continue to debug that how did we arrive here.
> 
> But if we don't exit to user space synchronously, Only relevant
> information we seem to have is -EFAULT. Apart from that, how does one
> figure out what address is bad, or who tried to access it. Or which
> file/offset does it belong to etc.
>
> I agree that problem is not necessarily in guest code. But by exiting
> synchronously, it gives enough information that one can use crash
> dump to get to bottom of the issue. If we exit to user space
> asynchronously, all this information will be lost and it might make
> it very hard to figure out (if not impossible), what's going on.

If we want userspace to be able to do something useful, KVM should explicitly
inform userspace about the error, userspace shouldn't simply assume that
-EFAULT means a HVA->PFN lookup failed.  Userspace also shouldn't have to
query guest state to handle the error, as that won't work for protected guests
guests like SEV-ES and TDX.

I can think of two options:

  1. Send a signal, a la kvm_send_hwpoison_signal().

  2. Add a userspace exit reason along with a new entry in the run struct,
     e.g. that provides the bad GPA, HVA, possibly permissions, etc...

> > > > > > To fully handle the situation, the guest needs to remove the bad page from
> > > > > > its memory pool.  Once the page is offlined, the guest kernel's error
> > > > > > handling will kick in when a task accesses the bad page (or nothing ever
> > > > > > touches the bad page again and everyone is happy).
> > > > > 
> > > > > This is not really a case of bad page as such. It is more of a page
> > > > > gone missing/trucated. And no new user can map it. We just need to
> > > > > worry about existing users who already have it mapped.
> > > > 
> > > > What do you mean by "no new user can map it"?  Are you talking about guest
> > > > tasks or host tasks?  If guest tasks, how would the guest know the page is
> > > > missing and thus prevent mapping the non-existent page?
> > > 
> > > If a new task wants mmap(), it will send a request to virtiofsd/qemu
> > > on host. If file has been truncated, then mapping beyond file size
> > > will fail and process will get error.  So they will not be able to
> > > map a page which has been truncated.
> > 
> > Ah.  Is there anything that prevents the notification side of things from
> > being handled purely within the virtiofs layer?  E.g. host notifies the guest
> > that a file got truncated, virtiofs driver in the guest invokes a kernel API
> > to remove the page(s).
> 
> virtiofsd notifications can help a bit but not in all cases. For example,
> If file got truncated and guest kernel accesses it immidiately after that,
> (before notification arrives), it will hang and notification will not
> be able to do much.
> 
> So while notification might be nice to have, but we still will need some
> sort of error reporting from kvm.

And I'm in full agreement with that.  What I'm saying is that resolving the
infinite loop is a _bug fix_ and is completely orthogonal to adding a new
mechanism to handle the file truncation scenario.

