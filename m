From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  1 Sep 2020 10:26:34 -0400
Message-Id: <20200901142634.1227109-3-vgoyal@redhat.com>
In-Reply-To: <20200901142634.1227109-1-vgoyal@redhat.com>
References: <20200901142634.1227109-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] fuse, dax: Save dax device in fuse_conn_dax
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: vgoyal@redhat.com

This is needed later in fuse_iomap_begin to fill iomap->dax_dev. Otherwise
dax generic code (dax_iomap_rw()) returns -EOPNOTSUPP.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index c7099eec17b4..aa89173234c1 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1296,6 +1296,7 @@ int fuse_dax_conn_alloc(struct fuse_conn *fc, struct dax_device *dax_dev)
 
 	fcd->nr_free_ranges = nr_ranges;
 	fcd->nr_ranges = nr_ranges;
+	fcd->dev = dax_dev;
 
 	fc->dax = fcd;
 	return 0;
-- 
2.25.4

