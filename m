References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<20200115125049.GD163546@stefanha-x1.localdomain>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <e39388eb-7a14-78e4-6b7e-a41af43db710@redhat.com>
Date: Wed, 15 Jan 2020 15:21:24 +0100
MIME-Version: 1.0
In-Reply-To: <20200115125049.GD163546@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="jv74wUQcf2GYJw68z0IV7dC4IZNAjWHfF"
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jv74wUQcf2GYJw68z0IV7dC4IZNAjWHfF
Content-Type: multipart/mixed; boundary="LeccrAPEheaRaIYfFgXc42vuEDHpPAsw1"

--LeccrAPEheaRaIYfFgXc42vuEDHpPAsw1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 13:50, Stefan Hajnoczi wrote:
> On Mon, Jan 13, 2020 at 06:46:49PM +0100, Max Reitz wrote:
>> (1) stat=E2=80=99s st_ino in the guest is not necessarily unique.  Cur=
rently, it
>> just the st_ino from the host file, so if you have mounted multiple
>> different filesystems in the exported directory tree, you may get
>> collisions.
>=20
> This must be fixed because POSIX file systems have unique and persisten=
t
> st_ino so that stat(2) can distinguish inodes from each other.

OK.

>> (2) The FUSE 64-bit fuse_ino_t (which identifies an open file,
>> basically) is not persistent.  It is just an index into a vector that
>> contains all open inodes, and whenever virtiofsd is restarted, the
>> vector is renewed.  That means that whenever this happens, all
>> fuse_ino_t values the guest holds will become invalid.  (And when
>> virtiofsd starts handing out new fuse_ino_t values, those will probabl=
y
>> not point to the same inodes as before.)
>=20
> fuse_ino_t only needs to be persistent when the FUSE_EXPORT_SUPPORT
> protocol feature is enabled.  It means that nodeids persist even when
> the last reference is dropped.  (If you implement an alternative
> open_by_handle_at(2) approach then it would extend the semantics.)

It currently looks like we want them even less persistent, i.e. allow
the server to make the client refresh fuse_ino_t values, right?

Also, when I say =E2=80=9Cpersistence=E2=80=9C, I mostly mean =E2=80=9Cpe=
rsistence through
multiple virtiofsd sessions=E2=80=9D.  The current state is that a new se=
ssion
doesn=E2=80=99t know what to do with the old values at all, so it=E2=80=99=
s all just broken.

(It wouldn=E2=80=99t be broken if we could tell the client that this is s=
o and
make the client refresh all its fuse_ino_t values.)

> However, it's more challenging to support power management freeze/thaw
> (not a high priority since no one seems to use it) when fuse_ino_t is
> not persistent.  The driver would have to do something during freeze
> and/or thaw to be able to restore the FUSE session state (fuse_ino_t,
> fh, etc).  If we end up not being able to implement freeze/that, I thin=
k
> that would be acceptable.

I suppose we don=E2=80=99t need fuse_ino_t specifically to be persistent;=
 it
would suffice if the client could get a persistent value (the handle)
from which to get new fuse_ino_t values when they are invalidated.

>> (3) name_to_handle_at()/open_by_handle_at() are implemented by FUSE ju=
st
>> by handing out the fuse_ino_t value as the handle.  This is not only a=

>> problem as long as fuse_ino_t is not persistent (see (2)), but also in=

>> general, because the fuse_ino_t value is only valid (per FUSE protocol=
)
>> as long as the inode is referenced by the guest.
>=20
> open_by_handle_at() will be needed sooner or later.  For example, users=

> might wish to export a virtio-fs file system via an NFS server running
> inside the guest.  We need this.

Sure.  But I think we should solve the first two points first because
however we do it will probably affect how we want to address this problem=
=2E

(For example, if we do decide to have handles always shared between
server and client and make fuse_ino_t a transient value that the server
can force-invalidate, then the *_handle_at() functions will be trivial
to implement.)

Max


--LeccrAPEheaRaIYfFgXc42vuEDHpPAsw1--

--jv74wUQcf2GYJw68z0IV7dC4IZNAjWHfF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4fH+UACgkQ9AfbAGHV
z0AdGQgArxri6NtxmqDPTk5kklOae18RJnamQbDLtGVeqw2eeLuClJY8lHk+I64a
i5u/zKNp02q5BkFEZVrs7Z8NLUb4wDnLN/d9u8WwOfStKT5b6UIB4NJX+RpEhUHM
o7tRco3SzadEC/vsLPVry/RxbdlbFm0nO6YA9A439aHzVGP6XjEm8VrgglcNpUYM
BDw4ycAuZlW3Sy34+14inS0Z79YiA0SBOioSDNvd6zjWBteYVqv6Oa/fIyLjh+JN
IeLX2F+GmwgbwjPz5jv1B3Ft0/eYxCGjWW8Lpf08ynfZyU/RxUdy9IDtCYtfDt5i
bZcpE4NNTnDr62f6utbT3+ye7X+NTw==
=L5Gb
-----END PGP SIGNATURE-----

--jv74wUQcf2GYJw68z0IV7dC4IZNAjWHfF--

