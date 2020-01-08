Date: Wed, 8 Jan 2020 10:24:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200108152425.GD1995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Enable xattr support by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Enable xattr support by default. Currently it is disabled by defaut
and that makes getfattr/setfattr fail in guest. 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c |    1 +
 1 file changed, 1 insertion(+)

Index: qemu/contrib/virtiofsd/passthrough_ll.c
===================================================================
--- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2020-01-08 10:10:08.762661288 -0500
+++ qemu/contrib/virtiofsd/passthrough_ll.c	2020-01-08 10:15:03.170488067 -0500
@@ -3096,6 +3096,7 @@ int main(int argc, char *argv[])
 	                      .writeback = 0,
 			      .posix_lock = 1,
 	                      .proc_self_fd = -1,
+			      .xattr = 1,
 	};
 	struct lo_map_elem *root_elem;
 	int ret = -1;

