References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
	<CAOssrKcXKb5B=9mTaPxXwNLSZWpUAZ=3UdcDQ8wCWVbEg0A2-w@mail.gmail.com>
	<CAOssrKf8DN68+5aAseBYsnSXr+zWHy0UqNdVHMU5cSu0b-EvQw@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <9dfafbc1-6b64-ed12-a950-19dbf7b1eda2@redhat.com>
Date: Wed, 15 Jan 2020 13:51:24 +0100
MIME-Version: 1.0
In-Reply-To: <CAOssrKf8DN68+5aAseBYsnSXr+zWHy0UqNdVHMU5cSu0b-EvQw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="5uxjtfCkDB2HIf42ehl0bQry9MVudP2HH"
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
--5uxjtfCkDB2HIf42ehl0bQry9MVudP2HH
Content-Type: multipart/mixed; boundary="MM7t9sJcDOHYwKcbSzVtSAUZbHVzLFAT3"

--MM7t9sJcDOHYwKcbSzVtSAUZbHVzLFAT3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.01.20 12:51, Miklos Szeredi wrote:
> On Wed, Jan 15, 2020 at 11:10 AM Miklos Szeredi <mszeredi@redhat.com> w=
rote:
>=20
>> New operations needed:
>>
>> LOOKUP_WITH_HANDLE: same as LOOKUP, but returns handle in addition to
>> fuse_ino_t and attributes.
>> LOOKUP_BY_HANDLE: same as LOOKUP, but gets a handle as input.
>=20
> And that can be reduced further to a single extended LOOKUP_HANDLE,
> which takes a handle as input and returns a handle in addition to the
> usual stuff.  The lookup-by-handle case can be done with a special
> name.  Currently "." is used for this purpose in the fuse protocol,
> which is a bit confusing since it has nothing to do the "." directory
> entry, but at least we don't have to introduce a new concept for this.

I=E2=80=99m afraid I don=E2=80=99t quite understand.  What handle would L=
OOKUP_HANDLE
take as input when I want to open a new file (as in, LOOKUP_WITH_HANDLE)?=


Max


--MM7t9sJcDOHYwKcbSzVtSAUZbHVzLFAT3--

--5uxjtfCkDB2HIf42ehl0bQry9MVudP2HH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl4fCswACgkQ9AfbAGHV
z0BEnwf/coIMSLjsLCOqUiawXWeltVN6LYeQLZAawtCCcv75VZMOyVUy89bi4s5N
Cg04BwMjhFrteKK6LZIT+fPY8ft7/6nXit79eCu/wIS1BoiysZcx3xkg5VHUoCpJ
v+yvZSmQDDeRrjQKrVGakYPGaolUf3XxuD49RM/pzmIxD4zfxG7fqzjEMENG6ORP
lfiHNkeTqS0oppvGTGQCZsGhZBxLMK0/NGiCozMUs4W/rkQBYhzCp7SvfsXMKEs4
G6VSamJs/VjPy9ymyWycNQLKXj5gAATzXTeBxQJhP0BDygNW/l/3qgySKERPjSI1
qinnA1pB0MWonejNom4dNMDeaekDSg==
=JJKd
-----END PGP SIGNATURE-----

--5uxjtfCkDB2HIf42ehl0bQry9MVudP2HH--

