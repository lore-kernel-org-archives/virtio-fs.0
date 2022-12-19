Return-Path: <berrange@redhat.com>
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Mon, 19 Dec 2022 08:02:03 -0500
Message-Id: <20221219130205.687815-5-berrange@redhat.com>
In-Reply-To: <20221219130205.687815-1-berrange@redhat.com>
References: <20221219130205.687815-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/6] util/error: add G_GNUC_PRINTF for various
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
 util/error-report.c | 1 +
 util/error.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/util/error-report.c b/util/error-report.c
index 5edb2e6040..6e44a55732 100644
--- a/util/error-report.c
+++ b/util/error-report.c
@@ -193,6 +193,7 @@ real_time_iso8601(void)
  * a single phrase, with no newline or trailing punctuation.
  * Prepend the current location and append a newline.
  */
+G_GNUC_PRINTF(2, 0)
 static void vreport(report_type type, const char *fmt, va_list ap)
 {
     gchar *timestr;
diff --git a/util/error.c b/util/error.c
index b6c89d1412..1e7af665b8 100644
--- a/util/error.c
+++ b/util/error.c
@@ -45,6 +45,7 @@ static void error_handle_fatal(Error **errp, Error *err)
     }
 }
 
+G_GNUC_PRINTF(6, 0)
 static void error_setv(Error **errp,
                        const char *src, int line, const char *func,
                        ErrorClass err_class, const char *fmt, va_list ap,
-- 
2.38.1

