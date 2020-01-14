References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
Date: Tue, 14 Jan 2020 17:49:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="hyu53ifdt5BVJX14ZdWTfRcb4IDh2bMVO"
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

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hyu53ifdt5BVJX14ZdWTfRcb4IDh2bMVO
Content-Type: multipart/mixed; boundary="eQvjV6f0L8NbGIwkHKsb5p6o198Lhje6D"

--eQvjV6f0L8NbGIwkHKsb5p6o198Lhje6D
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 14.01.20 17:13, Miklos Szeredi wrote:
> On Mon, Jan 13, 2020 at 6:47 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> Hi,
>>
>> As discussed in today=E2=80=99s meeting, there is a problem with uniqu=
ely and
>> persistently identifying nodes in the guest.
>>
>> Actually, there are multiple problems:
>>
>> (1) stat=E2=80=99s st_ino in the guest is not necessarily unique.  Cur=
rently, it
>> just the st_ino from the host file, so if you have mounted multiple
>> different filesystems in the exported directory tree, you may get
>> collisions.
>>
>> (2) The FUSE 64-bit fuse_ino_t (which identifies an open file,
>> basically) is not persistent.  It is just an index into a vector that
>> contains all open inodes, and whenever virtiofsd is restarted, the
>> vector is renewed.  That means that whenever this happens, all
>> fuse_ino_t values the guest holds will become invalid.  (And when
>> virtiofsd starts handing out new fuse_ino_t values, those will probabl=
y
>> not point to the same inodes as before.)
>>
>> (3) name_to_handle_at()/open_by_handle_at() are implemented by FUSE ju=
st
>> by handing out the fuse_ino_t value as the handle.  This is not only a=

>> problem as long as fuse_ino_t is not persistent (see (2)), but also in=

>> general, because the fuse_ino_t value is only valid (per FUSE protocol=
)
>> as long as the inode is referenced by the guest.
>>
>> The first question that I think needs to be asked is whether we care
>> about each of this points at all.
>>
>> (1) Maybe it just doesn=E2=80=99t matter whether the st_ino values are=
 unique.
>=20
> It does matter, otherwise we can't claim it's a POSIX filesystem, and
> applications can't rely on the guarantees made by the standard.
> st_ino is used to find hard links by backup utilities and st_ino +
> d_ino values are used by tree traversal (such as find(1)).
>=20
>>
>> (2) Maybe we don=E2=80=99t care about virtiofsd being restarted while =
the guest
>> is running or only paused.  (=E2=80=9CRestarting=E2=80=9D includes mig=
ration of the
>> daemon to a different host.)
>>
>> (3) I suppose we do care about this.
>>
>>
>> Assuming we do care about the points, here are some ways I have
>> considered of addressing them:
>>
>> (1)
>>
>> (a)
>>
>> If we could make the 64-bit fuse_ino_t unique and persistent (see (2))=
,
>> we could use that for st_ino (also a 64-bit field).
>=20
> My gut feeling is that we'd want to avoid boundless maps stored in
> memory or any kind of storage.

Well, if we don=E2=80=99t need persistent fuse_ino_t values (i.e., we don=
=E2=80=99t care
about (2)), then we could just use what passthrough_ll currently does.
It does sound a bit like you don=E2=80=99t like even the current mapping,=

though. (?)

> In fact we want to do the opposite: avoid having to keep map of
> objects currently in guest cache.  We want to flush the server maps
> independently of the guest cache when the maps grow too large or there
> are too many open file descriptors (a big issue with running virtiofsd
> unprivileged)...
>=20
>>
>> (b)
>>
>> Otherwise, we probably want to continue passing through st_ino and the=
n
>> ensure that stat=E2=80=99s st_dev is unique for each submount in the e=
xported
>> tree.  We can achieve that by extending the FUSE protocol for virtiofs=
d
>> to announce submounts and then the FUSE kernel driver to automount the=
m.
>>  (This means that these submounts in the guest are then technically
>> unrelated filesystems.  It also means that the FUSE driver would need =
to
>> automount them with the =E2=80=9Cvirtiofs=E2=80=9D fs type, which is k=
ind of weird, and
>> restricts this solution to virtiofs.)
>>
>>
>> (2)
>>
>> (a)
>>
>> We can keep the current way if we just store the in-memory mapping whi=
le
>> virtiofsd is suspended (and migrate it it if we want to migrate the
>> virtiofsd instance).  The table may grow to be very large, though, and=

>> it contains for example file descriptors that we would need to migrate=
,
>> too (perhaps as file handles?).
>>
>> (b)
>>
>> We could extend the fuse_ino_t type to an arbitrary size basically, to=

>> be negotiated between FUSE server and client.  This would require
>> extensive modification of the FUSE protocol and kernel driver (and wou=
ld
>> ask for respective modification of libfuse, too), though.  Such a larg=
er
>> value could then capture both a submount ID and a unique identifier fo=
r
>> inodes on the respective host filesystems, such as st_ino.  This would=

>> ensure that every virtiofsd instance would generate the same fuse_ino_=
t
>> values for the same nodes on the same exported tree.
>>
>> However, note that this doesn=E2=80=99t auto-populate the fuse_ino_t m=
appings:
>> When after restarting virtiofsd the server wants to access an existing=

>> inode, it can=E2=80=99t, because there is no good way to translate eve=
n larger
>> fuse_ino_t values to a file descriptor.  (We could do that if the
>> fuse_ino_t value encapsulated a handle.  (As in open_by_handle_at().)
>=20
> ...and this is the proposal that would solve that one as well.  If we
> could encapsulate the file handle into all messages, than we wouldn't
> have to worry about refcounting objects and keeping files open.  The
> server could just flush it's caches independently of the guest.
>=20
>> The problem is that we can=E2=80=99t trust the guest to keep a handle,=
 so we
>> must ensure that the handle returned points to a file the guest is
>> allowed to access.  Doing that cryptographically (e.g. with a MAC) is
>> probably out of the question, because that would make fuse_ino_t reall=
y
>> big.
>=20
> I'm not a crypto expert, but why would that need to be big?  AES has
> 16 byte block size, so the handle would need to be padded to be a
> multiple of 16 bytes, but that doesn't sound excessive at all.

A MAC is an encrypted hash, so it needs to be as long as the hash is.
That is, 32 bytes for SHA-256 or 64 for SHA-512.  I naively expected
that increasing the file handle size from 8 to 32 + handle (which is
probably 12 to 16 bytes in length, so ~48 B) or even 64 + handle (~80 B)
would not be so nice.

> What worries me more is the variable nature of the field size, but I
> suppose there's no good way to get around that.

What worries me most is how to pass that object around to all FUSE
functions, and that they all need a new interface.

I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep an
internal vector of currently active handles and then when variable-size
handles are enabled, fuse_ino_t would just act as an index into that vect=
or?

I suppose we could then use the full-size handles in all messages and
just hand out temporary indices to existing functions (just so we don=E2=80=
=99t
have to change their interface).  Server and client have their own
vectors, because when they communicate, only the full handles have meanin=
g.

Or we could implement the table on top of the current system by sharing
it between the client and server.  Whenever the server creates a
fuse_ino_t value, it then also creates a full-size handle, and returns
both the handle and its corresponding fuse_ino_t value to the server.
The server can use the fuse_ino_t normally most of the time, but with a
catch: The client would be able to invalidate it.  Then the server needs
to obtain a new fuse_ino_t value for the existing handle.
(Invalidating and reacquiring a fuse_ino_t value would be new FUSE
operations.)

I just got this idea, so maybe it=E2=80=99s silly.  But I suppose it coul=
d solve
our problems without being too invasive?

[...]

>> Side note:
>>
>> As for migrating a virtiofsd instance: Note that everything above that=

>> depends on host file handles or host ino_t values will make it
>> impossible to migrate to a different filesystem.  But maybe doing that=

>> would lead to all kind of other problems anyway.
>=20
> If filesystem exported to guests is backed by a common server (e.g.
> NFS) than that should solve the ino_t and file handle persistency
> across migration.

Yes, but that wouldn=E2=80=99t be a different filesystem then.

Thanks a lot for taking the time to read and respond!

Max


--eQvjV6f0L8NbGIwkHKsb5p6o198Lhje6D--

--hyu53ifdt5BVJX14ZdWTfRcb4IDh2bMVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4d8QMACgkQ9AfbAGHV
z0ApcggAo1sc5W1poMlWlkc9bBrrfX0UNXNHdZhhZw/CxafjyWp9DUH4n4AW1v10
QAuMFCb5XI7Ixu7S+quPbknQrfPJreMmgnw/0e5is4aT2MT4apsfBQi1MUhnE115
hl70hb7Dc7vcW7sVb43J+UWODvZsAJW65rGYeQq4WAzXwRSzir05f9mEPpTDKRx4
RsrZbsQY8BIQag4mYROD9LgodziOBpq0ECc1FCYuCDrNGzkkRjtdzYiDnK2CRsiS
4Bm5WgqySJfWCAeY0XrNVCVTrCDQbXX5EI5dQ9ryEglUHziLqiHcxcsx+YlOVxzh
jIPD5TKTGlZC7UmuVnJpPPhrUkVwVQ==
=pHHX
-----END PGP SIGNATURE-----

--hyu53ifdt5BVJX14ZdWTfRcb4IDh2bMVO--

