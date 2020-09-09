From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:40:24 +0200
Message-Id: <20200909184028.262297-5-mreitz@redhat.com>
In-Reply-To: <20200909184028.262297-1-mreitz@redhat.com>
References: <20200909184028.262297-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/8] virtiofsd: Add fuse_reply_attr_with_flags()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

The plain fuse_reply_attr() function does not allow setting
fuse_attr.flags, so add this new function that does.

Make fuse_reply_attr() a wrapper around it.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 15 +++++++++++++++
 tools/virtiofsd/fuse_lowlevel.c | 14 ++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 9c06240f9e..1ff6ba1e4f 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1313,6 +1313,21 @@ int fuse_reply_create(fuse_req_t req, const struct fuse_entry_param *e,
 int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
                     double attr_timeout);
 
+/**
+ * Reply with attributes and set fuse_attr.flags
+ *
+ * Possible requests:
+ *   getattr, setattr
+ *
+ * @param req request handle
+ * @param attr the attributes
+ * @param attr_timeout validity timeout (in seconds) for the attributes
+ * @param attr_flags flags to put into fuse_attr.flags
+ * @return zero for success, -errno for failure to send reply
+ */
+int fuse_reply_attr_with_flags(fuse_req_t req, const struct stat *attr,
+                               double attr_timeout, uint32_t attr_flags);
+
 /**
  * Reply with the contents of a symbolic link
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 3ca49456c3..70efd3feaf 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -426,8 +426,8 @@ int fuse_reply_create(fuse_req_t req, const struct fuse_entry_param *e,
     return send_reply_ok(req, buf, entrysize + sizeof(struct fuse_open_out));
 }
 
-int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
-                    double attr_timeout)
+int fuse_reply_attr_with_flags(fuse_req_t req, const struct stat *attr,
+                               double attr_timeout, uint32_t attr_flags)
 {
     struct fuse_attr_out arg;
     size_t size = sizeof(arg);
@@ -437,9 +437,19 @@ int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
     arg.attr_valid_nsec = calc_timeout_nsec(attr_timeout);
     convert_stat(attr, &arg.attr);
 
+    if (req->se->conn.capable & FUSE_CAP_ATTR_FLAGS) {
+        arg.attr.flags = attr_flags;
+    }
+
     return send_reply_ok(req, &arg, size);
 }
 
+int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
+                    double attr_timeout)
+{
+    return fuse_reply_attr_with_flags(req, attr, attr_timeout, 0);
+}
+
 int fuse_reply_readlink(fuse_req_t req, const char *linkname)
 {
     return send_reply_ok(req, linkname, strlen(linkname));
-- 
2.26.2

