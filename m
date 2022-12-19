Return-Path: <berrange@redhat.com>
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Mon, 19 Dec 2022 08:02:01 -0500
Message-Id: <20221219130205.687815-3-berrange@redhat.com>
In-Reply-To: <20221219130205.687815-1-berrange@redhat.com>
References: <20221219130205.687815-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/6] hw/xen: use G_GNUC_PRINTF/SCANF for various
 functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 hw/xen/xen-bus.c                | 1 +
 hw/xen/xen_pvdev.c              | 1 +
 include/hw/xen/xen-bus-helper.h | 6 ++++--
 include/hw/xen/xen-bus.h        | 3 ++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index 645a29a5a0..df3f6b9ae0 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -561,6 +561,7 @@ void xen_device_backend_printf(XenDevice *xendev, const char *key,
     }
 }
 
+G_GNUC_SCANF(3, 4)
 static int xen_device_backend_scanf(XenDevice *xendev, const char *key,
                                     const char *fmt, ...)
 {
diff --git a/hw/xen/xen_pvdev.c b/hw/xen/xen_pvdev.c
index 037152f063..1a5177b354 100644
--- a/hw/xen/xen_pvdev.c
+++ b/hw/xen/xen_pvdev.c
@@ -196,6 +196,7 @@ const char *xenbus_strstate(enum xenbus_state state)
  *  2 == noisy debug messages (logfile only).
  *  3 == will flood your log (logfile only).
  */
+G_GNUC_PRINTF(3, 0)
 static void xen_pv_output_msg(struct XenLegacyDevice *xendev,
                               FILE *f, const char *fmt, va_list args)
 {
diff --git a/include/hw/xen/xen-bus-helper.h b/include/hw/xen/xen-bus-helper.h
index 629a904d1a..8782f30550 100644
--- a/include/hw/xen/xen-bus-helper.h
+++ b/include/hw/xen/xen-bus-helper.h
@@ -31,10 +31,12 @@ void xs_node_printf(struct xs_handle *xsh,  xs_transaction_t tid,
 /* Read from node/key unless node is empty, in which case read from key */
 int xs_node_vscanf(struct xs_handle *xsh,  xs_transaction_t tid,
                    const char *node, const char *key, Error **errp,
-                   const char *fmt, va_list ap);
+                   const char *fmt, va_list ap)
+    G_GNUC_SCANF(6, 0);
 int xs_node_scanf(struct xs_handle *xsh,  xs_transaction_t tid,
                   const char *node, const char *key, Error **errp,
-                  const char *fmt, ...);
+                  const char *fmt, ...)
+    G_GNUC_SCANF(6, 7);
 
 /* Watch node/key unless node is empty, in which case watch key */
 void xs_node_watch(struct xs_handle *xsh, const char *node, const char *key,
diff --git a/include/hw/xen/xen-bus.h b/include/hw/xen/xen-bus.h
index 713e763348..4d966a2dbb 100644
--- a/include/hw/xen/xen-bus.h
+++ b/include/hw/xen/xen-bus.h
@@ -94,7 +94,8 @@ void xen_device_frontend_printf(XenDevice *xendev, const char *key,
     G_GNUC_PRINTF(3, 4);
 
 int xen_device_frontend_scanf(XenDevice *xendev, const char *key,
-                              const char *fmt, ...);
+                              const char *fmt, ...)
+    G_GNUC_SCANF(3, 4);
 
 void xen_device_set_max_grant_refs(XenDevice *xendev, unsigned int nr_refs,
                                    Error **errp);
-- 
2.38.1

