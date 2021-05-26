Date: Wed, 26 May 2021 14:50:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210526185017.GB1225492@horse>
References: <20210512125544.9536-1-mreitz@redhat.com>
	<20210512125544.9536-2-mreitz@redhat.com>
	<20210526181324.GA1222711@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210526181324.GA1222711@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, May 26, 2021 at 02:13:24PM -0400, Vivek Goyal wrote:
> On Wed, May 12, 2021 at 02:55:42PM +0200, Max Reitz wrote:
> > Mount point directories represent two inodes: On one hand, they are a
> > normal directory on their parent filesystem.  On the other, they are the
> > root node of the filesystem mounted there.  Thus, they have two inode
> > IDs.
> > 
> > Right now, we only report the latter inode ID (i.e. the inode ID of the
> > mounted filesystem's root node).  This is fine once the guest has
> > auto-mounted a submount there (so this inode ID goes with a device ID
> > that is distinct from the parent filesystem), but before the auto-mount,
> > they have the device ID of the parent and the inode ID for the submount.
> > This is problematic because this is likely exactly the same
> > st_dev/st_ino combination as the parent filesystem's root node.  This
> > leads to problems for example with `find`, which will thus complain
> > about a filesystem loop if it has visited the parent filesystem's root
> > node before, and then refuse to descend into the submount.
> > 
> > There is a way to find the mount directory's original inode ID, and that
> > is to readdir(3) the parent directory, look for the mount directory, and
> > read the dirent.d_ino field.  Using this, we can let lookup and
> > readdirplus return that original inode ID, which the guest will thus
> > show until the submount is auto-mounted.
> 
> > (Then, it will invoke getattr
> > and that stat(2) call will return the inode ID for the submount.)
> 
> Hi Max,
> 
> How are we sure that GETATTR() will always be called and that will
> allow us to return inode number in mounted filesystem (instead of
> parent filesystem). I thought GETATTR will be called only if cached
> attrs have expired. (1 second default for cache=auto). Otherwise
> stat() will fill inode->i_no from cache and return. And I am afraid
> that in that case we will return inode number from parent fs,
> instead of mounted fs.
> 
> Say following sequence of events happens pretty fast one after the
> other. Say /mnt/virtiofs/foo is a mount point in server but client
> has not created submount yet.
> 
> A. stat(/mnt/virtiofs/foo, AT_NO_AUTOMOUNT)
>    -> This should get inode number in parent filesystem on host and 
>       store in guest inode->i_no and return to user space. Say inode
>       in guest is called a_ino.
> B. stat(/mnt/virtiofs/foo)
>    -> This should create submount and create new inode (say b_ino), using
>       properties from a_ino. IOW, this should copy a_ino->i_no to
>       b_ino->b_ino given current code, IIUC.
> 
>    -> Assume timeout has not happened and cached attrs have not expired.
> 
>    -> And now b_ino->i_no (or ->orig_ino) will be returned to user space.
> 
> Am I missing something. Do we need to always expire inode attrs when
> we create submount so that client is forced to issue GETATTR.

Looks like while initialzing b_ino, we are setting attr_valid=0, which
should set fi->i_time=0 and force issuing GETATTR later.

fuse_fill_super_submount()
  root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, 0, 0);
                                                         ^
    fuse_iget(attr_valid=0)
       fuse_change_attributes(attr_valid=0)
	  fuse_change_attributes_common(attr_valid=0)
            fi->i_time = attr_valid;

So may be this will force GETATTR and fetch new inode id when second
stat() is called.

Thanks
Vivek

> > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 104 +++++++++++++++++++++++++++++--
> >  1 file changed, 99 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 1553d2ef45..110b6e7e5b 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -968,14 +968,87 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
> >      return 0;
> >  }
> >  
> > +/*
> > + * Use readdir() to find mp_name's inode ID on the parent's filesystem.
> > + * (For mount points, stat() will only return the inode ID on the
> > + * filesystem mounted there, i.e. the root directory's inode ID.  The
> > + * mount point originally was a directory on the parent filesystem,
> > + * though, and so has a different inode ID there.  When passing
> > + * submount information to the guest, we need to pass this other ID,
> > + * so the guest can use it as the inode ID until the submount is
> > + * auto-mounted.  (At which point the guest will invoke getattr and
> > + * find the inode ID on the submount.))
> > + *
> > + * Return 0 on success, and -errno otherwise.  *pino is set only in
> > + * case of success.
> > + */
> > +static int get_mp_ino_on_parent(const struct lo_inode *dir, const char *mp_name,
> > +                                ino_t *pino)
> > +{
> > +    int dirfd = -1;
> > +    int ret;
> > +    DIR *dp = NULL;
> > +
> > +    dirfd = openat(dir->fd, ".", O_RDONLY);
> > +    if (dirfd < 0) {
> > +        ret = -errno;
> > +        goto out;
> > +    }
> > +
> > +    dp = fdopendir(dirfd);
> > +    if (!dp) {
> > +        ret = -errno;
> > +        goto out;
> > +    }
> > +    /* Owned by dp now */
> > +    dirfd = -1;
> > +
> > +    while (true) {
> > +        struct dirent *de;
> > +
> > +        errno = 0;
> > +        de = readdir(dp);
> > +        if (!de) {
> > +            ret = errno ? -errno : -ENOENT;
> > +            goto out;
> > +        }
> > +
> > +        if (!strcmp(de->d_name, mp_name)) {
> > +            *pino = de->d_ino;
> > +            ret = 0;
> > +            goto out;
> > +        }
> > +    }
> > +
> > +out:
> > +    if (dp) {
> > +        closedir(dp);
> > +    }
> > +    if (dirfd >= 0) {
> > +        close(dirfd);
> > +    }
> > +    return ret;
> > +}
> > +
> >  /*
> >   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
> >   * called eventually to decrement nlookup again. If inodep is non-NULL, the
> >   * inode pointer is stored and the caller must call lo_inode_put().
> > + *
> > + * If parent_fs_st_ino is true, the entry is a mount point, and submounts are
> > + * announced to the guest, set e->attr.st_ino to the entry's inode ID on its
> > + * parent filesystem instead of its inode ID on the filesystem mounted on it.
> > + * (For mount points, the entry encompasses two inodes: One on the parent FS,
> > + * and one on the mounted FS (where it is the root node), so it has two inode
> > + * IDs.  When looking up entries, we should show the guest the parent FS's inode
> > + * ID, because as long as the guest has not auto-mounted the submount, it should
> > + * see that original ID.  Once it does perform the auto-mount, it will invoke
> > + * getattr and see the root node's inode ID.)
> >   */
> >  static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >                          struct fuse_entry_param *e,
> > -                        struct lo_inode **inodep)
> > +                        struct lo_inode **inodep,
> > +                        bool parent_fs_st_ino)
> >  {
> >      int newfd;
> >      int res;
> > @@ -984,6 +1057,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >      struct lo_data *lo = lo_data(req);
> >      struct lo_inode *inode = NULL;
> >      struct lo_inode *dir = lo_inode(req, parent);
> > +    ino_t ino_id_for_guest;
> >  
> >      if (inodep) {
> >          *inodep = NULL; /* in case there is an error */
> > @@ -1018,9 +1092,22 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >          goto out_err;
> >      }
> >  
> > +    ino_id_for_guest = e->attr.st_ino;
> > +
> >      if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
> >          (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
> >          e->attr_flags |= FUSE_ATTR_SUBMOUNT;
> > +
> > +        if (parent_fs_st_ino) {
> > +            /*
> > +             * Best effort, so ignore errors.
> > +             * Also note that using readdir() means there may be races:
> > +             * The directory entry we find (if any) may be different
> > +             * from newfd.  Again, this is a best effort.  Reporting
> > +             * the wrong inode ID to the guest is not catastrophic.
> > +             */
> > +            get_mp_ino_on_parent(dir, name, &ino_id_for_guest);
> > +        }
> >      }
> >  
> >      inode = lo_find(lo, &e->attr, mnt_id);
> > @@ -1043,6 +1130,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  
> >          inode->nlookup = 1;
> >          inode->fd = newfd;
> > +        /*
> > +         * For the inode key, use the dev/ino/mnt ID as reported by stat()
> > +         * (i.e. not ino_id_for_guest)
> > +         */
> >          inode->key.ino = e->attr.st_ino;
> >          inode->key.dev = e->attr.st_dev;
> >          inode->key.mnt_id = mnt_id;
> > @@ -1058,6 +1149,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >      }
> >      e->ino = inode->fuse_ino;
> >  
> > +    /* Report ino_id_for_guest to the guest */
> > +    e->attr.st_ino = ino_id_for_guest;
> > +
> >      /* Transfer ownership of inode pointer to caller or drop it */
> >      if (inodep) {
> >          *inodep = inode;
> > @@ -1104,7 +1198,7 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
> >          return;
> >      }
> >  
> > -    err = lo_do_lookup(req, parent, name, &e, NULL);
> > +    err = lo_do_lookup(req, parent, name, &e, NULL, true);
> >      if (err) {
> >          fuse_reply_err(req, err);
> >      } else {
> > @@ -1217,7 +1311,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
> >          goto out;
> >      }
> >  
> > -    saverr = lo_do_lookup(req, parent, name, &e, NULL);
> > +    saverr = lo_do_lookup(req, parent, name, &e, NULL, false);
> >      if (saverr) {
> >          goto out;
> >      }
> > @@ -1714,7 +1808,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
> >  
> >          if (plus) {
> >              if (!is_dot_or_dotdot(name)) {
> > -                err = lo_do_lookup(req, ino, name, &e, NULL);
> > +                err = lo_do_lookup(req, ino, name, &e, NULL, true);
> >                  if (err) {
> >                      goto error;
> >                  }
> > @@ -1936,7 +2030,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >          goto out;
> >      }
> >  
> > -    err = lo_do_lookup(req, parent, name, &e, &inode);
> > +    err = lo_do_lookup(req, parent, name, &e, &inode, false);
> >      if (err) {
> >          goto out;
> >      }
> > -- 
> > 2.31.1
> > 
> > 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

