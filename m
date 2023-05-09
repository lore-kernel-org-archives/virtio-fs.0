Return-Path: <stefanha@redhat.com>
Date: Tue, 9 May 2023 11:41:30 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230509154130.GG926999@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="ZGPoR+tbgHGFel9H"
Content-Disposition: inline
In-Reply-To: <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>


--ZGPoR+tbgHGFel9H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 05, 2023 at 11:03:16AM +0200, Hanna Czenczek wrote:
> On 04.05.23 23:14, Stefan Hajnoczi wrote:
> > On Thu, 4 May 2023 at 13:39, Hanna Czenczek <hreitz@redhat.com> wrote:
> > > On 11.04.23 17:05, Hanna Czenczek wrote:
> > >=20
> > > [...]
> > >=20
> > > > Hanna Czenczek (4):
> > > >     vhost: Re-enable vrings after setting features
> > > >     vhost-user: Interface for migration state transfer
> > > >     vhost: Add high-level state save/load functions
> > > >     vhost-user-fs: Implement internal migration
> > > I=E2=80=99m trying to write v2, and my intention was to keep the code
> > > conceptually largely the same, but include in the documentation change
> > > thoughts and notes on how this interface is to be used in the future,
> > > when e.g. vDPA =E2=80=9Cextensions=E2=80=9D come over to vhost-user. =
 My plan was to,
> > > based on that documentation, discuss further.
> > >=20
> > > But now I=E2=80=99m struggling to even write that documentation becau=
se it=E2=80=99s not
> > > clear to me what exactly the result of the discussion was, so I need =
to
> > > stop even before that.
> > >=20
> > > So as far as I understand, we need/want SUSPEND/RESUME for two reason=
s:
> > > 1. As a signal to the back-end when virt queues are no longer to be
> > > processed, so that it is clear that it will not do that when asked for
> > > migration state.
> > > 2. Stateful devices that support SET_STATUS receive a status of 0 when
> > > the VM is stopped, which supposedly resets the internal state. While
> > > suspended, device state is frozen, so as far as I understand, SUSPEND
> > > before SET_STATUS would have the status change be deferred until RESU=
ME.
> > I'm not sure about SUSPEND -> SET_STATUS 0 -> RESUME. I guess the
> > device would be reset right away and it would either remain suspended
> > or be resumed as part of reset :).
> >=20
> > Unfortunately the concepts of SUSPEND/RESUME and the Device Status
> > Field are orthogonal and there is no spec that explains how they
> > interact.
>=20
> Ah, OK.=C2=A0 So I guess it=E2=80=99s up to the implementation to decide =
whether the
> virtio device status counts as part of the =E2=80=9Cconfiguration=E2=80=
=9D that =E2=80=9C[it] must
> not change=E2=80=9D.
>=20
> > > I don=E2=80=99t want to hang myself up on 2 because it doesn=E2=80=99=
t really seem
> > > important to this series, but: Why does a status of 0 reset the inter=
nal
> > > state?  [Note: This is all virtio_reset() seems to do, set the status=
 to
> > > 0.]  The vhost-user specification only points to the virtio
> > > specification, which doesn=E2=80=99t say anything to that effect. Ins=
tead, an
> > > explicit device reset is mentioned, which would be
> > > VHOST_USER_RESET_DEVICE, i.e. something completely different. Because
> > > RESET_DEVICE directly contradicts SUSPEND=E2=80=99s description, I wo=
uld like to
> > > think that invoking RESET_DEVICE on a SUSPEND-ed device is just inval=
id.
> > The vhost-user protocol didn't have the concept of the VIRTIO Device
> > Status Field until SET_STATUS was added.
> >=20
> > In order to participate in the VIRTIO device lifecycle to some extent,
> > the pre-SET_STATUS vhost-user protocol relied on vhost-user-specific
> > messages like RESET_DEVICE.
> >=20
> > At the VIRTIO level, devices are reset by setting the Device Status
> > Field to 0.
>=20
> (I didn=E2=80=99t find this in the virtio specification until today, turn=
s out it=E2=80=99s
> under 4.1.4.3 =E2=80=9CCommon configuration structure layout=E2=80=9D, no=
t under 2.1 =E2=80=9CDevice
> Status Field=E2=80=9D, where I was looking.)
>=20
> > All state is lost and the Device Initialization process
> > must be followed to make the device operational again.
> >=20
> > Existing vhost-user backends don't implement SET_STATUS 0 (it's new).
> >=20
> > It's messy and not your fault. I think QEMU should solve this by
> > treating stateful devices differently from non-stateful devices. That
> > way existing vhost-user backends continue to work and new stateful
> > devices can also be supported.
>=20
> It=E2=80=99s my understanding that SET_STATUS 0/RESET_DEVICE is problemat=
ic for
> stateful devices.=C2=A0 In a previous email, you wrote that these should
> implement SUSPEND+RESUME so qemu can use those instead.=C2=A0 But those a=
re
> separate things, so I assume we just use SET_STATUS 0 when stopping the VM
> because this happens to also stop processing vrings as a side effect?

SET_STATUS 0 doesn't do anything in most existing vhost-user backends
and QEMU's vhost code doesn't rely on it doing anything. It was added as
an optimization hint for DPDK's vhost-user-net implementation without
noticing that it breaks stateful devices (see commit 923b8921d210).

>=20
> I.e. I understand =E2=80=9Ctreating stateful devices differently=E2=80=9D=
 to mean that qemu
> should use SUSPEND+RESUME instead of SET_STATUS 0 when the back-end suppo=
rts
> it, and stateful back-ends should support it.
>=20
> > > Is it that a status 0 won=E2=80=99t explicitly reset the internal sta=
te, but
> > > because it does mean that the driver is unbound, the state should
> > > implicitly be reset?
> > I think the fundamental problem is that transports like virtio-pci put
> > registers back in their initialization state upon reset, so internal
> > state is lost.
> >=20
> > The VIRTIO spec does not go into detail on device state across reset
> > though, so I don't think much more can be said about the semantics.
> >=20
> > > Anyway.  1 seems to be the relevant point for migration.  As far as I
> > > understand, currently, a vhost-user back-end has no way of knowing wh=
en
> > > to stop processing virt queues.  Basically, rings can only transition
> > > from stopped to started, but not vice versa.  The vhost-user
> > > specification has this bit: =E2=80=9COnce the source has finished mig=
ration,
> > > rings will be stopped by the source. No further update must be done
> > > before rings are restarted.=E2=80=9D  It just doesn=E2=80=99t say how=
 the front-end lets
> > > the back-end know that the rings are (to be) stopped.  So this seems
> > > like a pre-existing problem for stateless migration.  Unless this is
> > > communicated precisely by setting the device status to 0?
> > No, my understanding is different. The vhost-user spec says the
> > backend must "stop [the] ring upon receiving
> > ``VHOST_USER_GET_VRING_BASE``".
>=20
> Yes, I missed that part!
>=20
> > The "Ring states" section goes into
> > more detail and adds the concept of enabled/disabled too.
> >=20
> > SUSPEND is stronger than GET_VRING_BASE though. GET_VRING_BASE only
> > applies to a single virtqueue, whereas SUSPEND acts upon the entire
> > device, including non-virtqueue aspects like Configuration Change
> > Notifications (VHOST_USER_BACKEND_CONFIG_CHANGE_MSG).
> >=20
> > You can approximate SUSPEND today by sending GET_VRING_BASE for all
> > virtqueues. I think in practice this does fully stop the device even
> > if the spec doesn't require it.
> >=20
> > If we want minimal changes to vhost-user, then we could rely on
> > GET_VRING_BASE to suspend and SET_VRING_ENABLE to resume. And
> > SET_STATUS 0 must not be sent so that the device's state is not lost.
>=20
> So you mean that we=E2=80=99d use SUSPEND instead of SET_STATUS 0, but be=
cause we
> have no SUSPEND, we=E2=80=99d ensure that GET_VRING_BASE is/was called on=
 all
> vrings?

Yes. I prefer adding SUSPEND+RESUME to vhost-user, but if we were
limited to today's vhost-user commands, then relying on GET_VRING_BASE
and skipping SET_STATUS calls for vhost_dev_start/stop() would come
close to achieving the behavior needed by stateful backends.

Stefan

--ZGPoR+tbgHGFel9H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRaaaoACgkQnKSrs4Gr
c8j4EwgAlmTc0tWiX62lP5u2fjjNblFzLCQaddyzJlt3pm/u+HVhsJPLY++k9cC3
SmNO8GjtaFPIKWxkVki2QfLsZdRo7S87r3Isv6re8gFvEsQKTuiiTOSqaJ+tzBs9
eclz0VTwsue1XvPrIx6Nk6RENHIcrnPPQrgNooU3JBllEQIeQQ/EKEMyqf9U4Bpo
+Lh6rPriYPKhwQYSiNhr97jEsNMbB2ABbFqSuPmr7j0wtCO+gfxpC35m3j5WuBqj
s4/PicWMxbO+tDzAZUdJ58+5Cg+PNRyT6rCiQVDG1w899Uaw9E2HfnDDcSkQkoib
j5Nq0ETbcvcLChEKju1zis1LXWa6eA==
=s+Ss
-----END PGP SIGNATURE-----

--ZGPoR+tbgHGFel9H--
