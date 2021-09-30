From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:44 -0400
Message-Id: <20210930143850.1188628-3-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-1-vgoyal@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/8] virtiofs: Fix a comment about fuse_dev
	allocation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com
Cc: vgoyal@redhat.com

Now virtiofs allocates fuse_dev for all queues and does not rely on fuse
common code to allocate for request queue. Fix the comment.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b9256b8f277f..f7c58a4b996d 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1307,7 +1307,7 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
 	}
 
 	err = -ENOMEM;
-	/* Allocate fuse_dev for hiprio and notification queues */
+	/* Allocate fuse_dev for all the queues */
 	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
-- 
2.31.1

