From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  4 Mar 2020 05:15:11 +0800
Message-Id: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] fuse: make written data persistent after writing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org
Cc: virtio-fs@redhat.com

If this is a DSYNC write, make sure we push it to stable storage now
that we've written data.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
This patch is based on 5.5-rc5.

 fs/fuse/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a63d779eac10..08e3df618d7f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1541,6 +1541,8 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (res > 0)
 		fuse_write_update_size(inode, iocb->ki_pos);
 	inode_unlock(inode);
+	if (res > 0)
+		res = generic_write_sync(iocb, res);
 
 	return res;
 }
-- 
1.8.3.1


