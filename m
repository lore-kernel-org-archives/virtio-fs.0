From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  3 Dec 2019 13:14:23 +0000
Message-Id: <20191203131423.40962-3-dgilbert@redhat.com>
In-Reply-To: <20191203131423.40962-1-dgilbert@redhat.com>
References: <20191203131423.40962-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Convert to libcap-ng
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

QEMU is moving to libcap-ng, so lets move as well.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 contrib/virtiofsd/Makefile.objs    |  2 -
 contrib/virtiofsd/passthrough_ll.c | 90 +++++++++++-------------------
 2 files changed, 33 insertions(+), 59 deletions(-)

diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
index 25f1e8dd73..941b19f18e 100644
--- a/contrib/virtiofsd/Makefile.objs
+++ b/contrib/virtiofsd/Makefile.objs
@@ -11,5 +11,3 @@ virtiofsd-obj-y = buffer.o \
 
 seccomp.o-cflags := $(SECCOMP_CFLAGS)
 seccomp.o-libs := $(SECCOMP_LIBS)
-
-passthrough_ll.o-libs += -lcap
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 139261efc1..a081a91b85 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -59,7 +59,6 @@
 #include <sys/prctl.h>
 #include <sys/syscall.h>
 #include <sys/xattr.h>
-#include <sys/capability.h>
 #include <sys/mount.h>
 #include <sys/mman.h>
 #include <sys/resource.h>
@@ -285,107 +284,82 @@ static int load_capng(void)
  * on success, error otherwise  */
 static int drop_effective_cap(const char *cap_name, bool *cap_dropped)
 {
-	cap_t caps;
-	cap_value_t cap;
-	cap_flag_value_t cap_value;
-	int ret = 0;
+	int cap, ret;
 
-	ret = cap_from_name(cap_name, &cap);
-	if (ret == -1) {
+	cap = capng_name_to_capability(cap_name);
+	if (cap < 0) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_from_name(%s) failed:%s\n", cap_name,
+		fuse_log(FUSE_LOG_ERR,
+			 "capng_name_to_capability(%s) failed:%s\n", cap_name,
 			 strerror(errno));
 		goto out;
 	}
 
-	if (!CAP_IS_SUPPORTED(cap)) {
-		fuse_log(FUSE_LOG_ERR, "capability(%s) is not supported\n", cap_name);
-		return EINVAL;
-	}
-
-	caps = cap_get_proc();
-	if (caps == NULL) {
+	if (load_capng()) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_get_proc() failed\n");
+		fuse_log(FUSE_LOG_ERR, "load_capng() failed\n");
 		goto out;
 	}
 
-	if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &cap_value) == -1) {
-		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_get_flag() failed\n");
-		goto out_cap_free;
-	}
-
 	/* We dont have this capability in effective set already. */
-	if (cap_value == CAP_CLEAR) {
+	if (!capng_have_capability(CAPNG_EFFECTIVE, cap)) {
 		ret = 0;
-		goto out_cap_free;
+		goto out;
 	}
 
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_CLEAR) == -1) {
+	if (capng_update(CAPNG_DROP, CAPNG_EFFECTIVE, cap)) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_set_flag() failed\n");
-		goto out_cap_free;
+		fuse_log(FUSE_LOG_ERR, "capng_update(DROP,) failed\n");
+		goto out;
 	}
 
-	if (cap_set_proc(caps) == -1) {
+	if (capng_apply(CAPNG_SELECT_CAPS)) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_set_procs() failed\n");
-		goto out_cap_free;
+		fuse_log(FUSE_LOG_ERR, "drop:capng_apply() failed\n");
+		goto out;
 	}
 
 	ret = 0;
 	if (cap_dropped)
 		*cap_dropped = true;
 
-out_cap_free:
-	cap_free(caps);
 out:
 	return ret;
 }
 
 static int gain_effective_cap(const char *cap_name)
 {
-	cap_t caps;
-	cap_value_t cap;
+	int cap;
 	int ret = 0;
 
-	ret = cap_from_name(cap_name, &cap);
-	if (ret == -1) {
+	cap = capng_name_to_capability(cap_name);
+	if (cap < 0) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_from_name(%s) failed:%s\n", cap_name,
+		fuse_log(FUSE_LOG_ERR,
+			 "capng_name_to_capability(%s) failed:%s\n", cap_name,
 			 strerror(errno));
 		goto out;
 	}
 
-	if (!CAP_IS_SUPPORTED(cap)) {
-		fuse_log(FUSE_LOG_ERR, "capability(%s) is not supported\n", cap_name);
-		return EINVAL;
-	}
-
-	caps = cap_get_proc();
-	if (caps == NULL) {
+	if (load_capng()) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_get_proc() failed\n");
+		fuse_log(FUSE_LOG_ERR, "load_capng() failed\n");
 		goto out;
 	}
 
-
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap, CAP_SET) == -1) {
+	if (capng_update(CAPNG_ADD, CAPNG_EFFECTIVE, cap)) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_set_flag() failed\n");
-		goto out_cap_free;
+		fuse_log(FUSE_LOG_ERR, "capng_update(ADD,) failed\n");
+		goto out;
 	}
 
-	if (cap_set_proc(caps) == -1) {
+	if (capng_apply(CAPNG_SELECT_CAPS)) {
 		ret = errno;
-		fuse_log(FUSE_LOG_ERR, "cap_set_procs() failed\n");
-		goto out_cap_free;
+		fuse_log(FUSE_LOG_ERR, "gain:capng_apply() failed\n");
+		goto out;
 	}
 	ret = 0;
 
-out_cap_free:
-	cap_free(caps);
 out:
 	return ret;
 }
@@ -2186,9 +2160,11 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 	 * clearing setuid/setgid on file.
 	 */
 	if (fi->kill_priv) {
-		res = drop_effective_cap("cap_fsetid", &cap_fsetid_dropped);
-		if (res != 0)
+		res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
+		if (res != 0) {
 			fuse_reply_err(req, res);
+			return;
+		}
 	}
 
 	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
@@ -2207,7 +2183,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 	}
 
 	if (cap_fsetid_dropped) {
-		res = gain_effective_cap("cap_fsetid");
+		res = gain_effective_cap("FSETID");
 		if (res)
 			fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
 	}
-- 
2.23.0

