From: Vitaly Kuznetsov <vkuznets@redhat.com>
In-Reply-To: <20200709125442.GA150543@redhat.com>
References: <20200709125442.GA150543@redhat.com>
Date: Fri, 17 Jul 2020 12:14:00 +0200
Message-ID: <87365qsb2v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Page fault error handling behavior in kvm seems little inconsistent when
> page fault reports error. If we are doing fault synchronously
> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> exit to user space and qemu reports error, "error: kvm run failed Bad address".
>
> But if we are doing async page fault, then async_pf_execute() will simply
> ignore the error reported by get_user_pages_remote() or
> by kvm_mmu_do_page_fault(). It is assumed that page fault was successful
> and either a page ready event is injected in guest or guest is brought
> out of artificial halt state and run again. In both the cases when guest
> retries the instruction, it takes exit again as page fault was not
> successful in previous attempt. And then this infinite loop continues
> forever.
>
> Trying fault in a loop will make sense if error is temporary and will
> be resolved on retry. But I don't see any intention in the code to
> determine if error is temporary or not.  Whether to do fault synchronously
> or asynchronously, depends on so many variables but none of the varibales
> is whether error is temporary or not. (kvm_can_do_async_pf()).
>
> And that makes it very inconsistent or unpredictable to figure out whether
> kvm will exit to qemu with error or it will just retry and go into an
> infinite loop.
>
> This patch tries to make this behavior consistent. That is instead of
> getting into infinite loop of retrying page fault, exit to user space
> and stop VM if page fault error happens.
>
> In future this can be improved by injecting errors into guest. As of
> now we don't have any race free method to inject errors in guest.
>
> When page fault error happens in async path save that pfn and when next
> time guest retries, do a sync fault instead of async fault. So that if error
> is encountered, we exit to qemu and avoid infinite loop.
>
> We maintain a cache of error gfns and force sync fault if a gfn is
> found in cache of error gfn. There is a small possibility that we
> miss an error gfn (as it got overwritten by a new error gfn). But
> its just a hint and sooner or later some error pfn will match
> and we will force sync fault and exit to user space.
>
> Change from v2:
> - Fixed a warning by converting kvm_find_error_gfn() static.
>
> Change from v1:
> - Maintain a cache of error gfns, instead of single gfn. (Vitaly)
>

Sorry for the delayed reply, please find some nitpicks below.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 61 +++++++++++++++++++++++++++++++--
>  4 files changed, 62 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..e6f8d3f1a377 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -137,6 +137,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  #define KVM_NR_VAR_MTRR 8
>  
>  #define ASYNC_PF_PER_VCPU 64
> +#define ERROR_GFN_PER_VCPU 64
>  
>  enum kvm_reg {
>  	VCPU_REGS_RAX = __VCPU_REGS_RAX,
> @@ -778,6 +779,7 @@ struct kvm_vcpu_arch {
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
>  		bool pageready_pending;
> +		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
>  	} apf;
>  
>  	/* OSVW MSRs (AMD only) */
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 444bb9c54548..d0a2a12c7bb6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
>  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
>  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  			     bool accessed_dirty, gpa_t new_eptp);
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  				u64 fault_address, char *insn, int insn_len);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d6a0ae7800c..a0e6283e872d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {

gpa_to_gfn() ?

>  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
>  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..c4d4dab3ccde 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
>  		vcpu->arch.apf.gfns[i] = ~0;
>  }
>  
> +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> +		vcpu->arch.apf.error_gfns[i] = ~0;

Nit: I see this is already present in kvm_async_pf_hash_reset() but what
about defining 

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a7580f69dda0..9144fde2550e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -38,6 +38,7 @@ typedef u64            gpa_t;
 typedef u64            gfn_t;
 
 #define GPA_INVALID    (~(gpa_t)0)
+#define GFN_INVALID    (~(gfn_t)0)
 
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;

and using it instead?

> +}
> +
>  static void kvm_on_user_return(struct user_return_notifier *urn)
>  {
>  	unsigned slot;
> @@ -9484,6 +9491,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>  
>  	kvm_async_pf_hash_reset(vcpu);
> +	kvm_error_gfn_hash_reset(vcpu);
>  	kvm_pmu_init(vcpu);
>  
>  	vcpu->arch.pending_external_vector = -1;
> @@ -9608,6 +9616,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	kvm_clear_async_pf_completion_queue(vcpu);
>  	kvm_async_pf_hash_reset(vcpu);
> +	kvm_error_gfn_hash_reset(vcpu);
>  	vcpu->arch.apf.halted = false;
>  
>  	if (kvm_mpx_supported()) {
> @@ -10369,6 +10378,41 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_rflags);
>  
> +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> +{
> +	BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> +
> +	return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> +}
> +
> +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	/*
> +	 * Overwrite the previous gfn. This is just a hint to do
> +	 * sync page fault.
> +	 */
> +	vcpu->arch.apf.error_gfns[key] = gfn;
> +}
> +
> +static void kvm_del_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	if (WARN_ON_ONCE(vcpu->arch.apf.error_gfns[key] != gfn))
> +		return;
> +
> +	vcpu->arch.apf.error_gfns[key] = ~0;
> +}
> +
> +static bool kvm_find_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	return vcpu->arch.apf.error_gfns[key] == gfn;
> +}

These two functions kvm_del_error_gfn()/kvm_find_error_gfn() come in
pair and the only usage seems to be

 if (kvm_find_error_gfn())
    kvm_del_error_gfn();

what if we replace it with a single kvm_find_and_remove_error_gfn() and
drop the WARN_ON_ONCE()?

> +
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
> @@ -10385,7 +10429,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
>  		return;
>  
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	if (r < 0)
> +		kvm_add_error_gfn(vcpu, gpa_to_gfn(work->cr2_or_gpa));
>  }
>  
>  static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> @@ -10495,7 +10541,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
> @@ -10509,7 +10555,16 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_arch_interrupt_allowed(vcpu);
> +	if (!kvm_arch_interrupt_allowed(vcpu))
> +		return false;
> +
> +	/* Found gfn in error gfn cache. Force sync fault */
> +	if (kvm_find_error_gfn(vcpu, gfn)) {
> +		kvm_del_error_gfn(vcpu, gfn);
> +		return false;
> +	}
> +
> +	return true;
>  }
>  
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,

-- 
Vitaly

