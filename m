Return-Path: <jefflexu@linux.alibaba.com>
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 16 May 2022 11:39:06 +0800
Message-Id: <20220516033906.58771-4-jefflexu@linux.alibaba.com>
In-Reply-To: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
References: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v8 3/3] virtiofsd: add 'dax=' option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com
Cc: joseph.qi@linux.alibaba.com, hsiangkao@linux.alibaba.com, haibinzhang@tencent.com, liudonghua@uniontech.com

Add "dax=[none|always|inode|filesize]" option to specify the policy of
constructing per-inode DAX attribute when guest virtiofs is mounted in
per inode DAX mode.

The default behavior is "none". That is, virtiofsd will always clear
per-inode DAX attribute and thus DAX is always disabled for all files.
It will default to "none" mode when "dax=" option is not specified.

Similarly, when it works in "always" mode, DAX is always enabled for all
files when guest virtiofs is mounted in per inode DAX mode.

Then it comes two policies regarding to per inode attributes.

When "dax=inode" is specified, virtiofsd will construct per-inode DAX
attribute denpending on the persistent inode flags, i.e.
FS_XFLAG_DAX/FS_DAX_FL of host files. With this option, admin could
select those files that should be DAX enabled and mark them with
persistent inode flags, or users could mark files as DAX enabled inside
guest.

When "dax=filesize" is specified, virtiofsd will construct per-inode DAX
attribute depending on the file size. In this case DAX will be disabled
for those with file size smaller than a specific threshold. Currently
the threshold is hardcoded as 32KB, which is calculated from a hint that
guest virtiofs manages DAX mapping at 2MB granularity. We can introduce
a new option, e.g. "--dax-filesize-threshold" to make the threshold
configurable if it's needed later.

Besides, negotiate per inode DAX feature in FUSE_INIT phase. It is worth
mentioning that, if no dax policy (other than "none" mode) is specified,
virtiofsd won't advertise support for per indoe DAX feature.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/fuse_common.h    |  5 +++++
 tools/virtiofsd/fuse_lowlevel.c  |  6 ++++++
 tools/virtiofsd/helper.c         |  6 ++++++
 tools/virtiofsd/passthrough_ll.c | 20 ++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index df6202d174..760e30cdfa 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -377,6 +377,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_SETXATTR_EXT (1 << 29)
 
+/**
+ * Indicates support for per inode DAX.
+ */
+#define FUSE_CAP_INODE_DAX (1ULL << 33)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 178c5dc968..3d448ba351 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2093,6 +2093,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (flags & FUSE_SETXATTR_EXT) {
         se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
     }
+    if (flags & FUSE_HAS_INODE_DAX) {
+        se->conn.capable |= FUSE_CAP_INODE_DAX;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2208,6 +2211,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (se->conn.want & FUSE_CAP_POSIX_ACL) {
         outarg.flags |= FUSE_POSIX_ACL;
     }
+    if (se->conn.want & FUSE_CAP_INODE_DAX) {
+        outarg.flags2 |= FUSE_HAS_INODE_DAX >> 32;
+    }
     outarg.max_readahead = se->conn.max_readahead;
     outarg.max_write = se->conn.max_write;
     if (se->conn.max_background >= (1 << 16)) {
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index a8295d975a..81f0adea71 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -187,6 +187,12 @@ void fuse_cmdline_help(void)
            "                               default: no_allow_direct_io\n"
            "    -o announce_submounts      Announce sub-mount points to the guest\n"
            "    -o posix_acl/no_posix_acl  Enable/Disable posix_acl. (default: disabled)\n"
+           "    -o dax=<policy>            policies of constructing per-inode DAX attribute when\n"
+           "                               guest advertises per-inode DAX mode.\n"
+           "                               - none: default, disable DAX for all files\n"
+           "                               - always: enable DAX for all files\n"
+           "                               - inode: depending on persistent inode flags\n"
+           "                               - filesize: depending on file size\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 00ec21bfc9..e6ebde138e 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -185,6 +185,7 @@ struct lo_data {
     int readdirplus_clear;
     int allow_direct_io;
     int announce_submounts;
+    int user_dax;
     int dax;
     bool use_statx;
     struct lo_inode root;
@@ -235,6 +236,10 @@ static const struct fuse_opt lo_opts[] = {
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
     { "posix_acl", offsetof(struct lo_data, user_posix_acl), 1 },
     { "no_posix_acl", offsetof(struct lo_data, user_posix_acl), 0 },
+    { "dax=none", offsetof(struct lo_data, user_dax), INODE_DAX_NONE },
+    { "dax=always", offsetof(struct lo_data, user_dax), INODE_DAX_ALWAYS },
+    { "dax=inode", offsetof(struct lo_data, user_dax), INODE_DAX_INODE },
+    { "dax=filesize", offsetof(struct lo_data, user_dax), INODE_DAX_FILESIZE },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -759,6 +764,21 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
         conn->want &= ~FUSE_CAP_POSIX_ACL;
     }
+
+    if (conn->capable & FUSE_CAP_INODE_DAX) {
+        lo->dax = lo->user_dax;
+    } else {
+        /* Set INODE_DAX_NONE explicitly to override the old value */
+        lo->dax = INODE_DAX_NONE;
+    }
+
+    /*
+     * If no dax policy is specified, then virtiofsd won't advertise support
+     * for per indoe DAX.
+     */
+    if (lo->dax != INODE_DAX_NONE) {
+        conn->want |= FUSE_CAP_INODE_DAX;
+    }
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
-- 
2.27.0

