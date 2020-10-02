Date: Fri, 2 Oct 2020 11:30:37 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201002183036.GB24460@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
	<20200929043700.GL31514@linux.intel.com>
	<20201001215508.GD3522@redhat.com>
	<20201001223320.GI7474@linux.intel.com>
	<20201002153854.GC3119@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201002153854.GC3119@redhat.com>
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

On Fri, Oct 02, 2020 at 11:38:54AM -0400, Vivek Goyal wrote:
> On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> > Alternatively, what about adding a new KVM request type to handle this?
> > E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> > request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> > to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> > simply get if error_gfn is "valid", i.e. there's a pending request.
> 
> Sorry, I did not understand the above proposal. Can you please elaborate
> a bit more. Part of it is that I don't know much about KVM requests.
> Looking at the code it looks like that main loop is parsing if some
> kvm request is pending and executing that action.
> 
> Don't we want to make sure that we exit to user space when guest retries
> error gfn access again.

> In this case once we get -EFAULT, we will still inject page_ready into
> guest. And then either same process or a different process might run. 
> 
> So when exactly code raises a kvm request. If I raise it right when
> I get -EFAULT, then kvm will exit to user space upon next entry
> time. But there is no guarantee guest vcpu is running the process which
> actually accessed the error gfn. And that probably means that register
> state of cpu does not mean much and one can not easily figure out
> which task tried to access the bad memory and when.
> 
> That's why we prepare a list of error gfn and only exit to user space
> when error_gfn access is retried so that guest vcpu context is correct.
> 
> What am I missing?

I don't think it's necessary to provide userspace with the register state of
the guest task that hit the bad page.  Other than debugging, I don't see how
userspace can do anything useful which such information.

Even if you want to inject an event of some form into the guest, having the
correct context for the event itself is not required.  IMO it's perfectly
reasonable for such an event to be asynchronous.

IIUC, your end goal is to be able to gracefully handle DAX file truncation.
Simply killing the guest task that hit the bad page isn't sufficient, as
nothing prevents a future task from accessing the same bad page.  To fully
handle the situation, the guest needs to remove the bad page from its memory
pool.  Once the page is offlined, the guest kernel's error handling will
kick in when a task accesses the bad page (or nothing ever touches the bad
page again and everyone is happy).

Note, I'm not necessarily suggesting that QEMU piggyback its #MC injection
to handle this, but I suspect the resulting behavior will look quite similar,
e.g. notify the virtiofs driver in the guest, which does some magic to take
the offending region offline, and then guest tasks get SIGBUS or whatever.

I also don't think it's KVM's responsibility to _directly_ handle such a
scenario.  As I said in an earlier version, KVM can't possibly know _why_ a
page fault came back with -EFAULT, only userspace can connect the dots of
GPA -> HVA -> vm_area_struct -> file -> inject event.  KVM definitely should
exit to userspace on the -EFAULT instead of hanging the guest, but that can
be done via a new request, as suggested.

