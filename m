From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 14 Jun 2021 13:44:53 -0400
Message-Id: <20210614174454.903555-2-vgoyal@redhat.com>
In-Reply-To: <20210614174454.903555-1-vgoyal@redhat.com>
References: <20210614174454.903555-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/2] init/do_mounts.c: Add a path to boot
	from tag based filesystems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: hch@infradead.org, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, v9fs-developer@lists.sourceforge.net, vgoyal@redhat.com

We want to be able to mount virtiofs as rootfs and pass appropriate
kernel command line. Right now there does not seem to be a good way
to do that. If I specify "root=myfs rootfstype=virtiofs", system
panics.

virtio-fs: tag </dev/root> not found
..
..
[ end Kernel panic - not syncing: VFS: Unable to mount root fs on
+unknown-block(0,0) ]

Basic problem here is that kernel assumes that device identifier
passed in "root=" is a block device. But there are few execptions
to this rule to take care of the needs of mtd, ubi, NFS and CIFS.

For example, mtd and ubi prefix "mtd:" or "ubi:" respectively.

"root=mtd:<identifier>" or "root=ubi:<identifier>"

NFS and CIFS use "root=/dev/nfs" and CIFS passes "root=/dev/cifs" and
actual root device details come from filesystem specific kernel
command line options.

virtiofs does not seem to fit in any of the above categories. In fact
we have 9pfs which can be used to boot from but it also does not
have a proper syntax to specify rootfs and does not fit into any of
the existing syntax. They both expect a device "tag" to be passed
in a device to be mounted. And filesystem knows how to parse and
use "tag".

So there seem to be a class of filesystems which specify root device
using a "tag" which is understood by the filesystem. And filesystem
simply expects that "tag" to be passed as "source" of mount and
how to mount filesystem using that "tag" is responsibility of filesystem.

This patch proposes that we internally create a list of filesystems
which pass a "tag" in "root=<tag>" and expect that tag to be passed
as "source" of mount. With this patch I can boot into virtiofs rootfs
with following syntax.

"root=myfs rootfstype=virtiofs rw"

This patch adds support for virtiofs and next patch adds 9p to the
list.

And any other file system which is fine with these semantics,
should be able to work with it easily.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 init/do_mounts.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index a78e44ee6adb..2a18238f4962 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -31,6 +31,12 @@
 int root_mountflags = MS_RDONLY | MS_SILENT;
 static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
+static char *__initdata tag_based_rootfs[] = {
+#if IS_BUILTIN(CONFIG_VIRTIO_FS)
+	"virtiofs",
+#endif
+};
+static bool __initdata tag_based_root;
 static int root_wait;
 
 dev_t ROOT_DEV;
@@ -552,6 +558,14 @@ void __init mount_root(void)
 		return;
 	}
 #endif
+	if (tag_based_root) {
+		if (!do_mount_root(root_device_name, root_fs_names,
+				   root_mountflags, root_mount_data))
+			return;
+		panic("VFS: Unable to mount root \"%s\" via \"%s\"\n",
+		      root_device_name, root_fs_names);
+	}
+
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);
@@ -563,6 +577,20 @@ void __init mount_root(void)
 #endif
 }
 
+static bool is_tag_based_rootfs(char *name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tag_based_rootfs); i++) {
+		int name_len = strlen(tag_based_rootfs[i]) + 1;
+
+		if (!strncmp(tag_based_rootfs[i], name, name_len))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -593,6 +621,10 @@ void __init prepare_namespace(void)
 			goto out;
 		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
+		if (ROOT_DEV == 0 && root_fs_names) {
+			if (is_tag_based_rootfs(root_fs_names))
+				tag_based_root = true;
+		}
 		if (strncmp(root_device_name, "/dev/", 5) == 0)
 			root_device_name += 5;
 	}
-- 
2.25.4

