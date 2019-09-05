From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:55 -0400
Message-Id: <20190905194859.16219-15-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 14/18] virtiofs: Add a fuse_iqueue operation to
	put() reference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, miklos@szeredi.hu
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com

Soon I will make virtio_fs object reference counted, where reference will
be taken by device as well as by fuse_conn (fuse_conn->fuse_iqueue->fiq_priv).

When fuse_connection is going away, it should put its reference on virtio_fs
object.

So add a fuse_iqueue method which can be used to call into virtio_fs to
put the reference on the object (fiq_priv).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/fuse_i.h | 5 +++++
 fs/fuse/inode.c  | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 85e2dcad68c1..04e2c000d63f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -479,6 +479,11 @@ struct fuse_iqueue_ops {
 	 */
 	void (*wake_pending_and_unlock)(struct fuse_iqueue *fiq)
 		__releases(fiq->waitq.lock);
+
+	/**
+	 * Put a reference on fiq_priv.
+	 */
+	void (*put)(struct fuse_iqueue *fiq);
 };
 
 /** /dev/fuse input queue operations */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 7fa0dcc6f565..70a433bdf01f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -631,8 +631,14 @@ EXPORT_SYMBOL_GPL(fuse_conn_init);
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
+		struct fuse_iqueue *fiq = &fc->iq;
+
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
+		if (fiq->priv && fiq->ops->put) {
+			fiq->ops->put(fiq);
+			fiq->priv = NULL;
+		}
 		put_pid_ns(fc->pid_ns);
 		put_user_ns(fc->user_ns);
 		fc->release(fc);
-- 
2.20.1

