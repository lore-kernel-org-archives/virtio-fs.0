Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:03 +0100
Message-Id: <20221205095228.1314-27-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 26/51] target/s390x/tcg: Fix and improve the
 SACF instruction
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>

From: Thomas Huth <thuth@redhat.com>

The SET ADDRESS SPACE CONTROL FAST instruction is not privileged, it can be
used from problem space, too. Just the switching to the home address space
is privileged and should still generate a privilege exception. This bug is
e.g. causing programs like Java that use the "getcpu" vdso kernel function
to crash (see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990417#26 ).

While we're at it, also check if DAT is not enabled. In that case the
instruction is supposed to generate a special operation exception.

Resolves: https://gitlab.com/qemu-project/qemu/-/issues/655
Message-Id: <20221201184443.136355-1-thuth@redhat.com>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 target/s390x/tcg/insn-data.h.inc | 2 +-
 target/s390x/tcg/cc_helper.c     | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/s390x/tcg/insn-data.h.inc b/target/s390x/tcg/insn-data.h.inc
index 7e952bdfc8..54d4250c9f 100644
--- a/target/s390x/tcg/insn-data.h.inc
+++ b/target/s390x/tcg/insn-data.h.inc
@@ -1365,7 +1365,7 @@
 /* SERVICE CALL LOGICAL PROCESSOR (PV hypercall) */
     F(0xb220, SERVC,   RRE,   Z,   r1_o, r2_o, 0, 0, servc, 0, IF_PRIV | IF_IO)
 /* SET ADDRESS SPACE CONTROL FAST */
-    F(0xb279, SACF,    S,     Z,   0, a2, 0, 0, sacf, 0, IF_PRIV)
+    C(0xb279, SACF,    S,     Z,   0, a2, 0, 0, sacf, 0)
 /* SET CLOCK */
     F(0xb204, SCK,     S,     Z,   0, m2_64a, 0, 0, sck, 0, IF_PRIV | IF_IO)
 /* SET CLOCK COMPARATOR */
diff --git a/target/s390x/tcg/cc_helper.c b/target/s390x/tcg/cc_helper.c
index b2e8d3d9f5..b36f8cdc8b 100644
--- a/target/s390x/tcg/cc_helper.c
+++ b/target/s390x/tcg/cc_helper.c
@@ -487,6 +487,10 @@ void HELPER(sacf)(CPUS390XState *env, uint64_t a1)
 {
     HELPER_LOG("%s: %16" PRIx64 "\n", __func__, a1);
 
+    if (!(env->psw.mask & PSW_MASK_DAT)) {
+        tcg_s390_program_interrupt(env, PGM_SPECIAL_OP, GETPC());
+    }
+
     switch (a1 & 0xf00) {
     case 0x000:
         env->psw.mask &= ~PSW_MASK_ASC;
@@ -497,6 +501,9 @@ void HELPER(sacf)(CPUS390XState *env, uint64_t a1)
         env->psw.mask |= PSW_ASC_SECONDARY;
         break;
     case 0x300:
+        if ((env->psw.mask & PSW_MASK_PSTATE) != 0) {
+            tcg_s390_program_interrupt(env, PGM_PRIVILEGED, GETPC());
+        }
         env->psw.mask &= ~PSW_MASK_ASC;
         env->psw.mask |= PSW_ASC_HOME;
         break;
-- 
2.38.1

