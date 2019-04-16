From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 03:08:56 +0800
Message-Id: <20190416190858.16833-3-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/4] virtiofsd: support nanosecond resolution
	for file timestamp
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

Define HAVE_STRUCT_STAT_ST_ATIM to 1 if `st_atim' is member of `struct
stat' which means support nanosecond resolution for the file timestamp
fields.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 configure                     | 16 ++++++++++++++++
 contrib/virtiofsd/fuse_misc.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/configure b/configure
index 5c21a65..57336ec 100755
--- a/configure
+++ b/configure
@@ -5147,6 +5147,19 @@ if compile_prog "" "" ; then
     strchrnul=yes
 fi
 
+#########################################
+# check if we have st_atim
+
+st_atim=no
+cat > $TMPC << EOF
+#include <sys/stat.h>
+#include <stddef.h>
+int main(void) { return offsetof(struct stat, st_atim); }
+EOF
+if compile_prog "" "" ; then
+    st_atim=yes
+fi
+
 ##########################################
 # check if trace backend exists
 
@@ -6757,6 +6770,9 @@ fi
 if test "$strchrnul" = "yes" ; then
   echo "HAVE_STRCHRNUL=y" >> $config_host_mak
 fi
+if test "$st_atim" = "yes" ; then
+  echo "HAVE_STRUCT_STAT_ST_ATIM=y" >> $config_host_mak
+fi
 if test "$byteswap_h" = "yes" ; then
   echo "CONFIG_BYTESWAP_H=y" >> $config_host_mak
 fi
diff --git a/contrib/virtiofsd/fuse_misc.h b/contrib/virtiofsd/fuse_misc.h
index 2f6663e..30a1d7f 100644
--- a/contrib/virtiofsd/fuse_misc.h
+++ b/contrib/virtiofsd/fuse_misc.h
@@ -7,6 +7,7 @@
 */
 
 #include <pthread.h>
+#include "config-host.h"
 
 /*
   Versioned symbols cannot be used in some cases because it
-- 
1.8.3.1

