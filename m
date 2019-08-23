From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Aug 2019 16:02:44 +0100
Message-Id: <20190823150245.17246-2-dgilbert@redhat.com>
In-Reply-To: <20190823150245.17246-1-dgilbert@redhat.com>
References: <20190823150245.17246-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: Rename unref_inode to indicate
	lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Rename unref_inode to unref_inode_lolocked to indicate
that it takes & releases the lo->mutex;  the next patch
will create a version that doesn't.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 1175349037..20b6c7ae91 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -206,7 +206,7 @@ static const struct fuse_opt lo_opts[] = {
 	  offsetof(struct lo_data, readdirplus_clear), 1 },
 	FUSE_OPT_END
 };
-static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n);
+static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uint64_t n);
 static void put_shared(struct lo_data *lo, struct lo_inode *inode);
 
 static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st);
@@ -683,7 +683,7 @@ retry:
 	return 0;
 
 fail_unref:
-	unref_inode(lo, p, 1);
+	unref_inode_lolocked(lo, p, 1);
 fail:
 	if (retries) {
 		retries--;
@@ -720,7 +720,7 @@ fallback:
 	res = lo_parent_and_name(lo, inode, path, &parent);
 	if (res != -1) {
 		res = utimensat(parent->fd, path, tv, AT_SYMLINK_NOFOLLOW);
-		unref_inode(lo, parent, 1);
+		unref_inode_lolocked(lo, parent, 1);
 		lo_inode_put(lo, &parent);
 	}
 
@@ -975,7 +975,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 		inode->is_symlink = S_ISLNK(e->attr.st_mode);
 
-		/* One for the caller and one for nlookup (released in unref_inode()) */
+		/* One for the caller and one for nlookup (released in unref_inode_lolocked()) */
 		g_atomic_int_set(&inode->refcount, 2);
 
 		inode->nlookup = 1;
@@ -999,7 +999,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 		      AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
 	if (res == -1) {
 		saverr = errno;
-		unref_inode(lo, inode, 1);
+		unref_inode_lolocked(lo, inode, 1);
 		errno = saverr;
 		goto out_err;
 	}
@@ -1197,7 +1197,7 @@ fallback:
 	res = lo_parent_and_name(lo, inode, path, &parent);
 	if (res != -1) {
 		res = linkat(parent->fd, path, dfd, name, 0);
-		unref_inode(lo, parent, 1);
+		unref_inode_lolocked(lo, parent, 1);
 		lo_inode_put(lo, &parent);
 	}
 
@@ -1309,7 +1309,7 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
 
 		fuse_reply_err(req, 0);
 	}
-	unref_inode(lo, inode, 1);
+	unref_inode_lolocked(lo, inode, 1);
 	lo_inode_put(lo, &inode);
 }
 
@@ -1371,8 +1371,8 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 		fuse_reply_err(req, 0);
 	}
 out:
-	unref_inode(lo, oldinode, 1);
-	unref_inode(lo, newinode, 1);
+	unref_inode_lolocked(lo, oldinode, 1);
+	unref_inode_lolocked(lo, newinode, 1);
 	lo_inode_put(lo, &oldinode);
 	lo_inode_put(lo, &newinode);
 	lo_inode_put(lo, &parent_inode);
@@ -1412,11 +1412,11 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
 
 		fuse_reply_err(req, 0);
 	}
-	unref_inode(lo, inode, 1);
+	unref_inode_lolocked(lo, inode, 1);
 	lo_inode_put(lo, &inode);
 }
 
-static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
+static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 {
 	if (!inode)
 		return;
@@ -1455,7 +1455,7 @@ static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
 		   (unsigned long long) inode->nlookup,
 		   (unsigned long long) nlookup);
 
-	unref_inode(lo, inode, nlookup);
+	unref_inode_lolocked(lo, inode, nlookup);
 	lo_inode_put(lo, &inode);
 }
 
@@ -2577,7 +2577,7 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
                 }
 
                 struct lo_inode *inode = value;
-                unref_inode(lo, inode, inode->nlookup);
+                unref_inode_lolocked(lo, inode, inode->nlookup);
         }
 }
 
-- 
2.21.0

