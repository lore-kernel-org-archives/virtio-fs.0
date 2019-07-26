From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:11:00 +0100
Message-Id: <20190726091103.23503-3-stefanha@redhat.com>
In-Reply-To: <20190726091103.23503-1-stefanha@redhat.com>
References: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] virtiofsd: prevent lo_lookup() NULL pointer
	dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

Most lo_do_lookup() have already checked that the parent inode exists.
lo_lookup() hasn't and can therefore hit a NULL pointer dereference when
lo_inode(req, parent) returns NULL.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 9ae1381618..277a17fc03 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -766,6 +766,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 	struct lo_data *lo = lo_data(req);
 	struct lo_inode *inode, *dir = lo_inode(req, parent);
 
+	if (!dir) {
+		return EBADF;
+	}
+
 	memset(e, 0, sizeof(*e));
 	e->attr_timeout = lo->timeout;
 	e->entry_timeout = lo->timeout;
-- 
2.21.0

