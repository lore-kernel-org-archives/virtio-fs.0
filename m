From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:32 +0100
Message-Id: <20210414155137.46522-21-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 20/25] DAX/unmap virtiofsd: Route unmappable
	reads
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

When a read with unmappable buffers is found, map it to a slave
read command.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 5ed78bd8cf..887e79a126 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -459,6 +459,43 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
         in_sg_left -= ret;
         len -= ret;
     } while (in_sg_left);
+
+    if (bad_in_num) {
+        /* TODO: Rework to send in fewer messages */
+        VhostUserFSSlaveMsg *msg = g_malloc0(sizeof(VhostUserFSSlaveMsg) +
+                                             sizeof(VhostUserFSSlaveMsgEntry));
+        while (len && bad_in_num) {
+            msg->count = 1;
+            msg->entries[0].flags = VHOST_USER_FS_FLAG_MAP_R;
+            msg->entries[0].fd_offset = buf->buf[0].pos;
+            msg->entries[0].c_offset =
+                (uint64_t)(uintptr_t)in_sg_ptr[0].iov_base;
+            msg->entries[0].len = in_sg_ptr[0].iov_len;
+            if (len < msg->entries[0].len) {
+                msg->entries[0].len = len;
+             }
+            int64_t req_res = fuse_virtio_io(se, msg, buf->buf[0].fd);
+            fuse_log(FUSE_LOG_DEBUG,
+                     "%s: bad loop; len=%zd bad_in_num=%d fd_offset=%zd "
+                     "c_offset=%p req_res=%ld\n",
+                     __func__, len, bad_in_num, buf->buf[0].pos,
+                     in_sg_ptr[0].iov_base, req_res);
+            if (req_res > 0) {
+                len -= msg->entries[0].len;
+                buf->buf[0].pos += msg->entries[0].len;
+                in_sg_ptr++;
+                bad_in_num--;
+            } else if (req_res == 0) {
+                break;
+            } else {
+                ret = req_res;
+                free(in_sg_cpy);
+                g_free(msg);
+                goto err;
+            }
+        }
+        g_free(msg);
+    }
     free(in_sg_cpy);
 
     /* Need to fix out->len on EOF */
-- 
2.31.1

