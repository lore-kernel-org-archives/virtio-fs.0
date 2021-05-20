From: Greg Kurz <groug@kaod.org>
Date: Thu, 20 May 2021 17:46:50 +0200
Message-Id: <20210520154654.1791183-2-groug@kaod.org>
In-Reply-To: <20210520154654.1791183-1-groug@kaod.org>
References: <20210520154654.1791183-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 1/5] fuse: Fix leak in
	fuse_dentry_automount() error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

Some rollback was forgotten during the addition of crossmounts.

Fixes: bf109c64040f ("fuse: implement crossmounts")
Cc: mreitz@redhat.com
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 1b6c001a7dd1..fb2af70596c3 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -339,8 +339,11 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 
 	/* Initialize superblock, making @mp_fi its root */
 	err = fuse_fill_super_submount(sb, mp_fi);
-	if (err)
+	if (err) {
+		fuse_conn_put(fc);
+		kfree(fm);
 		goto out_put_sb;
+	}
 
 	sb->s_flags |= SB_ACTIVE;
 	fsc->root = dget(sb->s_root);
-- 
2.26.3

