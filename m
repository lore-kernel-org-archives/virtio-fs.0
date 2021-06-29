Date: Tue, 29 Jun 2021 14:44:31 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210629144431.02e2ce0c@bahia.lan>
In-Reply-To: <YNng0CPIFHxDIE3a@work-vm>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
	<20210622150852.1507204-2-vgoyal@redhat.com>
	<YNng0CPIFHxDIE3a@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu

On Mon, 28 Jun 2021 15:46:40 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

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

You can also add:

Fixes: 278f064e4524 ("Update Linux headers to 5.13-rc4")

because this is basically what happened : this commit exposes the API
breakage.

This is kinda problematic : linux kernel headers are updated globally,
i.e. an header update merged by some other subsystem will unknowingly
break virtiofsd each time we face a similar situation.

We could cope with it if the code was adapted to API changes when
needed, e.g. this patch squashed into 278f064e4524 . It doesn't
seem that can be achievable without some automation to detect
buggy situations (e.g. code depends on the size of a structure).
And even with that, it would still cause the subsystem that
needs the header update to depend on other subsystems to
fix the breakage.

Another possibility could maybe to stop doing global updates and
let each subsystem handle the kernel headers it needs.

OR we could avoid breaking the API in the kernel in the first
place.

Thoughts ?

Anyway, the fix is good:

Reviewed-by: Greg Kurz <groug@kaod.org>

> (I don't think libfuse has a fix for this in yet itself, but it might
> survive because it doesn't bother copying the data like we do with
> mbuf).
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

