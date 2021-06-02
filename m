Date: Wed, 2 Jun 2021 14:19:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210602181958.GC115492@redhat.com>
References: <20210512125544.9536-1-mreitz@redhat.com>
	<20210512125544.9536-2-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512125544.9536-2-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Find original inode ID of
	mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Wed, May 12, 2021 at 02:55:42PM +0200, Max Reitz wrote:
> Mount point directories represent two inodes: On one hand, they are a
> normal directory on their parent filesystem.  On the other, they are the
> root node of the filesystem mounted there.  Thus, they have two inode
> IDs.
> 
> Right now, we only report the latter inode ID (i.e. the inode ID of the
> mounted filesystem's root node).  This is fine once the guest has
> auto-mounted a submount there (so this inode ID goes with a device ID
> that is distinct from the parent filesystem), but before the auto-mount,
> they have the device ID of the parent and the inode ID for the submount.
> This is problematic because this is likely exactly the same
> st_dev/st_ino combination as the parent filesystem's root node.  This
> leads to problems for example with `find`, which will thus complain
> about a filesystem loop if it has visited the parent filesystem's root
> node before, and then refuse to descend into the submount.
> 
> There is a way to find the mount directory's original inode ID, and that
> is to readdir(3) the parent directory, look for the mount directory, and
> read the dirent.d_ino field.  Using this, we can let lookup and
> readdirplus return that original inode ID, which the guest will thus
> show until the submount is auto-mounted.  (Then, it will invoke getattr
> and that stat(2) call will return the inode ID for the submount.)

[ CC miklos ]

Hi Max,

Though we discussed this in chat room, I am still responding to this
email with the concern I have, so that there is a record of it.

So with this patch for FUSE_LOOKUP  we always return submount's parentinode
id and with GETATTR request we return actual inode id of submount. That
kind of bothers me a bit as we are assuming that there is always going
to be a GETATTR request after FUSE_LOOKUP. FUSE_LOOKUP itself has attrs
returned with it and it might happen that after FUSE_LOOKUP, FUSE_GETATTR
might not be called at all because FUSE_LOOKUP itself got the latest
updated attrs with certain timeout.

For example, if I call stat on a normal file (not submount), I see that
after FUSE_LOOKUP, no FUSE_GETATTR request is going and
fuse_update_get_attr() is using attrs from locally cached inode attrs.

But same thing does not seem to be happening in case of submount. Once
submount is created in guest, I see that we never seem to be calling
->revalidate() on newly created dentry of submount root. I am not sure
why. And that means we don't do FUSE_LOOKUP and that means FUSE_GETATTR
always gets called.

I am not sure if this is a bug or expected behavior. I am not confident
that we can rely on this behavior of submount dentries. 

Ccing Miklos. He might have thoughts on this.

As we discussed, may be it is a better idea to create two inodes in
virtiofsd (like we do in guest). One for submount parent and one for
actual submount.

Thanks
Vivek


> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 104 +++++++++++++++++++++++++++++--
>  1 file changed, 99 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 1553d2ef45..110b6e7e5b 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -968,14 +968,87 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>      return 0;
>  }
>  
> +/*
> + * Use readdir() to find mp_name's inode ID on the parent's filesystem.
> + * (For mount points, stat() will only return the inode ID on the
> + * filesystem mounted there, i.e. the root directory's inode ID.  The
> + * mount point originally was a directory on the parent filesystem,
> + * though, and so has a different inode ID there.  When passing
> + * submount information to the guest, we need to pass this other ID,
> + * so the guest can use it as the inode ID until the submount is
> + * auto-mounted.  (At which point the guest will invoke getattr and
> + * find the inode ID on the submount.))
> + *
> + * Return 0 on success, and -errno otherwise.  *pino is set only in
> + * case of success.
> + */
> +static int get_mp_ino_on_parent(const struct lo_inode *dir, const char *mp_name,
> +                                ino_t *pino)
> +{
> +    int dirfd = -1;
> +    int ret;
> +    DIR *dp = NULL;
> +
> +    dirfd = openat(dir->fd, ".", O_RDONLY);
> +    if (dirfd < 0) {
> +        ret = -errno;
> +        goto out;
> +    }
> +
> +    dp = fdopendir(dirfd);
> +    if (!dp) {
> +        ret = -errno;
> +        goto out;
> +    }
> +    /* Owned by dp now */
> +    dirfd = -1;
> +
> +    while (true) {
> +        struct dirent *de;
> +
> +        errno = 0;
> +        de = readdir(dp);
> +        if (!de) {
> +            ret = errno ? -errno : -ENOENT;
> +            goto out;
> +        }
> +
> +        if (!strcmp(de->d_name, mp_name)) {
> +            *pino = de->d_ino;
> +            ret = 0;
> +            goto out;
> +        }
> +    }
> +
> +out:
> +    if (dp) {
> +        closedir(dp);
> +    }
> +    if (dirfd >= 0) {
> +        close(dirfd);
> +    }
> +    return ret;
> +}
> +
>  /*
>   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
>   * called eventually to decrement nlookup again. If inodep is non-NULL, the
>   * inode pointer is stored and the caller must call lo_inode_put().
> + *
> + * If parent_fs_st_ino is true, the entry is a mount point, and submounts are
> + * announced to the guest, set e->attr.st_ino to the entry's inode ID on its
> + * parent filesystem instead of its inode ID on the filesystem mounted on it.
> + * (For mount points, the entry encompasses two inodes: One on the parent FS,
> + * and one on the mounted FS (where it is the root node), so it has two inode
> + * IDs.  When looking up entries, we should show the guest the parent FS's inode
> + * ID, because as long as the guest has not auto-mounted the submount, it should
> + * see that original ID.  Once it does perform the auto-mount, it will invoke
> + * getattr and see the root node's inode ID.)
>   */
>  static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>                          struct fuse_entry_param *e,
> -                        struct lo_inode **inodep)
> +                        struct lo_inode **inodep,
> +                        bool parent_fs_st_ino)
>  {
>      int newfd;
>      int res;
> @@ -984,6 +1057,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *inode = NULL;
>      struct lo_inode *dir = lo_inode(req, parent);
> +    ino_t ino_id_for_guest;
>  
>      if (inodep) {
>          *inodep = NULL; /* in case there is an error */
> @@ -1018,9 +1092,22 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          goto out_err;
>      }
>  
> +    ino_id_for_guest = e->attr.st_ino;
> +
>      if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
>          (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
>          e->attr_flags |= FUSE_ATTR_SUBMOUNT;
> +
> +        if (parent_fs_st_ino) {
> +            /*
> +             * Best effort, so ignore errors.
> +             * Also note that using readdir() means there may be races:
> +             * The directory entry we find (if any) may be different
> +             * from newfd.  Again, this is a best effort.  Reporting
> +             * the wrong inode ID to the guest is not catastrophic.
> +             */
> +            get_mp_ino_on_parent(dir, name, &ino_id_for_guest);
> +        }
>      }
>  
>      inode = lo_find(lo, &e->attr, mnt_id);
> @@ -1043,6 +1130,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>          inode->nlookup = 1;
>          inode->fd = newfd;
> +        /*
> +         * For the inode key, use the dev/ino/mnt ID as reported by stat()
> +         * (i.e. not ino_id_for_guest)
> +         */
>          inode->key.ino = e->attr.st_ino;
>          inode->key.dev = e->attr.st_dev;
>          inode->key.mnt_id = mnt_id;
> @@ -1058,6 +1149,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      }
>      e->ino = inode->fuse_ino;
>  
> +    /* Report ino_id_for_guest to the guest */
> +    e->attr.st_ino = ino_id_for_guest;
> +
>      /* Transfer ownership of inode pointer to caller or drop it */
>      if (inodep) {
>          *inodep = inode;
> @@ -1104,7 +1198,7 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
>          return;
>      }
>  
> -    err = lo_do_lookup(req, parent, name, &e, NULL);
> +    err = lo_do_lookup(req, parent, name, &e, NULL, true);
>      if (err) {
>          fuse_reply_err(req, err);
>      } else {
> @@ -1217,7 +1311,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>          goto out;
>      }
>  
> -    saverr = lo_do_lookup(req, parent, name, &e, NULL);
> +    saverr = lo_do_lookup(req, parent, name, &e, NULL, false);
>      if (saverr) {
>          goto out;
>      }
> @@ -1714,7 +1808,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
>  
>          if (plus) {
>              if (!is_dot_or_dotdot(name)) {
> -                err = lo_do_lookup(req, ino, name, &e, NULL);
> +                err = lo_do_lookup(req, ino, name, &e, NULL, true);
>                  if (err) {
>                      goto error;
>                  }
> @@ -1936,7 +2030,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>          goto out;
>      }
>  
> -    err = lo_do_lookup(req, parent, name, &e, &inode);
> +    err = lo_do_lookup(req, parent, name, &e, &inode, false);
>      if (err) {
>          goto out;
>      }
> -- 
> 2.31.1
> 
> 

