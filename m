From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 14 Jul 2021 16:23:21 -0400
Message-Id: <20210714202321.59729-4-vgoyal@redhat.com>
In-Reply-To: <20210714202321.59729-1-vgoyal@redhat.com>
References: <20210714202321.59729-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 3/3] fs: simplify get_filesystem_list /
	get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: viro@zeniv.linux.org.uk
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

From: Christoph Hellwig <hch@lst.de>

Just output the '\0' separate list of supported file systems for block
devices directly rather than going through a pointless round of string
manipulation.

Based on an earlier patch from Al Viro <viro@zeniv.linux.org.uk>.

Vivek:
Modified list_bdev_fs_names() and split_fs_names() to return number of
null terminted strings to caller. Callers now use that information to
loop through all the strings instead of relying on one extra null char
being present at the end.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/filesystems.c   | 27 +++++++++++++++----------
 include/linux/fs.h |  2 +-
 init/do_mounts.c   | 49 ++++++++++++++++++++--------------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 90b8d879fbaf..58b9067b2391 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -209,21 +209,28 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
 }
 #endif
 
-int __init get_filesystem_list(char *buf)
+int __init list_bdev_fs_names(char *buf, size_t size)
 {
-	int len = 0;
-	struct file_system_type * tmp;
+	struct file_system_type *p;
+	size_t len;
+	int count = 0;
 
 	read_lock(&file_systems_lock);
-	tmp = file_systems;
-	while (tmp && len < PAGE_SIZE - 80) {
-		len += sprintf(buf+len, "%s\t%s\n",
-			(tmp->fs_flags & FS_REQUIRES_DEV) ? "" : "nodev",
-			tmp->name);
-		tmp = tmp->next;
+	for (p = file_systems; p; p = p->next) {
+		if (!(p->fs_flags & FS_REQUIRES_DEV))
+			continue;
+		len = strlen(p->name) + 1;
+		if (len > size) {
+			pr_warn("%s: truncating file system list\n", __func__);
+			break;
+		}
+		memcpy(buf, p->name, len);
+		buf += len;
+		size -= len;
+		count++;
 	}
 	read_unlock(&file_systems_lock);
-	return len;
+	return count;
 }
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..c76dfc01cf9d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3622,7 +3622,7 @@ int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_inodes(struct ctl_table *table, int write,
 		   void *buffer, size_t *lenp, loff_t *ppos);
-int __init get_filesystem_list(char *buf);
+int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
diff --git a/init/do_mounts.c b/init/do_mounts.c
index bdeb90b8d669..9b4a1f877e47 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -338,32 +338,22 @@ __setup("rootflags=", root_data_setup);
 __setup("rootfstype=", fs_names_setup);
 __setup("rootdelay=", root_delay_setup);
 
-static void __init split_fs_names(char *page, char *names)
+static int __init split_fs_names(char *page, char *names)
 {
-	strcpy(page, root_fs_names);
-	while (*page++) {
-		if (page[-1] == ',')
-			page[-1] = '\0';
-	}
-	*page = '\0';
-}
-
-static void __init get_all_fs_names(char *page)
-{
-	int len = get_filesystem_list(page);
-	char *s = page, *p, *next;
+	int count = 0;
+	char *p = page;
 
-	page[len] = '\0';
-	for (p = page - 1; p; p = next) {
-		next = strchr(++p, '\n');
-		if (*p++ != '\t')
-			continue;
-		while ((*s++ = *p++) != '\n')
-			;
-		s[-1] = '\0';
+	strcpy(p, root_fs_names);
+	while (*p++) {
+		if (p[-1] == ',')
+			p[-1] = '\0';
 	}
+	*p = '\0';
+
+	for (p = page; *p; p += strlen(p)+1)
+		count++;
 
-	*s = '\0';
+	return count;
 }
 
 static int __init do_mount_root(const char *name, const char *fs,
@@ -409,15 +399,16 @@ void __init mount_block_root(char *name, int flags)
 	char *fs_names = page_address(page);
 	char *p;
 	char b[BDEVNAME_SIZE];
+	int num_fs, i;
 
 	scnprintf(b, BDEVNAME_SIZE, "unknown-block(%u,%u)",
 		  MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
 	if (root_fs_names)
-		split_fs_names(fs_names, root_fs_names);
+		num_fs = split_fs_names(fs_names, root_fs_names);
 	else
-		get_all_fs_names(fs_names);
+		num_fs = list_bdev_fs_names(fs_names, PAGE_SIZE);
 retry:
-	for (p = fs_names; *p; p += strlen(p)+1) {
+	for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1) {
 		int err = do_mount_root(name, p, flags, root_mount_data);
 		switch (err) {
 			case 0:
@@ -450,7 +441,7 @@ void __init mount_block_root(char *name, int flags)
 	printk("List of all partitions:\n");
 	printk_all_partitions();
 	printk("No filesystem could mount root, tried: ");
-	for (p = fs_names; *p; p += strlen(p)+1)
+	for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1)
 		printk(" %s", p);
 	printk("\n");
 	panic("VFS: Unable to mount root fs on %s", b);
@@ -551,13 +542,15 @@ static int __init mount_nodev_root(void)
 {
 	char *fs_names, *fstype;
 	int err = -EINVAL;
+	int num_fs, i;
 
 	fs_names = (void *)__get_free_page(GFP_KERNEL);
 	if (!fs_names)
 		return -EINVAL;
-	split_fs_names(fs_names, root_fs_names);
+	num_fs = split_fs_names(fs_names, root_fs_names);
 
-	for (fstype = fs_names; *fstype; fstype += strlen(fstype) + 1) {
+	for (i = 0, fstype = fs_names; i < num_fs;
+	     i++, fstype += strlen(fstype) + 1) {
 		if (!fs_is_nodev(fstype))
 			continue;
 		err = do_mount_root(root_device_name, fstype, root_mountflags,
-- 
2.31.1

