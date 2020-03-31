From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 31 Mar 2020 15:40:10 -0400
Message-Id: <20200331194011.24834-4-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] kvm: Always get async page notifications
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

Right now, we seem to get async pf related notifications only if guest
is in user mode, or if it is in kernel mode and CONFIG_PREEMPTION is
enabled. I think idea is that if CONFIG_PREEMPTION is enabled then it
gives us opportunity to schedule something else if page is not ready.

If KVM_ASYNC_PF_SEND_ALWAYS is not set, then host will not send
notifications of PAGE_NOT_PRESENT/PAGE_READY. Instead once page
has been installed guest will run.

Now we are adding capability to report errors as part of async pf
protocol. That means we need async pf related notifications so that
we can make a task wait and when error is reported, we can either
send SIGBUS to user process or search through exception tables for
possible error handler.

Hence enable async pf notifications always. Not sure if this will
have noticieable performance implication though.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/kvm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 42d17e8c0135..97753a648133 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -336,9 +336,7 @@ static void kvm_guest_cpu_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
 		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
-#ifdef CONFIG_PREEMPTION
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
-#endif
 		pa |= KVM_ASYNC_PF_ENABLED;
 
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
-- 
2.25.1

