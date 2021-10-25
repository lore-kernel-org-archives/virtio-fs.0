From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Mon, 25 Oct 2021 16:46:29 -0400
Message-Id: <20211025204634.2517-3-iangelak@redhat.com>
In-Reply-To: <20211025204634.2517-1-iangelak@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 2/7] FUSE: Add the remote inotify support
	capability to FUSE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, vgoyal@redhat.com

Add the remote inotify support capability to FUSE init flags, which is
supported by the kernel only when the "CONFIG_INOTIFY_USER" config
option is enabled in the guest kernel.

If virtiofsd wants the remote inotify support feature enabled only then
the guest kernel will enable it. However, this means that the kernel
will suppress the local inotify events related to inodes within the
directory exported through virtiofs. The suppression of local events
prevents the guest from receiving duplicate events; one from the guest
kernel and one from virtiofsd.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 fs/fuse/fuse_i.h | 7 +++++++
 fs/fuse/inode.c  | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f55f9f94b1a4..c3cebfb936d2 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -649,6 +649,13 @@ struct fuse_conn {
 	 */
 	unsigned handle_killpriv_v2:1;
 
+	/* Is the remote inotify capability supported by the filesystem?
+	 * If yes then all the local inotify events related to inodes
+	 * in the FUSE filesystem will be suppressed and only the remote
+	 * events will be let through.
+	 */
+	unsigned no_fsnotify:1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 12d49a1914e8..039a040ddc91 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1143,6 +1143,9 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 			}
 			if (arg->flags & FUSE_SETXATTR_EXT)
 				fc->setxattr_ext = 1;
+			if (!(arg->flags & FUSE_HAVE_FSNOTIFY)) {
+				fc->no_fsnotify = 1;
+			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1190,6 +1193,9 @@ void fuse_send_init(struct fuse_mount *fm)
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
 		ia->in.flags |= FUSE_MAP_ALIGNMENT;
+#endif
+#ifdef CONFIG_INOTIFY_USER
+	ia->in.flags |= FUSE_HAVE_FSNOTIFY;
 #endif
 	if (fm->fc->auto_submounts)
 		ia->in.flags |= FUSE_SUBMOUNTS;
-- 
2.33.0

