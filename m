From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Thu,  6 Jun 2019 15:16:15 +0800
Message-Id: <1559805375-44679-1-git-send-email-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: fix lo_do_lookup panic
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>

It needs to check for invalid parent dir.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 8a3adc9..f544387 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -640,6 +640,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 	struct lo_data *lo = lo_data(req);
 	struct lo_inode *inode, *dir = lo_inode(req, parent);
 
+	if (dir == NULL)
+		return EBADF;
+
 	memset(e, 0, sizeof(*e));
 	e->attr_timeout = lo->timeout;
 	e->entry_timeout = lo->timeout;
-- 
1.8.3.1

