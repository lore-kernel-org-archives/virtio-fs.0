From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Wed, 7 Oct 2020 18:29:13 +0900
Message-ID: <20201007092913.1524199-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH] configure: add option for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Currently it is unknown whether virtiofsd will be built at
configuration time. It will be automatically built when dependency
is met. Also, required libraries are not clear.

To make this clear, add configure option --{enable,disable}-virtiofsd.
The default is the same as current (enabled if available) like many
other options. When --enable-virtiofsd is given and dependency is not
met, we get:

  ERROR: virtiofsd requires libcap-ng devel, seccomp devel, vhost user and tools support

In addition, configuration summary now includes virtiofsd entry:

  build virtiofs daemon: YES/NO

Sidenote: this patch defines CONFIG_VIRTIOFSD for config-host.mak
to avoid duplicate dependency check in tools/meson.build.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 configure         | 22 ++++++++++++++++++++++
 docs/meson.build  |  2 +-
 meson.build       |  1 +
 tools/meson.build |  9 +--------
 4 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index ecc8e90e8b..9d76e73014 100755
--- a/configure
+++ b/configure
@@ -403,6 +403,7 @@ netmap="no"
 sdl="auto"
 sdl_image="auto"
 virtfs=""
+virtiofsd=""
 mpath=""
 vnc="enabled"
 sparse="no"
@@ -1117,6 +1118,10 @@ for opt do
   ;;
   --enable-virtfs) virtfs="yes"
   ;;
+  --disable-virtiofsd) virtiofsd="no"
+  ;;
+  --enable-virtiofsd) virtiofsd="yes"
+  ;;
   --disable-mpath) mpath="no"
   ;;
   --enable-mpath) mpath="yes"
@@ -1873,6 +1878,7 @@ disabled with --disable-FEATURE, default is enabled if available:
   vnc-png         PNG compression for VNC server
   cocoa           Cocoa UI (Mac OS X only)
   virtfs          VirtFS
+  virtiofsd       build virtiofs daemon (virtiofsd)
   mpath           Multipath persistent reservation passthrough
   xen             xen backend driver support
   xen-pci-passthrough    PCI passthrough support for Xen
@@ -6344,6 +6350,15 @@ if test "$softmmu" = yes ; then
       fi
       virtfs=no
     fi
+    if test "$virtiofsd" != no && test "$cap_ng" = yes && test "$seccomp" = yes \
+         && test "$vhost_user" = yes && test "$want_tools" = yes; then
+      virtiofsd=yes
+    else
+      if test "$virtiofsd" = yes; then
+        error_exit "virtiofsd requires libcap-ng devel, seccomp devel, vhost user and tools support"
+      fi
+      virtiofsd=no
+    fi
     if test "$mpath" != no && test "$mpathpersist" = yes ; then
       mpath=yes
     else
@@ -6357,6 +6372,10 @@ if test "$softmmu" = yes ; then
       error_exit "VirtFS is supported only on Linux"
     fi
     virtfs=no
+    if test "$virtiofsd" = yes; then
+      error_exit "virtiofsd is supported only on Linux"
+    fi
+    virtiofsd=no
     if test "$mpath" = yes; then
       error_exit "Multipath is supported only on Linux"
     fi
@@ -6901,6 +6920,9 @@ fi
 if test "$virtfs" = "yes" ; then
   echo "CONFIG_VIRTFS=y" >> $config_host_mak
 fi
+if test "$virtiofsd" = "yes" ; then
+  echo "CONFIG_VIRTIOFSD=y" >> $config_host_mak
+fi
 if test "$mpath" = "yes" ; then
   echo "CONFIG_MPATH=y" >> $config_host_mak
   if test "$mpathpersist_new_api" = "yes"; then
diff --git a/docs/meson.build b/docs/meson.build
index 0340d489ac..6b9b277ef7 100644
--- a/docs/meson.build
+++ b/docs/meson.build
@@ -15,7 +15,7 @@ if build_docs
         'qemu-nbd.8': (have_tools ? 'man8' : ''),
         'qemu-trace-stap.1': (config_host.has_key('CONFIG_TRACE_SYSTEMTAP') ? 'man1' : ''),
         'virtfs-proxy-helper.1': (have_virtfs_proxy_helper ? 'man1' : ''),
-        'virtiofsd.1': (have_virtiofsd ? 'man1' : ''),
+        'virtiofsd.1': (config_host.has_key('CONFIG_VIRTIOFSD') ? 'man1' : ''),
     },
     'system': {
         'qemu.1': 'man1',
diff --git a/meson.build b/meson.build
index 5b586afc38..a4ea961272 100644
--- a/meson.build
+++ b/meson.build
@@ -1336,6 +1336,7 @@ summary_info += {'Audio drivers':     config_host['CONFIG_AUDIO_DRIVERS']}
 summary_info += {'Block whitelist (rw)': config_host['CONFIG_BDRV_RW_WHITELIST']}
 summary_info += {'Block whitelist (ro)': config_host['CONFIG_BDRV_RO_WHITELIST']}
 summary_info += {'VirtFS support':    config_host.has_key('CONFIG_VIRTFS')}
+summary_info += {'build virtiofs daemon': config_host.has_key('CONFIG_VIRTIOFSD')}
 summary_info += {'Multipath support': config_host.has_key('CONFIG_MPATH')}
 summary_info += {'VNC support':       vnc.found()}
 if vnc.found()
diff --git a/tools/meson.build b/tools/meson.build
index 513bd2ff4f..f1241982d6 100644
--- a/tools/meson.build
+++ b/tools/meson.build
@@ -1,10 +1,3 @@
-have_virtiofsd = (have_system and
-    have_tools and
-    'CONFIG_LINUX' in config_host and 
-    'CONFIG_SECCOMP' in config_host and
-    'CONFIG_LIBCAP_NG' in config_host and
-    'CONFIG_VHOST_USER' in config_host)
-
-if have_virtiofsd
+if 'CONFIG_VIRTIOFSD' in config_host
   subdir('virtiofsd')
 endif
-- 
2.25.4

