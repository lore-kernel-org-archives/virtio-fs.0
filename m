Date: Tue, 22 Jun 2021 18:01:21 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210622180121.0e4d6748@bahia.lan>
In-Reply-To: <YNCVzPd1UGSzriMP@stefanha-x1.localdomain>
References: <20210617141518.304659-1-groug@kaod.org>
	<YNCVzPd1UGSzriMP@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SSFE.C8W0nmf_OLp0YmrYa3";
	protocol="application/pgp-signature"; micalg=pgp-sha256
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't allow file creation with
	FUSE_OPEN
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

--Sig_/SSFE.C8W0nmf_OLp0YmrYa3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Jun 2021 14:36:12 +0100
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Thu, Jun 17, 2021 at 04:15:18PM +0200, Greg Kurz wrote:
> > A well behaved FUSE client uses FUSE_CREATE to create files. It isn't
> > supposed to pass O_CREAT along a FUSE_OPEN request, as documented in
> > the "fuse_lowlevel.h" header :
> >=20
> >     /**
> >      * Open a file
> >      *
> >      * Open flags are available in fi->flags. The following rules
> >      * apply.
> >      *
> >      *  - Creation (O_CREAT, O_EXCL, O_NOCTTY) flags will be
> >      *    filtered out / handled by the kernel.
> >=20
> > But if it does anyway, virtiofsd crashes with:
> >=20
> > *** invalid openat64 call: O_CREAT or O_TMPFILE without mode ***: termi=
nated
> >=20
> > This is because virtiofsd ends up passing this flag to openat() without
> > passing a mode_t 4th argument which is mandatory with O_CREAT, and glibc
> > aborts.
> >=20
> > The offending path is:
> >=20
> > lo_open()
> >     lo_do_open()
> >         lo_inode_open()
> >=20
> > Other callers of lo_inode_open() only pass O_RDWR and lo_create()
> > passes a valid fd to lo_do_open() which thus doesn't even call
> > lo_inode_open() in this case.
> >=20
> > Specifying O_CREAT with FUSE_OPEN is a protocol violation. Check this
> > in lo_open() and return an error to the client : EINVAL since this is
> > already what glibc returns with other illegal flag combinations.
> >=20
> > The FUSE filesystem doesn't currently support O_TMPFILE, but the very
> > same would happen if O_TMPFILE was passed in a FUSE_OPEN request. Check
> > that as well.
> >=20
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
>=20
> Thank you!
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Upstream libfuse folks suggested to do the change in fuse_lowlevel.c so
that it fixes all filesystems, not only those based on passthrough_ll.c.

I'll thus post a new version.

They also seemed to be a little concerned by open() returning EINVAL
to the end user who did nothing wrong (kernel did). They suggested
that the server should rather print out an error and exit... which
isn't really an option for us. And anyway, we already return EINVAL
when we can't extract the arguments of the request. So I won't
address this concern, but I still wanted to share it here.

--Sig_/SSFE.C8W0nmf_OLp0YmrYa3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAmDSCVEACgkQcdTV5YIv
c9Y/ww/+I3DeyRtFBJWuFL4Xpgx4Ldc7qJ5NWljpE0EPpBR+nWCxIeI0kvtuswmK
9kxatBAe7wp6lZChnu27cmk/MN8vXXV4GLZya+SJ2EvfEE9eNunksOLkFlwP2NtL
fM4gOWv6KjXhvOYQJJTm3J5GoCbBpPD3s23tsz0lDBu3TIG/sNJ4PzJ6dtu38+Rl
sCyMWP1g1trwx2S+HEjpJbwmmo5yPY9Lsg17Qm8k0K9Sat7RX3eooSMarLk1skWI
5LZeB87QaktKg6d7HBTzO0nuBYu+glHsaPM0lF89MdzgiO/YhlsB3jwv16tqXniV
1Jc2isrMmGyTkoTwRCZlcpos3RRZ5zju3KMCzMrC3NHMZ9ah43/+OPdbtCZnJu23
eDAAf6pakgsBabdx/dMRt2cvX2yLc66he5dyBNnRQWseBuyj3Lm9Hj0iMGAKrv2T
XyJnx1JqN2QXPGXseSlG2fW8NZB9ZSxakjUzPqN8LduvwMqk3eVzOwgE51hw0bJu
y6hTlSYzmgk8h+gX3lqPpbdYQTdViO0vs2NDrVIE/j7XMKhx54H134YGnKEfTWD1
ZM8bU9qq0NW3RHWoH8i0CTp6EL7ucrziRiYTzSvympBKHiphQUEWBjCbmp3e2/oh
q68UEmyRqi/z/PyiaWBOJI3hu3K+4D2GqyadhtsiTEP8iP+gVsI=
=245e
-----END PGP SIGNATURE-----

--Sig_/SSFE.C8W0nmf_OLp0YmrYa3--

