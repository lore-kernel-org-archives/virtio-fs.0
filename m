Return-Path: <berrange@redhat.com>
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Date: Mon, 19 Dec 2022 08:02:04 -0500
Message-Id: <20221219130205.687815-6-berrange@redhat.com>
In-Reply-To: <20221219130205.687815-1-berrange@redhat.com>
References: <20221219130205.687815-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/6] tests: add G_GNUC_PRINTF for various
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
 tests/qtest/ahci-test.c           |  3 +++
 tests/qtest/arm-cpu-features.c    |  1 +
 tests/qtest/erst-test.c           |  2 +-
 tests/qtest/ide-test.c            |  3 ++-
 tests/qtest/ivshmem-test.c        |  4 ++--
 tests/qtest/libqmp.c              |  2 +-
 tests/qtest/libqos/libqos-pc.h    |  6 ++++--
 tests/qtest/libqos/libqos-spapr.h |  6 ++++--
 tests/qtest/libqos/libqos.h       |  6 ++++--
 tests/qtest/libqos/virtio-9p.c    |  1 +
 tests/qtest/migration-helpers.h   |  1 +
 tests/qtest/rtas-test.c           |  2 +-
 tests/qtest/usb-hcd-uhci-test.c   |  4 ++--
 tests/unit/test-qmp-cmds.c        | 13 +++++++++----
 14 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/tests/qtest/ahci-test.c b/tests/qtest/ahci-test.c
index 66652fed04..1967cd5898 100644
--- a/tests/qtest/ahci-test.c
+++ b/tests/qtest/ahci-test.c
@@ -154,6 +154,7 @@ static void ahci_migrate(AHCIQState *from, AHCIQState *to, const char *uri)
 /**
  * Start a Q35 machine and bookmark a handle to the AHCI device.
  */
+G_GNUC_PRINTF(1, 0)
 static AHCIQState *ahci_vboot(const char *cli, va_list ap)
 {
     AHCIQState *s;
@@ -171,6 +172,7 @@ static AHCIQState *ahci_vboot(const char *cli, va_list ap)
 /**
  * Start a Q35 machine and bookmark a handle to the AHCI device.
  */
+G_GNUC_PRINTF(1, 2)
 static AHCIQState *ahci_boot(const char *cli, ...)
 {
     AHCIQState *s;
@@ -209,6 +211,7 @@ static void ahci_shutdown(AHCIQState *ahci)
  * Boot and fully enable the HBA device.
  * @see ahci_boot, ahci_pci_enable and ahci_hba_enable.
  */
+G_GNUC_PRINTF(1, 2)
 static AHCIQState *ahci_boot_and_enable(const char *cli, ...)
 {
     AHCIQState *ahci;
diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index 5a14527386..8691802950 100644
--- a/tests/qtest/arm-cpu-features.c
+++ b/tests/qtest/arm-cpu-features.c
@@ -32,6 +32,7 @@ static QDict *do_query_no_props(QTestState *qts, const char *cpu_type)
                           QUERY_TAIL, cpu_type);
 }
 
+G_GNUC_PRINTF(3, 4)
 static QDict *do_query(QTestState *qts, const char *cpu_type,
                        const char *fmt, ...)
 {
diff --git a/tests/qtest/erst-test.c b/tests/qtest/erst-test.c
index 974e8bcfe5..c45bee7f05 100644
--- a/tests/qtest/erst-test.c
+++ b/tests/qtest/erst-test.c
@@ -98,7 +98,7 @@ static void setup_vm_cmd(ERSTState *s, const char *cmd)
     const char *arch = qtest_get_arch();
 
     if (strcmp(arch, "i386") == 0 || strcmp(arch, "x86_64") == 0) {
-        s->qs = qtest_pc_boot(cmd);
+        s->qs = qtest_pc_boot("%s", cmd);
     } else {
         g_printerr("erst-test tests are only available on x86\n");
         exit(EXIT_FAILURE);
diff --git a/tests/qtest/ide-test.c b/tests/qtest/ide-test.c
index dbe1563b23..dcb050bf9b 100644
--- a/tests/qtest/ide-test.c
+++ b/tests/qtest/ide-test.c
@@ -125,6 +125,7 @@ static QGuestAllocator guest_malloc;
 static char *tmp_path[2];
 static char *debug_path;
 
+G_GNUC_PRINTF(1, 2)
 static QTestState *ide_test_start(const char *cmdline_fmt, ...)
 {
     QTestState *qts;
@@ -788,7 +789,7 @@ static void test_flush_nodev(void)
     QPCIDevice *dev;
     QPCIBar bmdma_bar, ide_bar;
 
-    qts = ide_test_start("");
+    qts = ide_test_start("%s", "");
 
     dev = get_pci_device(qts, &bmdma_bar, &ide_bar);
 
diff --git a/tests/qtest/ivshmem-test.c b/tests/qtest/ivshmem-test.c
index cd550c8935..9bf8e78df6 100644
--- a/tests/qtest/ivshmem-test.c
+++ b/tests/qtest/ivshmem-test.c
@@ -109,9 +109,9 @@ static void setup_vm_cmd(IVState *s, const char *cmd, bool msix)
     const char *arch = qtest_get_arch();
 
     if (strcmp(arch, "i386") == 0 || strcmp(arch, "x86_64") == 0) {
-        s->qs = qtest_pc_boot(cmd);
+        s->qs = qtest_pc_boot("%s", cmd);
     } else if (strcmp(arch, "ppc64") == 0) {
-        s->qs = qtest_spapr_boot(cmd);
+        s->qs = qtest_spapr_boot("%s", cmd);
     } else {
         g_printerr("ivshmem-test tests are only available on x86 or ppc64\n");
         exit(EXIT_FAILURE);
diff --git a/tests/qtest/libqmp.c b/tests/qtest/libqmp.c
index 2b08382e5d..a89cab03c3 100644
--- a/tests/qtest/libqmp.c
+++ b/tests/qtest/libqmp.c
@@ -134,7 +134,7 @@ static void socket_send_fds(int socket_fd, int *fds, size_t fds_num,
  * in the case that they choose to discard all replies up until
  * a particular EVENT is received.
  */
-static void
+static G_GNUC_PRINTF(4, 0) void
 _qmp_fd_vsend_fds(int fd, int *fds, size_t fds_num,
                   const char *fmt, va_list ap)
 {
diff --git a/tests/qtest/libqos/libqos-pc.h b/tests/qtest/libqos/libqos-pc.h
index 1a9923ead4..a2e4209a49 100644
--- a/tests/qtest/libqos/libqos-pc.h
+++ b/tests/qtest/libqos/libqos-pc.h
@@ -3,8 +3,10 @@
 
 #include "libqos.h"
 
-QOSState *qtest_pc_vboot(const char *cmdline_fmt, va_list ap);
-QOSState *qtest_pc_boot(const char *cmdline_fmt, ...);
+QOSState *qtest_pc_vboot(const char *cmdline_fmt, va_list ap)
+    G_GNUC_PRINTF(1, 0);
+QOSState *qtest_pc_boot(const char *cmdline_fmt, ...)
+    G_GNUC_PRINTF(1, 2);
 void qtest_pc_shutdown(QOSState *qs);
 
 #endif
diff --git a/tests/qtest/libqos/libqos-spapr.h b/tests/qtest/libqos/libqos-spapr.h
index c61338917a..e4483c14f8 100644
--- a/tests/qtest/libqos/libqos-spapr.h
+++ b/tests/qtest/libqos/libqos-spapr.h
@@ -3,8 +3,10 @@
 
 #include "libqos.h"
 
-QOSState *qtest_spapr_vboot(const char *cmdline_fmt, va_list ap);
-QOSState *qtest_spapr_boot(const char *cmdline_fmt, ...);
+QOSState *qtest_spapr_vboot(const char *cmdline_fmt, va_list ap)
+    G_GNUC_PRINTF(1, 0);
+QOSState *qtest_spapr_boot(const char *cmdline_fmt, ...)
+    G_GNUC_PRINTF(1, 2);
 void qtest_spapr_shutdown(QOSState *qs);
 
 /* List of capabilities needed to silence warnings with TCG */
diff --git a/tests/qtest/libqos/libqos.h b/tests/qtest/libqos/libqos.h
index 9b4dd509f0..12d05b2365 100644
--- a/tests/qtest/libqos/libqos.h
+++ b/tests/qtest/libqos/libqos.h
@@ -21,8 +21,10 @@ struct QOSState {
     QOSOps *ops;
 };
 
-QOSState *qtest_vboot(QOSOps *ops, const char *cmdline_fmt, va_list ap);
-QOSState *qtest_boot(QOSOps *ops, const char *cmdline_fmt, ...);
+QOSState *qtest_vboot(QOSOps *ops, const char *cmdline_fmt, va_list ap)
+    G_GNUC_PRINTF(2, 0);
+QOSState *qtest_boot(QOSOps *ops, const char *cmdline_fmt, ...)
+    G_GNUC_PRINTF(2, 3);
 void qtest_common_shutdown(QOSState *qs);
 void qtest_shutdown(QOSState *qs);
 bool have_qemu_img(void);
diff --git a/tests/qtest/libqos/virtio-9p.c b/tests/qtest/libqos/virtio-9p.c
index 7f21028256..186fcc1141 100644
--- a/tests/qtest/libqos/virtio-9p.c
+++ b/tests/qtest/libqos/virtio-9p.c
@@ -211,6 +211,7 @@ static void *virtio_9p_pci_create(void *pci_bus, QGuestAllocator *t_alloc,
  *                      variable arguments of this function to this
  *                      replacement string
  */
+G_GNUC_PRINTF(3, 4)
 static void regex_replace(GString *haystack, const char *pattern,
                           const char *replace_fmt, ...)
 {
diff --git a/tests/qtest/migration-helpers.h b/tests/qtest/migration-helpers.h
index db0684de48..a188b62787 100644
--- a/tests/qtest/migration-helpers.h
+++ b/tests/qtest/migration-helpers.h
@@ -25,6 +25,7 @@ QDict *wait_command_fd(QTestState *who, int fd, const char *command, ...);
 G_GNUC_PRINTF(2, 3)
 QDict *wait_command(QTestState *who, const char *command, ...);
 
+G_GNUC_PRINTF(2, 3)
 QDict *qmp_command(QTestState *who, const char *command, ...);
 
 G_GNUC_PRINTF(3, 4)
diff --git a/tests/qtest/rtas-test.c b/tests/qtest/rtas-test.c
index 50df60e5b2..1ba42b37d2 100644
--- a/tests/qtest/rtas-test.c
+++ b/tests/qtest/rtas-test.c
@@ -13,7 +13,7 @@ static void run_test_rtas_get_time_of_day(const char *machine)
     uint64_t ret;
     time_t t1, t2;
 
-    qs = qtest_spapr_boot(machine);
+    qs = qtest_spapr_boot("%s", machine);
 
     t1 = time(NULL);
     ret = qrtas_get_time_of_day(qs->qts, &qs->alloc, &tm, &ns);
diff --git a/tests/qtest/usb-hcd-uhci-test.c b/tests/qtest/usb-hcd-uhci-test.c
index 7a117b64d9..f264d2bf73 100644
--- a/tests/qtest/usb-hcd-uhci-test.c
+++ b/tests/qtest/usb-hcd-uhci-test.c
@@ -72,9 +72,9 @@ int main(int argc, char **argv)
     qtest_add_func("/uhci/pci/hotplug/usb-storage", test_usb_storage_hotplug);
 
     if (strcmp(arch, "i386") == 0 || strcmp(arch, "x86_64") == 0) {
-        qs = qtest_pc_boot(cmd);
+        qs = qtest_pc_boot("%s", cmd);
     } else if (strcmp(arch, "ppc64") == 0) {
-        qs = qtest_spapr_boot(cmd);
+        qs = qtest_spapr_boot("%s", cmd);
     } else {
         g_printerr("usb-hcd-uhci-test tests are only "
                    "available on x86 or ppc64\n");
diff --git a/tests/unit/test-qmp-cmds.c b/tests/unit/test-qmp-cmds.c
index 2373cd64cb..6d52b4e5d8 100644
--- a/tests/unit/test-qmp-cmds.c
+++ b/tests/unit/test-qmp-cmds.c
@@ -138,6 +138,7 @@ void qmp___org_qemu_x_command(__org_qemu_x_EnumList *a,
 }
 
 
+G_GNUC_PRINTF(2, 3)
 static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
 {
     va_list ap;
@@ -160,6 +161,7 @@ static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
     return ret;
 }
 
+G_GNUC_PRINTF(3, 4)
 static void do_qmp_dispatch_error(bool allow_oob, ErrorClass cls,
                                   const char *template, ...)
 {
@@ -269,7 +271,7 @@ static void test_dispatch_cmd_io(void)
 
 static void test_dispatch_cmd_deprecated(void)
 {
-    const char *cmd = "{ 'execute': 'test-command-features1' }";
+    #define cmd "{ 'execute': 'test-command-features1' }"
     QDict *ret;
 
     memset(&compat_policy, 0, sizeof(compat_policy));
@@ -287,12 +289,13 @@ static void test_dispatch_cmd_deprecated(void)
 
     compat_policy.deprecated_input = COMPAT_POLICY_INPUT_REJECT;
     do_qmp_dispatch_error(false, ERROR_CLASS_COMMAND_NOT_FOUND, cmd);
+    #undef cmd
 }
 
 static void test_dispatch_cmd_arg_deprecated(void)
 {
-    const char *cmd = "{ 'execute': 'test-features0',"
-        " 'arguments': { 'fs1': { 'foo': 42 } } }";
+    #define cmd "{ 'execute': 'test-features0'," \
+        " 'arguments': { 'fs1': { 'foo': 42 } } }"
     QDict *ret;
 
     memset(&compat_policy, 0, sizeof(compat_policy));
@@ -310,11 +313,12 @@ static void test_dispatch_cmd_arg_deprecated(void)
 
     compat_policy.deprecated_input = COMPAT_POLICY_INPUT_REJECT;
     do_qmp_dispatch_error(false, ERROR_CLASS_GENERIC_ERROR, cmd);
+    #undef cmd
 }
 
 static void test_dispatch_cmd_ret_deprecated(void)
 {
-    const char *cmd = "{ 'execute': 'test-features0' }";
+    #define cmd "{ 'execute': 'test-features0' }"
     QDict *ret;
 
     memset(&compat_policy, 0, sizeof(compat_policy));
@@ -334,6 +338,7 @@ static void test_dispatch_cmd_ret_deprecated(void)
     ret = qobject_to(QDict, do_qmp_dispatch(false, cmd));
     assert(ret && qdict_size(ret) == 0);
     qobject_unref(ret);
+    #undef cmd
 }
 
 /* test generated dealloc functions for generated types */
-- 
2.38.1

