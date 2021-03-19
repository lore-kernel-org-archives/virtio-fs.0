From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 19 Mar 2021 15:55:47 -0400
Message-Id: <20210319195547.427371-4-vgoyal@redhat.com>
In-Reply-To: <20210319195547.427371-1-vgoyal@redhat.com>
References: <20210319195547.427371-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] fuse: Add a flag
	FUSE_SETXATTR_ACL_KILL_SGID to kill SGID
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: seth.forshee@canonical.com, vgoyal@redhat.com

When posix access ACL is set, it can have an effect on file mode and
it can also need to clear SGID if.

- None of caller's group/supplementary groups match file owner group.
AND
- Caller is not priviliged (No CAP_FSETID).

As of now fuser server is responsible for changing the file mode as well. But
it does not know whether to clear SGID or not.

So add a flag FUSE_SETXATTR_ACL_KILL_SGID and send this info with
SETXATTR to let file server know that sgid needs to be cleared as well.

Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/acl.c             | 7 ++++++-
 include/uapi/linux/fuse.h | 7 +++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index d31260a139d4..45358124181a 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -71,6 +71,7 @@ int fuse_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 		return -EINVAL;
 
 	if (acl) {
+		unsigned extra_flags = 0;
 		/*
 		 * Fuse userspace is responsible for updating access
 		 * permissions in the inode, if needed. fuse_setxattr
@@ -94,7 +95,11 @@ int fuse_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 			return ret;
 		}
 
-		ret = fuse_setxattr(inode, name, value, size, 0, 0);
+		if (fc->setxattr_v2 &&
+		    posix_acl_mode_clear_sgid(&init_user_ns, inode))
+			extra_flags |= FUSE_SETXATTR_ACL_KILL_SGID;
+
+		ret = fuse_setxattr(inode, name, value, size, 0, extra_flags);
 		kfree(value);
 	} else {
 		ret = fuse_removexattr(inode, name);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 1bb555c1c117..08c11a7beaa7 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -180,6 +180,7 @@
  *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
  *  - add FUSE_OPEN_KILL_SUIDGID
  *  - add FUSE_SETXATTR_V2
+ *  - add FUSE_SETXATTR_ACL_KILL_SGID
  */
 
 #ifndef _LINUX_FUSE_H
@@ -454,6 +455,12 @@ struct fuse_file_lock {
  */
 #define FUSE_OPEN_KILL_SUIDGID	(1 << 0)
 
+/**
+ * setxattr flags
+ * FUSE_SETXATTR_ACL_KILL_SGID: Clear SGID when system.posix_acl_access is set
+ */
+#define FUSE_SETXATTR_ACL_KILL_SGID	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
-- 
2.25.4

