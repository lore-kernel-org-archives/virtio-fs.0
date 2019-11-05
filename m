DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=qQXriDAmGVYWmDIQ5Z6gRehd77sJ5yWG2d1HzcVfMzQ=;
	b=IDHzbuxWN6TQMmuxKO0FuR0cGlEVDsvezOKU/RE+Du5P+5KdT3fYFLDNuAB8QpOFfS
	hTUGw8xp+s3CJu7Ye9Dfmhq2FnOyGB4b1rc/z8ZctWzOGRY4/GYgYg4blKkdQJm8hzXU
	ByPIfK06VC6Q6inKj9poEn5ZcwWO6jOiy9dCP+yt0CXspNUtpeVD2qB2dAbjqf3cf4IF
	HXp7DwAZVqGvrYk4ob9TNX9hYENfXHNKDJzBbw3R7pjANBlzW2ZYp6atLuAsRQjZyNvz
	K7Y7s+kcHfn3r+DndoDz7a7oE2j4Cv6PiEle8uvXTX55NfI8NDKWpu+ifWSwzflZOXDr
	6VSw==
Date: Tue, 5 Nov 2019 17:02:52 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20191105160252.GF166646@stefanha-x1.localdomain>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-4-stefanha@redhat.com>
	<20191029003605.GC2508@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iBwuxWUsK/REspAd"
Content-Disposition: inline
In-Reply-To: <20191029003605.GC2508@work-vm>
Subject: Re: [Virtio-fs] [RFC 3/3] tests/vhost-user-fs-test: add
	vhost-user-fs test case
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com


--iBwuxWUsK/REspAd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2019 at 12:36:05AM +0000, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > +static void after_test(void *arg G_GNUC_UNUSED)
> > +{
> > +    unlink(socket_path);
> > +
> > +    remove_dir_and_children(shared_dir);
>=20
> This scares me. Especially since it's running as root.
> Can we add a bunch of paranoid checks to make sure it doesn't
> end up rm -rf / ?

Yes, we can resolve the path and check it is not "/".

> > +/* Open a file by nodeid using FUSE_OPEN */
> > +static int32_t fuse_open(QVirtioFS *vfs, uint64_t nodeid, uint32_t fla=
gs,
> > +                         uint64_t *fh)
> > +{
> > +    struct fuse_in_header in_hdr =3D {
> > +        .opcode =3D guest32(FUSE_OPEN),
> > +        .unique =3D guest64(virtio_fs_get_unique(vfs)),
> > +        .nodeid =3D guest64(nodeid),
> > +    };
> > +    struct fuse_open_in in =3D {
> > +        .flags =3D guest32(flags),
> > +    };
> > +    struct iovec sg_in[] =3D {
> > +        { .iov_base =3D &in_hdr, .iov_len =3D sizeof(in_hdr) },
> > +        { .iov_base =3D &in, .iov_len =3D sizeof(in) },
> > +    };
> > +    struct fuse_out_header out_hdr;
> > +    struct fuse_open_out out;
> > +    struct iovec sg_out[] =3D {
> > +        { .iov_base =3D &out_hdr, .iov_len =3D sizeof(out_hdr) },
> > +        { .iov_base =3D &out, .iov_len =3D sizeof(out) },
> > +    };
>=20
> I wonder if anything can be done to reduce the size of the iovec boiler
> plate?

I'm not aware of a clean way to build the iovec array automatically but
we could do this if you prefer it:

  #define IOVEC(elem) { .iov_base =3D &elem, .iov_len =3D sizeof(elem) }

  struct iovec sg_in[] =3D {
    IOVEC(in_hdr),
    IOVEC(in),
  };

Do you find this nicer?

Stefan

--iBwuxWUsK/REspAd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3BnSwACgkQnKSrs4Gr
c8jMdwf/dPuWyPiILgjVQyqoBW4i4LYRi2NqilkJDN5b9Is1n1dmVvfhtTnH748o
Ex2by9FJVrRcaP7cENH6wQEJgN4IlrUfKn28Y+Ge42aDFjkHm3N7/BlgJJojrJmh
89hcnr1n2eEVD/GrLbEfIxLCNZ64379gvlGZCPd3WQJ0nOUD1R4CeaJRRYODg6gK
sXUJqIXAzi62k0OfiSibvSPTnlf5XK1mh9VbSC2K2NNIgW1fmaxt3q2jr1gknt0/
k72CZENM6Jjhyb5GEzykXigCIrrJBAnO5sxNbp0xzdD3z/UxI8WtBkodDDEZjB0S
DxXnVgUawY4sos0uEjaK6Zp8W2i92g==
=wxgU
-----END PGP SIGNATURE-----

--iBwuxWUsK/REspAd--

