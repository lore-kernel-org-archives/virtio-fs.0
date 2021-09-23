From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 23 Sep 2021 17:25:22 +0800
Message-Id: <20210923092526.72341-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v5 1/5] fuse: add fuse_should_enable_dax() helper
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

This is in prep for following per-file DAX checking.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/dax.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 281d79f8b3d3..28db96ea23e2 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1330,11 +1330,19 @@ static const struct address_space_operations fuse_dax_file_aops  = {
 	.invalidatepage	= noop_invalidatepage,
 };
 
-void fuse_dax_inode_init(struct inode *inode)
+static bool fuse_should_enable_dax(struct inode *inode)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (!fc->dax)
+		return false;
+
+	return true;
+}
+
+void fuse_dax_inode_init(struct inode *inode)
+{
+	if (!fuse_should_enable_dax(inode))
 		return;
 
 	inode->i_flags |= S_DAX;
-- 
2.27.0

