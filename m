From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 31 Mar 2020 15:40:11 -0400
Message-Id: <20200331194011.24834-5-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] kvm, x86,
	async_pf: Search exception tables in case of error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: aarcange@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com, dhildenb@redhat.com, vgoyal@redhat.com

If an error happens during page fault and it was kernel code executing
at the time of fault, search exception tables and jump to corresponding
handler, if there is one.

This is useful when virtiofs DAX code is doing memcpy and page fault
returns an error because corresponding page has been truncated on
host. In that case, we want to return that error to guest user space,
instead of retrying infinitely.

This does not take care of nested KVM. Exit into L1 does not have notion
of passing "struct pt_regs" to handler. That needs to be fixed first.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |  5 +++--
 arch/x86/kernel/kvm.c           | 24 ++++++++++++++++++------
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 2d464e470325..2c9e7c852b40 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -88,7 +88,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
+void kvm_async_pf_task_wait(u32 token, int interrupt_kernel,
+			    struct pt_regs *regs, unsigned long error_code);
 void kvm_async_pf_task_wake(u32 token, bool is_err, unsigned long addr);
 void kvm_read_and_reset_pf_reason(struct kvm_apf_reason *reason);
 extern void kvm_disable_steal_time(void);
@@ -103,7 +104,7 @@ static inline void kvm_spinlock_init(void)
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
 #else /* CONFIG_KVM_GUEST */
-#define kvm_async_pf_task_wait(T, I) do {} while(0)
+#define kvm_async_pf_task_wait(T, I, R, E) do {} while(0)
 #define kvm_async_pf_task_wake(T, I, A) do {} while(0)
 
 static inline bool kvm_para_available(void)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 97753a648133..387ef0aa323b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -98,17 +98,23 @@ static struct kvm_task_sleep_node *_find_apf_task(struct kvm_task_sleep_head *b,
 	return NULL;
 }
 
-static void handle_async_pf_error(int user_mode, unsigned long fault_addr)
+static inline void handle_async_pf_error(int user_mode,
+					 unsigned long fault_addr,
+					 struct pt_regs *regs,
+					 unsigned long error_code)
 {
 	if (user_mode)
 		force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)fault_addr);
+	else
+		fixup_exception(regs, X86_TRAP_PF, error_code, fault_addr);
 }
 
 /*
  * @interrupt_kernel: Is this called from a routine which interrupts the kernel
  * 		      (other than user space)?
  */
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel)
+void kvm_async_pf_task_wait(u32 token, int interrupt_kernel,
+			    struct pt_regs *regs, unsigned long error_code)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
@@ -120,13 +126,17 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_kernel)
 	raw_spin_lock(&b->lock);
 	e = _find_apf_task(b, token);
 	if (e) {
+		bool is_err = e->is_err;
+		unsigned long fault_addr = e->fault_addr;
+
 		/* dummy entry exist -> wake up was delivered ahead of PF */
-		if (e->is_err)
-			handle_async_pf_error(!interrupt_kernel, e->fault_addr);
 		hlist_del(&e->link);
 		kfree(e);
 		raw_spin_unlock(&b->lock);
 
+		if (is_err)
+			handle_async_pf_error(!interrupt_kernel, fault_addr,
+					      regs, error_code);
 		rcu_irq_exit();
 		return;
 	}
@@ -167,7 +177,8 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_kernel)
 		finish_swait(&n.wq, &wait);
 
 	if (n.is_err)
-		handle_async_pf_error(!interrupt_kernel, n.fault_addr);
+		handle_async_pf_error(!interrupt_kernel, n.fault_addr, regs,
+				      error_code);
 
 	rcu_irq_exit();
 	return;
@@ -273,7 +284,8 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned lon
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		kvm_async_pf_task_wait((u32)address, !user_mode(regs));
+		kvm_async_pf_task_wait((u32)address, !user_mode(regs), regs,
+				       error_code);
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e3337c5f73e0..a9b707fb5861 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4207,7 +4207,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		vcpu->arch.apf.host_apf_reason.reason = 0;
 		local_irq_disable();
-		kvm_async_pf_task_wait(fault_address, 0);
+		kvm_async_pf_task_wait(fault_address, 0, NULL, 0);
 		local_irq_enable();
 		break;
 	case KVM_PV_REASON_PAGE_READY:
-- 
2.25.1

