Return-Path: <dgilbert@redhat.com>
From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 18 Jan 2023 15:38:31 +0000
Message-Id: <20230118153833.102731-2-dgilbert@redhat.com>
In-Reply-To: <20230118153833.102731-1-dgilbert@redhat.com>
References: <20230118153833.102731-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/3] virtiofsd: Remove build and docs glue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Remove all the virtiofsd build and docs infrastructure.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 MAINTAINERS                                    |  2 --
 docs/conf.py                                   |  4 ----
 docs/meson.build                               |  1 -
 docs/tools/index.rst                           |  1 -
 meson.build                                    |  1 -
 meson_options.txt                              |  2 --
 .../ci/org.centos/stream/8/x86_64/configure    |  2 --
 scripts/coverity-scan/COMPONENTS.md            |  3 ---
 scripts/meson-buildoptions.sh                  |  3 ---
 tools/meson.build                              | 13 -------------
 tools/virtiofsd/50-qemu-virtiofsd.json.in      |  5 -----
 tools/virtiofsd/meson.build                    | 18 ------------------
 12 files changed, 55 deletions(-)
 delete mode 100644 tools/virtiofsd/50-qemu-virtiofsd.json.in
 delete mode 100644 tools/virtiofsd/meson.build

diff --git a/MAINTAINERS b/MAINTAINERS
index 0fe50d01e3..4f8ab04dba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2093,10 +2093,8 @@ virtiofs
 M: Dr. David Alan Gilbert <dgilbert@redhat.com>
 M: Stefan Hajnoczi <stefanha@redhat.com>
 S: Supported
-F: tools/virtiofsd/*
 F: hw/virtio/vhost-user-fs*
 F: include/hw/virtio/vhost-user-fs.h
-F: docs/tools/virtiofsd.rst
 L: virtio-fs@redhat.com
 
 virtio-input
diff --git a/docs/conf.py b/docs/conf.py
index e33cf3d381..b2b4c166e1 100644
--- a/docs/conf.py
+++ b/docs/conf.py
@@ -290,10 +290,6 @@
     ('tools/virtfs-proxy-helper', 'virtfs-proxy-helper',
      'QEMU 9p virtfs proxy filesystem helper',
      ['M. Mohan Kumar'], 1),
-    ('tools/virtiofsd', 'virtiofsd',
-     'QEMU virtio-fs shared file system daemon',
-     ['Stefan Hajnoczi <stefanha@redhat.com>',
-      'Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>'], 1),
 ]
 man_make_section_directory = False
 
diff --git a/docs/meson.build b/docs/meson.build
index 9136fed3b7..bbcdccce68 100644
--- a/docs/meson.build
+++ b/docs/meson.build
@@ -48,7 +48,6 @@ if build_docs
         'qemu-storage-daemon.1': (have_tools ? 'man1' : ''),
         'qemu-trace-stap.1': (stap.found() ? 'man1' : ''),
         'virtfs-proxy-helper.1': (have_virtfs_proxy_helper ? 'man1' : ''),
-        'virtiofsd.1': (have_virtiofsd ? 'man1' : ''),
         'qemu.1': 'man1',
         'qemu-block-drivers.7': 'man7',
         'qemu-cpu-models.7': 'man7'
diff --git a/docs/tools/index.rst b/docs/tools/index.rst
index 1edd5a8054..641550111c 100644
--- a/docs/tools/index.rst
+++ b/docs/tools/index.rst
@@ -14,4 +14,3 @@ command line utilities and other standalone programs.
    qemu-pr-helper
    qemu-trace-stap
    virtfs-proxy-helper
-   virtiofsd
diff --git a/meson.build b/meson.build
index 58d8cd68a6..2f1bf88c9a 100644
--- a/meson.build
+++ b/meson.build
@@ -3860,7 +3860,6 @@ if have_block
   summary_info += {'Block whitelist (ro)': get_option('block_drv_ro_whitelist')}
   summary_info += {'Use block whitelist in tools': get_option('block_drv_whitelist_in_tools')}
   summary_info += {'VirtFS support':    have_virtfs}
-  summary_info += {'build virtiofs daemon': have_virtiofsd}
   summary_info += {'Live block migration': config_host_data.get('CONFIG_LIVE_BLOCK_MIGRATION')}
   summary_info += {'replication support': config_host_data.get('CONFIG_REPLICATION')}
   summary_info += {'bochs support':     get_option('bochs').allowed()}
diff --git a/meson_options.txt b/meson_options.txt
index 559a571b6b..0c9666437c 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -268,8 +268,6 @@ option('vhost_user_blk_server', type: 'feature', value: 'auto',
        description: 'build vhost-user-blk server')
 option('virtfs', type: 'feature', value: 'auto',
        description: 'virtio-9p support')
-option('virtiofsd', type: 'feature', value: 'auto',
-       description: 'build virtiofs daemon (virtiofsd)')
 option('libvduse', type: 'feature', value: 'auto',
        description: 'build VDUSE Library')
 option('vduse_blk_export', type: 'feature', value: 'auto',
diff --git a/scripts/ci/org.centos/stream/8/x86_64/configure b/scripts/ci/org.centos/stream/8/x86_64/configure
index 75882faa9c..54e9043674 100755
--- a/scripts/ci/org.centos/stream/8/x86_64/configure
+++ b/scripts/ci/org.centos/stream/8/x86_64/configure
@@ -137,7 +137,6 @@
 --disable-vhost-vdpa \
 --disable-virglrenderer \
 --disable-virtfs \
---disable-virtiofsd \
 --disable-vnc \
 --disable-vnc-jpeg \
 --disable-png \
@@ -190,7 +189,6 @@
 --enable-tpm \
 --enable-trace-backends=dtrace \
 --enable-usb-redir \
---enable-virtiofsd \
 --enable-vhost-kernel \
 --enable-vhost-net \
 --enable-vhost-user \
diff --git a/scripts/coverity-scan/COMPONENTS.md b/scripts/coverity-scan/COMPONENTS.md
index 0e6ab4936e..639dcee45a 100644
--- a/scripts/coverity-scan/COMPONENTS.md
+++ b/scripts/coverity-scan/COMPONENTS.md
@@ -132,9 +132,6 @@ util
 xen
   ~ (/qemu)?(.*/xen.*)
 
-virtiofsd
-  ~ (/qemu)?(/tools/virtiofsd/.*)
-
 (headers)
   ~ (/qemu)?(/include/.*)
 
diff --git a/scripts/meson-buildoptions.sh b/scripts/meson-buildoptions.sh
index 0f71e92dcb..e4b466699b 100644
--- a/scripts/meson-buildoptions.sh
+++ b/scripts/meson-buildoptions.sh
@@ -173,7 +173,6 @@ meson_options_help() {
   printf "%s\n" '  vhost-vdpa      vhost-vdpa kernel backend support'
   printf "%s\n" '  virglrenderer   virgl rendering support'
   printf "%s\n" '  virtfs          virtio-9p support'
-  printf "%s\n" '  virtiofsd       build virtiofs daemon (virtiofsd)'
   printf "%s\n" '  vmnet           vmnet.framework network backend support'
   printf "%s\n" '  vnc             VNC server'
   printf "%s\n" '  vnc-jpeg        JPEG lossy compression for VNC server'
@@ -455,8 +454,6 @@ _meson_option_parse() {
     --disable-virglrenderer) printf "%s" -Dvirglrenderer=disabled ;;
     --enable-virtfs) printf "%s" -Dvirtfs=enabled ;;
     --disable-virtfs) printf "%s" -Dvirtfs=disabled ;;
-    --enable-virtiofsd) printf "%s" -Dvirtiofsd=enabled ;;
-    --disable-virtiofsd) printf "%s" -Dvirtiofsd=disabled ;;
     --enable-vmnet) printf "%s" -Dvmnet=enabled ;;
     --disable-vmnet) printf "%s" -Dvmnet=disabled ;;
     --enable-vnc) printf "%s" -Dvnc=enabled ;;
diff --git a/tools/meson.build b/tools/meson.build
index 10eb3a043f..e69de29bb2 100644
--- a/tools/meson.build
+++ b/tools/meson.build
@@ -1,13 +0,0 @@
-have_virtiofsd = get_option('virtiofsd') \
-    .require(targetos == 'linux',
-             error_message: 'virtiofsd requires Linux') \
-    .require(seccomp.found() and libcap_ng.found(),
-             error_message: 'virtiofsd requires libcap-ng-devel and seccomp-devel') \
-    .require(have_vhost_user,
-             error_message: 'virtiofsd needs vhost-user-support') \
-    .disable_auto_if(not have_tools and not have_system) \
-    .allowed()
-
-if have_virtiofsd
-  subdir('virtiofsd')
-endif
diff --git a/tools/virtiofsd/50-qemu-virtiofsd.json.in b/tools/virtiofsd/50-qemu-virtiofsd.json.in
deleted file mode 100644
index 9bcd86f8dc..0000000000
--- a/tools/virtiofsd/50-qemu-virtiofsd.json.in
+++ /dev/null
@@ -1,5 +0,0 @@
-{
-  "description": "QEMU virtiofsd vhost-user-fs",
-  "type": "fs",
-  "binary": "@libexecdir@/virtiofsd"
-}
diff --git a/tools/virtiofsd/meson.build b/tools/virtiofsd/meson.build
deleted file mode 100644
index c134ba633f..0000000000
--- a/tools/virtiofsd/meson.build
+++ /dev/null
@@ -1,18 +0,0 @@
-executable('virtiofsd', files(
-  'buffer.c',
-  'fuse_opt.c',
-  'fuse_log.c',
-  'fuse_lowlevel.c',
-  'fuse_signals.c',
-  'fuse_virtio.c',
-  'helper.c',
-  'passthrough_ll.c',
-  'passthrough_seccomp.c'),
-  dependencies: [seccomp, qemuutil, libcap_ng, vhost_user],
-  install: true,
-  install_dir: get_option('libexecdir'))
-
-configure_file(input: '50-qemu-virtiofsd.json.in',
-               output: '50-qemu-virtiofsd.json',
-               configuration: { 'libexecdir' : get_option('prefix') / get_option('libexecdir') },
-               install_dir: qemu_datadir / 'vhost-user')
-- 
2.39.0

