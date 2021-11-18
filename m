From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Date: Thu, 18 Nov 2021 20:27:44 +0100
Message-Id: <20211118192744.64325-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH-for-6.2? v2] docs: Render binary names as
	monospaced text
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, John G Johnson <john.g.johnson@oracle.com>, Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, virtio-fs@redhat.com, Darren Kenny <darren.kenny@oracle.com>, Niek Linnenbank <nieklinnenbank@gmail.com>, qemu-arm@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Jagannathan Raman <jag.raman@oracle.com>, Eric Blake <eblake@redhat.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
v2: Addressed Eric comments
---
 docs/about/removed-features.rst        |  8 ++++----
 docs/devel/build-system.rst            |  6 +++---
 docs/devel/multi-process.rst           |  6 +++---
 docs/devel/testing.rst                 |  8 ++++----
 docs/image-fuzzer.txt                  |  6 +++---
 docs/system/arm/orangepi.rst           |  2 +-
 docs/system/images.rst                 |  2 +-
 docs/system/qemu-block-drivers.rst.inc |  6 +++---
 docs/system/tls.rst                    |  2 +-
 docs/tools/qemu-img.rst                | 18 +++++++++---------
 docs/tools/qemu-nbd.rst                |  4 ++--
 docs/tools/qemu-storage-daemon.rst     |  7 ++++---
 docs/tools/virtiofsd.rst               |  4 ++--
 13 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 9d0d90c90d9..d42c3341dee 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -658,8 +658,8 @@ enforce that any failure to open the backing image (including if the
 backing file is missing or an incorrect format was specified) is an
 error when ``-u`` is not used.
 
-qemu-img amend to adjust backing file (removed in 6.1)
-''''''''''''''''''''''''''''''''''''''''''''''''''''''
+``qemu-img amend`` to adjust backing file (removed in 6.1)
+''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 The use of ``qemu-img amend`` to modify the name or format of a qcow2
 backing image was never fully documented or tested, and interferes
@@ -670,8 +670,8 @@ backing chain should be performed with ``qemu-img rebase -u`` either
 before or after the remaining changes being performed by amend, as
 appropriate.
 
-qemu-img backing file without format (removed in 6.1)
-'''''''''''''''''''''''''''''''''''''''''''''''''''''
+``qemu-img`` backing file without format (removed in 6.1)
+'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 The use of ``qemu-img create``, ``qemu-img rebase``, or ``qemu-img
 convert`` to create or modify an image that depends on a backing file
diff --git a/docs/devel/build-system.rst b/docs/devel/build-system.rst
index 7a83f5fc0db..431caba7aa0 100644
--- a/docs/devel/build-system.rst
+++ b/docs/devel/build-system.rst
@@ -121,11 +121,11 @@ process for:
 
 1) executables, which include:
 
-   - Tools - qemu-img, qemu-nbd, qga (guest agent), etc
+   - Tools - ``qemu-img``, ``qemu-nbd``, ``qga`` (guest agent), etc
 
-   - System emulators - qemu-system-$ARCH
+   - System emulators - ``qemu-system-$ARCH``
 
-   - Userspace emulators - qemu-$ARCH
+   - Userspace emulators - ``qemu-$ARCH``
 
    - Unit tests
 
diff --git a/docs/devel/multi-process.rst b/docs/devel/multi-process.rst
index e5758a79aba..2c5ec977df8 100644
--- a/docs/devel/multi-process.rst
+++ b/docs/devel/multi-process.rst
@@ -187,9 +187,9 @@ desired, in which the emulation application should only be allowed to
 access the files or devices the VM it's running on behalf of can access.
 #### qemu-io model
 
-Qemu-io is a test harness used to test changes to the QEMU block backend
-object code. (e.g., the code that implements disk images for disk driver
-emulation) Qemu-io is not a device emulation application per se, but it
+``qemu-io`` is a test harness used to test changes to the QEMU block backend
+object code (e.g., the code that implements disk images for disk driver
+emulation). ``qemu-io`` is not a device emulation application per se, but it
 does compile the QEMU block objects into a separate binary from the main
 QEMU one. This could be useful for disk device emulation, since its
 emulation applications will need to include the QEMU block objects.
diff --git a/docs/devel/testing.rst b/docs/devel/testing.rst
index 60c59023e58..755343c7dd0 100644
--- a/docs/devel/testing.rst
+++ b/docs/devel/testing.rst
@@ -564,11 +564,11 @@ exploiting a QEMU security bug to compromise the host.
 QEMU binaries
 ~~~~~~~~~~~~~
 
-By default, qemu-system-x86_64 is searched in $PATH to run the guest. If there
-isn't one, or if it is older than 2.10, the test won't work. In this case,
+By default, ``qemu-system-x86_64`` is searched in $PATH to run the guest. If
+there isn't one, or if it is older than 2.10, the test won't work. In this case,
 provide the QEMU binary in env var: ``QEMU=/path/to/qemu-2.10+``.
 
-Likewise the path to qemu-img can be set in QEMU_IMG environment variable.
+Likewise the path to ``qemu-img`` can be set in QEMU_IMG environment variable.
 
 Make jobs
 ~~~~~~~~~
@@ -650,7 +650,7 @@ supported. To start the fuzzer, run
 
   tests/image-fuzzer/runner.py -c '[["qemu-img", "info", "$test_img"]]' /tmp/test qcow2
 
-Alternatively, some command different from "qemu-img info" can be tested, by
+Alternatively, some command different from ``qemu-img info`` can be tested, by
 changing the ``-c`` option.
 
 Integration tests using the Avocado Framework
diff --git a/docs/image-fuzzer.txt b/docs/image-fuzzer.txt
index 3e23ebec331..279cc8c807f 100644
--- a/docs/image-fuzzer.txt
+++ b/docs/image-fuzzer.txt
@@ -51,10 +51,10 @@ assumes that core dumps will be generated in the current working directory.
 For comprehensive test results, please, set up your test environment
 properly.
 
-Paths to binaries under test (SUTs) qemu-img and qemu-io are retrieved from
-environment variables. If the environment check fails the runner will
+Paths to binaries under test (SUTs) ``qemu-img`` and ``qemu-io`` are retrieved
+from environment variables. If the environment check fails the runner will
 use SUTs installed in system paths.
-qemu-img is required for creation of backing files, so it's mandatory to set
+``qemu-img`` is required for creation of backing files, so it's mandatory to set
 the related environment variable if it's not installed in the system path.
 For details about environment variables see qemu-iotests/check.
 
diff --git a/docs/system/arm/orangepi.rst b/docs/system/arm/orangepi.rst
index c55694dd91b..83c7445197b 100644
--- a/docs/system/arm/orangepi.rst
+++ b/docs/system/arm/orangepi.rst
@@ -128,7 +128,7 @@ Alternatively, you can also choose to build you own image with buildroot
 using the orangepi_pc_defconfig. Also see https://buildroot.org for more information.
 
 When using an image as an SD card, it must be resized to a power of two. This can be
-done with the qemu-img command. It is recommended to only increase the image size
+done with the ``qemu-img`` command. It is recommended to only increase the image size
 instead of shrinking it to a power of two, to avoid loss of data. For example,
 to prepare a downloaded Armbian image, first extract it and then increase
 its size to one gigabyte as follows:
diff --git a/docs/system/images.rst b/docs/system/images.rst
index 3d9144e6258..d000bd6b6f1 100644
--- a/docs/system/images.rst
+++ b/docs/system/images.rst
@@ -20,7 +20,7 @@ where myimage.img is the disk image filename and mysize is its size in
 kilobytes. You can add an ``M`` suffix to give the size in megabytes and
 a ``G`` suffix for gigabytes.
 
-See the qemu-img invocation documentation for more information.
+See the ``qemu-img`` invocation documentation for more information.
 
 .. _disk_005fimages_005fsnapshot_005fmode:
 
diff --git a/docs/system/qemu-block-drivers.rst.inc b/docs/system/qemu-block-drivers.rst.inc
index 16225710ebb..e313784426d 100644
--- a/docs/system/qemu-block-drivers.rst.inc
+++ b/docs/system/qemu-block-drivers.rst.inc
@@ -511,13 +511,13 @@ of an inet socket:
 
   |qemu_system| linux.img -hdb nbd+unix://?socket=/tmp/my_socket
 
-In this case, the block device must be exported using qemu-nbd:
+In this case, the block device must be exported using ``qemu-nbd``:
 
 .. parsed-literal::
 
   qemu-nbd --socket=/tmp/my_socket my_disk.qcow2
 
-The use of qemu-nbd allows sharing of a disk between several guests:
+The use of ``qemu-nbd`` allows sharing of a disk between several guests:
 
 .. parsed-literal::
 
@@ -530,7 +530,7 @@ and then you can use it with two guests:
   |qemu_system| linux1.img -hdb nbd+unix://?socket=/tmp/my_socket
   |qemu_system| linux2.img -hdb nbd+unix://?socket=/tmp/my_socket
 
-If the nbd-server uses named exports (supported since NBD 2.9.18, or with QEMU's
+If the ``nbd-server`` uses named exports (supported since NBD 2.9.18, or with QEMU's
 own embedded NBD server), you must specify an export name in the URI:
 
 .. parsed-literal::
diff --git a/docs/system/tls.rst b/docs/system/tls.rst
index b0973afe1bf..1a04674362e 100644
--- a/docs/system/tls.rst
+++ b/docs/system/tls.rst
@@ -311,7 +311,7 @@ containing one or more usernames and random keys::
    mkdir -m 0700 /tmp/keys
    psktool -u rich -p /tmp/keys/keys.psk
 
-TLS-enabled servers such as qemu-nbd can use this directory like so::
+TLS-enabled servers such as ``qemu-nbd`` can use this directory like so::
 
    qemu-nbd \
      -t -x / \
diff --git a/docs/tools/qemu-img.rst b/docs/tools/qemu-img.rst
index c0a44431467..d663dd92bd7 100644
--- a/docs/tools/qemu-img.rst
+++ b/docs/tools/qemu-img.rst
@@ -127,9 +127,9 @@ by the used format or see the format descriptions below for details.
 .. option:: -S SIZE
 
   Indicates the consecutive number of bytes that must contain only zeros
-  for qemu-img to create a sparse image during conversion. This value is rounded
-  down to the nearest 512 bytes. You may use the common size suffixes like
-  ``k`` for kilobytes.
+  for ``qemu-img`` to create a sparse image during conversion. This value is
+  rounded down to the nearest 512 bytes. You may use the common size suffixes
+  like ``k`` for kilobytes.
 
 .. option:: -t CACHE
 
@@ -431,7 +431,7 @@ Command description:
   suppressed from the destination image.
 
   *SPARSE_SIZE* indicates the consecutive number of bytes (defaults to 4k)
-  that must contain only zeros for qemu-img to create a sparse image during
+  that must contain only zeros for ``qemu-img`` to create a sparse image during
   conversion. If *SPARSE_SIZE* is 0, the source will not be scanned for
   unallocated or zero sectors, and the destination image will always be
   fully allocated.
@@ -447,7 +447,7 @@ Command description:
   If the ``-n`` option is specified, the target volume creation will be
   skipped. This is useful for formats such as ``rbd`` if the target
   volume has already been created with site specific options that cannot
-  be supplied through qemu-img.
+  be supplied through ``qemu-img``.
 
   Out of order writes can be enabled with ``-W`` to improve performance.
   This is only recommended for preallocated devices like host devices or other
@@ -472,7 +472,7 @@ Command description:
   If the option *BACKING_FILE* is specified, then the image will record
   only the differences from *BACKING_FILE*. No size needs to be specified in
   this case. *BACKING_FILE* will never be modified unless you use the
-  ``commit`` monitor command (or qemu-img commit).
+  ``commit`` monitor command (or ``qemu-img commit``).
 
   If a relative path name is given, the backing file is looked up relative to
   the directory containing *FILENAME*.
@@ -684,7 +684,7 @@ Command description:
 
   Safe mode
     This is the default mode and performs a real rebase operation. The
-    new backing file may differ from the old one and qemu-img rebase
+    new backing file may differ from the old one and ``qemu-img rebase``
     will take care of keeping the guest-visible content of *FILENAME*
     unchanged.
 
@@ -697,7 +697,7 @@ Command description:
     exists.
 
   Unsafe mode
-    qemu-img uses the unsafe mode if ``-u`` is specified. In this
+    ``qemu-img`` uses the unsafe mode if ``-u`` is specified. In this
     mode, only the backing file name and format of *FILENAME* is changed
     without any checks on the file contents. The user must take care of
     specifying the correct new backing file, or the guest-visible
@@ -735,7 +735,7 @@ Command description:
   sizes accordingly.  Failure to do so will result in data loss!
 
   When shrinking images, the ``--shrink`` option must be given. This informs
-  qemu-img that the user acknowledges all loss of data beyond the truncated
+  ``qemu-img`` that the user acknowledges all loss of data beyond the truncated
   image's end.
 
   After using this command to grow a disk image, you must use file system and
diff --git a/docs/tools/qemu-nbd.rst b/docs/tools/qemu-nbd.rst
index 56e54cd4411..fdcee0244af 100644
--- a/docs/tools/qemu-nbd.rst
+++ b/docs/tools/qemu-nbd.rst
@@ -38,7 +38,7 @@ driver options if ``--image-opts`` is specified.
   supported. The common object types that it makes sense to define are the
   ``secret`` object, which is used to supply passwords and/or encryption
   keys, and the ``tls-creds`` object, which is used to supply TLS
-  credentials for the qemu-nbd server or client.
+  credentials for the ``qemu-nbd`` server or client.
 
 .. option:: -p, --port=PORT
 
@@ -238,7 +238,7 @@ daemon:
 Expose the guest-visible contents of a qcow2 file via a block device
 /dev/nbd0 (and possibly creating /dev/nbd0p1 and friends for
 partitions found within), then disconnect the device when done.
-Access to bind qemu-nbd to an /dev/nbd device generally requires root
+Access to bind ``qemu-nbd`` to a /dev/nbd device generally requires root
 privileges, and may also require the execution of ``modprobe nbd``
 to enable the kernel NBD client module.  *CAUTION*: Do not use
 this method to mount filesystems from an untrusted guest image - a
diff --git a/docs/tools/qemu-storage-daemon.rst b/docs/tools/qemu-storage-daemon.rst
index b8ef4486f1e..3e5a9dc0320 100644
--- a/docs/tools/qemu-storage-daemon.rst
+++ b/docs/tools/qemu-storage-daemon.rst
@@ -10,9 +10,10 @@ Synopsis
 Description
 -----------
 
-qemu-storage-daemon provides disk image functionality from QEMU, qemu-img, and
-qemu-nbd in a long-running process controlled via QMP commands without running
-a virtual machine. It can export disk images, run block job operations, and
+``qemu-storage-daemon`` provides disk image functionality from QEMU,
+``qemu-img``, and ``qemu-nbd`` in a long-running process controlled via QMP
+commands without running a virtual machine.
+It can export disk images, run block job operations, and
 perform other disk-related operations. The daemon is controlled via a QMP
 monitor and initial configuration from the command-line.
 
diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index cc314028309..07ac0be5511 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -136,8 +136,8 @@ Extended attribute (xattr) mapping
 By default the name of xattr's used by the client are passed through to the server
 file system.  This can be a problem where either those xattr names are used
 by something on the server (e.g. selinux client/server confusion) or if the
-virtiofsd is running in a container with restricted privileges where it cannot
-access some attributes.
+``virtiofsd`` is running in a container with restricted privileges where it
+cannot access some attributes.
 
 Mapping syntax
 ~~~~~~~~~~~~~~
-- 
2.31.1

