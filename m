Date: Thu, 23 Jul 2020 16:19:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723151929.GA300121@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-4-stefanha@redhat.com>
	<20200722170328.GU2324845@redhat.com>
	<20200723124611.GL186372@stefanha-x1.localdomain>
	<20200723125035.GH2615312@redhat.com>
	<20200723135603.GB5885@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20200723135603.GB5885@redhat.com>
Subject: Re: [Virtio-fs] [PATCH for-5.1 3/3] virtiofsd: probe
 unshare(CLONE_FS) and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, rmohr@redhat.com, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-devel@nongnu.org, vromanso@redhat.com


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2020 at 09:56:03AM -0400, Vivek Goyal wrote:
> On Thu, Jul 23, 2020 at 01:50:35PM +0100, Daniel P. Berrang=E9 wrote:
> > On Thu, Jul 23, 2020 at 01:46:11PM +0100, Stefan Hajnoczi wrote:
> > > On Wed, Jul 22, 2020 at 06:03:28PM +0100, Daniel P. Berrang=E9 wrote:
> > > > On Wed, Jul 22, 2020 at 02:02:06PM +0100, Stefan Hajnoczi wrote:
> > > > > An assertion failure is raised during request processing if
> > > > > unshare(CLONE_FS) fails. Implement a probe at startup so the prob=
lem can
> > > > > be detected right away.
> > > > >=20
> > > > > Unfortunately Docker/Moby does not include unshare in the seccomp=
=2Ejson
> > > > > list unless CAP_SYS_ADMIN is given. Other seccomp.json lists alwa=
ys
> > > > > include unshare (e.g. podman is unaffected):
> > > > > https://raw.githubusercontent.com/seccomp/containers-golang/maste=
r/seccomp.json
> > > > >=20
> > > > > Use "docker run --security-opt seccomp=3Dpath/to/seccomp.json ...=
" if the
> > > > > default seccomp.json is missing unshare.
> > > > >=20
> > > > > Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > > > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > ---
> > > > >  tools/virtiofsd/fuse_virtio.c | 13 +++++++++++++
> > > > >  1 file changed, 13 insertions(+)
> > > > >=20
> > > > > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse=
_virtio.c
> > > > > index 3b6d16a041..ebeb352514 100644
> > > > > --- a/tools/virtiofsd/fuse_virtio.c
> > > > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > > > @@ -949,6 +949,19 @@ int virtio_session_mount(struct fuse_session=
 *se)
> > > > >  {
> > > > >      int ret;
> > > > > =20
> > > > > +    /*
> > > > > +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will=
 need it. It's
> > > > > +     * an unprivileged system call but some Docker/Moby versions=
 are known to
> > > > > +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
> > > > > +     */
> > > > > +    ret =3D unshare(CLONE_FS);
> > > > > +    if (ret =3D=3D -1 && errno =3D=3D EPERM) {
> > > > > +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with EP=
ERM. If "
> > > > > +                "running in a container please check that the co=
ntainer "
> > > > > +                "runtime seccomp policy allows unshare.\n");
> > > > > +        return -1;
> > > > > +    }
> > > > > +
> > > >=20
> > > > This describes the unshare() call as a "probe" and a "test", but th=
at's
> > > > misleading IMHO. A "probe" / "test" implies that after it has compl=
eted,
> > > > there's no lingering side-effect, which isn't the case here.
> > > >=20
> > > > This is actively changing the process' namespace environment in the
> > > > success case, and not putting it back how it was originally.
> > > >=20
> > > > May be this is in fact OK, but if so I think the commit message and
> > > > comment should explain/justify what its fine to have this lingering
> > > > side-effect.
> > > >=20
> > > > If we want to avoid the side-effect then we need to fork() and run
> > > > unshare() in the child, and use a check of exit status of the child
> > > > to determine the result.
> > >=20
> > > Thanks for pointing this out. I'll add a comment explaining that
> > > virtiofsd is single-threaded at this point. No other threads share the
> > > file system attributes so the call has no observable side-effects.
> >=20
> > Also, if we do an unshare() here, do we still need the unshare() later
> > on in the code ?
>=20
> I think so. That unshare() later is to isolate one thread from other.

Yes. Each thread that calls unshare(CLONE_FS) gets its own current
working directory and other file system attributes.

The purpose of the call is to allow worker threads to change current
working directory without affecting each other.

Stefan

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8ZqoEACgkQnKSrs4Gr
c8gWGwf+JXFC/fVRr0GYRmrh2uGeGA4U1u2SxYwL9sZysPsGWbqQ1tw6+mu8fzNv
stSqtgMA+7FZJERxdL551DWiEloK1mSKpp8pb5RVBxEW6HZrVwsKAw3F89bkJrhk
tiCxlkTvlhd+D3eIoO4/lYoYHj5HRP0hO67yB7LGicSqpfED/3AbTGJSYBgIb7Mu
7lgKFy1cyA1p7TrLtbpFOixoUS4kTRlmETa5mUuRU9SqHjvNKlQugJMrMNcNiDrK
lXpy1tv/gmpRShFFlW5LoePDV/z9UEj4L8QHauuxy+yFF2Rf8WyGqzL0OCN9YuWi
2Nrzj7F7AgF5m/Qd1T2/PhBi5yTyrw==
=IHJ0
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

