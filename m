Date: Fri, 31 Jul 2020 09:26:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200731082638.GA173083@stefanha-x1.localdomain>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
	<CALDPj7uvquu=YWX_Ve7ROdj=LZWjkgPOm+wvEAynGvjeF4Xivg@mail.gmail.com>
	<20200729144027.GF52286@stefanha-x1.localdomain>
	<ad75a25c-0343-5c57-1933-e3c88f76df1c@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <ad75a25c-0343-5c57-1933-e3c88f76df1c@redhat.com>
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


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 06:21:34PM -0400, Daniel Walsh wrote:
> On 7/29/20 10:40, Stefan Hajnoczi wrote:
> > On Wed, Jul 29, 2020 at 09:59:01AM +0200, Roman Mohr wrote:
> >> On Tue, Jul 28, 2020 at 3:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >>
> >>> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> >>>> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> >>>> misono.tomohiro@fujitsu.com> wrote:
> >>>>
> >>>>>> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and pri=
nt
> >>> an
> >>>>> error
> >> Yes they can run as root. I can tell you what we plan to do with the
> >> containerized virtiofsd: We run it as part of the user-owned pod (a se=
t of
> >> containers).
> >> One of our main goals at the moment is to run VMs in a user-owned pod
> >> without additional privileges.
> >> So that in case the user (VM-creator/owner) enters the pod or something
> >> breaks out of the VM they are just in the unprivileged container sandb=
ox.
> >> As part of that we try to get also rid of running containers in the
> >> user-context with the root user.
> >>
> >> One possible scenario which I could think of as being desirable from a
> >> kubevirt perspective:
> >> We would run the VM in one container and have an unprivileged
> >> virtiofsd container in parallel.
> >> This container already has its own mount namespace and it is not that
> >> critical if something manages to enter this sandbox.
> >>
> >> But we are not as far yet as getting completely rid of root right now =
in
> >> kubevirt, so if as a temporary step it needs root, the current proposed
> >> changes would still be very useful for us.
> > What is the issue with root in user namespaces?
> >
> > I remember a few years ago it was seen as a major security issue but
> > don't remember if container runtimes were already using user namespaces
> > back then.
> >
> > I guess the goal might be simply to minimize Linux capabilities as much
> > as possible?
> >
> > virtiofsd could nominally run with an arbitrary uid/gid but it still
> > needs the Linux capabilities that allow it to change uid/gid and
> > override file system permission checks just like the root user. Not sure
> > if there is any advantage to running with uid 1000 when you still have
> > these Linux capabilities.
> >
> > Stefan
>=20
> When you run in a user namespace, virtiofsd would only have
> setuid/setgid over the range of UIDs mapped into the user namespace.=A0 So
> if UID=3D0 on the host is not mapped, then the container can not create
> real UID=3D0 files on disk.
>=20
> Similarly you can protect the user directories and any content by
> running the containers in a really high UID Mapping.

Roman, do user namespaces address your concerns about uid 0 in
containers?

Stefan

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8j1b4ACgkQnKSrs4Gr
c8j0gQf/XOWE89ORV2Kmnot5KdoBuTN+VNcLxQllhA0bwIJbCrX7wXJhfpVkgzvU
Lsg+tp8lRMjE0EWSAelF7UbNqEF97JXQgSA1BT3Aqf0w+FR9he09sjL6m3VMc6xt
OgFc0yx3UxAbuQpryCXBYI7gMmliO/eRmiOCx69CPnaWsbjhbldHpwSg2oyWne3k
uJ3biwV73x0ig66XkBWHQ9qwR9iYTZAvx/OK+DBFvtaQXUpZjfyjqbInKi3yTF0Z
Arg+nJ25yHctaPMjjXYoR19AiUeZREKIODuw9agM8qCJgfnkBln9XmYUgDupTVV7
vPXTOYF3kwmz5aPfc+2O1f0el/VRTw==
=0WtM
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--

