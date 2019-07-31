From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:03 +0100
Message-Id: <20190731161006.9447-3-stefanha@redhat.com>
In-Reply-To: <20190731161006.9447-1-stefanha@redhat.com>
References: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] virtiofsd: take lo->mutex around
	lo_add_dirp_mapping()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

The lo_add_dirp_mapping() function assumes lo->mutex is held, so we
should acquire it.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 417a104218..e1d729d26b 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1357,7 +1357,9 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi
 
 	g_atomic_int_set(&d->refcount, 1); /* paired with lo_releasedir() */
 
+	pthread_mutex_lock(&lo->mutex);
 	fh = lo_add_dirp_mapping(req, d);
+	pthread_mutex_unlock(&lo->mutex);
 	if (fh == -1)
 		goto out_err;
 
-- 
2.21.0

