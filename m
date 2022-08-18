Return-Path: <yokada.996@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc;
 bh=34YSupzvFPGf54q4I719p5ZvNSdYXQRbFLGKQamgoTQ=;
 b=pa9XOzatRzKWuheXDs22T3192JnXjcENdherXX87rgYqIUc+q3zmSW0wf2n40ifpxP
 Kfd5PC4OmcdpnOgwixESMkchmgONHpGlvJ+PVdXZyv/JRyhltKZYVqa5ULKt11y1WCu2
 duXiLQTEZcfu24zFU8hiCO+MrOgCFNKA2ju5scdmcakY+nK/o0Q9rj5hYfrO5CZCqsfc
 AE6tLhsDVjcP5ftTHjqbDcGDi/qtEzu6459LFQKAmdhIVoZMMZo/p+XUJhRlq4Zm8bFR
 fljomqu9UTDcuHJsLLHINDTP5ykXIDrqa/SrBD364+DsTaWV1T1233mKf8qq3EdwVZ+D
 JSkA==
From: Yusuke Okada <yokada.996@gmail.com>
Date: Thu, 18 Aug 2022 14:46:19 -0400
Message-Id: <20220818184618.2205172-1-yokada.996@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond to
 get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Yusuke Okada <okada.yusuke@jp.fujitsu.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>

From: Yusuke Okada <okada.yusuke@jp.fujitsu.com>

The "%f" specifier in g_date_time_format() is only available in glib
2.65.2 or later. If combined with older glib, the function returns null
and the timestamp displayed as "(null)".

For backward compatibility, g_date_time_get_microsecond should be used
to retrieve subsecond.

In this patch the g_date_time_format() leaves subsecond field as "%06d"
and let next snprintf to format with g_date_time_get_microsecond.

Signed-off-by: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 371a7bead6..20f0f41f99 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -4185,6 +4185,7 @@ static void setup_nofile_rlimit(unsigned long rlimit_nofile)
 static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
 {
     g_autofree char *localfmt = NULL;
+    char buf[64];
 
     if (current_log_level < level) {
         return;
@@ -4197,9 +4198,11 @@ static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
                                        fmt);
         } else {
             g_autoptr(GDateTime) now = g_date_time_new_now_utc();
-            g_autofree char *nowstr = g_date_time_format(now, "%Y-%m-%d %H:%M:%S.%f%z");
+            g_autofree char *nowstr = g_date_time_format(now,
+                                       "%Y-%m-%d %H:%M:%S.%%06d%z");
+            snprintf(buf, 64, nowstr, g_date_time_get_microsecond(now));
             localfmt = g_strdup_printf("[%s] [ID: %08ld] %s",
-                                       nowstr, syscall(__NR_gettid), fmt);
+                                       buf, syscall(__NR_gettid), fmt);
         }
         fmt = localfmt;
     }
-- 
2.31.1

