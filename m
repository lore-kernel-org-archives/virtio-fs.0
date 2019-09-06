From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri,  6 Sep 2019 11:03:24 +0100
Message-Id: <20190906100324.8492-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] init/do_mounts.c: add virtiofs root fs support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: mszeredi@redhat.com, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

Make it possible to boot directly from a virtiofs file system with tag
'myfs' using the following kernel parameters:

  rootfstype=virtiofs root=myfs rw

Booting directly from virtiofs makes it possible to use a directory on
the host as the root file system.  This is convenient for testing and
situations where manipulating disk image files is cumbersome.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
This patch is based on linux-next (next-20190904) but should apply
cleanly to other virtiofs trees.

 init/do_mounts.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 9634ecf3743d..030be2f1999a 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -554,6 +554,16 @@ void __init mount_root(void)
 			change_floppy("root floppy");
 	}
 #endif
+#ifdef CONFIG_VIRTIO_FS
+	if (root_fs_names && !strcmp(root_fs_names, "virtiofs")) {
+		if (!do_mount_root(root_device_name, "virtiofs",
+				   root_mountflags, root_mount_data))
+			return;
+
+		panic("VFS: Unable to mount root fs \"%s\" from virtiofs",
+		      root_device_name);
+	}
+#endif
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);
-- 
2.21.0

