Date: Wed, 15 Jan 2020 12:01:18 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200115120118.GC163546@stefanha-x1.localdomain>
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2020 at 08:24:51PM +0100, Miklos Szeredi wrote:
> On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:
> > What worries me most is how to pass that object around to all FUSE
> > functions, and that they all need a new interface.
>=20
> You mean libfuse API?
>=20
> > I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep an
> > internal vector of currently active handles and then when variable-size
> > handles are enabled, fuse_ino_t would just act as an index into that ve=
ctor?
> >
> > I suppose we could then use the full-size handles in all messages and
> > just hand out temporary indices to existing functions (just so we don=
=E2=80=99t
> > have to change their interface).  Server and client have their own
> > vectors, because when they communicate, only the full handles have mean=
ing.
> >
> > Or we could implement the table on top of the current system by sharing
> > it between the client and server.  Whenever the server creates a
> > fuse_ino_t value, it then also creates a full-size handle, and returns
> > both the handle and its corresponding fuse_ino_t value to the server.
> > The server can use the fuse_ino_t normally most of the time, but with a
> > catch: The client would be able to invalidate it.  Then the server needs
> > to obtain a new fuse_ino_t value for the existing handle.
> > (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
> > operations.)
>=20
> I think you may have accidentally switched "server" and "client" in
> the above description a couple of times.
>=20
> But if I'm reading this correctly, your idea is to keep the 64bit
> value on the interface (this could be just libfuse or both libfuse and
> the kernel API) and add new interfaces to establish and reestablish
> the mapping from (non-persistent) fuse_ino_t to (persistent) handle.

I'm not sure I understand Max's idea.

Miklos, I think you're saying keep fuse_ino_t semantics unchanged (not
persistent, can be reused after the last reference is dropped) and add a
separate struct export_operations-style FUSE API to map fuse_ino_t <->
struct file_handle.

We'd need to use submounts to avoid st_ino collisions in that case.

I like this approach because it requires no persistent state or extra
in-memory data structures (if struct file_handle is cryptographically
signed).

My biggest concern is that submounts may be complex to implement or
introduce problems (e.g. users see the submounts and get EBUSY when
unmounting the original directory).

Stefan

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4e/w4ACgkQnKSrs4Gr
c8ihPwgAoFqSJsKz7xQ9F1z7WA5QTM6DL88R/5nNwmOEmyud6bR6Fl3nYW4iTxk1
EIe7zO1Slj4OiI/X7rDRkZq2nbs5V7pea/bmbDTyPpStddygV3D/sOVf3QKDRGvA
QfRcNZ18b0/XZIo/4oo4RgebhHij23B7KwIbokajDAD7woR/odrUc8UycVz2xEPu
9+jxcImH/lo/WRaN3QR1y/vgcSf0EkJswGe68jqigIdeKZRIBYMzHKiMOldHqVEa
64uQVL8zDzoNN9dNYf63YoK8Vn7CWYlcyKT171+0Y8ZKADLPLXToumW6tYdNnVSe
GfgYp+kyOfw/PJkL4E8IYO6RyHYjXw==
=gF5y
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--

