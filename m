From: Eric Ren <renzhen@linux.alibaba.com>
Date: Tue, 11 Jun 2019 21:44:40 +0800
Message-Id: <bff1bd0e0d829acacba4a10e072e4a8ccdf972b4.1560260621.git.renzhen@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: fix incorrect error handling in
	lo_do_lookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 574e209d95..78716c8aca 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -670,7 +670,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 		close(newfd);
 		newfd = -1;
 	} else {
-		saverr = ENOMEM;
 		inode = calloc(1, sizeof(struct lo_inode));
 		if (!inode)
 			goto out_err;
@@ -691,7 +690,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 	res = fstatat(inode->fd, "", &e->attr,
 		      AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
 	if (res == -1) {
+		saverr = errno;
 		unref_inode(lo, inode, 1);
+		errno = saverr;
 		goto out_err;
 	}
 
-- 
2.17.2 (Apple Git-113)

