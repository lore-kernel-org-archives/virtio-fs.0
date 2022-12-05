Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:05 +0100
Message-Id: <20221205095228.1314-29-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 28/51] multifd: Create page_size fields into
 both MultiFD{Recv, Send}Params
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Leonardo Bras <leobras@redhat.com>

We were calling qemu_target_page_size() left and right.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
---
 migration/multifd.h      |  4 ++++
 migration/multifd-zlib.c | 14 ++++++--------
 migration/multifd-zstd.c | 12 +++++-------
 migration/multifd.c      | 18 ++++++++----------
 4 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/migration/multifd.h b/migration/multifd.h
index 519f498643..86fb9982b3 100644
--- a/migration/multifd.h
+++ b/migration/multifd.h
@@ -80,6 +80,8 @@ typedef struct {
     bool registered_yank;
     /* packet allocated len */
     uint32_t packet_len;
+    /* guest page size */
+    uint32_t page_size;
     /* multifd flags for sending ram */
     int write_flags;
 
@@ -143,6 +145,8 @@ typedef struct {
     QIOChannel *c;
     /* packet allocated len */
     uint32_t packet_len;
+    /* guest page size */
+    uint32_t page_size;
 
     /* syncs main thread and channels */
     QemuSemaphore sem_sync;
diff --git a/migration/multifd-zlib.c b/migration/multifd-zlib.c
index 18213a9513..37770248e1 100644
--- a/migration/multifd-zlib.c
+++ b/migration/multifd-zlib.c
@@ -116,7 +116,6 @@ static void zlib_send_cleanup(MultiFDSendParams *p, Error **errp)
 static int zlib_send_prepare(MultiFDSendParams *p, Error **errp)
 {
     struct zlib_data *z = p->data;
-    size_t page_size = qemu_target_page_size();
     z_stream *zs = &z->zs;
     uint32_t out_size = 0;
     int ret;
@@ -135,8 +134,8 @@ static int zlib_send_prepare(MultiFDSendParams *p, Error **errp)
          * with compression. zlib does not guarantee that this is safe,
          * therefore copy the page before calling deflate().
          */
-        memcpy(z->buf, p->pages->block->host + p->normal[i], page_size);
-        zs->avail_in = page_size;
+        memcpy(z->buf, p->pages->block->host + p->normal[i], p->page_size);
+        zs->avail_in = p->page_size;
         zs->next_in = z->buf;
 
         zs->avail_out = available;
@@ -242,12 +241,11 @@ static void zlib_recv_cleanup(MultiFDRecvParams *p)
 static int zlib_recv_pages(MultiFDRecvParams *p, Error **errp)
 {
     struct zlib_data *z = p->data;
-    size_t page_size = qemu_target_page_size();
     z_stream *zs = &z->zs;
     uint32_t in_size = p->next_packet_size;
     /* we measure the change of total_out */
     uint32_t out_size = zs->total_out;
-    uint32_t expected_size = p->normal_num * page_size;
+    uint32_t expected_size = p->normal_num * p->page_size;
     uint32_t flags = p->flags & MULTIFD_FLAG_COMPRESSION_MASK;
     int ret;
     int i;
@@ -274,7 +272,7 @@ static int zlib_recv_pages(MultiFDRecvParams *p, Error **errp)
             flush = Z_SYNC_FLUSH;
         }
 
-        zs->avail_out = page_size;
+        zs->avail_out = p->page_size;
         zs->next_out = p->host + p->normal[i];
 
         /*
@@ -288,8 +286,8 @@ static int zlib_recv_pages(MultiFDRecvParams *p, Error **errp)
         do {
             ret = inflate(zs, flush);
         } while (ret == Z_OK && zs->avail_in
-                             && (zs->total_out - start) < page_size);
-        if (ret == Z_OK && (zs->total_out - start) < page_size) {
+                             && (zs->total_out - start) < p->page_size);
+        if (ret == Z_OK && (zs->total_out - start) < p->page_size) {
             error_setg(errp, "multifd %u: inflate generated too few output",
                        p->id);
             return -1;
diff --git a/migration/multifd-zstd.c b/migration/multifd-zstd.c
index d788d309f2..f4a8e1ed1f 100644
--- a/migration/multifd-zstd.c
+++ b/migration/multifd-zstd.c
@@ -113,7 +113,6 @@ static void zstd_send_cleanup(MultiFDSendParams *p, Error **errp)
 static int zstd_send_prepare(MultiFDSendParams *p, Error **errp)
 {
     struct zstd_data *z = p->data;
-    size_t page_size = qemu_target_page_size();
     int ret;
     uint32_t i;
 
@@ -128,7 +127,7 @@ static int zstd_send_prepare(MultiFDSendParams *p, Error **errp)
             flush = ZSTD_e_flush;
         }
         z->in.src = p->pages->block->host + p->normal[i];
-        z->in.size = page_size;
+        z->in.size = p->page_size;
         z->in.pos = 0;
 
         /*
@@ -241,8 +240,7 @@ static int zstd_recv_pages(MultiFDRecvParams *p, Error **errp)
 {
     uint32_t in_size = p->next_packet_size;
     uint32_t out_size = 0;
-    size_t page_size = qemu_target_page_size();
-    uint32_t expected_size = p->normal_num * page_size;
+    uint32_t expected_size = p->normal_num * p->page_size;
     uint32_t flags = p->flags & MULTIFD_FLAG_COMPRESSION_MASK;
     struct zstd_data *z = p->data;
     int ret;
@@ -265,7 +263,7 @@ static int zstd_recv_pages(MultiFDRecvParams *p, Error **errp)
 
     for (i = 0; i < p->normal_num; i++) {
         z->out.dst = p->host + p->normal[i];
-        z->out.size = page_size;
+        z->out.size = p->page_size;
         z->out.pos = 0;
 
         /*
@@ -279,8 +277,8 @@ static int zstd_recv_pages(MultiFDRecvParams *p, Error **errp)
         do {
             ret = ZSTD_decompressStream(z->zds, &z->out, &z->in);
         } while (ret > 0 && (z->in.size - z->in.pos > 0)
-                         && (z->out.pos < page_size));
-        if (ret > 0 && (z->out.pos < page_size)) {
+                         && (z->out.pos < p->page_size));
+        if (ret > 0 && (z->out.pos < p->page_size)) {
             error_setg(errp, "multifd %u: decompressStream buffer too small",
                        p->id);
             return -1;
diff --git a/migration/multifd.c b/migration/multifd.c
index 509bbbe3bf..efffa77a76 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -87,15 +87,14 @@ static void nocomp_send_cleanup(MultiFDSendParams *p, Error **errp)
 static int nocomp_send_prepare(MultiFDSendParams *p, Error **errp)
 {
     MultiFDPages_t *pages = p->pages;
-    size_t page_size = qemu_target_page_size();
 
     for (int i = 0; i < p->normal_num; i++) {
         p->iov[p->iovs_num].iov_base = pages->block->host + p->normal[i];
-        p->iov[p->iovs_num].iov_len = page_size;
+        p->iov[p->iovs_num].iov_len = p->page_size;
         p->iovs_num++;
     }
 
-    p->next_packet_size = p->normal_num * page_size;
+    p->next_packet_size = p->normal_num * p->page_size;
     p->flags |= MULTIFD_FLAG_NOCOMP;
     return 0;
 }
@@ -139,7 +138,6 @@ static void nocomp_recv_cleanup(MultiFDRecvParams *p)
 static int nocomp_recv_pages(MultiFDRecvParams *p, Error **errp)
 {
     uint32_t flags = p->flags & MULTIFD_FLAG_COMPRESSION_MASK;
-    size_t page_size = qemu_target_page_size();
 
     if (flags != MULTIFD_FLAG_NOCOMP) {
         error_setg(errp, "multifd %u: flags received %x flags expected %x",
@@ -148,7 +146,7 @@ static int nocomp_recv_pages(MultiFDRecvParams *p, Error **errp)
     }
     for (int i = 0; i < p->normal_num; i++) {
         p->iov[i].iov_base = p->host + p->normal[i];
-        p->iov[i].iov_len = page_size;
+        p->iov[i].iov_len = p->page_size;
     }
     return qio_channel_readv_all(p->c, p->iov, p->normal_num, errp);
 }
@@ -281,8 +279,7 @@ static void multifd_send_fill_packet(MultiFDSendParams *p)
 static int multifd_recv_unfill_packet(MultiFDRecvParams *p, Error **errp)
 {
     MultiFDPacket_t *packet = p->packet;
-    size_t page_size = qemu_target_page_size();
-    uint32_t page_count = MULTIFD_PACKET_SIZE / page_size;
+    uint32_t page_count = MULTIFD_PACKET_SIZE / p->page_size;
     RAMBlock *block;
     int i;
 
@@ -344,7 +341,7 @@ static int multifd_recv_unfill_packet(MultiFDRecvParams *p, Error **errp)
     for (i = 0; i < p->normal_num; i++) {
         uint64_t offset = be64_to_cpu(packet->offset[i]);
 
-        if (offset > (block->used_length - page_size)) {
+        if (offset > (block->used_length - p->page_size)) {
             error_setg(errp, "multifd: offset too long %" PRIu64
                        " (max " RAM_ADDR_FMT ")",
                        offset, block->used_length);
@@ -433,8 +430,7 @@ static int multifd_send_pages(QEMUFile *f)
     p->packet_num = multifd_send_state->packet_num++;
     multifd_send_state->pages = p->pages;
     p->pages = pages;
-    transferred = ((uint64_t) pages->num) * qemu_target_page_size()
-                + p->packet_len;
+    transferred = ((uint64_t) pages->num) * p->page_size + p->packet_len;
     qemu_file_acct_rate_limit(f, transferred);
     ram_counters.multifd_bytes += transferred;
     ram_counters.transferred += transferred;
@@ -947,6 +943,7 @@ int multifd_save_setup(Error **errp)
         /* We need one extra place for the packet header */
         p->iov = g_new0(struct iovec, page_count + 1);
         p->normal = g_new0(ram_addr_t, page_count);
+        p->page_size = qemu_target_page_size();
 
         if (migrate_use_zero_copy_send()) {
             p->write_flags = QIO_CHANNEL_WRITE_FLAG_ZERO_COPY;
@@ -1194,6 +1191,7 @@ int multifd_load_setup(Error **errp)
         p->name = g_strdup_printf("multifdrecv_%d", i);
         p->iov = g_new0(struct iovec, page_count);
         p->normal = g_new0(ram_addr_t, page_count);
+        p->page_size = qemu_target_page_size();
     }
 
     for (i = 0; i < thread_count; i++) {
-- 
2.38.1

