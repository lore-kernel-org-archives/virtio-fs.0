From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Wed, 14 Aug 2019 10:27:51 +0800
Message-Id: <20190814022751.116741-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: simplify setup_remount_slave
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>

We can just use MS_REC to propagate MS_SLAVE. This would also allow us
to close a race window between reading proc mountinfo and calling
mount(MS_SLAVE) for each entry, vs. others umounting the mount point in
parallel.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 53 ++----------------------------
 1 file changed, 3 insertions(+), 50 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 6662cc237a..d1ce369071 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2032,55 +2032,6 @@ static struct fuse_lowlevel_ops lo_oper = {
         .removemapping  = lo_removemapping,
 };
 
-/* Remount with MS_SLAVE so our mounts don't affect the outside world */
-static void setup_remount_slave(void)
-{
-	gchar *mountinfo = NULL;
-	gchar *line;
-	gchar *nextline;
-
-	if (!g_file_get_contents("/proc/self/mountinfo", &mountinfo, NULL, NULL)) {
-		fprintf(stderr, "unable to read /proc/self/mountinfo\n");
-		exit(EXIT_FAILURE);
-	}
-
-	for (line = mountinfo; line; line = nextline) {
-		gchar **fields = NULL;
-		char *eol;
-
-		nextline = NULL;
-
-		eol = strchr(line, '\n');
-		if (eol) {
-			*eol = '\0';
-			nextline = eol + 1;
-		}
-
-		/*
-		 * The line format is:
-		 * 442 441 253:4 / / rw,relatime shared:1 - xfs /dev/sda1 rw
-		 */
-		fields = g_strsplit(line, " ", -1);
-		if (!fields[0] || !fields[1] || !fields[2] || !fields[3] ||
-		    !fields[4] || !fields[5] || !fields[6]) {
-			goto next; /* parsing failed, skip line */
-		}
-
-		if (!strstr(fields[6], "shared")) {
-			goto next; /* not shared, skip line */
-		}
-
-		if (mount(NULL, fields[4], NULL, MS_SLAVE, NULL) < 0) {
-			err(1, "mount(%s, MS_SLAVE)", fields[4]);
-		}
-
-next:
-		g_strfreev(fields);
-	}
-
-	g_free(mountinfo);
-}
-
 /* This magic is based on lxc's lxc_pivot_root() */
 static void setup_pivot_root(const char *source)
 {
@@ -2135,7 +2086,9 @@ static void setup_mount_namespace(const char *source)
 		err(1, "unshare(CLONE_NEWNS)");
 	}
 
-	setup_remount_slave();
+	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
+		err(1, "mount(/, MS_REC|MS_PRIVATE)");
+	}
 
 	if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
 		err(1, "mount(%s, %s, MS_BIND)", source, source);
-- 
2.17.1

