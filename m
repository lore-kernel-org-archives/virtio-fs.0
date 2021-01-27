Date: Wed, 27 Jan 2021 10:18:05 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210127101805.GD299797@stefanha-x1.localdomain>
References: <20210126103502.260758-1-stefanha@redhat.com>
	<20210126181604.1a4c69c6@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <20210126181604.1a4c69c6@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2021 at 06:16:04PM +0100, Greg Kurz wrote:
> On Tue, 26 Jan 2021 10:35:02 +0000
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > A well-behaved FUSE client does not attempt to open special files with
> > FUSE_OPEN because they are handled on the client side (e.g. device nodes
> > are handled by client-side device drivers).
> >=20
> > The check to prevent virtiofsd from opening special files is missing in
> > a few cases, most notably FUSE_OPEN. A malicious client can cause
> > virtiofsd to open a device node, potentially allowing the guest to
> > escape.=20
>=20
> or pretty much anything nasty you can think of, e.g. DoS if the malicious
> client repeatedly asks virtiofsd to open FIFOs the other side of which is
> never opened.
>=20
> > This can be exploited by a modified guest device driver. It is
> > not exploitable from guest userspace since the guest kernel will handle
> > special files inside the guest instead of sending FUSE requests.
> >=20
> > This patch adds the missing checks to virtiofsd. This is a short-term
> > solution because it does not prevent a compromised virtiofsd process
> > from opening device nodes on the host.
> >=20
> > Reported-by: Alex Xu <alex@alxu.ca>
> > Fixes: CVE-2020-35517
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
>=20
> The patch looks pretty good to me. It just seems to be missing a change in
> lo_create():
>=20
>     fd =3D openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFO=
LLOW,
>                 mode);
>=20
> A malicious guest could have created anything called ${name} in this dire=
ctory
> before calling FUSE_CREATE and we'll open it blindly, or I'm missing some=
thing ?

Good point! I will send another revision.

Stefan

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmARPd0ACgkQnKSrs4Gr
c8gNIgf/YdElsWhjcT1Hu1brzUPWC4zSiIUK/CUDnKO015eJiCh2jyQ/7tyuAHOO
njwtXBydBtlbR45lSsDmusMJjpAICE0dJvqShMjYD7WwMXD81Fl8KJFoBseenU8g
HBrIBouy7OTuuHtOdJ8ofvopuR+CR4zWicrZRmChRRhpKM7UfQPEjbgof4FtpvPL
XK4CVTGeTtci++icwTQgGPAnvUYn3RJv0be37pIbzKjABfKaAk/NGf3d8HXxLN/9
n7sJQGj+Lt9y849TfZUhR1/7woPCmBSFBEM2fCpQfTIsU20V7QhgSQMOI4qD0hi0
T2l7yvHbjKBqXshib1TJA8FFoh2D5w==
=RnDm
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--

