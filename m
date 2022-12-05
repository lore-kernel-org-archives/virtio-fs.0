Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:47 +0100
Message-Id: <20221205095228.1314-11-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 10/51] target/arm: Set
 TCGCPUOps.restore_state_to_opc for v7m
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Evgeny Ermakov <evgeny.v.ermakov@gmail.com>

From: Evgeny Ermakov <evgeny.v.ermakov@gmail.com>

This setting got missed, breaking v7m.

Fixes: 56c6c98df85c ("target/arm: Convert to tcg_ops restore_state_to_opc")
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1347
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Evgeny Ermakov <evgeny.v.ermakov@gmail.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221129204146.550394-1-richard.henderson@linaro.org>
---
 target/arm/internals.h | 4 ++++
 target/arm/cpu.c       | 6 +++---
 target/arm/cpu_tcg.c   | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index d9121d9ff8..161e42d50f 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -185,6 +185,10 @@ static inline int r14_bank_number(int mode)
 void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu);
 void arm_translate_init(void);
 
+void arm_restore_state_to_opc(CPUState *cs,
+                              const TranslationBlock *tb,
+                              const uint64_t *data);
+
 #ifdef CONFIG_TCG
 void arm_cpu_synchronize_from_tb(CPUState *cs, const TranslationBlock *tb);
 #endif /* CONFIG_TCG */
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a021df9e9e..38d066c294 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -91,9 +91,9 @@ void arm_cpu_synchronize_from_tb(CPUState *cs,
     }
 }
 
-static void arm_restore_state_to_opc(CPUState *cs,
-                                     const TranslationBlock *tb,
-                                     const uint64_t *data)
+void arm_restore_state_to_opc(CPUState *cs,
+                              const TranslationBlock *tb,
+                              const uint64_t *data)
 {
     CPUARMState *env = cs->env_ptr;
 
diff --git a/target/arm/cpu_tcg.c b/target/arm/cpu_tcg.c
index 60ff539fa1..9a2cef7d05 100644
--- a/target/arm/cpu_tcg.c
+++ b/target/arm/cpu_tcg.c
@@ -1035,6 +1035,7 @@ static const struct TCGCPUOps arm_v7m_tcg_ops = {
     .initialize = arm_translate_init,
     .synchronize_from_tb = arm_cpu_synchronize_from_tb,
     .debug_excp_handler = arm_debug_excp_handler,
+    .restore_state_to_opc = arm_restore_state_to_opc,
 
 #ifdef CONFIG_USER_ONLY
     .record_sigsegv = arm_cpu_record_sigsegv,
-- 
2.38.1

