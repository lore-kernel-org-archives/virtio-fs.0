From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:46 -0400
Message-Id: <20190716210051.11724-2-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/6] fuse: Continue to wait if inline reclaim
	returns null
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

It is possible that inline reclaim returns null. Continue to wait for free
range in that case.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d9bada37d8ef..310fb22b31bd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -4074,8 +4074,11 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
 		if (dmap)
 			return dmap;
 
-		if (fi->nr_dmaps)
-			return inode_reclaim_first_dmap(fc, inode);
+		if (fi->nr_dmaps) {
+			dmap = inode_reclaim_first_dmap(fc, inode);
+			if (dmap)
+				return dmap;
+		}
 		/*
 		 * There are no mappings which can be reclaimed.
 		 * Wait for one.
-- 
2.20.1

