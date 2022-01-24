From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 24 Jan 2022 16:24:48 -0500
Message-Id: <20220124212455.83968-3-vgoyal@redhat.com>
In-Reply-To: <20220124212455.83968-1-vgoyal@redhat.com>
References: <20220124212455.83968-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 2/9] virtiofsd: Fix breakage due to
	fuse_init_in size change
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

Kernel version 5.17 has increased the size of "struct fuse_init_in" struct.
Previously this struct was 16 bytes and now it has been extended to
64 bytes in size.

Once qemu headers are updated to latest, it will expect to receive 64 byte
size struct (for protocol version major 7 and minor > 6). But if guest is
booting older kernel (older than 5.17), then it still sends older
fuse_init_in of size 16 bytes. And do_init() fails. It is expecting
64 byte struct. And this results in mount of virtiofs failing.

Fix this by parsing 16 bytes only for now. Separate patches will be
posted which will parse rest of the bytes and enable new functionality.
Right now we don't support any of the new functionality, so we don't
lose anything by not parsing bytes beyond 16.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index e4679c73ab..ce29a70253 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1880,6 +1880,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
                     struct fuse_mbuf_iter *iter)
 {
     size_t compat_size = offsetof(struct fuse_init_in, max_readahead);
+    size_t compat2_size = offsetof(struct fuse_init_in, flags) + sizeof(uint32_t);
     struct fuse_init_in *arg;
     struct fuse_init_out outarg;
     struct fuse_session *se = req->se;
@@ -1897,7 +1898,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
 
     /* ...and now consume the new fields. */
     if (arg->major == 7 && arg->minor >= 6) {
-        if (!fuse_mbuf_iter_advance(iter, sizeof(*arg) - compat_size)) {
+        if (!fuse_mbuf_iter_advance(iter, compat2_size - compat_size)) {
             fuse_reply_err(req, EINVAL);
             return;
         }
-- 
2.31.1

