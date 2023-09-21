Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282895; x=1695887695;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=jlU7vc1UjVKlw3Dv2jSmgf2SIHJeXqpTwAZU3tpQIrQ=;
 b=DDeZLOAe99d1Z9BUtob/J0n9I5Vuljxrx4pwaCG2CkbAZV/g9bXrMFKvqwFNfbxGFr
 //S86ZhZeKTaHOSkPH0mtFnfMBzIPVq2DeR89dyV0fQ8Ny6KnZbEMCLAcAXQFfXOKDj+
 mIJEDJkEFG26+jasP1TxEKsFSE8YHTASTyNC1Hh1WX4Q8JfsXJGkQsVnRpEb/kAplok1
 Uy6Pq+FhlFF6rT07eJSa/CrpA1nWf5fcHrMcERGreGg/3NrpcfNu3sOj2mIuSYQiMFdf
 5kcQgVlKbm4wLhYde5Bkdd/1m/WTbUdG5R1/rgkxfo3xwqqonu4m3K5Y3PyOws0v5sgA
 WI1w==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:17 +0900
Message-ID: <20230921075425.16738-4-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 3/8] contrib/rdmacm-mux: Use
 qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the default Unix socket
path.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 contrib/rdmacm-mux/main.c      | 22 ++++++++++++++--------
 contrib/rdmacm-mux/meson.build |  2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/contrib/rdmacm-mux/main.c b/contrib/rdmacm-mux/main.c
index 771ca01e03..00c14031ca 100644
--- a/contrib/rdmacm-mux/main.c
+++ b/contrib/rdmacm-mux/main.c
@@ -14,6 +14,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
 #include <sys/poll.h>
 #include <sys/ioctl.h>
 #include <pthread.h>
@@ -40,8 +41,6 @@
 #define CM_REQ_DGID_POS      80
 #define CM_SIDR_REQ_DGID_POS 44
 
-/* The below can be override by command line parameter */
-#define UNIX_SOCKET_PATH "/var/run/rdmacm-mux"
 /* Has format %s-%s-%d" <path>-<rdma-dev--name>-<port> */
 #define SOCKET_PATH_MAX (PATH_MAX - NAME_MAX - sizeof(int) - 2)
 #define RDMA_PORT_NUM 1
@@ -77,7 +76,13 @@ typedef struct RdmaCmServer {
 
 static RdmaCMServer server = {0};
 
-static void usage(const char *progname)
+static char *get_default_unix_socket_path(void)
+{
+    g_autofree char *run = qemu_get_runtime_dir();
+    return g_build_filename(run, "rdmacm-mux", NULL);
+}
+
+static void usage(const char *progname, const char *default_unix_socket_path)
 {
     printf("Usage: %s [OPTION]...\n"
            "Start a RDMA-CM multiplexer\n"
@@ -86,7 +91,7 @@ static void usage(const char *progname)
            "\t-d rdma-device-name   Name of RDMA device to register with\n"
            "\t-s unix-socket-path   Path to unix socket to listen on (default %s)\n"
            "\t-p rdma-device-port   Port number of RDMA device to register with (default %d)\n",
-           progname, UNIX_SOCKET_PATH, RDMA_PORT_NUM);
+           progname, default_unix_socket_path, RDMA_PORT_NUM);
 }
 
 static void help(const char *progname)
@@ -97,16 +102,16 @@ static void help(const char *progname)
 static void parse_args(int argc, char *argv[])
 {
     int c;
-    char unix_socket_path[SOCKET_PATH_MAX];
+    g_autofree char *default_unix_socket_path = get_default_unix_socket_path();
+    char *unix_socket_path = default_unix_socket_path;
 
     strcpy(server.args.rdma_dev_name, "");
-    strcpy(unix_socket_path, UNIX_SOCKET_PATH);
     server.args.rdma_port_num = RDMA_PORT_NUM;
 
     while ((c = getopt(argc, argv, "hs:d:p:")) != -1) {
         switch (c) {
         case 'h':
-            usage(argv[0]);
+            usage(argv[0], default_unix_socket_path);
             exit(0);
 
         case 'd':
@@ -115,7 +120,7 @@ static void parse_args(int argc, char *argv[])
 
         case 's':
             /* This is temporary, final name will build below */
-            strncpy(unix_socket_path, optarg, SOCKET_PATH_MAX - 1);
+            unix_socket_path = optarg;
             break;
 
         case 'p':
@@ -811,6 +816,7 @@ int main(int argc, char *argv[])
 {
     int rc;
 
+    qemu_init_exec_dir(argv[0]);
     memset(&server, 0, sizeof(server));
 
     parse_args(argc, argv);
diff --git a/contrib/rdmacm-mux/meson.build b/contrib/rdmacm-mux/meson.build
index 36c9c89630..59f60f9cac 100644
--- a/contrib/rdmacm-mux/meson.build
+++ b/contrib/rdmacm-mux/meson.build
@@ -1,7 +1,7 @@
 if have_pvrdma
   # FIXME: broken on big endian architectures
   executable('rdmacm-mux', files('main.c'), genh,
-             dependencies: [glib, libumad],
+             dependencies: [glib, libumad, qemuutil],
              build_by_default: false,
              install: false)
 endif
-- 
2.41.0

