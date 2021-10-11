From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 11 Oct 2021 11:09:36 +0800
Message-Id: <20211011030938.109206-5-jefflexu@linux.alibaba.com>
In-Reply-To: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
References: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v6 4/6] virtiofsd: add 'dax=' option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

This option is used to specify the policy of constructing per-inode DAX
attribute when guest virtiofs is mounted with "-o dax=inode".

Currently there are two valid policies, "server" and "attr".

When "dax=server" is specified, virtiofsd could implement its own
heuristic strategy of constructing per-inode DAX attribute, e.g.
depending on the file size.

When "dax=attr" is specified, virtiofsd will construct per-inode DAX
attribute denpending on the persistent inode flags of host files. With
this option, admin could select those files that should be DAX enabled
and mark them with persistent inode flags, or users could mark files as
DAX enabled inside guest.

The default behaviour is "none", that is, DAX is always disabled for all
files when guest virtiofs is mounted with "-o dax=inode".

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/helper.c         |  7 +++++++
 tools/virtiofsd/passthrough_ll.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 28243b51b2..3c7fecda74 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -183,6 +183,13 @@ void fuse_cmdline_help(void)
            "                               to virtiofsd from guest applications.\n"
            "                               default: no_allow_direct_io\n"
            "    -o announce_submounts      Announce sub-mount points to the guest\n"
+           "    -o dax=<policy>            policies of constructing per-file DAX attribute.\n"
+           "                               could be one of \"server\", \"attr\"\n"
+           "                               - server: fuse daemon's own heuristic policy,\n"
+	   "                                 e.g. depending on file size\n"
+           "                               - attr: depending on persistent inode attribute\n"
+           "                                 of host files set by admin or guest\n"
+           "                               default: none\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 5969d67810..b4de86e317 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -137,6 +137,12 @@ enum {
     SANDBOX_CHROOT,
 };
 
+enum {
+    DAX_NONE,
+    DAX_SERVER,
+    DAX_ATTR,
+};
+
 typedef struct xattr_map_entry {
     char *key;
     char *prepend;
@@ -162,6 +168,8 @@ struct lo_data {
     int readdirplus_clear;
     int allow_direct_io;
     int announce_submounts;
+    int user_dax;
+    int dax;
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
@@ -206,6 +214,8 @@ static const struct fuse_opt lo_opts[] = {
     { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     { "killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 1 },
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
+    { "dax=server", offsetof(struct lo_data, user_dax), DAX_SERVER },
+    { "dax=attr", offsetof(struct lo_data, user_dax), DAX_ATTR },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -704,6 +714,12 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         conn->want &= ~FUSE_CAP_HANDLE_KILLPRIV_V2;
         lo->killpriv_v2 = 0;
     }
+
+    if ((conn->capable & FUSE_CAP_PERFILE_DAX)) {
+        lo->dax = lo->user_dax;
+    } else {
+        lo->dax = DAX_NONE;
+    }
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
-- 
2.27.0

