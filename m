Date: Fri, 24 Jul 2020 13:22:52 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200724122252.GA333683@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722190318.GM2660@work-vm>
	<20200723123229.GK186372@stefanha-x1.localdomain>
	<20200723175538.GW2621@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20200723175538.GW2621@work-vm>
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


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2020 at 06:55:38PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Wed, Jul 22, 2020 at 08:03:18PM +0100, Dr. David Alan Gilbert wrote:
> > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > +    /*
> > > > +     * Make the shared directory the file system root so that FUSE=
_OPEN
> > > > +     * (lo_open()) cannot escape the shared directory by opening a=
 symlink.
> > > > +     *
> > > > +     * It's still possible to escape the chroot via lo->proc_self_=
fd but that
> > > > +     * requires gaining control of the process first.
> > > > +     */
> > > > +    if (chroot(lo->source) !=3D 0) {
> > > > +        fuse_log(FUSE_LOG_ERR, "chroot(\"%s\"): %m\n", lo->source);
> > > > +        exit(1);
> > > > +    }
> > >=20
> > > I'm seeing suggestions that you should drop CAP_SYS_CHROOT after
> > > chroot'ing to stop an old escape (where you create another jail inside
> > > the jail and the kernel then lets you walk outside of the old one).
> >=20
> > That's already the case:
> >=20
> > 1. setup_seccomp() blocks further chroot(2) calls.
> > 2. setup_capabilities() drops CAP_SYS_CHROOT.
>=20
> Ah yes; could you add a comment if you respin; it's not obvious that
> the capability to chroot allows you to break out of an existing chroot
> you're in.

Sure.

Stefan

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8a0pwACgkQnKSrs4Gr
c8gtjAf+N3a6aSnhKxco1M3LCLZ/NcE9w+b0cAGpoxUawTBFfxYCHoT569DSsB5M
qBhQsAw6JWm6FvmnsSlrND2m6bIvARP5k3OOZzwyv7jrfCkoWG/q53ULaWCtYsOr
NFrGoqrDKicuwZa8YwJOERT+yJv/wIpWPJ585UIU8F5NtQ4LirYz2W71YfxkU519
czYfiAoY42QJSmrCjEi18SJCfD6gS7cbY5yOKAWq2y5zK8mGJe2j91WXa4N/DssH
79C2XlmEWpAvQUbXBsO5oYpuxNzRgWBiNruP5PkltPtOtIHOV0nbTnbOvR8aHj9N
vNUXY8FWOmZTE4VXa2zvuOCphT6gWg==
=3N0O
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--

