From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue,  2 Nov 2021 13:56:43 +0800
Message-Id: <20211102055646.103337-4-jefflexu@linux.alibaba.com>
In-Reply-To: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v7 3/6] virtiofsd: add 'dax=' option
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

Currently there are two valid policies, "inode" and "filesize".

When "dax=inode" is specified, virtiofsd will construct per-inode DAX
attribute denpending on the persistent inode flags, i.e.
FS_XFLAG_DAX/FS_DAX_FL of host files. With this option, admin could
select those files that should be DAX enabled and mark them with
persistent inode flags, or users could mark files as DAX enabled inside
guest.

When "dax=filesize" is specified, virtiofsd will construct per-inode DAX
attribute depending on the file size. In this case DAX will be disabled
for those with file size smaller than 32KB.

The default behavior is "none". That is, virtiofsd will always clear
per-inode DAX attribute and thus DAX is always disabled for all files
when guest virtiofs is mounted with "-o dax=inode".

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/helper.c         |  5 +++++
 tools/virtiofsd/passthrough_ll.c | 12 ++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index a8295d975a..c613bebf2c 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -187,6 +187,11 @@ void fuse_cmdline_help(void)
            "                               default: no_allow_direct_io\n"
            "    -o announce_submounts      Announce sub-mount points to the guest\n"
            "    -o posix_acl/no_posix_acl  Enable/Disable posix_acl. (default: disabled)\n"
+           "    -o dax=<policy>            policies of constructing per-inode DAX attribute.\n"
+           "                               could be one of \"inode\", \"filesize\"\n"
+           "                               - inode: depending on persistent inode flags\n"
+           "                               - filesize: depending on file size\n"
+           "                               default: none\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 2768497be4..13a632bddd 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -138,6 +138,12 @@ enum {
     SANDBOX_CHROOT,
 };
 
+enum {
+    INODE_DAX_NONE,
+    INODE_DAX_INODE,
+    INODE_DAX_FILESIZE,
+};
+
 typedef struct xattr_map_entry {
     char *key;
     char *prepend;
@@ -163,6 +169,8 @@ struct lo_data {
     int readdirplus_clear;
     int allow_direct_io;
     int announce_submounts;
+    int user_dax;
+    int dax;
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
@@ -212,6 +220,8 @@ static const struct fuse_opt lo_opts[] = {
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
     { "posix_acl", offsetof(struct lo_data, user_posix_acl), 1 },
     { "no_posix_acl", offsetof(struct lo_data, user_posix_acl), 0 },
+    { "dax=inode", offsetof(struct lo_data, user_dax), INODE_DAX_INODE },
+    { "dax=filesize", offsetof(struct lo_data, user_dax), INODE_DAX_FILESIZE },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -736,6 +746,8 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
         conn->want &= ~FUSE_CAP_POSIX_ACL;
     }
+
+    lo->dax = lo->user_dax;
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
-- 
2.27.0

