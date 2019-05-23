From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Thu, 23 May 2019 10:06:34 +0800
Message-Id: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: handle NULL dir in lo_do_lookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Reported by fstests/generic/467.

open_by_handle_at() called from fuse inside guest can carry fuse mount
point to daemon but lo_do_lookup() doesn't know its inode info because
it's out of fuse's scope, thus lo_inode(req, parent) ends up with
returning a NULL dir and breaks virtiofsd immediately.

Note that it'd break applications that uses open_by_handle_at.

It seems to me that nothing could be done to support open_by_handle_at in
this case.

This simply tells fuse a ENOENT error so that open_by_handle_at() in guest
can get a ESTALE.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 9b7e515..b58708f 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -640,6 +640,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 	struct lo_data *lo = lo_data(req);
 	struct lo_inode *inode, *dir = lo_inode(req, parent);
 
+        /*
+         * name_to_handle_at() and open_by_handle_at() can reach here with fuse
+         * mount point in guest, but we don't have its inode info in the
+         * ino_map.
+         */
+        if (!dir)
+                return ENOENT;
+
 	memset(e, 0, sizeof(*e));
 	e->attr_timeout = lo->timeout;
 	e->entry_timeout = lo->timeout;
-- 
1.8.3.1

