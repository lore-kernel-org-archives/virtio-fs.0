From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  7 Aug 2020 15:55:24 -0400
Message-Id: <20200807195526.426056-19-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-1-vgoyal@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 18/20] fuse: Release file in process context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

fuse_file_put(sync) can be called with sync=true/false. If sync=true,
it waits for release request response and then calls iput() in the
caller's context. If sync=false, it does not wait for release request
response, frees the fuse_file struct immediately and req->end function
does the iput().

iput() can be a problem with DAX if called in req->end context. If this
is last reference to inode (VFS has let go its reference already), then
iput() will clean DAX mappings as well and send REMOVEMAPPING requests
and wait for completion. (All the the worker thread context which is
processing fuse replies from daemon on the host).

That means it blocks worker thread and it stops processing further
replies and system deadlocks.

So for now, force sync release of file in case of DAX inodes.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ecd2a42f6e30..605976a586c2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -527,6 +527,7 @@ void fuse_release_common(struct file *file, bool isdir)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_release_args *ra = ff->release_args;
 	int opcode = isdir ? FUSE_RELEASEDIR : FUSE_RELEASE;
+	bool sync = false;
 
 	fuse_prepare_release(fi, ff, file->f_flags, opcode);
 
@@ -546,8 +547,19 @@ void fuse_release_common(struct file *file, bool isdir)
 	 * Make the release synchronous if this is a fuseblk mount,
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
+	 *
+	 * For DAX, fuse server is trusted. So it should be fine to
+	 * do a sync file put. Doing async file put is creating
+	 * problems right now because when request finish, iput()
+	 * can lead to freeing of inode. That means it tears down
+	 * mappings backing DAX memory and sends REMOVEMAPPING message
+	 * to server and blocks for completion. Currently, waiting
+	 * in req->end context deadlocks the system as same worker thread
+	 * can't process REMOVEMAPPING reply it is waiting for.
 	 */
-	fuse_file_put(ff, ff->fc->destroy, isdir);
+	if (IS_DAX(file_inode(file)) || ff->fc->destroy)
+		sync = true;
+	fuse_file_put(ff, sync, isdir);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)
-- 
2.25.4

