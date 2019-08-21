From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:37:30 -0400
Message-Id: <20190821173742.24574-2-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 01/13] fuse: delete dentry if timeout is zero
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, vgoyal@redhat.com

From: Miklos Szeredi <mszeredi@redhat.com>

Don't hold onto dentry in lru list if need to re-lookup it anyway at next
access.

More advanced version of this patch would periodically flush out dentries
from the lru which have gone stale.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dir.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index dd0f64f7bc06..fd8636e67ae9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -29,12 +29,26 @@ union fuse_dentry {
 	struct rcu_head rcu;
 };
 
-static inline void fuse_dentry_settime(struct dentry *entry, u64 time)
+static void fuse_dentry_settime(struct dentry *dentry, u64 time)
 {
-	((union fuse_dentry *) entry->d_fsdata)->time = time;
+	/*
+	 * Mess with DCACHE_OP_DELETE because dput() will be faster without it.
+	 *  Don't care about races, either way it's just an optimization
+	 */
+	if ((time && (dentry->d_flags & DCACHE_OP_DELETE)) ||
+	    (!time && !(dentry->d_flags & DCACHE_OP_DELETE))) {
+		spin_lock(&dentry->d_lock);
+		if (time)
+			dentry->d_flags &= ~DCACHE_OP_DELETE;
+		else
+			dentry->d_flags |= DCACHE_OP_DELETE;
+		spin_unlock(&dentry->d_lock);
+	}
+
+	((union fuse_dentry *) dentry->d_fsdata)->time = time;
 }
 
-static inline u64 fuse_dentry_time(struct dentry *entry)
+static inline u64 fuse_dentry_time(const struct dentry *entry)
 {
 	return ((union fuse_dentry *) entry->d_fsdata)->time;
 }
@@ -255,8 +269,14 @@ static void fuse_dentry_release(struct dentry *dentry)
 	kfree_rcu(fd, rcu);
 }
 
+static int fuse_dentry_delete(const struct dentry *dentry)
+{
+	return time_before64(fuse_dentry_time(dentry), get_jiffies_64());
+}
+
 const struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
+	.d_delete	= fuse_dentry_delete,
 	.d_init		= fuse_dentry_init,
 	.d_release	= fuse_dentry_release,
 };
-- 
2.20.1

