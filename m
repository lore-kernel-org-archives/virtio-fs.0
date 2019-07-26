From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:10:59 +0100
Message-Id: <20190726091103.23503-2-stefanha@redhat.com>
In-Reply-To: <20190726091103.23503-1-stefanha@redhat.com>
References: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/5] virtiofsd: skip unnecessary
	vu_queue_get_avail_bytes()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

When debug output is disabled there is no need to calculate the number
of in/out bytes available.

There is also no need to skip a request if there are 0 out bytes.  The
request parsing code already handles invalid requests.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_virtio.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 083e4fc317..d543c6d30f 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -507,18 +507,16 @@ static void *fv_queue_thread(void *opaque)
                ret = pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
                assert(ret == 0); /* there is no possible error case */
 
-               /* out is from guest, in is too guest */
-               unsigned int in_bytes, out_bytes;
-               vu_queue_get_avail_bytes(dev, q, &in_bytes, &out_bytes, ~0, ~0);
+               if (se->debug) {
+                       /* out is from guest, in is too guest */
+                       unsigned int in_bytes, out_bytes;
+                       vu_queue_get_avail_bytes(dev, q, &in_bytes, &out_bytes, ~0, ~0);
 
-               if (se->debug)
                        fuse_debug("%s: Queue %d gave evalue: %zx available: in: %u out: %u\n",
 				  __func__, qi->qidx, (size_t)evalue, in_bytes,
 				  out_bytes);
-
-               if (!out_bytes) {
-                       goto next;
                }
+
                while (1) {
                        bool allocated_bufv = false;
                        struct fuse_bufvec bufv;
@@ -708,7 +706,6 @@ static void *fv_queue_thread(void *opaque)
                        elem = NULL;
                 }
 
-next:
                 pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
         }
         pthread_mutex_destroy(&ch.lock);
-- 
2.21.0

