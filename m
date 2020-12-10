Date: Thu, 10 Dec 2020 19:58:51 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201210195851.GM3629@work-vm>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207183021.22752-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofsd: Disable posix_lock hash
 table if remote locks are not enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> If remote posix locks are not enabled (lo->posix_lock == false), then disable
> code paths taken to initialize inode->posix_lock hash table and corresponding
> destruction and search etc.
> 
> lo_getlk() and lo_setlk() have been modified to return ENOSYS if daemon
> does not support posix lock but client still sends a lock/unlock request.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 51 +++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 59202a843b..8ba79f503a 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -914,10 +914,11 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          inode->key.ino = e->attr.st_ino;
>          inode->key.dev = e->attr.st_dev;
>          inode->key.mnt_id = mnt_id;
> -        pthread_mutex_init(&inode->plock_mutex, NULL);
> -        inode->posix_locks = g_hash_table_new_full(
> -            g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
> -
> +        if (lo->posix_lock) {
> +            pthread_mutex_init(&inode->plock_mutex, NULL);
> +            inode->posix_locks = g_hash_table_new_full(
> +                g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
> +        }
>          pthread_mutex_lock(&lo->mutex);
>          inode->fuse_ino = lo_add_inode_mapping(req, inode);
>          g_hash_table_insert(lo->inodes, &inode->key, inode);
> @@ -1303,12 +1304,13 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
>      if (!inode->nlookup) {
>          lo_map_remove(&lo->ino_map, inode->fuse_ino);
>          g_hash_table_remove(lo->inodes, &inode->key);
> -        if (g_hash_table_size(inode->posix_locks)) {
> -            fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
> +        if (lo->posix_lock) {
> +            if (g_hash_table_size(inode->posix_locks)) {
> +                fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
> +            }
> +            g_hash_table_destroy(inode->posix_locks);
> +            pthread_mutex_destroy(&inode->plock_mutex);
>          }
> -        g_hash_table_destroy(inode->posix_locks);
> -        pthread_mutex_destroy(&inode->plock_mutex);
> -
>          /* Drop our refcount from lo_do_lookup() */
>          lo_inode_put(lo, &inode);
>      }
> @@ -1784,6 +1786,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>               ino, fi->flags, fi->lock_owner, lock->l_type, lock->l_start,
>               lock->l_len);
>  
> +    if (!lo->posix_lock) {
> +        fuse_reply_err(req, ENOSYS);
> +        return;
> +    }
> +
>      inode = lo_inode(req, ino);
>      if (!inode) {
>          fuse_reply_err(req, EBADF);
> @@ -1829,6 +1836,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>               ino, fi->flags, lock->l_type, lock->l_pid, fi->lock_owner, sleep,
>               lock->l_whence, lock->l_start, lock->l_len);
>  
> +    if (!lo->posix_lock) {
> +        fuse_reply_err(req, ENOSYS);
> +        return;
> +    }
> +
>      if (sleep) {
>          fuse_reply_err(req, EOPNOTSUPP);
>          return;
> @@ -1953,6 +1965,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      int res;
>      (void)ino;
>      struct lo_inode *inode;
> +    struct lo_data *lo = lo_data(req);
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {
> @@ -1961,12 +1974,14 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      }
>  
>      /* An fd is going away. Cleanup associated posix locks */
> -    pthread_mutex_lock(&inode->plock_mutex);
> -    g_hash_table_remove(inode->posix_locks, GUINT_TO_POINTER(fi->lock_owner));
> -    pthread_mutex_unlock(&inode->plock_mutex);
> -
> +    if (lo->posix_lock) {
> +        pthread_mutex_lock(&inode->plock_mutex);
> +        g_hash_table_remove(inode->posix_locks,
> +            GUINT_TO_POINTER(fi->lock_owner));
> +        pthread_mutex_unlock(&inode->plock_mutex);
> +    }
>      res = close(dup(lo_fi_fd(req, fi)));
> -    lo_inode_put(lo_data(req), &inode);
> +    lo_inode_put(lo, &inode);
>      fuse_reply_err(req, res == -1 ? errno : 0);
>  }
>  
> @@ -3372,9 +3387,11 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
>      root->key.mnt_id = mnt_id;
>      root->nlookup = 2;
>      g_atomic_int_set(&root->refcount, 2);
> -    pthread_mutex_init(&root->plock_mutex, NULL);
> -    root->posix_locks = g_hash_table_new_full(
> -        g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
> +    if (lo->posix_lock) {
> +        pthread_mutex_init(&root->plock_mutex, NULL);
> +        root->posix_locks = g_hash_table_new_full(
> +            g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
> +    }
>  }
>  
>  static guint lo_key_hash(gconstpointer key)
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

