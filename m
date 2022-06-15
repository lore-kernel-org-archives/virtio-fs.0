Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 15 Jun 2022 16:51:13 +0100
Message-Id: <20220615155129.1025811-3-stefanha@redhat.com>
In-Reply-To: <20220615155129.1025811-1-stefanha@redhat.com>
References: <20220615155129.1025811-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 02/18] Use io_uring_register_ring_fd() to skip fd
 operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, Jagannathan Raman <jag.raman@oracle.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Stefan Hajnoczi <stefanha@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Beraldo Leal <bleal@redhat.com>, Peter Xu <peterx@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Qiuhao Li <Qiuhao.Li@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, Markus Armbruster <armbru@redhat.com>, Bandan Das <bsd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Alexander Bulekov <alxndr@bu.edu>, Julia Suvorova <jusual@redhat.com>, Darren Kenny <darren.kenny@oracle.com>, Wainer dos Santos Moschetta <wainersm@redhat.com>, John G Johnson <john.g.johnson@oracle.com>, Sam Li <faithilikerun@gmail.com>

From: Sam Li <faithilikerun@gmail.com>

Linux recently added a new io_uring(7) optimization API that QEMU
doesn't take advantage of yet. The liburing library that QEMU uses
has added a corresponding new API calling io_uring_register_ring_fd().
When this API is called after creating the ring, the io_uring_submit()
library function passes a flag to the io_uring_enter(2) syscall
allowing it to skip the ring file descriptor fdget()/fdput()
operations. This saves some CPU cycles.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Message-id: 20220531105011.111082-1-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 meson.build      |  1 +
 block/io_uring.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 0c2e11ff07..9e65cc5367 100644
--- a/meson.build
+++ b/meson.build
@@ -1752,6 +1752,7 @@ config_host_data.set('CONFIG_LIBNFS', libnfs.found())
 config_host_data.set('CONFIG_LIBSSH', libssh.found())
 config_host_data.set('CONFIG_LINUX_AIO', libaio.found())
 config_host_data.set('CONFIG_LINUX_IO_URING', linux_io_uring.found())
+config_host_data.set('CONFIG_LIBURING_REGISTER_RING_FD', cc.has_function('io_uring_register_ring_fd', prefix: '#include <liburing.h>', dependencies:linux_io_uring))
 config_host_data.set('CONFIG_LIBPMEM', libpmem.found())
 config_host_data.set('CONFIG_NUMA', numa.found())
 config_host_data.set('CONFIG_OPENGL', opengl.found())
diff --git a/block/io_uring.c b/block/io_uring.c
index 0b401512b9..d48e472e74 100644
--- a/block/io_uring.c
+++ b/block/io_uring.c
@@ -18,6 +18,7 @@
 #include "qapi/error.h"
 #include "trace.h"
 
+
 /* io_uring ring size */
 #define MAX_ENTRIES 128
 
@@ -434,8 +435,17 @@ LuringState *luring_init(Error **errp)
     }
 
     ioq_init(&s->io_q);
+#ifdef CONFIG_LIBURING_REGISTER_RING_FD
+    if (io_uring_register_ring_fd(&s->ring) < 0) {
+        /*
+         * Only warn about this error: we will fallback to the non-optimized
+         * io_uring operations.
+         */
+        warn_report("failed to register linux io_uring ring file descriptor");
+    }
+#endif
+
     return s;
-
 }
 
 void luring_cleanup(LuringState *s)
-- 
2.36.1

