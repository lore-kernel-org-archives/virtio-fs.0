Return-Path: <stefanha@redhat.com>
Date: Tue, 9 May 2023 10:53:32 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230509145332.GD926999@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <CAJaqyWdhBq=0f-Qhbdg3AduS8zkPV5p6-uEEn24p1hRKcA3pOQ@mail.gmail.com>
 <05e9946d-f2be-f594-fea2-d1d03686b644@redhat.com>
 <20230508211002.GC926999@fedora>
 <a2e87bab-41c3-0402-927e-54d0a0e67d43@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="tGVhIo4KYIiSUs8I"
Content-Disposition: inline
In-Reply-To: <a2e87bab-41c3-0402-927e-54d0a0e67d43@redhat.com>
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
Cc: Eugenio Perez Martin <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--tGVhIo4KYIiSUs8I
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 10:53:35AM +0200, Hanna Czenczek wrote:
> On 08.05.23 23:10, Stefan Hajnoczi wrote:
> > On Fri, May 05, 2023 at 02:51:55PM +0200, Hanna Czenczek wrote:
> > > On 05.05.23 11:53, Eugenio Perez Martin wrote:
> > > > On Fri, May 5, 2023 at 11:03=E2=80=AFAM Hanna Czenczek <hreitz@redh=
at.com> wrote:
> > > > > On 04.05.23 23:14, Stefan Hajnoczi wrote:
> > > > > > On Thu, 4 May 2023 at 13:39, Hanna Czenczek <hreitz@redhat.com>=
 wrote:
> > > [...]
> > >=20
> > > > > > All state is lost and the Device Initialization process
> > > > > > must be followed to make the device operational again.
> > > > > >=20
> > > > > > Existing vhost-user backends don't implement SET_STATUS 0 (it's=
 new).
> > > > > >=20
> > > > > > It's messy and not your fault. I think QEMU should solve this by
> > > > > > treating stateful devices differently from non-stateful devices=
=2E That
> > > > > > way existing vhost-user backends continue to work and new state=
ful
> > > > > > devices can also be supported.
> > > > > It=E2=80=99s my understanding that SET_STATUS 0/RESET_DEVICE is p=
roblematic for
> > > > > stateful devices.  In a previous email, you wrote that these shou=
ld
> > > > > implement SUSPEND+RESUME so qemu can use those instead.  But thos=
e are
> > > > > separate things, so I assume we just use SET_STATUS 0 when stoppi=
ng the
> > > > > VM because this happens to also stop processing vrings as a side =
effect?
> > > > >=20
> > > > > I.e. I understand =E2=80=9Ctreating stateful devices differently=
=E2=80=9D to mean that
> > > > > qemu should use SUSPEND+RESUME instead of SET_STATUS 0 when the b=
ack-end
> > > > > supports it, and stateful back-ends should support it.
> > > > >=20
> > > > Honestly I cannot think of any use case where the vhost-user backend
> > > > did not ignore set_status(0) and had to retrieve vq states. So maybe
> > > > we can totally remove that call from qemu?
> > > I don=E2=80=99t know so I can=E2=80=99t really say; but I don=E2=80=
=99t quite understand why qemu
> > > would reset a device at any point but perhaps VM reset (and even then=
 I=E2=80=99d
> > > expect the post-reset guest to just reset the device on boot by itsel=
f,
> > > too).
> > DPDK stores the Device Status field value and uses it later:
> > https://github.com/DPDK/dpdk/blob/main/lib/vhost/vhost_user.c#L2791
> >=20
> > While DPDK performs no immediate action upon SET_STATUS 0, omitting the
> > message will change the behavior of other DPDK code like
> > virtio_is_ready().
> >=20
> > Changing the semantics of the vhost-user protocol in a way that's not
> > backwards compatible is something we should avoid unless there is no
> > other way.
>=20
> Well, I have two opinions on this:
>=20
> First, that in DPDK sounds wrong.=C2=A0 vhost_dev_stop() is called mostly=
 by
> devices that call it when set_status is called on them.=C2=A0 But they do=
n=E2=80=99t call
> it if status =3D=3D 0, they call it if virtio_device_should_start() retur=
ns
> false, which is the case when the VM is stopped.=C2=A0 So basically we se=
t a
> status value on the back-end device that is not the status value that is =
set
> in qemu. If DPDK makes actual use of this status value that differs from
> that of the front-end in qemu, that sounds like it probably actually wron=
g.
>=20
> Second, it=E2=80=99s entirely possible and probably probable that DPDK do=
esn=E2=80=99t make
> =E2=80=9Cactual use of this status value=E2=80=9D; the only use it probab=
ly has is to
> determine whether the device is supposed to be stopped, which is exactly
> what qemu has tried to confer by setting it to 0.=C2=A0 So it=E2=80=99s b=
asically two
> implementations that have agreed on abusing a value to emulate behavior t=
hat
> isn=E2=80=99t otherwise implement (SUSPEND), and that works because all d=
evices are
> stateless.=C2=A0 Then, I agree, we can=E2=80=99t change this until it get=
s SUSPEND
> support.
>=20
> > The fundamental problem is that QEMU's vhost code is designed to reset
> > vhost devices because it assumes they are stateless. If an F_SUSPEND
> > protocol feature bit is added, then it becomes possible to detect new
> > backends and suspend/resume them rather than reset them.
> >=20
> > That's the solution that I favor because it's backwards compatible and
> > the same model can be applied to stateful vDPA devices in the future.
>=20
> So basically the idea is the following: vhost_dev_stop() should just susp=
end
> the device, not reset it.=C2=A0 For devices that don=E2=80=99t support SU=
SPEND, we still
> need to do something, and just calling GET_VRING_BASE on all vrings is
> deemed inadequate, so they are reset (SET_STATUS 0) as a work-around,
> assuming that stateful devices that care (i.e. implement SET_STATUS) will
> also implement SUSPEND to not have this =E2=80=9Clegacy reset=E2=80=9D ha=
ppen to them.
>=20
> Sounds good to me.=C2=A0 (If I understood that right. :))

Yes.

Stefan

--tGVhIo4KYIiSUs8I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRaXmwACgkQnKSrs4Gr
c8g+EggAw5qZaO/U8zNYOrgoZ2fi2uB9Yz8d2xku7SQU5QZD1en32Jp9C+RmgEFb
YGSQ+GwYU+H0vgObSkoK8j26bwSl9vL4QrpnTsWqAZKiMczxiAhIX9qP1Shktt4/
Zl6d6bC5X9eBQIk5nhAfiJJFZulHXBdOMACDsqW99uZGxEFnapPhzu/ULrnB+c4+
FfIHn7eRKIOXMSHPnfJGcMQv6BFVetVETlmoQAb48dq36GsTG2V2sGTB4pCHj7hk
1PCd1cOumubcYTrjUDjmXV0b2qCy0bw5+IM/GiA8PSjryj5IKOZ2bJvorDEgJMAh
XVjJW7B/frnKgzDtPqYYnWXHz3zffQ==
=gSjc
-----END PGP SIGNATURE-----

--tGVhIo4KYIiSUs8I--
