Date: Tue, 21 Apr 2020 14:41:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200421184107.GC28740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] overlayfs: Pass O_TRUNC flag to underlying
	filesystem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Amir Goldstein <amir73il@gmail.com>

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

Fix it by passing O_TRUNC to underlying filesystem.

I found this problem while running unionmount-testsuite. It fails.

***
*** ./run --ov --samefs --ts=0 open-trunc
***
TEST open-trunc.py:10: Open O_TRUNC|O_RDONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo100 -r -t -R 
 ./run --open-file /mnt/virtiofs/mnt/a/foo100 -r -t -R 
TEST open-trunc.py:18: Open O_TRUNC|O_WRONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -w -t -W q
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -r -R q
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -w -t -W p
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -r -R p
TEST open-trunc.py:28: Open O_TRUNC|O_APPEND|O_WRONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -a -t -W q
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -r -R q
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -a -t -W p
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -r -R p
/mnt/virtiofs/mnt/a/foo102: File size wrong (got 2, want 1)

After this patch, unionmount-testsuite passes with overlayfs on top of
virtiofs.
 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: redhat-linux/fs/overlayfs/file.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/file.c	2020-04-21 13:33:40.777125594 -0400
+++ redhat-linux/fs/overlayfs/file.c	2020-04-21 13:53:30.317125594 -0400
@@ -134,7 +134,7 @@ static int ovl_open(struct inode *inode,
 		return err;
 
 	/* No longer need these flags, so don't pass them on to underlying fs */
-	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY);
 
 	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
 	if (IS_ERR(realfile))

