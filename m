From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:20 +0800
Message-Id: <20190416180322.65113-8-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 7/9] fuse: return early if punch_hole fails
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We don't have to clear FUSE_I_SIZE_UNSTABLE if punch_hole fails at
filemap_write_and_wait_rang(), since the bit is not set yet.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 620326e..712fd97 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3585,7 +3585,7 @@ static long __fuse_file_fallocate(struct file *file, int mode,
 		err = filemap_write_and_wait_range(inode->i_mapping, offset,
 							endbyte);
 		if (err)
-			goto out;
+			return err;
 		fuse_sync_writes(inode);
 	}
 
-- 
1.8.3.1

