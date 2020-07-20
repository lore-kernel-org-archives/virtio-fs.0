Date: Mon, 20 Jul 2020 13:49:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200720174916.GE502563@redhat.com>
References: <20200709125442.GA150543@redhat.com>
	<87365qsb2v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87365qsb2v.fsf@vitty.brq.redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3] kvm,
 x86: Exit to user space in case of page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org

On Fri, Jul 17, 2020 at 12:14:00PM +0200, Vitaly Kuznetsov wrote:

[..]
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6d6a0ae7800c..a0e6283e872d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> >  	if (!async)
> >  		return false; /* *pfn has correct page already */
> >  
> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
> 
> gpa_to_gfn() ?

Will do. I forgot to make this change since last feedback.

> 
> >  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
> >  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
> >  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 88c593f83b28..c4d4dab3ccde 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.apf.gfns[i] = ~0;
> >  }
> >  
> > +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> > +{
> > +	int i;
> > +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> > +		vcpu->arch.apf.error_gfns[i] = ~0;
> 
> Nit: I see this is already present in kvm_async_pf_hash_reset() but what
> about defining 
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index a7580f69dda0..9144fde2550e 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -38,6 +38,7 @@ typedef u64            gpa_t;
>  typedef u64            gfn_t;
>  
>  #define GPA_INVALID    (~(gpa_t)0)
> +#define GFN_INVALID    (~(gfn_t)0)

Will do.

[..]
> > +static void kvm_del_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > +
> > +	if (WARN_ON_ONCE(vcpu->arch.apf.error_gfns[key] != gfn))
> > +		return;
> > +
> > +	vcpu->arch.apf.error_gfns[key] = ~0;
> > +}
> > +
> > +static bool kvm_find_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > +
> > +	return vcpu->arch.apf.error_gfns[key] == gfn;
> > +}
> 
> These two functions kvm_del_error_gfn()/kvm_find_error_gfn() come in
> pair and the only usage seems to be
> 
>  if (kvm_find_error_gfn())
>     kvm_del_error_gfn();
> 
> what if we replace it with a single kvm_find_and_remove_error_gfn() and
> drop the WARN_ON_ONCE()?

Ok, I am fine with this as well. Will do.

Thanks
Vivek

