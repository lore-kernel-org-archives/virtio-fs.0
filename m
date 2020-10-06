Date: Tue, 6 Oct 2020 11:08:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201006150817.GD5306@redhat.com>
References: <20201002192734.GD3119@redhat.com>
	<20201002194517.GD24460@linux.intel.com>
	<20201002200214.GB10232@redhat.com>
	<20201002211314.GE24460@linux.intel.com>
	<20201005153318.GA4302@redhat.com>
	<20201005161620.GC11938@linux.intel.com>
	<20201006134629.GB5306@redhat.com>
	<877ds38n6r.fsf@vitty.brq.redhat.com>
	<20201006141501.GC5306@redhat.com>
	<874kn78l2z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kn78l2z.fsf@vitty.brq.redhat.com>
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
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, Sean Christopherson <sean.j.christopherson@intel.com>, linux-kernel@vger.kernel.org

On Tue, Oct 06, 2020 at 04:50:44PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Oct 06, 2020 at 04:05:16PM +0200, Vitaly Kuznetsov wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >> 
> >> > A. Just exit to user space with -EFAULT (using kvm request) and don't
> >> >    wait for the accessing task to run on vcpu again. 
> >> 
> >> What if we also save the required information (RIP, GFN, ...) in the
> >> guest along with the APF token
> >
> > Can you elaborate a bit more on this. You mean save GFN on stack before
> > it starts waiting for PAGE_READY event?
> 
> When PAGE_NOT_PRESENT event is injected as #PF (for now) in the guest
> kernel gets all the registers of the userspace process (except for CR2
> which is replaced with a token). In case it is not trivial to extract
> accessed GFN from this data we can extend the shared APF structure and
> add it there, KVM has it when it queues APF.
> 
> >
> >> so in case of -EFAULT we can just 'crash'
> >> the guest and the required information can easily be obtained from
> >> kdump? This will solve the debugging problem even for TDX/SEV-ES (if
> >> kdump is possible there).
> >
> > Just saving additional info in guest will not help because there might
> > be many tasks waiting and you don't know which GFN is problematic one.
> 
> But KVM knows which token caused the -EFAULT when we exit to userspace
> (and we can pass this information to it) so to debug the situation you
> take this token and then explore the kdump searching for what's
> associated with this exact token.

So you will have to report token (along with -EFAULT) to user space. So this
is basically the 3rd proposal which is extension of kvm API and will
report say HVA/GFN also to user space along with -EFAULT.

Thanks
Vivek

