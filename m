Date: Wed, 8 Jan 2020 15:24:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200108202422.GF1995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Open fd O_RDONLY in
	setxattr/removexattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Do not open fd O_RDWR as it will fail for directories with EISDIR. This
code can be called both for regular files as well as directories.

I noticed this when I tried "setfattr -n user.foo -v test <dir>" inside
the guest and got EISDIR.

To write xattr, we don't have to open fd with write permissions. Looks
like kernel will do permission checks on inode.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: qemu/contrib/virtiofsd/passthrough_ll.c
===================================================================
--- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:01:03.821980889 -0500
+++ qemu/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:05:15.209384352 -0500
@@ -2424,7 +2424,7 @@ static void lo_setxattr(fuse_req_t req,
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;
@@ -2473,7 +2473,7 @@ static void lo_removexattr(fuse_req_t re
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;

