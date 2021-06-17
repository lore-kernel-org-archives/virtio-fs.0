DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=UJ6ZxhI7pFym7PlR0u1lnYbOiSY2JPtqMcPqBO8j2q0=;
	b=BK05KsYHCXpeyI0F6JM/YUplQU
	wVe/HymRx2z4x4OxmQIUe+oHOroCwZcyqh5Mx/szwWxJAwZ6D7TMoGzyEAB9NFiDg5xFb8Xi2jzH/
	7RkPuGbZUIlRJeQJnowTEqkl3PWASCqw/eHsf519z9DHnHIG0FT+XiBAz6IQnoSXizvPR5KqvUAY9
	fzca3YiGLU/ELLa0NRSfV3t5JX5HQWQkmZxNTR/LUDu1jaHOKKpP/TgvYoTJP0vtv+uGnaT6MDqnA
	DjPUSREvFVqZycTWJW515GpydyhNnidvEUisHBlPV4IXjasREJaxVpOfnh0qPjtr3SE3yYTvsCixX
	fcyXeAnA==
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Jun 2021 17:36:49 +0200
Message-Id: <20210617153649.1886693-3-hch@lst.de>
In-Reply-To: <20210617153649.1886693-1-hch@lst.de>
References: <20210617153649.1886693-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 2/2] init: allow mounting arbitrary
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
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

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
 init/do_mounts.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index ec32de3ad52b..64c60cb72ecb 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -534,6 +534,44 @@ static int __init mount_cifs_root(void)
 }
 #endif
 
+static int __init try_mount_nodev(char *fstype)
+{
+	struct file_system_type *fs = get_fs_type(fstype);
+	int err = -EINVAL;
+
+	if (!fs)
+		return -EINVAL;
+	if (!(fs->fs_flags & (FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA)))
+		err = do_mount_root(root_device_name, fstype, root_mountflags,
+					root_mount_data);
+	put_filesystem(fs);
+
+	if (err != -EACCES && err != -EINVAL)
+		panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
+			      root_device_name, fstype, err);
+	return err;
+}
+
+static int __init mount_nodev_root(void)
+{
+	char *fs_names, *p;
+	int err = -EINVAL;
+
+	fs_names = (void *)__get_free_page(GFP_KERNEL);
+	if (!fs_names)
+		return -EINVAL;
+	split_fs_names(fs_names, root_fs_names);
+
+	for (p = fs_names; *p; p += strlen(p) + 1) {
+		err = try_mount_nodev(p);
+		if (!err)
+			break;
+	}
+
+	free_page((unsigned long)fs_names);
+	return err;
+}
+
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
@@ -550,6 +588,8 @@ void __init mount_root(void)
 		return;
 	}
 #endif
+	if (ROOT_DEV == 0 && mount_nodev_root() == 0)
+		return;
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);
-- 
2.30.2

