From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Jul 2020 15:47:33 -0400
Message-Id: <20200730194736.173994-3-vgoyal@redhat.com>
In-Reply-To: <20200730194736.173994-1-vgoyal@redhat.com>
References: <20200730194736.173994-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/5] virtiofsd: create lock/pid file in per
	user cache dir
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, vromanso@redhat.com, virtio-fs@redhat.com, vgoyal@redhat.com

Right now we create lock/pid file in /usr/local/var/... and unprivliged
user does not have access to create files there.

Hence, in unprivileged mode, create this file in per user cache dir
as specified by environment variable XDG_RUNTIME_DIR.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 6b21a93841..1551a94757 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -972,8 +972,21 @@ static bool fv_socket_lock(struct fuse_session *se)
     g_autofree gchar *pidfile = NULL;
     g_autofree gchar *dir = NULL;
     Error *local_err = NULL;
+    gboolean unprivileged = false;
 
-    dir = qemu_get_local_state_pathname("run/virtiofsd");
+    if (geteuid() != 0)
+        unprivileged = true;
+
+    /*
+     * Unpriviliged users don't have access to /usr/local/var. Hence
+     * store lock/pid file in per user cache directory. Use environment
+     * variable XDG_RUNTIME_DIR.
+     */
+    if (unprivileged) {
+        dir = g_strdup_printf("%s/virtiofsd", g_get_user_runtime_dir());
+    } else {
+        dir = qemu_get_local_state_pathname("run/virtiofsd");
+    }
 
     if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
         fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
-- 
2.25.4

