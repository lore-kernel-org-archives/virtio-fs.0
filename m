From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 27 Aug 2020 16:36:53 +0100
Message-Id: <20200827153657.111098-3-dgilbert@redhat.com>
In-Reply-To: <20200827153657.111098-1-dgilbert@redhat.com>
References: <20200827153657.111098-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/6] virtiofsd: Add printf checking to
	fuse_log
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Use qemu's GCC_FMT_ATTR to add printf style checking to fuse_log.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_log.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/virtiofsd/fuse_log.h b/tools/virtiofsd/fuse_log.h
index bf6c11ff11..3ea38312b0 100644
--- a/tools/virtiofsd/fuse_log.h
+++ b/tools/virtiofsd/fuse_log.h
@@ -15,6 +15,7 @@
  */
 
 #include <stdarg.h>
+#include "qemu/compiler.h"
 
 /**
  * Log severity level
@@ -69,6 +70,7 @@ void fuse_set_log_func(fuse_log_func_t func);
  * @param level severity level (FUSE_LOG_ERR, FUSE_LOG_DEBUG, etc)
  * @param fmt sprintf-style format string including newline
  */
+GCC_FMT_ATTR(2, 3)
 void fuse_log(enum fuse_log_level level, const char *fmt, ...);
 
 #endif /* FUSE_LOG_H_ */
-- 
2.26.2

