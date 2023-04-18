Return-Path: <stefanha@redhat.com>
Date: Tue, 18 Apr 2023 12:04:15 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230418160415.GB4048149@fedora>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <CAJSP0QURbJrEoFY8FhMnq_B6tx-qYspfu-OB6=6hz5=qAwE=6A@mail.gmail.com>
 <87ttxeeatd.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="qG0Ivx1WmQAdGIuU"
Content-Disposition: inline
In-Reply-To: <87ttxeeatd.fsf@linaro.org>
Subject: Re: [Virtio-fs] [PATCH 00/12] virtio: add vhost-user-generic and
 reduce copy and paste
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>


--qG0Ivx1WmQAdGIuU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 17, 2023 at 05:14:59PM +0100, Alex Benn=E9e wrote:
>=20
> Stefan Hajnoczi <stefanha@gmail.com> writes:
>=20
> > On Fri, 14 Apr 2023 at 12:06, Alex Benn=E9e <alex.bennee@linaro.org> wr=
ote:
> >>
> >> A lot of our vhost-user stubs are large chunks of boilerplate that do
> >> (mostly) the same thing. This series attempts to fix that by defining
> >> a new base class for vhost-user devices and then converting the rng
> >> and gpio devices to be based off them. You can even use
> >> vhost-user-device directly if you supply it with the right magic
> >> numbers (which is helpful for development).
> >>
> >> However the final patch runs into the weeds because I don't yet have a
> >> clean way to represent in QOM the fixing of certain properties for the
> >> specialised classes.
> >>
> >> The series is a net reduction in code and an increase in
> >> documentation but obviously needs to iron out a few more warts. I'm
> >> open to suggestions on the best way to tweak the QOM stuff.
> >
> > --device vhost-user-device is not really possible because vhost-user
> > devices are not full VIRTIO devices. vhost-user devices depend on
> > device-specific code in the VMM by design.
>=20
> What device specific code? You certainly need to instantiate stuff in
> the DTB/ACPI tables for -M virt but everything else can be handed off to
> the vhost-user daemon.

There are vhost-user device types that lack functionality entirely, like
vhost-user-net's lack of the controlq virtqueue and configuration space.
It is not even possible to query the MAC address from a vhost-user-net
device. It's not a full virtio-net device and the VMM has to fill in the
gaps to emulate the missing virtqueues and configuration space.

There are device type-specific vhost-user messages like
VHOST_USER_SEND_RARP and VHOST_USER_CREATE_CRYPTO_SESSION that can't
really be supported by a generic --device vhost-user-device.

Live migration is another device-specific aspect that is handled by the
vhost-user frontend.

> Indeed the split brain is a bit silly in some places. For example is
> QEMU really the best arbiter of a block device config when the actual
> backend is a separate process. We have config passing in the vhost-user
> spec.

Optional vhost-user messages like configuration space access may be in
the spec, but existing device types cannot rely on them for backwards
compatibility reasons. Therefore most existing device types don't use
the configuration space. Those that do may only access parts of the
configuration space from the backend and emulate the rest.

The blog post I linked mentions a new protocol feature bit
(VHOST_USER_PROTOCOL_F_VDPA) to distinguish new vhost-user backends that
are full VIRTIO devices. This doesn't exist today, but I think something
like that is necessary to detect devices that will work with --device
vhost-user-device.

> > The "subset of a VIRTIO device" design made sense for vhost_net.
> > Nowadays there are other device types that are close to full VIRTIO
> > devices, although the vhost-user protocol doesn't support the full
> > VIRTIO device lifecycle.
>=20
> What are we missing?

vhost-user needs:
- A GET_DEVICE_ID message.
- A GET_CONFIG_SIZE message. Today it is assumed that the vhost-user
  frontend already knows the configuration space size.
- A protocol feature bit indicating that the device is a full VIRTIO
  device. These devices also need to implement the SET_STATUS message,
  which is rarely implemented today.

> > I think a user-creatable --device vhost-user-device is not a good idea
> > today. It creates confusion. Many people aren't aware of the
> > architectural difference between vhost-user and VIRTIO devices. The
> > result is that VMMs and vhost-user backends implement increasingly
> > brittle VIRTIO configuration space and feature bit logic as they
> > knowingly or unknowingly try to paper over the fact that a traditional
> > vhost-user device isn't a full VIRTIO device.
>=20
> I've always found the device feature gating in QEMU confusing. Surely we
> can rely on the daemon to properly enumerate the features it supports?

The backend's features cannot be passed through to the guest because
there is also an emulated VIRTIO transport (virtio-pci, virtio-mmio,
virtio-ccw) involved. The transport may support a different feature set
=66rom the vhost-user backend. For example, the transport may support
Packed Virtqueues but the backend may not. So some filtering is
necessary in the VMM.

Since some of the device-specific functionality may be handled by the
VMM, then this extends beyond just the transport feature bits.

But I agree with you that it's ugly and complex. I have to re-read the
code every time because it works in a strange way.

> > It is possible to resolve this difference and make --device
> > vhost-user-device work properly for devices that want to be full
> > VIRTIO devices. See "Making VMM device shims optional" here:
> > https://blog.vmsplice.net/2020/09/on-unifying-vhost-user-and-virtio.html
> >
> > Even after extending the vhost-user protocol to solve the current
> > limitations, existing backends would still only be partial VIRTIO
> > devices that wouldn't work with --device vhost-user-device.
>=20
> It works for RNG, GPIO (and soon I'll be testing i2c and SCSI). All we
> need is the virtioid and the number of virtio queues.

There is already a vhost-user message for querying the number of
virtqueues: VHOST_USER_GET_QUEUE_NUM.

See above for other missing stuff.

> > Reducing boilerplate is helpful, but I think --device
> > vhost-user-device should not be user-creatable.
>=20
> After this series lands it will certainly make adding new shims easier
> but having a vhost-user-device will make testing of new backends easier.
> Can we not simply document it as an advanced feature for those who know
> what they are doing? I'm not intending to deprecate the existing shims.

If you add the missing pieces to vhost-user then --device
vhost-user-device can be done properly. Two messages and one protocol
feature bit are required, it's not that bad.

Stefan

--qG0Ivx1WmQAdGIuU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ+v38ACgkQnKSrs4Gr
c8ieHwf8CfoIaa37ul/ZKEojrKqPFoTvHGgzGZpyIQrLEUhmH+3bvyOhOddIGCF2
LCygbmLX1iv4L8T0FFnw7XmL6xJveN2p2cU2dPmN7i4h+l6tY++tHmyMRwGQ2MSk
2BZOVdvJd3CS3GKJUjo5Fuu0jdfbBPfDPxTr5BmC5IMx3Wr5ML5lCZr5skrbzbZR
eoHEzGlFrKPc7iHnq1n16vOH1MMM/Zxv68us7Is2ZHnHSpUwro2em7w0D+ZR0SsG
1w05q4zam0oW243KDEmmXFqU8R/daLxG3bP0TuH+3rlJabcRdXje/asQzdH2MgyT
cZa26+nWnLTiJK9kX1V4OzaPC7ALZg==
=mC+3
-----END PGP SIGNATURE-----

--qG0Ivx1WmQAdGIuU--
