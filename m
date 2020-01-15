References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
	<CAOssrKcXKb5B=9mTaPxXwNLSZWpUAZ=3UdcDQ8wCWVbEg0A2-w@mail.gmail.com>
	<CAOssrKf8DN68+5aAseBYsnSXr+zWHy0UqNdVHMU5cSu0b-EvQw@mail.gmail.com>
	<9dfafbc1-6b64-ed12-a950-19dbf7b1eda2@redhat.com>
	<CAOssrKdXxN5iUpMocenvQZoHYinzVBYZEADersU7RHRy5Tf2tA@mail.gmail.com>
	<CAOssrKdU=+A9kkdwFiHAJRRFesER1hFT3eATQmZO3=x7Bs1ong@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <4baf208d-66fb-4759-8fac-691c853d7154@redhat.com>
Date: Wed, 15 Jan 2020 16:19:06 +0100
MIME-Version: 1.0
In-Reply-To: <CAOssrKdU=+A9kkdwFiHAJRRFesER1hFT3eATQmZO3=x7Bs1ong@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="MtrfCRNMg664dtFKlvr5Ek8bkIriNfon7"
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
--MtrfCRNMg664dtFKlvr5Ek8bkIriNfon7
Content-Type: multipart/mixed; boundary="WgAHIrZoGmv7Av5WirjaTjDIhtSuDE8ww"

--WgAHIrZoGmv7Av5WirjaTjDIhtSuDE8ww
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 16:05, Miklos Szeredi wrote:
> On Wed, Jan 15, 2020 at 3:58 PM Miklos Szeredi <mszeredi@redhat.com> wr=
ote:
>>
>> On Wed, Jan 15, 2020 at 1:51 PM Max Reitz <mreitz@redhat.com> wrote:
>>>
>>> On 15.01.20 12:51, Miklos Szeredi wrote:
>>>> On Wed, Jan 15, 2020 at 11:10 AM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>>>>
>>>>> New operations needed:
>>>>>
>>>>> LOOKUP_WITH_HANDLE: same as LOOKUP, but returns handle in addition =
to
>>>>> fuse_ino_t and attributes.
>>>>> LOOKUP_BY_HANDLE: same as LOOKUP, but gets a handle as input.
>>>>
>>>> And that can be reduced further to a single extended LOOKUP_HANDLE,
>>>> which takes a handle as input and returns a handle in addition to th=
e
>>>> usual stuff.  The lookup-by-handle case can be done with a special
>>>> name.  Currently "." is used for this purpose in the fuse protocol,
>>>> which is a bit confusing since it has nothing to do the "." director=
y
>>>> entry, but at least we don't have to introduce a new concept for thi=
s.
>>>
>>> I=E2=80=99m afraid I don=E2=80=99t quite understand.  What handle wou=
ld LOOKUP_HANDLE
>>> take as input when I want to open a new file (as in, LOOKUP_WITH_HAND=
LE)?
>>
>> For example open("/foo/bar", ...) would do:
>>
>> lookup_handle($ROOT_HANDLE, "foo") -> { FOO_HANDLE, FOO_NODEID }
>> lookup_handle($FOO_HANDLE, "bar") -> { BAR_HANDLE, BAR_NODEID }
>> open($BAR_NODEID, ...)
>=20
> Note also that this scheme makes fuse_ino_t values non-reusable,
> otherwise there could be messy conflicts with client using an old
> value that the server interprets as a new value.

But wouldn=E2=80=99t it just be against the protocol to use a dropped or
invalidated fuse_ino_t value?

> But with the 64bit fuse_ino_t space wraparound shouldn't be an issue.

I don=E2=80=99t really see the problem with the current solution of havin=
g
fuse_ino_t be an index into a vector, and old values being reused.  As
far as I understand, there is a protocol for refcount fuse_ino_t values
and the clients should not reuse values whose refcount has gone to zero.

(And we=E2=80=99d add to that protocol by adding a way for the server to =
make
the client invalidate an existing fuse_ino_t value and request a new
one.  I suppose we=E2=80=99d do that just by responding e.g. EINVAL if a
fuse_ino_t value is used that the server doesn=E2=80=99t recognize, and t=
hen the
client has to invoke lookup_(by_)handle to get a new value.)

Max


--WgAHIrZoGmv7Av5WirjaTjDIhtSuDE8ww--

--MtrfCRNMg664dtFKlvr5Ek8bkIriNfon7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4fLWoACgkQ9AfbAGHV
z0BtIwf9HcpJXeheCDFxG+t0i1fpwTFvNY6lInXGaSAUgcaWcpSDnZAI1pLtmnH/
ab6g9cs9zfjvti9NNQNwbWKU771LqkgPEtWAx0UvfO6VaIlhMMnloDLhjCo3Xef4
a/RF9CrYfMmpgSbv+hZvLWdmJT59Tj/kuF8Od4xx0ORqP3ymzHijb/soRNDCob50
9onGyvA3FrS8qnBRSYLPVhmPotLqtNQE7NAahiZy6Sc9GFrNQHf7W1xtGoQ7qwHr
4kl+5oeocqvoYNGLswzT9T4oIO7ND6QiuBCBYuzZ7MCcf+WCbiBV84rPPD85qUEc
XOCBe/60k37vBKf2dsNNdwot4xawVw==
=Ljpr
-----END PGP SIGNATURE-----

--MtrfCRNMg664dtFKlvr5Ek8bkIriNfon7--

