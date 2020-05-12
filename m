From: Eryu Guan <eguan@linux.alibaba.com>
Date: Tue, 12 May 2020 10:29:04 +0800
Message-Id: <20200512022904.75689-1-eguan@linux.alibaba.com>
In-Reply-To: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
References: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2] fuse: invalidate inode attr in writeback
	cache mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org
Cc: virtio-fs@redhat.com, miklos@szeredi.hu

Under writeback mode, inode->i_blocks is not updated, making utils du
read st.blocks as 0.

For example, when using virtiofs (cache=always & nondax mode) with
writeback_cache enabled, writing a new file and check its disk usage
with du, du reports 0 usage.

  # uname -r
  5.6.0-rc6+
  # mount -t virtiofs virtiofs /mnt/virtiofs
  # rm -f /mnt/virtiofs/testfile

  # create new file and do extend write
  # xfs_io -fc "pwrite 0 4k" /mnt/virtiofs/testfile
  wrote 4096/4096 bytes at offset 0
  4 KiB, 1 ops; 0.0001 sec (28.103 MiB/sec and 7194.2446 ops/sec)
  # du -k /mnt/virtiofs/testfile
  0               <==== disk usage is 0
  # stat -c %s,%b /mnt/virtiofs/testfile
  4096,0          <==== i_size is correct, but st_blocks is 0

Fix it by invalidating attr in fuse_flush(), so we get up-to-date attr
from server on next getattr.

Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
v2:
- do fuse_invalidate_attr() in fuse_flush() as Miklos suggested

 fs/fuse/file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9d67b830fb7a..4bb399caec01 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -445,8 +445,9 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	err = 0;
 	if (fc->no_flush)
-		return 0;
+		goto inval_attr_out;
 
 	err = write_inode_now(inode, 1);
 	if (err)
@@ -475,6 +476,14 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 		fc->no_flush = 1;
 		err = 0;
 	}
+
+inval_attr_out:
+	/*
+	 * In memory i_blocks is not maintained by fuse, if writeback cache is
+	 * enabled, i_blocks from cached attr may not be accurate.
+	 */
+	if (!err && fc->writeback_cache)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
-- 
2.26.1.107.gefe3874

