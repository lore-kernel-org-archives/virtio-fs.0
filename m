References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-8-vgoyal@redhat.com>
From: Christophe de Dinechin <dinechin@redhat.com>
Date: Tue, 05 Oct 2021 15:37:17 +0200
In-reply-to: <20210930153037.1194279-8-vgoyal@redhat.com>
Message-ID: <lytuhv617w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH 07/13] virtiofsd: Release file locks using
 F_UNLCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu


On 2021-09-30 at 11:30 -04, Vivek Goyal <vgoyal@redhat.com> wrote...
> We are emulating posix locks for guest using open file description locks
> in virtiofsd. When any of the fd is closed in guest, we find associated
> OFD lock fd (if there is one) and close it to release all the locks.
>
> Assumption here is that there is no other thread using lo_inode_plock
> structure or plock->fd, hence it is safe to do so.
>
> But now we are about to introduce blocking variant of locks (SETLKW),
> and that means we might be waiting to a lock to be available and
> using plock->fd. And that means there are still users of plock
> structure.
>
> So release locks using fcntl(SETLK, F_UNLCK) instead of closing fd
> and plock will be freed later when lo_inode is being freed.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 38b2af8599..6928662e22 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1557,9 +1557,6 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
>          lo_map_remove(&lo->ino_map, inode->fuse_ino);
>          g_hash_table_remove(lo->inodes, &inode->key);
>          if (lo->posix_lock) {
> -            if (g_hash_table_size(inode->posix_locks)) {
> -                fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
> -            }
>              g_hash_table_destroy(inode->posix_locks);
>              pthread_mutex_destroy(&inode->plock_mutex);
>          }
> @@ -2266,6 +2263,8 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      (void)ino;
>      struct lo_inode *inode;
>      struct lo_data *lo = lo_data(req);
> +    struct lo_inode_plock *plock;
> +    struct flock flock;
>
>      inode = lo_inode(req, ino);
>      if (!inode) {
> @@ -2282,8 +2281,22 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      /* An fd is going away. Cleanup associated posix locks */
>      if (lo->posix_lock) {
>          pthread_mutex_lock(&inode->plock_mutex);
> -        g_hash_table_remove(inode->posix_locks,

I'm curious why the g_hash_table_remove above is not in the 'if' below?

> +        plock = g_hash_table_lookup(inode->posix_locks,
>              GUINT_TO_POINTER(fi->lock_owner));
> +
> +        if (plock) {
> +            /*
> +             * An fd is being closed. For posix locks, this means
> +             * drop all the associated locks.
> +             */
> +            memset(&flock, 0, sizeof(struct flock));
> +            flock.l_type = F_UNLCK;
> +            flock.l_whence = SEEK_SET;
> +            /* Unlock whole file */
> +            flock.l_start = flock.l_len = 0;
> +            fcntl(plock->fd, F_OFD_SETLK, &flock);
> +        }
> +
>          pthread_mutex_unlock(&inode->plock_mutex);
>      }
>      res = close(dup(lo_fi_fd(req, fi)));


--
Cheers,
Christophe de Dinechin (IRC c3d)

