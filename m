Date: Mon, 28 Jun 2021 10:54:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210628145453.GA1818333@redhat.com>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
	<20210622150852.1507204-2-vgoyal@redhat.com>
	<YNng0CPIFHxDIE3a@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNng0CPIFHxDIE3a@work-vm>
Subject: Re: [Virtio-fs] [PATCH v7 1/7] virtiofsd: Fix fuse setxattr() API
 change issue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Nikolaus Rath <Nikolaus@rath.org>, qemu-devel@nongnu.org, miklos@szeredi.hu

On Mon, Jun 28, 2021 at 03:46:40PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > With kernel header updates fuse_setxattr_in struct has grown in size.
> > But this new struct size only takes affect if user has opted in
> > for fuse feature FUSE_SETXATTR_EXT otherwise fuse continues to
> > send "fuse_setxattr_in" of older size. Older size is determined
> > by FUSE_COMPAT_SETXATTR_IN_SIZE.
> > 
> > Fix this. If we have not opted in for FUSE_SETXATTR_EXT, then
> > expect that we will get fuse_setxattr_in of size FUSE_COMPAT_SETXATTR_IN_SIZE
> > and not sizeof(struct fuse_sexattr_in).
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Yeh it's a bit of a grim fix, but I think it's the best we can do, and
> we need to get it in since the headers have already been merged.
> (I don't think libfuse has a fix for this in yet itself, but it might
> survive because it doesn't bother copying the data like we do with
> mbuf).

[ CC Niklaus Rath]

libfuse will need a fix as well once they move to 5.13 kernel headers.
As of now they seem to be still working with 5.2 kernel headers.

commit 249942f6411042c4af18bd10438da34801cce02b
Author: Kirill Smelkov <kirr@nexedi.com>
Date:   Tue Jul 9 23:54:09 2019 +0300

    Sync fuse_kernel.h with Linux 5.2 (#433)

Thanks
Vivek

> 
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> > ---
> >  tools/virtiofsd/fuse_common.h   | 5 +++++
> >  tools/virtiofsd/fuse_lowlevel.c | 7 ++++++-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> > index fa9671872e..0c2665b977 100644
> > --- a/tools/virtiofsd/fuse_common.h
> > +++ b/tools/virtiofsd/fuse_common.h
> > @@ -372,6 +372,11 @@ struct fuse_file_info {
> >   */
> >  #define FUSE_CAP_HANDLE_KILLPRIV_V2 (1 << 28)
> >  
> > +/**
> > + * Indicates that file server supports extended struct fuse_setxattr_in
> > + */
> > +#define FUSE_CAP_SETXATTR_EXT (1 << 29)
> > +
> >  /**
> >   * Ioctl flags
> >   *
> > diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> > index 7fe2cef1eb..c2b6ff1686 100644
> > --- a/tools/virtiofsd/fuse_lowlevel.c
> > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > @@ -1419,8 +1419,13 @@ static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
> >      struct fuse_setxattr_in *arg;
> >      const char *name;
> >      const char *value;
> > +    bool setxattr_ext = req->se->conn.want & FUSE_CAP_SETXATTR_EXT;
> >  
> > -    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> > +    if (setxattr_ext) {
> > +        arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> > +    } else {
> > +        arg = fuse_mbuf_iter_advance(iter, FUSE_COMPAT_SETXATTR_IN_SIZE);
> > +    }
> >      name = fuse_mbuf_iter_advance_str(iter);
> >      if (!arg || !name) {
> >          fuse_reply_err(req, EINVAL);
> > -- 
> > 2.25.4
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

