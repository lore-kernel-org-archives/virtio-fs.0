Return-Path: <stefanha@redhat.com>
Date: Thu, 26 May 2022 08:49:34 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
References: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="rlDir5U3QoVKFdNx"
Content-Disposition: inline
In-Reply-To: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Prashant Dewan <linux_learner@outlook.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, slp@redhat.com, gmaglione@redhat.com


--rlDir5U3QoVKFdNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:
> Hello Stefan,
>=20
> Here is the output from virtofsd..
>=20
> ------------------------------------
> - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-26 0=
4:41:57 UTC. --
> May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user device=
 daemon.<<Placeholder: run this daemon as non-privileged user>>.
> May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO  vir=
tiofsd] Waiting for vhost-user socket connection...
> May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27=
:11Z INFO  virtiofsd] Client connected, servicing requests
> May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27=
:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidParam)

virtiofsd terminated. I have CCed Sergio and German, who may have
suggestions about what to check next.

Stefan

> May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service: De=
activated successfully.
> May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service: Sc=
heduled restart job, restart counter is at 1.
>=20
> ________________________________
> From: Stefan Hajnoczi
> Sent: Wednesday, May 25, 2022 4:02 PM
> To: Prashant Dewan
> Cc: virtio-fs@redhat.com
> Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
>=20
> On Tue, May 24, 2022 at 02:29:12PM +0000, Pra Dew wrote:
> > I am trying to setup virtfs using KVM and QEMU.
> >
> >
> >   1.  Inside the VM, I do
> >      *   mount -t virtiofs myfs /dev/myfile  --succeeds
> >      *   cd /dev/myfile  -hangs
> >
> >
> >   1.  The host logs -
> >
> >  qemu-system: Failed to write msg. Wrote -1 instead of 20.
>=20
> Sending a vhost-user protocol message failed. It is likely that the
> virtiofsd process terminated and the UNIX domain socket closed on QEMU.
>=20
> Is there any output from virtiofsd?
>=20
> Stefan

--rlDir5U3QoVKFdNx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKPMQ4ACgkQnKSrs4Gr
c8jg/gf9GEyzok9tVmhJzZu3hEJuC1UiHLt8l8uXnde55S/Iw+KF5muW8zQgzkl7
K6u2S1Oku2e1QvyKvgvu8/7Ntb73kXTa1UIwXB7zjaLSNQ559QjqHpbeTL37iNzD
CB867aFuht2R7DBHb+5CBXfKNOiRvoFJyGIHnBZzv4rPOxlHLcE7BipYeKAFVJqr
MXrWRcPLg1z5lNvNUjGIje2xdgvmmB240X/MfP2HlKJF3ZWBZMavmQDnXomtjelr
pAXOp63Rx1tVqvoyDj62do/Ak/F25Gy7v+jLp48jlaZmbY2gosEtn6dwkfKfdi6B
U/ZuEufMY/jm/fq1NQvYlkDVdvIvAA==
=s2mN
-----END PGP SIGNATURE-----

--rlDir5U3QoVKFdNx--
