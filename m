From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  1 Aug 2019 17:54:06 +0100
Message-Id: <20190801165409.20121-2-stefanha@redhat.com>
In-Reply-To: <20190801165409.20121-1-stefanha@redhat.com>
References: <20190801165409.20121-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/4] virtiofsd: process requests in a thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

Introduce a thread pool so that fv_queue_thread() just pops
VuVirtqElements and hands them to the thread pool.  For the time being
only one worker thread is allowed since passthrough_ll.c is not
thread-safe yet.  Future patches will lift this restriction so that
multiple FUSE requests can be processed in parallel.

The main new concept is struct FVRequest, which contains both
VuVirtqElement and struct fuse_chan.  We now have fv_VuDev for a device,
fv_QueueInfo for a virtqueue, and FVRequest for a request.  Some of
fv_QueueInfo's fields are moved into FVRequest because they are
per-request.  The name FVRequest conforms to QEMU coding style and I
expect the struct fv_* types will be renamed in a future refactoring.

This patch series is not optimal.  fbuf reuse is dropped so each request
does malloc(se->bufsize), but there is no clean and cheap way to keep
this with a thread pool.  The vq_lock mutex is held for longer than
necessary, especially during the eventfd_write() syscall.  Performance
can be improved in the future.

prctl(2) had to be added to the seccomp whitelist because glib invokes
it.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_virtio.c | 491 ++++++++++++++++++--------------
 contrib/virtiofsd/seccomp.c     |   1 +
 2 files changed, 273 insertions(+), 219 deletions(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index d543c6d30f..0c52911144 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -29,26 +29,40 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <glib.h>
 
 #include "contrib/libvhost-user/libvhost-user.h"
 
 struct fv_VuDev;
 struct fv_QueueInfo {
         pthread_t thread;
+
+        /* This lock protects the VuVirtq preventing races between
+         * fv_queue_thread() and fv_queue_worker().
+         */
+        pthread_mutex_t vq_lock;
+
         struct fv_VuDev *virtio_dev;
 
         /* Our queue index, corresponds to array position */
         int       qidx;
         int       kick_fd;
         int       kill_fd; /* For killing the thread */
-
-        /* The element for the command currently being processed */
-        VuVirtqElement *qe;
-        /* If any of the qe vec elements (towards vmm) are unmappable */
-        unsigned int elem_bad_in;
-        bool      reply_sent;
 };
 
+/* A FUSE request */
+typedef struct {
+        VuVirtqElement elem;
+        struct fuse_chan ch;
+
+        /* Number of unmappable iovecs */
+        unsigned int bad_in_num;
+        unsigned int bad_out_num;
+
+        /* Used to complete requests that involve no reply */
+        bool reply_sent;
+} FVRequest;
+
 /* We pass the dev element into libvhost-user
  * and then use it to get back to the outer
  * container for other data.
@@ -186,8 +200,11 @@ static void copy_iov(struct iovec *src_iov, int src_count,
 int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
                     struct iovec *iov, int count)
 {
-        VuVirtqElement *elem;
-        VuVirtq *q;
+        FVRequest *req = container_of(ch, FVRequest, ch);
+        struct fv_QueueInfo *qi = ch->qi;
+        VuDev *dev = &se->virtio_dev->dev;
+        VuVirtq *q = vu_get_queue(dev, qi->qidx);
+        VuVirtqElement *elem = &req->elem;
         int ret = 0;
 
         assert(count >= 1);
@@ -200,11 +217,7 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
 
         /* unique == 0 is notification, which we don't support */
         assert (out->unique);
-        /* For virtio we always have ch */
-        assert(ch);
-        assert(!ch->qi->reply_sent);
-        elem = ch->qi->qe;
-        q = &ch->qi->virtio_dev->dev.vq[ch->qi->qidx];
+        assert(!req->reply_sent);
 
         /* The 'in' part of the elem is to qemu */
         unsigned int in_num = elem->in_num;
@@ -231,9 +244,15 @@ int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
         }
 
         copy_iov(iov, count, in_sg, in_num, tosend_len);
-        vu_queue_push(&se->virtio_dev->dev, q, elem, tosend_len);
-        vu_queue_notify(&se->virtio_dev->dev, q);
-        ch->qi->reply_sent = true;
+
+        pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        pthread_mutex_lock(&qi->vq_lock);
+        vu_queue_push(dev, q, elem, tosend_len);
+        vu_queue_notify(dev, q);
+        pthread_mutex_unlock(&qi->vq_lock);
+        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+
+        req->reply_sent = true;
 
 err:
 
@@ -249,9 +268,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                          struct iovec *iov, int count,
                          struct fuse_bufvec *buf, size_t len)
 {
+        FVRequest *req = container_of(ch, FVRequest, ch);
+        struct fv_QueueInfo *qi = ch->qi;
+        VuDev *dev = &se->virtio_dev->dev;
+        VuVirtq *q = vu_get_queue(dev, qi->qidx);
+        VuVirtqElement *elem = &req->elem;
         int ret = 0;
-        VuVirtqElement *elem;
-        VuVirtq *q;
 
         assert(count >= 1);
         assert(iov[0].iov_len >= sizeof(struct fuse_out_header));
@@ -271,15 +293,11 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
         /* unique == 0 is notification which we don't support */
         assert (out->unique);
 
-        /* For virtio we always have ch */
-        assert(ch);
-        assert(!ch->qi->reply_sent);
-        elem = ch->qi->qe;
-        q = &ch->qi->virtio_dev->dev.vq[ch->qi->qidx];
+        assert(!req->reply_sent);
 
         /* The 'in' part of the elem is to qemu */
         unsigned int in_num = elem->in_num;
-        unsigned int bad_in_num = ch->qi->elem_bad_in;
+        unsigned int bad_in_num = req->bad_in_num;
         struct iovec *in_sg = elem->in_sg;
         size_t in_len = iov_length(in_sg, in_num);
         size_t in_len_writeable = iov_length(in_sg, in_num - bad_in_num);
@@ -423,16 +441,219 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
 
         ret = 0;
 
-        vu_queue_push(&se->virtio_dev->dev, q, elem, tosend_len);
-        vu_queue_notify(&se->virtio_dev->dev, q);
+        pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        pthread_mutex_lock(&qi->vq_lock);
+        vu_queue_push(dev, q, elem, tosend_len);
+        vu_queue_notify(dev, q);
+        pthread_mutex_unlock(&qi->vq_lock);
+        pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
 
 err:
         if (ret == 0)
-                ch->qi->reply_sent = true;
+                req->reply_sent = true;
 
         return ret;
 }
 
+/* Process one FVRequest in a thread pool */
+static void fv_queue_worker(gpointer data, gpointer user_data)
+{
+        struct fv_QueueInfo *qi = user_data;
+        struct fuse_session *se = qi->virtio_dev->se;
+        struct VuDev *dev = &qi->virtio_dev->dev;
+        FVRequest *req = data;
+        VuVirtqElement *elem = &req->elem;
+        struct fuse_buf fbuf = {};
+        bool allocated_bufv = false;
+        struct fuse_bufvec bufv;
+        struct fuse_bufvec *pbufv;
+
+        assert(se->bufsize > sizeof(struct fuse_in_header));
+
+        /* An element contains one request and the space to send our response
+         * They're spread over multiple descriptors in a scatter/gather set
+         * and we can't trust the guest to keep them still; so copy in/out.
+         */
+        fbuf.mem = malloc(se->bufsize);
+        assert(fbuf.mem);
+
+        fuse_mutex_init(&req->ch.lock);
+        req->ch.fd = (int)0xdaff0d111;
+        req->ch.ctr = 1;
+        req->ch.qi = qi;
+
+        /* The 'out' part of the elem is from qemu */
+        unsigned int out_num = elem->out_num;
+        unsigned int out_num_readable = out_num - req->bad_out_num;
+        struct iovec *out_sg = elem->out_sg;
+        size_t out_len = iov_length(out_sg, out_num);
+        size_t out_len_readable = iov_length(out_sg, out_num_readable);
+        if (se->debug)
+                fuse_debug("%s: elem %d: with %d out desc of length %zd"
+                           " bad_in_num=%u bad_out_num=%u\n",
+                           __func__, elem->index, out_num,
+                           out_len, req->bad_in_num, req->bad_out_num);
+
+        /* The elem should contain a 'fuse_in_header' (in to fuse)
+         * plus the data based on the len in the header.
+         */
+        if (out_len_readable < sizeof(struct fuse_in_header)) {
+                fuse_err("%s: elem %d too short for in_header\n",
+                                __func__, elem->index);
+                assert(0); // TODO
+        }
+        if (out_len > se->bufsize) {
+                fuse_err("%s: elem %d too large for buffer\n",
+                                __func__, elem->index);
+                assert(0); // TODO
+        }
+        // Copy just the first element and look at it
+        copy_from_iov(&fbuf, 1, out_sg);
+
+        pbufv = NULL; /* Compiler thinks an unitialised path */
+        if (req->bad_in_num || req->bad_out_num) {
+                bool handled_unmappable = false;
+
+                if (out_num > 2 && out_num_readable >= 2 && !req->bad_in_num &&
+                                out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
+                                ((struct fuse_in_header *)fbuf.mem)->opcode ==
+                                FUSE_WRITE &&
+                                out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
+                        handled_unmappable = true;
+
+                        // copy the fuse_write_in header after the fuse_in_header
+                        fbuf.mem += out_sg->iov_len;
+                        copy_from_iov(&fbuf, 1, out_sg + 1);
+                        fbuf.mem -= out_sg->iov_len;
+                        fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
+
+                        // Allocate the bufv, with space for the rest of the iov
+                        allocated_bufv = true;
+                        pbufv = malloc(sizeof(struct fuse_bufvec) +
+                                        sizeof(struct fuse_buf) * (out_num - 2));
+
+                        pbufv->count = 1;
+                        pbufv->buf[0] = fbuf;
+
+                        size_t iovindex, pbufvindex;
+                        iovindex = 2; // 2 headers, separate iovs
+                        pbufvindex = 1; // 2 headers, 1 fusebuf
+
+                        for(; iovindex < out_num; iovindex++, pbufvindex++) {
+                                pbufv->count++;
+                                pbufv->buf[pbufvindex].pos = ~0; // Dummy
+                                pbufv->buf[pbufvindex].flags =
+                                        (iovindex < out_num_readable) ?
+                                        0 : FUSE_BUF_PHYS_ADDR;
+                                pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
+                                pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
+                        }
+                }
+
+                if (out_num == 2 && out_num_readable == 2 && req->bad_in_num &&
+                                out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
+                                ((struct fuse_in_header *)fbuf.mem)->opcode ==
+                                FUSE_READ &&
+                                out_sg[1].iov_len == sizeof(struct fuse_read_in)) {
+                        if (se->debug) {
+                                fuse_debug("Unmappable read case "
+                                           "in_num=%d bad_in_num=%d\n",
+                                           elem->in_num, req->bad_in_num);
+                        }
+                        handled_unmappable = true;
+                }
+
+                if (!handled_unmappable) {
+                        fuse_err("Unhandled unmappable element: out: %d(b:%d) in: %d(b:%d)",
+                                 out_num, req->bad_out_num,
+                                 elem->in_num, req->bad_in_num);
+                        fv_panic(dev, "Unhandled unmappable element");
+                }
+        }
+
+        if (!req->bad_out_num) {
+                if (out_num > 2 &&
+                                out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
+                                ((struct fuse_in_header *)fbuf.mem)->opcode ==
+                                FUSE_WRITE &&
+                                out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
+                        // For a write we don't actually need to copy the
+                        // data, we can just do it straight out of guest memory
+                        // but we must sitll copy the headers in case the guest
+                        // was nasty and changed them while we were using them.
+                        if (se->debug)
+                                fuse_debug("%s: Write special case\n", __func__);
+
+                        // copy the fuse_write_in header afte rthe fuse_in_header
+                        fbuf.mem += out_sg->iov_len;
+                        copy_from_iov(&fbuf, 1, out_sg + 1);
+                        fbuf.mem -= out_sg->iov_len;
+                        fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
+
+                        // Allocate the bufv, with space for the rest of the iov
+                        allocated_bufv = true;
+                        pbufv = malloc(sizeof(struct fuse_bufvec) +
+                                        sizeof(struct fuse_buf) * (out_num - 2));
+
+                        pbufv->count = 1;
+                        pbufv->buf[0] = fbuf;
+
+                        size_t iovindex, pbufvindex;
+                        iovindex = 2; // 2 headers, separate iovs
+                        pbufvindex = 1; // 2 headers, 1 fusebuf
+
+                        for(; iovindex < out_num; iovindex++, pbufvindex++) {
+                                pbufv->count++;
+                                pbufv->buf[pbufvindex].pos = ~0; // Dummy
+                                pbufv->buf[pbufvindex].flags = 0;
+                                pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
+                                pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
+                        }
+                } else {
+                        // Normal (non fast write) path
+
+                        // Copy the rest of the buffer
+                        fbuf.mem += out_sg->iov_len;
+                        copy_from_iov(&fbuf, out_num - 1, out_sg + 1);
+                        fbuf.mem -= out_sg->iov_len;
+                        fbuf.size = out_len;
+
+                        // TODO! Endianness of header
+
+                        // TODO: Add checks for fuse_session_exited
+                        bufv.buf[0] = fbuf;
+                        bufv.count = 1;
+                        pbufv = &bufv;
+                }
+        }
+        pbufv->idx = 0;
+        pbufv->off = 0;
+        fuse_session_process_buf_int(se, pbufv, &req->ch);
+
+        if (allocated_bufv) free(pbufv);
+
+        /* If the request has no reply, still recycle the virtqueue element */
+        if (!req->reply_sent) {
+                struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
+
+                if (se->debug) {
+                        fuse_debug("%s: elem %d no reply sent\n",
+                                   __func__, elem->index);
+                }
+
+                pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
+                pthread_mutex_lock(&qi->vq_lock);
+                vu_queue_push(dev, q, elem, 0);
+                vu_queue_notify(dev, q);
+                pthread_mutex_unlock(&qi->vq_lock);
+                pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+        }
+
+        pthread_mutex_destroy(&req->ch.lock);
+        free(fbuf.mem);
+        free(req);
+}
+
 /* Thread function for individual queues, created when a queue is 'started' */
 static void *fv_queue_thread(void *opaque)
 {
@@ -440,16 +661,14 @@ static void *fv_queue_thread(void *opaque)
         struct VuDev        *dev = &qi->virtio_dev->dev;
         struct VuVirtq      *q = vu_get_queue(dev, qi->qidx);
         struct fuse_session *se = qi->virtio_dev->se;
-        struct fuse_chan    ch;
-        struct fuse_buf     fbuf;
+        GThreadPool *pool;
 
-        fbuf.mem = NULL;
-        fbuf.flags = 0;
-
-        fuse_mutex_init(&ch.lock);
-        ch.fd = (int)0xdaff0d111;
-        ch.ctr = 1;
-        ch.qi = qi;
+        pool = g_thread_pool_new(fv_queue_worker, qi, 1 /* TODO max_threads */,
+                        TRUE, NULL);
+        if (!pool) {
+                fuse_err("%s: g_thread_pool_new failed\n", __func__);
+                return NULL;
+        }
 
         fuse_info("%s: Start for queue %d kick_fd %d\n",
                   __func__, qi->qidx, qi->kick_fd);
@@ -507,6 +726,8 @@ static void *fv_queue_thread(void *opaque)
                ret = pthread_rwlock_rdlock(&qi->virtio_dev->vu_dispatch_rwlock);
                assert(ret == 0); /* there is no possible error case */
 
+               pthread_mutex_lock(&qi->vq_lock);
+
                if (se->debug) {
                        /* out is from guest, in is too guest */
                        unsigned int in_bytes, out_bytes;
@@ -518,198 +739,26 @@ static void *fv_queue_thread(void *opaque)
                }
 
                while (1) {
-                       bool allocated_bufv = false;
-                       struct fuse_bufvec bufv;
-                       struct fuse_bufvec *pbufv;
                        unsigned int bad_in_num = 0, bad_out_num = 0;
-
-                       /* An element contains one request and the space to send our response
-                        * They're spread over multiple descriptors in a scatter/gather set
-                        * and we can't trust the guest to keep them still; so copy in/out.
-                        */
-                       VuVirtqElement *elem = vu_queue_pop(dev, q, sizeof(VuVirtqElement),
-                                                           &bad_in_num, &bad_out_num);
-                       if (!elem) {
+                       FVRequest *req = vu_queue_pop(dev, q, sizeof(FVRequest),
+                                                     &bad_in_num,
+                                                     &bad_out_num);
+                       if (!req) {
                                break;
                        }
 
-                       qi->qe = elem;
-                       qi->reply_sent = false;
-                       qi->elem_bad_in = bad_in_num;
+                       req->reply_sent = false;
+                       req->bad_in_num = bad_in_num;
+                       req->bad_out_num = bad_out_num;
 
-                       if (!fbuf.mem) {
-                               fbuf.mem = malloc(se->bufsize);
-                               assert(fbuf.mem);
-                               assert(se->bufsize > sizeof(struct fuse_in_header));
-                       }
-                       /* The 'out' part of the elem is from qemu */
-                       unsigned int out_num = elem->out_num;
-                       unsigned int out_num_readable = out_num - bad_out_num;
-                       struct iovec *out_sg = elem->out_sg;
-                       size_t out_len = iov_length(out_sg, out_num);
-                       size_t out_len_readable = iov_length(out_sg, out_num_readable);
-                       if (se->debug)
-                               fuse_debug("%s: elem %d: with %d out desc of length %zd"
-                                          " bad_in_num=%u bad_out_num=%u\n",
-					  __func__, elem->index, out_num,
-					  out_len, bad_in_num, bad_out_num);
-
-                       /* The elem should contain a 'fuse_in_header' (in to fuse)
-                        * plus the data based on the len in the header.
-                        */
-                       if (out_len_readable < sizeof(struct fuse_in_header)) {
-                               fuse_err("%s: elem %d too short for in_header\n",
-                                        __func__, elem->index);
-                               assert(0); // TODO
-                       }
-                       if (out_len > se->bufsize) {
-                               fuse_err("%s: elem %d too large for buffer\n",
-                                        __func__, elem->index);
-                               assert(0); // TODO
-                       }
-                       // Copy just the first element and look at it
-                       copy_from_iov(&fbuf, 1, out_sg);
-
-                       pbufv = NULL; /* Compiler thinks an unitialised path */
-                       if (bad_in_num || bad_out_num) {
-                           bool handled_unmappable = false;
-
-                           if (out_num > 2 && out_num_readable >= 2 && !bad_in_num &&
-                               out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
-                               ((struct fuse_in_header *)fbuf.mem)->opcode ==
-                                   FUSE_WRITE &&
-                               out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
-                               handled_unmappable = true;
-
-                               // copy the fuse_write_in header after the fuse_in_header
-                               fbuf.mem += out_sg->iov_len;
-                               copy_from_iov(&fbuf, 1, out_sg + 1);
-                               fbuf.mem -= out_sg->iov_len;
-                               fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
-
-                               // Allocate the bufv, with space for the rest of the iov
-                               allocated_bufv = true;
-                               pbufv = malloc(sizeof(struct fuse_bufvec) +
-                                              sizeof(struct fuse_buf) * (out_num - 2));
-
-                               pbufv->count = 1;
-                               pbufv->buf[0] = fbuf;
-
-                               size_t iovindex, pbufvindex;
-                               iovindex = 2; // 2 headers, separate iovs
-                               pbufvindex = 1; // 2 headers, 1 fusebuf
-
-                               for(; iovindex < out_num; iovindex++, pbufvindex++) {
-                                       pbufv->count++;
-                                       pbufv->buf[pbufvindex].pos = ~0; // Dummy
-                                       pbufv->buf[pbufvindex].flags =
-                                               (iovindex < out_num_readable) ?
-                                               0 : FUSE_BUF_PHYS_ADDR;
-                                       pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
-                                       pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
-                               }
-                           }
-
-                           if (out_num == 2 && out_num_readable == 2 && bad_in_num &&
-                               out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
-                               ((struct fuse_in_header *)fbuf.mem)->opcode ==
-                                   FUSE_READ &&
-                               out_sg[1].iov_len == sizeof(struct fuse_read_in)) {
-                               if (se->debug) {
-                                   fuse_debug("Unmappable read case "
-                                              "in_num=%d bad_in_num=%d\n",
-                                              elem->in_num, bad_in_num);
-                               }
-                               handled_unmappable = true;
-                           }
-
-                           if (!handled_unmappable) {
-                               fuse_err("Unhandled unmappable element: out: %d(b:%d) in: %d(b:%d)",
-                                        out_num, bad_out_num,
-                                        elem->in_num, bad_in_num);
-                               fv_panic(dev, "Unhandled unmappable element");
-                           }
-                       }
-
-                       if (!bad_out_num) {
-                           if (out_num > 2 &&
-                               out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
-                               ((struct fuse_in_header *)fbuf.mem)->opcode ==
-                                   FUSE_WRITE &&
-                               out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
-                                   // For a write we don't actually need to copy the
-                                   // data, we can just do it straight out of guest memory
-                                   // but we must sitll copy the headers in case the guest
-                                   // was nasty and changed them while we were using them.
-                                   if (se->debug)
-                                           fuse_debug("%s: Write special case\n", __func__);
-
-                                   // copy the fuse_write_in header afte rthe fuse_in_header
-                                   fbuf.mem += out_sg->iov_len;
-                                   copy_from_iov(&fbuf, 1, out_sg + 1);
-                                   fbuf.mem -= out_sg->iov_len;
-                                   fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
-
-                                   // Allocate the bufv, with space for the rest of the iov
-                                   allocated_bufv = true;
-                                   pbufv = malloc(sizeof(struct fuse_bufvec) +
-                                                  sizeof(struct fuse_buf) * (out_num - 2));
-
-                                   pbufv->count = 1;
-                                   pbufv->buf[0] = fbuf;
-
-                                   size_t iovindex, pbufvindex;
-                                   iovindex = 2; // 2 headers, separate iovs
-                                   pbufvindex = 1; // 2 headers, 1 fusebuf
-
-                                   for(; iovindex < out_num; iovindex++, pbufvindex++) {
-                                           pbufv->count++;
-                                           pbufv->buf[pbufvindex].pos = ~0; // Dummy
-                                           pbufv->buf[pbufvindex].flags = 0;
-                                           pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
-                                           pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
-                                   }
-                           } else {
-                                   // Normal (non fast write) path
-
-                                   // Copy the rest of the buffer
-                                   fbuf.mem += out_sg->iov_len;
-                                   copy_from_iov(&fbuf, out_num - 1, out_sg + 1);
-                                   fbuf.mem -= out_sg->iov_len;
-                                   fbuf.size = out_len;
-
-                                   // TODO! Endianness of header
-
-                                   // TODO: Add checks for fuse_session_exited
-                                   bufv.buf[0] = fbuf;
-                                   bufv.count = 1;
-                                   pbufv = &bufv;
-                           }
-                       }
-                       pbufv->idx = 0;
-                       pbufv->off = 0;
-                       fuse_session_process_buf_int(se, pbufv, &ch);
-
-                       if (allocated_bufv) free(pbufv);
-
-                       if (!qi->reply_sent) {
-			       if (se->debug) {
-				       fuse_debug("%s: elem %d no reply sent\n",
-					          __func__, elem->index);
-			       }
-                               /* I think we've still got to recycle the element */
-                               vu_queue_push(dev, q, elem, 0);
-                               vu_queue_notify(dev, q);
-                       }
-                       qi->qe = NULL;
-                       free(elem);
-                       elem = NULL;
+                       g_thread_pool_push(pool, req, NULL);
                 }
 
+                pthread_mutex_unlock(&qi->vq_lock);
                 pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
         }
-        pthread_mutex_destroy(&ch.lock);
-        free(fbuf.mem);
+
+        g_thread_pool_free(pool, FALSE, TRUE);
 
         return NULL;
 }
@@ -760,6 +809,9 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 
                 ourqi->kill_fd = eventfd(0, EFD_CLOEXEC | EFD_SEMAPHORE);
                 assert(ourqi->kill_fd != -1);
+
+                pthread_mutex_init(&ourqi->vq_lock, NULL);
+
                 if (pthread_create(&ourqi->thread, NULL,  fv_queue_thread,
                                    ourqi)) {
                         fuse_err("%s: Failed to create thread for queue %d\n",
@@ -780,6 +832,7 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
                        fuse_err("%s: Failed to join thread idx %d err %d\n",
                                 __func__, qidx, ret);
                 }
+                pthread_mutex_destroy(&ourqi->vq_lock);
                 close(ourqi->kill_fd);
                 ourqi->kick_fd = -1;
                 free(vud->qi[qidx]);
diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index cea4cc5f60..5f1c873b82 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -58,6 +58,7 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(open),
 	SCMP_SYS(openat),
 	SCMP_SYS(ppoll),
+	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
 	SCMP_SYS(preadv),
 	SCMP_SYS(pwrite64),
 	SCMP_SYS(read),
-- 
2.21.0

