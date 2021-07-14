From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 14 Jul 2021 16:23:19 -0400
Message-Id: <20210714202321.59729-2-vgoyal@redhat.com>
In-Reply-To: <20210714202321.59729-1-vgoyal@redhat.com>
References: <20210714202321.59729-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 1/3] init: split get_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: viro@zeniv.linux.org.uk
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de

From: Christoph Hellwig <hch@lst.de>

Split get_fs_names into one function that splits up the command line
argument, and one that gets the list of all registered file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 74aede860de7..ec32de3ad52b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -338,30 +338,31 @@ __setup("rootflags=", root_data_setup);
 __setup("rootfstype=", fs_names_setup);
 __setup("rootdelay=", root_delay_setup);
 
-static void __init get_fs_names(char *page)
+static void __init split_fs_names(char *page, char *names)
 {
-	char *s = page;
-
-	if (root_fs_names) {
-		strcpy(page, root_fs_names);
-		while (*s++) {
-			if (s[-1] == ',')
-				s[-1] = '\0';
-		}
-	} else {
-		int len = get_filesystem_list(page);
-		char *p, *next;
+	strcpy(page, root_fs_names);
+	while (*page++) {
+		if (page[-1] == ',')
+			page[-1] = '\0';
+	}
+	*page = '\0';
+}
 
-		page[len] = '\0';
-		for (p = page-1; p; p = next) {
-			next = strchr(++p, '\n');
-			if (*p++ != '\t')
-				continue;
-			while ((*s++ = *p++) != '\n')
-				;
-			s[-1] = '\0';
-		}
+static void __init get_all_fs_names(char *page)
+{
+	int len = get_filesystem_list(page);
+	char *s = page, *p, *next;
+
+	page[len] = '\0';
+	for (p = page - 1; p; p = next) {
+		next = strchr(++p, '\n');
+		if (*p++ != '\t')
+			continue;
+		while ((*s++ = *p++) != '\n')
+			;
+		s[-1] = '\0';
 	}
+
 	*s = '\0';
 }
 
@@ -411,7 +412,10 @@ void __init mount_block_root(char *name, int flags)
 
 	scnprintf(b, BDEVNAME_SIZE, "unknown-block(%u,%u)",
 		  MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
-	get_fs_names(fs_names);
+	if (root_fs_names)
+		split_fs_names(fs_names, root_fs_names);
+	else
+		get_all_fs_names(fs_names);
 retry:
 	for (p = fs_names; *p; p += strlen(p)+1) {
 		int err = do_mount_root(name, p, flags, root_mount_data);
-- 
2.31.1

