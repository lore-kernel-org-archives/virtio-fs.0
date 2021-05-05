From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Wed,  5 May 2021 11:36:59 +0100
Message-Id: <20210505103702.521457-5-berrange@redhat.com>
In-Reply-To: <20210505103702.521457-1-berrange@redhat.com>
References: <20210505103702.521457-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/7] usb/dev-mtp: use GDateTime for formatting
	timestamp for objects
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
 hw/usb/dev-mtp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/hw/usb/dev-mtp.c b/hw/usb/dev-mtp.c
index bbb8274344..a71fcc326d 100644
--- a/hw/usb/dev-mtp.c
+++ b/hw/usb/dev-mtp.c
@@ -772,12 +772,9 @@ static void usb_mtp_add_str(MTPData *data, const char *str)
 
 static void usb_mtp_add_time(MTPData *data, time_t time)
 {
-    char buf[16];
-    struct tm tm;
-
-    gmtime_r(&time, &tm);
-    strftime(buf, sizeof(buf), "%Y%m%dT%H%M%S", &tm);
-    usb_mtp_add_str(data, buf);
+    g_autoptr(GDateTime) then = g_date_time_new_from_unix_utc(time);
+    g_autofree char *thenstr = g_date_time_format(then, "%Y%m%dT%H%M%S");
+    usb_mtp_add_str(data, thenstr);
 }
 
 /* ----------------------------------------------------------------------- */
-- 
2.31.1

