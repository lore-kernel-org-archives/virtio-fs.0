From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  9 Oct 2020 14:15:10 -0400
Message-Id: <20201009181512.65496-5-vgoyal@redhat.com>
In-Reply-To: <20201009181512.65496-1-vgoyal@redhat.com>
References: <20201009181512.65496-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 4/6] fuse: Don't send ATTR_MODE to kill
	suid/sgid for handle_killpriv_v2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

If client does a write() on a suid/sgid file, VFS will first call
fuse_setattr() with ATTR_KILL_S[UG]ID set. This requires sending
setattr to file server with ATTR_MODE set to kill suid/sgid. But
to do that client needs to know latest mode otherwise it is racy.

To reduce the race window, current code first call fuse_do_getattr()
to get latest ->i_mode and then resets suid/sgid bits and sends rest
to server with setattr(ATTR_MODE). This does not reduce the race
completely but narrows race window significantly.

With fc->handle_killpriv_v2 enabled, it should be possible to remove
this race completely. Do not kill suid/sgid with ATTR_MODE at all. It
will be killed by server when WRITE request is sent to server soon.
This is similar to fc->handle_killpriv logic. V2 is just more refined
version of protocol. Hence this patch does not send ATTR_MODE to
kill suid/sgid if fc->handle_killpriv_v2 is enabled.

This creates an issue if fc->writeback_cache is enabled. In that
case WRITE can be cached in guest and server might not see WRITE
request and hence will not kill suid/sgid. Miklos suggested that
in such cases, we should fallback to a writethrough WRITE instead
and that will generate WRITE request and kill suid/sgid. This patch
implements that too.

But this relies on client seeing the suid/sgid set. If another client
sets suid/sgid and this client does not see it immideately, then we
will not fallback to writethrough WRITE. So this is one limitation
with both fc->handle_killpriv_v2 and fc->writeback_cache enabled.
Both the options are not fully compatible. But might be good enough
for many use cases.

Note: I am not checking whether security.capability is set or not when
      falling back to writethrough path. if suid/sgid is not set and only
      security.capability is set, that will be taken care of by
      file_remove_privs() call in ->writeback_cache path.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dir.c  | 2 +-
 fs/fuse/file.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecdb7895c156..510178594a8d 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1664,7 +1664,7 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 		 *
 		 * This should be done on write(), truncate() and chown().
 		 */
-		if (!fc->handle_killpriv) {
+		if (!fc->handle_killpriv && !fc->handle_killpriv_v2) {
 			/*
 			 * ia_mode calculation may have used stale i_mode.
 			 * Refresh and recalculate.
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e40428f3d0f1..ee1bb9bfdcd5 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1260,17 +1260,24 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t written_buffered = 0;
 	struct inode *inode = mapping->host;
 	ssize_t err;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 	loff_t endbyte = 0;
 
-	if (get_fuse_conn(inode)->writeback_cache) {
+	if (fc->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err = fuse_update_attributes(mapping->host, file);
 		if (err)
 			return err;
 
+		if (fc->handle_killpriv_v2 &&
+		    should_remove_suid(file_dentry(file))) {
+			goto writethrough;
+		}
+
 		return generic_file_write_iter(iocb, from);
 	}
 
+writethrough:
 	inode_lock(inode);
 
 	/* We can write back this queue in page reclaim */
-- 
2.25.4

