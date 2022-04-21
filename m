Return-Path: <marcandre.lureau@redhat.com>
From: marcandre.lureau@redhat.com
Date: Thu, 21 Apr 2022 17:49:37 +0400
Message-Id: <20220421134940.2887768-28-marcandre.lureau@redhat.com>
In-Reply-To: <20220421134940.2887768-1-marcandre.lureau@redhat.com>
References: <20220421134940.2887768-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 27/30] util: replace
 qemu_get_local_state_pathname()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Weil <sw@weilnetz.de>, "open list:Block SCSI subsystem" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Simplify the function to only return the directory path. Callers are
adjusted to use the GLib function to build paths, g_build_filename().

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Message-Id: <20220420132624.2439741-39-marcandre.lureau@redhat.com>
---
 include/qemu/osdep.h          | 9 +++------
 qga/main.c                    | 8 ++++----
 scsi/qemu-pr-helper.c         | 6 ++++--
 tools/virtiofsd/fuse_virtio.c | 4 +++-
 util/oslib-posix.c            | 7 ++-----
 util/oslib-win32.c            | 5 ++---
 6 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 4bf2883a60b3..baaa23c1568d 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -556,16 +556,13 @@ void qemu_set_cloexec(int fd);
 void fips_set_state(bool requested);
 bool fips_get_state(void);
 
-/* Return a dynamically allocated pathname denoting a file or directory that is
- * appropriate for storing local state.
- *
- * @relative_pathname need not start with a directory separator; one will be
- * added automatically.
+/* Return a dynamically allocated directory path that is appropriate for storing
+ * local state.
  *
  * The caller is responsible for releasing the value returned with g_free()
  * after use.
  */
-char *qemu_get_local_state_pathname(const char *relative_pathname);
+char *qemu_get_local_state_dir(void);
 
 /* Find program directory, and save it for later usage with
  * qemu_get_exec_dir().
diff --git a/qga/main.c b/qga/main.c
index aa00ad8fabdf..3c20bf1fbfe0 100644
--- a/qga/main.c
+++ b/qga/main.c
@@ -129,12 +129,12 @@ static void stop_agent(GAState *s, bool requested);
 static void
 init_dfl_pathnames(void)
 {
+    g_autofree char *state = qemu_get_local_state_dir();
+
     g_assert(dfl_pathnames.state_dir == NULL);
     g_assert(dfl_pathnames.pidfile == NULL);
-    dfl_pathnames.state_dir = qemu_get_local_state_pathname(
-      QGA_STATE_RELATIVE_DIR);
-    dfl_pathnames.pidfile   = qemu_get_local_state_pathname(
-      QGA_STATE_RELATIVE_DIR G_DIR_SEPARATOR_S "qemu-ga.pid");
+    dfl_pathnames.state_dir = g_build_filename(state, QGA_STATE_RELATIVE_DIR, NULL);
+    dfl_pathnames.pidfile = g_build_filename(state, QGA_STATE_RELATIVE_DIR, "qemu-ga.pid", NULL);
 }
 
 static void quit_handler(int sig)
diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c
index df493e2a503e..196b78c00df5 100644
--- a/scsi/qemu-pr-helper.c
+++ b/scsi/qemu-pr-helper.c
@@ -77,8 +77,10 @@ static int gid = -1;
 
 static void compute_default_paths(void)
 {
-    socket_path = qemu_get_local_state_pathname("run/qemu-pr-helper.sock");
-    pidfile = qemu_get_local_state_pathname("run/qemu-pr-helper.pid");
+    g_autofree char *state = qemu_get_local_state_dir();
+
+    socket_path = g_build_filename(state, "run", "qemu-pr-helper.sock", NULL);
+    pidfile = g_build_filename(state, "run", "qemu-pr-helper.pid", NULL);
 }
 
 static void usage(const char *name)
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 60b96470c51a..a52eacf82e1e 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -901,10 +901,12 @@ static bool fv_socket_lock(struct fuse_session *se)
 {
     g_autofree gchar *sk_name = NULL;
     g_autofree gchar *pidfile = NULL;
+    g_autofree gchar *state = NULL;
     g_autofree gchar *dir = NULL;
     Error *local_err = NULL;
 
-    dir = qemu_get_local_state_pathname("run/virtiofsd");
+    state = qemu_get_local_state_dir();
+    dir = g_build_filename(state, "run", "virtiofsd", NULL);
 
     if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
         fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index bcb35c3c8246..b8bf7d4070ce 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -297,12 +297,9 @@ int qemu_pipe(int pipefd[2])
 }
 
 char *
-qemu_get_local_state_pathname(const char *relative_pathname)
+qemu_get_local_state_dir(void)
 {
-    g_autofree char *dir = g_strdup_printf("%s/%s",
-                                           CONFIG_QEMU_LOCALSTATEDIR,
-                                           relative_pathname);
-    return get_relocated_path(dir);
+    return get_relocated_path(CONFIG_QEMU_LOCALSTATEDIR);
 }
 
 void qemu_set_tty_echo(int fd, bool echo)
diff --git a/util/oslib-win32.c b/util/oslib-win32.c
index b897d759365f..9c1e8121fd6d 100644
--- a/util/oslib-win32.c
+++ b/util/oslib-win32.c
@@ -235,7 +235,7 @@ int qemu_get_thread_id(void)
 }
 
 char *
-qemu_get_local_state_pathname(const char *relative_pathname)
+qemu_get_local_state_dir(void)
 {
     HRESULT result;
     char base_path[MAX_PATH+1] = "";
@@ -247,8 +247,7 @@ qemu_get_local_state_pathname(const char *relative_pathname)
         g_critical("CSIDL_COMMON_APPDATA unavailable: %ld", (long)result);
         abort();
     }
-    return g_strdup_printf("%s" G_DIR_SEPARATOR_S "%s", base_path,
-                           relative_pathname);
+    return g_strdup(base_path);
 }
 
 void qemu_set_tty_echo(int fd, bool echo)
-- 
2.36.0

