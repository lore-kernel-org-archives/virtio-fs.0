Date: Wed, 20 Jan 2021 16:20:11 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210120162011.GA5177@stefanha-x1.localdomain>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
	<20210118165541.GD255498@stefanha-x1.localdomain>
	<9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: P J P <ppandit@redhat.com>
Cc: virtio-fs@redhat.com


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2021 at 08:04:29PM +0530, P J P wrote:
> +-- On Mon, 18 Jan 2021, Stefan Hajnoczi wrote --+
> | Guest applications may run with different uids/gids. The host has no co=
ntrol=20
> | over that.
> |=20
> | Imagine booting a guest form a virtio-fs root file system and installin=
g=20
> | packages. The guest must be able to control uids/gids for that to work.
>=20
> * I see; I'll try to better understand how it's done.
>=20
> * With UID namespaces, I thought virtiofsd(1) would be able to operate fi=
les=20
>   with arbitrary uid/gid, even after dropping its root privileges to acqu=
ire=20
>   non-root privileges on the host; Because it has 'root' privileges under=
 the=20
>   shared directory & UID namespace.

Excatly, this is the most promising direction but it has a limitation:
the uid/gid on the host file system are in the uid/gid range that was
assigned to the user namespace. If anything other than the VM needs to
access those files then you need to either ensure it runs with the
currect uid/gid on the host or chown the files. That complicates some
use cases. It does seem worth offering as a feature but only works for
some use cases.

When Linux gets uid/gid mapping functionality this issue will be solved.
virtiofsd will run unprivileged but the host files can have the correct
uid/gids.

Stefan

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAIWDsACgkQnKSrs4Gr
c8iUdQgAxaHAjSCCkYsPY3vO/03jSGKbbbGGLlumMjzVytzKjtj2LodSN/MKgDKG
TFxONkjjkTb6NAq/KcBYJz39oh3goFQyGt8/vRenYzCfP+G5QEnU/iHVZBb5EUY+
ligO2nTmr0oFrlhIUiXN4OAIUH62aEfrNX4dwH7zr2zPNnGaZMg7c0b09PH36qNx
J5luXZM10dJtP8RsIulhxmaQkuevqEQR3LVCi4SfTkCEW8k7+Jot3XojfZp1epD8
XP41C84oie7x4/94NJcMQjCo4t1Cxx6AN5HK8AHMBlahjAgJYT0KKGqaNhKnZTA2
gp/al/IAepbpM9C70NI/nKMi4kbkZA==
=oUA/
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

