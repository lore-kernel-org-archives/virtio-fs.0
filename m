Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BJn5Gpsfix8eR37iFYW0tYNid+vOro5KOtMhRy0rf4c=;
 b=EXLxVaqBSxFla3mrNQ0uCKB4AVKP5YbOPNhdR37wmBcgLqpmrG95sOnnaDp79D9NvT
 gtCBOIrQ/u5D7BEg87qNA0ZdDnNdRla2UXj/BXAldgviwIm484QxC8uOsIEMBAp7N+bO
 tExqdyK5VLHC9Cvv2DZULt/F8KiBFTmxVsT13D4zSAws/o5z+QYQojZSTSIwSMRsB1+P
 l1O6p+RmS3Jhxqrv4y0T/1NK4cCPUtOi6MSIZE9899SZZTbTLb2yRJPZHZU89sOF2TtC
 lRASyQpeNEu070oW6wOYwcQkEE+LbxMOul2y2DnEfGbW/dIbSoXuyN618OC28TscBWv5
 uRyw==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 10 Nov 2022 19:06:27 +0900
Message-Id: <20221110100629.61496-9-akihiko.odaki@daynix.com>
In-Reply-To: <20221110100629.61496-1-akihiko.odaki@daynix.com>
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v2 08/10] module: Use qemu_get_runtime_dir()
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
index 32e263163c..580658edf4 100644
--- a/util/module.c
+++ b/util/module.c
@@ -242,7 +242,8 @@ int module_load(const char *prefix, const char *name, Error **errp)
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

