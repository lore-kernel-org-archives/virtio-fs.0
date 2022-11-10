Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=yAOm4xAwUIMS3nIWuITf2mBCrb5XaCIFaM5bi4ZPZPo=;
 b=FzX5sSAo1Yghg/9iJmCKRz6A0J0oBZyMFd7GIvtQkSc0AtS+KpbwVYSKQ0JviepakQ
 dSCZ1fwzZvpS/VyYyQtQBe37/PW7POcjekM7H2TK+YpEpxCpGspq1RwJVwTGQxZ6Z/Im
 GhWOPYgQbGPIf5Oq/Asbc3faa4temdUQpuUARn5A7CXA0Xio6L6nmI+HJBdtocy5+rMS
 5navhqpgfZpgapSPGqmknLkhvDH01TZV6hxW93pfT3vYD3yx/I9e7Khrq9GaRV+0SB1S
 e+jBx3++sqv8HcX+vta9efK+01F6sMPI8L29yK3U6JNPf8t+BUC2blqIXnDQrz0rtzSC
 9lBw==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 19:06:26 +0900
Message-Id: <20221110100629.61496-8-akihiko.odaki@daynix.com>
In-Reply-To: <20221110100629.61496-1-akihiko.odaki@daynix.com>
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v2 07/10] virtiofsd: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the path to a lock file.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 tools/virtiofsd/fuse_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 9368e292e4..b9eeed85e6 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -901,12 +901,12 @@ static bool fv_socket_lock(struct fuse_session *se)
 {
     g_autofree gchar *sk_name = NULL;
     g_autofree gchar *pidfile = NULL;
-    g_autofree gchar *state = NULL;
+    g_autofree gchar *run = NULL;
     g_autofree gchar *dir = NULL;
     Error *local_err = NULL;
 
-    state = qemu_get_local_state_dir();
-    dir = g_build_filename(state, "run", "virtiofsd", NULL);
+    run = qemu_get_runtime_dir();
+    dir = g_build_filename(run, "virtiofsd", NULL);
 
     if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
         fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",
-- 
2.38.1

