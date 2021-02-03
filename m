Date: Wed, 3 Feb 2021 14:47:30 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210203144730.GJ2950@work-vm>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-2-stefanha@redhat.com>
	<20210203152035.374924b9@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203152035.374924b9@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v4 1/3] virtiofsd: extract lo_do_open() from
	lo_open()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

* Greg Kurz (groug@kaod.org) wrote:
> On Wed,  3 Feb 2021 11:37:17 +0000
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
> 
> > Both lo_open() and lo_create() have similar code to open a file. Extract
> > a common lo_do_open() function from lo_open() that will be used by
> > lo_create() in a later commit.
> > 
> > Since lo_do_open() does not otherwise need fuse_req_t req, convert
> > lo_add_fd_mapping() to use struct lo_data *lo instead.
> > 
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> 
> With the s/ENOMEM/-ENOMEM/ change in lo_do_open() suggested by patchew,

Isn't it actually the return -errno that's different from the original?

Dave

> Reviewed-by: Greg Kurz <groug@kaod.org>
> 
> >  tools/virtiofsd/passthrough_ll.c | 73 ++++++++++++++++++++------------
> >  1 file changed, 46 insertions(+), 27 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 5fb36d9407..e63cbd3fb7 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -459,17 +459,17 @@ static void lo_map_remove(struct lo_map *map, size_t key)
> >  }
> >  
> >  /* Assumes lo->mutex is held */
> > -static ssize_t lo_add_fd_mapping(fuse_req_t req, int fd)
> > +static ssize_t lo_add_fd_mapping(struct lo_data *lo, int fd)
> >  {
> >      struct lo_map_elem *elem;
> >  
> > -    elem = lo_map_alloc_elem(&lo_data(req)->fd_map);
> > +    elem = lo_map_alloc_elem(&lo->fd_map);
> >      if (!elem) {
> >          return -1;
> >      }
> >  
> >      elem->fd = fd;
> > -    return elem - lo_data(req)->fd_map.elems;
> > +    return elem - lo->fd_map.elems;
> >  }
> >  
> >  /* Assumes lo->mutex is held */
> > @@ -1651,6 +1651,38 @@ static void update_open_flags(int writeback, int allow_direct_io,
> >      }
> >  }
> >  
> > +static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
> > +                      struct fuse_file_info *fi)
> > +{
> > +    char buf[64];
> > +    ssize_t fh;
> > +    int fd;
> > +
> > +    update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > +
> > +    sprintf(buf, "%i", inode->fd);
> > +    fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> > +    if (fd == -1) {
> > +        return -errno;
> > +    }
> > +
> > +    pthread_mutex_lock(&lo->mutex);
> > +    fh = lo_add_fd_mapping(lo, fd);
> > +    pthread_mutex_unlock(&lo->mutex);
> > +    if (fh == -1) {
> > +        close(fd);
> > +        return ENOMEM;
> > +    }
> > +
> > +    fi->fh = fh;
> > +    if (lo->cache == CACHE_NONE) {
> > +        fi->direct_io = 1;
> > +    } else if (lo->cache == CACHE_ALWAYS) {
> > +        fi->keep_cache = 1;
> > +    }
> > +    return 0;
> > +}
> > +
> >  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >                        mode_t mode, struct fuse_file_info *fi)
> >  {
> > @@ -1691,7 +1723,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> >          ssize_t fh;
> >  
> >          pthread_mutex_lock(&lo->mutex);
> > -        fh = lo_add_fd_mapping(req, fd);
> > +        fh = lo_add_fd_mapping(lo, fd);
> >          pthread_mutex_unlock(&lo->mutex);
> >          if (fh == -1) {
> >              close(fd);
> > @@ -1892,38 +1924,25 @@ static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
> >  
> >  static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
> >  {
> > -    int fd;
> > -    ssize_t fh;
> > -    char buf[64];
> >      struct lo_data *lo = lo_data(req);
> > +    struct lo_inode *inode = lo_inode(req, ino);
> > +    int err;
> >  
> >      fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d)\n", ino,
> >               fi->flags);
> >  
> > -    update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > -
> > -    sprintf(buf, "%i", lo_fd(req, ino));
> > -    fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> > -    if (fd == -1) {
> > -        return (void)fuse_reply_err(req, errno);
> > -    }
> > -
> > -    pthread_mutex_lock(&lo->mutex);
> > -    fh = lo_add_fd_mapping(req, fd);
> > -    pthread_mutex_unlock(&lo->mutex);
> > -    if (fh == -1) {
> > -        close(fd);
> > -        fuse_reply_err(req, ENOMEM);
> > +    if (!inode) {
> > +        fuse_reply_err(req, EBADF);
> >          return;
> >      }
> >  
> > -    fi->fh = fh;
> > -    if (lo->cache == CACHE_NONE) {
> > -        fi->direct_io = 1;
> > -    } else if (lo->cache == CACHE_ALWAYS) {
> > -        fi->keep_cache = 1;
> > +    err = lo_do_open(lo, inode, fi);
> > +    lo_inode_put(lo, &inode);
> > +    if (err) {
> > +        fuse_reply_err(req, err);
> > +    } else {
> > +        fuse_reply_open(req, fi);
> >      }
> > -    fuse_reply_open(req, fi);
> >  }
> >  
> >  static void lo_release(fuse_req_t req, fuse_ino_t ino,
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

