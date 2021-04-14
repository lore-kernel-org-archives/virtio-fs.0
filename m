Date: Wed, 14 Apr 2021 08:00:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YHaTGM0JebV1XYpc@stefanha-x1.localdomain>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
	<YHVakoU5hY0wif2n@stefanha-x1.localdomain>
	<20210413133534.GA1235549@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Po2/+ykJwIjfF6dK"
Content-Disposition: inline
In-Reply-To: <20210413133534.GA1235549@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Anton Kuchin <antonkuchin@yandex-team.ru>, "Michael S. Tsirkin" <mst@redhat.com>


--Po2/+ykJwIjfF6dK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2021 at 09:35:34AM -0400, Vivek Goyal wrote:
> On Tue, Apr 13, 2021 at 09:47:14AM +0100, Stefan Hajnoczi wrote:
> > On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
> > > Make virtio-fs take into account server capabilities.
> > >=20
> > > Just returning requested features assumes they all of then are implem=
ented
> > > by server and results in setting unsupported configuration if some of=
 them
> > > are absent.
> > >=20
> > > Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> > > ---
> > >  hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
> > >  1 file changed, 13 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > > index ac4fc34b36..6cf983ba0e 100644
> > > --- a/hw/virtio/vhost-user-fs.c
> > > +++ b/hw/virtio/vhost-user-fs.c
> > > @@ -24,6 +24,14 @@
> > >  #include "monitor/monitor.h"
> > >  #include "sysemu/sysemu.h"
> > > =20
> > > +static const int user_feature_bits[] =3D {
> > > +    VIRTIO_F_VERSION_1,
> > > +    VIRTIO_RING_F_INDIRECT_DESC,
> > > +    VIRTIO_RING_F_EVENT_IDX,
> > > +    VIRTIO_F_NOTIFY_ON_EMPTY,
> > > +    VHOST_INVALID_FEATURE_BIT
> > > +};
> >=20
> > Please add:
> >=20
> > VIRTIO_F_RING_PACKED
> > VIRTIO_F_IOMMU_PLATFORM
>=20
> Hi Stefan,
>=20
> What about
>=20
> VIRTIO_F_ANY_LAYOUT
>=20
> I see this one is currently set in requested_features. IIUC, qemu will
> assume that device supports VIRTIO_F_ANY_LAYOUT if we don't reset it.

virtio-fs requires VIRTIO 1.1+ where the "any layout" semantics are
mandatory. The Legacy device interface is not supported by virtio-fs so
this feature bit isn't used.

Here is the VIRTIO_F_ANY_LAYOUT section in the spec if you want to read
more about it:
https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x=
1-4130003

> And I see two more flags.
>=20
> VIRTIO_F_ORDER_PLATFORM
> VIRTIO_F_SR_IOV
>=20
> Should this be part of user_feature_bits[] too?

VIRTIO_F_ORDER_PLATFORM is unclear. It could be used in some way if the
vhost-user device backend passes the virtqueue memory to a physical PCI
device, but I think vhost-user doesn't support that (instead vDPA would
be used).

VIRTIO_F_SR_IOV is not relevant to vhost-user device backends. It's
unlikely to be implemented but if so, then the hypervisor would handle
it as part of virtio-pci device emulation and the vhost-user device
backend would be unaware.

So I think these 3 feature bits do not need to be negotiated with the
vhost-user device backend.

Stefan

--Po2/+ykJwIjfF6dK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB2kxgACgkQnKSrs4Gr
c8hcBggAxxpMo6AYZlKsrlDzinbNxJ0Xz25Q/ivNmMCb5Vdmy2pjC93IYNeSKrDZ
qPj+h/usJZ9D1WwLainDhp9aGmt/TYCu10IQ5AFgF+M4+Qng+1RWczT/P+RPgS95
gop52WTRx+TyjTWT6DkvXEm2NBPEENNgPmZ7elRLW0+uhhFuuUMsQ7rncT299mVn
+P6rxwMnodOtp3jD+d9JgxGd3DpYdL0ohZkLycRG8QNSeudNZ6WR29EGJuzf2YEE
aan6HknrZ5k2bWPkYs3GpHLEOsYeFVmMdahBoJjDAdpgsOYEK5nTd7BX6NhaySo+
YJ67cYnub+r1J5Ac0R6Y/ps29CyzCg==
=88IN
-----END PGP SIGNATURE-----

--Po2/+ykJwIjfF6dK--

