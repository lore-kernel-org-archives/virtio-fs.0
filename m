Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=yAOm4xAwUIMS3nIWuITf2mBCrb5XaCIFaM5bi4ZPZPo=;
 b=nowE1IAA3TGJ2TwAu946s1Mt5gRJ4WGCCeomIEZ2aw6iXrsh7KC7oG83L7z7jzy/NR
 YFglAZm/Cv/A1CBKViAsr0k5QuhF8zC8gWCXHenDZXkTE2auK3xvczb9WAt+iTbF5HSE
 blEk20WqLHxh1WNBY5guI8BTPR5RriHNsuu+lGzXqjuSMsAnJl/s+7DIiutcV7bhmJyG
 bG5KlZeOmoJUs9rZNXfPe/On20/9Ji9Ad7XMK82WhE+1X5AcdDKnU4kYFLn4lT8NVzh+
 b8mbwdCH9XJI128sMewCCTNTza/khpSj32KMB6zNR1BMU7DXv3M2u3TL+Cv1BKcRfXA4
 A0EA==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 15:23:26 +0900
Message-Id: <20221110062329.13363-8-akihiko.odaki@daynix.com>
In-Reply-To: <20221110062329.13363-1-akihiko.odaki@daynix.com>
References: <20221110062329.13363-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH 07/10] virtiofsd: Use qemu_get_runtime_dir()
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

