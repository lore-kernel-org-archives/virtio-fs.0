Date: Tue, 6 Apr 2021 10:07:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210406140706.GB934253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] fuse: Invalidate attrs when page writeback
	completes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, eric.auger@redhat.com

In fuse when a direct/write-through write happens we invalidate attrs because
that might have updated mtime/ctime on server and cached mtime/ctime
will be stale.

What about page writeback path. Looks like we don't invalidate attrs there.
To be consistent, invalidate attrs in writeback path as well. Only exception
is when writeback_cache is enabled. In that case we strust local mtime/ctime
and there is no need to invalidate attrs.

Recently users started experiencing failure of xfstests generic/080,
geneirc/215 and generic/614 on virtiofs. This happened only newer
"stat" utility and not older one. This patch fixes the issue.

So what's the root cause of the issue. Here is detailed explanation.

generic/080 test does mmap write to a file, closes the file and then
checks if mtime has been updated or not. When file is closed, it
leads to flushing of dirty pages (and that should update mtime/ctime
on server). But we did not explicitly invalidate attrs after writeback
finished. Still generic/080 passed so far and reason being that we
invalidated atime in fuse_readpages_end(). This is called in fuse_readahead()
path and always seems to trigger before mmaped write.

So after mmaped write when lstat() is called, it sees that atleast one
of the fields being asked for is invalid (atime) and that results in
generating GETATTR to server and mtime/ctime also get updated and test
passes.

But newer /usr/bin/stat seems to have moved to using statx() syscall now
(instead of using lstat()). And statx() allows it to query only ctime
or mtime (and not rest of the basic stat fields). That means when
querying for mtime, fuse_update_get_attr() sees that mtime is not
invalid (only atime is invalid). So it does not generate a new GETATTR
and fill stat with cached mtime/ctime. And that means updated mtime
is not seen by xfstest and tests start failing.

Invalidating attrs after writeback completion should solve this problem
in a generic manner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8cccecb55fb8..482281bf170a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1759,8 +1759,17 @@ static void fuse_writepage_end(struct fuse_mount *fm, struct fuse_args *args,
 		container_of(args, typeof(*wpa), ia.ap.args);
 	struct inode *inode = wpa->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	mapping_set_error(inode->i_mapping, error);
+	/*
+	 * A writeback finished and this might have updated mtime/ctime on
+	 * server making local mtime/ctime stale. Hence invalidate attrs.
+	 * Do this only if writeback_cache is not enabled. If writeback_cache
+	 * is enabled, we trust local ctime/mtime.
+	 */
+	if (!fc->writeback_cache)
+		fuse_invalidate_attr(inode);
 	spin_lock(&fi->lock);
 	rb_erase(&wpa->writepages_entry, &fi->writepages);
 	while (wpa->next) {
-- 
2.25.4

