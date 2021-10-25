From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Mon, 25 Oct 2021 16:46:34 -0400
Message-Id: <20211025204634.2517-8-iangelak@redhat.com>
In-Reply-To: <20211025204634.2517-1-iangelak@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 7/7] virtiofs: Add support for handling the
	remote fsnotify notifications
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, vgoyal@redhat.com

FUSE and specifically virtiofs should be able to handle the asynchronous
event notifications originating from the FUSE server. To this end we add
the FUSE_NOTIFY_FSNOTIFY switch case to the "virtio_fs_handle_notify" in
fs/fuse/virtio_fs.c to handle these specific notifications.

The event notification contains the information that a user space
application would receive when monitoring an inode for events. The
information is the mask of the inode watch, a file name corresponding to
the inode the remote event was generated for and finally, the inotify
cookie.

Then a new event should be generated corresponding to the event
notification received from the FUSE server. Specifically, FUSE in the guest
kernel will call the "__fsnotify" function in fs/notify/fsnotify.c to send
the event to user space.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 fs/fuse/virtio_fs.c | 64 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d3dba9e3a07e..4c48c2812caa 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -16,6 +16,7 @@
 #include <linux/fs_parser.h>
 #include <linux/highmem.h>
 #include <linux/uio.h>
+#include <linux/fsnotify_backend.h>
 #include "fuse_i.h"
 
 /* Used to help calculate the FUSE connection's max_pages limit for a request's
@@ -655,14 +656,69 @@ static void notify_node_reuse(struct virtio_fs_vq *notify_fsvq,
 	spin_unlock(&notify_fsvq->lock);
 }
 
+static int fsnotify_remote_event(struct inode *inode, uint32_t mask,
+				 struct qstr *filename, uint32_t cookie)
+{
+	return __fsnotify(mask, NULL, 0, NULL,
+			  (const struct qstr *)filename, inode, cookie);
+}
+
+/*
+ * Function to generate a new event when a fsnotify notification comes from the
+ * fuse server
+ */
+static int generate_fsnotify_event(struct fuse_conn *fc,
+			struct fuse_notify_fsnotify_out *fsnotify_out)
+{
+	struct inode *inode;
+	uint32_t mask, cookie;
+	struct fuse_mount *fm;
+	int ret = -1;
+	struct qstr name;
+
+	down_read(&fc->killsb);
+	inode = fuse_ilookup(fc, fsnotify_out->inode, &fm);
+	/*
+	 * The inode that corresponds to the event does not exist in this case
+	 * so do not generate any new event and just return an error
+	 */
+	if (!inode)
+		goto out;
+
+	mask = fsnotify_out->mask;
+	cookie = fsnotify_out->cookie;
+
+	/*
+	 * If the notification contained the name of the file/dir the event
+	 * occurred for, it will be placed after the fsnotify_out struct in the
+	 * notification message
+	 */
+	if (fsnotify_out->namelen > 0) {
+		name.len = fsnotify_out->namelen;
+		name.name = (char *)fsnotify_out + sizeof(struct fuse_notify_fsnotify_out);
+		ret = fsnotify_remote_event(inode, mask, &name, cookie);
+	} else {
+		ret = fsnotify_remote_event(inode, mask, NULL, cookie);
+	}
+
+	up_read(&fc->killsb);
+out:
+	if (ret < 0)
+		return -EINVAL;
+
+	return ret;
+}
+
 static int virtio_fs_handle_notify(struct virtio_fs *vfs,
-				   struct virtio_fs_notify_node *notifyn)
+				   struct virtio_fs_notify_node *notifyn,
+				   struct fuse_conn *fc)
 {
 	int ret = 0, no_reuse = 0;
 	struct virtio_fs_notify *notify = &notifyn->notify;
 	struct virtio_fs_vq *notify_fsvq = &vfs->vqs[VQ_NOTIFY_IDX];
 	struct fuse_out_header *oh = &notify->out_hdr;
 	struct fuse_notify_lock_out *lo;
+	struct fuse_notify_fsnotify_out *fsnotify_out;
 
 	/*
 	 * For notifications, oh.unique is 0 and oh->error contains code
@@ -673,6 +729,10 @@ static int virtio_fs_handle_notify(struct virtio_fs *vfs,
 		lo = (struct fuse_notify_lock_out *) &notify->outarg;
 		no_reuse = notify_complete_waiting_req(vfs, lo);
 		break;
+	case FUSE_NOTIFY_FSNOTIFY:
+		fsnotify_out = (struct fuse_notify_fsnotify_out *) &notify->outarg;
+		generate_fsnotify_event(fc, fsnotify_out);
+		break;
 	default:
 		pr_err("virtio-fs: Unexpected notification %d\n", oh->error);
 	}
@@ -711,7 +771,7 @@ static void virtio_fs_notify_done_work(struct work_struct *work)
 		WARN_ON(oh->unique);
 		list_del_init(&notifyn->list);
 		/* Handle notification */
-		virtio_fs_handle_notify(vfs, notifyn);
+		virtio_fs_handle_notify(vfs, notifyn, fsvq->fud->fc);
 		spin_lock(&fsvq->lock);
 		dec_in_flight_req(fsvq);
 		spin_unlock(&fsvq->lock);
-- 
2.33.0

