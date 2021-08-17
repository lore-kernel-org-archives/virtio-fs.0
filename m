From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 17 Aug 2021 10:22:19 +0800
Message-Id: <20210817022220.17574-8-jefflexu@linux.alibaba.com>
In-Reply-To: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v4 7/8] fuse: support changing per-file DAX flag
	inside guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

Fuse client can enable or disable per-file DAX inside kernel/guest by
chattr(1). Similarly the new state won't be updated until the file is
closed and reopened later.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/ioctl.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 546ea3d58fb4..a9ed53c5dbd1 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -469,8 +469,6 @@ int fuse_fileattr_set(struct user_namespace *mnt_userns,
 	if (fa->flags_valid) {
 		err = fuse_priv_ioctl(inode, ff, FS_IOC_SETFLAGS,
 				      &flags, sizeof(flags));
-		if (err)
-			goto cleanup;
 	} else {
 		memset(&xfa, 0, sizeof(xfa));
 		xfa.fsx_xflags = fa->fsx_xflags;
@@ -483,6 +481,19 @@ int fuse_fileattr_set(struct user_namespace *mnt_userns,
 				      &xfa, sizeof(xfa));
 	}
 
+	if (err)
+		goto cleanup;
+
+	if (IS_ENABLED(CONFIG_FUSE_DAX)) {
+		bool newdax;
+
+		if (fa->flags_valid)
+			newdax = flags & FS_DAX_FL;
+		else
+			newdax = fa->fsx_xflags & FS_XFLAG_DAX;
+		fuse_dax_dontcache(inode, newdax);
+	}
+
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
 
-- 
2.27.0

