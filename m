Date: Wed, 7 Jul 2021 17:04:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210707210404.GB244500@redhat.com>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210622081217.GA2975@lst.de>
	<YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
	<20210629205048.GE5231@redhat.com> <20210630053601.GA29241@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630053601.GA29241@lst.de>
Subject: Re: [Virtio-fs] [PATCH 3/2] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Wed, Jun 30, 2021 at 07:36:01AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 29, 2021 at 04:50:48PM -0400, Vivek Goyal wrote:
> > May be we should modify mount_block_root() code so that it does not
> > require that extra "\0". Possibly zero initialize page and that should
> > make sure list_bdev_fs_names() does not have to worry about it.
> > 
> > It is possible that a page gets full from the list of filesystems, and
> > last byte on page is terminating null. In that case just zeroing page
> > will not help. We can keep track of some sort of end pointer and make
> > sure we are not searching beyond that for valid filesystem types.
> > 
> > end = page + PAGE_SIZE - 1;
> > 
> > mount_block_root()
> > {
> > 	for (p = fs_names; p < end && *p; p += strlen(p)+1) {
> > 	}
> > }
> 
> Maybe.  To honest I'd prefer to not even touch this unrelated code given
> how full of landmines it is :)

Hi Christoph,

How about following patch. This applies on top of your patches. I noticed
that Al had suggested to return number of filesystems from helper
functions. I just did that and used that to iterate in the loop.

I tested it with a virtual block device (root=/dev/vda1) and it works.
I also filled page with garbage after allocation to make sure natually
occurring null is not there in the middle of page to terminate string.

If you like it, can you please incorporate it in your patches.

Thanks
Vivek

---
 fs/filesystems.c   |    5 ++++-
 include/linux/fs.h |    2 +-
 init/do_mounts.c   |    7 ++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

Index: redhat-linux/fs/filesystems.c
===================================================================
--- redhat-linux.orig/fs/filesystems.c	2021-07-07 16:12:08.890562576 -0400
+++ redhat-linux/fs/filesystems.c	2021-07-07 16:27:51.197620063 -0400
@@ -209,10 +209,11 @@ SYSCALL_DEFINE3(sysfs, int, option, unsi
 }
 #endif
 
-void __init list_bdev_fs_names(char *buf, size_t size)
+int __init list_bdev_fs_names(char *buf, size_t size)
 {
 	struct file_system_type *p;
 	size_t len;
+	int count = 0;
 
 	read_lock(&file_systems_lock);
 	for (p = file_systems; p; p = p->next) {
@@ -226,8 +227,10 @@ void __init list_bdev_fs_names(char *buf
 		memcpy(buf, p->name, len);
 		buf += len;
 		size -= len;
+		count++;
 	}
 	read_unlock(&file_systems_lock);
+	return count;
 }
 
 #ifdef CONFIG_PROC_FS
Index: redhat-linux/include/linux/fs.h
===================================================================
--- redhat-linux.orig/include/linux/fs.h	2021-07-07 15:36:43.224418935 -0400
+++ redhat-linux/include/linux/fs.h	2021-07-07 16:12:18.232949807 -0400
@@ -3622,7 +3622,7 @@ int proc_nr_dentry(struct ctl_table *tab
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_inodes(struct ctl_table *table, int write,
 		   void *buffer, size_t *lenp, loff_t *ppos);
-void __init list_bdev_fs_names(char *buf, size_t size);
+int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
Index: redhat-linux/init/do_mounts.c
===================================================================
--- redhat-linux.orig/init/do_mounts.c	2021-07-07 16:12:08.890562576 -0400
+++ redhat-linux/init/do_mounts.c	2021-07-07 16:23:32.308889444 -0400
@@ -391,15 +391,16 @@ void __init mount_block_root(char *name,
 	char *fs_names = page_address(page);
 	char *p;
 	char b[BDEVNAME_SIZE];
+	int num_fs, i;
 
 	scnprintf(b, BDEVNAME_SIZE, "unknown-block(%u,%u)",
 		  MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
 	if (root_fs_names)
 		split_fs_names(fs_names, root_fs_names);
 	else
-		list_bdev_fs_names(fs_names, PAGE_SIZE);
+		num_fs = list_bdev_fs_names(fs_names, PAGE_SIZE);
 retry:
-	for (p = fs_names; *p; p += strlen(p)+1) {
+	for (p = fs_names, i = 0; i < num_fs; p += strlen(p)+1, i++) {
 		int err = do_mount_root(name, p, flags, root_mount_data);
 		switch (err) {
 			case 0:
@@ -432,7 +433,7 @@ retry:
 	printk("List of all partitions:\n");
 	printk_all_partitions();
 	printk("No filesystem could mount root, tried: ");
-	for (p = fs_names; *p; p += strlen(p)+1)
+	for (p = fs_names, i = 0; i < num_fs; p += strlen(p)+1, i++)
 		printk(" %s", p);
 	printk("\n");
 	panic("VFS: Unable to mount root fs on %s", b);


