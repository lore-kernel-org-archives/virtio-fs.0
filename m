From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 19 Aug 2020 18:19:52 -0400
Message-Id: <20200819221956.845195-15-vgoyal@redhat.com>
In-Reply-To: <20200819221956.845195-1-vgoyal@redhat.com>
References: <20200819221956.845195-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 14/18] fuse,dax: add DAX mmap support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com
Cc: dan.j.williams@intel.com, vgoyal@redhat.com, miklos@szeredi.hu

From: Stefan Hajnoczi <stefanha@redhat.com>

Add DAX mmap() support.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 fs/fuse/file.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 99457d0b14b9..f1ad8b95b546 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2841,10 +2841,15 @@ static const struct vm_operations_struct fuse_file_vm_ops = {
 	.page_mkwrite	= fuse_page_mkwrite,
 };
 
+static int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma);
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fuse_file *ff = file->private_data;
 
+	/* DAX mmap is superior to direct_io mmap */
+	if (IS_DAX(file_inode(file)))
+		return fuse_dax_mmap(file, vma);
+
 	if (ff->open_flags & FOPEN_DIRECT_IO) {
 		/* Can't provide the coherency needed for MAP_SHARED */
 		if (vma->vm_flags & VM_MAYSHARE)
@@ -2863,9 +2868,63 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static vm_fault_t __fuse_dax_fault(struct vm_fault *vmf,
+				   enum page_entry_size pe_size, bool write)
+{
+	vm_fault_t ret;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	pfn_t pfn;
+
+	if (write)
+		sb_start_pagefault(sb);
+
+	ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &fuse_iomap_ops);
+
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+
+	if (write)
+		sb_end_pagefault(sb);
+
+	return ret;
+}
+
+static vm_fault_t fuse_dax_fault(struct vm_fault *vmf)
+{
+	return __fuse_dax_fault(vmf, PE_SIZE_PTE,
+				vmf->flags & FAULT_FLAG_WRITE);
+}
+
+static vm_fault_t fuse_dax_huge_fault(struct vm_fault *vmf,
+			       enum page_entry_size pe_size)
+{
+	return __fuse_dax_fault(vmf, pe_size, vmf->flags & FAULT_FLAG_WRITE);
+}
+
+static vm_fault_t fuse_dax_page_mkwrite(struct vm_fault *vmf)
+{
+	return __fuse_dax_fault(vmf, PE_SIZE_PTE, true);
+}
+
+static vm_fault_t fuse_dax_pfn_mkwrite(struct vm_fault *vmf)
+{
+	return __fuse_dax_fault(vmf, PE_SIZE_PTE, true);
+}
+
+static const struct vm_operations_struct fuse_dax_vm_ops = {
+	.fault		= fuse_dax_fault,
+	.huge_fault	= fuse_dax_huge_fault,
+	.page_mkwrite	= fuse_dax_page_mkwrite,
+	.pfn_mkwrite	= fuse_dax_pfn_mkwrite,
+};
+
 static int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return -EINVAL; /* TODO */
+	file_accessed(file);
+	vma->vm_ops = &fuse_dax_vm_ops;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	return 0;
 }
 
 static int convert_fuse_file_lock(struct fuse_conn *fc,
@@ -3938,6 +3997,7 @@ static const struct file_operations fuse_file_operations = {
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.flock		= fuse_file_flock,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
-- 
2.25.4

