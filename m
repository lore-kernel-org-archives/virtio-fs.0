From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 29 Jul 2020 18:14:07 -0400
Message-Id: <20200729221410.147556-3-vgoyal@redhat.com>
In-Reply-To: <20200729221410.147556-1-vgoyal@redhat.com>
References: <20200729221410.147556-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] virtiofsd: create lock/pid file in per user
	cache dir
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

So create this file in per user cache dir as queried as specified
by environment variable XDG_RUNTIME_DIR.

Note: "su $USER" does not update XDG_RUNTIME_DIR and it still points to
root user's director. So for now I create a directory /tmp/$UID to save
lock/pid file. Dan pointed out that it can be a problem if a malicious
app already has /tmp/$UID created. So we probably need to get rid of this.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 40 ++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 6b21a93841..f763a70ba5 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -972,13 +972,43 @@ static bool fv_socket_lock(struct fuse_session *se)
     g_autofree gchar *pidfile = NULL;
     g_autofree gchar *dir = NULL;
     Error *local_err = NULL;
+    gboolean unprivileged = false;
 
-    dir = qemu_get_local_state_pathname("run/virtiofsd");
+    if (geteuid() != 0)
+        unprivileged = true;
 
-    if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
-        fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
-                 __func__, dir, strerror(errno));
-        return false;
+    /*
+     * Unpriviliged users don't have access to /usr/local/var. Hence
+     * store lock/pid file in per user directory. Use environment
+     * variable XDG_RUNTIME_DIR.
+     * If one logs into the system as root and then does "su" then
+     * XDG_RUNTIME_DIR still points to root user directory. In that
+     * case create a directory for user in /tmp/$UID
+     */
+    if (unprivileged) {
+        gchar *user_dir = NULL;
+        gboolean create_dir = false;
+        user_dir = g_strdup(g_get_user_runtime_dir());
+        if (!user_dir || g_str_has_suffix(user_dir, "/0")) {
+            user_dir = g_strdup_printf("/tmp/%d", geteuid());
+            create_dir = true;
+        }
+
+        if (create_dir && g_mkdir_with_parents(user_dir, S_IRWXU) < 0) {
+            fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
+                     __func__, user_dir, strerror(errno));
+            g_free(user_dir);
+            return false;
+        }
+        dir = g_strdup(user_dir);
+        g_free(user_dir);
+    } else {
+        dir = qemu_get_local_state_pathname("run/virtiofsd");
+        if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
+            fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s",
+                     __func__, dir, strerror(errno));
+            return false;
+        }
     }
 
     sk_name = g_strdup(se->vu_socket_path);
-- 
2.25.4

