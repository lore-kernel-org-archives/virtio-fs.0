From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 14 Jul 2021 16:23:20 -0400
Message-Id: <20210714202321.59729-3-vgoyal@redhat.com>
In-Reply-To: <20210714202321.59729-1-vgoyal@redhat.com>
References: <20210714202321.59729-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 2/3] init: allow mounting arbitrary
	non-blockdevice filesystems as root
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: viro@zeniv.linux.org.uk
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de

From: Christoph Hellwig <hch@lst.de>

Currently the only non-blockdevice filesystems that can be used as the
initial root filesystem are NFS and CIFS, which use the magic
"root=/dev/nfs" and "root=/dev/cifs" syntax that requires the root
device file system details to come from filesystem specific kernel
command line options.

Add a little bit of new code that allows to just pass arbitrary
string mount options to any non-blockdevice filesystems so that it can
be mounted as the root file system.

For example a virtiofs root file system can be mounted using the
following syntax:

"root=myfs rootfstype=virtiofs rw"

Based on an earlier patch from Vivek Goyal <vgoyal@redhat.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index ec32de3ad52b..bdeb90b8d669 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -534,6 +534,45 @@ static int __init mount_cifs_root(void)
 }
 #endif
 
+static bool __init fs_is_nodev(char *fstype)
+{
+	struct file_system_type *fs = get_fs_type(fstype);
+	bool ret = false;
+
+	if (fs) {
+		ret = !(fs->fs_flags & FS_REQUIRES_DEV);
+		put_filesystem(fs);
+	}
+
+	return ret;
+}
+
+static int __init mount_nodev_root(void)
+{
+	char *fs_names, *fstype;
+	int err = -EINVAL;
+
+	fs_names = (void *)__get_free_page(GFP_KERNEL);
+	if (!fs_names)
+		return -EINVAL;
+	split_fs_names(fs_names, root_fs_names);
+
+	for (fstype = fs_names; *fstype; fstype += strlen(fstype) + 1) {
+		if (!fs_is_nodev(fstype))
+			continue;
+		err = do_mount_root(root_device_name, fstype, root_mountflags,
+				    root_mount_data);
+		if (!err)
+			break;
+		if (err != -EACCES && err != -EINVAL)
+			panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
+			      root_device_name, fstype, err);
+	}
+
+	free_page((unsigned long)fs_names);
+	return err;
+}
+
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
@@ -550,6 +589,10 @@ void __init mount_root(void)
 		return;
 	}
 #endif
+	if (ROOT_DEV == 0 && root_device_name && root_fs_names) {
+		if (mount_nodev_root() == 0)
+			return;
+	}
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);
-- 
2.31.1

