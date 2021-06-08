Date: Tue, 8 Jun 2021 11:35:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210608153524.GB504497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>" syntax
 for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, v9fs-developer@lists.sourceforge.net

We want to be able to mount virtiofs as rootfs and pass appropriate
kernel command line. Right now there does not seem to be a good way
to do that. If I specify "root=myfs rootfstype=virtiofs", system
panics.

virtio-fs: tag </dev/root> not found
..
..
[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]

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

So this patch proposes that we add a new prefix "fstag:" which specifies
that identifier which follows is filesystem specific tag and its not
a block device. Just pass this tag to filesystem and filesystem will
figure out how to mount it.

For example, "root=fstag:<tag>".

In case of virtiofs, I can specify "root=fstag:myfs rootfstype=virtiofs"
and it works.

I think this should work for 9p as well. "root=fstag:myfs rootfstype=9p".
Though I have yet to test it.

This kind of syntax should be able to address wide variety of use cases
where root device is not a block device and is simply some kind of
tag/label understood by filesystem.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/root_dev.h |  1 +
 init/do_mounts.c         | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
index 4e78651371ba..3fda7c5d9327 100644
--- a/include/linux/root_dev.h
+++ b/include/linux/root_dev.h
@@ -9,6 +9,7 @@
 enum {
 	Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
 	Root_CIFS = MKDEV(UNNAMED_MAJOR, 254),
+	Root_FSTAG = MKDEV(UNNAMED_MAJOR, 253),
 	Root_RAM0 = MKDEV(RAMDISK_MAJOR, 0),
 	Root_RAM1 = MKDEV(RAMDISK_MAJOR, 1),
 	Root_FD0 = MKDEV(FLOPPY_MAJOR, 0),
diff --git a/init/do_mounts.c b/init/do_mounts.c
index a78e44ee6adb..4d1df0da1ccc 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -275,6 +275,7 @@ static dev_t devt_from_devnum(const char *name)
  *	9) PARTLABEL=<name> with name being the GPT partition label.
  *	   MSDOS partitions do not support labels!
  *	10) /dev/cifs represents Root_CIFS (0xfe)
+ *	11) fstag:<tag> represents Root_FSTAG (0xfd)
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -287,6 +288,8 @@ dev_t name_to_dev_t(const char *name)
 		return Root_NFS;
 	if (strcmp(name, "/dev/cifs") == 0)
 		return Root_CIFS;
+	if (strncmp(name, "fstag:", 6) == 0)
+		return Root_FSTAG;
 	if (strcmp(name, "/dev/ram") == 0)
 		return Root_RAM0;
 #ifdef CONFIG_BLOCK
@@ -552,6 +555,16 @@ void __init mount_root(void)
 		return;
 	}
 #endif
+	if (ROOT_DEV == Root_FSTAG && root_fs_names) {
+		/* Skip "fstag:" prefix and point to real tag */
+		root_device_name += 6;
+		if (!do_mount_root(root_device_name, root_fs_names,
+					root_mountflags, root_mount_data))
+			return;
+		panic("VFS: Unable to mount root \"fstag:%s\" via \"%s\"\n",
+			root_device_name, root_fs_names);
+	}
+
 #ifdef CONFIG_BLOCK
 	{
 		int err = create_dev("/dev/root", ROOT_DEV);
-- 
2.25.4

