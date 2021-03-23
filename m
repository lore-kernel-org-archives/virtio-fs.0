Date: Tue, 23 Mar 2021 13:45:06 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFnw4kRo21yXlbxK@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
	<CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
	<YFHUbEdszo4nursr@stefanha-x1.localdomain>
	<CAFQAk7ia5HsX0e4WBrhDtytGKnd5LsPrUSz9DJVFoo+ShDRP7Q@mail.gmail.com>
	<YFh45AUkh1OzbE6H@stefanha-x1.localdomain>
	<20210322201326.GH446288@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wuS6R2OceLl3Kyfx"
Content-Disposition: inline
In-Reply-To: <20210322201326.GH446288@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: vrothber@redhat.com, "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@gmail.com>


--wuS6R2OceLl3Kyfx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2021 at 04:13:26PM -0400, Vivek Goyal wrote:
> On Mon, Mar 22, 2021 at 11:00:52AM +0000, Stefan Hajnoczi wrote:
> > On Wed, Mar 17, 2021 at 08:32:31PM +0800, Jiachen Zhang wrote:
> > > On Wed, Mar 17, 2021 at 6:05 PM Stefan Hajnoczi <stefanha@redhat.com>=
 wrote:
> > > > On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > > I agreed with you that a virtiofsd must be launched by a software like
> > > systemd. So we are planning to define more generic persist/restore
> > > interfaces (callbacks). Then anyone can implement their own persist/r=
estore
> > > callbacks to store states to proper places.  And I think in the next
> > > version we will implement default callbacks for the interfaces. Inste=
ad of
> > > vhost-user messages, systemd's sd_notify(3) will be the default metho=
d for
> > > storing fds, and several tmpfs files can be the default place to stor=
e the
> > > shm regions.
> >=20
> > Okay, great!
> >=20
> > I was thinking about how to make the crash recovery mechanism reusable
> > as a C library or Rust crate. The mechanism is a combination of:
> > 1. sd_listen_fds(3) for restoring the fds on restart.
> > 2. sd_notify(3) for storing the fds.
> > 3. memfd or tmpfs for storing state (could be mmapped).
> >=20
> > I'm not sure if there is enough common behavior to create a reusable API
> > or if this is quite application-specific.
>=20
> I am wondering what will happen for use cases where virtiofsd is running
> inside a container (with no systemd inside containers).
>=20
> Do container managers offer systemd like services to save and restore
> state.

It appears so, at least for Podman where sd_notify is explicitly
mentioned:
https://www.redhat.com/sysadmin/improved-systemd-podman

As mentioned in this email thread, the socket activation and
sd_notify(3) interface can also be implemented by non-systemd software.
Anyone running a custom container runtime or orchestration software
could add these interfaces (they are reasonably simple and the protocols
are documented in the systemd documentation).

Stefan

--wuS6R2OceLl3Kyfx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBZ8OIACgkQnKSrs4Gr
c8gkLwf/Y8kynUlQ/LDECaTWekzges0TxYpXfBhQCZ7AjQ1nu2yxTGiw9jUbdRid
jTndmCQHhTfRPTiYR7SAcfiiIb+gDd+e4DrMQma0xQKNiFz9zRoyDId6ZzWIUpcy
JyWsnBUfHxGqTYdycequqd34OPl1gnwOnTMdc6hunoo96t7sW2Km8z0I8QW4kyAT
lr4/1xbrh1fcbr7C/uTxT22NllHbN0N8hnwKx+iiY4Fj5jjTVQFQoERjHCsPxWQg
GHxsUMBlhB1YUUgtWT5T0pW8+S4l93lqLoAi5l2wFyx5m0Pyf1bzSu9jop7XSmwT
aiU/xcl4Z96WAECDLfq0Vbrsb7DMEQ==
=cPN0
-----END PGP SIGNATURE-----

--wuS6R2OceLl3Kyfx--

