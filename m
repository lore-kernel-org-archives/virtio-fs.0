Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:00 +0100
Message-Id: <20221205095228.1314-24-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 23/51] target/i386: Always completely
 initialize TranslateFault
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Daniel Hoffman <dhoff749@gmail.com>

From: Richard Henderson <richard.henderson@linaro.org>

In get_physical_address, the canonical address check failed to
set TranslateFault.stage2, which resulted in an uninitialized
read from the struct when reporting the fault in x86_cpu_tlb_fill.

Adjust all error paths to use structure assignment so that the
entire struct is always initialized.

Reported-by: Daniel Hoffman <dhoff749@gmail.com>
Fixes: 9bbcf372193a ("target/i386: Reorg GET_HPHYS")
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20221201074522.178498-1-richard.henderson@linaro.org>
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1324
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 target/i386/tcg/sysemu/excp_helper.c | 34 ++++++++++++++++------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/target/i386/tcg/sysemu/excp_helper.c b/target/i386/tcg/sysemu/excp_helper.c
index 405a5d414a..55bd1194d3 100644
--- a/target/i386/tcg/sysemu/excp_helper.c
+++ b/target/i386/tcg/sysemu/excp_helper.c
@@ -71,10 +71,11 @@ static bool ptw_translate(PTETranslate *inout, hwaddr addr)
         TranslateFault *err = inout->err;
 
         assert(inout->ptw_idx == MMU_NESTED_IDX);
-        err->exception_index = 0; /* unused */
-        err->error_code = inout->env->error_code;
-        err->cr2 = addr;
-        err->stage2 = S2_GPT;
+        *err = (TranslateFault){
+            .error_code = inout->env->error_code,
+            .cr2 = addr,
+            .stage2 = S2_GPT,
+        };
         return false;
     }
     return true;
@@ -431,10 +432,11 @@ do_check_protect_pse36:
                                   MMU_NESTED_IDX, true,
                                   &pte_trans.haddr, &full, 0);
         if (unlikely(flags & TLB_INVALID_MASK)) {
-            err->exception_index = 0; /* unused */
-            err->error_code = env->error_code;
-            err->cr2 = paddr;
-            err->stage2 = S2_GPA;
+            *err = (TranslateFault){
+                .error_code = env->error_code,
+                .cr2 = paddr,
+                .stage2 = S2_GPA,
+            };
             return false;
         }
 
@@ -494,10 +496,11 @@ do_check_protect_pse36:
         }
         break;
     }
-    err->exception_index = EXCP0E_PAGE;
-    err->error_code = error_code;
-    err->cr2 = addr;
-    err->stage2 = S2_NONE;
+    *err = (TranslateFault){
+        .exception_index = EXCP0E_PAGE,
+        .error_code = error_code,
+        .cr2 = addr,
+    };
     return false;
 }
 
@@ -564,9 +567,10 @@ static bool get_physical_address(CPUX86State *env, vaddr addr,
                 int shift = in.pg_mode & PG_MODE_LA57 ? 56 : 47;
                 int64_t sext = (int64_t)addr >> shift;
                 if (sext != 0 && sext != -1) {
-                    err->exception_index = EXCP0D_GPF;
-                    err->error_code = 0;
-                    err->cr2 = addr;
+                    *err = (TranslateFault){
+                        .exception_index = EXCP0D_GPF,
+                        .cr2 = addr,
+                    };
                     return false;
                 }
             }
-- 
2.38.1

