DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=b9Flv9Y2FE/C1eEICXU/BQJh4wynAJmPbsAicXerMx0=;
	b=IY0qZegw+YgoZpCHdNTcdlYBtXzV/pY8hJPZh9Q/bzkS5pwiYZcTnpe76Q92+Rx4YA
	FkOMxsX7gFnM07x5iclIjKVCmo0nrqiXVzmKXuMOt0QFWihMSaXLrSFO8rgxMjneH5nT
	EEhU0OmF+9BWrSdImYfGBJPvMOUXGwHhQSy8E=
Date: Sat, 28 Aug 2021 17:21:39 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
Message-ID: <YSpUgzG8rM5LeFDy@miu.piliscsaba.redhat.com>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
	<CAOQ4uxh69ii5Yk-DgFAq+TrrvJ6xCv9s8sKLfo3aBCSWjJvp9Q@mail.gmail.com>
	<YRqEPjzHg9IlifBo@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YRqEPjzHg9IlifBo@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 5/5] virtiofs: propagate sync() to file
	server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Robert Krawitz <rlk@redhat.com>

On Mon, Aug 16, 2021 at 11:29:02AM -0400, Vivek Goyal wrote:
> On Sun, Aug 15, 2021 at 05:14:06PM +0300, Amir Goldstein wrote:

> > I wonder - even if the server does not support SYNCFS or if the kernel
> > does not trust the server with SYNCFS, fuse_sync_fs() can wait
> > until all pending requests up to this call have been completed, either
> > before or after submitting the SYNCFS request. No?
> 
> > 
> > Does virtiofsd track all requests prior to SYNCFS request to make
> > sure that they were executed on the host filesystem before calling
> > syncfs() on the host filesystem?
> 
> Hi Amir,
> 
> I don't think virtiofsd has any such notion. I would think, that
> client should make sure all pending writes have completed and
> then send SYNCFS request.
> 
> Looking at the sync_filesystem(), I am assuming vfs will take care
> of flushing out all dirty pages and then call ->sync_fs.
> 
> Having said that, I think fuse queues the writeback request internally
> and signals completion of writeback to mm(end_page_writeback()). And
> that's why fuse_fsync() has notion of waiting for all pending
> writes to finish on an inode (fuse_sync_writes()).
> 
> So I think you have raised a good point. That is if there are pending
> writes at the time of syncfs(), we don't seem to have a notion of
> first waiting for all these writes to finish before we send
> FUSE_SYNCFS request to server.

So here a proposed patch for fixing this.  Works by counting write requests
initiated up till the syncfs call.  Since more than one syncfs can be in
progress counts are kept in "buckets" in order to wait for the correct write
requests in each instance.

I tried to make this lightweight, but the cacheline bounce due to the counter is
still there, unfortunately.  fc->num_waiting also causes cacheline bouce, so I'm
not going to optimize this (percpu counter?) until that one is also optimizied.

Not yet tested, and I'm not sure how to test this.

Comments?

Thanks,
Miklos


diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 97f860cfc195..8d1d6e895534 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -389,6 +389,7 @@ struct fuse_writepage_args {
 	struct list_head queue_entry;
 	struct fuse_writepage_args *next;
 	struct inode *inode;
+	struct fuse_sync_bucket *bucket;
 };
 
 static struct fuse_writepage_args *fuse_find_writeback(struct fuse_inode *fi,
@@ -1608,6 +1609,9 @@ static void fuse_writepage_free(struct fuse_writepage_args *wpa)
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	int i;
 
+	if (wpa->bucket && atomic_dec_and_test(&wpa->bucket->num_writepages))
+		wake_up(&wpa->bucket->waitq);
+
 	for (i = 0; i < ap->num_pages; i++)
 		__free_page(ap->pages[i]);
 
@@ -1871,6 +1875,19 @@ static struct fuse_writepage_args *fuse_writepage_args_alloc(void)
 
 }
 
+static void fuse_writepage_add_to_bucket(struct fuse_conn *fc,
+					 struct fuse_writepage_args *wpa)
+{
+	if (!fc->sync_fs)
+		return;
+
+	rcu_read_lock();
+	do {
+		wpa->bucket = rcu_dereference(fc->curr_bucket);
+	} while (unlikely(!atomic_inc_not_zero(&wpa->bucket->num_writepages)));
+	rcu_read_unlock();
+}
+
 static int fuse_writepage_locked(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -1898,6 +1915,7 @@ static int fuse_writepage_locked(struct page *page)
 	if (!wpa->ia.ff)
 		goto err_nofile;
 
+	fuse_writepage_add_to_bucket(fc, wpa);
 	fuse_write_args_fill(&wpa->ia, wpa->ia.ff, page_offset(page), 0);
 
 	copy_highpage(tmp_page, page);
@@ -2148,6 +2166,8 @@ static int fuse_writepages_fill(struct page *page,
 			__free_page(tmp_page);
 			goto out_unlock;
 		}
+		fuse_writepage_add_to_bucket(fc, wpa);
+
 		data->max_pages = 1;
 
 		ap = &wpa->ia.ap;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 07829ce78695..ee638e227bb3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -515,6 +515,14 @@ struct fuse_fs_context {
 	void **fudptr;
 };
 
+struct fuse_sync_bucket {
+	atomic_t num_writepages;
+	union {
+		wait_queue_head_t waitq;
+		struct rcu_head rcu;
+	};
+};
+
 /**
  * A Fuse connection.
  *
@@ -807,6 +815,9 @@ struct fuse_conn {
 
 	/** List of filesystems using this connection */
 	struct list_head mounts;
+
+	/* New writepages go into this bucket */
+	struct fuse_sync_bucket *curr_bucket;
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b9beb39a4a18..524b2d128985 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -506,10 +506,24 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+static struct fuse_sync_bucket *fuse_sync_bucket_alloc(void)
+{
+	struct fuse_sync_bucket *bucket;
+
+	bucket = kzalloc(sizeof(*bucket), GFP_KERNEL | __GFP_NOFAIL);
+	if (bucket) {
+		init_waitqueue_head(&bucket->waitq);
+		/* Initial active count */
+		atomic_set(&bucket->num_writepages, 1);
+	}
+	return bucket;
+}
+
 static int fuse_sync_fs(struct super_block *sb, int wait)
 {
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	struct fuse_conn *fc = fm->fc;
+	struct fuse_sync_bucket *bucket, *new_bucket;
 	struct fuse_syncfs_in inarg;
 	FUSE_ARGS(args);
 	int err;
@@ -528,6 +542,31 @@ static int fuse_sync_fs(struct super_block *sb, int wait)
 	if (!fc->sync_fs)
 		return 0;
 
+	new_bucket = fuse_sync_bucket_alloc();
+	spin_lock(&fc->lock);
+	bucket = fc->curr_bucket;
+	if (atomic_read(&bucket->num_writepages) != 0) {
+		/* One more for count completion of old bucket */
+		atomic_inc(&new_bucket->num_writepages);
+		rcu_assign_pointer(fc->curr_bucket, new_bucket);
+		/* Drop initially added active count */
+		atomic_dec(&bucket->num_writepages);
+		spin_unlock(&fc->lock);
+
+		wait_event(bucket->waitq, atomic_read(&bucket->num_writepages) == 0);
+		/*
+		 * Drop count on new bucket, possibly resulting in a completion
+		 * if more than one syncfs is going on
+		 */
+		if (atomic_dec_and_test(&new_bucket->num_writepages))
+			wake_up(&new_bucket->waitq);
+		kfree_rcu(bucket, rcu);
+	} else {
+		spin_unlock(&fc->lock);
+		/* Free unused */
+		kfree(new_bucket);
+	}
+
 	memset(&inarg, 0, sizeof(inarg));
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
@@ -770,6 +809,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
 		put_user_ns(fc->user_ns);
+		kfree_rcu(fc->curr_bucket, rcu);
 		fc->release(fc);
 	}
 }
@@ -1418,6 +1458,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	if (sb->s_flags & SB_MANDLOCK)
 		goto err;
 
+	fc->curr_bucket = fuse_sync_bucket_alloc();
 	fuse_sb_defaults(sb);
 
 	if (ctx->is_bdev) {

