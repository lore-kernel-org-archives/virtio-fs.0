From: Gang Deng <gavin.dg@linux.alibaba.com>
Date: Mon, 19 Aug 2019 11:41:14 +0800
Message-Id: <8b1d9bb9ac4b539fc9ebef0c4676d4cc1cafad5b.1566185612.git.gavin.dg@linux.alibaba.com>
In-Reply-To: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs]  [RFC PATCH 2/2] virtiofsd: support vstat&&vtrace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: gavin.dg@linux.alibaba.com

With this patch, when the vritiofsd daemon was started with '-o trace' option,
we can use vstat to show performance of virtiofs, e.g.

 $ sudo ./vstat /proc/<virtiofs-pid>/fd/<trace-file> 1

Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
---
 Makefile                           |  3 +++
 Makefile.objs                      |  1 +
 contrib/virtiofsd/Makefile.objs    |  5 ++++-
 contrib/virtiofsd/fuse_i.h         |  1 +
 contrib/virtiofsd/fuse_lowlevel.c  | 11 +++++++++++
 contrib/virtiofsd/fuse_lowlevel.h  |  1 +
 contrib/virtiofsd/helper.c         |  4 +++-
 contrib/virtiofsd/passthrough_ll.c |  7 +++++++
 8 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a3dfdd6fa8..bf6e9145b6 100644
--- a/Makefile
+++ b/Makefile
@@ -414,6 +414,7 @@ dummy := $(call unnest-vars,, \
                 ivshmem-client-obj-y \
                 ivshmem-server-obj-y \
                 virtiofsd-obj-y \
+                vstat-obj-y \
                 rdmacm-mux-obj-y \
                 libvhost-user-obj-y \
                 vhost-user-scsi-obj-y \
@@ -648,6 +649,8 @@ rdmacm-mux$(EXESUF): $(rdmacm-mux-obj-y) $(COMMON_LDADDS)
 ifdef CONFIG_LINUX # relies on Linux-specific syscalls
 virtiofsd$(EXESUF): $(virtiofsd-obj-y) libvhost-user.a $(COMMON_LDADDS)
 	$(call LINK, $^)
+vstat$(EXESUF): $(vstat-obj-y) $(COMMON_LDADDS)
+	$(call LINK, $^)
 endif
 
 vhost-user-gpu$(EXESUF): $(vhost-user-gpu-obj-y) $(libvhost-user-obj-y) libqemuutil.a libqemustub.a
diff --git a/Makefile.objs b/Makefile.objs
index dfdd7d56ea..f2c64ac089 100644
--- a/Makefile.objs
+++ b/Makefile.objs
@@ -126,6 +126,7 @@ rdmacm-mux-obj-y = contrib/rdmacm-mux/
 vhost-user-input-obj-y = contrib/vhost-user-input/
 vhost-user-gpu-obj-y = contrib/vhost-user-gpu/
 virtiofsd-obj-y = contrib/virtiofsd/
+vstat-obj-y = contrib/virtiofsd/
 
 ######################################################################
 trace-events-subdirs =
diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
index 25f1e8dd73..8fdfb4b81b 100644
--- a/contrib/virtiofsd/Makefile.objs
+++ b/contrib/virtiofsd/Makefile.objs
@@ -7,9 +7,12 @@ virtiofsd-obj-y = buffer.o \
                   fuse_virtio.o \
                   helper.o \
                   passthrough_ll.o \
-                  seccomp.o
+                  seccomp.o \
+                  vtrace.o
 
 seccomp.o-cflags := $(SECCOMP_CFLAGS)
 seccomp.o-libs := $(SECCOMP_LIBS)
 
 passthrough_ll.o-libs += -lcap
+
+vstat-obj-y = vstat.o
diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
index 5c82cf2eac..2271b60b79 100644
--- a/contrib/virtiofsd/fuse_i.h
+++ b/contrib/virtiofsd/fuse_i.h
@@ -75,6 +75,7 @@ struct fuse_session {
         int   vu_socketfd;
         struct fv_VuDev *virtio_dev;
         int thread_pool_size;
+	struct virtiofs_trace *trace;
 };
 
 struct fuse_chan {
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index ff5e79a8f3..2366336b0a 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -15,6 +15,7 @@
 #include "fuse_opt.h"
 #include "fuse_misc.h"
 #include "fuse_virtio.h"
+#include "vtrace.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -2420,6 +2421,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
 	struct fuse_mbuf_iter iter = FUSE_MBUF_ITER_INIT(buf);
 	struct fuse_in_header *in;
 	struct fuse_req *req;
+	uint64_t start = 0;
 	int err;
 
 	/* The first buffer must be a memory buffer */
@@ -2513,11 +2515,20 @@ void fuse_session_process_buf_int(struct fuse_session *se,
 			fuse_reply_err(intr, EAGAIN);
 	}
 
+	if (se->trace) {
+		start = vtrace_rdtsc();
+		virtiofs_trace_account_op_begin(se->trace, in->opcode);
+	}
+
 	if (in->opcode == FUSE_WRITE && se->op.write_buf)
 		do_write_buf(req, in->nodeid, &iter, bufv);
 	else
 		fuse_ll_ops[in->opcode].func(req, in->nodeid, &iter);
 
+	if (se->trace)
+		virtiofs_trace_account_op_end(se->trace, in->opcode,
+					(int64_t)(vtrace_rdtsc() - start));
+
 	pthread_rwlock_unlock(&se->init_rwlock);
 	return;
 
diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
index b441d3dfed..69d598c23c 100644
--- a/contrib/virtiofsd/fuse_lowlevel.h
+++ b/contrib/virtiofsd/fuse_lowlevel.h
@@ -1799,6 +1799,7 @@ struct fuse_cmdline_opts {
 	int clone_fd;
 	int syslog;
 	int log_level;
+	int trace;
 	unsigned int max_idle_threads;
 };
 
diff --git a/contrib/virtiofsd/helper.c b/contrib/virtiofsd/helper.c
index 4c71452080..8ec7cb57a4 100644
--- a/contrib/virtiofsd/helper.c
+++ b/contrib/virtiofsd/helper.c
@@ -56,6 +56,7 @@ static const struct fuse_opt fuse_helper_opts[] = {
 	FUSE_HELPER_OPT_VALUE("log_level=info", log_level, LOG_INFO),
 	FUSE_HELPER_OPT_VALUE("log_level=warn", log_level, LOG_WARNING),
 	FUSE_HELPER_OPT_VALUE("log_level=err", log_level, LOG_ERR),
+	FUSE_HELPER_OPT("trace",	trace),
 	FUSE_OPT_END
 };
 
@@ -145,7 +146,8 @@ void fuse_cmdline_help(void)
 	       "    -o max_idle_threads        the maximum number of idle worker threads\n"
 	       "                               allowed (default: 10)\n"
 	       "    -o log_level=<level>       log level, default to \"info\"\n"
-	       "                               level could be one of \"debug, info, warn, err\"\n");
+	       "                               level could be one of \"debug, info, warn, err\"\n"
+	       "    -o trace                   record raw statistics which can be reported by vstat\n");
 }
 
 static int fuse_helper_opt_proc(void *data, const char *arg, int key,
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index ca11764feb..a6146d93ca 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -66,6 +66,7 @@
 #include <gmodule.h>
 #include "fuse_log.h"
 #include "seccomp.h"
+#include "vtrace.h"
 
 /* Keep track of inode posix locks for each owner. */
 struct lo_inode_plock {
@@ -2974,6 +2975,10 @@ int main(int argc, char *argv[])
 
 	fuse_daemonize(opts.foreground);
 
+	/* error could also be acceptable */
+	if (opts.trace)
+		se->trace = virtiofs_trace_init(lo.source);
+
 	if (lo.ireg_sock != -1) {
 		pthread_t ireg_thread;
 
@@ -2997,6 +3002,8 @@ int main(int argc, char *argv[])
 	/* Block until ctrl+c or fusermount -u */
         ret = virtio_loop(se);
 
+	if (opts.trace)
+		virtiofs_trace_fin(se->trace);
 err_out4:
 	fuse_session_unmount(se);
 err_out3:
-- 
2.20.1.7.g153144c

