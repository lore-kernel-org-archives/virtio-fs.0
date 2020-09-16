From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 16 Sep 2020 12:17:36 -0400
Message-Id: <20200916161737.38028-6-vgoyal@redhat.com>
In-Reply-To: <20200916161737.38028-1-vgoyal@redhat.com>
References: <20200916161737.38028-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 5/6] fuse: Add a flag FUSE_OPEN_KILL_PRIV for
	open() request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

With FUSE_HANDLE_KILLPRIV_V2 support, server will need to kill
suid/sgid/security.capability on open(O_TRUNC), if server supports
FUSE_ATOMIC_O_TRUNC.

But server needs to kill suid/sgid only if caller does not have
CAP_FSETID. Given server does not have this information, client
needs to send this info to server.

So add a flag FUSE_OPEN_KILL_PRIV to fuse_open_in request which tells
server to kill suid/sgid(only if group execute is set).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c            |  5 +++++
 include/uapi/linux/fuse.h | 10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e40428f3d0f1..2853f55fd8f7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -42,6 +42,11 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
 	if (!fc->atomic_o_trunc)
 		inarg.flags &= ~O_TRUNC;
+
+	if (fc->handle_killpriv_v2 && (inarg.flags & O_TRUNC) &&
+	    !capable(CAP_FSETID))
+		inarg.open_flags |= FUSE_OPEN_KILL_PRIV;
+
 	args.opcode = opcode;
 	args.nodeid = nodeid;
 	args.in_numargs = 1;
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 7b8da0a2de0d..e20b3ee9d292 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -173,6 +173,7 @@
  *  - add FUSE_SETUPMAPPING and FUSE_REMOVEMAPPING
  *  - add map_alignment to fuse_init_out, add FUSE_MAP_ALIGNMENT flag
  *  - add FUSE_HANDLE_KILLPRIV_V2
+ *  - add FUSE_OPEN_KILL_PRIV
  */
 
 #ifndef _LINUX_FUSE_H
@@ -427,6 +428,13 @@ struct fuse_file_lock {
  */
 #define FUSE_FSYNC_FDATASYNC	(1 << 0)
 
+/**
+ * Open flags
+ * FUSE_OPEN_KILL_PRIV: Kill suid/sgid/security.capability. sgid is cleared
+ * 			only if file has group execute permission.
+ */
+#define FUSE_OPEN_KILL_PRIV	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -588,7 +596,7 @@ struct fuse_setattr_in {
 
 struct fuse_open_in {
 	uint32_t	flags;
-	uint32_t	unused;
+	uint32_t	open_flags;
 };
 
 struct fuse_create_in {
-- 
2.25.4

