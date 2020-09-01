From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  1 Sep 2020 16:40:45 -0400
Message-Id: <20200901204045.1250822-3-vgoyal@redhat.com>
In-Reply-To: <20200901204045.1250822-1-vgoyal@redhat.com>
References: <20200901204045.1250822-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] fuse: Enable SB_NOSEC if filesystem is not
	shared
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: vgoyal@redhat.com

We don't enable SB_NOSEC on fuse filesystems thinking filesystem is
shared and files attrs setuid/setgid/capabilities can change without
fuse knowing about it. This means on every WRITE, file_remove_privs(),
is called and that calls into fuse server to figure out if security.capability
xattr has been set on file. Most of the time this is a performance hog,
specially for small writes done at high frequency.

Enable SB_NOSEC if fuse filesystem sets flag FS_NONSHARED_FS. This means,
do not expect file attrs/xattrs to change without the knowledge of
fuse. In this case it should be possible to enable SB_NOSEC.

For the case of shared filesystems, we will have to come up with a different
mechanism to enable SB_NOSEC. I guess it will depend on invalidation
mechanisms implemented by filesystem and cache coherency guarantees.

I do clear inode S_NOSEC flag whenever file attrs are being refreshed. So
this still honors attr timeout protocol.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 088faa3e352c..2da13fe25417 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -187,6 +187,9 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 		inode->i_mode &= ~S_ISVTX;
 
 	fi->orig_ino = attr->ino;
+
+	/* Clear S_NOSEC whenever cached attrs are being refreshed */
+	inode->i_flags &= ~S_NOSEC;
 }
 
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
@@ -967,6 +970,9 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
 			}
 			if (arg->flags & FUSE_NONSHARED_FS) {
 				fc->nonshared_fs = 1;
+				down_write(&fc->sb->s_umount);
+				fc->sb->s_flags |= SB_NOSEC;
+				up_write(&fc->sb->s_umount);
 			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
-- 
2.25.4

