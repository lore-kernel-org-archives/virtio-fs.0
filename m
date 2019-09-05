From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  5 Sep 2019 09:29:47 +0100
Message-Id: <20190905082947.6633-3-stefanha@redhat.com>
In-Reply-To: <20190905082947.6633-1-stefanha@redhat.com>
References: <20190905082947.6633-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RESEND 2/2] virtiofsd: replace err(3) and
	errx(3) with fuse_err()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Do not use err(3) and errx(3) since they print to stderr.  When --syslog
is used these messages must go to syslog(3) instead.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 107 +++++++++++++++++++----------
 contrib/virtiofsd/seccomp.c        |  15 ++--
 2 files changed, 81 insertions(+), 41 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 7fab0bf6c1..9c6f60ef5a 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -47,7 +47,6 @@
 #include <dirent.h>
 #include <assert.h>
 #include <errno.h>
-#include <err.h>
 #include <semaphore.h>
 #include <inttypes.h>
 #include <pthread.h>
@@ -1081,12 +1080,16 @@ static void lo_restore_cred(struct lo_cred *old)
 	int res;
 
 	res = syscall(SYS_setresuid, -1, old->euid, -1);
-	if (res == -1)
-		err(1, "seteuid(%u)", old->euid);
+	if (res == -1) {
+		fuse_err("seteuid(%u): %m\n", old->euid);
+		exit(1);
+	}
 
 	res = syscall(SYS_setresgid, -1, old->egid, -1);
-	if (res == -1)
-		err(1, "setegid(%u)", old->egid);
+	if (res == -1) {
+		fuse_err("setegid(%u): %m\n", old->egid);
+		exit(1);
+	}
 }
 
 static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
@@ -2677,8 +2680,10 @@ static void setup_shared_versions(struct lo_data *lo)
 		return;
 
 	sock = socket(AF_UNIX, SOCK_SEQPACKET, 0);
-	if (sock == -1)
-		err(1, "socket(AF_UNIX, SOCK_SEQPACKET, 0)");
+	if (sock == -1) {
+		fuse_err("socket(AF_UNIX, SOCK_SEQPACKET, 0): %m\n");
+		exit(1);
+	}
 
 	strncpy(name.sun_path, socket_name, sizeof(name.sun_path) - 1);
 
@@ -2694,18 +2699,25 @@ static void setup_shared_versions(struct lo_data *lo)
 	lo->ireg_sock = sock;
 
 	fd = open(version_path, O_RDWR);
-	if (sock == -1)
-		err(1, "open(%s, O_RDWR)", version_path);
+	if (sock == -1) {
+		fuse_err("open(%s, O_RDWR): %m\n", version_path);
+		exit(1);
+	}
 
 	res = fstat(fd, &stat);
-	if (res == -1)
-		err(1, "fstat(%i, &stat)", fd);
+	if (res == -1) {
+		fuse_err("fstat(%i, &stat): %m\n", fd);
+		exit(1);
+	}
 
 	lo->version_table_size = stat.st_size / sizeof(lo->version_table[0]);
 
 	addr = mmap(NULL, stat.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED)
-		err(1, "mmap(NULL, %li, PROT_READ | PROT_WRITE, MAP_SHARED, %i, 0", stat.st_size, fd);
+	if (addr == MAP_FAILED) {
+		fuse_err("mmap(NULL, %li, PROT_READ | PROT_WRITE, MAP_SHARED, %i, 0): %m\n",
+			 stat.st_size, fd);
+		exit(1);
+	}
 
 	lo->version_table = addr;
 }
@@ -2718,36 +2730,44 @@ static void setup_pivot_root(const char *source)
 
 	oldroot = open("/", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
 	if (oldroot < 0) {
-		err(1, "open(/)");
+		fuse_err("open(/): %m\n");
+		exit(1);
 	}
 
 	newroot = open(source, O_DIRECTORY | O_RDONLY | O_CLOEXEC);
 	if (newroot < 0) {
-		err(1, "open(%s)", source);
+		fuse_err("open(%s): %m\n", source);
+		exit(1);
 	}
 
 	if (fchdir(newroot) < 0) {
-		err(1, "fchdir(newroot)");
+		fuse_err("fchdir(newroot): %m\n");
+		exit(1);
 	}
 
 	if (syscall(__NR_pivot_root, ".", ".") < 0){
-		err(1, "pivot_root(., .)");
+		fuse_err("pivot_root(., .): %m\n");
+		exit(1);
 	}
 
 	if (fchdir(oldroot) < 0) {
-		err(1, "fchdir(oldroot)");
+		fuse_err("fchdir(oldroot): %m\n");
+		exit(1);
 	}
 
 	if (mount("", ".", "", MS_SLAVE | MS_REC, NULL) < 0) {
-		err(1, "mount(., MS_SLAVE | MS_REC)");
+		fuse_err("mount(., MS_SLAVE | MS_REC): %m\n");
+		exit(1);
 	}
 
 	if (umount2(".", MNT_DETACH) < 0) {
-		err(1, "umount2(., MNT_DETACH)");
+		fuse_err("umount2(., MNT_DETACH): %m\n");
+		exit(1);
 	}
 
 	if (fchdir(newroot) < 0) {
-		err(1, "fchdir(newroot)");
+		fuse_err("fchdir(newroot): %m\n");
+		exit(1);
 	}
 
 	close(newroot);
@@ -2761,15 +2781,18 @@ static void setup_pivot_root(const char *source)
 static void setup_mount_namespace(const char *source)
 {
 	if (unshare(CLONE_NEWNS) != 0) {
-		err(1, "unshare(CLONE_NEWNS)");
+		fuse_err("unshare(CLONE_NEWNS): %m\n");
+		exit(1);
 	}
 
 	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
-		err(1, "mount(/, MS_REC|MS_PRIVATE)");
+		fuse_err("mount(/, MS_REC|MS_PRIVATE): %m\n");
+		exit(1);
 	}
 
 	if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
-		err(1, "mount(%s, %s, MS_BIND)", source, source);
+		fuse_err("mount(%s, %s, MS_BIND): %m\n", source, source);
+		exit(1);
 	}
 
 	setup_pivot_root(source);
@@ -2791,12 +2814,15 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
 	struct stat stat;
 
 	fd = open("/", O_PATH);
-	if (fd == -1)
-		err(1, "open(%s, O_PATH)", lo->source);
+	if (fd == -1) {
+		fuse_err("open(%s, O_PATH): %m\n", lo->source);
+	}
 
 	res = fstatat(fd, "", &stat, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
-	if (res == -1)
-		err(1, "fstatat(%s)", lo->source);
+	if (res == -1) {
+		fuse_err("fstatat(%s): %m\n", lo->source);
+		exit(1);
+	}
 
 	root->fd = fd;
 	root->key.ino = stat.st_ino;
@@ -2809,7 +2835,8 @@ static void setup_proc_self_fd(struct lo_data *lo)
 {
 	lo->proc_self_fd = open("/proc/self/fd", O_PATH);
 	if (lo->proc_self_fd == -1) {
-		err(1, "open(/proc/self/fd, O_PATH)");
+		fuse_err("open(/proc/self/fd, O_PATH): %m\n");
+		exit(1);
 	}
 }
 
@@ -2828,14 +2855,16 @@ static void setup_nofile_rlimit(void)
 	errno = 0;
 	max = strtoll(nr_open, NULL, 0);
 	if (errno) {
-		err(1, "strtoll(%s)", nr_open);
+		fuse_err("strtoll(%s): %m\n", nr_open);
+		exit(1);
 	}
 
 	rlim.rlim_cur = max;
 	rlim.rlim_max = max;
 
 	if (setrlimit(RLIMIT_NOFILE, &rlim) < 0) {
-		err(1, "setrlimit(RLIMIT_NOFILE)");
+		fuse_err("setrlimit(RLIMIT_NOFILE): %m\n");
+		exit(1);
 	}
 
 	g_free(nr_open);
@@ -2951,10 +2980,15 @@ int main(int argc, char *argv[])
 		int res;
 
 		res = lstat(lo.source, &stat);
-		if (res == -1)
-			err(1, "failed to stat source (\"%s\")", lo.source);
-		if (!S_ISDIR(stat.st_mode))
-			errx(1, "source is not a directory");
+		if (res == -1) {
+			fuse_err("failed to stat source (\"%s\"): %m\n",
+				 lo.source);
+			exit(1);
+		}
+		if (!S_ISDIR(stat.st_mode)) {
+			fuse_err("source is not a directory\n");
+			exit(1);
+		}
 	} else {
 		lo.source = strdup("/");
 	}
@@ -2974,7 +3008,8 @@ int main(int argc, char *argv[])
 			break;
 		}
 	} else if (lo.timeout < 0) {
-		errx(1, "timeout is negative (%lf)", lo.timeout);
+		fuse_err("timeout is negative (%lf)\n", lo.timeout);
+		exit(1);
 	}
 
 	setup_shared_versions(&lo);
diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 3b92c6ee13..c4d9cd6fab 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -7,10 +7,10 @@
  */
 
 #include <stdlib.h>
-#include <err.h>
 #include <errno.h>
 #include <seccomp.h>
 #include <glib.h>
+#include "fuse_log.h"
 #include "seccomp.h"
 
 static const int syscall_whitelist[] = {
@@ -97,7 +97,9 @@ static void add_whitelist(scmp_filter_ctx ctx, const int syscalls[],
 	for (i = 0; i < len; i++) {
 		if (seccomp_rule_add(ctx, SCMP_ACT_ALLOW,
 				     syscalls[i], 0) != 0) {
-			err(1, "seccomp_rule_add syscall %d", syscalls[i]);
+			fuse_err("seccomp_rule_add syscall %d failed\n",
+				 syscalls[i]);
+			exit(1);
 		}
 	}
 }
@@ -112,7 +114,8 @@ void setup_seccomp(bool enable_syslog)
 	ctx = seccomp_init(SCMP_ACT_KILL);
 #endif
 	if (!ctx) {
-		err(1, "seccomp_init()");
+		fuse_err("seccomp_init() failed\n");
+		exit(1);
 	}
 
 	add_whitelist(ctx, syscall_whitelist, G_N_ELEMENTS(syscall_whitelist));
@@ -123,11 +126,13 @@ void setup_seccomp(bool enable_syslog)
 
 	/* libvhost-user calls this for post-copy migration, we don't need it */
 	if (seccomp_rule_add(ctx, SCMP_ACT_ERRNO(ENOSYS), SCMP_SYS(userfaultfd), 0) != 0) {
-		err(1, "seccomp_rule_add userfaultfd");
+		fuse_err("seccomp_rule_add userfaultfd failed\n");
+		exit(1);
 	}
 
 	if (seccomp_load(ctx) < 0) {
-		err(1, "seccomp_load()");
+		fuse_err("seccomp_load() failed\n");
+		exit(1);
 	}
 
 	seccomp_release(ctx);
-- 
2.21.0

