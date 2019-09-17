Date: Tue, 17 Sep 2019 16:18:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190917151829.GA14252@stefanha-x1.localdomain>
References: <20190906100324.8492-1-stefanha@redhat.com>
	<CAFLxGvw-n2VYcYR9kei7Hu2RBhCG9PeWuW7Z+SaiyDQVBRiugw@mail.gmail.com>
	<20190909070039.GB13708@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20190909070039.GB13708@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtiofs root fs
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2019 at 09:00:39AM +0200, Stefan Hajnoczi wrote:
> On Fri, Sep 06, 2019 at 09:16:04PM +0200, Richard Weinberger wrote:
> > On Fri, Sep 6, 2019 at 1:15 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> > >
> > > Make it possible to boot directly from a virtiofs file system with tag
> > > 'myfs' using the following kernel parameters:
> > >
> > >   rootfstype=3Dvirtiofs root=3Dmyfs rw
> > >
> > > Booting directly from virtiofs makes it possible to use a directory on
> > > the host as the root file system.  This is convenient for testing and
> > > situations where manipulating disk image files is cumbersome.
> > >
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > ---
> > > This patch is based on linux-next (next-20190904) but should apply
> > > cleanly to other virtiofs trees.
> > >
> > >  init/do_mounts.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/init/do_mounts.c b/init/do_mounts.c
> > > index 9634ecf3743d..030be2f1999a 100644
> > > --- a/init/do_mounts.c
> > > +++ b/init/do_mounts.c
> > > @@ -554,6 +554,16 @@ void __init mount_root(void)
> > >                         change_floppy("root floppy");
> > >         }
> > >  #endif
> > > +#ifdef CONFIG_VIRTIO_FS
> > > +       if (root_fs_names && !strcmp(root_fs_names, "virtiofs")) {
> > > +               if (!do_mount_root(root_device_name, "virtiofs",
> > > +                                  root_mountflags, root_mount_data))
> > > +                       return;
> > > +
> > > +               panic("VFS: Unable to mount root fs \"%s\" from virti=
ofs",
> > > +                     root_device_name);
> > > +       }
> > > +#endif
> >=20
> > I think you don't need this, you can abuse a hack for mtd/ubi in
> > prepare_namespace().
> > At least for 9p it works well:
> > qemu-system-x86_64 -m 4G -M pc,accel=3Dkvm -nographic -kernel
> > arch/x86/boot/bzImage -append "rootfstype=3D9p
> > rootflags=3Dtrans=3Dvirtio,version=3D9p2000.L root=3Dmtdfake console=3D=
ttyS0 ro
> > init=3D/bin/sh" -virtfs
> > local,id=3Drootfs,path=3D/,security_model=3Dpassthrough,mount_tag=3Dmtd=
fake
>=20
> That is worse because:
> 1. The file system must be named "mtd*" or "ubi*".
> 2. When mounting fails you get confusing error messages about block
>    devices and partitions.  These do not apply to virtio-fs or
>    virtio-9p.
>=20
> > If this works too for virtiofs I suggest to cleanup the hack and
> > generalize it. B-)
>=20
> Why mtd and ubi block devices even have a special case?  Maybe this code
> was added because ROOT_DEV =3D name_to_dev_t(root_device_name) doesn't
> work for "mtd:partition" device names so the regular CONFIG_BLOCK code
> path doesn't work for these devices.
>=20
> Given the ordering/fallback logic in prepare_namespace()/mount_root() I
> don't feel comfortable changing other code paths.  It's likely to break
> something.
>=20
> If you or others have a concrete suggestion for how to generalize this
> I'm happy to try implementing it.

Ping

Stefan

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2A+UMACgkQnKSrs4Gr
c8i6eAgAkN2zE2XAxwI84NK3smJPl675qn0414PNvQhfQsE2irOGG5SjPssik9FJ
Cu/teFu0WP4nj+EgOZW3YG8nVKS9J9eGylwMRM0nKmSyMEQJuRSUMUOj0Y1hXGqN
NDHhAyl/zgaiFYZ0v2uZg5iGCyAP7kmK339O2+MJaYTxZ21gfrTNmZB/K054GUq5
XGWHkl2zQ+Yt2Lx/1UIfyI68hB5+CgbosMGdpn79Tt1ZR6biNWfQyE5Ou9MJu9ol
WVO4mz+P3cQbjoNuaPifD441wy8AFDsGBFDat5ANlfxuQQr1uNCLbKdZ9tNtx5XC
POj4rf1iHTW5qMSB5tW10T3NIXzpxA==
=bVOi
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--

