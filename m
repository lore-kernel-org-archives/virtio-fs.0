Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:23 +0100
Message-Id: <20221205095228.1314-47-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 46/51] migration: Drop rs->f
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>

From: Peter Xu <peterx@redhat.com>

Now with rs->pss we can already cache channels in pss->pss_channels.  That
pss_channel contains more infromation than rs->f because it's per-channel.
So rs->f could be replaced by rss->pss[RAM_CHANNEL_PRECOPY].pss_channel,
while rs->f itself is a bit vague now.

Note that vanilla postcopy still send pages via pss[RAM_CHANNEL_PRECOPY],
that's slightly confusing but it reflects the reality.

Then, after the replacement we can safely drop rs->f.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 1ae093fb61..334309f1c6 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -323,8 +323,6 @@ struct RAMSrcPageRequest {
 
 /* State of RAM for migration */
 struct RAMState {
-    /* QEMUFile used for this migration */
-    QEMUFile *f;
     /*
      * PageSearchStatus structures for the channels when send pages.
      * Protected by the bitmap_mutex.
@@ -2532,8 +2530,6 @@ static int ram_find_and_save_block(RAMState *rs)
         }
 
         if (found) {
-            /* Cache rs->f in pss_channel (TODO: remove rs->f) */
-            pss->pss_channel = rs->f;
             pages = ram_save_host_page(rs, pss);
         }
     } while (!pages && again);
@@ -3089,7 +3085,7 @@ static void ram_state_resume_prepare(RAMState *rs, QEMUFile *out)
     ram_state_reset(rs);
 
     /* Update RAMState cache of output QEMUFile */
-    rs->f = out;
+    rs->pss[RAM_CHANNEL_PRECOPY].pss_channel = out;
 
     trace_ram_state_resume_prepare(pages);
 }
@@ -3180,7 +3176,7 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
             return -1;
         }
     }
-    (*rsp)->f = f;
+    (*rsp)->pss[RAM_CHANNEL_PRECOPY].pss_channel = f;
 
     WITH_RCU_READ_LOCK_GUARD() {
         qemu_put_be64(f, ram_bytes_total_common(true) | RAM_SAVE_FLAG_MEM_SIZE);
@@ -3315,7 +3311,7 @@ static int ram_save_iterate(QEMUFile *f, void *opaque)
 out:
     if (ret >= 0
         && migration_is_setup_or_active(migrate_get_current()->state)) {
-        ret = multifd_send_sync_main(rs->f);
+        ret = multifd_send_sync_main(rs->pss[RAM_CHANNEL_PRECOPY].pss_channel);
         if (ret < 0) {
             return ret;
         }
@@ -3385,7 +3381,7 @@ static int ram_save_complete(QEMUFile *f, void *opaque)
         return ret;
     }
 
-    ret = multifd_send_sync_main(rs->f);
+    ret = multifd_send_sync_main(rs->pss[RAM_CHANNEL_PRECOPY].pss_channel);
     if (ret < 0) {
         return ret;
     }
-- 
2.38.1

