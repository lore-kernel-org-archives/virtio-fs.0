From: Eryu Guan <eguan@linux.alibaba.com>
Date: Wed,  6 May 2020 23:20:44 +0800
Message-Id: <1588778444-28375-1-git-send-email-eguan@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RFC] fuse: invalidate inode attr in writeback
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

Under writeback mode, inode->i_blocks is not updated, making utils like
du read st.blocks as 0.

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
  # stat -c %s,%b /mnt/virtiofs/testfile
  4096,0	  <==== i_size is correct, but block usage is 0

Fix it by invalidating attr in fuse_write_end(), like other write paths.

Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
 fs/fuse/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9d67b830fb7a..3c875104ca11 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2228,6 +2228,7 @@ static int fuse_write_end(struct file *file, struct address_space *mapping,
 	}
 
 	fuse_write_update_size(inode, pos + copied);
+	fuse_invalidate_attr(inode);
 	set_page_dirty(page);
 
 unlock:
-- 
1.8.3.1


