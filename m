Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=AC+ag6DjlMRVYIRoMVgQ7eyLCeIppVPRSyLkAkRwpvs=;
 b=Rg2YfPcHB9D9stGXkj+2qQcpiHgjKDmcb3ss4c6FOkou+38XkDHiFgJFCky6oztAEP
 t1dHuEGNlAwA9GZV6wru04vjq5kAFU+zqdMrL/UUG3JFptzRX3uhc1RUNewgc8NH7QcO
 ZL+JEzsP5bMu149evctM+f9NszU+6Dt/0xi45LTD34VhdXQgdqWoBXTHxzq/kEdYevZH
 qZv7nryajoDvjRGTsJlEsOfZ2RozmWjERANZ0xW1Zmn5qwmxSBbBFsuYWBooVapJTebS
 0W0QvqPQ0bjWO9CuyRBQxuw94/fBy4fKfkTM1IqizZXghSe30mXMD+pOSvo6KzpJ0UZP
 H3MA==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 19:06:29 +0900
Message-Id: <20221110100629.61496-11-akihiko.odaki@daynix.com>
In-Reply-To: <20221110100629.61496-1-akihiko.odaki@daynix.com>
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v2 10/10] spice-app: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() provides QEMU-specific fallback of runtime
directory.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 ui/spice-app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ui/spice-app.c b/ui/spice-app.c
index 7e71e18da9..feb162baa7 100644
--- a/ui/spice-app.c
+++ b/ui/spice-app.c
@@ -145,8 +145,8 @@ static void spice_app_display_early_init(DisplayOptions *opts)
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
2.38.1

