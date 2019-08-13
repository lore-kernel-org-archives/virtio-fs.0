DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=pzOk7WV9d9M+uZRq6CAI5T4X0VA1g5jlWhhL6CFx8AE=;
	b=mKU5lRvGsO2AFWc2FlaOkBtRZRo9rQAVT1yStuUCbBrCjj2uvIqM6nrNHElHEsWFgo
	uWjtWN4BX6v/ZAIzB7KqnM4wpCHW/ldeqEJaYfBaYLVl5fpPwUdDG1UydS95eSX5ypJ0
	p7hy+XuClgJ8yP79sxzY+F9yDSKs0hPdL/QQYhQEmZmURO+vpppfsWZw2gKWvphAjCkY
	K6AwJ5qrEOOjDN9V2T96V37OLOdy9aSxPqAqMKbT2LLC/6J6jgS8g4rWA8IbuvCACV5A
	Tw3dH4HNuxMdAMOjlidpRciuiUKenReYJhWF6pGbXnj29BuXRADi596rYwwaZUXGzpH+
	1Lcw==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Tue, 13 Aug 2019 16:06:45 -0400
Message-Id: <20190813200645.13819-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH v3] virtiofsd: Prevent multiply running with
	same vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, piaojun <piaojun@huawei.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

virtiofsd can run multiply even if the vhost_user_socket is same path.

  ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
  [1] 244965
  virtio_session_mount: Waiting for vhost-user socket connection...
  ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
  [2] 244966
  virtio_session_mount: Waiting for vhost-user socket connection...
  ]#

The user will get confused about the situation and maybe the cause of the
unexpected problem. So it's better to prevent the multiple running.

Create a regular file under localstatedir directory to exclude the
vhost_user_socket. To create and lock the file, use qemu_write_pidfile()
because the API has some sanity checks and file lock.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
---
 contrib/virtiofsd/fuse_i.h        |  1 +
 contrib/virtiofsd/fuse_lowlevel.c |  6 ++++
 contrib/virtiofsd/fuse_virtio.c   | 51 +++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
index ff6e1b75ba..89cc20a787 100644
--- a/contrib/virtiofsd/fuse_i.h
+++ b/contrib/virtiofsd/fuse_i.h
@@ -72,6 +72,7 @@ struct fuse_session {
         char *vu_socket_path;
         int   vu_listen_fd;
         int   vu_socketfd;
+        char *vu_socket_lock;
         struct fv_VuDev *virtio_dev;
 };
 
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 8adc4b1ab8..9d41b48d73 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -16,6 +16,7 @@
 #include "fuse_misc.h"
 #include "fuse_virtio.h"
 
+#include <glib.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stddef.h>
@@ -2587,6 +2588,11 @@ void fuse_session_destroy(struct fuse_session *se)
 	free(se->vu_socket_path);
 	se->vu_socket_path = NULL;
 
+	if (se->vu_socket_lock) {
+		g_free(se->vu_socket_lock);
+		se->vu_socket_lock = NULL;
+	}
+
 	free(se);
 }
 
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 083e4fc317..927f379f7a 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -32,6 +32,9 @@
 
 #include "contrib/libvhost-user/libvhost-user.h"
 
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+
 struct fv_VuDev;
 struct fv_QueueInfo {
         pthread_t thread;
@@ -862,6 +865,43 @@ int virtio_loop(struct fuse_session *se)
        return 0;
 }
 
+static void strreplace(char *s, char old, char new)
+{
+        for (; *s; ++s)
+                if (*s == old)
+                        *s = new;
+}
+
+static int fv_socket_lock(struct fuse_session *se)
+{
+        char *dir, *sk_name;
+        Error *local_err = NULL;
+        int ret = -1;
+
+        dir = qemu_get_local_state_pathname("run/virtiofsd");
+
+        if (g_mkdir_with_parents(dir, S_IRWXU) < -1) {
+                fuse_err("%s: Failed to create directory %s: %s",
+                        __func__, dir, strerror(errno));
+                return ret;
+        }
+
+        sk_name = g_strdup(se->vu_socket_path);
+        strreplace(sk_name, '/', '.');
+        se->vu_socket_lock = g_strdup_printf("%s/%s.pid", dir, sk_name);
+
+        if (!qemu_write_pidfile(se->vu_socket_lock, &local_err)) {
+                error_report_err(local_err);
+        } else {
+                ret = 0;
+        }
+
+        g_free(sk_name);
+        g_free(dir);
+
+        return ret;
+}
+
 static int fv_create_listen_socket(struct fuse_session *se)
 {
         struct sockaddr_un un;
@@ -876,6 +916,17 @@ static int fv_create_listen_socket(struct fuse_session *se)
                 return -1;
         }
 
+        if (!strlen(se->vu_socket_path)) {
+                fuse_err("Socket path is NULL\n");
+                return -1;
+        }
+
+        /* Check the vu_socket_path is already used */
+        if (fv_socket_lock(se) == -1) {
+                fuse_err("%s: Socket lock file creation failed\n", __func__);
+                return -1;
+        }
+
         /* Create the Unix socket to communicate with qemu
          * based on QEMU's vhost-user-bridge
          */
-- 
2.18.1

