Date: Tue, 6 Oct 2020 13:28:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201006172832.GF5306@redhat.com>
References: <20201006134629.GB5306@redhat.com>
	<877ds38n6r.fsf@vitty.brq.redhat.com>
	<20201006141501.GC5306@redhat.com>
	<874kn78l2z.fsf@vitty.brq.redhat.com>
	<20201006150817.GD5306@redhat.com>
	<871rib8ji1.fsf@vitty.brq.redhat.com>
	<20201006161200.GB17610@linux.intel.com>
	<87y2kj71gj.fsf@vitty.brq.redhat.com>
	<20201006171704.GC17610@linux.intel.com>
	<20201006172148.GI3000@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006172148.GI3000@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Sean Christopherson <sean.j.christopherson@intel.com>, virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>

On Tue, Oct 06, 2020 at 06:21:48PM +0100, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> > On Tue, Oct 06, 2020 at 06:39:56PM +0200, Vitaly Kuznetsov wrote:
> > > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > > 
> > > > On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> > > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > > >> > So you will have to report token (along with -EFAULT) to user space. So this
> > > >> > is basically the 3rd proposal which is extension of kvm API and will
> > > >> > report say HVA/GFN also to user space along with -EFAULT.
> > > >> 
> > > >> Right, I meant to say that guest kernel has full register state of the
> > > >> userspace process which caused APF to get queued and instead of trying
> > > >> to extract it in KVM and pass to userspace in case of a (later) failure
> > > >> we limit KVM api change to contain token or GFN only and somehow keep
> > > >> the rest in the guest. This should help with TDX/SEV-ES.
> > > >
> > > > Whatever gets reported to userspace should be identical with and without
> > > > async page faults, i.e. it definitely shouldn't have token information.
> > > >
> > > 
> > > Oh, right, when the error gets reported synchronously guest's kernel is
> > > not yet aware of the issue so it won't be possible to find anything in
> > > its kdump if userspace decides to crash it immediately. The register
> > > state (if available) will be actual though.
> > > 
> > > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > > into the guest is not an option.  
> > > 
> > > Not even #MC? So sad :-)
> > 
> > Heh, #MC isn't allowed either, yet...
> > 
> > > > Nor do I think that's "correct" behavior (see everyone's objections to
> > > > using #PF for APF fixed).  I.e. the event should probably be an IRQ.
> > > 
> > > I recall Paolo objected against making APF 'page not present' into in
> > > interrupt as it will require some very special handling to make sure it
> > > gets injected (and handled) immediately but I'm not really sure how big
> > > the hack is going to be, maybe in the light of TDX/SEV-ES it's worth a
> > > try.
> > 
> > This shouldn't have anything to do with APF.  Again, the event injection is
> > needed even in the synchronous case as the file truncation in the host can
> > affect existing mappings in the guest.
> > 
> > I don't know that the mechanism needs to be virtiofs specific or if there can
> > be a more generic "these PFNs have disappeared", but it's most definitely
> > orthogonal to APF.
> 
> There are other cases we get 'these PFNs have disappeared' other than
> virtiofs;  the classic is when people back the guest using a tmpfs that
> then runs out of room.

I also played with nvdimm driver where device was backed a file on host.
If I truncate that file, we face similar issues.

https://lore.kernel.org/kvm/20200616214847.24482-1-vgoyal@redhat.com/

I think any resource which can be backed by a file on host, can
potentially run into this issue if file is truncated.
(if guest can do load/store on these pages directly). 

Thanks
Vivek

