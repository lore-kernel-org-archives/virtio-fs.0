Date: Mon, 12 Apr 2021 08:02:06 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210412060206.ehp3tme2mzvc46w4@mhamilton>
References: <CABpfLih7gTh8a=SYtFT4hGo03K3cnCmAK-+FUXC8X9MhLBwfzg@mail.gmail.com>
	<20210409134158.GD1111800@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="efvdldvsmx55hn6u"
Content-Disposition: inline
In-Reply-To: <20210409134158.GD1111800@redhat.com>
Subject: Re: [Virtio-fs] Compiling virtio-fs/qemu on Mac
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Anthony J Rabbito <hello@anthonyrabbito.com>


--efvdldvsmx55hn6u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 09, 2021 at 09:41:58AM -0400, Vivek Goyal wrote:
> On Thu, Apr 08, 2021 at 08:36:37PM -0400, Anthony J Rabbito wrote:
> > Hi All,
> > I'm having some trouble getting virt9p built with Qemu on Darwin. Given
> > that virtio-fs is progressing nicely i'm wondering if anyone has had any
> > success building for Darwin?
> > Looking to build a podman machine with shared directories.
> > Thanks,
>=20
> Hi Anthony,=20
>=20
> I have never tried building qemu/virtiofsd for Darwin.
>=20
> My understanding is that virtiofsd is supposed to be running on Linux.
> It has code which makes assumption about linux specific behavior. So
> I doubt it will work correctly on Darwin even if you managed to
> compile it.

Yes, this is the case. For the macOS port of libkrun, which integrates
a virtio-fs server, I had to rewrite a significant part of the
passthrough implementation [1]. And even with all the workarounds
there, the semantics aren't 100% compatible, just good enough for the
common use cases.

Sergio.

[1] https://github.com/containers/libkrun/blob/main/src/devices/src/virtio/=
fs/macos/passthrough.rs

--efvdldvsmx55hn6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBz4loACgkQ9GknjS8M
AjVNgQ/+OeP0zH1XJ/J4AF2JasVd2JDqdYiGpE3ZY+5/U6ryvbquXPvkcI9zAZDh
J9WBEEBgXLZ1ux/zZcGuV7z0rLj+QOYRrjgONXpVVleJLlJ8Y15JVQA0C9IvQpp8
F1fxSk1JxowbIYlcvdM3LQRxzMhSbRr+dD/Ab8jWSJPMcaCAnGOpx2/OdfFsjTlS
EPWFDsnT8z6lZyOJq1NMhyTndCpju3ZTjOhF03VkxbQqMqjiZCzekWQO0wazzw/R
C3kjLz+EB7j8cbYKp/G+JwXRsfvztKjGqKibPY53YqMLP9v3C0Vwl2hPPOUYCDjZ
x/AZdfTfqQMb9hIOjm/0158SueHEDkKI08YyYyheO2K7ewNMyACHgU9tE95ABMIU
NJ0ARTAKXcrgmA5pDvUgv7ufJXVZIu65NKlcb+FYLPBmxNMUcGKbUTLKjURhZESd
t4Xfpr7fNqYLzrM1tGDVQ+BdYZ0GltfmQORpFD/9UpFGcPX6RP/224dqmDWeEFwI
IEwKXoID06sqhrNNQJJfTwPgNIzlrqUMJ7zLNpcaxUW1qgrv2KStgkwo77PjGLmR
18lmXqDsSIpey++FaQH7X/eG+a7RgLvCXOaCVgrR/LhZuvFcyV3UWxx0sUAo07HZ
43TYU35thupLV+czH7fXiMR/S3Pf+oJCbjOn44Z8f0xJ09v5Xrk=
=WRiZ
-----END PGP SIGNATURE-----

--efvdldvsmx55hn6u--

