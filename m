Date: Thu, 25 Jun 2020 17:47:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200625214701.GA180786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [RFC PATCH] kvm,
	x86: Exit to user space in case of page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: virtio-fs@redhat.com, pbonzini@redhat.com, vkuznets@redhat.com, sean.j.christopherson@intel.com

Page fault error handling behavior in kvm seems little inconsistent when
page fault reports error. If we are doing fault synchronously
then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
exit to user space and qemu reports error, "error: kvm run failed Bad address".

But if we are doing async page fault, then async_pf_execute() will simply
ignore the error reported by get_user_pages_remote() or
by kvm_mmu_do_page_fault(). It is assumed that page fault was successful
and either a page ready event is injected in guest or guest is brought
out of artificial halt state and run again. In both the cases when guest
retries the instruction, it takes exit again as page fault was not
successful in previous attempt. And then this infinite loop continues
forever.

Trying fault in a loop will make sense if error is temporary and will
be resolved on retry. But I don't see any intention in the code to
determine if error is temporary or not.  Whether to do fault synchronously
or asynchronously, depends on so many variables but none of the varibales
is whether error is temporary or not. (kvm_can_do_async_pf()).

And that makes it very inconsistent or unpredictable to figure out whether
kvm will exit to qemu with error or it will just retry and go into an
infinite loop.

This patch tries to make this behavior consistent. That is instead of
getting into infinite loop of retrying page fault, exit to user space
and stop VM if page fault error happens.

In future this can be improved by injecting errors into guest. As of
now we don't have any race free method to inject errors in guest.

When page fault error happens in async path save that pfn and when next
time guest retries, do a sync fault instead of async fault. So that if error
is encountered, we exit to qemu and avoid infinite loop.

As of now only one error pfn is stored and that means it could be
overwritten before next a retry from guest happens. But this is
just a hint and if we miss it, some other time we will catch it.
If this becomes an issue, we could maintain an array of error
gfn later to help ease the issue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              | 14 +++++++++++---
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b21540..3c0677b9d3d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
+		gfn_t error_gfn;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..d0a2a12c7bb6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
 void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp);
-bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
+bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76817d13c86e..a882a6a9f7a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	if (!async)
 		return false; /* *pfn has correct page already */
 
-	if (!prefault && kvm_can_do_async_pf(vcpu)) {
+	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
 		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b92db412335..a6af7e9831b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10380,7 +10380,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	if (r < 0)
+		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
@@ -10490,7 +10492,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
@@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	 * If interrupts are off we cannot even use an artificial
 	 * halt state.
 	 */
-	return kvm_arch_interrupt_allowed(vcpu);
+	if (!kvm_arch_interrupt_allowed(vcpu))
+		return false;
+
+	if (vcpu->arch.apf.error_gfn == gfn)
+		return false;
+
+	return true;
 }
 
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
-- 
2.25.4

