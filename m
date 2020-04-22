From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 22 Apr 2020 09:08:49 -0400
Message-Id: <20200422130850.59900-2-vgoyal@redhat.com>
In-Reply-To: <20200422130850.59900-1-vgoyal@redhat.com>
References: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] overlayfs: ovl_setattr() should clear
	ATTR_FILE from attr->ia_valid
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

ovl_setattr() can be passed an attr which has ATTR_FILE set and
attr->ia_file is a file pointer to overlay file. This is done
in open(O_TRUNC) path.

We should either replace with attr->ia_file with underlying file object
or clear ATTR_FILE so that underlying filesystem does not end up using
overlayfs file object pointer.

There are no good use cases yet so for now clear ATTR_FILE. fuse seems
to be one user which can use this. But it can work even without this.
So it is not mandatory to pass ATTR_FILE to fuse.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b0d42ece4d7c..8d147bc70f0b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -58,6 +58,11 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 			attr->ia_valid &= ~ATTR_MODE;
 
+		/* We might have to translate ovl file into underlying file
+		 * object once some use cases are there. For now, simply
+		 * don't let underlying filesystem rely on attr->ia_file */
+		attr->ia_valid &= ~ATTR_FILE;
+
 		inode_lock(upperdentry->d_inode);
 		old_cred = ovl_override_creds(dentry->d_sb);
 		err = notify_change(upperdentry, attr, NULL);
-- 
2.25.3

