Return-Path: <stefanha@redhat.com>
Date: Wed, 25 May 2022 17:02:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Yo5TEFsNI3XOB+aL@stefanha-x1.localdomain>
References: <BY5PR14MB38937584E1C443A7BB3B0BCF86D79@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="AOWdCJO3rdfoV8S7"
Content-Disposition: inline
In-Reply-To: <BY5PR14MB38937584E1C443A7BB3B0BCF86D79@BY5PR14MB3893.namprd14.prod.outlook.com>
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
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>


--AOWdCJO3rdfoV8S7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2022 at 02:29:12PM +0000, Prashant Dewan wrote:
> I am trying to setup virtfs using KVM and QEMU.
>=20
>=20
>   1.  Inside the VM, I do
>      *   mount -t virtiofs myfs /dev/myfile  --succeeds
>      *   cd /dev/myfile  -hangs
>=20
>=20
>   1.  The host logs -
>=20
>  qemu-system: Failed to write msg. Wrote -1 instead of 20.

Sending a vhost-user protocol message failed. It is likely that the
virtiofsd process terminated and the UNIX domain socket closed on QEMU.

Is there any output from virtiofsd?

Stefan

--AOWdCJO3rdfoV8S7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKOUxAACgkQnKSrs4Gr
c8gsMAgAtCVE+Nve97olEp+e2B948lRAk/w3rdRJVCc8fcIrOEYpO0mJCw2Toj8y
atmOWV5gjC23VxAkgBsoHK34PN7i68pdp84vUy89PBycKpuXDgrVo3Z143qvtXqQ
FvaVZvhLmK7tKOXR6ZTBZb4ts2n6Gn91Hjlw6W0CokCBYfOMOQUI4FzRuuETJaCn
+zrc71mLTVVd9kPU4fAPcO/Jc8cF6pUe/yMLQBeiGSoz1W3Tn2zF3Hgx9VO3SVxO
ILWlsT3ZR6XEI8iB3RgyLQJw1omqShaV2cAnr2CvGTzSSTS0NJIh+nWlGRxtIViU
XER3OOYQ7YpLjh8r0yAcswYkD0w0Fw==
=oAu9
-----END PGP SIGNATURE-----

--AOWdCJO3rdfoV8S7--
