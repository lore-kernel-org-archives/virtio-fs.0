From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 16 Sep 2020 12:17:34 -0400
Message-Id: <20200916161737.38028-4-vgoyal@redhat.com>
In-Reply-To: <20200916161737.38028-1-vgoyal@redhat.com>
References: <20200916161737.38028-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/6] fuse: setattr should set FATTR_KILL_PRIV
	upon size change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

If fc->handle_killpriv_v2 is enabled, we expect file server to clear
suid/sgid/security.capbility upon chown/truncate/write as appropriate.

Upon truncate (ATTR_SIZE), suid/sgid is cleared only if caller does
not have CAP_FSETID. File server does not know whether caller has
CAP_FSETID or not. Hence set FATTR_KILL_PRIV upon truncate to let
file server know that caller does not have CAP_FSETID and it should
kill suid/sgid as appropriate.

We don't have to send this information for chown (ATTR_UID/ATTR_GID)
as that always clears suid/sgid irrespective of capabilities of
calling process.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dir.c             | 2 ++
 include/uapi/linux/fuse.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c4a01290aec6..ecdb7895c156 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1575,6 +1575,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		/* For mandatory locking in truncate */
 		inarg.valid |= FATTR_LOCKOWNER;
 		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
+		if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
+			inarg.valid |= FATTR_KILL_PRIV;
 	}
 	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
 	err = fuse_simple_request(fc, &args);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 3ae3f222a0ed..7b8da0a2de0d 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -269,6 +269,7 @@ struct fuse_file_lock {
 #define FATTR_MTIME_NOW	(1 << 8)
 #define FATTR_LOCKOWNER	(1 << 9)
 #define FATTR_CTIME	(1 << 10)
+#define FATTR_KILL_PRIV	(1 << 14) /* Matches ATTR_KILL_PRIV */
 
 /**
  * Flags returned by the OPEN request
-- 
2.25.4

