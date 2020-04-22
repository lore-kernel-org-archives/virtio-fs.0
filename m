From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 22 Apr 2020 09:08:50 -0400
Message-Id: <20200422130850.59900-3-vgoyal@redhat.com>
In-Reply-To: <20200422130850.59900-1-vgoyal@redhat.com>
References: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] overlayfs: ovl_setattr() should clear
	ATTR_OPEN
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

As of now during open(), we don't pass bunch of flags to underlying
filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
calls ->setattr() with zero size and underlying filesystem sets file size
to 0.

But when overlayfs is running on top of virtiofs, it has an optimization
where it does not send setattr request to server if dectects that
truncation is part of open(O_TRUNC). It assumes that server already zeroed
file size as part of open(O_TRUNC).

fuse_do_setattr() {
        if (attr->ia_valid & ATTR_OPEN) {
                /*
                 * No need to send request to userspace, since actual
                 * truncation has already been done by OPEN.  But still
                 * need to truncate page cache.
                 */
        }
}

IOW, fuse expects O_TRUNC to be passed to it as part of open flags.

But currently overlayfs does not pass O_TRUNC to underlying filesystem
hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
following does not zero the file size of a file is either upper only
or has already been copied up.

fd = open(foo.txt, O_TRUNC | O_WRONLY);

There are two ways to fix this. Either pass O_TRUNC to underlying filesystem
or clear ATTR_OPEN from attr->ia_valid so that fuse ends up sending a
SETATTR request to server. Miklos is concerned that O_TRUNC might have
side affects so it is better to clear ATTR_OPEN for now. Hence this patch
clears ATTR_OPEN from attr->ia_valid.

I found this problem while running unionmount-testsuite. With this patch,
unionmount-testsuite passes with overlayfs on top of virtiofs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8d147bc70f0b..08ae88b72d9a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -37,6 +37,17 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 		/* Truncate should trigger data copy up as well */
 		full_copy_up = true;
+
+		/* If open(O_TRUNC) is done, VFS calls ->setattr with
+		 * ATTR_OPEN set. Overlayfs does not pass O_TRUNC flag
+		 * to underlying filesystem during open. Do not pass
+		 * ATTR_OPEN. This disables optimization in fuse which
+		 * assumes open(O_TRUNC) already set file size to 0. But
+		 * we never passed O_TRUNC to fuse. So by clearing ATTR_OPEN,
+		 * fuse will be forced to set ->setattr() request to
+		 * server.
+		 */
+		attr->ia_valid &= ~ATTR_OPEN;
 	}
 
 	if (!full_copy_up)
-- 
2.25.3

