From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Wed,  5 May 2021 11:36:58 +0100
Message-Id: <20210505103702.521457-4-berrange@redhat.com>
In-Reply-To: <20210505103702.521457-1-berrange@redhat.com>
References: <20210505103702.521457-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/7] net/rocker: use GDateTime for formatting
	timestamp in debug messages
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
 hw/net/rocker/rocker.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/hw/net/rocker/rocker.h b/hw/net/rocker/rocker.h
index 941c932265..412fa44d01 100644
--- a/hw/net/rocker/rocker.h
+++ b/hw/net/rocker/rocker.h
@@ -25,14 +25,9 @@
 #if defined(DEBUG_ROCKER)
 #  define DPRINTF(fmt, ...) \
     do {                                                           \
-        struct timeval tv;                                         \
-        char timestr[64];                                          \
-        time_t now;                                                \
-        gettimeofday(&tv, NULL);                                   \
-        now = tv.tv_sec;                                           \
-        strftime(timestr, sizeof(timestr), "%T", localtime(&now)); \
-        fprintf(stderr, "%s.%06ld ", timestr, tv.tv_usec);         \
-        fprintf(stderr, "ROCKER: " fmt, ## __VA_ARGS__);           \
+        g_autoptr(GDateTime) now = g_date_time_new_now_local();    \
+        g_autofree char *nowstr = g_date_time_format(now, "%T.%f");\
+        fprintf(stderr, "%s ROCKER: " fmt, nowstr, ## __VA_ARGS__);\
     } while (0)
 #else
 static inline GCC_FMT_ATTR(1, 2) int DPRINTF(const char *fmt, ...)
-- 
2.31.1

