From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  6 May 2021 14:43:04 -0400
Message-Id: <20210506184304.321645-3-vgoyal@redhat.com>
In-Reply-To: <20210506184304.321645-1-vgoyal@redhat.com>
References: <20210506184304.321645-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofs,
	dax: Fixed smatch warning about ret being uninitialized
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: dan.carpenter@oracle.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org

Dan reported a smatch warning about "ret" being uninitialized. Fix it.

fs/fuse/dax.c:197 dmap_removemapping_list() error: uninitialized symbol 'ret'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dax.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index f06fdad3f7b1..1608b6606ef0 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -253,7 +253,10 @@ static int dmap_removemapping_list(struct inode *inode, unsigned int num,
 	struct fuse_removemapping_one *remove_one, *ptr;
 	struct fuse_removemapping_in inarg;
 	struct fuse_dax_mapping *dmap;
-	int ret, i = 0, nr_alloc;
+	int ret = 0, i = 0, nr_alloc;
+
+	if (!num)
+		return ret;
 
 	nr_alloc = min_t(unsigned int, num, FUSE_REMOVEMAPPING_MAX_ENTRY);
 	remove_one = kmalloc_array(nr_alloc, sizeof(*remove_one), GFP_NOFS);
-- 
2.25.4

