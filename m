Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282923; x=1695887723;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=D7XgavntPO93Ri3KubETdfMRGZmmewXPeIHFa3pR3w4=;
 b=AnVh/Fl12HqfRVuE/Dg+Thl6fKqADXrJN1bibToVl73kLwz00s4AWqSHIzDsti0Wp+
 X0ExP4ClwgwpXu/wlQMMaHNXfrO8GrbesL0icJVkg3U9NtTdUv33iykcSyznKoSxfQgv
 rqNux/gbK2fiTCgrKbS6VsgPA/dHa4hl5N61bfdUYZOfrti8FwkTyGAwXCg3yvys0lww
 H0PDh47vhPQZBa2VRqbCGXrAFoL3g+g/BkPQbXlAg04v7FPnnNQOyfgzxJwkRD5lhr2c
 QLpl3cTBUwur3BeQuScfX9CuMeGXKU0RiR6j2ByGXPlvVl006rs4BTfC2gF/xaINBhNI
 ZsjQ==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:22 +0900
Message-ID: <20230921075425.16738-9-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 8/8] spice-app: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() provides QEMU-specific fallback of runtime
directory.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 ui/spice-app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ui/spice-app.c b/ui/spice-app.c
index 405fb7f9f5..f6c2343213 100644
--- a/ui/spice-app.c
+++ b/ui/spice-app.c
@@ -151,8 +151,8 @@ static void spice_app_display_early_init(DisplayOptions *opts)
     atexit(spice_app_atexit);
 
     if (qemu_name) {
-        app_dir = g_build_filename(g_get_user_runtime_dir(),
-                                   "qemu", qemu_name, NULL);
+        g_autofree char *run = qemu_get_runtime_dir();
+        app_dir = g_build_filename(run, "qemu", qemu_name, NULL);
         if (g_mkdir_with_parents(app_dir, S_IRWXU) < -1) {
             error_report("Failed to create directory %s: %s",
                          app_dir, strerror(errno));
-- 
2.41.0

