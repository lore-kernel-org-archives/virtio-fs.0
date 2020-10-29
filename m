From: Max Reitz <mreitz@redhat.com>
Date: Thu, 29 Oct 2020 18:17:40 +0100
Message-Id: <20201029171744.150726-4-mreitz@redhat.com>
In-Reply-To: <20201029171744.150726-1-mreitz@redhat.com>
References: <20201029171744.150726-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/7] meson.build: Check for statx()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

Check whether the glibc provides statx() and if so, define CONFIG_STATX.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 meson.build | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/meson.build b/meson.build
index 47e32e1fcb..39ac5cf6d8 100644
--- a/meson.build
+++ b/meson.build
@@ -736,6 +736,21 @@ if not has_malloc_trim and get_option('malloc_trim').enabled()
   endif
 endif
 
+# Check whether the glibc provides statx()
+
+statx_test = '''
+  #ifndef _GNU_SOURCE
+  #define _GNU_SOURCE
+  #endif
+  #include <sys/stat.h>
+  int main(void) {
+    struct statx statxbuf;
+    statx(0, "", 0, STATX_BASIC_STATS, &statxbuf);
+    return 0;
+  }'''
+
+has_statx = cc.links(statx_test)
+
 #################
 # config-host.h #
 #################
@@ -768,6 +783,7 @@ config_host_data.set('CONFIG_XKBCOMMON', xkbcommon.found())
 config_host_data.set('CONFIG_KEYUTILS', keyutils.found())
 config_host_data.set('CONFIG_GETTID', has_gettid)
 config_host_data.set('CONFIG_MALLOC_TRIM', has_malloc_trim)
+config_host_data.set('CONFIG_STATX', has_statx)
 config_host_data.set('QEMU_VERSION', '"@0@"'.format(meson.project_version()))
 config_host_data.set('QEMU_VERSION_MAJOR', meson.project_version().split('.')[0])
 config_host_data.set('QEMU_VERSION_MINOR', meson.project_version().split('.')[1])
-- 
2.26.2

