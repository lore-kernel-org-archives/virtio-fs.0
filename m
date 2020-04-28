MIME-Version: 1.0
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
In-Reply-To: <20200428145143.GB107541@stefanha-x1.localdomain>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 28 Apr 2020 21:07:25 +0200
Message-ID: <CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, qemu-devel@nongnu.org

On Tue, Apr 28, 2020 at 4:52 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Mon, Apr 27, 2020 at 06:59:02PM +0100, Dr. David Alan Gilbert wrote:
> > * Max Reitz (mreitz@redhat.com) wrote:
> > > Currently, setup_mounts() bind-mounts the shared directory without
> > > MS_REC.  This makes all submounts disappear.
> > >
> > > Pass MS_REC so that the guest can see submounts again.
> >
> > Thanks!
> >
> > > Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
> >
> > Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
> >
> > > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > index 4c35c95b25..9d7f863e66 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
> > >      int oldroot;
> > >      int newroot;
> > >
> > > -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
> > > +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> > >          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
> > >          exit(1);
> > >      }
> >
> > Do we want MS_SLAVE to pick up future mounts that might happenf rom the
> > host?
>
> There are two separate concepts:
>
> 1. Mount namespaces.  The virtiofsd process is sandboxed and lives in
>    its own mount namespace.  Therefore it does not share the mounts that
>    the rest of the host system sees.
>
> 2. Propagation type.  This is related to bind mounts so that mount
>    operations that happen in one bind-mounted location can also appear
>    in other bind-mounted locations.
>
> Since virtiofsd is in a separate mount namespace, does the propagation
> type even have any effect?

It's a complicated thing.  Current setup results in propagation
happening to the cloned namespace, but not to the bind mounted root.

Why?  Because setting mounts "slave" after unshare, results in the
propagation being stopped at that point.  To make it propagate
further, change it back to "shared".  Note: the result changing to
"slave" and then to "shared" results in breaking the backward
propagation to the original namespace, but allowing propagation
further down the chain.

Thanks,
Miklos


