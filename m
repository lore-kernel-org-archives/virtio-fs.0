Date: Thu, 23 Jul 2020 13:29:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723122924.GJ186372@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722181710.GA598987@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Content-Disposition: inline
In-Reply-To: <20200722181710.GA598987@redhat.com>
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
Cc: virtio-fs@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, rmohr@redhat.com


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 02:17:10PM -0400, Vivek Goyal wrote:
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
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/helper.c         |  3 +++
> >  tools/virtiofsd/passthrough_ll.c | 44 ++++++++++++++++++++++++++++++--
> >  2 files changed, 45 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> > index 3105b6c23a..7421c9ca1a 100644
> > --- a/tools/virtiofsd/helper.c
> > +++ b/tools/virtiofsd/helper.c
> > @@ -151,6 +151,9 @@ void fuse_cmdline_help(void)
> >             "    -o cache=3D<mode>            cache mode. could be one =
of \"auto, "
> >             "always, none\"\n"
> >             "                               default: auto\n"
> > +           "    -o chroot|no_chroot        use container-friendly chro=
ot instead\n"
> > +           "                               of stronger mount namespace=
 sandbox\n"
> > +           "                               default: false\n"
>=20
> This option name disabling namespace setup is little confusing to me.
>=20
> Will it make sense to provide another option to disable/enable
> namespaces. "-o no-namespaces" and that disables setting up
> namespaces.

Thanks, I'll propose a new syntax.

Stefan

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8ZgqQACgkQnKSrs4Gr
c8h2qAgAyLOF3qPM7OoCvAWSwDCEsd0FRWJFZcterUjQ//F5p4gyp3tB0KTJdmpO
VCs7ileThaahPFtmW9bw1iZAFVh+x9juOk6jusR1k4hE/caBQxpUsiKjnQaIFtWS
TquT7UD/4DWE3bokfB9NZ7K7fiNR4ZAswCEO+6dXQDCxWVX0YdRaXDnq+s7c7wyq
ebIYRc5ZidHaF3A+vrETTACycBxI/FjjVrvKi85S0E7ILs1TuuuL3AawaAB9lIGO
5oCvRhxyVnfK60iI4+iUWo+vIF6pL3Ao//y2yeTkSyBFxwbtb5W7EWt/4Ttwp1Wa
xfZRxvqJVZKEk6ynPnJlHpHenrEdZw==
=RCxG
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--

