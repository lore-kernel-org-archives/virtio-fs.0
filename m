From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 23 Sep 2021 17:25:26 +0800
Message-Id: <20210923092526.72341-6-jefflexu@linux.alibaba.com>
In-Reply-To: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v5 5/5] fuse: mark inode DONT_CACHE when
	per-file DAX hint changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

When the per-file DAX hint changes while the file is still *opened*, it
is quite complicated and maybe fragile to dynamically change the DAX
state.

Hence mark the inode and corresponding dentries as DONE_CACHE once the
per-file DAX hint changes, so that the inode instance will be evicted
and freed as soon as possible once the file is closed and the last
reference to the inode is put. And then when the file gets reopened next
time, the new instantiated inode will reflect the new DAX state.

In summary, when the per-file DAX hint changes for an *opened* file, the
DAX state of the file won't be updated until this file is closed and
reopened later.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/dax.c    | 9 +++++++++
 fs/fuse/fuse_i.h | 1 +
 fs/fuse/inode.c  | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index b0682ddd5d77..d90eaf1c5b48 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1358,6 +1358,15 @@ void fuse_dax_inode_init(struct inode *inode, unsigned int flags)
 	inode->i_data.a_ops = &fuse_dax_file_aops;
 }
 
+void fuse_dax_dontcache(struct inode *inode, unsigned int flags)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (fc->dax_mode == FUSE_DAX_INODE &&
+	    (!!IS_DAX(inode) != !!(flags & FUSE_ATTR_DAX)))
+		d_mark_dontcache(inode);
+}
+
 bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment)
 {
 	if (fc->dax && (map_alignment > FUSE_DAX_SHIFT)) {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 0270a41c31d7..bb2c11e0311a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1270,6 +1270,7 @@ void fuse_dax_conn_free(struct fuse_conn *fc);
 bool fuse_dax_inode_alloc(struct super_block *sb, struct fuse_inode *fi);
 void fuse_dax_inode_init(struct inode *inode, unsigned int flags);
 void fuse_dax_inode_cleanup(struct inode *inode);
+void fuse_dax_dontcache(struct inode *inode, unsigned int flags);
 bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment);
 void fuse_dax_cancel_work(struct fuse_conn *fc);
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 48f466a65b76..aee462a25231 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -268,6 +268,9 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 		if (inval)
 			invalidate_inode_pages2(inode->i_mapping);
 	}
+
+	if (IS_ENABLED(CONFIG_FUSE_DAX))
+		fuse_dax_dontcache(inode, attr->flags);
 }
 
 static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
-- 
2.27.0

