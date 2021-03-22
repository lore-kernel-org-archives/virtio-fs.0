Date: Mon, 22 Mar 2021 10:54:56 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFh3gIMbEEEYDdS/@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<1709993.NBFj2RoZ23@silver>
	<CAFQAk7jmvzL3tT=7ExcUKyo9SKNdhT29F5y3f4K8YigA08=BWQ@mail.gmail.com>
	<1711593.yAA9ihpmTb@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="COV0ppyWz2Yz3WLE"
Content-Disposition: inline
In-Reply-To: <1711593.yAA9ihpmTb@silver>
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


--COV0ppyWz2Yz3WLE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 12:58:46PM +0100, Christian Schoenebeck wrote:
> On Mittwoch, 17. M=E4rz 2021 13:57:47 CET Jiachen Zhang wrote:
> > On Wed, Mar 17, 2021 at 7:50 PM Christian Schoenebeck <
> >=20
> > qemu_oss@crudebyte.com> wrote:
> > > On Mittwoch, 17. M=E4rz 2021 11:05:32 CET Stefan Hajnoczi wrote:
> > > > On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > > > > Thanks for the suggestions. Actually, we choose to save all state
> > > > > information to QEMU because a virtiofsd has the same lifecycle as=
 its
> > > > > QEMU master. However, saving things to a file do avoid communicat=
ion
> > >=20
> > > with
> > >=20
> > > > > QEMU, and we no longer need to increase the complexity of vhost-u=
ser
> > > > > protocol. The suggestion to save fds to the systemd is also very
> > > > > reasonable
> > > > > if we don't consider the lifecycle issues, we will try it.
> > > >=20
> > > > Hi,
> > > > We recently discussed crash recovery in the virtio-fs bi-weekly cal=
l and
> > > > I read some of this email thread because it's a topic I'm intereste=
d in.
> > >=20
> > > I just had a quick fly over the patches so far. Shouldn't there be so=
me
> > > kind
> > > of constraint for an automatic reconnection feature after a crash to
> > > prevent
> > > this being exploited by ROP brute force attacks?
> > >=20
> > > E.g. adding some (maybe continuously increasing) delay and/or limitin=
g the
> > > amount of reconnects within a certain time frame would come to my min=
d.
> > >=20
> > > Best regards,
> > > Christian Schoenebeck
> >=20
> > Thanks, Christian. I am still trying to figure out the details of the R=
OP
> > attacks.
> >=20
> > However, QEMU's vhost-user reconnection is based on chardev socket
> > reconnection. The socket reconnection can be enabled by the "--chardev
> > socket,...,reconnect=3DN" in QEMU command options, in which N means QEM=
U will
> > try to connect the disconnected socket every N seconds. We can increase=
 N
> > to increase the reconnect delay. If we want to change the reconnect del=
ay
> > dynamically, I think we should change the chardev socket reconnection c=
ode.
> > It is a more generic mechanism than vhost-user-fs and vhost-user backen=
d.
> >=20
> > By the way, I also considered the socket reconnection delay time in the
> > performance aspect. As the reconnection delay increase, if an applicati=
on
> > in the guest is doing I/Os, it will suffer larger tail latency. And for
> > now, the smallest delay is 1 second, which is rather large for
> > high-performance virtual I/O devices today. I think maybe a more perfor=
mant
> > and safer reconnect delay adjustment mechanism should be considered in =
the
> > future. What are your thoughts?
>=20
> So with N=3D1 an attacker could e.g. bypass a 16-bit PAC by brute-force i=
n ~18=20
> hours (e.g. on Arm if PAC + MTE was enabled). With 24-bit PAC (no MTE) it=
=20
> would be ~194 days. Independent of what architecture and defend mechanism=
 is=20
> used, there is always the possibility though that some kind of side chann=
el=20
> attack exists that might require a much lower amount of attempts. So in a=
n=20
> untrusted environment I would personally limit the amount of automatic=20
> reconnects and rather accept a down time for further investigation if a=
=20
> suspicious high amount of crashes happened.
>=20
> And yes, if a dynamic delay scheme was deployed in future then starting w=
ith a=20
> value smaller than 1 second would make sense.

If we're talking about repeatedly crashing the process to find out its
memory map, shouldn't each process have a different randomized memory
layout?

Stefan

--COV0ppyWz2Yz3WLE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBYd4AACgkQnKSrs4Gr
c8gTBAgAmn7gCTEiBI4nV4D5u27OL0k9GIqn6TejdUDNAj7fRaLPHP54KeBgcXue
HZlc51CSz0z+8R+plbpdBcLvy+cSt9VV7fTnowIJ7IW5SqXPY1NNQWxmFAFse4rC
sdwxiRBJayHa4v9Nanm6cefyDrEGSREdmMjXy8pipHEZ2Xp+4pYhdI4ZBWPedgwa
/kEqweRyfm1txcC4PrTUe1bcyeVNxKKQDNYsj5ki/OwhY0mLwa6VOlmlnl7XqusD
YOi0neLdPKitHzfyKqdjNXTkh7a/Ylgw1MLsIDDBeMeF/ZDpeP3qYm5p/Ryw76qd
phCCqCTqb8khTTeK6T8ZiqvMA7TEVw==
=p+De
-----END PGP SIGNATURE-----

--COV0ppyWz2Yz3WLE--

