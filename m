From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Wed,  4 Aug 2021 15:06:49 +0800
Message-Id: <20210804070653.118123-5-jefflexu@linux.alibaba.com>
In-Reply-To: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
References: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v3 4/8] fuse: negotiate if server/client
	supports per-file DAX
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

Among the FUSE_INIT phase, server/client shall negotiate if supporting
per-file DAX.

Requirements for server:
- capable of handling SETFLAGS/FSSETXATTR ioctl and storing
  FS_DAX_FL/FS_XFLAG_DAX persistently.
- set FUSE_ATTR_DAX if the file capable of per-file DAX when replying
  FUSE_LOOKUP request accordingly.

Requirements for client:
- capable of handling per-file DAX when receiving FUSE_ATTR_DAX.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/inode.c  | 12 +++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a23dd8d0c181..0b21e76a379a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -770,6 +770,9 @@ struct fuse_conn {
 	/* Propagate syncfs() to server */
 	unsigned int sync_fs:1;
 
+	/* Does the filesystem support per-file DAX? */
+	unsigned int perfile_dax:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 0bc0d8af81e1..d59aea41d70d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1087,10 +1087,12 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 					min_t(unsigned int, fc->max_pages_limit,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
-			if (IS_ENABLED(CONFIG_FUSE_DAX) &&
-			    arg->flags & FUSE_MAP_ALIGNMENT &&
-			    !fuse_dax_check_alignment(fc, arg->map_alignment)) {
-				ok = false;
+			if (IS_ENABLED(CONFIG_FUSE_DAX)) {
+				if (arg->flags & FUSE_MAP_ALIGNMENT &&
+				    !fuse_dax_check_alignment(fc, arg->map_alignment))
+					ok = false;
+				if (arg->flags & FUSE_PERFILE_DAX)
+					fc->perfile_dax = 1;
 			}
 			if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
 				fc->handle_killpriv_v2 = 1;
@@ -1144,7 +1146,7 @@ void fuse_send_init(struct fuse_mount *fm)
 		FUSE_HANDLE_KILLPRIV_V2 | FUSE_SETXATTR_EXT;
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
-		ia->in.flags |= FUSE_MAP_ALIGNMENT;
+		ia->in.flags |= FUSE_MAP_ALIGNMENT | FUSE_PERFILE_DAX;
 #endif
 	if (fm->fc->auto_submounts)
 		ia->in.flags |= FUSE_SUBMOUNTS;
-- 
2.27.0

