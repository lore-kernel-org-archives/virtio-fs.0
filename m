Date: Thu, 27 May 2021 18:56:00 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK/dMFhgHfohXg7V@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-21-dgilbert@redhat.com>
	<YJQKBfZ+++VUiSOO@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQKBfZ+++VUiSOO@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 20/26] DAX/unmap virtiofsd: Parse
	unmappable elements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:54PM +0100, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > For some read/writes the virtio queue elements are unmappable by
> > the daemon; these are cases where the data is to be read/written
> > from non-RAM.  In viritofs's case this is typically a direct read/write
> 
> s/viritofs/virtiofs/

Eventually I'll stop making that typo.

> > into an mmap'd DAX file also on virtiofs (possibly on another instance).
> > 
> > When we receive a virtio queue element, check that we have enough
> > mappable data to handle the headers.  Make a note of the number of
> > unmappable 'in' entries (ie. for read data back to the VMM),
> > and flag the fuse_bufvec for 'out' entries with a new flag
> > FUSE_BUF_PHYS_ADDR.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > with fix by:
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  tools/virtiofsd/buffer.c      |   4 +-
> >  tools/virtiofsd/fuse_common.h |   7 ++
> >  tools/virtiofsd/fuse_virtio.c | 230 ++++++++++++++++++++++++----------
> >  3 files changed, 173 insertions(+), 68 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
> > index 874f01c488..1a050aa441 100644
> > --- a/tools/virtiofsd/buffer.c
> > +++ b/tools/virtiofsd/buffer.c
> > @@ -77,6 +77,7 @@ static ssize_t fuse_buf_write(const struct fuse_buf *dst, size_t dst_off,
> >      ssize_t res = 0;
> >      size_t copied = 0;
> >  
> > +    assert(!(src->flags & FUSE_BUF_PHYS_ADDR));
> >      while (len) {
> >          if (dst->flags & FUSE_BUF_FD_SEEK) {
> >              res = pwrite(dst->fd, (char *)src->mem + src_off, len,
> > @@ -272,7 +273,8 @@ ssize_t fuse_buf_copy(struct fuse_bufvec *dstv, struct fuse_bufvec *srcv)
> >       * process
> >       */
> >      for (i = 0; i < srcv->count; i++) {
> > -        if (srcv->buf[i].flags & FUSE_BUF_IS_FD) {
> > +        if ((srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR) ||
> > +            (srcv->buf[i].flags & FUSE_BUF_IS_FD)) {
> >              break;
> >          }
> >      }
> > diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> > index fa9671872e..af43cf19f9 100644
> > --- a/tools/virtiofsd/fuse_common.h
> > +++ b/tools/virtiofsd/fuse_common.h
> > @@ -626,6 +626,13 @@ enum fuse_buf_flags {
> >       * detected.
> >       */
> >      FUSE_BUF_FD_RETRY = (1 << 3),
> > +
> > +    /**
> > +     * The addresses in the iovec represent guest physical addresses
> > +     * that can't be mapped by the daemon process.
> > +     * IO must be bounced back to the VMM to do it.
> > +     */
> > +    FUSE_BUF_PHYS_ADDR = (1 << 4),
> 
> Based on the previous patch this is not a gpa, it's an IOVA. Depending
> on the virtiofs device's DMA address space in QEMU this might be the
> same as guest physical addresses but there could also be vIOMMU
> translation (see the address_space_translate() call in the patch that
> implemented the IO slave command).

I've changed that comment to:
    /**
     * The addresses in the iovec represent guest physical addresses
     * (or IOVA when used with an IOMMU) * that can't be mapped by the
     * daemon process.
     * IO must be bounced back to the VMM to do it.

> Maybe virtiofs + vIOMMU has never been tested though... I'm not sure it
> works today.

It has and it definitely doesn't work yet.

> If you want to leave it as is, feel free:
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

