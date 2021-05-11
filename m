From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 11 May 2021 17:37:31 -0400
Message-Id: <20210511213736.281016-3-vgoyal@redhat.com>
In-Reply-To: <20210511213736.281016-1-vgoyal@redhat.com>
References: <20210511213736.281016-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/7] virtiofsd: Get rid of unreachable code in
	read
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

pvreadv() can return following.

- error
- 0 in case of EOF
- short read

We seem to handle all the cases already. We are retrying read in case
of short read. So another check for short read seems like dead code.
Get rid of it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 32914f7e95..5dcd08fccb 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -446,11 +446,6 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                      in_sg_left);
             break;
         }
-        if (ret != len) {
-            fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
-            ret = EIO;
-            goto err;
-        }
         in_sg_left -= ret;
         len -= ret;
     } while (in_sg_left);
-- 
2.25.4

