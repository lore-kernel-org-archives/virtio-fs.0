From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 18 May 2021 17:35:32 -0400
Message-Id: <20210518213538.693422-2-vgoyal@redhat.com>
In-Reply-To: <20210518213538.693422-1-vgoyal@redhat.com>
References: <20210518213538.693422-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/7] virtiofsd: Check for EINTR in preadv()
	and retry
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

We don't seem to check for EINTR and retry. There are other places
in code where we check for EINTR. So lets add a check.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 9efdbd8ffd..755d7fb25c 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -421,6 +421,9 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
 
         if (ret == -1) {
             ret = errno;
+            if (ret == EINTR) {
+                continue;
+            }
             fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m) len=%zd\n",
                      __func__, len);
             goto err;
-- 
2.25.4

