Date: Tue, 28 Apr 2020 09:53:08 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200428085308.GA15547@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
	<20200427175814.GC146096@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20200427175814.GC146096@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: virtiofs: Fix nullptr dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2020 at 01:58:14PM -0400, Vivek Goyal wrote:
> On Fri, Apr 24, 2020 at 03:25:39PM +0900, Chirantan Ekbote wrote:
> > virtiofs device implementations are allowed to provide more than one
> > request queue.  In this case `fsvq->fud` would not be initialized,
> > leading to a nullptr dereference later during driver initialization.
> >=20
> > Make sure that `fsvq->fud` is initialized for all request queues even if
> > the driver doesn't use them.
> >=20
> > Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> > ---
> >  fs/fuse/virtio_fs.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index bade747689033..d3c38222a7e4e 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -1066,10 +1066,13 @@ static int virtio_fs_fill_super(struct super_bl=
ock *sb)
> >  	}
> > =20
> >  	err =3D -ENOMEM;
> > -	/* Allocate fuse_dev for hiprio and notification queues */
> > -	for (i =3D 0; i < VQ_REQUEST; i++) {
> > +	/* Allocate fuse_dev for all queues except the first request queue. */
> > +	for (i =3D 0; i < fs->nvqs; i++) {
> >  		struct virtio_fs_vq *fsvq =3D &fs->vqs[i];
> > =20
> > +		if (i =3D=3D VQ_REQUEST)
> > +			continue;
> > +
>=20
> These special conditions of initializing fuse device for one queue
> fusing fill_super_common() and rest of the queues outside of it, are
> bothering me. I am proposing a separate patch where all fuse device
> initialization/cleanup is done by the caller. It makes code look
> cleaner and easier to understand.

Nice!

Stefan

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6n7vIACgkQnKSrs4Gr
c8hteAf/eYI9TctYqcOxsmycO3jHxaBajTT1j+7GE3qjJo+kGEV5XkAFdqNGKc6q
O0wtnX8BrFIGvjo/oyibAtA2r712jKx0M6TllaKEOaT5ukuWA9Ele5Ahn0rn2hJV
itjPBriTX/r/R4tAtHeItWrWgmnYhsoI29orLKPAZJbjilaiIyIStSG5UH8zmMa8
VZpqfCX+MozlIJKyMb1e//FNDY9NQ7YLpyGLb30iB5pS7Nq12bKshV0r0wsqBCws
HKz3VHyJz8Bso7GQCMiTzdeKYJuIT1ZY3NKixON2/0YAOpubd3ET19h5MFe/UX5S
p7zIWZ2hShTWipUP3SM1QCpRoOWsew==
=cZw4
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--

