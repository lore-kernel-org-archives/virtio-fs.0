From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Date: Mon, 13 Jan 2020 17:37:34 +0800
Message-ID: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] vitriofsd/passthrough_ll: Make fallocate()
	work
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

1) Use correct CONFIG_FALLOCATE macro to check if fallocate() is supported.(i.e configure
   script sets CONFIG_FALLOCATE intead of HAVE_FALLOCATE if fallocate() is supported)
2) Avoid 'Bad file descriptor' error by passing correct fd to fallocate().

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 42a3e182f9..a19823caaf 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2313,8 +2313,8 @@ static void lo_fallocate(fuse_req_t req, fuse_ino_t ino, int mode, off_t offset,
     struct lo_data *lo = lo_data(req);
     (void)ino;
 
-#ifdef HAVE_FALLOCATE
-    err = fallocate(fi->fh, mode, offset, length);
+#ifdef CONFIG_FALLOCATE
+    err = fallocate(lo_fi_fd(req, fi), mode, offset, length);
     if (err < 0) {
         err = errno;
     }
-- 
2.21.0




