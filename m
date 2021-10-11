From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 11 Oct 2021 11:00:49 +0800
Message-Id: <20211011030052.98923-5-jefflexu@linux.alibaba.com>
In-Reply-To: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
References: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v6 4/7] fuse: negotiate per-file DAX in FUSE_INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hub
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

Among the FUSE_INIT phase, client shall advertise per-file DAX if it's
mounted with "-o dax=inode". Then server is aware that client is in
per-file DAX mode, and will construct per-inode DAX attribute
accordingly.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b4b41683e97e..f4ad99e2415b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1203,6 +1203,8 @@ void fuse_send_init(struct fuse_mount *fm)
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
 		ia->in.flags |= FUSE_MAP_ALIGNMENT;
+	if (fm->fc->dax_mode == FUSE_DAX_INODE)
+		ia->in.flags |= FUSE_PERFILE_DAX;
 #endif
 	if (fm->fc->auto_submounts)
 		ia->in.flags |= FUSE_SUBMOUNTS;
-- 
2.27.0

