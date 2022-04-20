Return-Path: <marcandre.lureau@redhat.com>
From: marcandre.lureau@redhat.com
Date: Wed, 20 Apr 2022 17:25:49 +0400
Message-Id: <20220420132624.2439741-7-marcandre.lureau@redhat.com>
In-Reply-To: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
References: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 06/41] include: rename qemu-common.h
 qemu/copyright.h
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>, Laurent Vivier <laurent@vivier.eu>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Akihiko Odaki <akihiko.odaki@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/{qemu-common.h => qemu/copyright.h} | 0
 bsd-user/main.c                             | 2 +-
 linux-user/main.c                           | 2 +-
 qemu-img.c                                  | 2 +-
 qemu-io.c                                   | 2 +-
 qemu-nbd.c                                  | 2 +-
 qga/main.c                                  | 2 +-
 scsi/qemu-pr-helper.c                       | 2 +-
 softmmu/vl.c                                | 2 +-
 storage-daemon/qemu-storage-daemon.c        | 2 +-
 tools/virtiofsd/passthrough_ll.c            | 2 +-
 ui/cocoa.m                                  | 2 +-
 12 files changed, 11 insertions(+), 11 deletions(-)
 rename include/{qemu-common.h => qemu/copyright.h} (100%)

diff --git a/include/qemu-common.h b/include/qemu/copyright.h
similarity index 100%
rename from include/qemu-common.h
rename to include/qemu/copyright.h
diff --git a/bsd-user/main.c b/bsd-user/main.c
index 88d347d05ebf..aaab3f278534 100644
--- a/bsd-user/main.c
+++ b/bsd-user/main.c
@@ -24,7 +24,7 @@
 #include <sys/sysctl.h>
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu/units.h"
 #include "qemu/accel.h"
 #include "sysemu/tcg.h"
diff --git a/linux-user/main.c b/linux-user/main.c
index fbc9bcfd5f5f..744d216b1e8e 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -18,7 +18,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu/units.h"
 #include "qemu/accel.h"
 #include "sysemu/tcg.h"
diff --git a/qemu-img.c b/qemu-img.c
index 116e05867558..a2b1d3653a1e 100644
--- a/qemu-img.c
+++ b/qemu-img.c
@@ -25,7 +25,7 @@
 #include "qemu/osdep.h"
 #include <getopt.h>
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu/qemu-progress.h"
 #include "qemu-version.h"
 #include "qapi/error.h"
diff --git a/qemu-io.c b/qemu-io.c
index eb8afc8b413b..952a36643b0c 100644
--- a/qemu-io.c
+++ b/qemu-io.c
@@ -15,7 +15,7 @@
 #include <termios.h>
 #endif
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qapi/error.h"
 #include "qemu-io.h"
 #include "qemu/error-report.h"
diff --git a/qemu-nbd.c b/qemu-nbd.c
index 713e7557a9eb..f4d121c0c40e 100644
--- a/qemu-nbd.c
+++ b/qemu-nbd.c
@@ -21,7 +21,7 @@
 #include <libgen.h>
 #include <pthread.h>
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qapi/error.h"
 #include "qemu/cutils.h"
 #include "sysemu/block-backend.h"
diff --git a/qga/main.c b/qga/main.c
index ac63d8e47802..8994f73e4735 100644
--- a/qga/main.c
+++ b/qga/main.c
@@ -18,7 +18,7 @@
 #include <syslog.h>
 #include <sys/wait.h>
 #endif
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qapi/qmp/json-parser.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qjson.h"
diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c
index f281daeced8d..e7549ffb3bc9 100644
--- a/scsi/qemu-pr-helper.c
+++ b/scsi/qemu-pr-helper.c
@@ -36,7 +36,7 @@
 #include <mpath_persist.h>
 #endif
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qapi/error.h"
 #include "qemu/cutils.h"
 #include "qemu/main-loop.h"
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 46aba6a039c4..b0bf16e16aaa 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -23,7 +23,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu/datadir.h"
 #include "qemu/units.h"
 #include "exec/cpu-common.h"
diff --git a/storage-daemon/qemu-storage-daemon.c b/storage-daemon/qemu-storage-daemon.c
index eb724072579a..a4415e8c995b 100644
--- a/storage-daemon/qemu-storage-daemon.c
+++ b/storage-daemon/qemu-storage-daemon.c
@@ -42,7 +42,7 @@
 #include "qapi/qmp/qstring.h"
 #include "qapi/qobject-input-visitor.h"
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu-version.h"
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 028dacdd8f5a..8af28f5fb823 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -38,7 +38,7 @@
 #include "qemu/osdep.h"
 #include "qemu/timer.h"
 #include "qemu-version.h"
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "fuse_virtio.h"
 #include "fuse_log.h"
 #include "fuse_lowlevel.h"
diff --git a/ui/cocoa.m b/ui/cocoa.m
index 839ae4f58a69..a2a74656fabf 100644
--- a/ui/cocoa.m
+++ b/ui/cocoa.m
@@ -27,7 +27,7 @@
 #import <Cocoa/Cocoa.h>
 #include <crt_externs.h>
 
-#include "qemu-common.h"
+#include "qemu/copyright.h"
 #include "qemu-main.h"
 #include "ui/clipboard.h"
 #include "ui/console.h"
-- 
2.35.1.693.g805e0a68082a

