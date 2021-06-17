DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1rcaBiYMmxbTIzBSP4Lkyvlkc2KdB5uGKfAUxQ6B2a4=;
	b=nTtzOYyH5nOB+rP0PzOPnj6I+b
	Kznx/IAocBctaMmCDpRBXcNsJOFm5Rx3yGsLm+PWWxWHDhmzH2k4knlIjyqz0MxafD79FV3ZF6Dp1
	Vx2s7YvaIQb+zKW4icpwpqz9MhyVR/6AWFOkICqel2DCojYafEI3tTZadCaGq8y08Kl9ybex3TajK
	qBTiX7TxTBkTKx5ClUNwC+i5dm/NVFXzhWnmUauAfJR3DgZy4hWMn3tOFJiL/w0rLP5boCXZN9vB8
	CTEExFY0i1HAry95jafbWjRvtbwQn/snQQYYccuM4Y3dngmmwxqibc25LV8ViDP1qTT+6XSdSVZ+f
	vdNdIovw==
Date: Thu, 17 Jun 2021 11:14:00 +0100
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <YMsgaPS90iKIqSvi@infradead.org>
References: <20210614174454.903555-1-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210614174454.903555-1-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2 0/2] Add support to boot virtiofs and
	9pfs as rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhowells@redhat.com, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

Why not something like the version below that should work for all nodev
file systems?

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 74aede860de7..3c5676603fef 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -530,6 +530,39 @@ static int __init mount_cifs_root(void)
 }
 #endif
 
+static int __init mount_nodev_root(void)
+{
+	struct file_system_type *fs = get_fs_type(root_fs_names);
+	char *fs_names, *p;
+	int err = -ENODEV;
+
+	if (!fs)
+		goto out;
+	if (fs->fs_flags & FS_REQUIRES_DEV)
+		goto out_put_filesystem;
+
+	fs_names = (void *)__get_free_page(GFP_KERNEL);
+	if (!fs_names)
+		goto out_put_filesystem;
+	get_fs_names(fs_names);
+
+	for (p = fs_names; *p; p += strlen(p) + 1) {
+		err = do_mount_root(root_device_name, p, root_mountflags,
+					root_mount_data);
+		if (!err)
+			break;
+		if (err != -EACCES && err != -EINVAL)
+			panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
+				      root_device_name, p, err);
+	}
+
+	free_page((unsigned long)fs_names);
+out_put_filesystem:
+	put_filesystem(fs);
+out:
+	return err;
+}
+
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
@@ -546,6 +579,8 @@ void __init mount_root(void)
 		return;
 	}
 #endif
+	if (ROOT_DEV == 0 && mount_nodev_root() == 0)
+		return;
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);

