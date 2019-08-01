Date: Thu, 1 Aug 2019 10:17:15 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190801091715.GC15179@stefanha-x1.localdomain>
References: <20190731161006.9447-1-stefanha@redhat.com>
	<20190731161006.9447-2-stefanha@redhat.com>
	<20190731184538.GO3203@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20190731184538.GO3203@work-vm>
Subject: Re: [Virtio-fs] [PATCH 1/5] virtiofsd: take lo->mutex around
	lo_add_fd_mapping()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 07:45:38PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > The lo_add_fd_mapping() function assumes lo->mutex is held, so we should
> > acquire it.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> Thanks, applied
>=20
> Would it make sense for me to squash this into:
>     virtiofsd: passthrough_ll: add fd_map to hide file descriptors=20
>=20
> ?

Yes, please.

Feel free to squash any of my virtio-fs patches as you see fit in order
to produce a nice clean patch series for upstream.  I don't mind if
fine-grained authorship information is lost, but please keep my
Signed-off-by.

Stefan

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1CrhsACgkQnKSrs4Gr
c8iCLAgAj3LmlRPxvClrlyjC+/CAF3ji80jd/ZWOtfY9Yv4iEaoUqX2uGXkrrqiW
NC15SlMWL0miyf7zIOKSjW84ZoPRMFIsz3RioF07UkdvtOuAFu//8aemqGj+Wt2m
IVFmLMULG3Ur/1A52PezhyQcfgIKcejZY624g0MeXv4aB6Hzqm/9emh6YTjoUGUD
wwy1u6sCLcCZPKIwwdtAARos8jc8h6RYr1UOLMbdcl8FrlnMtEuFHwmYdlNCGKiT
NgLmz78Tap+N6sc8ETVkQOkczAe9zEqmszLYoFZmyrslC6GJXnnCIW4EBQ3sAS4i
N9fjX5rshqiV1qC1AaAUemYQ9lgcCA==
=/9cz
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--

