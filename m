Date: Wed, 3 Jul 2019 16:32:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190703203234.GB5499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH][virtio-fs-dev] virtiofsd: Fix
 fuse_reply_create() to determine correct length of buffer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi Dave,

Following patch needs to be applied on virtio-fs-dev branch to make it
work with latest kernel. Otherwise file creation reply returns error.

Thanks
Vivek

Put conditional express in brackets. Otherwise expression being evaluated
becomes (entrysize + sizeof(struct fuse_open_out) + shared) instead and
which obviously results in wrong size calculation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_lowlevel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: qemu/contrib/virtiofsd/fuse_lowlevel.c
===================================================================
--- qemu.orig/contrib/virtiofsd/fuse_lowlevel.c	2019-07-01 13:22:55.489623969 -0400
+++ qemu/contrib/virtiofsd/fuse_lowlevel.c	2019-07-01 13:23:56.338143585 -0400
@@ -413,7 +413,7 @@ int fuse_reply_create(fuse_req_t req, co
 	ever->version_index = e->version_offset;
 	return send_reply_ok(req, buf,
 			     entrysize + sizeof(struct fuse_open_out) +
-                             shared ? sizeof(struct fuse_entryver_out) : 0);
+                             (shared ? sizeof(struct fuse_entryver_out) : 0));
 }
 
 int fuse_reply_attr(fuse_req_t req, const struct stat *attr,

