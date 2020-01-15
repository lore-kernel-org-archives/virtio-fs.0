References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<20200115101222.GB3811@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <2f099bc9-d2ef-0f1c-8fe0-dd2e64f061ca@redhat.com>
Date: Wed, 15 Jan 2020 13:58:06 +0100
MIME-Version: 1.0
In-Reply-To: <20200115101222.GB3811@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ZZJoSYXRNdPDjzdvSmv7x9F8icbt0fWOm"
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZZJoSYXRNdPDjzdvSmv7x9F8icbt0fWOm
Content-Type: multipart/mixed; boundary="kyry08DxnWU5r1DgkppAxFCFYfxUgya27"

--kyry08DxnWU5r1DgkppAxFCFYfxUgya27
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 11:12, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
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
>>
>> The first question that I think needs to be asked is whether we care
>> about each of this points at all.
>>
>> (1) Maybe it just doesn=E2=80=99t matter whether the st_ino values are=
 unique.
>>
>> (2) Maybe we don=E2=80=99t care about virtiofsd being restarted while =
the guest
>> is running or only paused.  (=E2=80=9CRestarting=E2=80=9D includes mig=
ration of the
>> daemon to a different host.)
>=20
> I prefer to split that answer because I care about migration but not
> about restarting the daemon in place.
>=20
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
>>
>> (This is the case if we keep the current schema for fuse_ino_t, be it
>> because we don=E2=80=99t care about (2) or because we want (2a).)
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
>=20
> This feels nice to me, since the st_dev map should be small.
>=20
>>  (This means that these submounts in the guest are then technically
>> unrelated filesystems.  It also means that the FUSE driver would need =
to
>> automount them with the =E2=80=9Cvirtiofs=E2=80=9D fs type, which is k=
ind of weird, and
>> restricts this solution to virtiofs.)
>=20
> Well it has to automount them witht he same type as it's mounted with;
> so it's not virtiofs specific.

Right.  But we need some way to tell the filesystem the context for the
submount.  I=E2=80=99m not sure whether that=E2=80=99s possible in an fs-=
agnostic way,
because the only information we can reasonably pass goes to
vfs_submount()=E2=80=99s @name parameter.  I think?  Or maybe we can make=
 @data
point to a FUSE-common structure that every FUSE fs with submounts would
then need to be able to parse?  But I=E2=80=99m not sure how that would e=
ven
translate to userspace.

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
>=20
> The 'when suspended' worries me - if it's important data to persist the=
n
> we probably need to be more careful with it; i.e. keep it sync'd to
> disk.  If it's not important long term then do we need to keep it that
> long?=20
> Be wary of migating a large, rapidly changing table.
>=20
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
>> The problem is that we can=E2=80=99t trust the guest to keep a handle,=
 so we
>> must ensure that the handle returned points to a file the guest is
>> allowed to access.  Doing that cryptographically (e.g. with a MAC) is
>> probably out of the question, because that would make fuse_ino_t reall=
y
>> big.  Another idea would be to set a flag on the host FS for files tha=
t
>> the guest has a handle to.  But this flag would need to be
>> guest-specific...  So we=E2=80=99d probably again end up with a large =
database
>> just as in (2a).  (It doesn=E2=80=99t need to be a flag on the FS, it =
could also
>> be a database, I suppose.))
>=20
> I'm no crypto person, but I don't know how to show that's safe.
> Some inode numbers are well-known (e.g. on xfs / always seems to be 128=

> for me).  I'm just worrying that makes it easier for the guest to figur=
e
> out the crypto.

Well, with MACs the adversary sees the data and the MAC together anyway,
so they=E2=80=99re designed in such a way that you can=E2=80=99t infer th=
e key from that
information.

And of course they=E2=80=99re designed such that without a key, you can=E2=
=80=99t
generate a valid MAC for given data.

IOW, that=E2=80=99s the precise reason we=E2=80=99d use a MAC: So the gue=
st can=E2=80=99t just
return a well-known handle to get access to files it shouldn=E2=80=99t be=
 able
to access.

>> We could also re-enumerate the exported tree after reopening (perhaps
>> lazily for each exported filesystem) and thus recreate the mapping.  B=
ut
>> this would take as much time as a =E2=80=9Cfind=E2=80=9D over the whol=
e exported tree.
>>
>> (c)
>>
>> We could complement the fuse_ino_t value by a context ID, that in our
>> case would probably be derived from the submount ID (e.g. the relative=

>> mount point).  This would only require minor modification of the FUSE
>> protocol: Detecting mount points in lookups; a new command to retrieve=
 a
>> mount point=E2=80=99s context ID; and some way to set this context ID.=

>>
>> We could set the context ID either explicitly with a new command; or a=
s
>> part of every FUSE request (a field in the request header); or just as=

>> part of virtio-fs (be it with one virtqueue per context (which may or
>> may not be feasible), or just by prefixing every FUSE request on the
>> line with a context ID).
>=20
> One-virtqueue per context doesn't seem feasible to me; we don't know
> how many submounts there will be and there could be lots of them.

OK, good, so I don=E2=80=99t have to worry about it. :-)

Max


--kyry08DxnWU5r1DgkppAxFCFYfxUgya27--

--ZZJoSYXRNdPDjzdvSmv7x9F8icbt0fWOm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4fDF4ACgkQ9AfbAGHV
z0AGxAgAm9VqDiLj+2zlHbNk5hfhc25bdNYidJU0h+79ML0Oyl3+iy5dEEy5srJx
o7hzJmpyy+V+9ctUbjy7Hl6Z6XMmOmROOKStPz8Obcm2hAcBY9m0/tadgOlczAR/
OWARTMXG0vDxxavB2MmDQVHmVJIqO46D9ba95lTeHTvzXmdzztPFbyZpfoScYJi4
y9Tf9kxQ4YxHzo3RagAKbTt/E2iICszYzVDCWA8czc+gmez3eF2CYKoWfXz0Fqse
gS2W021XWpSvvfcjNNU69HdEgTGFmjN+k13W+2vsBpDC/C8Gq4GiRuV8gPDlCdS2
geBCd3zjlZ2Q5FfoEBhMY+oLN1gMAQ==
=iVt0
-----END PGP SIGNATURE-----

--ZZJoSYXRNdPDjzdvSmv7x9F8icbt0fWOm--

