From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 17 Aug 2021 10:22:20 +0800
Message-Id: <20210817022220.17574-9-jefflexu@linux.alibaba.com>
In-Reply-To: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v4 8/8] fuse: show '-o dax=inode' option only
	when FUSE server supports
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

Prior of this patch, the mount option will still show '-o dax=inode'
when FUSE server advertises that it doesn't support per-file DAX.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 8c9774c6a210..7f09a964823f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -697,7 +697,7 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",dax=always");
 	else if (fc->dax_mode == FUSE_DAX_NEVER)
 		seq_puts(m, ",dax=never");
-	else if (fc->dax_mode == FUSE_DAX_INODE)
+	else if ((fc->dax_mode == FUSE_DAX_INODE) && fc->perfile_dax)
 		seq_puts(m, ",dax=inode");
 #endif
 
-- 
2.27.0

