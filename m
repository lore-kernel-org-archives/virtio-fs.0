From: Connor Kuehl <ckuehl@redhat.com>
Date: Thu, 18 Mar 2021 08:52:23 -0500
Message-Id: <20210318135223.1342795-4-ckuehl@redhat.com>
In-Reply-To: <20210318135223.1342795-1-ckuehl@redhat.com>
References: <20210318135223.1342795-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 3/3] fuse: fix typo for fuse_conn.max_pages
	comment
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

'Maxmum' -> 'Maximum'

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
 fs/fuse/fuse_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f0e4ee906464..8bdee79ba593 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -552,7 +552,7 @@ struct fuse_conn {
 	/** Maximum write size */
 	unsigned max_write;
 
-	/** Maxmum number of pages that can be used in a single request */
+	/** Maximum number of pages that can be used in a single request */
 	unsigned int max_pages;
 
 #if IS_ENABLED(CONFIG_VIRTIO_FS)
-- 
2.30.2

