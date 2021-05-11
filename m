From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 11 May 2021 17:37:35 -0400
Message-Id: <20210511213736.281016-7-vgoyal@redhat.com>
In-Reply-To: <20210511213736.281016-1-vgoyal@redhat.com>
References: <20210511213736.281016-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 6/7] virtiofsd: Check EOF before short read
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

In virtio_send_data_iov() we are checking first for short read and then
EOF condition. Change the order. Basically check for error and EOF first
and last remaining piece is short ready which will lead to retry
automatically at the end of while loop.

Just that it is little simpler to read to the code. There is no need
to call "continue" and also one less call of "len-=ret".

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 434fe401cf..aa53808ef9 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -410,25 +410,24 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                      __func__, len);
             goto err;
         }
-        fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n", __func__,
-                 ret, len);
-        if (ret < len && ret) {
-            fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
-            /* Skip over this much next time around */
-            iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, ret);
-            buf->buf[0].pos += ret;
-            len -= ret;
 
-            /* Lets do another read */
-            continue;
-        }
         if (!ret) {
             /* EOF case? */
             fuse_log(FUSE_LOG_DEBUG, "%s: !ret len remaining=%zd\n", __func__,
                      len);
             break;
         }
+        fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n", __func__,
+                 ret, len);
+
         len -= ret;
+        /* Short read. Retry reading remaining bytes */
+        if (len) {
+            fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
+            /* Skip over this much next time around */
+            iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, ret);
+            buf->buf[0].pos += ret;
+        }
     } while (len);
 
     /* Need to fix out->len on EOF */
-- 
2.25.4

