DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=KXMemJT2f77C1JBuIAswqv8Bg/L6wBojfSBZAvpysjw=;
	b=zWd+j7DAtQ4CxFXZMmqJCyqGK352t4yjMo2K5x8QbfnjZeKZM26uMgV4I5exC3/XOu
	B+zqUAaJgLxuGp10B97p2cKuiWYONw2D4iCNA8UJaR9zlInd5BkNx2cgkeFa5IAUykud
	a4onldWLL0YXP3jalqkyxSsTWktNcnkTXy/mi+TuSa9Ff5Iau01uy0ybY1nOB7z8FnHW
	FjYKMsra1wiAJmO8cGdhuEssbL+kM8AFL+Hn3hrNPHu1W7pKujtp42Rr8V9genzZHhMz
	h88zyOqt7yUzw/8MhK+DPnqJe2uOVpyJQly06wrOYOF7bVR07AvcnHBa6FCYIrnlVh5j
	KJUA==
MIME-Version: 1.0
References: <20190513144144.21646-1-tao.peng@linux.alibaba.com>
	<20190522112655.GB2666@work-vm>
In-Reply-To: <20190522112655.GB2666@work-vm>
From: Tao Peng <bergwolf@hyper.sh>
Date: Fri, 24 May 2019 12:21:31 +0800
Message-ID: <CACGKRzXqF90h5fRSOM6HXNG3ojraj5PRj98i11FJqq_w8cp2eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: make FUSE_REMOVEMAPPING support
 multiple entries
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, mszeredi@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, May 22, 2019 at 7:27 PM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Peng Tao (tao.peng@linux.alibaba.com) wrote:
> > The fuse wire protocol is changed so that we can unmap multiple
> > mappings in a single call.
> >
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
>
> Hi,
>   Thanks for the patch and apologies for not responding sooner
>
> > ---
> >  contrib/virtiofsd/fuse_kernel.h    |  9 +++++++--
> >  contrib/virtiofsd/fuse_lowlevel.c  | 21 ++++++++++++++------
> >  contrib/virtiofsd/fuse_lowlevel.h  |  5 +++--
> >  contrib/virtiofsd/passthrough_ll.c | 31 ++++++++++++++++++++----------
> >  4 files changed, 46 insertions(+), 20 deletions(-)
> >
> > diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
> > index ce46046a4f..093cacff02 100644
> > --- a/contrib/virtiofsd/fuse_kernel.h
> > +++ b/contrib/virtiofsd/fuse_kernel.h
> > @@ -830,9 +830,14 @@ struct fuse_setupmapping_out {
> >          uint64_t        len[FUSE_SETUPMAPPING_ENTRIES];
> >  };
> >
> > -struct fuse_removemapping_in {
> > +struct fuse_removemapping_in_header {
> >          /* An already open handle */
> > -     uint64_t        fh;
> > +        uint64_t        fh;
> > +        /* number of fuse_removemapping_in follows */
> > +        unsigned        num;
>
> I think all fields in fuse structures are fixed length - e.g. uint32_t
> or uint64_t.
>
> > +};
> > +
> > +struct fuse_removemapping_in {
> >          /* Offset into the dax to start the unmapping */
> >          uint64_t        moffset;
> >          /* Length of mapping required */
>
> Miklos: Does this make sense for a fuse structure? It's that header
> followed by 'num' of fuse_removemapping_in.
>
>
> This is an interface change so we do have to coordinate with your kernel
> change.
>
Yes, please see "[Virtio-fs] [PATCH-v2 2/2] virtiofs:
FUSE_REMOVEMAPPING support multiple removing multiple entries" for the
kernel part of the change.

> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index 111c6e1636..4619865c2c 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -1907,21 +1907,30 @@ static void do_setupmapping(fuse_req_t req, fuse_ino_t nodeid,
> >  static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> >                            struct fuse_mbuf_iter *iter)
> >  {
> > -     struct fuse_removemapping_in *arg;
> > +     struct fuse_removemapping_in_header *header;
> > +     struct fuse_removemapping_in *argp;
> >          struct fuse_file_info fi;
> >
> > -     arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> > -     if (!arg) {
> > +     header = fuse_mbuf_iter_advance(iter, sizeof(*header));
> > +     if (!header || header->num <= 0) {
> > +             fprintf(stderr, "do_removemapping: invalid header %p\n", header);
> > +             fuse_reply_err(req, EINVAL);
> > +             return;
> > +     }
> > +
> > +     argp = fuse_mbuf_iter_advance(iter, header->num * sizeof(*argp));
> > +     if (!argp) {
> > +             fprintf(stderr, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
> > +                             header->num, sizeof(*argp), iter->size, iter->pos);
> >               fuse_reply_err(req, EINVAL);
> >               return;
> >       }
> >          memset(&fi, 0, sizeof(fi));
> > -     fi.fh = arg->fh;
> > +     fi.fh = header->fh;
> >
> >       if (req->se->op.removemapping)
> > -             req->se->op.removemapping(req, req->se, nodeid, arg->moffset,
> > -                                          arg->len, &fi);
> > +             req->se->op.removemapping(req, req->se, nodeid, header->num, argp, &fi);
> >       else
> >               fuse_reply_err(req, ENOSYS);
> >  }
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
> > index 6a001c4605..b2b8747074 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.h
> > +++ b/contrib/virtiofsd/fuse_lowlevel.h
> > @@ -23,6 +23,7 @@
> >  #endif
> >
> >  #include "fuse_common.h"
> > +#include "fuse_kernel.h"
> >
> >  #include <utime.h>
> >  #include <fcntl.h>
> > @@ -1200,8 +1201,8 @@ struct fuse_lowlevel_ops {
> >           * TODO
> >           */
> >          void (*removemapping) (fuse_req_t req, struct fuse_session *se,
> > -                               fuse_ino_t ino, uint64_t moffset,
> > -                               uint64_t len, struct fuse_file_info *fi);
> > +                               fuse_ino_t ino, unsigned num,
> > +                               struct fuse_removemapping_in *args, struct fuse_file_info *fi);
> >  };
> >
> >  /**
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index 1ddb68f1db..96d5468ead 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1925,20 +1925,31 @@ err:
> >  }
> >
> >  static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
> > -                             fuse_ino_t ino, uint64_t moffset,
> > -                             uint64_t len, struct fuse_file_info *fi)
> > +                             fuse_ino_t ino, unsigned num,
> > +                          struct fuse_removemapping_in *argsp,
> > +                          struct fuse_file_info *fi)
> >  {
> >          VhostUserFSSlaveMsg msg = { 0 };
> >       int ret = 0;
> >
> > -     msg.len[0] = len;
> > -     msg.c_offset[0] = moffset;
> > -        if (fuse_virtio_unmap(se, &msg)) {
> > -                fprintf(stderr,
> > -                        "%s: unmap over virtio failed "
> > -                        "(offset=0x%lx, len=0x%lx)\n", __func__, moffset, len);
> > -                ret = EINVAL;
> > -        }
> > +     for (int i = 0; num > 0; i++, argsp++) {
>
> Probably best to make 'i' unsigned as well.
>
Thanks for reviewing. I'll change the patch as suggested.

Cheers,
Tao

-- 
bergwolf@hyper.sh

