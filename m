References: <20200506153832.240812-1-mreitz@redhat.com>
	<20200506154010.241055-2-mreitz@redhat.com>
	<20200506160411.GO2743@work-vm>
	<52f6dc62-496e-2337-72dc-a9b762732848@redhat.com>
	<CAOssrKfcZH3Bu1g2U4XbGn_b5LenLoHQOO=WWqT71J4sMVTv3w@mail.gmail.com>
	<9a601294-a470-3df9-fd8f-0eb1ed5847b6@redhat.com>
	<CAOssrKcgQ7cFpG6Jh7B25bVNp419coHvFjCiGt4KiZ=oHsYhJw@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <4518b2a2-705b-9c13-1384-560e670f941f@redhat.com>
Date: Thu, 7 May 2020 17:15:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAOssrKcgQ7cFpG6Jh7B25bVNp419coHvFjCiGt4KiZ=oHsYhJw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="zOaZIOESmGytO0VymKLUpIoD4w8OfWqsY"
Subject: Re: [Virtio-fs] [RFC 2/2] virtiofsd: Set st_rdev for sub-mount
	points
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
--zOaZIOESmGytO0VymKLUpIoD4w8OfWqsY
Content-Type: multipart/mixed; boundary="h3kKql2P4LKlkfTh0wNYGrtiD69wQzrF6"

--h3kKql2P4LKlkfTh0wNYGrtiD69wQzrF6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07.05.20 16:29, Miklos Szeredi wrote:
> On Thu, May 7, 2020 at 2:18 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> On 07.05.20 13:43, Miklos Szeredi wrote:
>>> On Thu, May 7, 2020 at 12:56 PM Max Reitz <mreitz@redhat.com> wrote:
>>>>
>>>> On 06.05.20 18:04, Dr. David Alan Gilbert wrote:
>>>>> * Max Reitz (mreitz@redhat.com) wrote:
>>>>>> Whenever we encounter a directory with an st_dev that differs from=
 that
>>>>>> of its parent, we set st_rdev accordingly so the guest can create =
a
>>>>>> submount for it.
>>>>>>
>>>>>> Make this behavior optional, so submounts are only announced to th=
e
>>>>>> guest with the announce_submounts option.  Some users may prefer t=
he
>>>>>> current behavior, so that the guest learns nothing about the host =
mount
>>>>>> structure.
>>>>>>
>>>>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>>>>
>>>>> Does this need to be wired to a flag in the INIT message (like say
>>>>> FUSE_ASYNC_READ) to indicate that the kernel/daemon supports this, =
or is
>>>>> it really safe just to start sending the changed rdev?
>>>>
>>>> I supposed it to be safe, given that rdev is never used for anything=
 but
>>>> device files, so basically it was just a reserved field for director=
ies.
>>>
>>> You assume only directories can be mounted, but that's not so.  A
>>> device can also be the source or destination of a bind mount.
>>
>> Well, I mostly thought this case wouldn=E2=80=99t be too important.  B=
ut I
>> suppose it doesn=E2=80=99t make sense to decide now that it=E2=80=99s =
never going to be
>> important.
>>
>>> We need to extend fuse_entry_out with a flags field.  We could
>>> possibly reuse the upper bits of entry_valid (i.e. timeouts above say=

>>> INT_MAX seconds could be taken as  "infinity").  Unfortunately that's=

>>> not as easy as splitting it into two fields due to endianness :(
>>
>> For the time being, a single bit would be sufficient to signify whethe=
r
>> there should be a submount at all.  We could add a field with a submou=
nt
>> ID (i.e., st_dev from the host) in the future when we decide we
>> want/need to ensure that two inodes with the same st_dev on the host
>> also have the same st_dev in the guest.
>=20
> Hmm, do we need a separate bit, then?  Couldn't the kernel decide
> based on st_dev whether a new submount is needed?  I.e. return root
> st_dev in INIT reply, store it in root fuse_mount and lookups compare
> attr.dev to fm->st_dev.

That was the idea, but there is no fuse_attr.dev, which is why I
(ab)used fuse_attr.rdev instead.

Max


--h3kKql2P4LKlkfTh0wNYGrtiD69wQzrF6--

--zOaZIOESmGytO0VymKLUpIoD4w8OfWqsY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl60JgIACgkQ9AfbAGHV
z0BX8AgAmGDI/ywIoSdvyF2MQHGYcB+t3/JbKrk76sQIXHPdyKIDWAtJqoDcwOmc
NQ/jzsfAY5DWb/BEfxC5fVEYI4tSj7YNKbGWAQO3hONCUa20NASpceYyT98f3rsJ
sbAbRlvoEOzlkN/r1uRUOOANZWQh3bOkxUVnU3rPuSV8QIt9IhvYggFXgC2LohAB
My0hImY7V+53YyiAig6EdZEfYfG6EtVshsEAxHaqatuqNGyrGuFQt8Fgu0+ZNcGY
oKGQtrMdSe4RV5JnB99apgFDYaX9IhvDfqWjQcI1Kh9cnDl9RKFIWpqvh9MjSUQD
atgri4YA7WZ/cWXo2C6e6cewZVEDNA==
=j2jT
-----END PGP SIGNATURE-----

--zOaZIOESmGytO0VymKLUpIoD4w8OfWqsY--

