From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Fri, 20 Mar 2020 07:54:49 +0800
Message-Id: <1584662089-26468-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: print more verbose information when
	bailing out
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

It'd be helpful to know what is the exact value of arg's offset, size
and flags.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index f7eb12c..7375bae 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1226,7 +1226,8 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
         }
 
 	if (fuse_buf_size(pbufv) != arg->size) {
-		fuse_err("fuse: do_write_buf: buffer size doesn't match arg->size\n");
+		fuse_err("fuse: do_write_buf: buffer size %lu doesn't match arg->size %u offset %lu flags %u\n",
+			 fuse_buf_size(pbufv), arg->size, arg->offset, arg->write_flags);
 		fuse_reply_err(req, EIO);
 		return;
 	}
-- 
1.8.3.1


