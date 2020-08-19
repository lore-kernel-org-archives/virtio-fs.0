From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 19 Aug 2020 18:19:53 -0400
Message-Id: <20200819221956.845195-16-vgoyal@redhat.com>
In-Reply-To: <20200819221956.845195-1-vgoyal@redhat.com>
References: <20200819221956.845195-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 15/18] fuse,
	virtiofs: Define dax address space operations
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

This is done along the lines of ext4 and xfs. I primarily wanted ->writepages
hook at this time so that I could call into dax_writeback_mapping_range().
This in turn will decide which pfns need to be written back.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f1ad8b95b546..0eecb4097c14 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2669,6 +2669,16 @@ static int fuse_writepages_fill(struct page *page,
 	return err;
 }
 
+static int fuse_dax_writepages(struct address_space *mapping,
+				struct writeback_control *wbc)
+{
+
+	struct inode *inode = mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	return dax_writeback_mapping_range(mapping, fc->dax_dev, wbc);
+}
+
 static int fuse_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -4021,6 +4031,13 @@ static const struct address_space_operations fuse_file_aops  = {
 	.write_end	= fuse_write_end,
 };
 
+static const struct address_space_operations fuse_dax_file_aops  = {
+	.writepages	= fuse_dax_writepages,
+	.direct_IO	= noop_direct_IO,
+	.set_page_dirty	= noop_set_page_dirty,
+	.invalidatepage	= noop_invalidatepage,
+};
+
 void fuse_init_file_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -4036,6 +4053,8 @@ void fuse_init_file_inode(struct inode *inode)
 	fi->writepages = RB_ROOT;
 	fi->dmap_tree = RB_ROOT_CACHED;
 
-	if (fc->dax_dev)
+	if (fc->dax_dev) {
 		inode->i_flags |= S_DAX;
+		inode->i_data.a_ops = &fuse_dax_file_aops;
+	}
 }
-- 
2.25.4

