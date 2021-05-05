From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Wed,  5 May 2021 11:36:57 +0100
Message-Id: <20210505103702.521457-3-berrange@redhat.com>
In-Reply-To: <20210505103702.521457-1-berrange@redhat.com>
References: <20210505103702.521457-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/7] block: use GDateTime for formatting
	timestamp when dumping snapshot info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <laurent@vivier.eu>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Brad Smith <brad@comstyle.com>

The GDateTime APIs provided by GLib avoid portability pitfalls, such
as some platforms where 'struct timeval.tv_sec' field is still 'long'
instead of 'time_t'. When combined with automatic cleanup, GDateTime
often results in simpler code too.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 block/qapi.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/block/qapi.c b/block/qapi.c
index 943e7b15ad..06851fb469 100644
--- a/block/qapi.c
+++ b/block/qapi.c
@@ -663,10 +663,8 @@ BlockStatsList *qmp_query_blockstats(bool has_query_nodes,
 
 void bdrv_snapshot_dump(QEMUSnapshotInfo *sn)
 {
-    char date_buf[128], clock_buf[128];
+    char clock_buf[128];
     char icount_buf[128] = {0};
-    struct tm tm;
-    time_t ti;
     int64_t secs;
     char *sizing = NULL;
 
@@ -674,10 +672,9 @@ void bdrv_snapshot_dump(QEMUSnapshotInfo *sn)
         qemu_printf("%-10s%-17s%8s%20s%13s%11s",
                     "ID", "TAG", "VM SIZE", "DATE", "VM CLOCK", "ICOUNT");
     } else {
-        ti = sn->date_sec;
-        localtime_r(&ti, &tm);
-        strftime(date_buf, sizeof(date_buf),
-                 "%Y-%m-%d %H:%M:%S", &tm);
+        g_autoptr(GDateTime) date = g_date_time_new_from_unix_local(sn->date_sec);
+        g_autofree char *date_buf = g_date_time_format(date, "%Y-%m-%d %H:%M:%S");
+
         secs = sn->vm_clock_nsec / 1000000000;
         snprintf(clock_buf, sizeof(clock_buf),
                  "%02d:%02d:%02d.%03d",
-- 
2.31.1

