From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:19 +0000
Message-Id: <20210209190224.62827-20-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 19/24] DAX/unmap virtiofsd: Route unmappable
	reads
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

When a read with unmappable buffers is found, map it to a slave
read command.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 8fa438525f..316d1f2463 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -397,6 +397,37 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
         in_sg_left -= ret;
         len -= ret;
     } while (in_sg_left);
+
+    if (bad_in_num) {
+        while (len && bad_in_num) {
+            VhostUserFSSlaveMsg msg = { 0 };
+            msg.flags[0] = VHOST_USER_FS_FLAG_MAP_R;
+            msg.fd_offset[0] = buf->buf[0].pos;
+            msg.c_offset[0] = (uint64_t)(uintptr_t)in_sg_ptr[0].iov_base;
+            msg.len[0] = in_sg_ptr[0].iov_len;
+            if (len < msg.len[0]) {
+                msg.len[0] = len;
+            }
+            int64_t req_res = fuse_virtio_io(se, &msg, buf->buf[0].fd);
+            fuse_log(FUSE_LOG_DEBUG,
+                     "%s: bad loop; len=%zd bad_in_num=%d fd_offset=%zd "
+                     "c_offset=%p req_res=%ld\n",
+                     __func__, len, bad_in_num, buf->buf[0].pos,
+                     in_sg_ptr[0].iov_base, req_res);
+            if (req_res > 0) {
+                len -= msg.len[0];
+                buf->buf[0].pos += msg.len[0];
+                in_sg_ptr++;
+                bad_in_num--;
+            } else if (req_res == 0) {
+                break;
+            } else {
+                ret = req_res;
+                free(in_sg_cpy);
+                goto err;
+            }
+        }
+    }
     free(in_sg_cpy);
 
     /* Need to fix out->len on EOF */
-- 
2.29.2

