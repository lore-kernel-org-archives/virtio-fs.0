From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 16 Sep 2020 12:17:35 -0400
Message-Id: <20200916161737.38028-5-vgoyal@redhat.com>
In-Reply-To: <20200916161737.38028-1-vgoyal@redhat.com>
References: <20200916161737.38028-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 4/6] fuse: Kill suid/sgid using ATTR_MODE if
	it is not truncate
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

If a truncate is happening with ->handle_killpriv_v2 is enabled, then
we don't have to send ATTR_MODE to kill suid/sgid as server will
kill it as part of the protocol.

But if this is non-truncate setattr then server will not kill suid/sgid.
So continue to send ATTR_MODE to kill suid/sgid for non-truncate setattr,
even if ->handle_killpriv_v2 is enabled.

This path is taken when client does a write on a file which has suid/
sgid is set. VFS will first kill suid/sgid and then proceed with WRITE.

One can argue that why not simply ignore ATTR_MODE because a WRITE
will follow and ->handle_killpriv_v2 will kill suid/sgid that time.
I feel this is a safer approach for following reasons.

- With ->writeback_cache enabled, WRITE will not go to server. I feel
  that for this reason ->writeback_cache mode is not fully compatible
  with ->handle_killpriv_v2. But if we kill suid/sgid now, this will
  solve this particular issue for ->writeback_cache mode too.

  Again, I will not solve all the issues around ->writeback_cache but
  makes things better.

- If we rely on WRITE killing suid/sgid, then after cache becomes
  out of sync w.r.t host. Client will still have suid/sgid set but
  subsequent WRITE will clear suid/sgid. Well WRITE will also invalidate
  client cache so further access to inode->i_mode should result in
  a ->getattr. Hmm..., for the case of ->writeback_cache, I am
  kind of inclined to send ATTR_MODE.

- We are sending setattr(ATTR_FORCE) anyway (even if we clear ATTR_MODE).
  So if we are not saving on setattr(), why not kill suid/sgid now.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dir.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecdb7895c156..4b0fe0828e36 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1655,6 +1655,21 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 		return -EACCES;
 
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) {
+		bool kill_sugid = true;
+		bool is_truncate = !!(attr->ia_valid & ATTR_SIZE);
+
+		if (fc->handle_killpriv ||
+		    (fc->handle_killpriv_v2 && is_truncate)) {
+			/*
+			 * If this is truncate and ->handle_killpriv_v2 is
+			 * enabled, we don't have to send ATTR_MODE to
+			 * kill suid/sgid as server will do it anyway as
+			 * part of truncate. But if this is not truncate
+			 * then kill suid/sgid by sending ATTR_MODE.
+			 */
+			kill_sugid = false;
+		}
+
 		attr->ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID |
 				    ATTR_MODE);
 
@@ -1664,7 +1679,7 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 		 *
 		 * This should be done on write(), truncate() and chown().
 		 */
-		if (!fc->handle_killpriv) {
+		if (kill_sugid) {
 			/*
 			 * ia_mode calculation may have used stale i_mode.
 			 * Refresh and recalculate.
-- 
2.25.4

