Date: Wed, 31 Jul 2019 15:59:05 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190731145905.GB7363@stefanha-x1.localdomain>
References: <20190726082131.6739-1-stefanha@redhat.com>
	<20190731103408.GB3203@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20190731103408.GB3203@work-vm>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtio_fs root fs
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 11:34:08AM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > It is useful to mount the root file system via virtio_fs.  During
> > testing a monolithic kernel is more convenient than an initramfs but
> > we'll need to teach the kernel how to boot directly from virtio_fs.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  init/do_mounts.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20
> > diff --git a/init/do_mounts.c b/init/do_mounts.c
> > index f8c230c77035..b2d9650488d7 100644
> > --- a/init/do_mounts.c
> > +++ b/init/do_mounts.c
> > @@ -553,6 +553,16 @@ void __init mount_root(void)
> >  			change_floppy("root floppy");
> >  	}
> >  #endif
> > +#ifdef CONFIG_VIRTIO_FS
> > +	if (root_fs_names && !strcmp(root_fs_names, "virtio_fs")) {
> > +		if (!do_mount_root(root_device_name, "virtio_fs",
> > +				   root_mountflags, root_mount_data))
> > +			return;
> > +
> > +		panic("VFS: Unable to mount root fs \"%s\" from virtio_fs",
> > +		      root_device_name);
> > +	}
> > +#endif
>=20
> I wonder if it's possible to make this more generic; I see that
> filesystems have a flag, FS_REQUIRES_DEV - should this
> work for most filesystems that don't have that set?

I don't know the answer.  We'll have to ask when upstreaming.

Stefan

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1BrLkACgkQnKSrs4Gr
c8jKOwgAhilW3R9aEuDiwH6RShjGnvowZFvDUWKBKI52dHydVWu1ReoDY/CBjaI7
0tXLs5dAnRerDtC0lqc2s6atFVMHlSix6rgIdrNbJ7eLyxZpBO6z4sdNACwuw5l0
XO0FPNe9C54SUUWYrkkq/zzMUGCceyKZ/YR3MD0ptaQ6kDJfpAVw1BeVU0FqDc9b
SvIaze7BhE+f/yznVj82dlwyPhk9PZvO1KTYXqEIh+mZR+mK+ozgXJ8cRPypFVUY
grHB26+modbnZiDtU4FcfOCs6YlHaVHZCtwfbx+QVh1ScSBSuuE2LP/Hc3WJ0hHe
ZGrzG1KRBiFZRBJP5BueYdV+001rpw==
=F7Gw
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--

