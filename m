Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695282912; x=1695887712;
 darn=redhat.com; 
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=XX44FJTRZg1+PqvDSJfTem/Daafu9UBqtypGiG20los=;
 b=NkJlPzcFE0bIuvFQs91fPJQ3imVARL5RTN27x3C8mmUKi0t73Y/XeGnFRIHzPKoXca
 rsA2BUtqUsE1001wO2yqolrQ2OREIxkcoGybtKDyuaL10cvWyqgZO1drSajJV0VNVmxR
 DOYT0EolD2LaV8AU8qJF2AuS07tWtQbCU+APz74Vefp8iN4v9bumo57siSHCdiUDT4Y7
 CyYVlv4+zmS46qS86mRRFvkusoWpN16QmCWfsJqGJCzwUFHJrkS5HqQH2TXuSn/lNpnS
 hgjTO0j/bQEXYt4ZgUAYY/nPJc7wYSFJLim8fn5mJ1Cw6s6S18NfpVATpfhnWMQbBGQo
 SN+w==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 21 Sep 2023 16:54:20 +0900
Message-ID: <20230921075425.16738-7-akihiko.odaki@daynix.com>
In-Reply-To: <20230921075425.16738-1-akihiko.odaki@daynix.com>
References: <20230921075425.16738-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 6/8] module: Use qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>, Akihiko Odaki <akihiko.odaki@daynix.com>

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
2.41.0

