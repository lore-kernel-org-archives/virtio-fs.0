Return-Path: <marcandre.lureau@redhat.com>
From: marcandre.lureau@redhat.com
Date: Thu, 21 Apr 2022 17:49:15 +0400
Message-Id: <20220421134940.2887768-6-marcandre.lureau@redhat.com>
In-Reply-To: <20220421134940.2887768-1-marcandre.lureau@redhat.com>
References: <20220421134940.2887768-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 05/30] include: rename qemu-common.h
 qemu/help-texts.h
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>, Laurent Vivier <laurent@vivier.eu>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Akihiko Odaki <akihiko.odaki@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Warner Losh <imp@bsdimp.com>
Message-Id: <20220420132624.2439741-7-marcandre.lureau@redhat.com>
---
 include/{qemu-common.h => qemu/help-texts.h} | 0
 bsd-user/main.c                              | 2 +-
 linux-user/main.c                            | 2 +-
 qemu-img.c                                   | 2 +-
 qemu-io.c                                    | 2 +-
 qemu-nbd.c                                   | 2 +-
 qga/main.c                                   | 2 +-
 scsi/qemu-pr-helper.c                        | 2 +-
 softmmu/vl.c                                 | 2 +-
 storage-daemon/qemu-storage-daemon.c         | 2 +-
 tools/virtiofsd/passthrough_ll.c             | 2 +-
 ui/cocoa.m                                   | 2 +-
 12 files changed, 11 insertions(+), 11 deletions(-)
 rename include/{qemu-common.h => qemu/help-texts.h} (100%)

diff --git a/include/qemu-common.h b/include/qemu/help-texts.h
similarity index 100%
rename from include/qemu-common.h
rename to include/qemu/help-texts.h
diff --git a/bsd-user/main.c b/bsd-user/main.c
index 74f2d35a5497..6f09180d6541 100644
--- a/bsd-user/main.c
+++ b/bsd-user/main.c
@@ -24,7 +24,7 @@
 #include <sys/sysctl.h>
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu/units.h"
 #include "qemu/accel.h"
 #include "qemu-version.h"
diff --git a/linux-user/main.c b/linux-user/main.c
index 5fb6ecac3f86..7ca48664e447 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -18,7 +18,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu/units.h"
 #include "qemu/accel.h"
 #include "qemu-version.h"
diff --git a/qemu-img.c b/qemu-img.c
index ef3224a9d4a8..6337a63b3b80 100644
--- a/qemu-img.c
+++ b/qemu-img.c
@@ -25,7 +25,7 @@
 #include "qemu/osdep.h"
 #include <getopt.h>
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu/qemu-progress.h"
 #include "qemu-version.h"
 #include "qapi/error.h"
diff --git a/qemu-io.c b/qemu-io.c
index 38321a27a301..d70d3dd4fde5 100644
--- a/qemu-io.c
+++ b/qemu-io.c
@@ -15,7 +15,7 @@
 #include <termios.h>
 #endif
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qapi/error.h"
 #include "qemu-io.h"
 #include "qemu/error-report.h"
diff --git a/qemu-nbd.c b/qemu-nbd.c
index bf9c5fedceba..397ffa64d768 100644
--- a/qemu-nbd.c
+++ b/qemu-nbd.c
@@ -21,7 +21,7 @@
 #include <libgen.h>
 #include <pthread.h>
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qapi/error.h"
 #include "qemu/cutils.h"
 #include "sysemu/block-backend.h"
diff --git a/qga/main.c b/qga/main.c
index 1deb0ee2fbfe..e4b22df01dcd 100644
--- a/qga/main.c
+++ b/qga/main.c
@@ -18,7 +18,7 @@
 #include <syslog.h>
 #include <sys/wait.h>
 #endif
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qapi/qmp/json-parser.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qjson.h"
diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c
index 1f2a84c53454..df493e2a503e 100644
--- a/scsi/qemu-pr-helper.c
+++ b/scsi/qemu-pr-helper.c
@@ -36,7 +36,7 @@
 #include <mpath_persist.h>
 #endif
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qapi/error.h"
 #include "qemu/cutils.h"
 #include "qemu/main-loop.h"
diff --git a/softmmu/vl.c b/softmmu/vl.c
index f679d48d7415..2a38ebe5fbb4 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -23,7 +23,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu/datadir.h"
 #include "qemu/units.h"
 #include "exec/cpu-common.h"
diff --git a/storage-daemon/qemu-storage-daemon.c b/storage-daemon/qemu-storage-daemon.c
index 1398f0443d76..9b8b17f52e48 100644
--- a/storage-daemon/qemu-storage-daemon.c
+++ b/storage-daemon/qemu-storage-daemon.c
@@ -42,7 +42,7 @@
 #include "qapi/qmp/qstring.h"
 #include "qapi/qobject-input-visitor.h"
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu-version.h"
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 028dacdd8f5a..b15c631ca512 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -38,7 +38,7 @@
 #include "qemu/osdep.h"
 #include "qemu/timer.h"
 #include "qemu-version.h"
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "fuse_virtio.h"
 #include "fuse_log.h"
 #include "fuse_lowlevel.h"
diff --git a/ui/cocoa.m b/ui/cocoa.m
index 839ae4f58a69..68bff4ff3796 100644
--- a/ui/cocoa.m
+++ b/ui/cocoa.m
@@ -27,7 +27,7 @@
 #import <Cocoa/Cocoa.h>
 #include <crt_externs.h>
 
-#include "qemu-common.h"
+#include "qemu/help-texts.h"
 #include "qemu-main.h"
 #include "ui/clipboard.h"
 #include "ui/console.h"
-- 
2.36.0

