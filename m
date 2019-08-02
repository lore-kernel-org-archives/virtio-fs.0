From: piaojun <piaojun@huawei.com>
Message-ID: <5D43F688.8000607@huawei.com>
Date: Fri, 2 Aug 2019 16:38:32 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v2] virtiofsd: fix compile error if
	'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: eblake@redhat.com

Use F_GETLK for fcntl when F_OFD_GETLK not defined, such as kernel 3.10.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
v2:
- Use F_OFD_SETLK to replace F_OFD_GETLK in #ifdef.

---
 contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index a81c01d..c69f2f3 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1780,7 +1780,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
 		goto out;
 	}

+#ifdef F_OFD_GETLK
 	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
+#else
+	ret = fcntl(plock->fd, F_GETLK, lock);
+#endif
 	if (ret == -1)
 		saverr = errno;

@@ -1831,7 +1835,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,

 	/* TODO: Is it alright to modify flock? */
 	lock->l_pid = 0;
+#ifdef F_OFD_SETLK
 	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
+#else
+	ret = fcntl(plock->fd, F_GETLK, lock);
+#endif
 	if (ret == -1) {
 		saverr = errno;
 	}
-- 

