From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  8 Jul 2021 13:57:38 -0400
Message-Id: <20210708175738.360757-2-vgoyal@redhat.com>
In-Reply-To: <20210708175738.360757-1-vgoyal@redhat.com>
References: <20210708175738.360757-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/1] xattr: Allow user.* xattr on symlink and
	special files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: gscrivan@redhat.com, tytso@mit.edu, miklos@szeredi.hu, selinux@vger.kernel.org, virtio-fs@redhat.com, linux-security-module@vger.kernel.org, casey.schaufler@intel.com, jack@suse.cz, christian.brauner@ubuntu.com, vgoyal@redhat.com

Currently user.* xattr are not allowed on symlink and special files.

man xattr and recent discussion suggested that primary reason for this
restriction is how file permissions for symlinks and special files
are little different from regular files and directories.

For symlinks, they are world readable/writable and if user xattr were
to be permitted, it will allow unpriviliged users to dump a huge amount
of user.* xattrs on symlinks without any control.

For special files, permissions typically control capability to read/write
from devices (and not necessarily from filesystem). So if a user can
write to device (/dev/null), does not necessarily mean it should be allowed
to write large number of user.* xattrs on the filesystem device node is
residing in.

This patch proposes to relax the restrictions a bit and allow file owner
or priviliged user (CAP_FOWNER), to be able to read/write user.* xattrs
on symlink and special files.

virtiofs daemon has a need to store user.* xatrrs on all the files
(including symlinks and special files), and currently that fails. This
patch should help.

Link: https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.com/
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/xattr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..2f1855c8b620 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -120,12 +120,14 @@ xattr_permission(struct user_namespace *mnt_userns, struct inode *inode,
 	}
 
 	/*
-	 * In the user.* namespace, only regular files and directories can have
-	 * extended attributes. For sticky directories, only the owner and
-	 * privileged users can write attributes.
+	 * In the user.* namespace, for symlinks and special files, only
+	 * the owner and priviliged users can read/write attributes.
+	 * For sticky directories, only the owner and privileged users can
+	 * write attributes.
 	 */
 	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
-		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
+		    !inode_owner_or_capable(mnt_userns, inode))
 			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
 		    (mask & MAY_WRITE) &&
-- 
2.25.4

