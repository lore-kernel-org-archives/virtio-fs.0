Date: Thu, 14 Jan 2021 13:34:24 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210114133424.GA299876@stefanha-x1.localdomain>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
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


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 02:11:28PM +0530, P J P wrote:
>   Hello,
>=20
> * Recently I realised that virtiofsd(1) process does not drop its 'root'
>   privileges while sharing host directory tree with a guest VM.
>=20
>   Libvirtd(8) generally starts a guest VM with non-root system user (ex. =
qemu)
>   privileges. If virtiofsd(1) has 'root' privileges, that makes it an
>   accomplice in a potential guest-to-host privilege escalation scenario. =
Which
>   is not good.
>=20
> * IMHO, ideally virtiofsd(1) should not run with 'root' privileges at all.
>=20
> * But If it has to, then atleast all default configuration settings must =
be
>   utmost strict and restrictive as possible. Ex. By default offer only re=
ad
>   access to guest VM.

That's not useful. Most users require read-write.

> * Another option is for root virtiofsd(1) process to fork a sub-process w=
hich
>   will run with non-root (ex. qemu) system user privileges.
>=20
>    - All file I/O operations for sharing a host directory with a guest are
>      performed by the sub-process with non-root system user privileges.
>=20
>    - Sub-process shall talk to the parent virtiofsd(1) process only when
>      privileged operation/assistance is required.
>=20
>   Ex. https://www.nginx.com/blog/inside-nginx-how-we-designed-for-perform=
ance-scale/
>=20
> ...wdyt?

Please take a look at the current sandboxing implementation in
virtiofsd. It greatly restricts the process. virtiofsd is not just a
process running freely with uid root.

Unlike nginx, virtiofsd needs to perform privileged operations as part
of serving requests. The fundamental issue is that the server must be
able to create, access, and modify files with arbitrary uids/gids.

If you have specific ideas, let's discuss them. We have been following
user namespace and uid/gid mapping/shifting features. They are not
widely available in Linux yet, but once they are it should be possible
to run with root only inside the user namespace (i.e. actually
unprivileged).

There is also an unfinished security document here that we could discuss
further and publish:
https://gitlab.com/virtio-fs/qemu/-/merge_requests/6/diffs?commit_id=3D718c=
71fa44f6b92ac27558c903d27935236b08ef

Stefan

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAASGAACgkQnKSrs4Gr
c8jTYwgAvFrOkWosLBia7KPo1JZxOHdd2QqGAnia1uh8br5k1MI9RkXXleCN0eU/
3R9qjoi+beTVz2gmaZ5u3urRB72zuK0QEUarO8gYcea1KhQ/rVpQWs4zfUgW8KOq
GSgemckqg4hJZnagGTFf9c/C+AweL963hDTP6diciIzE17d9SEeSQY9Nq35EyB6r
dS1emQZiPfpWqMia9zRsTI46tX2yM3OtG0tr0vz3eH6STU7g/hqDCjjW5Qh17XAE
7BDQt4f4bIF7l90z/f+mhLdcKt+Gob6EESJISR36ikSdSEfeE2MB7UL5m55MZHMf
A68wj1vYBDd0dRTymdIB6Yu3oFWV1A==
=fzMr
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--

