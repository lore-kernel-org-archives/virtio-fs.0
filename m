Date: Thu, 9 Jan 2020 12:56:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200109175634.GA17952@redhat.com>
References: <20200108202422.GF1995@redhat.com>
	<20200109022303.GA79586@e18g06458.et15sqa>
	<OSBPR01MB4582182B3FFD047E2FEC6326E5390@OSBPR01MB4582.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <OSBPR01MB4582182B3FFD047E2FEC6326E5390@OSBPR01MB4582.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Open fd O_RDONLY in
 setxattr/removexattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Thu, Jan 09, 2020 at 09:27:15AM +0000, misono.tomohiro@fujitsu.com wrote:
> > On Wed, Jan 08, 2020 at 03:24:22PM -0500, Vivek Goyal wrote:
> > > Do not open fd O_RDWR as it will fail for directories with EISDIR.
> > > This code can be called both for regular files as well as directories.
> > >
> > > I noticed this when I tried "setfattr -n user.foo -v test <dir>"
> > > inside the guest and got EISDIR.
> > >
> > > To write xattr, we don't have to open fd with write permissions. Looks
> > > like kernel will do permission checks on inode.
> > >
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >=20
> > Looks good to me.
> >=20
> > Reviewed-by: Eryu Guan <eguan@linux.alibaba.com>
> >=20
> > > ---
> > >  contrib/virtiofsd/passthrough_ll.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > Index: qemu/contrib/virtiofsd/passthrough_ll.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:01:03.=
821980889 -0500
> > > +++ qemu/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:05:15.20938=
4352 -0500
> > > @@ -2424,7 +2424,7 @@ static void lo_setxattr(fuse_req_t req,
> > >  	}
> > >
> > >  	sprintf(procname, "%i", inode->fd);
> > > -	fd =3D openat(lo->proc_self_fd, procname, O_RDWR);
> > > +	fd =3D openat(lo->proc_self_fd, procname, O_RDONLY);
> > >  	if (fd < 0) {
> > >  		saverr =3D errno;
> > >  		goto out;
> > > @@ -2473,7 +2473,7 @@ static void lo_removexattr(fuse_req_t re
> > >  	}
> > >
> > >  	sprintf(procname, "%i", inode->fd);
> > > -	fd =3D openat(lo->proc_self_fd, procname, O_RDWR);
> > > +	fd =3D openat(lo->proc_self_fd, procname, O_RDONLY);
> > >  	if (fd < 0) {
> > >  		saverr =3D errno;
> > >  		goto out;
> > >
>=20
> Hello,
>=20
> So I sent the same patch last October[1] and got comments
> that it's would be better to fix the fundamental problem
> (do not call openat() to non regular file/directory) [2].

Right. So this patch is only solving the issue for directories (and not
for symlinks other special files). We will need more improvements in
this area.

I am trying to make overlayfs work on top of virtiofs so that it can
be tested and see if it works well or not. Overlayfs does bunch of
xattr operations on work/work directory and it fails. So this patch
will atleast fix that and allow me to make progress.


>   [1] https://www.redhat.com/archives/virtio-fs/2019-October/msg00030.html
>   [2] https://www.redhat.com/archives/virtio-fs/2019-October/msg00046.html
> =A0
> I tried the suggested approach which uses fchdir(proc_self_fd) + ...xattr=
() + fchdir(root.fd)
> combination instead of current openat() + f...xattr().=20
> However, it seems that always fchdir on xattr operation for regular files=
 too incurs
> some performance overhead (~10% or more).
> =A0
> So I think hybrid approach is better:=20
>   For regular file/directory: use f...xattr
>   For other file types: use fchdir + ...xattr + fchdir=20

This sounds reasonable. I will give it a try.  In fact Miklos's patch
for allowing fsetxattr() on O_PATH is still being reviewed upstream. Once
that is merged, our approach should probably be.

1. Try fsetxattr(O_PATH fd).
2. If 1 fails, try openat() followed by fsetxattr() for regular files
   and dirs.
3. For other file types use fchdir + ...xattr() + fchdir.=20

Thanks
Vivek

> =A0
> Attached patch adopts the above solution.
> So could you check the patch's approach? If it is fine, I will send it as=
 a formal patch
> (and I apologize that my response is delayed).
>=20
> Thanks,
> Misono


