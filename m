Date: Thu, 11 Mar 2021 14:58:09 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YEowAVzkMBo1oKTU@work-vm>
References: <20210304174536.54446-1-dgilbert@redhat.com>
	<YEZNTFOT2noej13i@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEZNTFOT2noej13i@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't assume header layout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, Mar 04, 2021 at 05:45:36PM +0000, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > virtiofsd incorrectly assumed a fixed set of header layout in the virt
> > queue; assuming that the fuse and write headers were conveniently
> > separated from the data;  the spec doesn't allow us to take that
> > convenience, so fix it up to deal with it the hard way.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c | 84 ++++++++++++++++++++++++++---------
> >  1 file changed, 63 insertions(+), 21 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> > index 523ee64fb7..55e2e057ec 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -129,18 +129,55 @@ static void fv_panic(VuDev *dev, const char *err)
> >   * Copy from an iovec into a fuse_buf (memory only)
> >   * Caller must ensure there is space
> >   */
> > -static void copy_from_iov(struct fuse_buf *buf, size_t out_num,
> > -                          const struct iovec *out_sg)
> > +static size_t copy_from_iov(struct fuse_buf *buf, size_t out_num,
> > +                            const struct iovec *out_sg,
> > +                            size_t max)
> >  {
> >      void *dest = buf->mem;
> > +    size_t copied = 0;
> >  
> > -    while (out_num) {
> > +    while (out_num && max) {
> >          size_t onelen = out_sg->iov_len;
> > +        onelen = MIN(onelen, max);
> >          memcpy(dest, out_sg->iov_base, onelen);
> >          dest += onelen;
> > +        copied += onelen;
> >          out_sg++;
> >          out_num--;
> > +        max -= onelen;
> >      }
> > +
> > +    return copied;
> > +}
> > +
> > +/*
> > + * Skip 'skip' bytes in the iov; 'sg_1stindex' is set as
> > + * the index for the 1st iovec to read data from, and
> > + * 'sg_1stskip' is the number of bytes to skip in that entry.
> > + *
> > + * Returns True if there are at least 'skip' bytes in the iovec
> > + *
> > + */
> > +static bool skip_iov(const struct iovec *sg, size_t sg_size,
> > +                     size_t skip,
> > +                     size_t *sg_1stindex, size_t *sg_1stskip)
> > +{
> > +    size_t vec;
> > +
> > +    for (vec = 0; vec < sg_size; vec++) {
> > +        if (sg[vec].iov_len > skip) {
> > +            *sg_1stskip = skip;
> > +            *sg_1stindex = vec;
> > +
> > +            return true;
> > +        }
> > +
 (1)         skip -= sg[vec].iov_len;
> > +    }
> > +
 (2)     *sg_1stindex = vec;
> > +    *sg_1stskip = 0;
 (3)     return skip == 0;
> >  }
> 
> This comment does not match the code: "Returns True if there are at
> least 'skip' bytes in the iovec". When skip == iov_length(sg, sg_size)
> the function returns false.

I'm not seeing how; in that case, it'll loop around executing (1) for
each vector, so skip will reduce, then it falls out of the for loop
and if it was equal to the size of the vector, (1) would have subtracted
the whole vector out, so skip would now be 0, hence the 'skip == 0' at 2 and
so it should return true.

> >  
> >  /*
> > @@ -505,14 +542,14 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> >                   elem->index);
> >          assert(0); /* TODO */
> >      }
> > -    /* Copy just the first element and look at it */
> > -    copy_from_iov(&fbuf, 1, out_sg);
> > +    /* Copy just the fuse_in_header and look at it */
> > +    copy_from_iov(&fbuf, out_num, out_sg,
> > +                  sizeof(struct fuse_in_header));
> >  
> >      pbufv = NULL; /* Compiler thinks an unitialised path */
> > -    if (out_num > 2 &&
> > -        out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
> > -        ((struct fuse_in_header *)fbuf.mem)->opcode == FUSE_WRITE &&
> > -        out_sg[1].iov_len == sizeof(struct fuse_write_in)) {
> > +    if (((struct fuse_in_header *)fbuf.mem)->opcode == FUSE_WRITE &&
> > +        out_len >= (sizeof(struct fuse_in_header) +
> > +                    sizeof(struct fuse_write_in))) {
> >          /*
> >           * For a write we don't actually need to copy the
> >           * data, we can just do it straight out of guest memory
> > @@ -521,15 +558,13 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> >           */
> >          fuse_log(FUSE_LOG_DEBUG, "%s: Write special case\n", __func__);
> >  
> > -        /* copy the fuse_write_in header afte rthe fuse_in_header */
> > -        fbuf.mem += out_sg->iov_len;
> > -        copy_from_iov(&fbuf, 1, out_sg + 1);
> > -        fbuf.mem -= out_sg->iov_len;
> > -        fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
> > +        fbuf.size = copy_from_iov(&fbuf, out_num, out_sg,
> > +                                  sizeof(struct fuse_in_header) +
> > +                                  sizeof(struct fuse_write_in));
> >  
> >          /* Allocate the bufv, with space for the rest of the iov */
> >          pbufv = malloc(sizeof(struct fuse_bufvec) +
> > -                       sizeof(struct fuse_buf) * (out_num - 2));
> > +                       sizeof(struct fuse_buf) * out_num);
> >          if (!pbufv) {
> >              fuse_log(FUSE_LOG_ERR, "%s: pbufv malloc failed\n",
> >                      __func__);
> > @@ -540,24 +575,31 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
> >          pbufv->count = 1;
> >          pbufv->buf[0] = fbuf;
> >  
> > -        size_t iovindex, pbufvindex;
> > -        iovindex = 2; /* 2 headers, separate iovs */
> > +        size_t iovindex, pbufvindex, skip;
> >          pbufvindex = 1; /* 2 headers, 1 fusebuf */
> >  
> > +        skip_iov(out_sg, out_num,
> > +                 sizeof(struct fuse_in_header) +
> > +                 sizeof(struct fuse_write_in),
> > +                 &iovindex, &skip);
> > +
> >          for (; iovindex < out_num; iovindex++, pbufvindex++) {
> 
> What happens when iov_length(out_sg, out_num) == sizeof(struct
> fuse_in_header) + sizeof(struct fuse_write_in)? I think it will add a
> bogus pbufv element.

skip_iov should have set iovindex=out_num in that case and so that loop
won't happen.

Dave

> >              pbufv->count++;
> >              pbufv->buf[pbufvindex].pos = ~0; /* Dummy */
> >              pbufv->buf[pbufvindex].flags = 0;
> >              pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
> >              pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
> > +
> > +            if (skip) {
> > +                pbufv->buf[pbufvindex].mem += skip;
> > +                pbufv->buf[pbufvindex].size -= skip;
> > +                skip = 0;
> > +            }
> >          }
> >      } else {
> >          /* Normal (non fast write) path */
> >  
> > -        /* Copy the rest of the buffer */
> > -        fbuf.mem += out_sg->iov_len;
> > -        copy_from_iov(&fbuf, out_num - 1, out_sg + 1);
> > -        fbuf.mem -= out_sg->iov_len;
> > +        copy_from_iov(&fbuf, out_num, out_sg, se->bufsize);
> >          fbuf.size = out_len;
> >  
> >          /* TODO! Endianness of header */
> > -- 
> > 2.29.2
> > 


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

