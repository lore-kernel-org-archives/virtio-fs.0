Date: Tue, 9 Feb 2021 17:47:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210209224754.GG3171@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofs: Fail dax mount if device does not
	support it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>

Right now "mount -t virtiofs -o dax myfs /mnt/virtiofs" succeeds even
if filesystem deivce does not have a cache window and hence DAX can't
be supported.

This gives a false sense to user that they are using DAX with virtiofs
but fact of the matter is that they are not.

Fix this by returning error if dax can't be supported and user has asked
for it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: redhat-linux/fs/fuse/virtio_fs.c
===================================================================
--- redhat-linux.orig/fs/fuse/virtio_fs.c	2021-02-04 10:40:21.704370721 -0500
+++ redhat-linux/fs/fuse/virtio_fs.c	2021-02-09 15:56:45.693653979 -0500
@@ -1324,8 +1324,15 @@ static int virtio_fs_fill_super(struct s
 
 	/* virtiofs allocates and installs its own fuse devices */
 	ctx->fudptr = NULL;
-	if (ctx->dax)
+	if (ctx->dax) {
+		if (!fs->dax_dev) {
+			err = -EINVAL;
+			pr_err("virtio-fs: dax can't be enabled as filesystem"
+			       " device does not support it.\n");
+			goto err_free_fuse_devs;
+		}
 		ctx->dax_dev = fs->dax_dev;
+	}
 	err = fuse_fill_super_common(sb, ctx);
 	if (err < 0)
 		goto err_free_fuse_devs;

