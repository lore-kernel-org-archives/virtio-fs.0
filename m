Date: Fri, 25 Oct 2019 14:53:23 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191025125323.GD13314@stefanha-x1.localdomain>
References: <20191016160157.12414-1-stefanha@redhat.com>
	<20191016160157.12414-3-stefanha@redhat.com>
	<20191024102611.GF3700@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
In-Reply-To: <20191024102611.GF3700@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: move to a new pid namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2019 at 11:26:11AM +0100, Daniel P. Berrang=E9 wrote:
> On Wed, Oct 16, 2019 at 05:01:57PM +0100, Stefan Hajnoczi wrote:
> It might be useful to call prctl(PR_SET_PDEATHSIG) here, so that
> if the parent process exits for any reason, the child will be killed
> off too.
[...]
> I feel like this is making things a bit misleading.
>=20
>  setup_pid_namespace()
>=20
> is now creating the mount namespace and pid namespace, and doing
> some mount point config
>=20
>  setup_mount_namespace()
>=20
> is not creating the mount namespace, but is doing some more mount
> point config.
>=20
> And then there's setup_net_namespace() too.
>=20
> I think there could be a  single
>=20
>   setup_namespaces()
>=20
> method that does the unshare(CLONE_NEWNS|CLONE_NEWNET|CLONE_NEWPID)
> and forking the child.
>=20
> And a setup_mounts()
>=20
> method that does all the mount() calls.

Thanks for your suggestions.  I'll implement both of them as follow-up
patches since this has already been included in the virtiofsd code.

Stefan

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2y8EMACgkQnKSrs4Gr
c8jRvQf/WTMG6gI+jzx5Ytr7ApU7nlx516Kmq/BtgD0DPng+qO/+VRLEH5uvCXAv
jfVP2dHA9LMwlH1YyyVXdvpkfb7JF/LMY6ZR85D43fRV43LRcgrsuVfXLbw8E56d
kKS6t7EziGQH9Qdp3rNKa1tvDliRa9Iwgqbxk83xGJEDeONo3AFry+L5jQroLXH5
3kCiXAHlPeFfQGmDo1CW7U1h7sIKtJ6SQLHyIB4+gMjDjKzN3aO00EahWg65Daqn
pPCW7Wdmt0kSJE7oxMLri2NphsLanaFpOgD8+Qag8olxg62JU5hmnRdiG3G19xzZ
+UmiuS7fXAPTDECy6mvMm/7uLCnkLA==
=TwjB
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--

