From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:37:39 -0400
Message-Id: <20190821173742.24574-11-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 10/13] fuse: Separate fuse device allocation and
	installation in fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

As of now fuse_dev_alloc() both allocates a fuse device and installs it
in fuse_conn list. fuse_dev_alloc() can fail if fuse_device allocation
fails.

virtio-fs needs to initialize multiple fuse devices (one per virtio
queue). It initializes one fuse device as part of call to
fuse_fill_super_common() and rest of the devices are allocated and
installed after that.

But, we can't affort to fail after calling fuse_fill_super_common() as
we don't have a way to undo all the actions done by fuse_fill_super_common().
So to avoid failures after the call to fuse_fill_super_common(),
pre-allocate all fuse devices early and install them into fuse connection
later.

This patch provides two separate helpers for fuse device allocation and
fuse device installation in fuse_conn.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/cuse.c   |  2 +-
 fs/fuse/dev.c    |  2 +-
 fs/fuse/fuse_i.h |  4 +++-
 fs/fuse/inode.c  | 25 ++++++++++++++++++++-----
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 7bdab6521469..04727540bdbb 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -506,7 +506,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 	 */
 	fuse_conn_init(&cc->fc, file->f_cred->user_ns, &fuse_dev_fiq_ops, NULL);
 
-	fud = fuse_dev_alloc(&cc->fc);
+	fud = fuse_dev_alloc_install(&cc->fc);
 	if (!fud) {
 		kfree(cc);
 		return -ENOMEM;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fa6794e96811..556e44fa6b20 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2319,7 +2319,7 @@ static int fuse_device_clone(struct fuse_conn *fc, struct file *new)
 	if (new->private_data)
 		return -EINVAL;
 
-	fud = fuse_dev_alloc(fc);
+	fud = fuse_dev_alloc_install(fc);
 	if (!fud)
 		return -ENOMEM;
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 70c1bde06293..605217552350 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1060,7 +1060,9 @@ void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns,
  */
 void fuse_conn_put(struct fuse_conn *fc);
 
-struct fuse_dev *fuse_dev_alloc(struct fuse_conn *fc);
+struct fuse_dev *fuse_dev_alloc_install(struct fuse_conn *fc);
+struct fuse_dev *fuse_dev_alloc(void);
+void fuse_dev_install(struct fuse_dev *fud, struct fuse_conn *fc);
 void fuse_dev_free(struct fuse_dev *fud);
 void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req);
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 226af184a402..0df885d6fa00 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1024,8 +1024,7 @@ static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
 	return 0;
 }
 
-struct fuse_dev *fuse_dev_alloc(struct fuse_conn *fc)
-{
+struct fuse_dev *fuse_dev_alloc(void) {
 	struct fuse_dev *fud;
 	struct list_head *pq;
 
@@ -1040,16 +1039,32 @@ struct fuse_dev *fuse_dev_alloc(struct fuse_conn *fc)
 	}
 
 	fud->pq.processing = pq;
-	fud->fc = fuse_conn_get(fc);
 	fuse_pqueue_init(&fud->pq);
 
+	return fud;
+}
+EXPORT_SYMBOL_GPL(fuse_dev_alloc);
+
+void fuse_dev_install(struct fuse_dev *fud, struct fuse_conn *fc) {
+	fud->fc = fuse_conn_get(fc);
 	spin_lock(&fc->lock);
 	list_add_tail(&fud->entry, &fc->devices);
 	spin_unlock(&fc->lock);
+}
+EXPORT_SYMBOL_GPL(fuse_dev_install);
 
+struct fuse_dev *fuse_dev_alloc_install(struct fuse_conn *fc)
+{
+	struct fuse_dev *fud;
+
+	fud = fuse_dev_alloc();
+	if (!fud)
+		return NULL;
+
+	fuse_dev_install(fud, fc);
 	return fud;
 }
-EXPORT_SYMBOL_GPL(fuse_dev_alloc);
+EXPORT_SYMBOL_GPL(fuse_dev_alloc_install);
 
 void fuse_dev_free(struct fuse_dev *fud)
 {
@@ -1119,7 +1134,7 @@ int fuse_fill_super_common(struct super_block *sb,
 		       mount_data->fiq_priv);
 	fc->release = fuse_free_conn;
 
-	fud = fuse_dev_alloc(fc);
+	fud = fuse_dev_alloc_install(fc);
 	if (!fud)
 		goto err_put_conn;
 
-- 
2.20.1

