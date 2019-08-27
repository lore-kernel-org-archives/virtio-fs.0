Date: Tue, 27 Aug 2019 15:45:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190827144540.GA24374@stefanha-x1.localdomain>
References: <20190821085659.8448-1-eguan@linux.alibaba.com>
	<20190821150429.GH3309@work-vm>
	<3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
	<20190822141603.GA4553@stefanha-x1.localdomain>
	<CAMxuvaw2Mh97QQJojQ2uGTZP9hxHG8ya7x=RCsvc=iYGzFH+SA@mail.gmail.com>
	<20190822153503.GX3267@redhat.com>
	<20190823105143.GH12092@stefanha-x1.localdomain>
	<20190826091825.GU52397@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20190826091825.GU52397@e18g06458.et15sqa>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add support to change log level
 on fly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, virtio-fs@redhat.com, Daniel Berrange <berrange@redhat.com>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2019 at 05:18:25PM +0800, Eryu Guan wrote:
> On Fri, Aug 23, 2019 at 11:51:43AM +0100, Stefan Hajnoczi wrote:
> > On Thu, Aug 22, 2019 at 04:35:03PM +0100, Daniel P. Berrang=E9 wrote:
> > > On Thu, Aug 22, 2019 at 06:33:05PM +0400, Marc-Andr=E9 Lureau wrote:
> > > > Hi
> > > >=20
> > > > On Thu, Aug 22, 2019 at 6:16 PM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
> > > > >
> > > > > On Thu, Aug 22, 2019 at 01:07:18PM +0800, piaojun wrote:
> > > > > > On 2019/8/21 23:04, Dr. David Alan Gilbert wrote:
> > > > > > > * Eryu Guan (eguan@linux.alibaba.com) wrote:
> > > > > > >> Introduce a file which contains the target log level, and
> > > > > > >> current_log_level will be reloaded to the target log level o=
n SIGHUP.
> > > > > > >>
> > > > > > >> The file is set to "/run/virtiofsd/log_level.<pid>". Due to
> > > > > > >> sandboxing in virtiofsd, this file can only be read/write via
> > > > > > >> /proc/<pid>/fd/<fd> for now.
> > > > > > >>
> > > > > > >> Example usage:
> > > > > > >>
> > > > > > >>   # view current log level
> > > > > > >>   cat /proc/<pid>/fd/<fd>
> > > > > > >>   # change log level to debug
> > > > > > >>   echo debug > /proc/<pid>/fd/<fd>
> > > > > > >>   kill -HUP <pid>
> > > > > > >>
> > > > > > >> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > > > > > >
> > > > > > > This looks really complex for something that can only be used=
 for
> > > > > > > changing log levels.
> > > > > >
> > > > > > I have the same opinion with Dave, and I wonder if we have some=
 easier
> > > > > > channel to tell virtiofsd to change log level. And making the c=
hannel
> > > > > > more generic is good for the expansibility of virtiofsd.
> > > > >
> > > > > Adding Dan and Marc-Andr=E9, who have dealt with DBus and QMP.  T=
hey can
> > > > > share their experience.
> > > > >
> > > > > The long-term concern we should think about is whether vhost-user
> > > > > backends should have standardized management commands.  They woul=
d be
> > > > > defined in docs/interop/vhost-user.rst and all backends implement=
ing a
> > > > > device type would implement a subset of them (plus additional
> > > > > "vendor-specific commands" if they really don't fit into the vhos=
t-user
> > > > > specification).
> > > > >
> > > > > In order to have standard commands we need to choose a standard R=
PC
> > > > > mechanism.  I'm pretty sure that DBus is a good choice based on my
> > > > > previous discussions with Dan and Marc-Andr=E9.  It is easy to us=
e from
> > > > > most programming languages and therefore easier to integrate than=
 a
> > > > > custom management channel.
> > > > >
> > > > > Dan and Marc-Andr=E9: The first commands we would like to offer in
> > > > > virtiofsd are:
> > > > >
> > > > >   get-log-level -> NUM
> > > > >   Return the current logging threshold level.
> > > > >
> > > > >   set-log-level NUM
> > > > >   Set the logging threshold level.
> > > > >
> > > > > If you have time to give a quick overview of how this looks in DB=
us that
> > > > > would be very helpful.  The virtiofsd code is written in C and cu=
rrently
> > > >=20
> > > > Well that depends how generic we want the interface to be :)
> > > >=20
> > > > https://dbus.freedesktop.org/doc/dbus-api-design.html
> > > >=20
> > > > service-name: none, or org.qemu.VhostUser1 or even org.qemu.VirtioF=
s1 ?
> > > > iface: org.qemu.VhostUser1, org.qemu.VirtioFs1 ?
> > > > path: /org/qemu/VhostUser1
> > > > property: "LogLevel", readwrite, string. If you follow systemd/sysl=
ogd:
> > > > "this accepts a numerical log level or the well-known syslog(3)
> > > > symbolic names (lowercase): emerg, alert, crit, err, warning, notic=
e,
> > > > info, debug."
> > > >=20
> > > > Systemd also has "LogTarget" and a bunch of other options/properties
> > > > that are settable from command line and at runtime with dbus (see m=
an
> > > > page).
> > > >=20
> > > >=20
> > > > > does not use glib/gobject/gio heavily, so I think we'd prefer a
> > > > > lightweight approach without a lot of gobject boilerplate, if pos=
sible.
> > > >=20
> > > > If you can afford GIO, I would highly recommend it. Even if you have
> > > > to run it in a seperate thread, that may be easier to maintain.
> > > >=20
> > > > Otherwise, sdbus or libdbus.
> > >=20
> > > sdbus is fairly nice if you absolutely must avoid GIO, but per my
> > > other msg I'd strongly recommend just using GIO for C apps.
> > >=20
> > > I would strongly recommend staying well away from libdbus. It is
> > > a very low level API and has some very unfortunate design choices
> > > which especially impact threaded usage. Most widely used DBus impls
> > > have dropped / avoided libdbus these  days and just impl the wire
> > > protocol themselves.
> >=20
> > Thanks for the information.
> >=20
> > I have just seen the dbus-vmstate patch on qemu-devel and I guess
> > vhost-user will eventually use that for live migration state.  So we'll
> > have DBus code in virtiofsd anyway.
> >=20
> > I think this makes the choice to use DBus an easy one.
> >=20
> > Eryu Guan: Sorry that your patch series was side-tracked by a discussion
> > about adding a management interface to virtiofsd.  But I think we should
>=20
> Glad to see the community reaches an agreement on this :)
>=20
> > start with DBus (based on what Daniel and Marc-Andr=E9 have suggested) =
so
> > that it's easy to add more management commands in the future.  Do you
> > want to try this out?  Otherwise I can try to rework your patch using
> > DBus so we can see what it would look like.
>=20
> I have zero experience on DBus, and I'm afraid I don't have much time
> looking into the docs and adding the DBus infrastructure to virtiofsd.
>=20
> If you could help that will be great! Thanks!

Okay, I'll give it a try and CC you on the patch so we can discuss
whether it's a good way forward for virtiofsd.

Stefan

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1lQhQACgkQnKSrs4Gr
c8hScAgArHTszvQ0BLTCnpBScL/7ulMB5ZpL0Yc8yOiLYZsm/YoCbPuqS+YUBgsP
RwX1cv7393ODDfrzQkWfkNHe8n7nUUo7sl4KjETwnrXm9hzDlY0FUC/TCteRNkg1
0n6TFSFvSi3g5PHfZWm6vjMcb+dNqphGmm8A5I0tO8auQDRTXyqqS2h8iktlYdE8
WBcTEWNijQSqSvvSMiAGkKmSiVWXPwfAJepbFiKLk+NTXVQHH1NIu4V2KUnOO8zM
TMUMW8AoTBCWHyOHb4wynFtLaSACdBbrEuto9Wob/Vt9M5Wxt0CrylQjO6hcxxeU
q0wsk4ffg/T1unRS1Qi4wMQA28R+ZQ==
=Hhf6
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

