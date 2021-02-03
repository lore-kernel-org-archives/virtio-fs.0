Date: Wed, 3 Feb 2021 16:14:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210203211441.GH3307@redhat.com>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-4-stefanha@redhat.com>
	<20210203152850.GA3307@redhat.com>
	<20210203170237.0c98f95f@bahia.lan>
	<20210203160858.GC3307@redhat.com>
	<20210203170514.GL74271@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203170514.GL74271@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v4 3/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>

On Wed, Feb 03, 2021 at 05:05:14PM +0000, Stefan Hajnoczi wrote:
> On Wed, Feb 03, 2021 at 11:08:58AM -0500, Vivek Goyal wrote:
> > On Wed, Feb 03, 2021 at 05:02:37PM +0100, Greg Kurz wrote:
> > > On Wed, 3 Feb 2021 10:28:50 -0500
> > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > On Wed, Feb 03, 2021 at 11:37:19AM +0000, Stefan Hajnoczi wrote:
> > > > 
> > > > [..]
> > > > > @@ -1727,36 +1764,38 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
> > > > >  
> > > > >      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
> > > > >  
> > > > > -    fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
> > > > > -                mode);
> > > > > +    /* Try to create a new file but don't open existing files */
> > > > > +    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
> > > > >      err = fd == -1 ? errno : 0;
> > > > > +
> > > > >      lo_restore_cred(&old);
> > > > >  
> > > > > -    if (!err) {
> > > > > -        ssize_t fh;
> > > > > -
> > > > > -        pthread_mutex_lock(&lo->mutex);
> > > > > -        fh = lo_add_fd_mapping(lo, fd);
> > > > > -        pthread_mutex_unlock(&lo->mutex);
> > > > > -        if (fh == -1) {
> > > > > -            close(fd);
> > > > > -            err = ENOMEM;
> > > > > -            goto out;
> > > > > -        }
> > > > > +    /* Ignore the error if file exists and O_EXCL was not given */
> > > > > +    if (err && !(err == EEXIST && !(fi->flags & O_EXCL))) {
> > > > 
> > > > Can this check be simplified to.
> > > >        if (err && (err == EEXIST && (fi->flags & O_EXCL)) {
> > > 
> > > I guess you meant :
> > > 
> > >         if (err && (err != EEXIST || fi->flags & O_EXCL) {
> > 
> > This sounds correct. I forgot to take into account that if error is
> > not -EEXIST, we still want to bail out irrespective of O_EXCL.
> 
> I thought about De Morgan's law too but found the OR expression is not
> easier to read than the AND expression :(. If you prefer it written this
> way I can change it though.

I personally find this one to read. And not because of AND but because
of double logical negation (!x) in previous expression.

But I am not particular about it. If you don't find it easier to
read, I can live with previous one.

Vivek

