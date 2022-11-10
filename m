Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=1uEBjaTElDdg0Zg5fYZb2Jay1kxJRBlw3oI5Sxs4u+Q=;
 b=D5xo8sPosWK2ntf5I3cR4vD2TXYL5XzKO9qL+N684tiwulV+W14CTiXN3dxv57sZvg
 O2Xre5SxtvF2IwBIPbL4hiJaLWMn8rOzNnFeXNBK19ey3sdVdI0l4LFY2jPwcfK+X3p8
 T6gFow8JD7lhLHe1UVgg/J8eTtEHGKU5eME9rP6HvaAO9Z9NaYdcCJgXg5exBYeAHBRL
 1LWD3PQkDNrUrv7qyaxsb39qojhggYRdmPBr0eh+luzmmkj3pto3aIr07w4HLycrwrau
 NUA+RN0CqJrGc6WrYso7a64w2VrfMRsn9626gT6tk8ZoTQUC3IQr6Cf77nT/lfrkNjEJ
 0yeQ==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 15:23:27 +0900
Message-Id: <20221110062329.13363-9-akihiko.odaki@daynix.com>
In-Reply-To: <20221110062329.13363-1-akihiko.odaki@daynix.com>
References: <20221110062329.13363-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH 08/10] module: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

qemu_get_runtime_dir() is used to construct the path to module upgrades.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 util/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/util/module.c b/util/module.c
index 8ddb0e18f5..50f52b7232 100644
--- a/util/module.c
+++ b/util/module.c
@@ -279,7 +279,8 @@ bool module_load_one(const char *prefix, const char *lib_name, bool mayfail)
     version_dir = g_strcanon(g_strdup(QEMU_PKGVERSION),
                              G_CSET_A_2_Z G_CSET_a_2_z G_CSET_DIGITS "+-.~",
                              '_');
-    dirs[n_dirs++] = g_strdup_printf("/var/run/qemu/%s", version_dir);
+    g_autofree char *run = qemu_get_runtime_dir();
+    dirs[n_dirs++] = g_build_filename(run, "qemu", version_dir, NULL);
 #endif
 
     assert(n_dirs <= ARRAY_SIZE(dirs));
-- 
2.38.1

