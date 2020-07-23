Date: Thu, 23 Jul 2020 16:36:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723153647.GB300121@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722175820.GL2660@work-vm>
	<20200723122850.GI186372@stefanha-x1.localdomain>
	<20200723134733.GA5885@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20200723134733.GA5885@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vromanso@redhat.com, rmohr@redhat.com


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2020 at 09:47:33AM -0400, Vivek Goyal wrote:
> On Thu, Jul 23, 2020 at 01:28:50PM +0100, Stefan Hajnoczi wrote:
> > On Wed, Jul 22, 2020 at 06:58:20PM +0100, Dr. David Alan Gilbert wrote:
> > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > virtiofsd cannot run in an unprivileged container because CAP_SYS_A=
DMIN
> > > > is required to create namespaces.
> > > >=20
> > > > Introduce a weaker sandbox that is sufficient in container environm=
ents
> > > > because the container runtime already sets up namespaces. Use chroo=
t to
> > > > restrict path traversal to the shared directory.
> > > >=20
> > > > virtiofsd loses the following:
> > > >=20
> > > > 1. Mount namespace. The process chroots to the shared directory but
> > > >    leaves the mounts in place. Seccomp rejects mount(2)/umount(2)
> > > >    syscalls.
> > >=20
> > > OK, I'm guessing the behaviour of what happens if the host adds anoth=
er
> > > mount afterwards might be different?
> >=20
> > Running inside a container with -o chroot:
> >  - The container has its own mount namespace and it is therefore not
> >    affected, modulo shared subtrees (see mount(8)).
>=20
> How does virtiofsd inside container gets the directory it wants to
> export to guest? I am assuming that its probably a volume mount
> inside container. If yes, volume mounts can set propagation
> properties say "slave" and that means mounts done later will
> propagate inside container in that volume (and hopefully be
> visible inside guest once submount patches are upstream).

Yes, the shared directory is a volume mount and propagation works as
expected:

  $ docker run -v path/to/shared-dir:/shared-dir:slave \
	       -v /tmp/socket-dir:/var/run \
	       virtiofsd

When I mount things in path/to/shared-dir on the host they appear in
/shared-dir inside the guest. When I omit the "slave" option (the
default is "private") then the mount does not propagate.

The following Dockerfile was used:

  $ cp ~/src/qemu/virtiofsd . # copy the executable
  $ cat >Dockerfile
  FROM fedora:32
  COPY --chown=3D0:0 virtiofsd /usr/bin/virtiofsd
  RUN dnf update -qy && dnf install -qy libseccomp liburing zlib glib2 nett=
le gnutls libcap-ng
  VOLUME ["/shared-dir", "/var/run"]
  CMD ["/usr/bin/virtiofsd", "--socket-path=3D/var/run/virtiofsd.sock", "-o=
", "source=3D/shared-dir", "-o", "cache=3Dauto", "-o", "no_posix_lock", "-o=
", "xattr", "-o", "chroot"]

Stefan

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8Zro8ACgkQnKSrs4Gr
c8iWkggAtGpbfo1cQOxcG92FgjYSVkpMbpQGp+Mlmr1zpPbb/3jfk9KnX8ONeV5M
YqCPm0tkPdX0Ufjkzano+Q3X1udYRCk3AShn7CfwhrkcWixQzzdk0QzO24pJDOjX
tL1msD+tMuljJf4X6lqAxFnTVWegUPcGGtRH4kk+ebNoPwccWdO6f1P9y50Q5ChB
POu4IFzY92ykUhJSB1EkyUKiQiqa467jU8twOkhaHjcw2ydGAs4Q6LAWSCgB0z+S
QWgBhS/4VcMxipfOQC3kj1Zlhlax6Jp8QnokO95MHyIATVk0FS93K8o/g6CkbzNb
TMoVWMMIHn1F4oMmVvpoF6JvWO0CfQ==
=paOA
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--

