Return-Path: <berrange@redhat.com>
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Mon, 19 Dec 2022 08:02:02 -0500
Message-Id: <20221219130205.687815-4-berrange@redhat.com>
In-Reply-To: <20221219130205.687815-1-berrange@redhat.com>
References: <20221219130205.687815-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/6] tools/virtiofsd: add G_GNUC_PRINTF for
 logging functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 tools/virtiofsd/fuse_log.c       | 1 +
 tools/virtiofsd/fuse_log.h       | 6 ++++--
 tools/virtiofsd/passthrough_ll.c | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/fuse_log.c b/tools/virtiofsd/fuse_log.c
index 745d88cd2a..2de3f48ee7 100644
--- a/tools/virtiofsd/fuse_log.c
+++ b/tools/virtiofsd/fuse_log.c
@@ -12,6 +12,7 @@
 #include "fuse_log.h"
 
 
+G_GNUC_PRINTF(2, 0)
 static void default_log_func(__attribute__((unused)) enum fuse_log_level level,
                              const char *fmt, va_list ap)
 {
diff --git a/tools/virtiofsd/fuse_log.h b/tools/virtiofsd/fuse_log.h
index 8d7091bd4d..e5c2967ab9 100644
--- a/tools/virtiofsd/fuse_log.h
+++ b/tools/virtiofsd/fuse_log.h
@@ -45,7 +45,8 @@ enum fuse_log_level {
  * @param ap format string arguments
  */
 typedef void (*fuse_log_func_t)(enum fuse_log_level level, const char *fmt,
-                                va_list ap);
+                                va_list ap)
+    G_GNUC_PRINTF(2, 0);
 
 /**
  * Install a custom log handler function.
@@ -68,6 +69,7 @@ void fuse_set_log_func(fuse_log_func_t func);
  * @param level severity level (FUSE_LOG_ERR, FUSE_LOG_DEBUG, etc)
  * @param fmt sprintf-style format string including newline
  */
-void fuse_log(enum fuse_log_level level, const char *fmt, ...);
+void fuse_log(enum fuse_log_level level, const char *fmt, ...)
+    G_GNUC_PRINTF(2, 3);
 
 #endif /* FUSE_LOG_H_ */
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 20f0f41f99..40ea2ed27f 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -4182,6 +4182,7 @@ static void setup_nofile_rlimit(unsigned long rlimit_nofile)
     }
 }
 
+G_GNUC_PRINTF(2, 0)
 static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
 {
     g_autofree char *localfmt = NULL;
-- 
2.38.1

