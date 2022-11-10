Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=imXo2IRrILpkxUDOjeir+V07IKls1TLJKB9c8zb1QFc=;
 b=vDkF5bL8SedL4u/8o+q2LoM2GA+YpMcjvsNQ9lUx7UUhm5ZR2Ezl52s+KhNoI1Bsdt
 3Gx1jarUSeeUOuuXbLgD4yl5hD06grTo6QQuvzDIlzrv/nF5m5RO/WAGKeiwitNj4sJ+
 8Kf6VOnBcrEiufCS4B5l4fdMxyIG/8xW+6MnsSywYM6ww3sqGO77atU4lj5t0YVDZ+Il
 sngtwoWWxi92ngZJNr0HkacNPIGT6puDjcDldGTU2lyW/dOb6yQTHYOJDoTUNdwXvGIA
 VsMiAz21o++//2CpTgyk810Uy8kHNL83tWIF5cmYZqJJnOlnDgiNpA77U0eQ7VzBxUl3
 gFww==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 15:23:22 +0900
Message-Id: <20221110062329.13363-4-akihiko.odaki@daynix.com>
In-Reply-To: <20221110062329.13363-1-akihiko.odaki@daynix.com>
References: <20221110062329.13363-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH 03/10] ivshmem-server: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the default PID file path.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 contrib/ivshmem-server/main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/contrib/ivshmem-server/main.c b/contrib/ivshmem-server/main.c
index 224dbeb547..16abbe2f5a 100644
--- a/contrib/ivshmem-server/main.c
+++ b/contrib/ivshmem-server/main.c
@@ -14,7 +14,6 @@
 
 #define IVSHMEM_SERVER_DEFAULT_VERBOSE        0
 #define IVSHMEM_SERVER_DEFAULT_FOREGROUND     0
-#define IVSHMEM_SERVER_DEFAULT_PID_FILE       "/var/run/ivshmem-server.pid"
 #define IVSHMEM_SERVER_DEFAULT_UNIX_SOCK_PATH "/tmp/ivshmem_socket"
 #define IVSHMEM_SERVER_DEFAULT_SHM_PATH       "ivshmem"
 #define IVSHMEM_SERVER_DEFAULT_SHM_SIZE       (4 * 1024 * 1024)
@@ -35,15 +34,23 @@ typedef struct IvshmemServerArgs {
     unsigned n_vectors;
 } IvshmemServerArgs;
 
+static char *ivshmem_server_get_default_pid_file(void)
+{
+    g_autofree char *run = qemu_get_runtime_dir();
+    return g_build_filename(run, "ivshmem-server.pid", NULL);
+}
+
 static void
 ivshmem_server_usage(const char *progname)
 {
+    g_autofree char *pid_file = ivshmem_server_get_default_pid_file();
+
     printf("Usage: %s [OPTION]...\n"
            "  -h: show this help\n"
            "  -v: verbose mode\n"
            "  -F: foreground mode (default is to daemonize)\n"
            "  -p <pid-file>: path to the PID file (used in daemon mode only)\n"
-           "     default " IVSHMEM_SERVER_DEFAULT_PID_FILE "\n"
+           "     default %s\n"
            "  -S <unix-socket-path>: path to the unix socket to listen to\n"
            "     default " IVSHMEM_SERVER_DEFAULT_UNIX_SOCK_PATH "\n"
            "  -M <shm-name>: POSIX shared memory object to use\n"
@@ -54,7 +61,7 @@ ivshmem_server_usage(const char *progname)
            "     default %u\n"
            "  -n <nvectors>: number of vectors\n"
            "     default %u\n",
-           progname, IVSHMEM_SERVER_DEFAULT_SHM_SIZE,
+           progname, pid_file, IVSHMEM_SERVER_DEFAULT_SHM_SIZE,
            IVSHMEM_SERVER_DEFAULT_N_VECTORS);
 }
 
@@ -189,10 +196,10 @@ main(int argc, char *argv[])
 {
     IvshmemServer server;
     struct sigaction sa, sa_quit;
+    g_autofree char *default_pid_file = NULL;
     IvshmemServerArgs args = {
         .verbose = IVSHMEM_SERVER_DEFAULT_VERBOSE,
         .foreground = IVSHMEM_SERVER_DEFAULT_FOREGROUND,
-        .pid_file = IVSHMEM_SERVER_DEFAULT_PID_FILE,
         .unix_socket_path = IVSHMEM_SERVER_DEFAULT_UNIX_SOCK_PATH,
         .shm_path = IVSHMEM_SERVER_DEFAULT_SHM_PATH,
         .use_shm_open = true,
@@ -207,6 +214,11 @@ main(int argc, char *argv[])
      */
     printf("*** Example code, do not use in production ***\n");
 
+    qemu_init_exec_dir(argv[0]);
+
+    default_pid_file = ivshmem_server_get_default_pid_file();
+    args.pid_file = default_pid_file;
+
     /* parse arguments, will exit on error */
     ivshmem_server_parse_args(&args, argc, argv);
 
-- 
2.38.1

