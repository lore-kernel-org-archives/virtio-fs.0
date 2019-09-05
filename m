From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:59 -0400
Message-Id: <20190905194859.16219-19-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 18/18] virtiofs: Remove TODO item from
	virtio_fs_free_devs()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, miklos@szeredi.hu
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com

virtio_fs_free_devs() is now called from ->kill_sb(). By this time
all device queues have been quiesced. I am assuming that while
->kill_sb() is in progress, another mount instance will wait for
it to finish (sb->s_umount mutex provides mutual exclusion).

W.r.t ->remove path, we should be fine as we are not touching vdev
or virtqueues. And we have reference on virtio_fs object, so we know
rest of the data structures are valid.

So I can't see the need of any additional locking yet.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index eadaea6eb8e2..61aa3eba7b22 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -200,8 +200,6 @@ static void virtio_fs_free_devs(struct virtio_fs *fs)
 {
 	unsigned int i;
 
-	/* TODO lock */
-
 	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
-- 
2.20.1

