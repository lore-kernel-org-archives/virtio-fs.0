From: Luis Henriques <lhenriques@suse.de>
Date: Fri, 26 Feb 2021 18:33:57 +0000
Message-Id: <20210226183357.28467-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH] fuse: Clear SGID bit when setting mode in
	setacl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

Setting file permissions with POSIX ACLs (setxattr) isn't clearing the
setgid bit.  This seems to be CVE-2016-7097, detected by running fstest
generic/375 in virtiofs.  Unfortunately, when the fix for this CVE landed
in the kernel with commit 073931017b49 ("posix_acl: Clear SGID bit when
setting file permissions"), FUSE didn't had ACLs support yet.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/fuse/acl.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index f529075a2ce8..1b273277c1c9 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -54,7 +54,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	const char *name;
+	umode_t mode = inode->i_mode;
 	int ret;
+	bool update_mode = false;
 
 	if (fuse_is_bad(inode))
 		return -EIO;
@@ -62,11 +64,18 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
 
-	if (type == ACL_TYPE_ACCESS)
+	if (type == ACL_TYPE_ACCESS) {
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
-	else if (type == ACL_TYPE_DEFAULT)
+		if (acl) {
+			ret = posix_acl_update_mode(inode, &mode, &acl);
+			if (ret)
+				return ret;
+			if (inode->i_mode != mode)
+				update_mode = true;
+		}
+	} else if (type == ACL_TYPE_DEFAULT) {
 		name = XATTR_NAME_POSIX_ACL_DEFAULT;
-	else
+	} else
 		return -EINVAL;
 
 	if (acl) {
@@ -98,6 +107,20 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	} else {
 		ret = fuse_removexattr(inode, name);
 	}
+	if (!ret && update_mode) {
+		struct dentry *entry;
+		struct iattr attr;
+
+		entry = d_find_alias(inode);
+		if (entry) {
+			memset(&attr, 0, sizeof(attr));
+			attr.ia_valid = ATTR_MODE | ATTR_CTIME;
+			attr.ia_mode = mode;
+			attr.ia_ctime = current_time(inode);
+			ret = fuse_do_setattr(entry, &attr, NULL);
+			dput(entry);
+		}
+	}
 	forget_all_cached_acls(inode);
 	fuse_invalidate_attr(inode);
 


