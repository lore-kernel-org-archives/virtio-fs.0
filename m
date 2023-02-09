Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  9 Feb 2023 10:25:18 -0500
Message-Id: <20230209152520.434183-5-stefanha@redhat.com>
In-Reply-To: <20230209152520.434183-1-stefanha@redhat.com>
References: <20230209152520.434183-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 4/6] qemu-io: use BdrvRequestFlags instead of int
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eric Blake <eblake@redhat.com>

The block layer APIs use BdrvRequestFlags while qemu-io code uses int.
Although the code compiles and runs fine, BdrvRequestFlags is clearer
because it differentiates between other types of flags like bdrv_open()
flags.

This is purely refactoring.

Reviewed-by: Eric Blake <eblake@redhat.com>
Reviewed-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20230207203719.242926-3-stefanha@redhat.com>
---
 qemu-io-cmds.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/qemu-io-cmds.c b/qemu-io-cmds.c
index a061031615..1f60c23ba4 100644
--- a/qemu-io-cmds.c
+++ b/qemu-io-cmds.c
@@ -556,7 +556,7 @@ static int do_pread(BlockBackend *blk, char *buf, int64_t offset,
 }
 
 static int do_pwrite(BlockBackend *blk, char *buf, int64_t offset,
-                     int64_t bytes, int flags, int64_t *total)
+                     int64_t bytes, BdrvRequestFlags flags, int64_t *total)
 {
     int ret;
 
@@ -573,7 +573,8 @@ static int do_pwrite(BlockBackend *blk, char *buf, int64_t offset,
 }
 
 static int do_pwrite_zeroes(BlockBackend *blk, int64_t offset,
-                               int64_t bytes, int flags, int64_t *total)
+                               int64_t bytes, BdrvRequestFlags flags,
+                               int64_t *total)
 {
     int ret = blk_pwrite_zeroes(blk, offset, bytes,
                                 flags | BDRV_REQ_ZERO_WRITE);
@@ -651,7 +652,7 @@ static int do_aio_readv(BlockBackend *blk, QEMUIOVector *qiov,
 }
 
 static int do_aio_writev(BlockBackend *blk, QEMUIOVector *qiov,
-                         int64_t offset, int flags, int *total)
+                         int64_t offset, BdrvRequestFlags flags, int *total)
 {
     int async_ret = NOT_DONE;
 
@@ -1028,7 +1029,7 @@ static int write_f(BlockBackend *blk, int argc, char **argv)
     struct timespec t1, t2;
     bool Cflag = false, qflag = false, bflag = false;
     bool Pflag = false, zflag = false, cflag = false, sflag = false;
-    int flags = 0;
+    BdrvRequestFlags flags = 0;
     int c, cnt, ret;
     char *buf = NULL;
     int64_t offset;
@@ -1229,7 +1230,7 @@ static int writev_f(BlockBackend *blk, int argc, char **argv)
 {
     struct timespec t1, t2;
     bool Cflag = false, qflag = false;
-    int flags = 0;
+    BdrvRequestFlags flags = 0;
     int c, cnt, ret;
     char *buf;
     int64_t offset;
@@ -1544,7 +1545,7 @@ static int aio_write_f(BlockBackend *blk, int argc, char **argv)
     int nr_iov, c;
     int pattern = 0xcd;
     struct aio_ctx *ctx = g_new0(struct aio_ctx, 1);
-    int flags = 0;
+    BdrvRequestFlags flags = 0;
 
     ctx->blk = blk;
     while ((c = getopt(argc, argv, "CfiqP:uz")) != -1) {
-- 
2.39.1

