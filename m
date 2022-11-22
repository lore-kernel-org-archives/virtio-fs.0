Return-Path: <armbru@redhat.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Tue, 22 Nov 2022 14:49:17 +0100
Message-Id: <20221122134917.1217307-3-armbru@redhat.com>
In-Reply-To: <20221122134917.1217307-1-armbru@redhat.com>
References: <20221122134917.1217307-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/2] block/vmdk: Simplify vmdk_co_create() to
 return directly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: groug@kaod.org, qemu_oss@crudebyte.com, Alistair.Francis@wdc.com, bin.meng@windriver.com, palmer@dabbelt.com, marcandre.lureau@redhat.com, pbonzini@redhat.com, yuval.shaia.ml@gmail.com, marcel.apfelbaum@gmail.com, mst@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pavel.dovgaluk@ispras.ru, alex.bennee@linaro.org, peterx@redhat.com, david@redhat.com, philmd@linaro.org, mrolnik@gmail.com, gaosong@loongson.cn, yangxiaojuan@loongson.cn, aurelien@aurel32.net, jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com, berrange@redhat.com, thuth@redhat.com, lvivier@redhat.com, suhang16@mails.ucas.ac.cn, chen.zhang@intel.com, lizhijian@fujitsu.com, stefanha@redhat.com, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, virtio-fs@redhat.com, Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org

Cc: Fam Zheng <fam@euphon.net>
Cc: Kevin Wolf <kwolf@redhat.com>
Cc: Hanna Reitz <hreitz@redhat.com>
Cc: qemu-block@nongnu.org
Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 block/vmdk.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/block/vmdk.c b/block/vmdk.c
index 26376352b9..bac3d8db50 100644
--- a/block/vmdk.c
+++ b/block/vmdk.c
@@ -2821,7 +2821,6 @@ static BlockBackend *vmdk_co_create_cb(int64_t size, int idx,
 static int coroutine_fn vmdk_co_create(BlockdevCreateOptions *create_options,
                                        Error **errp)
 {
-    int ret;
     BlockdevCreateOptionsVmdk *opts;
 
     opts = &create_options->u.vmdk;
@@ -2829,24 +2828,19 @@ static int coroutine_fn vmdk_co_create(BlockdevCreateOptions *create_options,
     /* Validate options */
     if (!QEMU_IS_ALIGNED(opts->size, BDRV_SECTOR_SIZE)) {
         error_setg(errp, "Image size must be a multiple of 512 bytes");
-        ret = -EINVAL;
-        goto out;
+        return -EINVAL;
     }
 
-    ret = vmdk_co_do_create(opts->size,
-                            opts->subformat,
-                            opts->adapter_type,
-                            opts->backing_file,
-                            opts->hwversion,
-                            opts->toolsversion,
-                            false,
-                            opts->zeroed_grain,
-                            vmdk_co_create_cb,
-                            opts, errp);
-    return ret;
-
-out:
-    return ret;
+    return vmdk_co_do_create(opts->size,
+                             opts->subformat,
+                             opts->adapter_type,
+                             opts->backing_file,
+                             opts->hwversion,
+                             opts->toolsversion,
+                             false,
+                             opts->zeroed_grain,
+                             vmdk_co_create_cb,
+                             opts, errp);
 }
 
 static void vmdk_close(BlockDriverState *bs)
-- 
2.37.3

