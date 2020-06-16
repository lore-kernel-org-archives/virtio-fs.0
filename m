From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jun 2020 17:48:47 -0400
Message-Id: <20200616214847.24482-4-vgoyal@redhat.com>
In-Reply-To: <20200616214847.24482-1-vgoyal@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] kvm,
	async_pf: Use FOLL_WRITE only for write faults
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wanpengli@tencent.com, miklos@szeredi.hu, sean.j.christopherson@intel.com, virtio-fs@redhat.com, pbonzini@redhat.com, vkuznets@redhat.com, vgoyal@redhat.com

async_pf_execute() calls get_user_pages_remote() and uses FOLL_WRITE
always. It does not matter whether fault happened due to read/write.

This creates issues if vma is mapped for reading and does not have
VM_WRITE set and check_vma_flags() fails in __get_user_pages() and
get_user_pages_remote() returns -EFAULT.

So far this was not an issue, as we don't care about return code
from get_user_pages_remote(). But soon we want to look at this error
code and if file got truncated and page can't be faulted in, we want
to inject error in guest and let guest take appropriate action (Either
send SIGBUS to guest process or do exception table handling or possibly
die).

Hence, we don't want to get -EFAULT erroneously. Pass FOLL_WRITE only
if it is write fault.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 7 ++++---
 include/linux/kvm_host.h | 4 +++-
 virt/kvm/async_pf.c      | 9 +++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 634182bb07c7..15969c4c8925 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4046,7 +4046,7 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 }
 
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				   gfn_t gfn)
+				   gfn_t gfn, bool write)
 {
 	struct kvm_arch_async_pf arch;
 
@@ -4056,7 +4056,8 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
-				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch,
+				  write);
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
@@ -4084,7 +4085,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return true;
-		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
+		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn, write))
 			return true;
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8558334b184..a7c3999a7374 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -208,12 +208,14 @@ struct kvm_async_pf {
 	bool   wakeup_all;
 	bool notpresent_injected;
 	int error_code;
+	bool write;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-		       unsigned long hva, struct kvm_arch_async_pf *arch);
+		       unsigned long hva, struct kvm_arch_async_pf *arch,
+		       bool write);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 6b30374a4de1..1d2dc267f9b8 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -53,6 +53,7 @@ static void async_pf_execute(struct work_struct *work)
 	int locked = 1;
 	bool first;
 	long ret;
+	unsigned int gup_flags = 0;
 
 	might_sleep();
 
@@ -61,8 +62,10 @@ static void async_pf_execute(struct work_struct *work)
 	 * mm and might be done in another context, so we must
 	 * access remotely.
 	 */
+	if (apf->write)
+		gup_flags = FOLL_WRITE;
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
+	ret = get_user_pages_remote(NULL, mm, addr, 1, gup_flags, NULL, NULL,
 				    &locked);
 	if (locked)
 		up_read(&mm->mmap_sem);
@@ -161,7 +164,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 }
 
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-		       unsigned long hva, struct kvm_arch_async_pf *arch)
+		       unsigned long hva, struct kvm_arch_async_pf *arch,
+		       bool write)
 {
 	struct kvm_async_pf *work;
 
@@ -186,6 +190,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;
+	work->write = write;
 	mmget(work->mm);
 	kvm_get_kvm(work->vcpu->kvm);
 
-- 
2.25.4

