Date: Wed, 29 Jul 2020 15:29:53 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200729142953.GE52286@stefanha-x1.localdomain>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728153219.GC21660@stefanha-x1.localdomain>
	<c5b15243-200b-fa17-27b5-1b27dbddbe6d@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Content-Disposition: inline
In-Reply-To: <c5b15243-200b-fa17-27b5-1b27dbddbe6d@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, Roman Mohr <rmohr@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2020 at 03:15:25PM -0400, Daniel Walsh wrote:
> On 7/28/20 11:32, Stefan Hajnoczi wrote:
> > On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> >> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> >> misono.tomohiro@fujitsu.com> wrote:
> >>
> >>>> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print=
 an
> >>> error
> >> "Just" pointing docker to a different seccomp.json file is something w=
hich
> >> k8s users/admin in many cases can't do.
> > There is a Moby PR to change the default seccomp.json file here but it's
> > unclear if it will be merged:
> > https://github.com/moby/moby/pull/41244
> >
> > Stefan
>=20
> Why not try Podman?

Absolutely, Podman allows unshare(2) in its default seccomp policy so it
does not have this problem.

I think Roman's point was mainly about the upstream user experience
where Docker is common.

Stefan

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8hh+AACgkQnKSrs4Gr
c8j8nQgAp70hD2BPLqDLm5JIwSXUuitCFEM/4u7WRCIu4k+IHcAdopIHEolwkQ3p
p05v4mTk69BwTNbFfKwzX2o8yXu/sjT96BqZqDtcJIoGH4vZd5l1yiqefGD8VvQM
qvTqOw8P3oXeY/H4WsluTbsQfL6aKuWjuBdSReOoTrUqfXnvH+Y2N3Y+yPIuFWeF
7Fnak1afGTeShhTWyDCLgomu1fwgdVSLZUt56bJ7ARaBkgr0YRsykdXUP4c1KkUO
93LoEW1Vwoxm/J+yziECd02oruuu9SM1M5CY/FOGxS7kBiebs683tI3Cq2zfBE4c
a3Yff6jYM4fFFN62MpB95KJ2JFenmg==
=eINk
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--

