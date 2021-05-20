Date: Thu, 20 May 2021 12:28:43 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKZH69V8ZZvtF3kF@work-vm>
References: <20210512125544.9536-1-mreitz@redhat.com>
	<20210512125544.9536-2-mreitz@redhat.com>
	<20210517145739.GE546943@horse.lan>
	<13641be2-e875-ca43-1cc4-8d06a4e6f81c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13641be2-e875-ca43-1cc4-8d06a4e6f81c@redhat.com>
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Max Reitz (mreitz@redhat.com) wrote:
> On 17.05.21 16:57, Vivek Goyal wrote:
> > On Wed, May 12, 2021 at 02:55:42PM +0200, Max Reitz wrote:
> > > Mount point directories represent two inodes: On one hand, they are a
> > > normal directory on their parent filesystem.  On the other, they are the
> > > root node of the filesystem mounted there.  Thus, they have two inode
> > > IDs.
> > > 
> > > Right now, we only report the latter inode ID (i.e. the inode ID of the
> > > mounted filesystem's root node).  This is fine once the guest has
> > > auto-mounted a submount there (so this inode ID goes with a device ID
> > > that is distinct from the parent filesystem), but before the auto-mount,
> > > they have the device ID of the parent and the inode ID for the submount.
> > > This is problematic because this is likely exactly the same
> > > st_dev/st_ino combination as the parent filesystem's root node.  This
> > > leads to problems for example with `find`, which will thus complain
> > > about a filesystem loop if it has visited the parent filesystem's root
> > > node before, and then refuse to descend into the submount.
> > > 
> > > There is a way to find the mount directory's original inode ID, and that
> > > is to readdir(3) the parent directory, look for the mount directory, and
> > > read the dirent.d_ino field.  Using this, we can let lookup and
> > > readdirplus return that original inode ID, which the guest will thus
> > > show until the submount is auto-mounted.  (Then, it will invoke getattr
> > > and that stat(2) call will return the inode ID for the submount.)
> > > 
> > > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > > ---
> > >   tools/virtiofsd/passthrough_ll.c | 104 +++++++++++++++++++++++++++++--
> > >   1 file changed, 99 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > index 1553d2ef45..110b6e7e5b 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -968,14 +968,87 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
> > >       return 0;
> > >   }
> > > +/*
> > > + * Use readdir() to find mp_name's inode ID on the parent's filesystem.
> > > + * (For mount points, stat() will only return the inode ID on the
> > > + * filesystem mounted there, i.e. the root directory's inode ID.  The
> > > + * mount point originally was a directory on the parent filesystem,
> > > + * though, and so has a different inode ID there.  When passing
> > > + * submount information to the guest, we need to pass this other ID,
> > > + * so the guest can use it as the inode ID until the submount is
> > > + * auto-mounted.  (At which point the guest will invoke getattr and
> > > + * find the inode ID on the submount.))
> > > + *
> > > + * Return 0 on success, and -errno otherwise.  *pino is set only in
> > > + * case of success.
> > > + */
> > > +static int get_mp_ino_on_parent(const struct lo_inode *dir, const char *mp_name,
> > > +                                ino_t *pino)
> > > +{
> > > +    int dirfd = -1;
> > > +    int ret;
> > > +    DIR *dp = NULL;
> > > +
> > > +    dirfd = openat(dir->fd, ".", O_RDONLY);
> > > +    if (dirfd < 0) {
> > > +        ret = -errno;
> > > +        goto out;
> > > +    }
> > > +
> > > +    dp = fdopendir(dirfd);
> > > +    if (!dp) {
> > > +        ret = -errno;
> > > +        goto out;
> > > +    }
> > > +    /* Owned by dp now */
> > > +    dirfd = -1;
> > > +
> > > +    while (true) {
> > > +        struct dirent *de;
> > > +
> > > +        errno = 0;
> > > +        de = readdir(dp);
> > > +        if (!de) {
> > > +            ret = errno ? -errno : -ENOENT;
> > > +            goto out;
> > > +        }
> > > +
> > > +        if (!strcmp(de->d_name, mp_name)) {
> > > +            *pino = de->d_ino;
> > > +            ret = 0;
> > > +            goto out;
> > > +        }
> > > +    }
> > > +
> > > +out:
> > > +    if (dp) {
> > > +        closedir(dp);
> > > +    }
> > > +    if (dirfd >= 0) {
> > > +        close(dirfd);
> > > +    }
> > > +    return ret;
> > > +}
> > > +
> > >   /*
> > >    * Increments nlookup on the inode on success. unref_inode_lolocked() must be
> > >    * called eventually to decrement nlookup again. If inodep is non-NULL, the
> > >    * inode pointer is stored and the caller must call lo_inode_put().
> > > + *
> > > + * If parent_fs_st_ino is true, the entry is a mount point, and submounts are
> > > + * announced to the guest, set e->attr.st_ino to the entry's inode ID on its
> > > + * parent filesystem instead of its inode ID on the filesystem mounted on it.
> > > + * (For mount points, the entry encompasses two inodes: One on the parent FS,
> > > + * and one on the mounted FS (where it is the root node), so it has two inode
> > > + * IDs.  When looking up entries, we should show the guest the parent FS's inode
> > > + * ID, because as long as the guest has not auto-mounted the submount, it should
> > > + * see that original ID.  Once it does perform the auto-mount, it will invoke
> > > + * getattr and see the root node's inode ID.)
> > >    */
> > >   static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >                           struct fuse_entry_param *e,
> > > -                        struct lo_inode **inodep)
> > > +                        struct lo_inode **inodep,
> > > +                        bool parent_fs_st_ino)
> > >   {
> > >       int newfd;
> > >       int res;
> > > @@ -984,6 +1057,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >       struct lo_data *lo = lo_data(req);
> > >       struct lo_inode *inode = NULL;
> > >       struct lo_inode *dir = lo_inode(req, parent);
> > > +    ino_t ino_id_for_guest;
> > >       if (inodep) {
> > >           *inodep = NULL; /* in case there is an error */
> > > @@ -1018,9 +1092,22 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > >           goto out_err;
> > >       }
> > > +    ino_id_for_guest = e->attr.st_ino;
> > > +
> > >       if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
> > >           (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
> > >           e->attr_flags |= FUSE_ATTR_SUBMOUNT;
> > > +
> > > +        if (parent_fs_st_ino) {
> > > +            /*
> > > +             * Best effort, so ignore errors.
> > > +             * Also note that using readdir() means there may be races:
> > > +             * The directory entry we find (if any) may be different
> > > +             * from newfd.  Again, this is a best effort.  Reporting
> > > +             * the wrong inode ID to the guest is not catastrophic.
> > > +             */
> > > +            get_mp_ino_on_parent(dir, name, &ino_id_for_guest);
> > 
> > Hi Max,
> > 
> > [CC virtio-fs list ]
> > 
> > In general patch looks good to me. A minor nit. get_mp_ino_on_parent()
> > is retruning error. It might be better to capture error and print a
> > message and continue.
> 
> Sure, why not.
> 
> > I have couple of general questions about submounts.
> > 
> > - What happens in case of single file mounted on top of another file.
> > 
> >    mount --bind foo.txt bar.txt
> > 
> > Do submounts work when mount point is not a directory.
> 
> No, as you can see in the condition quoted above, we only set the
> FUSE_ATTR_SUBMOUNT flag for directories.  That seemed the most common case
> for me, and I didn’t want to have to worry about weirdness that might ensue
> for file mounts.

It might be worth checking file mounts don't break too badly; I'm pretty
sure I've seen the container systems use them a lot in /etc

Dave

> > - Say a directory is not a mount point yet and lookup instantiates an
> >    inode. Later user mounts something on that directory. When does
> >    client/server notice this change. I am assuming this is probably
> >    part of revalidation path.
> 
> I guess at least before this patch this is no different from any other
> filesystem change.  Because st_dev+st_ino changed, it should basically look
> like the old directory was removed and a different one was put in its place.
> 
> Now, with this patch, we will return the old st_ino to the guest, but
> internally virtiofsd will still use the submount’s st_dev/st_ino, so a new
> lo_inode should be created, and so fuse_dentry_revalidate()’s lookup should
> return a different node ID, resulting it to consider the entry expired.
> 
> Besides, fuse_dentry_revalidate() has a condition on IS_AUTOMOUNT(inode) !=
> flags & FUSE_ATTR_SUBMOUNT.  Considering the previous paragraph, this
> doesn’t seem necessary to me, but it can’t hurt.
> 
> Max
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

