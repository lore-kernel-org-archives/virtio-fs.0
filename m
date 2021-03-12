From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 15:10:03 +0100
Message-Id: <20210312141003.819108-4-groug@kaod.org>
In-Reply-To: <20210312141003.819108-1-groug@kaod.org>
References: <20210312141003.819108-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: Don't allow empty filenames
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

POSIX.1-2017 clearly stipulates that empty filenames aren't
allowed ([1] and [2]). Since virtiofsd is supposed to mirror
the host file system hierarchy and the host can be assumed to
be linux, we don't really expect clients to pass requests with
an empty path in it. If they do so anyway, this would eventually
cause an error when trying to create/lookup the actual inode
on the underlying POSIX filesystem. But this could still confuse
some code that wouldn't be ready to cope with this.

Filter out empty names coming from the client at the top level,
so that the rest doesn't have to care about it. This is done
everywhere we already call is_safe_path_component(), but
in a separate helper since the usual error for empty path
names is ENOENT instead of EINVAL.

[1] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_170
[2] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 35 ++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index f63016d35626..bff9dc2cd26d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -237,6 +237,11 @@ static bool is_safe_path_component(const char *path)
     return !is_dot_or_dotdot(path);
 }
 
+static bool is_empty(const char *name)
+{
+    return name[0] == '\0';
+}
+
 static struct lo_data *lo_data(fuse_req_t req)
 {
     return (struct lo_data *)fuse_req_userdata(req);
@@ -1083,6 +1088,11 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
     fuse_log(FUSE_LOG_DEBUG, "lo_lookup(parent=%" PRIu64 ", name=%s)\n", parent,
              name);
 
+    if (is_empty(name)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     /*
      * Don't use is_safe_path_component(), allow "." and ".." for NFS export
      * support.
@@ -1174,6 +1184,11 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
     struct fuse_entry_param e;
     struct lo_cred old = {};
 
+    if (is_empty(name)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     if (!is_safe_path_component(name)) {
         fuse_reply_err(req, EINVAL);
         return;
@@ -1246,6 +1261,11 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     char procname[64];
     int saverr;
 
+    if (is_empty(name)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     if (!is_safe_path_component(name)) {
         fuse_reply_err(req, EINVAL);
         return;
@@ -1323,6 +1343,11 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
     struct lo_inode *inode;
     struct lo_data *lo = lo_data(req);
 
+    if (is_empty(name)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     if (!is_safe_path_component(name)) {
         fuse_reply_err(req, EINVAL);
         return;
@@ -1352,6 +1377,11 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
     struct lo_inode *newinode = NULL;
     struct lo_data *lo = lo_data(req);
 
+    if (is_empty(name) || is_empty(newname)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     if (!is_safe_path_component(name) || !is_safe_path_component(newname)) {
         fuse_reply_err(req, EINVAL);
         return;
@@ -1405,6 +1435,11 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
     struct lo_inode *inode;
     struct lo_data *lo = lo_data(req);
 
+    if (is_empty(name)) {
+        fuse_reply_err(req, ENOENT);
+        return;
+    }
+
     if (!is_safe_path_component(name)) {
         fuse_reply_err(req, EINVAL);
         return;
-- 
2.26.2

