From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  5 Sep 2019 16:21:34 +0100
Message-Id: <20190905152136.30637-2-stefanha@redhat.com>
In-Reply-To: <20190905152136.30637-1-stefanha@redhat.com>
References: <20190905152136.30637-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 1/3] virtiofsd: add org.qemu.Virtiofsd interface
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>

Define a DBus interface for virtiofsd management.  It only allows
querying and changing the log level at the moment.

In the future more methods and properties could be added.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 configure                                |  7 +++++++
 Makefile                                 | 13 +++++++++++++
 contrib/virtiofsd/Makefile.objs          |  6 +++++-
 .gitignore                               |  1 +
 contrib/virtiofsd/org.qemu.Virtiofsd.xml |  7 +++++++
 5 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 contrib/virtiofsd/org.qemu.Virtiofsd.xml

diff --git a/configure b/configure
index 2976e64b9b..17b789d772 100755
--- a/configure
+++ b/configure
@@ -3674,10 +3674,16 @@ if $pkg_config --atleast-version=$glib_req_ver gio-2.0; then
     gio=yes
     gio_cflags=$($pkg_config --cflags gio-2.0)
     gio_libs=$($pkg_config --libs gio-2.0)
+    gdbus_codegen=$($pkg_config --variable=gdbus_codegen gio-2.0)
 else
     gio=no
 fi
 
+if $pkg_config --atleast-version=$glib_req_ver gio-unix-2.0; then
+    gio_cflags="$gio_cflags $($pkg_config --cflags gio-unix-2.0)"
+    gio_libs="$gio_libs $($pkg_config --libs gio-unix-2.0)"
+fi
+
 # Sanity check that the current size_t matches the
 # size that glib thinks it should be. This catches
 # problems on multi-arch where people try to build
@@ -6856,6 +6862,7 @@ if test "$gio" = "yes" ; then
     echo "CONFIG_GIO=y" >> $config_host_mak
     echo "GIO_CFLAGS=$gio_cflags" >> $config_host_mak
     echo "GIO_LIBS=$gio_libs" >> $config_host_mak
+    echo "GDBUS_CODEGEN=$gdbus_codegen" >> $config_host_mak
 fi
 echo "CONFIG_TLS_PRIORITY=\"$tls_priority\"" >> $config_host_mak
 if test "$gnutls" = "yes" ; then
diff --git a/Makefile b/Makefile
index a3dfdd6fa8..6b1af33348 100644
--- a/Makefile
+++ b/Makefile
@@ -124,6 +124,11 @@ GENERATED_QAPI_FILES += qapi/qapi-doc.texi
 
 generated-files-y += $(GENERATED_QAPI_FILES)
 
+ifdef CONFIG_LINUX
+generated-files-y += contrib/virtiofsd/gdbus_generated.h
+generated-files-y += contrib/virtiofsd/gdbus_generated.c
+endif
+
 generated-files-y += trace/generated-tcg-tracers.h
 
 generated-files-y += trace/generated-helpers-wrappers.h
@@ -646,6 +651,14 @@ rdmacm-mux$(EXESUF): $(rdmacm-mux-obj-y) $(COMMON_LDADDS)
 	$(call LINK, $^)
 
 ifdef CONFIG_LINUX # relies on Linux-specific syscalls
+contrib/virtiofsd/gdbus_generated.h contrib/virtiofsd/gdbus_generated.c: contrib/virtiofsd/gdbus_generated.c-timestamp ;
+contrib/virtiofsd/gdbus_generated.c-timestamp: $(SRC_PATH)/contrib/virtiofsd/org.qemu.Virtiofsd.xml
+	$(call quiet-command,$(GDBUS_CODEGEN) $< \
+		--interface-prefix org.qemu \
+		--generate-c-code contrib/virtiofsd/gdbus_generated, \
+		"GEN","$(@:%-timestamp=%)")
+	@>$@
+
 virtiofsd$(EXESUF): $(virtiofsd-obj-y) libvhost-user.a $(COMMON_LDADDS)
 	$(call LINK, $^)
 endif
diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
index 25f1e8dd73..9b2af1bc23 100644
--- a/contrib/virtiofsd/Makefile.objs
+++ b/contrib/virtiofsd/Makefile.objs
@@ -7,9 +7,13 @@ virtiofsd-obj-y = buffer.o \
                   fuse_virtio.o \
                   helper.o \
                   passthrough_ll.o \
-                  seccomp.o
+                  seccomp.o \
+                  gdbus_generated.o
 
 seccomp.o-cflags := $(SECCOMP_CFLAGS)
 seccomp.o-libs := $(SECCOMP_LIBS)
 
+gdbus_generated.o-cflags := $(GIO_CFLAGS)
+gdbus_generated.o-libs := $(GIO_LIBS)
+
 passthrough_ll.o-libs += -lcap
diff --git a/.gitignore b/.gitignore
index fd6e6c38c7..c04d5dd0b1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,6 +6,7 @@
 /config-target.*
 /config.status
 /config-temp
+/contrib/virtiofsd/gdbus_generated.*
 /elf2dmp
 /trace-events-all
 /trace/generated-events.h
diff --git a/contrib/virtiofsd/org.qemu.Virtiofsd.xml b/contrib/virtiofsd/org.qemu.Virtiofsd.xml
new file mode 100644
index 0000000000..efc0c59020
--- /dev/null
+++ b/contrib/virtiofsd/org.qemu.Virtiofsd.xml
@@ -0,0 +1,7 @@
+<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"
+         "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
+<node>
+    <interface name="org.qemu.Virtiofsd">
+        <property name="LogLevel" type="s" access="readwrite"/>
+    </interface>
+</node>
-- 
2.21.0

