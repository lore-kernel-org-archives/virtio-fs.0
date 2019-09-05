From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  5 Sep 2019 09:29:46 +0100
Message-Id: <20190905082947.6633-2-stefanha@redhat.com>
In-Reply-To: <20190905082947.6633-1-stefanha@redhat.com>
References: <20190905082947.6633-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RESEND 1/2] virtiofsd: replace warn(3) and
	warnx(3) with fuse_warning()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Do not use warn(3) and warnx(3) since they print to stderr.  When
--syslog is used these messages must go to syslog(3) instead.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 36 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 0ef01b7e3f..7fab0bf6c1 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -628,12 +628,12 @@ retry:
 
 	res = readlinkat(lo->proc_self_fd, procname, path, PATH_MAX);
 	if (res < 0) {
-		warn("lo_parent_and_name: readlink failed");
+		fuse_warning("lo_parent_and_name: readlink failed: %m\n");
 		goto fail_noretry;
 	}
 
 	if (res >= PATH_MAX) {
-		warnx("lo_parent_and_name: readlink overflowed");
+		fuse_warning("lo_parent_and_name: readlink overflowed\n");
 		goto fail_noretry;
 	}
 	path[res] = '\0';
@@ -641,7 +641,7 @@ retry:
 	last = strrchr(path, '/');
 	if (last == NULL) {
 		/* Shouldn't happen */
-		warnx("lo_parent_and_name: INTERNAL ERROR: bad path read from proc");
+		fuse_warning("lo_parent_and_name: INTERNAL ERROR: bad path read from proc\n");
 		goto fail_noretry;
 	}
 	if (last == path) {
@@ -655,13 +655,13 @@ retry:
 		res = fstatat(AT_FDCWD, last == path ? "/" : path, &stat, 0);
 		if (res == -1) {
 			if (!retries)
-				warn("lo_parent_and_name: failed to stat parent");
+				fuse_warning("lo_parent_and_name: failed to stat parent: %m\n");
 			goto fail;
 		}
 		p = lo_find(lo, &stat);
 		if (p == NULL) {
 			if (!retries)
-				warnx("lo_parent_and_name: failed to find parent");
+				fuse_warning("lo_parent_and_name: failed to find parent\n");
 			goto fail;
 		}
 	}
@@ -669,12 +669,12 @@ retry:
 	res = fstatat(p->fd, last, &stat, AT_SYMLINK_NOFOLLOW);
 	if (res == -1) {
 		if (!retries)
-			warn("lo_parent_and_name: failed to stat last");
+			fuse_warning("lo_parent_and_name: failed to stat last: %m\n");
 		goto fail_unref;
 	}
 	if (stat.st_dev != inode->key.dev || stat.st_ino != inode->key.ino) {
 		if (!retries)
-			warnx("lo_parent_and_name: filed to match last");
+			fuse_warning("lo_parent_and_name: filed to match last\n");
 		goto fail_unref;
 	}
 	*parent = p;
@@ -895,9 +895,9 @@ static void get_shared(struct lo_data *lo, struct lo_inode *inode)
 	res = write(lo->ireg_sock, &msg, sizeof(msg));
 	if (res != sizeof(msg)) {
 		if (res == -1)
-			warn("write(lo->ireg_sock, {IREG_GET, ...})");
+			fuse_warning("write(lo->ireg_sock, {IREG_GET, ...}): %m\n");
 		else
-			warnx("short write to ireg_sock: %i", res);
+			fuse_warning("short write to ireg_sock: %i\n", res);
 		return;
 	}
 
@@ -919,9 +919,9 @@ static void put_shared(struct lo_data *lo, struct lo_inode *inode)
 	res = write(lo->ireg_sock, &msg, sizeof(msg));
 	if (res != sizeof(msg)) {
 		if (res == -1)
-			warn("write(lo->ireg_sock, {IREG_PUT, ...})");
+			fuse_warning("write(lo->ireg_sock, {IREG_PUT, ...}): %m\n");
 		else
-			warnx("short write to ireg_sock: %i", res);
+			fuse_warning("short write to ireg_sock: %i\n", res);
 		return;
 	}
 }
@@ -1428,7 +1428,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 		lo_map_remove(&lo->ino_map, inode->fuse_ino);
                 g_hash_table_remove(lo->inodes, &inode->key);
 		if (g_hash_table_size(inode->posix_locks)) {
-			warn("Hash table is not empty\n");
+			fuse_warning("Hash table is not empty\n");
 		}
 		g_hash_table_destroy(inode->posix_locks);
 		pthread_mutex_destroy(&inode->plock_mutex);
@@ -2640,19 +2640,19 @@ static void *ireg_do(void *data)
 		res = read(lo->ireg_sock, buf, sizeof(buf));
 		if (res <= 0) {
 			if (res == -1)
-				warn("read(lo->ireg_sock, ...)");
+				fuse_warning("read(lo->ireg_sock, ...): %m\n");
 			else
-				warnx("disconnected from ireg");
+				fuse_warning("disconnected from ireg\n");
 			return NULL;
 		}
 		if (res != sizeof(reply)) {
-			warnx("bad size message: %i", res);
+			fuse_warning("bad size message: %i\n", res);
 			continue;
 		}
 
 		memcpy(&reply, buf, sizeof(reply));
 		if (reply.op != SRV_VERSION) {
-			warn("bad reply to IREG_GET: %i", reply.op);
+			fuse_warning("bad reply to IREG_GET: %i\n", reply.op);
 			continue;
 		}
 
@@ -2685,7 +2685,7 @@ static void setup_shared_versions(struct lo_data *lo)
 	res = connect(sock, (const struct sockaddr *) &name,
 		      sizeof(struct sockaddr_un));
 	if (res == -1) {
-		warn("connect to ireg");
+		fuse_warning("connect to ireg: %m\n");
 		close(sock);
 		lo->ireg_sock = -1;
 		return;
@@ -2996,7 +2996,7 @@ int main(int argc, char *argv[])
 
 		ret = pthread_create(&ireg_thread, NULL, ireg_do, &lo);
 		if (ret) {
-			warnx("pthread_create: %s", strerror(ret));
+			fuse_warning("pthread_create: %s\n", strerror(ret));
 			ret = 1;
 			goto err_out4;
 		}
-- 
2.21.0

