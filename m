Date: Thu, 23 Jul 2020 13:17:08 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723121708.GH186372@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722165811.GT2324845@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="h3LYUU6HlUDSAOzy"
Content-Disposition: inline
In-Reply-To: <20200722165811.GT2324845@redhat.com>
Subject: Re: [Virtio-fs] [PATCH for-5.1 2/3] virtiofsd: add
 container-friendly -o chroot sandboxing option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com


--h3LYUU6HlUDSAOzy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 05:58:11PM +0100, Daniel P. Berrang=E9 wrote:
> On Wed, Jul 22, 2020 at 02:02:05PM +0100, Stefan Hajnoczi wrote:
> > virtiofsd cannot run in an unprivileged container because CAP_SYS_ADMIN
> > is required to create namespaces.
> >=20
> > Introduce a weaker sandbox that is sufficient in container environments
> > because the container runtime already sets up namespaces. Use chroot to
> > restrict path traversal to the shared directory.
> >=20
> > virtiofsd loses the following:
> >=20
> > 1. Mount namespace. The process chroots to the shared directory but
> >    leaves the mounts in place. Seccomp rejects mount(2)/umount(2)
> >    syscalls.
> >=20
> > 2. Pid namespace. This should be fine because virtiofsd is the only
> >    process running in the container.
> >=20
> > 3. Network namespace. This should be fine because seccomp already
> >    rejects the connect(2) syscall, but an additional layer of security
> >    is lost. Container runtime-specific network security policies can be
> >    used drop network traffic (except for the vhost-user UNIX domain
> >    socket).
>=20
> IIUC this relies on the fact that the container will still have=20
> CAP_SYS_CHROOT IOW, we still don't have a solution for running
> virtiofsd as an unprivileged user.

Yes, this still requires root in the container.

Stefan

--h3LYUU6HlUDSAOzy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8Zf8QACgkQnKSrs4Gr
c8iLbwgAviC1NQgA4Vm+Xio7KYEn44ZsEpL2SFhZD27BjsmxEv+YFMlYL/8fAXiR
h1ApQwFKEcy8wQ+iVYVLYnJDJm+DTBMEH8vWI+NiPYNN01MhXZzvtNd31LWXJyOg
9sSfS5GZqFNFk0ybcmDfh/ENjDHRbf+vdmJe9c5VpXEzJDa8i37aSz3AlqXiZv1h
vAvB+etU8uC2cJkxPFUlAlyWMXkGM6rxQ6TecVbLMGj7RJICaJVzI/MH42MPwguL
HsPPzHT3Q5F56X457aJO6oevjHYsfCy7Olmu2m9r/I2sCqB5EjO1DwyCYo3CjbuU
3Uk0+8jqh5lJx0K08vtWPoXK+NBL4A==
=x66X
-----END PGP SIGNATURE-----

--h3LYUU6HlUDSAOzy--

