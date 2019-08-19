From: Gang Deng <gavin.dg@linux.alibaba.com>
Date: Mon, 19 Aug 2019 11:41:13 +0800
Message-Id: <09680e84da8a43ee8fa69ed4ec7d1a5a5ffa9130.1566185612.git.gavin.dg@linux.alibaba.com>
In-Reply-To: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
References: <cover.1566185612.git.gavin.dg@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs]  [RFC PATCH 1/2] virtiofsd: add stat tools
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

There exist two components: vtrace && vstat. vtrace is embeded in virtiofsd,
it will put raw statistics data into share memory. Then the vstat tool could
parse it and do some post processing works. The performance overhead of
vtrace is very small because it does very simple things.

For example, if we call open(2)/close(2) frequently in guest, and
randwite a file whose length is greater than the size of dax window.
We'll get the output as below:

op                        inflt         op/s     svctm/us   %util
FUSE_OPEN(14)                 0      8379.87         3.24   2.71%
FUSE_RELEASE(18)              0      8379.87         1.77   1.48%
FUSE_FLUSH(25)                0      8379.87         2.04   1.71%
FUSE_SETUPMAPPING(48)         1      6393.90        34.72  22.20%
FUSE_REMOVEMAPPING(49)        0      6404.90        37.61  24.09%
TOTAL                         1     37938.39        13.76  52.20%

The meaning of fields:

- op
  The type of fuse requests, 'TOTAL' is sum of all.

- inflt
  The number of the inflight requests, it must be ethier 0 or 1 because
  virtiofsd can only process fuse requests serially.

- op/s
  The number of fuse requests completed per second.

- svctm/us
  The average service time (in microseconds) for fuse requests.

- %util
  Percentage of elapsed time during which virtiofsd was processing the fuse
  requests.

when virtiofsd is hang, e.g. we support flock in host (just for example,
this has been fxied), we'll get this:

op                        inflt         op/s     svctm/us   %util
FUSE_SETLKW(33)               1         0.00         0.00 100.00%
TOTAL                         1         0.00         0.00 100.00%

the utilization is 100% and op/s equals zero, it indicates hang.

If virtiofsd is idle, then the output looks like this:

op                        inflt         op/s     svctm/us   %util
TOTAL                         0         0.00         0.00   0.00%

Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
---
 contrib/virtiofsd/vstat.c  | 680 +++++++++++++++++++++++++++++++++++++
 contrib/virtiofsd/vtrace.c |  95 ++++++
 contrib/virtiofsd/vtrace.h |  53 +++
 3 files changed, 828 insertions(+)
 create mode 100644 contrib/virtiofsd/vstat.c
 create mode 100644 contrib/virtiofsd/vtrace.c
 create mode 100644 contrib/virtiofsd/vtrace.h

diff --git a/contrib/virtiofsd/vstat.c b/contrib/virtiofsd/vstat.c
new file mode 100644
index 0000000000..aa7048fba4
--- /dev/null
+++ b/contrib/virtiofsd/vstat.c
@@ -0,0 +1,680 @@
+#include <assert.h>
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/queue.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "fuse_kernel.h"
+#include "vtrace.h"
+
+/*
+ * There exist two components: vtrace && vstat. vtrace is embeded in virtiofsd,
+ * it will put raw statistics data into share memory. Then the vstat tool could
+ * parse it and do some post processing works. The performance overhead of
+ * vtrace is very small because it does very simple things.
+ *
+ * For example, if we call open(2)/close(2) frequently in guest, and
+ * randwite a file whose length is greater than the size of dax window.
+ * We'll get the output as below:
+ *
+ * op                        inflt         op/s     svctm/us   %util
+ * FUSE_OPEN(14)                 0      8379.87         3.24   2.71%
+ * FUSE_RELEASE(18)              0      8379.87         1.77   1.48%
+ * FUSE_FLUSH(25)                0      8379.87         2.04   1.71%
+ * FUSE_SETUPMAPPING(48)         1      6393.90        34.72  22.20%
+ * FUSE_REMOVEMAPPING(49)        0      6404.90        37.61  24.09%
+ * TOTAL                         1     37938.39        13.76  52.20%
+ *
+ * The meaning of fields:
+ *
+ * - op
+ *   The type of fuse requests, 'TOTAL' is sum of all.
+ *
+ * - inflt
+ *   The number of the inflight requests, it must be ethier 0 or 1 because
+ *   virtiofsd can only process fuse requests serially.
+ *
+ * - op/s
+ *   The number of fuse requests completed per second.
+ *
+ * - svctm/us
+ *   The average service time (in microseconds) for fuse requests.
+ *
+ * - %util
+ *   Percentage of elapsed time during which virtiofsd was processing the fuse
+ *   requests.
+ *
+ * when virtiofsd is hang, e.g. we support flock in host (just for example,
+ * this has been fxied), we'll get this:
+ *
+ * op                        inflt         op/s     svctm/us   %util
+ * FUSE_SETLKW(33)               1         0.00         0.00 100.00%
+ * TOTAL                         1         0.00         0.00 100.00%
+ *
+ * the utilization is 100% and op/s equals zero, it indicates hang.
+ *
+ * If virtiofsd is idle, then the output looks like this:
+ *
+ * op                        inflt         op/s     svctm/us   %util
+ * TOTAL                         0         0.00         0.00   0.00%
+ *
+ *
+ *TODO:
+ * Vstat was designed to scan VIRTIOFS_TRACE_DIR directory to get all virtiofs
+ * devices. However it's not supported yet. Because virtiofsd couldn't unlink
+ * the trace file when exited due to the sandboxing, actually we unlink the
+ * trace file when inited. Then vstat can only access the trace file through
+ * the /proc/<virtiofs-pid>/fd/<trace-file> (which needs root privilege)
+ * This should be refactored later if virtiofsd could access /dev/shm
+ * directory, then vstat can run as nobody and be able to scan all devices
+ * like iostat tool.
+ */
+
+#define MS_PER_SEC 			1000
+#define US_PER_SEC 			1000000
+#define NS_PER_SEC			1000000000
+#define SEC_PER_DAY			(3600 * 24)
+#define usec_to_sec(usec)		((double)(usec) / US_PER_SEC)
+#define usec_to_nsec(usec)		(usec * MS_PER_SEC)
+#define sec_to_usec(sec)		(sec * US_PER_SEC)
+
+struct trace_entry {
+	int				valid;
+	struct virtiofs_trace		trace[2];
+	char				trace_path[PATH_MAX];
+
+	TAILQ_ENTRY(trace_entry)	entries;
+};
+
+static uint64_t tsc_resolution_hz;
+static bool g_print_timestamp = false;
+static int g_interval = 1;
+static struct timeval g_ts[2];
+
+TAILQ_HEAD(, trace_entry) g_trace_head;
+
+
+static inline double us_to_tick(uint64_t us)
+{
+	return ((double)us) / US_PER_SEC * tsc_resolution_hz;
+}
+static inline double tick_to_us(uint64_t tick)
+{
+	return ((double)tick) / tsc_resolution_hz * US_PER_SEC;
+}
+
+static inline double tick_to_ms(uint64_t tick)
+{
+	return ((double)tick) / tsc_resolution_hz * MS_PER_SEC;
+}
+
+#define __case_ret_str(val)     case(val): return #val
+static const char *fuse_op2str(int op)
+{
+	switch(op) {
+	__case_ret_str(FUSE_LOOKUP);
+	__case_ret_str(FUSE_FORGET);
+	__case_ret_str(FUSE_GETATTR);
+	__case_ret_str(FUSE_SETATTR);
+	__case_ret_str(FUSE_READLINK);
+	__case_ret_str(FUSE_SYMLINK);
+	__case_ret_str(FUSE_MKNOD);
+	__case_ret_str(FUSE_MKDIR);
+	__case_ret_str(FUSE_UNLINK);
+	__case_ret_str(FUSE_RMDIR);
+	__case_ret_str(FUSE_RENAME);
+	__case_ret_str(FUSE_LINK);
+	__case_ret_str(FUSE_OPEN);
+	__case_ret_str(FUSE_READ);
+	__case_ret_str(FUSE_WRITE);
+	__case_ret_str(FUSE_STATFS);
+	__case_ret_str(FUSE_RELEASE);
+	__case_ret_str(FUSE_FSYNC);
+	__case_ret_str(FUSE_SETXATTR);
+	__case_ret_str(FUSE_GETXATTR);
+	__case_ret_str(FUSE_LISTXATTR);
+	__case_ret_str(FUSE_REMOVEXATTR);
+	__case_ret_str(FUSE_FLUSH);
+	__case_ret_str(FUSE_INIT);
+	__case_ret_str(FUSE_OPENDIR);
+	__case_ret_str(FUSE_READDIR);
+	__case_ret_str(FUSE_RELEASEDIR);
+	__case_ret_str(FUSE_FSYNCDIR);
+	__case_ret_str(FUSE_GETLK);
+	__case_ret_str(FUSE_SETLK);
+	__case_ret_str(FUSE_SETLKW);
+	__case_ret_str(FUSE_ACCESS);
+	__case_ret_str(FUSE_CREATE);
+	__case_ret_str(FUSE_INTERRUPT);
+	__case_ret_str(FUSE_BMAP);
+	__case_ret_str(FUSE_DESTROY);
+	__case_ret_str(FUSE_IOCTL);
+	__case_ret_str(FUSE_POLL);
+	__case_ret_str(FUSE_NOTIFY_REPLY);
+	__case_ret_str(FUSE_BATCH_FORGET);
+	__case_ret_str(FUSE_FALLOCATE);
+	__case_ret_str(FUSE_READDIRPLUS);
+	__case_ret_str(FUSE_RENAME2);
+	__case_ret_str(FUSE_LSEEK);
+	__case_ret_str(FUSE_COPY_FILE_RANGE);
+	__case_ret_str(FUSE_SETUPMAPPING);
+	__case_ret_str(FUSE_REMOVEMAPPING);
+	default: return "OP_UNKNOWN";
+	}
+}
+
+static void virtiofs_dump_trace(struct virtiofs_trace *trace)
+{
+	int op;
+	char op_buf[24];
+	struct fuse_op_stat *stat;
+
+	fprintf(stdout, "mountpoint %s\n", trace->mountpoint);
+	fprintf(stdout, "version 0x%x\n", trace->version);
+	fprintf(stdout, "%-24s %6s %16s %16s\n",
+		"op", "inflt", "done", "elapsed(ms)");
+	for (op = 0; op < VIRTIOFS_MAX_OP; op++) {
+		stat = &trace->stats[op];
+
+		/* filter noop */
+		if (!stat->done && !stat->inflight)
+			continue;
+		snprintf(op_buf, sizeof(op_buf), "%s(%d)", fuse_op2str(op), op);
+		fprintf(stdout, "%-24s %6"PRIu64" %16"PRIu64" %16.2f\n",
+			op_buf,
+			stat->inflight,
+			stat->done,
+			tick_to_ms(stat->elapsed_ticks));
+	}
+}
+
+
+/*
+ * TODO: trace_lookup/add/del was supposed to be used when vstat scan and show
+ * multiple devices.
+ */
+static inline struct trace_entry *trace_lookup(const char *trace_path)
+{
+	struct trace_entry *entry;
+
+	TAILQ_FOREACH(entry, &g_trace_head, entries) {
+		if (!strncmp(trace_path, entry->trace_path,
+			     sizeof(entry->trace_path)))
+			return entry;
+	}
+
+	return NULL;
+}
+
+static inline void trace_add(struct trace_entry *entry)
+{
+	TAILQ_INSERT_TAIL(&g_trace_head, entry, entries);
+}
+
+static inline void trace_del(struct trace_entry *entry)
+{
+	TAILQ_REMOVE(&g_trace_head, entry, entries);
+}
+
+static struct trace_entry *get_trace_by_path(const char *trace_path)
+{
+	struct trace_entry *entry = trace_lookup(trace_path);
+	if (entry)
+		return entry;
+
+	entry = (struct trace_entry *)malloc(sizeof(*entry));
+	if (entry == NULL)
+		return NULL;
+	memset(entry, 0, sizeof(*entry));
+	snprintf(entry->trace_path, sizeof(entry->trace_path),
+		 "%s", trace_path);
+	trace_add(entry);
+	return entry;
+}
+
+static void trace_put(struct trace_entry *entry)
+{
+	trace_del(entry);
+	free(entry);
+}
+
+static int virtiofs_read_trace_one_int(const char *trace_path,
+				       struct virtiofs_trace *trace)
+{
+	int trace_fd, ret;
+	struct stat s;
+	ssize_t read_len;
+
+	if (!trace_path)
+		return -1;
+
+	trace_fd = open(trace_path, O_RDONLY);
+	if (trace_fd == -1) {
+		fprintf(stderr, "open %s failed [%d]\n", trace_path, -errno);
+		return -1;
+	}
+
+	ret = fstat(trace_fd, &s);
+	if (ret != 0) {
+		fprintf(stderr, "fstat %s failed [%d]\n", trace_path, -errno);
+		goto failed;
+	}
+
+	/*
+	 * Treat it as version not compatible, just a stub because we have only
+	 * one version.
+	 */
+	if ((size_t)s.st_size != (sizeof(struct virtiofs_trace))) {
+		fprintf(stderr, "size %zu != %zu miss matched\n",
+			s.st_size, sizeof(struct virtiofs_trace));
+		goto failed;
+	}
+
+	/* read stat file */
+	read_len = read(trace_fd, trace, s.st_size);
+	if (read_len != s.st_size) {
+		fprintf(stderr, "read failed %ld(%ld)\n", read_len, s.st_size);
+		goto failed;
+	}
+
+	/*
+	 * Check version, vstat must be compatible to old vtrace version if
+	 * it exist.
+	 */
+	if (trace->version != VIRTIOFS_TRACE_VERSION) {
+		fprintf(stderr, "version 0x%x != 0x%x miss matched\n",
+			trace->version, VIRTIOFS_TRACE_VERSION);
+		goto failed;
+	}
+
+	close(trace_fd);
+	return 0;
+failed:
+	close(trace_fd);
+	return -1;
+}
+
+static int virtiofs_read_trace_one(const char *trace_path, int curr)
+{
+	struct trace_entry *entry = get_trace_by_path(trace_path);
+	if (entry == NULL)
+		return -1;
+	if (!virtiofs_read_trace_one_int(trace_path, &entry->trace[curr]))
+		entry->valid = 1;
+	return 0;
+}
+
+/* Detect whether it's a trace file. */
+static bool is_virtiofs_pci(const char *trace_path)
+{
+	int fd;
+	uint64_t val;
+	ssize_t len;
+
+	if (access(trace_path, R_OK))
+		return false;
+
+	fd = open(trace_path, O_RDONLY);
+	if (fd == -1)
+		return false;
+	len = read(fd, &val, sizeof(val));
+	close(fd);
+
+	if (len != sizeof(val))
+		return false;
+
+	return (val == VIRTIOFS_TRACE_MAGIC);
+}
+
+static void destroy_invalid_trace(void)
+{
+	struct trace_entry *entry;
+	TAILQ_FOREACH(entry, &g_trace_head, entries) {
+		if (!entry->valid) {
+			trace_put(entry);
+			continue;
+		}
+		/* mark invalid for next round */
+		entry->valid = 0;
+	}
+}
+
+static void virtiofs_read_trace(int curr, const char *trace_path)
+{
+	virtiofs_read_trace_one(trace_path, curr);
+	destroy_invalid_trace();
+}
+
+static void alarm_handler(int sig)
+{
+	alarm(g_interval);
+}
+
+static time_t get_localtime(struct tm *rectime, int d_off)
+{
+	time_t timer;
+	struct tm *ltm;
+
+	time(&timer);
+	timer -= SEC_PER_DAY * d_off;
+	ltm = localtime(&timer);
+
+	if (ltm)
+		*rectime = *ltm;
+	return timer;
+}
+
+static inline uint64_t timeval_sub(struct timeval t1, struct timeval t2)
+{
+	int64_t ret;
+
+	t1.tv_usec -= t2.tv_usec;
+	t1.tv_sec -= t2.tv_sec;
+
+	ret = sec_to_usec(t1.tv_sec) + t1.tv_usec;
+	return (ret < 0) ? 0 : ret;
+}
+
+/* clamp_positive */
+static inline int64_t cp(int64_t n)
+{
+	return (n < 0)  ?  0 : n;
+}
+
+#define SUM_FIELD(i, j, field) (((i)->field) += ((j)->field))
+#define DIFF_FIELD(i, j, field) (cp(((i)->field) - ((j)->field)))
+#define DIV(m, n) (((n) == 0) ?  0 : ((double)(m) / (n)))
+#define DVDF_FIELD(i, j, field, n) \
+	DIV((DIFF_FIELD(i, j, field)), (n))
+#define DVDFF_FIELD(i, j, field0, field1) \
+	DIV((DIFF_FIELD(i, j, field0)), (DIFF_FIELD(i, j, field1)))
+
+static void virtiofs_trace_output_one(struct trace_entry *entry,
+				      int curr,
+				      uint64_t dur /* in us */)
+{
+	struct virtiofs_trace *t_curr = &entry->trace[curr],
+			      *t_prev = &entry->trace[(curr ^ 1)];
+	struct fuse_op_stat *s_curr, *s_prev, tot_curr = {0}, tot_prev = {0};
+	int op;
+	char op_buf[24];
+	uint64_t deco_ticks;
+
+	fprintf(stdout, "%-24s %6s %12s %12s %7s\n",
+		"op", "inflt", "op/s", "svctm/us", "%util");
+	for (op = 0; op < VIRTIOFS_MAX_OP; op++) {
+		s_curr = &t_curr->stats[op];
+		s_prev = &t_prev->stats[op];
+
+		/* filter noop */
+		if (!DIFF_FIELD(s_curr, s_prev, done) && !s_curr->inflight)
+			continue;
+
+		/* To detect hung */
+		if ((s_curr->done == s_prev->done) &&
+		    (s_curr->inflight >= s_prev->inflight) &&
+		    (s_prev->inflight > 0))
+			deco_ticks = us_to_tick(dur);
+		else
+			deco_ticks = 0;
+		s_curr->elapsed_ticks += deco_ticks;
+		snprintf(op_buf, sizeof(op_buf), "%s(%d)", fuse_op2str(op), op);
+#define __OUTPUT_ONE(curr, prev)			do {		    \
+		fprintf(stdout, "%-24s %6"PRIu64" %12.2f %12.2f %6.2f%%\n", \
+			op_buf,						    \
+			(curr)->inflight,				    \
+			DVDF_FIELD(curr, prev, done, usec_to_sec(dur)),     \
+			tick_to_us(DVDFF_FIELD(curr, prev, elapsed_ticks, done)), \
+			DVDF_FIELD(curr, prev, elapsed_ticks, us_to_tick(dur)) * 100);\
+} while (0)
+		__OUTPUT_ONE(s_curr, s_prev);
+
+#define __ACCUMULATE(tot, s) 	do {			\
+		SUM_FIELD(tot, s, inflight);		\
+		SUM_FIELD(tot, s, done);		\
+		SUM_FIELD(tot, s, elapsed_ticks);	\
+} while (0)
+		__ACCUMULATE(&tot_curr, s_curr);
+		__ACCUMULATE(&tot_prev, s_prev);
+		s_curr->elapsed_ticks -= deco_ticks;
+	}
+
+	snprintf(op_buf, sizeof(op_buf), "%s", "TOTAL");
+	__OUTPUT_ONE(&tot_curr, &tot_prev);
+}
+
+static void virtiofs_trace_output(int curr, struct tm *rectime)
+{
+	struct trace_entry *entry;
+	uint64_t duration;
+	char timestamp[64];
+
+	duration = timeval_sub(g_ts[curr], g_ts[curr^1]);
+	if (duration == 0) {
+		fprintf(stderr, "duration is zero, impossible\n");
+		return;
+	}
+
+	fprintf(stdout, "\n");
+	if (g_print_timestamp) {
+		strftime(timestamp, sizeof(timestamp),
+			 "%Y-%m-%d %H:%M:%S", rectime);
+		fprintf(stdout, "%s\n", timestamp);
+	}
+
+	/* output body */
+	TAILQ_FOREACH(entry, &g_trace_head, entries)
+		virtiofs_trace_output_one(entry, curr, duration);
+}
+
+static int do_stat_summary(const char *trace_path)
+{
+	struct virtiofs_trace trace;
+	int ret;
+
+	ret = virtiofs_read_trace_one_int(trace_path, &trace);
+	if (ret)
+		return ret;
+	virtiofs_dump_trace(&trace);
+	return 0;
+}
+
+static int do_stat_loop(int interval, int count, const char *trace_path)
+{
+	int curr = 0;
+	struct sigaction alrm_act;
+	struct tm rectime;
+
+	TAILQ_INIT(&g_trace_head);
+
+	if (interval <= 0)
+		return -1;
+
+	g_interval = interval;
+	memset(&alrm_act, 0, sizeof(alrm_act));
+	alrm_act.sa_handler = alarm_handler;
+	sigaction(SIGALRM, &alrm_act, NULL);
+	alarm(g_interval);
+
+	get_localtime(&rectime, 0);
+
+	do {
+		/* read traces */
+		gettimeofday(&g_ts[curr], NULL);
+		virtiofs_read_trace(curr, trace_path);
+
+		/* write stats */
+		get_localtime(&rectime, 0);
+		virtiofs_trace_output(curr, &rectime);
+		if (count > 0)
+			count--;
+
+		if (count) {
+			curr ^= 1;
+			pause();
+		}
+	} while (count);
+	return 0;
+
+}
+
+static void vstat_usage(void)
+{
+	fprintf(stderr,
+		"\tvstat [-t] [-s] <trace_path> [interval [count]]\n");
+}
+
+/* parse the interval and count like iostat */
+static int get_interval_count(int *argcp, char **argv, int *iv, int *cnt)
+{
+	long interval = 1, count = 0;
+	int argc = *argcp;
+
+	/* Determin if the last argument is an virtio-fs-pci device id */
+	if (argc > 0 && !is_virtiofs_pci(argv[argc - 1])) {
+		char *end;
+
+		errno = 0;
+		interval = strtoul(argv[argc - 1], &end, 10);
+
+		if (*end == '\0' && errno == 0) {
+			if (interval == 0) {
+				fprintf(stderr, "interval cannot be zero\n");
+				vstat_usage();
+				return 1;
+			}
+			/* Ignore the last parameter */
+			argc--;
+
+			/* run until CTRL^c */
+			count = -1;
+		} else {
+			/*
+			 * If this is not a valid number, just plow on.  The
+			 * user will get a more informative error message later
+			 * on.
+			 */
+			interval = 0;
+		}
+	}
+
+	/*
+	 * If the last argument is also an integer, then we have both a count
+	 * and an interval.
+	 */
+	if (argc > 0 && !is_virtiofs_pci(argv[argc - 1])) {
+		char *end;
+
+		errno = 0;
+		count = interval;
+		interval = strtoul(argv[argc - 1], &end, 10);
+
+		if (*end == '\0' && errno == 0) {
+			if (interval == 0) {
+				fprintf(stderr, "interval cannot be zero\n");
+				vstat_usage();
+				return 1;
+			}
+			/* Ignore the last parameter */
+			argc--;
+		} else
+			interval = 0;
+	}
+
+	/* might be overflow.  someone is insane! */
+	*iv = (int)interval;
+	*cnt = (int)count;
+	*argcp = argc;
+
+	return 0;
+}
+
+/* Most code are copied from DPDK. */
+static uint64_t get_tsc_freq(void)
+{
+	struct timespec sleeptime = {.tv_nsec = 5E8 }; /* 1/2 second */
+
+	struct timespec t_start, t_end;
+	uint64_t tsc_hz;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &t_start) == 0) {
+		uint64_t ns, end, start = vtrace_rdtsc();
+		nanosleep(&sleeptime,NULL);
+		clock_gettime(CLOCK_MONOTONIC_RAW, &t_end);
+		end = vtrace_rdtsc();
+		ns = ((t_end.tv_sec - t_start.tv_sec) * NS_PER_SEC);
+		ns += (t_end.tv_nsec - t_start.tv_nsec);
+
+		double secs = (double)ns/NS_PER_SEC;
+		tsc_hz = (uint64_t)((end - start)/secs);
+		return tsc_hz;
+	} else {
+		uint64_t start = vtrace_rdtsc();
+		sleep(1);
+		return vtrace_rdtsc() - start;
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	char *trace_path = NULL;
+	bool summary = false;
+	int interval = 1, count = -1;
+	int c, ret;
+
+	while ((c = getopt(argc, argv, "sth")) != -1) {
+		switch (c) {
+		case 's':
+			summary = true;
+			break;
+		case 't':
+			g_print_timestamp = true;
+			break;
+		case 'h':
+			vstat_usage();
+			return 0;
+		default:
+			vstat_usage();
+			return 1;
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	ret = get_interval_count(&argc, argv, &interval, &count);
+	if (ret)
+		return ret;
+
+	if (argc) {
+		assert(argc == 1);
+		trace_path = argv[0];
+	}
+
+	/* Trace_path must be supplied currently, maybe refactored later. */
+	if (!trace_path || !is_virtiofs_pci(trace_path)) {
+		fprintf(stderr, "Must specify correct trace path.\n");
+		vstat_usage();
+		return -1;
+	}
+
+	tsc_resolution_hz = get_tsc_freq();
+
+	if (summary)
+		return do_stat_summary(trace_path);
+	else
+		return do_stat_loop(interval, count, trace_path);
+}
diff --git a/contrib/virtiofsd/vtrace.c b/contrib/virtiofsd/vtrace.c
new file mode 100644
index 0000000000..b94f9c68f5
--- /dev/null
+++ b/contrib/virtiofsd/vtrace.c
@@ -0,0 +1,95 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "fuse_log.h"
+#include "vtrace.h"
+
+struct virtiofs_trace *virtiofs_trace_init(const char *mountpoint)
+{
+	struct virtiofs_trace *trace = NULL;
+	char trace_path[PATH_MAX];
+	size_t trace_size = sizeof(struct virtiofs_trace);
+	int trace_fd;
+
+	if (!mountpoint) {
+		fuse_err("virtiofs_trace null mountpoint\n");
+		return NULL;
+	}
+
+	/* TODO: vm id and the tag may be more suitable */
+	snprintf(trace_path, sizeof(trace_path), "/vtrace%d", getpid());
+	trace_fd = shm_open(trace_path, O_CREAT | O_RDWR, 0644);
+	if (trace_fd == -1) {
+		fuse_err("shm_open: %s failed[%d]\n", trace_path, -errno);
+		return NULL;
+	}
+	if (ftruncate(trace_fd, trace_size) != 0) {
+		fuse_err("ftruncate: %s failed[%d]\n", trace_path, -errno);
+		goto fail;
+	}
+	trace = mmap(0, trace_size, PROT_READ | PROT_WRITE,
+		     MAP_SHARED | MAP_LOCKED, trace_fd, 0);
+	if (trace == MAP_FAILED) {
+		fuse_err("mmap: %s failed[%d]\n", trace_path, -errno);
+		goto fail;
+	}
+	memset(trace, 0, trace_size);
+	strncpy(trace->mountpoint, mountpoint, sizeof(trace->mountpoint));
+	trace->version = VIRTIOFS_TRACE_VERSION;
+	trace->trace_fd = trace_fd;
+	trace->magic = VIRTIOFS_TRACE_MAGIC;
+	shm_unlink(trace_path);
+	fuse_info("create virtiofs trace %s succeed\n", trace_path);
+	return trace;
+
+fail:
+	if (trace && (trace != MAP_FAILED))
+		munmap(trace, trace_size);
+	if (trace_fd != -1)
+		close(trace_fd);
+	shm_unlink(trace_path);
+	return NULL;
+}
+
+void virtiofs_trace_fin(struct virtiofs_trace *trace)
+{
+	if (!trace)
+		return;
+
+	close(trace->trace_fd);
+	munmap(trace, sizeof(struct virtiofs_trace));
+}
+
+void virtiofs_trace_account_op_begin(struct virtiofs_trace *trace, int op)
+{
+	struct fuse_op_stat *stat;
+
+	if (op >= VIRTIOFS_MAX_OP)
+		return;
+
+	stat = &trace->stats[op];
+	stat->inflight++;
+}
+
+void virtiofs_trace_account_op_end(struct virtiofs_trace *trace, int op,
+				   int64_t ticks)
+{
+	struct fuse_op_stat *stat;
+
+	if (op >= VIRTIOFS_MAX_OP)
+		return;
+
+	if (ticks < 0) /* tsc overflow */
+		ticks = 0;
+	stat = &trace->stats[op];
+	stat->inflight--;
+	stat->done++;
+	stat->elapsed_ticks += ticks;
+}
diff --git a/contrib/virtiofsd/vtrace.h b/contrib/virtiofsd/vtrace.h
new file mode 100644
index 0000000000..5ca1b966d6
--- /dev/null
+++ b/contrib/virtiofsd/vtrace.h
@@ -0,0 +1,53 @@
+#ifndef _VIRTIOFS_TRACE_H_
+#define _VIRTIOFS_TRACE_H_
+
+#include <linux/limits.h>
+#include <stdint.h>
+
+#define VIRTIOFS_TRACE_VERSION	0x1
+#define VIRTIOFS_TRACE_DIR	"/dev/shm"
+/* hexadecimal format of 'vtrace' */
+#define VIRTIOFS_TRACE_MAGIC	0x767472616365
+
+
+/* Reserve op num for new added fuse operation. */
+#define VIRTIOFS_MAX_OP		64
+
+struct fuse_op_stat {
+	uint64_t		inflight;
+	uint64_t		done;
+	uint64_t		elapsed_ticks;
+};
+
+struct virtiofs_trace {
+	uint64_t		magic;
+	uint32_t		version;
+	int			trace_fd;
+	struct fuse_op_stat	stats[VIRTIOFS_MAX_OP];
+	char			mountpoint[PATH_MAX];
+};
+
+struct virtiofs_trace *virtiofs_trace_init(const char *mountpoint);
+void virtiofs_trace_fin(struct virtiofs_trace *trace);
+void virtiofs_trace_account_op_begin(struct virtiofs_trace *trace, int op);
+void virtiofs_trace_account_op_end(struct virtiofs_trace *trace, int op,
+				   int64_t ticks);
+
+/* NOTE: only x86_64 implementation, copied from DPDK.*/
+static inline uint64_t vtrace_rdtsc(void)
+{
+	union {
+		uint64_t tsc_64;
+		struct {
+			uint32_t lo_32;
+			uint32_t hi_32;
+		};
+	} tsc;
+
+	asm volatile("rdtsc" :
+		     "=a" (tsc.lo_32),
+		     "=d" (tsc.hi_32));
+	return tsc.tsc_64;
+}
+
+#endif /* _VIRTIOFS_TRACE_H_ */
-- 
2.20.1.7.g153144c

