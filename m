Return-Path: <stefan@weilnetz.de>
From: Stefan Weil <sw@weilnetz.de>
Date: Sun, 30 Oct 2022 11:59:44 +0100
Message-Id: <20221030105944.311940-1-sw@weilnetz.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v2] Fix some typos in documentation and comments
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>, Peter Maydell <peter.maydell@linaro.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Konstantin Kostiuk <kkostiuk@redhat.com>, Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org, virtio-fs@redhat.com, Stefan Weil <sw@weilnetz.de>

Most of them were found and fixed using codespell.

Signed-off-by: Stefan Weil <sw@weilnetz.de>
---

v2: Fixes from Peter Maydell's comments

My focus was fixing typos which are relevant for the generated documentatio=
n.

codespell finds many more typos in source code, and adding it to the contin=
uous
integration checks looks more and more like a good idea.

Stefan


 docs/devel/testing.rst              |  2 +-
 docs/system/arm/cpu-features.rst    |  2 +-
 docs/system/loongarch/loongson3.rst |  2 +-
 docs/tools/virtiofsd.rst            |  2 +-
 include/exec/memory.h               |  2 +-
 qapi/qom.json                       |  2 +-
 qemu-options.hx                     | 10 +++++-----
 qga/qapi-schema.json                |  2 +-
 tests/qtest/libqtest.h              |  2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/docs/devel/testing.rst b/docs/devel/testing.rst
index fbb98faabe..e10c47b5a7 100644
--- a/docs/devel/testing.rst
+++ b/docs/devel/testing.rst
@@ -99,7 +99,7 @@ successfully on various hosts. The following list shows s=
ome best practices:
 * If your test cases uses the blkdebug feature, use relative path to pass
   the config and image file paths in the command line as Windows absolute
   path contains the delimiter ":" which will confuse the blkdebug parser.
-* Use double quotes in your extra QEMU commmand line in your test cases
+* Use double quotes in your extra QEMU command line in your test cases
   instead of single quotes, as Windows does not drop single quotes when
   passing the command line to QEMU.
 * Windows opens a file in text mode by default, while a POSIX compliant
diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-feature=
s.rst
index c2c01ec7d2..00c444042f 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -433,7 +433,7 @@ additional constraints on the set of vector lengths sup=
ported by SME.
 SME User-mode Default Vector Length Property
 --------------------------------------------
=20
-For qemu-aarch64, the cpu propery ``sme-default-vector-length=3DN`` is
+For qemu-aarch64, the cpu property ``sme-default-vector-length=3DN`` is
 defined to mirror the Linux kernel parameter file
 ``/proc/sys/abi/sme_default_vector_length``.  The default length, ``N``,
 is in units of bytes and must be between 16 and 8192.
diff --git a/docs/system/loongarch/loongson3.rst b/docs/system/loongarch/lo=
ongson3.rst
index 1bdab44e27..68113b6f5e 100644
--- a/docs/system/loongarch/loongson3.rst
+++ b/docs/system/loongarch/loongson3.rst
@@ -41,7 +41,7 @@ can be accessed by following steps.
=20
   $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464-loongarch-cpu \
       -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd initrd.img \
-      -append "root=3D/dev/ram rdinit=3D/sbin/init consol e=3DttyS0,115200=
" \
+      -append "root=3D/dev/ram rdinit=3D/sbin/init console=3DttyS0,115200"=
 \
       --nographic
=20
 Note: The running speed may be a little slow, as the performance of our
diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 5f5ac9dd56..995a754a7b 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -232,7 +232,7 @@ e.g.:
=20
   ``:ok:server::security.:``
=20
-  will pass 'securty.' xattr's in listxattr from the server
+  will pass 'security.' xattr's in listxattr from the server
   and ignore following rules.
=20
   ``:ok:all:::``
diff --git a/include/exec/memory.h b/include/exec/memory.h
index bfb1de8eea..a751c111bd 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1970,7 +1970,7 @@ void memory_region_clear_dirty_bitmap(MemoryRegion *m=
r, hwaddr start,
  * querying the same page multiple times, which is especially useful for
  * display updates where the scanlines often are not page aligned.
  *
- * The dirty bitmap region which gets copyed into the snapshot (and
+ * The dirty bitmap region which gets copied into the snapshot (and
  * cleared afterwards) can be larger than requested.  The boundaries
  * are rounded up/down so complete bitmap longs (covering 64 pages on
  * 64bit hosts) can be copied over into the bitmap snapshot.  Which
diff --git a/qapi/qom.json b/qapi/qom.json
index 80dd419b39..216b56a4e6 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -586,7 +586,7 @@
 #
 # @size: size of the memory region in bytes
 #
-# @x-use-canonical-path-for-ramblock-id: if true, the canoncial path is us=
ed
+# @x-use-canonical-path-for-ramblock-id: if true, the canonical path is us=
ed
 #                                        for ramblock-id. Disable this for=
 4.0
 #                                        machine types or older to allow
 #                                        migration with newer QEMU version=
s.
diff --git a/qemu-options.hx b/qemu-options.hx
index eb38e5dc40..1141dc5e58 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -1051,7 +1051,7 @@ SRST
     details on the external interface.
=20
 ``-device isa-ipmi-kcs,bmc=3Did[,ioport=3Dval][,irq=3Dval]``
-    Add a KCS IPMI interafce on the ISA bus. This also adds a
+    Add a KCS IPMI interface on the ISA bus. This also adds a
     corresponding ACPI and SMBIOS entries, if appropriate.
=20
     ``bmc=3Did``
@@ -1071,7 +1071,7 @@ SRST
     is 0xe4 and the default interrupt is 5.
=20
 ``-device pci-ipmi-kcs,bmc=3Did``
-    Add a KCS IPMI interafce on the PCI bus.
+    Add a KCS IPMI interface on the PCI bus.
=20
     ``bmc=3Did``
         The BMC to connect to, one of ipmi-bmc-sim or ipmi-bmc-extern abov=
e.
@@ -5248,8 +5248,8 @@ SRST
         read the colo-compare git log.
=20
     ``-object cryptodev-backend-builtin,id=3Did[,queues=3Dqueues]``
-        Creates a cryptodev backend which executes crypto opreation from
-        the QEMU cipher APIS. The id parameter is a unique ID that will
+        Creates a cryptodev backend which executes crypto operations from
+        the QEMU cipher APIs. The id parameter is a unique ID that will
         be used to reference this cryptodev backend from the
         ``virtio-crypto`` device. The queues parameter is optional,
         which specify the queue number of cryptodev backend, the default
@@ -5516,7 +5516,7 @@ SRST
                        file=3D/etc/qemu/vnc.allow
=20
         Finally the ``/etc/qemu/vnc.allow`` file would contain the list
-        of x509 distingished names that are permitted access
+        of x509 distinguished names that are permitted access
=20
         ::
=20
diff --git a/qga/qapi-schema.json b/qga/qapi-schema.json
index 026a56f76c..796434ed34 100644
--- a/qga/qapi-schema.json
+++ b/qga/qapi-schema.json
@@ -392,7 +392,7 @@
 ##
 # @guest-file-flush:
 #
-# Write file changes bufferred in userspace to disk/kernel buffers
+# Write file changes buffered in userspace to disk/kernel buffers
 #
 # @handle: filehandle returned by guest-file-open
 #
diff --git a/tests/qtest/libqtest.h b/tests/qtest/libqtest.h
index 65c040e504..1a76bae326 100644
--- a/tests/qtest/libqtest.h
+++ b/tests/qtest/libqtest.h
@@ -727,7 +727,7 @@ bool qtest_has_device(const char *device);
  * qtest_qmp_device_add_qdict:
  * @qts: QTestState instance to operate on
  * @drv: Name of the device that should be added
- * @arguments: QDict with properties for the device to intialize
+ * @arguments: QDict with properties for the device to initialize
  *
  * Generic hot-plugging test via the device_add QMP command with propertie=
s
  * supplied in form of QDict. Use NULL for empty properties list.
--=20
2.30.2

