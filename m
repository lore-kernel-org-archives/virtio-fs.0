From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  1 Sep 2020 10:26:33 -0400
Message-Id: <20200901142634.1227109-2-vgoyal@redhat.com>
In-Reply-To: <20200901142634.1227109-1-vgoyal@redhat.com>
References: <20200901142634.1227109-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] fuse,
	dax: Use correct config option CONFIG_FUSE_DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: vgoyal@redhat.com

Correct config option to use is CONFIG_FUSE_DAX and not CONFIG_VIRTIO_FS_DAX.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7b53ae43860c..380577159c6e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3480,6 +3480,6 @@ void fuse_init_file_inode(struct inode *inode)
 	init_waitqueue_head(&fi->page_waitq);
 	fi->writepages = RB_ROOT;
 
-	if (IS_ENABLED(CONFIG_VIRTIO_FS_DAX))
+	if (IS_ENABLED(CONFIG_FUSE_DAX))
 		fuse_dax_inode_init(inode);
 }
-- 
2.25.4

