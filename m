Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282901; x=1695887701;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+dsr6eyuJ9VSJfAqFZ+Sn8WOb7QBRrG/FmPzrYRLnEY=;
 b=kghmKI2t+7hCw+dW1XCh8pCpDmR9UzHdrFxJy6V1TgF0OfAorE1NY36bOZpnUlUe++
 DRdl5XqapaQ59e79DfCm1iy/FfrTpsLe6aYz6BUdoHddSK1/O+I7pnACCjsDS7MF7KNO
 Xf58mCyiZnLgGCk+G69BfiTv9mIoX88eJHKhAbRs3AbBbC7Y37JsrKwJKKQH5hTBXc2Z
 9zIhwZR7m9avf9eVqiJfLvIbbUSyWTXgQUuNUaEpu9RAiPmbiu6wFD+YZtBf/sPqqr1h
 5R36EzKmo8KsreXZkHkCACcb9+ZjJ2JEKQwd4d5pUtE67bro06FPqi4d4LQJVJ8q69R/
 gOEg==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:18 +0900
Message-ID: <20230921075425.16738-5-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 4/8] qga: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the default state directory.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 qga/main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/qga/main.c b/qga/main.c
index 8668b9f3d3..145ee02df3 100644
--- a/qga/main.c
+++ b/qga/main.c
@@ -45,12 +45,11 @@
 #define QGA_VIRTIO_PATH_DEFAULT "/dev/virtio-ports/org.qemu.guest_agent.0"
 #endif /* CONFIG_BSD */
 #define QGA_SERIAL_PATH_DEFAULT "/dev/ttyS0"
-#define QGA_STATE_RELATIVE_DIR  "run"
 #else
 #define QGA_VIRTIO_PATH_DEFAULT "\\\\.\\Global\\org.qemu.guest_agent.0"
-#define QGA_STATE_RELATIVE_DIR  "qemu-ga"
 #define QGA_SERIAL_PATH_DEFAULT "COM1"
 #endif
+#define QGA_STATE_RELATIVE_DIR  "qemu-ga"
 #ifdef CONFIG_FSFREEZE
 #define QGA_FSFREEZE_HOOK_DEFAULT CONFIG_QEMU_CONFDIR "/fsfreeze-hook"
 #endif
@@ -129,12 +128,12 @@ static void stop_agent(GAState *s, bool requested);
 static void
 init_dfl_pathnames(void)
 {
-    g_autofree char *state = qemu_get_local_state_dir();
+    g_autofree char *run = qemu_get_runtime_dir();
 
     g_assert(dfl_pathnames.state_dir == NULL);
     g_assert(dfl_pathnames.pidfile == NULL);
-    dfl_pathnames.state_dir = g_build_filename(state, QGA_STATE_RELATIVE_DIR, NULL);
-    dfl_pathnames.pidfile = g_build_filename(state, QGA_STATE_RELATIVE_DIR, "qemu-ga.pid", NULL);
+    dfl_pathnames.state_dir = g_build_filename(run, QGA_STATE_RELATIVE_DIR, NULL);
+    dfl_pathnames.pidfile = g_build_filename(run, QGA_STATE_RELATIVE_DIR, "qemu-ga.pid", NULL);
 }
 
 static void quit_handler(int sig)
-- 
2.41.0

