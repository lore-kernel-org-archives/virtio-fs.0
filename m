From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 12 Aug 2021 13:46:17 +0800
Message-Id: <20210812054618.26057-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 1/2] fuse: disable atomic_o_trunc if no_open is
	enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

From: Liu Bo <bo.liu@linux.alibaba.com>

When 'no_open' is used by virtiofsd, guest kernel won't send OPEN request
any more.  However, with atomic_o_trunc, SETATTR request is also omitted in
OPEN(O_TRUNC) so that the backend file is not truncated.  With a following
GETATTR, inode size on guest side is updated to be same with that on host
side, the end result is that O_TRUNC semantic is broken.

This disables atomic_o_trunc as well if with no_open.

Reviewed-by: Peng Tao <tao.peng@linux.alibaba.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b494ff08f08c..1231128f8dd6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -151,10 +151,16 @@ struct fuse_file *fuse_file_open(struct fuse_mount *fm, u64 nodeid,
 			fuse_file_free(ff);
 			return ERR_PTR(err);
 		} else {
-			if (isdir)
+			if (isdir) {
 				fc->no_opendir = 1;
-			else
+			} else {
 				fc->no_open = 1;
+				/*
+				 * In case of no_open, disable atomic_o_trunc as
+				 * well.
+				 */
+				fc->atomic_o_trunc = 0;
+			}
 		}
 	}
 
-- 
2.27.0

