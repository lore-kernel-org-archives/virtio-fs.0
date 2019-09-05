From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:53 -0400
Message-Id: <20190905194859.16219-13-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 12/18] virtiofs: Use virtio_fs_free_devs() in
	error path
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

We already have an helper to cleanup fuse devices. Use that instead of
duplicating the code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index a76bd5a04521..40259368a6bd 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -999,8 +999,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 err_free_init_req:
 	fuse_request_free(init_req);
 err_free_fuse_devs:
-	for (i = 0; i < fs->nvqs; i++)
-		fuse_dev_free(fs->vqs[i].fud);
+	virtio_fs_free_devs(fs);
 err:
 	return err;
 }
-- 
2.20.1

