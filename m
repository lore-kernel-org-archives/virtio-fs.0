Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:06 +0100
Message-Id: <20221205095228.1314-30-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 29/51] multifd: Create page_count fields into
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

We were recalculating it left and right.  We plan to change that
values on next patches.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
---
 migration/multifd.h | 4 ++++
 migration/multifd.c | 7 ++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/migration/multifd.h b/migration/multifd.h
index 86fb9982b3..e2802a9ce2 100644
--- a/migration/multifd.h
+++ b/migration/multifd.h
@@ -82,6 +82,8 @@ typedef struct {
     uint32_t packet_len;
     /* guest page size */
     uint32_t page_size;
+    /* number of pages in a full packet */
+    uint32_t page_count;
     /* multifd flags for sending ram */
     int write_flags;
 
@@ -147,6 +149,8 @@ typedef struct {
     uint32_t packet_len;
     /* guest page size */
     uint32_t page_size;
+    /* number of pages in a full packet */
+    uint32_t page_count;
 
     /* syncs main thread and channels */
     QemuSemaphore sem_sync;
diff --git a/migration/multifd.c b/migration/multifd.c
index efffa77a76..b8dc559d24 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -279,7 +279,6 @@ static void multifd_send_fill_packet(MultiFDSendParams *p)
 static int multifd_recv_unfill_packet(MultiFDRecvParams *p, Error **errp)
 {
     MultiFDPacket_t *packet = p->packet;
-    uint32_t page_count = MULTIFD_PACKET_SIZE / p->page_size;
     RAMBlock *block;
     int i;
 
@@ -306,10 +305,10 @@ static int multifd_recv_unfill_packet(MultiFDRecvParams *p, Error **errp)
      * If we received a packet that is 100 times bigger than expected
      * just stop migration.  It is a magic number.
      */
-    if (packet->pages_alloc > page_count) {
+    if (packet->pages_alloc > p->page_count) {
         error_setg(errp, "multifd: received packet "
                    "with size %u and expected a size of %u",
-                   packet->pages_alloc, page_count) ;
+                   packet->pages_alloc, p->page_count) ;
         return -1;
     }
 
@@ -944,6 +943,7 @@ int multifd_save_setup(Error **errp)
         p->iov = g_new0(struct iovec, page_count + 1);
         p->normal = g_new0(ram_addr_t, page_count);
         p->page_size = qemu_target_page_size();
+        p->page_count = page_count;
 
         if (migrate_use_zero_copy_send()) {
             p->write_flags = QIO_CHANNEL_WRITE_FLAG_ZERO_COPY;
@@ -1191,6 +1191,7 @@ int multifd_load_setup(Error **errp)
         p->name = g_strdup_printf("multifdrecv_%d", i);
         p->iov = g_new0(struct iovec, page_count);
         p->normal = g_new0(ram_addr_t, page_count);
+        p->page_count = page_count;
         p->page_size = qemu_target_page_size();
     }
 
-- 
2.38.1

