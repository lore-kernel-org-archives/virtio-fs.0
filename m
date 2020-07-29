Date: Wed, 29 Jul 2020 15:40:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200729144027.GF52286@stefanha-x1.localdomain>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
	<CALDPj7uvquu=YWX_Ve7ROdj=LZWjkgPOm+wvEAynGvjeF4Xivg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Content-Disposition: inline
In-Reply-To: <CALDPj7uvquu=YWX_Ve7ROdj=LZWjkgPOm+wvEAynGvjeF4Xivg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Roman Mohr <rmohr@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>


--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2020 at 09:59:01AM +0200, Roman Mohr wrote:
> On Tue, Jul 28, 2020 at 3:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>=20
> > On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> > > On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> > > misono.tomohiro@fujitsu.com> wrote:
> > >
> > > > > Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and pr=
int
> > an
> > > > error
> Yes they can run as root. I can tell you what we plan to do with the
> containerized virtiofsd: We run it as part of the user-owned pod (a set of
> containers).
> One of our main goals at the moment is to run VMs in a user-owned pod
> without additional privileges.
> So that in case the user (VM-creator/owner) enters the pod or something
> breaks out of the VM they are just in the unprivileged container sandbox.
> As part of that we try to get also rid of running containers in the
> user-context with the root user.
>=20
> One possible scenario which I could think of as being desirable from a
> kubevirt perspective:
> We would run the VM in one container and have an unprivileged
> virtiofsd container in parallel.
> This container already has its own mount namespace and it is not that
> critical if something manages to enter this sandbox.
>=20
> But we are not as far yet as getting completely rid of root right now in
> kubevirt, so if as a temporary step it needs root, the current proposed
> changes would still be very useful for us.

What is the issue with root in user namespaces?

I remember a few years ago it was seen as a major security issue but
don't remember if container runtimes were already using user namespaces
back then.

I guess the goal might be simply to minimize Linux capabilities as much
as possible?

virtiofsd could nominally run with an arbitrary uid/gid but it still
needs the Linux capabilities that allow it to change uid/gid and
override file system permission checks just like the root user. Not sure
if there is any advantage to running with uid 1000 when you still have
these Linux capabilities.

Stefan

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8hilsACgkQnKSrs4Gr
c8gTAAgAg3n9zRW0ZMJOMe2UgsbMHF8o5QaHKAHCrYSIkZH8D/vuRm1ZTRLVleBq
ovB+lwmEFNZ6rfV69hJLuoU4v2qzUVHOa4i/K2O/EytfnIaGDn82dQiiXRaHXTiL
xKWp3eXhYYzHELEwc+9wgH3965MsOhUdopah1TpG/9W3LA8P9f4yOQJQmuq9RTsl
dTZFHzv1lnNUUUQKpJzZt14yz3tLRNpgopfPZnyEUnsuT/ZFwySdX0t/qyFQWaSu
aT6T+pDYjw9syKZmwEB6iI3iFmFhIWQABBV+8hizOjPkLHAjIwex+wcFEO3a2iup
S9otKVU5gLQMU+AUfWltexAKYVfgTA==
=v/Fl
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--

