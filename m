From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:58 +0100
Message-Id: <20210428110100.27757-25-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 24/26] vhost-user-fs: Extend
	VhostUserFSSlaveMsg to pass additional info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

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
index ee600ce968..036ca17767 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -244,6 +244,11 @@ uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, int message_size,
         return (uint64_t)-1;
     }
 
+    if (sm->flags & VHOST_USER_FS_GENFLAG_DROP_FSETID) {
+        error_report("Dropping CAP_FSETID is not supported");
+        return (uint64_t)-ENOTSUP;
+    }
+
     for (i = 0; i < sm->count && !res; i++) {
         VhostUserFSSlaveMsgEntry *e = &sm->entries[i];
         if (e->len == 0) {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 2931164e23..bcd797c0cc 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -30,6 +30,10 @@ OBJECT_DECLARE_SIMPLE_TYPE(VHostUserFS, VHOST_USER_FS)
 #define VHOST_USER_FS_FLAG_MAP_R (1u << 0)
 #define VHOST_USER_FS_FLAG_MAP_W (1u << 1)
 
+/* Generic flags for the overall message and not individual ranges */
+/* Drop capability CAP_FSETID during the operation */
+#define VHOST_USER_FS_GENFLAG_DROP_FSETID (1u << 0)
+
 typedef struct {
     /* Offsets within the file being mapped */
     uint64_t fd_offset;
@@ -42,6 +46,8 @@ typedef struct {
 } VhostUserFSSlaveMsgEntry;
 
 typedef struct {
+    /* Generic flags for the overall message */
+    uint32_t flags;
     /* Number of entries */
     uint16_t count;
     /* Spare */
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 42b0833c4b..4dba4321f4 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -132,6 +132,10 @@ typedef enum VhostUserSlaveRequest {
 #define VHOST_USER_FS_FLAG_MAP_R (1u << 0)
 #define VHOST_USER_FS_FLAG_MAP_W (1u << 1)
 
+/* Generic flags for the overall message and not individual ranges */
+/* Drop capability CAP_FSETID during the operation */
+#define VHOST_USER_FS_GENFLAG_DROP_FSETID (1u << 0)
+
 typedef struct {
     /* Offsets within the file being mapped */
     uint64_t fd_offset;
@@ -144,6 +148,8 @@ typedef struct {
 } VhostUserFSSlaveMsgEntry;
 
 typedef struct {
+    /* Generic flags for the overall message */
+    uint32_t flags;
     /* Number of entries */
     uint16_t count;
     /* Spare */
-- 
2.31.1

