From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 16 Sep 2020 12:17:32 -0400
Message-Id: <20200916161737.38028-2-vgoyal@redhat.com>
In-Reply-To: <20200916161737.38028-1-vgoyal@redhat.com>
References: <20200916161737.38028-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/6] fuse: Introduce the notion of
	FUSE_HANDLE_KILLPRIV_V2
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

We already have FUSE_HANDLE_KILLPRIV flag that says that file server will
remove suid/sgid/caps on truncate/chown/write. But that's little different
from what Linux VFS implements.

To be consistent with Linux VFS behavior what we want is.

- caps are always cleared on chown/write/truncate
- suid is always cleared on chown, while for truncate/write it is cleared
  only if caller does not have CAP_FSETID.
- sgid is always cleared on chown, while for truncate/write it is cleared
  only if caller does not have CAP_FSETID as well as file has group execute
  permission.

As previous flag did not provide above semantics. Implement a V2 of the
protocol with above said constraints.

Server does not know if caller has CAP_FSETID or not. So for the case
of write()/truncate(), client will send information in special flag to
indicate whether to kill priviliges or not. These changes are in subsequent
patches.

FUSE_HANDLE_KILLPRIV_V2 relies on WRITE being sent to server to clear
suid/sgid/security.capability. But with ->writeback_cache, WRITES are
cached in guest. So it is not recommended to use FUSE_HANDLE_KILLPRIV_V2
and writeback_cache together. Though it probably might be good enough
for lot of use cases.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/fuse_i.h          | 6 ++++++
 fs/fuse/inode.c           | 5 ++++-
 include/uapi/linux/fuse.h | 7 +++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index dbaae2f6c73e..3dd1578be405 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -631,6 +631,12 @@ struct fuse_conn {
 	/* show legacy mount options */
 	unsigned int legacy_opts_show:1;
 
+	/** fs kills suid/sgid/cap on write/chown/trunc. suid is
+	    killed on write/trunc only if caller did not have CAP_FSETID.
+	    sgid is killed on write/truncate only if caller did not have
+	    CAP_FSETID as well as file has group execute permission. */
+	unsigned handle_killpriv_v2:1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d252237219bf..20740b61f12b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -993,6 +993,8 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
 			    !fuse_dax_check_alignment(fc, arg->map_alignment)) {
 				ok = false;
 			}
+			if (arg->flags & FUSE_HANDLE_KILLPRIV_V2)
+				fc->handle_killpriv_v2 = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1035,7 +1037,8 @@ void fuse_send_init(struct fuse_conn *fc)
 		FUSE_WRITEBACK_CACHE | FUSE_NO_OPEN_SUPPORT |
 		FUSE_PARALLEL_DIROPS | FUSE_HANDLE_KILLPRIV | FUSE_POSIX_ACL |
 		FUSE_ABORT_ERROR | FUSE_MAX_PAGES | FUSE_CACHE_SYMLINKS |
-		FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA;
+		FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA |
+		FUSE_HANDLE_KILLPRIV_V2;
 #ifdef CONFIG_FUSE_DAX
 	if (fc->dax)
 		ia->in.flags |= FUSE_MAP_ALIGNMENT;
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 8899e4862309..3ae3f222a0ed 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -172,6 +172,7 @@
  *  - add FUSE_WRITE_KILL_PRIV flag
  *  - add FUSE_SETUPMAPPING and FUSE_REMOVEMAPPING
  *  - add map_alignment to fuse_init_out, add FUSE_MAP_ALIGNMENT flag
+ *  - add FUSE_HANDLE_KILLPRIV_V2
  */
 
 #ifndef _LINUX_FUSE_H
@@ -316,6 +317,11 @@ struct fuse_file_lock {
  * FUSE_MAP_ALIGNMENT: init_out.map_alignment contains log2(byte alignment) for
  *		       foffset and moffset fields in struct
  *		       fuse_setupmapping_out and fuse_removemapping_one.
+ * FUSE_HANDLE_KILLPRIV_V2: fs kills suid/sgid/cap on write/chown/trunc.
+ * 			Upon write/truncate suid/sgid is only killed if caller
+ * 			does not have CAP_FSETID. Additionally upon
+ * 			write/truncate sgid is killed only if file has group
+ * 			execute permission. (Same as Linux VFS behavior).
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -344,6 +350,7 @@ struct fuse_file_lock {
 #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
 #define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
 #define FUSE_MAP_ALIGNMENT	(1 << 26)
+#define FUSE_HANDLE_KILLPRIV_V2	(1 << 27)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.25.4

