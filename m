From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:06 +0100
Message-Id: <20190731161006.9447-6-stefanha@redhat.com>
In-Reply-To: <20190731161006.9447-1-stefanha@redhat.com>
References: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/5] virtiofsd: introduce inode refcount to
	prevent use-after-free
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

If thread A is using an inode it must not be deleted by thread B when
processing a FUSE_FORGET request.

The FUSE protocol itself already has a counter called nlookup that is
used in FUSE_FORGET messages.  We cannot trust this counter since the
untrusted client can manipulate it via FUSE_FORGET messages.

Introduce a new refcount to keep inodes alive for the required lifespan.
lo_inode_put() must be called to release a reference.  FUSE's nlookup
counter holds exactly one reference so that the inode stays alive as
long as the client still wants to remember it.

Note that the lo_inode->is_symlink field is moved to avoid creating a
hole in the struct due to struct field alignment.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 212 ++++++++++++++++++++++++-----
 1 file changed, 178 insertions(+), 34 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 125e9d9f96..0c90e352d2 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -95,7 +95,12 @@ struct lo_key {
 
 struct lo_inode {
 	int fd;
-	bool is_symlink;
+
+	/* Atomic reference count for this object.  The nlookup field holds a
+	 * reference and release it when nlookup reaches 0.
+	 */
+	gint refcount;
+
 	struct lo_key key;
 
 	/* This counter keeps the inode alive during the FUSE session.
@@ -115,6 +120,8 @@ struct lo_inode {
 	fuse_ino_t fuse_ino;
 	pthread_mutex_t plock_mutex;
 	GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
+
+	bool is_symlink;
 };
 
 struct lo_cred {
@@ -198,6 +205,7 @@ static const struct fuse_opt lo_opts[] = {
 	FUSE_OPT_END
 };
 static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n);
+static void put_shared(struct lo_data *lo, struct lo_inode *inode);
 
 static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st);
 
@@ -359,6 +367,24 @@ static ssize_t lo_add_inode_mapping(fuse_req_t req, struct lo_inode *inode)
 	return elem - lo_data(req)->ino_map.elems;
 }
 
+static void lo_inode_put(struct lo_data *lo, struct lo_inode **inodep)
+{
+	struct lo_inode *inode = *inodep;
+
+	if (!inode) {
+		return;
+	}
+
+	*inodep = NULL;
+
+	if (g_atomic_int_dec_and_test(&inode->refcount)) {
+		close(inode->fd);
+		put_shared(lo, inode);
+		free(inode);
+	}
+}
+
+/* Caller must release refcount using lo_inode_put() */
 static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 {
 	struct lo_data *lo = lo_data(req);
@@ -366,6 +392,9 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 
 	pthread_mutex_lock(&lo->mutex);
 	elem = lo_map_get(&lo->ino_map, ino);
+	if (elem) {
+		g_atomic_int_inc(&elem->inode->refcount);
+	}
 	pthread_mutex_unlock(&lo->mutex);
 
 	if (!elem)
@@ -374,10 +403,22 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 	return elem->inode;
 }
 
+/* TODO Remove this helper and force callers to hold an inode refcount until
+ * they are done with the fd.  This will be done in a later patch to make
+ * review easier.
+ */
 static int lo_fd(fuse_req_t req, fuse_ino_t ino)
 {
 	struct lo_inode *inode = lo_inode(req, ino);
-	return inode ? inode->fd : -1;
+	int fd;
+
+	if (!inode) {
+		return -1;
+	}
+
+	fd = inode->fd;
+	lo_inode_put(lo_data(req), &inode);
+	return fd;
 }
 
 static bool lo_debug(fuse_req_t req)
@@ -463,6 +504,9 @@ static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
 	fuse_reply_attr(req, &buf, lo->timeout);
 }
 
+/* Increments parent->nlookup and caller must release refcount using
+ * lo_inode_put(&parent).
+ */
 static int lo_parent_and_name(struct lo_data *lo, struct lo_inode *inode,
 			      char path[PATH_MAX], struct lo_inode **parent)
 {
@@ -498,6 +542,7 @@ retry:
 		p = &lo->root;
 		pthread_mutex_lock(&lo->mutex);
 		p->nlookup++;
+		g_atomic_int_inc(&p->refcount);
 		pthread_mutex_unlock(&lo->mutex);
 	} else {
 		*last = '\0';
@@ -570,6 +615,7 @@ fallback:
 	if (res != -1) {
 		res = utimensat(parent->fd, path, tv, AT_SYMLINK_NOFOLLOW);
 		unref_inode(lo, parent, 1);
+		lo_inode_put(lo, &parent);
 	}
 
 	return res;
@@ -683,11 +729,13 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
 			goto out_err;
 	}
 	update_version(lo, inode);
+	lo_inode_put(lo, &inode);
 
 	return lo_getattr(req, ino, fi);
 
 out_err:
 	saverr = errno;
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 }
 
@@ -704,6 +752,7 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st)
 	if (p) {
 		assert(p->nlookup > 0);
 		p->nlookup++;
+		g_atomic_int_inc(&p->refcount);
 	}
 	pthread_mutex_unlock(&lo->mutex);
 
@@ -771,6 +820,9 @@ static void put_shared(struct lo_data *lo, struct lo_inode *inode)
 	}
 }
 
+/* Increments nlookup and caller must release refcount using
+ * lo_inode_put(&parent).
+ */
 static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 			 struct fuse_entry_param *e)
 {
@@ -778,7 +830,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 	int res;
 	int saverr;
 	struct lo_data *lo = lo_data(req);
-	struct lo_inode *inode, *dir = lo_inode(req, parent);
+	struct lo_inode *inode = NULL;
+	struct lo_inode *dir = lo_inode(req, parent);
 
 	if (!dir) {
 		return EBADF;
@@ -811,6 +864,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 			goto out_err;
 
 		inode->is_symlink = S_ISLNK(e->attr.st_mode);
+
+		/* One for the caller and one for nlookup (released in unref_inode()) */
+		g_atomic_int_set(&inode->refcount, 2);
+
 		inode->nlookup = 1;
 		inode->fd = newfd;
 		newfd = -1;
@@ -839,6 +896,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 	e->ino = inode->fuse_ino;
 	e->version_offset = inode->version_offset;
+	lo_inode_put(lo, &inode);
+	lo_inode_put(lo, &dir);
 
 	if (lo_debug(req))
 		fuse_debug("  %lli/%s -> %lli (version_table[%lli]=%lli)\n",
@@ -853,6 +912,8 @@ out_err:
 	saverr = errno;
 	if (newfd != -1)
 		close(newfd);
+	lo_inode_put(lo, &inode);
+	lo_inode_put(lo, &dir);
 	return saverr;
 }
 
@@ -963,7 +1024,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
 	if (res == -1)
 		goto out;
 
-	update_version(lo, lo_inode(req, parent));
+	update_version(lo, dir);
 
 	saverr = lo_do_lookup(req, parent, name, &e);
 	if (saverr)
@@ -975,9 +1036,11 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
 			   (unsigned long long) e.ino);
 
 	fuse_reply_entry(req, &e, lo->shared);
+	lo_inode_put(lo, &dir);
 	return;
 
 out:
+	lo_inode_put(lo, &dir);
 	if (newfd != -1)
 		close(newfd);
 	fuse_reply_err(req, saverr);
@@ -1029,6 +1092,7 @@ fallback:
 	if (res != -1) {
 		res = linkat(parent->fd, path, dfd, name, 0);
 		unref_inode(lo, parent, 1);
+		lo_inode_put(lo, &parent);
 	}
 
 	return res;
@@ -1039,6 +1103,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 {
 	int res;
 	struct lo_data *lo = lo_data(req);
+	struct lo_inode *parent_inode;
 	struct lo_inode *inode;
 	struct fuse_entry_param e;
 	int saverr;
@@ -1048,17 +1113,18 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 		return;
 	}
 
+	parent_inode = lo_inode(req, parent);
 	inode = lo_inode(req, ino);
-	if (!inode) {
-		fuse_reply_err(req, EBADF);
-		return;
+	if (!parent_inode || !inode) {
+		errno = EBADF;
+		goto out_err;
 	}
 
 	memset(&e, 0, sizeof(struct fuse_entry_param));
 	e.attr_timeout = lo->timeout;
 	e.entry_timeout = lo->timeout;
 
-	res = linkat_empty_nofollow(lo, inode, lo_fd(req, parent), name);
+	res = linkat_empty_nofollow(lo, inode, parent_inode->fd, name);
 	if (res == -1)
 		goto out_err;
 
@@ -1071,7 +1137,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 	pthread_mutex_unlock(&lo->mutex);
 	e.ino = inode->fuse_ino;
 	update_version(lo, inode);
-	update_version(lo, lo_inode(req, parent));
+	update_version(lo, parent_inode);
 
 	if (lo_debug(req))
 		fuse_debug("  %lli/%s -> %lli\n",
@@ -1079,13 +1145,18 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 			   (unsigned long long) e.ino);
 
 	fuse_reply_entry(req, &e, lo->shared);
+	lo_inode_put(lo, &parent_inode);
+	lo_inode_put(lo, &inode);
 	return;
 
 out_err:
 	saverr = errno;
+	lo_inode_put(lo, &parent_inode);
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 }
 
+/* Increments nlookup and caller must release refcount using lo_inode_put() */
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
 				    const char *name)
 {
@@ -1121,11 +1192,20 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
 	if (res == -1) {
 		fuse_reply_err(req, errno);
 	} else {
+		struct lo_inode *parent_inode;
+
 		update_version(lo, inode);
-		update_version(lo, lo_inode(req, parent));
+
+		parent_inode = lo_inode(req, parent);
+		if (parent_inode) {
+			update_version(lo, parent_inode);
+			lo_inode_put(lo, &parent_inode);
+		}
+
 		fuse_reply_err(req, 0);
 	}
 	unref_inode(lo, inode, 1);
+	lo_inode_put(lo, &inode);
 }
 
 static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
@@ -1133,8 +1213,10 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 		      unsigned int flags)
 {
 	int res;
-	struct lo_inode *oldinode;
-	struct lo_inode *newinode;
+	struct lo_inode *parent_inode;
+	struct lo_inode *newparent_inode;
+	struct lo_inode *oldinode = NULL;
+	struct lo_inode *newinode = NULL;
 	struct lo_data *lo = lo_data(req);
 
 	if (!is_safe_path_component(name) ||
@@ -1143,6 +1225,13 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 		return;
 	}
 
+	parent_inode = lo_inode(req, parent);
+	newparent_inode = lo_inode(req, newparent);
+	if (!parent_inode || !newparent_inode) {
+		fuse_reply_err(req, EBADF);
+		goto out;
+	}
+
 	oldinode = lookup_name(req, parent, name);
 	newinode = lookup_name(req, newparent, newname);
 	if (!oldinode) {
@@ -1155,8 +1244,8 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 #ifndef SYS_renameat2
 		fuse_reply_err(req, EINVAL);
 #else
-		res = syscall(SYS_renameat2, lo_fd(req, parent), name,
-			      lo_fd(req, newparent), newname, flags);
+		res = syscall(SYS_renameat2, parent_inode->fd, name,
+			      newparent_inode->fd, newname, flags);
 		if (res == -1 && errno == ENOSYS)
 			fuse_reply_err(req, EINVAL);
 		else
@@ -1165,21 +1254,24 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 		goto out;
 	}
 
-	res = renameat(lo_fd(req, parent), name,
-			lo_fd(req, newparent), newname);
+	res = renameat(parent_inode->fd, name, newparent_inode->fd, newname);
 	if (res == -1) {
 		fuse_reply_err(req, errno);
 	} else {
 		update_version(lo, oldinode);
 		if (newinode)
 			update_version(lo, newinode);
-		update_version(lo, lo_inode(req, parent));
-		update_version(lo, lo_inode(req, newparent));
+		update_version(lo, parent_inode);
+		update_version(lo, newparent_inode);
 		fuse_reply_err(req, 0);
 	}
 out:
 	unref_inode(lo, oldinode, 1);
 	unref_inode(lo, newinode, 1);
+	lo_inode_put(lo, &oldinode);
+	lo_inode_put(lo, &newinode);
+	lo_inode_put(lo, &parent_inode);
+	lo_inode_put(lo, &newparent_inode);
 }
 
 static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
@@ -1203,11 +1295,20 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
 	if (res == -1) {
 		fuse_reply_err(req, errno);
 	} else {
+		struct lo_inode *parent_inode;
+
 		update_version(lo, inode);
-		update_version(lo, lo_inode(req, parent));
+
+		parent_inode = lo_inode(req, parent);
+		if (parent_inode) {
+			update_version(lo, parent_inode);
+			lo_inode_put(lo, &parent_inode);
+		}
+
 		fuse_reply_err(req, 0);
 	}
 	unref_inode(lo, inode, 1);
+	lo_inode_put(lo, &inode);
 }
 
 static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
@@ -1227,9 +1328,9 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 		g_hash_table_destroy(inode->posix_locks);
 		pthread_mutex_destroy(&inode->plock_mutex);
 		pthread_mutex_unlock(&lo->mutex);
-		close(inode->fd);
-		put_shared(lo, inode);
-		free(inode);
+
+		/* Drop our refcount from lo_do_lookup() */
+		lo_inode_put(lo, &inode);
 	} else {
 		pthread_mutex_unlock(&lo->mutex);
 	}
@@ -1244,6 +1345,7 @@ static int unref_all_inodes_cb(gpointer key, gpointer value,
 	inode->nlookup = 0;
 	lo_map_remove(&lo->ino_map, inode->fuse_ino);
 	close(inode->fd);
+	lo_inode_put(lo, &inode); /* Drop our refcount from lo_do_lookup() */
 
 	return TRUE;
 }
@@ -1273,6 +1375,7 @@ static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
 	}
 
 	unref_inode(lo, inode, nlookup);
+	lo_inode_put(lo, &inode);
 }
 
 static void lo_forget(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
@@ -1492,6 +1595,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
     err = 0;
 error:
     lo_dirp_put(&d);
+    lo_inode_put(lo, &dinode);
 
     // If there's an error, we can only signal it if we haven't stored
     // any entries yet - otherwise we'd end up with wrong lookup
@@ -1546,6 +1650,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 {
 	int fd;
 	struct lo_data *lo = lo_data(req);
+	struct lo_inode *parent_inode;
 	struct fuse_entry_param e;
 	int err;
 	struct lo_cred old = {};
@@ -1559,11 +1664,17 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 		return;
 	}
 
+	parent_inode = lo_inode(req, parent);
+	if (!parent_inode) {
+		fuse_reply_err(req, EBADF);
+		return;
+	}
+
 	err = lo_change_cred(req, &old);
 	if (err)
 		goto out;
 
-	fd = openat(lo_fd(req, parent), name,
+	fd = openat(parent_inode->fd, name,
 		    (fi->flags | O_CREAT) & ~O_NOFOLLOW, mode);
 	err = fd == -1 ? errno : 0;
 	lo_restore_cred(&old);
@@ -1571,15 +1682,15 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 	if (!err) {
 		ssize_t fh;
 
-		update_version(lo, lo_inode(req, parent));
+		update_version(lo, parent_inode);
 
 		pthread_mutex_lock(&lo->mutex);
 		fh = lo_add_fd_mapping(req, fd);
 		pthread_mutex_unlock(&lo->mutex);
 		if (fh == -1) {
 			close(fd);
-			fuse_reply_err(req, ENOMEM);
-			return;
+			err = ENOMEM;
+			goto out;
 		}
 
 		fi->fh = fh;
@@ -1591,6 +1702,8 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 		fi->keep_cache = 1;
 
 out:
+	lo_inode_put(lo, &parent_inode);
+
 	if (err)
 		fuse_reply_err(req, err);
 	else
@@ -1660,15 +1773,17 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
 	plock = lookup_create_plock_ctx(lo, inode, fi->lock_owner, lock->l_pid,
 			&ret);
 	if (!plock) {
-		pthread_mutex_unlock(&inode->plock_mutex);
-		fuse_reply_err(req, ret);
-		return;
+		saverr = ret;
+		goto out;
 	}
 
 	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
 	if (ret == -1)
 		saverr = errno;
+
+out:
 	pthread_mutex_unlock(&inode->plock_mutex);
+	lo_inode_put(lo, &inode);
 
 	if (saverr)
 		fuse_reply_err(req, saverr);
@@ -1707,9 +1822,8 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
 			&ret);
 
 	if (!plock) {
-		pthread_mutex_unlock(&inode->plock_mutex);
-		fuse_reply_err(req, ret);
-		return;
+		saverr = ret;
+		goto out;
 	}
 
 	/* TODO: Is it alright to modify flock? */
@@ -1718,7 +1832,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
 	if (ret == -1) {
 		saverr = errno;
 	}
+
+out:
 	pthread_mutex_unlock(&inode->plock_mutex);
+	lo_inode_put(lo, &inode);
+
 	fuse_reply_err(req, saverr);
 }
 
@@ -1849,6 +1967,8 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 
 	res = close(dup(lo_fi_fd(req, fi)));
 	fuse_reply_err(req, res == -1 ? errno : 0);
+
+	lo_inode_put(lo_data(req), &inode);
 }
 
 static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
@@ -1921,7 +2041,14 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 	if(res < 0) {
 		fuse_reply_err(req, -res);
 	} else {
-		update_version(lo, lo_inode(req, ino));
+		struct lo_inode *inode;
+
+		inode = lo_inode(req, ino);
+		if (inode) {
+			update_version(lo, inode);
+			lo_inode_put(lo, &inode);
+		}
+
 		fuse_reply_write(req, (size_t) res);
 	}
 }
@@ -1948,7 +2075,13 @@ static void lo_fallocate(fuse_req_t req, fuse_ino_t ino, int mode,
         if (err < 0) {
                 err = errno;
         } else {
-		update_version(lo, lo_inode(req, ino));
+		struct lo_inode *inode;
+
+		inode = lo_inode(req, ino);
+		if (inode) {
+			update_version(lo, inode);
+			lo_inode_put(lo, &inode);
+		}
 	}
 
 	fuse_reply_err(req, err);
@@ -2029,11 +2162,14 @@ out_free:
 	if (fd >= 0) {
 		close(fd);
 	}
+
+	lo_inode_put(lo, &inode);
 	return;
 
 out_err:
 	saverr = errno;
 out:
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 	goto out_free;
 }
@@ -2101,11 +2237,14 @@ out_free:
 	if (fd >= 0) {
 		close(fd);
 	}
+
+	lo_inode_put(lo, &inode);
 	return;
 
 out_err:
 	saverr = errno;
 out:
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 	goto out_free;
 }
@@ -2157,6 +2296,8 @@ out:
 	if (fd >= 0) {
 		close(fd);
 	}
+
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 }
 
@@ -2206,6 +2347,8 @@ out:
 	if (fd >= 0) {
 		close(fd);
 	}
+
+	lo_inode_put(lo, &inode);
 	fuse_reply_err(req, saverr);
 }
 
@@ -2598,6 +2741,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
 	root->key.ino = stat.st_ino;
 	root->key.dev = stat.st_dev;
 	root->nlookup = 2;
+	g_atomic_int_set(&root->refcount, 2);
 }
 
 static void setup_proc_self_fd(struct lo_data *lo)
-- 
2.21.0

