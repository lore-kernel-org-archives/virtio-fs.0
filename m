From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 13 Aug 2019 15:29:44 -0400
Message-Id: <20190813192944.26009-5-vgoyal@redhat.com>
In-Reply-To: <20190813192944.26009-1-vgoyal@redhat.com>
References: <20190813192944.26009-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] virtiofsd: Drop CAP_FSETID if client asked
	for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If client requested killing setuid/setgid bits on file being written, drop
CAP_FSETID capability so that setuid/setgid bits are cleared upon write
automatically.

pjdfstest chown/12.t needs this.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/Makefile.objs    |   2 +
 contrib/virtiofsd/passthrough_ll.c | 127 +++++++++++++++++++++++++++++
 contrib/virtiofsd/seccomp.c        |   2 +
 3 files changed, 131 insertions(+)

diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
index 941b19f18e..25f1e8dd73 100644
--- a/contrib/virtiofsd/Makefile.objs
+++ b/contrib/virtiofsd/Makefile.objs
@@ -11,3 +11,5 @@ virtiofsd-obj-y = buffer.o \
 
 seccomp.o-cflags := $(SECCOMP_CFLAGS)
 seccomp.o-libs := $(SECCOMP_LIBS)
+
+passthrough_ll.o-libs += -lcap
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 321bbb20be..412663653a 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -56,6 +56,7 @@
 #include <sys/mman.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/capability.h>
 
 #include "ireg.h"
 #include <sys/mount.h>
@@ -230,6 +231,115 @@ static struct lo_data *lo_data(fuse_req_t req)
 	return (struct lo_data *) fuse_req_userdata(req);
 }
 
+/* Helpers for dropping and regaining effective capabilities. Returns 0
+ * on success, error otherwise  */
+static int drop_effective_cap(const char *cap_name, bool *cap_dropped)
+{
+	cap_t caps;
+	cap_value_t cap;
+	cap_flag_value_t cap_value;
+	int ret = 0;
+
+	ret = cap_from_name(cap_name, &cap);
+	if (ret == -1) {
+		ret = errno;
+		fuse_err("cap_from_name(%s) failed:%s\n", cap_name,
+			 strerror(errno));
+		goto out;
+	}
+
+	if (!CAP_IS_SUPPORTED(cap)) {
+		fuse_err("capability(%s) is not supported\n", cap_name);
+		return EINVAL;
+	}
+
+	caps = cap_get_proc();
+	if (caps == NULL) {
+		ret = errno;
+		fuse_err("cap_get_proc() failed\n");
+		goto out;
+	}
+
+	if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &cap_value) == -1) {
+		ret = errno;
+		fuse_err("cap_get_flag() failed\n");
+		goto out_cap_free;
+	}
+
+	/* We dont have this capability in effective set already. */
+	if (cap_value == CAP_CLEAR) {
+		ret = 0;
+		goto out_cap_free;
+	}
+
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_CLEAR) == -1) {
+		ret = errno;
+		fuse_err("cap_set_flag() failed\n");
+		goto out_cap_free;
+	}
+
+	if (cap_set_proc(caps) == -1) {
+		ret = errno;
+		fuse_err("cap_set_procs() failed\n");
+		goto out_cap_free;
+	}
+
+	ret = 0;
+	if (cap_dropped)
+		*cap_dropped = true;
+
+out_cap_free:
+	cap_free(caps);
+out:
+	return ret;
+}
+
+static int gain_effective_cap(const char *cap_name)
+{
+	cap_t caps;
+	cap_value_t cap;
+	int ret = 0;
+
+	ret = cap_from_name(cap_name, &cap);
+	if (ret == -1) {
+		ret = errno;
+		fuse_err("cap_from_name(%s) failed:%s\n", cap_name,
+			 strerror(errno));
+		goto out;
+	}
+
+	if (!CAP_IS_SUPPORTED(cap)) {
+		fuse_err("capability(%s) is not supported\n", cap_name);
+		return EINVAL;
+	}
+
+	caps = cap_get_proc();
+	if (caps == NULL) {
+		ret = errno;
+		fuse_err("cap_get_proc() failed\n");
+		goto out;
+	}
+
+
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_SET) == -1) {
+		ret = errno;
+		fuse_err("cap_set_flag() failed\n");
+		goto out_cap_free;
+	}
+
+	if (cap_set_proc(caps) == -1) {
+		ret = errno;
+		fuse_err("cap_set_procs() failed\n");
+		goto out_cap_free;
+	}
+	ret = 0;
+
+out_cap_free:
+	cap_free(caps);
+out:
+	return ret;
+}
+
 static void lo_map_init(struct lo_map *map)
 {
 	map->elems = NULL;
@@ -2014,6 +2124,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 	ssize_t res;
 	struct fuse_bufvec out_buf = FUSE_BUFVEC_INIT(fuse_buf_size(in_buf));
 	struct lo_data *lo = lo_data(req);
+	bool cap_fsetid_dropped = false;
 
 	out_buf.buf[0].flags = FUSE_BUF_IS_FD | FUSE_BUF_FD_SEEK;
 	out_buf.buf[0].fd = lo_fi_fd(req, fi);
@@ -2023,6 +2134,16 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
 			   ino, out_buf.buf[0].size, (unsigned long) off);
 
+	/*
+	 * If kill_priv is set, drop CAP_FSETID which should lead to kernel
+	 * clearing setuid/setgid on file.
+	 */
+	if (fi->kill_priv) {
+		res = drop_effective_cap("cap_fsetid", &cap_fsetid_dropped);
+		if (res != 0)
+			fuse_reply_err(req, res);
+	}
+
 	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
 	if(res < 0) {
 		fuse_reply_err(req, -res);
@@ -2037,6 +2158,12 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 
 		fuse_reply_write(req, (size_t) res);
 	}
+
+	if (cap_fsetid_dropped) {
+		res = gain_effective_cap("cap_fsetid");
+		if (res)
+			fuse_err("Failed to gain CAP_FSETID\n");
+	}
 }
 
 static void lo_statfs(fuse_req_t req, fuse_ino_t ino)
diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 5f1c873b82..7384ebee0a 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -78,6 +78,8 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(unlinkat),
 	SCMP_SYS(utimensat),
 	SCMP_SYS(write),
+	SCMP_SYS(capget),
+	SCMP_SYS(capset),
 };
 
 /* Syscalls used when --syslog is enabled */
-- 
2.17.2

