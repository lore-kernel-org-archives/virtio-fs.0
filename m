From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Wed,  5 May 2021 11:37:02 +0100
Message-Id: <20210505103702.521457-8-berrange@redhat.com>
In-Reply-To: <20210505103702.521457-1-berrange@redhat.com>
References: <20210505103702.521457-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 7/7] virtiofsd: use GDateTime for formatting
	timestamp for debug messages
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
 tools/virtiofsd/passthrough_ll.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 1553d2ef45..cdd224918c 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3558,10 +3558,6 @@ static void setup_nofile_rlimit(unsigned long rlimit_nofile)
 static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
 {
     g_autofree char *localfmt = NULL;
-    struct timespec ts;
-    struct tm tm;
-    char sec_fmt[sizeof "2020-12-07 18:17:54"];
-    char zone_fmt[sizeof "+0100"];
 
     if (current_log_level < level) {
         return;
@@ -3573,23 +3569,10 @@ static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
             localfmt = g_strdup_printf("[ID: %08ld] %s", syscall(__NR_gettid),
                                        fmt);
         } else {
-            /* try formatting a broken-down timestamp */
-            if (clock_gettime(CLOCK_REALTIME, &ts) != -1 &&
-                localtime_r(&ts.tv_sec, &tm) != NULL &&
-                strftime(sec_fmt, sizeof sec_fmt, "%Y-%m-%d %H:%M:%S",
-                         &tm) != 0 &&
-                strftime(zone_fmt, sizeof zone_fmt, "%z", &tm) != 0) {
-                localfmt = g_strdup_printf("[%s.%02ld%s] [ID: %08ld] %s",
-                                           sec_fmt,
-                                           ts.tv_nsec / (10L * 1000 * 1000),
-                                           zone_fmt, syscall(__NR_gettid),
-                                           fmt);
-            } else {
-                /* fall back to a flat timestamp */
-                localfmt = g_strdup_printf("[%" PRId64 "] [ID: %08ld] %s",
-                                           get_clock(), syscall(__NR_gettid),
-                                           fmt);
-            }
+            g_autoptr(GDateTime) now = g_date_time_new_now_local();
+            g_autofree char *nowstr = g_date_time_format(now, "%Y-%m-%d %H:%M:%S.%f%z");
+            localfmt = g_strdup_printf("[%s] [ID: %08ld] %s",
+                                       nowstr, syscall(__NR_gettid), fmt);
         }
         fmt = localfmt;
     }
-- 
2.31.1

