From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed,  4 Mar 2020 11:58:44 -0500
Message-Id: <20200304165845.3081-20-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-1-vgoyal@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 19/20] fuse: Take inode lock for dax inode
	truncation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: mst@redhat.com, vgoyal@redhat.com

When a file is opened with O_TRUNC, we need to make sure that any other
DAX operation is not in progress. DAX expects i_size to be stable.

In fuse_iomap_begin() we check for i_size at multiple places and we expect
i_size to not change.

Another problem is, if we setup a mapping in fuse_iomap_begin(), and
file gets truncated and dax read/write happens, KVM currently hangs.
It tries to fault in a page which does not exist on host (file got
truncated). It probably requries fixing in KVM.

So for now, take inode lock. Once KVM is fixed, we might have to
have a look at it again.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 561428b66101..8b264fcb9b3c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -483,7 +483,7 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	int err;
 	bool is_wb_truncate = (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc &&
-			  fc->writeback_cache;
+			  (fc->writeback_cache || IS_DAX(inode));
 
 	err = generic_file_open(inode, file);
 	if (err)
-- 
2.20.1

