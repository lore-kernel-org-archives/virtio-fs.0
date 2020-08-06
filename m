From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Thu, 6 Aug 2020 20:11:29 +0900
Message-ID: <20200806111129.22055-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Cleanup norace option description
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org

Cleanup norace option as the feature was removed by below commit:

Fixes: 93bb3d8d4cda("virtiofsd: remove symlink fallbacks")
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 docs/tools/virtiofsd.rst | 3 ---
 tools/virtiofsd/helper.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 824e713491..58666a4495 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -63,9 +63,6 @@ Options
     Print only log messages matching LEVEL or more severe.  LEVEL is one of
     ``err``, ``warn``, ``info``, or ``debug``.  The default is ``info``.
 
-  * norace -
-    Disable racy fallback.  The default is false.
-
   * posix_lock|no_posix_lock -
     Enable/disable remote POSIX locks.  The default is ``posix_lock``.
 
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 2e4cdb4f49..4ded1d588a 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -159,8 +159,6 @@ void fuse_cmdline_help(void)
            "    -o max_idle_threads        the maximum number of idle worker "
            "threads\n"
            "                               allowed (default: 10)\n"
-           "    -o norace                  disable racy fallback\n"
-           "                               default: false\n"
            "    -o posix_lock|no_posix_lock\n"
            "                               enable/disable remote posix lock\n"
            "                               default: posix_lock\n"
-- 
2.21.3

