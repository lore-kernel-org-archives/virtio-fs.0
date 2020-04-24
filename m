DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=gfc0cFO2L1HUkwddTCsuj4a1zB9/jwWzyBDO+mCQarU=;
	b=BLtx0N5LC85qAEv11FxLkhD7+543mklwOA7DxGaz3qkPFpdnaz1m7zbbl3uVeEGQ0D
	ORDeFnGX68cXXK4ozkw24hStQgus/kwSbJcFYz8wTJwea9ogyQ9HGMSFUCy9lU0AgVZC
	D2/IIWNRLKY2JTEZ7YgoDEeOi2H30WOoVG8Ds=
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Fri, 24 Apr 2020 15:25:39 +0900
Message-Id: <20200424062540.23679-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] fuse: virtiofs: Fix nullptr dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

virtiofs device implementations are allowed to provide more than one
request queue.  In this case `fsvq->fud` would not be initialized,
leading to a nullptr dereference later during driver initialization.

Make sure that `fsvq->fud` is initialized for all request queues even if
the driver doesn't use them.

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
---
 fs/fuse/virtio_fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index bade747689033..d3c38222a7e4e 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1066,10 +1066,13 @@ static int virtio_fs_fill_super(struct super_block *sb)
 	}
 
 	err = -ENOMEM;
-	/* Allocate fuse_dev for hiprio and notification queues */
-	for (i = 0; i < VQ_REQUEST; i++) {
+	/* Allocate fuse_dev for all queues except the first request queue. */
+	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
+		if (i == VQ_REQUEST)
+			continue;
+
 		fsvq->fud = fuse_dev_alloc();
 		if (!fsvq->fud)
 			goto err_free_fuse_devs;
-- 
2.26.2.303.gf8c07b1a785-goog


