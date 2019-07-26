From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 26 Jul 2019 11:58:36 -0400
Message-Id: <20190726155837.29155-2-vgoyal@redhat.com>
In-Reply-To: <20190726155837.29155-1-vgoyal@redhat.com>
References: <20190726155837.29155-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: During setup mapping,
	open file O_RDWR only if needed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

As of now we always open file O_RDWR (even if writable mappings are not
required). This leads to copy up of file if file is backed by overlayfs
and hence nullying advantages of overlayfs.

So open file O_RDONLY if writable mappings are not required. Open O_RDWR
if writable mappings are needed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_lowlevel.c  |  5 +++--
 contrib/virtiofsd/passthrough_ll.c | 17 +++++++----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 8adc4b1ab8..2ed894563b 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1891,8 +1891,9 @@ static void do_setupmapping(fuse_req_t req, fuse_ino_t nodeid,
         // for now just use O_ flags
         uint64_t genflags;
 
-        genflags = 0;
-        genflags |= (arg->flags & FUSE_SETUPMAPPING_FLAG_WRITE) ? O_WRONLY : 0;
+	genflags = O_RDONLY;
+	if (arg->flags & FUSE_SETUPMAPPING_FLAG_WRITE)
+		genflags = O_RDWR;
 
 	if (req->se->op.setupmapping) {
 		/*
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 9ae1381618..c09c46a7e5 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2197,15 +2197,17 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
         VhostUserFSSlaveMsg msg = { 0 };
         uint64_t vhu_flags;
 	char *buf;
+	bool writable = flags & O_RDWR;
 
 	if (lo_debug(req))
-		fuse_debug("lo_setupmapping(ino=%" PRIu64 ", fi=0x%p)\n", ino,
-			   (void *)fi);
+		fuse_debug("lo_setupmapping(ino=%" PRIu64 ", fi=0x%p,"
+			   " foffset=%" PRIu64 ", len=%" PRIu64
+			   ", moffset=%" PRIu64 ", flags=%" PRIu64 ")\n", ino,
+			   (void *)fi, foffset, len, moffset, flags);
 
         vhu_flags = VHOST_USER_FS_FLAG_MAP_R;
-        if (flags & O_WRONLY) {
+	if (writable)
                 vhu_flags |= VHOST_USER_FS_FLAG_MAP_W;
-        }
 
 	msg.fd_offset[0] = foffset;
 	msg.len[0] = len;
@@ -2219,15 +2221,10 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
 		if (res == -1)
 			return (void) fuse_reply_err(req, errno);
 
-		/*
-		 * TODO: O_RDWR might not be allowed if file is read only or
-		 * write only. Fix it.
-		 */
-		fd = openat(lo->proc_self_fd, buf, O_RDWR);
+		fd = openat(lo->proc_self_fd, buf, flags);
 		free(buf);
 		if (fd == -1)
 			return (void) fuse_reply_err(req, errno);
-
 	}
 
         if (fuse_virtio_map(req, &msg, fd)) {
-- 
2.17.2

