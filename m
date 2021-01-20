Date: Wed, 20 Jan 2021 16:21:04 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210120162104.GB5177@stefanha-x1.localdomain>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
	<20210118165541.GD255498@stefanha-x1.localdomain>
	<9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
	<CAJFHJroGX7YYPK2KzxBtM3Pnf7heUxsjZXOvoH0GR7gMrDTuuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <CAJFHJroGX7YYPK2KzxBtM3Pnf7heUxsjZXOvoH0GR7gMrDTuuQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, P J P <ppandit@redhat.com>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 02:49:52PM +0900, Chirantan Ekbote wrote:
> On Tue, Jan 19, 2021 at 11:34 PM P J P <ppandit@redhat.com> wrote:
> >
> > +-- On Mon, 18 Jan 2021, Stefan Hajnoczi wrote --+
> > | Guest applications may run with different uids/gids. The host has no =
control
> > | over that.
> > |
> > | Imagine booting a guest form a virtio-fs root file system and install=
ing
> > | packages. The guest must be able to control uids/gids for that to wor=
k.
> >
> > * I see; I'll try to better understand how it's done.
> >
> > * With UID namespaces, I thought virtiofsd(1) would be able to operate =
files
> >   with arbitrary uid/gid, even after dropping its root privileges to ac=
quire
> >   non-root privileges on the host; Because it has 'root' privileges und=
er the
> >   shared directory & UID namespace.
> >
>=20
> This is actually what we do in crosvm.  It works pretty well but has a
> few limitations:
>=20
> - Setting up the uidmap and gidmap requires CAP_SETUID and CAP_SETGID
> (unless you're only mapping in the current euid/egid) so a user
> without sudo access cannot do it.
> - The daemon cannot do anything that requires caps in the init
> namespace.  For example, it cannot set any security.* or trusted.*
> xattrs but that can be worked around by re-mapping them into the
> user.* xattr namespace.  Another example is anything to do with
> filesystem quotas.  We deal with this by forwarding them to another
> daemon running in the init namespace but it's not ideal.
>=20
> Overall I think we're pretty happy with the user namespace sandbox.  I
> think the benefit of dropping all privileges in the init namespace has
> been worth the cost of dealing with the limitations we've run into so
> far.

Cool, thanks for sharing those details!

Stefan

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAIWG8ACgkQnKSrs4Gr
c8h9rAgAoQLMDWgP6PNmVmX3f2/KVO05mXRgGnGOP1+lMjCNbMfEJCanR+1Un3Pg
2+3BikpzDSThtgrHA2rkIR4rLowkLOyQ0kMtBgfPDYT0NzHFL1yHQWi6q5tiDXSl
PsbbWRdAbHhR2WcAptaDAjfZxniGZsmsJq4k8DGHoQp32LTNvzDRPGCWa5LRO7Ti
pAHAAMITI5TVR2+nGzZh3rw+5hdM90FJplmzLSkbZgLcCS0eF1WFr1TNfyYJ94Y+
V9L65/Dnn+KKrEoh8xy8/gNGVdij6FBAkzl6qPF/nYS8txT7r/lcBl+hhkk5TEX5
yOAJ7qg1MkvyfWDJjUM93ePKqlO1Rw==
=TN0I
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--

