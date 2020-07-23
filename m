Date: Thu, 23 Jul 2020 13:28:50 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723122850.GI186372@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722175820.GL2660@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MPkR1dXiUZqK+927"
Content-Disposition: inline
In-Reply-To: <20200722175820.GL2660@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, rmohr@redhat.com, qemu-devel@nongnu.org, vromanso@redhat.com


--MPkR1dXiUZqK+927
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 06:58:20PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
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
>=20
> OK, I'm guessing the behaviour of what happens if the host adds another
> mount afterwards might be different?

Running inside a container with -o chroot:
 - The container has its own mount namespace and it is therefore not
   affected, modulo shared subtrees (see mount(8)).

Running outside a container with -o chroot:
 - Path traversal can only reach mounts that are made within the shared
   directory tree. Technically other mounts are still there but it is
   not possible to reach them via file system paths.

> > 2. Pid namespace. This should be fine because virtiofsd is the only
> >    process running in the container.
>=20
> Is it ? Isn't the qemu and any other vhost-user processes also in the
> same container?

No. QEMU, virtiofsd, and other vhost-user processes should run in their
own containers. Application container images are typically designed to
run a single program per container. It's technically possible to launch
multiple programs but that is considered bad practice for application
containers.

Kubernetes:
Containers in a pod do not share a single pid namespace by default.
Pods do share a single network namespace so they can communicate via
UNIX domain sockets.

> > 3. Network namespace. This should be fine because seccomp already
> >    rejects the connect(2) syscall, but an additional layer of security
> >    is lost. Container runtime-specific network security policies can be
> >    used drop network traffic (except for the vhost-user UNIX domain
> >    socket).
>=20
> Should this be tied to the same flag - this feels different from the
> chroot specific problem.

Good point. Daniel Berrange has suggested another command-line syntax
that makes sandbox configuration more modular. I'll try to implement
something like that.

Stefan

--MPkR1dXiUZqK+927
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8ZgoIACgkQnKSrs4Gr
c8h1zwf+OetM+DquK6ixEWTGmiV9CQJ/x8PVDkAON2pb35cjoFNFks6bK90wheCl
ajGM2zlXhyLK64HEqhDhlmK+2gVBzpJeMNpRwAPFIkZeRKNxW9xYmH0bxLVxJtTf
3PslPVM10L/o3S5NLB/j0lVRL5EdR9nOtL1+FEPhGlNC9Y6MNhM3sUWHPtDQr+CB
dEq7WD6HauBwi8esX3S6Izut2AieqVKgI3NoecZ8NPmCftEj3LLkXHhy0Z+R/SHV
E6hG/LZGv5ka6p+B4C86PCqEof7lNepm4xPUrCptByEQsPM/zigzwq0TuodclevP
OC7Qts4qjuFt7y1Ts5gsIcsTk9YSgw==
=o4bu
-----END PGP SIGNATURE-----

--MPkR1dXiUZqK+927--

