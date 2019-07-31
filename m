From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:05 +0100
Message-Id: <20190731161006.9447-5-stefanha@redhat.com>
In-Reply-To: <20190731161006.9447-1-stefanha@redhat.com>
References: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/5] virtiofsd: fix inode nlookup leaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

utimensat_empty() and linkat_empty_nofollow() must unref the parent
directory inode that was obtained from lo_parent_and_name().

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 135123366a..125e9d9f96 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -567,8 +567,10 @@ static int utimensat_empty(struct lo_data *lo, struct lo_inode *inode,
 
 fallback:
 	res = lo_parent_and_name(lo, inode, path, &parent);
-	if (res != -1)
+	if (res != -1) {
 		res = utimensat(parent->fd, path, tv, AT_SYMLINK_NOFOLLOW);
+		unref_inode(lo, parent, 1);
+	}
 
 	return res;
 }
@@ -1024,8 +1026,10 @@ static int linkat_empty_nofollow(struct lo_data *lo, struct lo_inode *inode,
 
 fallback:
 	res = lo_parent_and_name(lo, inode, path, &parent);
-	if (res != -1)
+	if (res != -1) {
 		res = linkat(parent->fd, path, dfd, name, 0);
+		unref_inode(lo, parent, 1);
+	}
 
 	return res;
 }
-- 
2.21.0

