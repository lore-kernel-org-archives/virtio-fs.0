Date: Thu, 23 Jul 2020 13:32:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200723123229.GK186372@stefanha-x1.localdomain>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-3-stefanha@redhat.com>
	<20200722190318.GM2660@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="W/+CTqSGWdiRg+8j"
Content-Disposition: inline
In-Reply-To: <20200722190318.GM2660@work-vm>
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


--W/+CTqSGWdiRg+8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 08:03:18PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > +    /*
> > +     * Make the shared directory the file system root so that FUSE_OPEN
> > +     * (lo_open()) cannot escape the shared directory by opening a sym=
link.
> > +     *
> > +     * It's still possible to escape the chroot via lo->proc_self_fd b=
ut that
> > +     * requires gaining control of the process first.
> > +     */
> > +    if (chroot(lo->source) !=3D 0) {
> > +        fuse_log(FUSE_LOG_ERR, "chroot(\"%s\"): %m\n", lo->source);
> > +        exit(1);
> > +    }
>=20
> I'm seeing suggestions that you should drop CAP_SYS_CHROOT after
> chroot'ing to stop an old escape (where you create another jail inside
> the jail and the kernel then lets you walk outside of the old one).

That's already the case:

1. setup_seccomp() blocks further chroot(2) calls.
2. setup_capabilities() drops CAP_SYS_CHROOT.

Stefan

--W/+CTqSGWdiRg+8j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8Zg10ACgkQnKSrs4Gr
c8h4HQf/RUS35yKPn0YuL0Blj7IStwftED6MWxJTsn76LYo4pnAtm1LLqWgDBuHo
qzpHnQhP7LEka+NA83+Vqmfz2qXtsYbj6itgLA73h/15b2pMWCkKg9U2yM0iztJp
pg4zDLUrt54i9NFTdRTsj+CHGFHdgspf+8ipMLhsiybtph3skBQtk3EvRUyVMJhR
2LxS5pRUCbr9uS5l/QLv9VAjcsCgEW98p2HG4uCJo6tY0li9iFY63Q5to3HL3rCy
EGMkFSOk/KYMcIoJQqSIO7getjtLVJuVqBxocKeYz2k7acpnE7UOODn9AVwWyfgn
FecaTHoPhmvjwaKwjUaQbmnbXs/fOQ==
=Yuf1
-----END PGP SIGNATURE-----

--W/+CTqSGWdiRg+8j--

