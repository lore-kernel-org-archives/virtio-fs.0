Date: Thu, 25 Jul 2019 16:49:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190725204934.GG15543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [RFC][PATCH] init: Allow mounting virtio_fs instance as
	rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

Hi Stefan,

I think following patch might allow you to mount virtio_fs as rootfs
with new syntax.

I have only compiled it and not tested it. Plase have a look.

Thanks
Vivek

virtio_fs passes root=<fs-instance-name> as identifier of virtio_fs instance
to be mounted. None of the existing primitives seems to fit virito_fs needs.

So check rootfstype and if it is "virtio_fs", do not parse root= further
and call mount_block_root().

This is similar to carving out special paths for ubifs. Now virtio_fs
users should be able to pass "root=myfs rootfstype=virtio_fs" and be
able to mount that particular instance of virtio_fs as rootfs.
 
Yet-To-Be-Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 init/do_mounts.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: rhvgoyal-linux-fuse/init/do_mounts.c
===================================================================
--- rhvgoyal-linux-fuse.orig/init/do_mounts.c	2019-04-09 15:42:17.096602971 -0400
+++ rhvgoyal-linux-fuse/init/do_mounts.c	2019-07-25 16:40:29.226348627 -0400
@@ -595,6 +595,10 @@ void __init prepare_namespace(void)
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
+		if (root_fs_names && !strncmp(root_fs_names, "virtio_fs", 3)) {
+			mount_block_root(root_device_name, root_mountflags);
+			goto out;
+		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
 		if (strncmp(root_device_name, "/dev/", 5) == 0)
 			root_device_name += 5;

