Date: Tue, 23 Mar 2021 14:25:29 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFn6WX/S1VRzkmel@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<1711593.yAA9ihpmTb@silver>
	<YFh3gIMbEEEYDdS/@stefanha-x1.localdomain>
	<2732080.qQGZu95Wvu@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="32voxJ6tmJj5Rjdk"
Content-Disposition: inline
In-Reply-To: <2732080.qQGZu95Wvu@silver>
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
 Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@gmail.com>


--32voxJ6tmJj5Rjdk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 01:54:46PM +0100, Christian Schoenebeck wrote:
> On Montag, 22. M=E4rz 2021 11:54:56 CET Stefan Hajnoczi wrote:
> > > > Thanks, Christian. I am still trying to figure out the details of t=
he
> > > > ROP
> > > > attacks.
> > > >=20
> > > > However, QEMU's vhost-user reconnection is based on chardev socket
> > > > reconnection. The socket reconnection can be enabled by the "--char=
dev
> > > > socket,...,reconnect=3DN" in QEMU command options, in which N means=
 QEMU
> > > > will
> > > > try to connect the disconnected socket every N seconds. We can incr=
ease
> > > > N
> > > > to increase the reconnect delay. If we want to change the reconnect
> > > > delay
> > > > dynamically, I think we should change the chardev socket reconnecti=
on
> > > > code.
> > > > It is a more generic mechanism than vhost-user-fs and vhost-user
> > > > backend.
> > > >=20
> > > > By the way, I also considered the socket reconnection delay time in=
 the
> > > > performance aspect. As the reconnection delay increase, if an
> > > > application
> > > > in the guest is doing I/Os, it will suffer larger tail latency. And=
 for
> > > > now, the smallest delay is 1 second, which is rather large for
> > > > high-performance virtual I/O devices today. I think maybe a more
> > > > performant
> > > > and safer reconnect delay adjustment mechanism should be considered=
 in
> > > > the
> > > > future. What are your thoughts?
> > >=20
> > > So with N=3D1 an attacker could e.g. bypass a 16-bit PAC by brute-for=
ce in
> > > ~18 hours (e.g. on Arm if PAC + MTE was enabled). With 24-bit PAC (no
> > > MTE) it would be ~194 days. Independent of what architecture and defe=
nd
> > > mechanism is used, there is always the possibility though that some k=
ind
> > > of side channel attack exists that might require a much lower amount =
of
> > > attempts. So in an untrusted environment I would personally limit the
> > > amount of automatic reconnects and rather accept a down time for furt=
her
> > > investigation if a suspicious high amount of crashes happened.
> > >=20
> > > And yes, if a dynamic delay scheme was deployed in future then starti=
ng
> > > with a value smaller than 1 second would make sense.
> >=20
> > If we're talking about repeatedly crashing the process to find out its
> > memory map, shouldn't each process have a different randomized memory
> > layout?
> >=20
> > Stefan
>=20
> Yes, ASLR is enabled on Linux and other OSes by default for more than 10=
=20
> years. But ASLR does not prevent ROP attacks which are commonly using rel=
ative=20
> offsets, tweaking the stack, indirect jumps, as well as heap spraying. Pl=
us=20
> side channels exist to gain access to direct addresses.
>=20
> The situation might improve significantly when shadow stacks (e.g. Intel =
CET)=20
> become widely used in future. But in the meantime I would be cautious if=
=20
> something is crashing too often in a certain time frame.

It's a good point for performance as well. A broken service should not
hog CPU by constantly restarting itself. If it's broken badly it may
never come back up and should be throttled.

Stefan

--32voxJ6tmJj5Rjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBZ+lkACgkQnKSrs4Gr
c8j4+wf/Z3D1NpNwfPwBAmvVIgM2UCcpv04AAVbQwAK2uLVWvesoQ8rDnLizkeWw
TOJ8NbwQAlKFfMhLBMSYKlzFmUNJnbn7pofPpccywhQFeu8jTkNBYDpikICi0Qug
sD5Ovk0TUCqzwb+K2uxdnaDB+ZMiZLYDGwQ4T14pAinO1RndTjtTNp1OYT56hQGk
KsiNZF9fEvkNGZ4zWCo4YDK4gNUE0fjdPNvukhtPJF2dF5Jh0NVGpZPtNAz+8QPT
d2StGsqyF71gYZpCCVFNEpjiRApwnDxSqVfZSPkRBk+O9Whk0VIGQxztQ+Rl4n25
aJgFSdUW8UdkFsL5z1HtviV81lbKoQ==
=YMcq
-----END PGP SIGNATURE-----

--32voxJ6tmJj5Rjdk--

