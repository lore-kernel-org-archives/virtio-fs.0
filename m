From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Mon, 25 Oct 2021 16:46:31 -0400
Message-Id: <20211025204634.2517-5-iangelak@redhat.com>
In-Reply-To: <20211025204634.2517-1-iangelak@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 4/7] FUSE: Add the
	fuse_fsnotify_send_request to FUSE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, vgoyal@redhat.com

The function "fuse_fsnotify_send_request" is responsible for sending an
fsnotify FUSE request to the FUSE server (virtiofsd).

The request contains all the information that is stored within the
"fuse_notify_fsnotify_in" struct, i.e., the event mask for the inotify
watch, the action to be performed on the watch (create, modify or delete)
and the group identifier which is essentially the 64bit (fsnotify_group)
pointer that corresponds to one inotify instance created by a user space
process.

Since each group identifier is unique, the FUSE server can create an equal
number of inotify instances to the ones created by the user space
processes.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 fs/fuse/dev.c    | 37 +++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dde341a6388a..89eea8abac4b 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1795,6 +1795,43 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 	}
 }
 
+/* Send a request for a watch placement to the FUSE server */
+int fuse_fsnotify_send_request(struct inode *inode, uint32_t mask,
+			       uint32_t action, uint64_t group)
+{
+	struct fuse_mount *fm = get_fuse_mount(inode);
+	struct fuse_notify_fsnotify_in inarg;
+	int err;
+	FUSE_ARGS(args);
+
+	/* The server does not support remote fsnotify events */
+	if (fm->fc->no_fsnotify)
+		return 0;
+
+	/*
+	 * Send the mask the action (remove, add, modify) and the
+	 * unique identifier that is the fsnotify group that is
+	 * interested in the watch to the FUSE server
+	 */
+	memset(&inarg, 0, sizeof(struct fuse_notify_fsnotify_in));
+	inarg.mask = mask;
+	inarg.action = action;
+	inarg.group = (uint64_t)group;
+
+	args.opcode = FUSE_FSNOTIFY;
+	args.nodeid = get_node_id(inode);
+	args.in_numargs = 1;
+	args.in_args[0].size = sizeof(struct fuse_notify_fsnotify_in);
+	args.in_args[0].value = &inarg;
+	args.out_numargs = 0;
+	args.force = true;
+
+	err = fuse_simple_request(fm, &args);
+
+	return err;
+}
+EXPORT_SYMBOL(fuse_fsnotify_send_request);
+
 /* Look up request on processing list by unique ID */
 static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c3cebfb936d2..5c83c4535608 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1243,6 +1243,9 @@ struct posix_acl *fuse_get_acl(struct inode *inode, int type, bool rcu);
 int fuse_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 		 struct posix_acl *acl, int type);
 
+int fuse_fsnotify_send_request(struct inode *inode, uint32_t mask,
+			       uint32_t action, uint64_t group);
+
 /* readdir.c */
 int fuse_readdir(struct file *file, struct dir_context *ctx);
 
-- 
2.33.0

