From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Nov 2021 18:17:28 -0500
Message-Id: <20211110231728.50385-7-vgoyal@redhat.com>
In-Reply-To: <20211110231728.50385-1-vgoyal@redhat.com>
References: <20211110231728.50385-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 6/6] virtiofsd: Add an option to
	enable/disable security label
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, dgilbert@redhat.com
Cc: casey@schaufler-ca.com, omosnace@redhat.com, vgoyal@redhat.com

Provide an option "-o security_label/no_security_label" to enable/disable
security label functionality. By default these are turned off.

If enabled, server will indicate to client that it is capable of handling
one security label during file creation. Typically this is expected to
be a SELinux label. File server will set this label on the file. It will
try to set it atomically wherever possible. But its not possible in
all the cases.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 docs/tools/virtiofsd.rst         |  7 +++++++
 tools/virtiofsd/helper.c         |  1 +
 tools/virtiofsd/passthrough_ll.c | 15 +++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index cc31402830..54699b2013 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -104,6 +104,13 @@ Options
   * posix_acl|no_posix_acl -
     Enable/disable posix acl support.  Posix ACLs are disabled by default.
 
+  * security_label|no_security_label -
+    Enable/disable security label support. Security labels are disabled by
+    default. This will allow client to send a MAC label of file during
+    file creation. Typically this is expected to be SELinux security
+    label. Server will try to set that label on newly created file
+    atomically wherever possible.
+
 .. option:: --socket-path=PATH
 
   Listen on vhost-user UNIX domain socket at PATH.
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index a8295d975a..e226fc590f 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -187,6 +187,7 @@ void fuse_cmdline_help(void)
            "                               default: no_allow_direct_io\n"
            "    -o announce_submounts      Announce sub-mount points to the guest\n"
            "    -o posix_acl/no_posix_acl  Enable/Disable posix_acl. (default: disabled)\n"
+           "    -o security_label/no_security_label  Enable/Disable security label. (default: disabled)\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 4505c0c363..4334885619 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -180,6 +180,7 @@ struct lo_data {
     int user_posix_acl, posix_acl;
     /* Keeps track if /proc/<pid>/attr/fscreate should be used or not */
     bool use_fscreate;
+    int user_security_label;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -214,6 +215,8 @@ static const struct fuse_opt lo_opts[] = {
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
     { "posix_acl", offsetof(struct lo_data, user_posix_acl), 1 },
     { "no_posix_acl", offsetof(struct lo_data, user_posix_acl), 0 },
+    { "security_label", offsetof(struct lo_data, user_security_label), 1 },
+    { "no_security_label", offsetof(struct lo_data, user_security_label), 0 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -770,6 +773,17 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
         conn->want &= ~FUSE_CAP_POSIX_ACL;
     }
+
+    if (lo->user_security_label == 1) {
+        if (!(conn->capable & FUSE_CAP_SECURITY_CTX)) {
+            fuse_log(FUSE_LOG_ERR, "lo_init: Can not enable security label."
+                     " kernel does not support FUSE_SECURITY_CTX capability.\n");
+        }
+        conn->want |= FUSE_CAP_SECURITY_CTX;
+    } else {
+        fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling security label\n");
+        conn->want &= ~FUSE_CAP_SECURITY_CTX;
+    }
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
@@ -4254,6 +4268,7 @@ int main(int argc, char *argv[])
         .proc_self_task = -1,
         .user_killpriv_v2 = -1,
         .user_posix_acl = -1,
+        .user_security_label = -1,
     };
     struct lo_map_elem *root_elem;
     struct lo_map_elem *reserve_elem;
-- 
2.31.1

