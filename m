From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue,  2 Nov 2021 13:26:02 +0800
Message-Id: <20211102052604.59462-6-jefflexu@linux.alibaba.com>
In-Reply-To: <20211102052604.59462-1-jefflexu@linux.alibaba.com>
References: <20211102052604.59462-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v7 5/7] fuse: negotiate per inode DAX in
	FUSE_INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com

Among the FUSE_INIT phase, client shall advertise per inode DAX if it's
mounted with "dax=inode". Then server is aware that client is in per
inode DAX mode, and will construct per-inode DAX attribute accordingly.

Server shall also advertise support for per inode DAX. If server doesn't
support it while client is mounted with "dax=inode", client will
silently fallback to "dax=never" since "dax=inode" is advisory only.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/dax.c    |  2 +-
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/inode.c  | 16 +++++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 8a328fb20dcb..c8ee601b94b8 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1350,7 +1350,7 @@ static bool fuse_should_enable_dax(struct inode *inode, unsigned int flags)
 		return true;
 
 	/* dax_mode is FUSE_DAX_INODE or FUSE_DAX_NONE */
-	return flags & FUSE_ATTR_DAX;
+	return fc->inode_dax && (flags & FUSE_ATTR_DAX);
 }
 
 void fuse_dax_inode_init(struct inode *inode, unsigned int flags)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 055b39430540..58e54b5a4d65 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -777,6 +777,9 @@ struct fuse_conn {
 	/* Propagate syncfs() to server */
 	unsigned int sync_fs:1;
 
+	/* Does the filesystem support per inode DAX? */
+	unsigned int inode_dax:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index acba14002d04..0512d8cb36c3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1136,11 +1136,19 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 					min_t(unsigned int, fc->max_pages_limit,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
-			if (IS_ENABLED(CONFIG_FUSE_DAX) &&
-			    arg->flags & FUSE_MAP_ALIGNMENT &&
+#ifdef CONFIG_FUSE_DAX
+			if ((arg->flags & FUSE_HAS_INODE_DAX) &&
+			    fuse_is_inode_dax_mode(fc->dax_mode)) {
+				fc->inode_dax = 1;
+			}
+			if (arg->flags & FUSE_MAP_ALIGNMENT &&
 			    !fuse_dax_check_alignment(fc, arg->map_alignment)) {
-				ok = false;
+				if (fuse_is_inode_dax_mode(fc->dax_mode))
+					fc->inode_dax = 0;
+				else
+					ok = false;
 			}
+#endif
 			if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
 				fc->handle_killpriv_v2 = 1;
 				fm->sb->s_flags |= SB_NOSEC;
@@ -1194,6 +1202,8 @@ void fuse_send_init(struct fuse_mount *fm)
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
 		ia->in.flags |= FUSE_MAP_ALIGNMENT;
+	if (fuse_is_inode_dax_mode(fm->fc->dax_mode))
+		ia->in.flags |= FUSE_HAS_INODE_DAX;
 #endif
 	if (fm->fc->auto_submounts)
 		ia->in.flags |= FUSE_SUBMOUNTS;
-- 
2.27.0

