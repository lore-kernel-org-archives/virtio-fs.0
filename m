From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:22 +0000
Message-Id: <20210209190224.62827-23-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 22/24] vhost-user-fs: Extend VhostUserFSSlaveMsg
	to pass additional info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Extend VhostUserFSSlaveMsg so that slave can ask it to drop CAP_FSETID
before doing I/O on fd.

In some cases, virtiofsd takes the onus of clearing setuid bit on a file
when WRITE happens. Generally virtiofsd does the WRITE to fd (from guest
memory which is mapped in virtiofsd as well), but if this memory is
unmappable in virtiofsd (like cache window), then virtiofsd asks qemu
to do the I/O instead.

To retain the capability to drop suid bit on write, qemu needs to
drop the CAP_FSETID as well before write to fd. Extend VhostUserFSSlaveMsg
so that virtiofsd can specify in message if CAP_FSETID needs to be
dropped.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 hw/virtio/vhost-user-fs.c                 | 5 +++++
 include/hw/virtio/vhost-user-fs.h         | 6 ++++++
 subprojects/libvhost-user/libvhost-user.h | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 357bc1d04e..61e891c82d 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -176,6 +176,11 @@ uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
         return (uint64_t)-1;
     }
 
+    if (sm->gen_flags & VHOST_USER_FS_GENFLAG_DROP_FSETID) {
+        error_report("Dropping CAP_FSETID is not supported");
+        return (uint64_t)-ENOTSUP;
+    }
+
     for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES && !res; i++) {
         if (sm->len[i] == 0) {
             continue;
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index ffd3165c29..e646eb004a 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -30,7 +30,13 @@ OBJECT_DECLARE_SIMPLE_TYPE(VHostUserFS, VHOST_USER_FS)
 #define VHOST_USER_FS_FLAG_MAP_R (1ull << 0)
 #define VHOST_USER_FS_FLAG_MAP_W (1ull << 1)
 
+/* Generic flags for the overall message and not individual ranges */
+/* Drop capability CAP_FSETID during the operation */
+#define VHOST_USER_FS_GENFLAG_DROP_FSETID (1ull << 0)
+
 typedef struct {
+    /* Generic flags for the overall message */
+    uint64_t gen_flags;
     /* Offsets within the file being mapped */
     uint64_t fd_offset[VHOST_USER_FS_SLAVE_ENTRIES];
     /* Offsets within the cache */
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index a398148ed9..f7de8f6387 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -132,7 +132,13 @@ typedef enum VhostUserSlaveRequest {
 #define VHOST_USER_FS_FLAG_MAP_R (1ull << 0)
 #define VHOST_USER_FS_FLAG_MAP_W (1ull << 1)
 
+/* Generic flags for the overall message and not individual ranges */
+/* Drop capability CAP_FSETID during the operation */
+#define VHOST_USER_FS_GENFLAG_DROP_FSETID (1ull << 0)
+
 typedef struct {
+    /* Generic flags for the overall message */
+    uint64_t gen_flags;
     /* Offsets within the file being mapped */
     uint64_t fd_offset[VHOST_USER_FS_SLAVE_ENTRIES];
     /* Offsets within the cache */
-- 
2.29.2

