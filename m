References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
	<CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
	<20200428191523.GU2794@work-vm>
	<0da9422f-6399-6ef0-1042-4b2b90d49ed8@redhat.com>
	<CAOssrKfA_7cAio6i4Zy5hM-6VwBXphja6ps4s_NKrLsoF1yC+Q@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <f2d4ced9-fc6d-289d-a979-4745039fcc8d@redhat.com>
Date: Wed, 29 Apr 2020 11:31:49 +0200
MIME-Version: 1.0
In-Reply-To: <CAOssrKfA_7cAio6i4Zy5hM-6VwBXphja6ps4s_NKrLsoF1yC+Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="EwsuK18nZn2W7T7QSjzF9UHriesKfQycx"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EwsuK18nZn2W7T7QSjzF9UHriesKfQycx
Content-Type: multipart/mixed; boundary="WDB7GMBz84t3sPeKFMKQSSDlFSWqHgEWq"

--WDB7GMBz84t3sPeKFMKQSSDlFSWqHgEWq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29.04.20 10:52, Miklos Szeredi wrote:
> On Wed, Apr 29, 2020 at 10:31 AM Max Reitz <mreitz@redhat.com> wrote:
>>
>> On 28.04.20 21:15, Dr. David Alan Gilbert wrote:
>=20
>>> So are you saying we need a:
>>>        if (mount(NULL, "/", NULL, MS_REC | MS_SHARED, NULL) < 0) {
>>>
>>>   and can this go straight after (1) ?
>>
>> Isn=E2=80=99t MS_SHARED and MS_SLAVE mutually exclusive, that is, both=
 are just
>> different propagation types?  So shouldn=E2=80=99t putting this after =
(1) be
>> effectively the same as replacing (1)?
>=20
> No, think of it more like a set of groups (mounts in a group have the
> same "shared:$ID" tag in /proc/self/mountinfo) and these groups being
> arranged into a tree, where child groups get propagation from the
> parent group (mounts have a "master:$PARENT_ID" tag), but not the
> other way round.
>=20
> So if a mount is part of a shared group and this group is also the
> child of another shared group, then it will have both a "shared:$ID"
> and a "master:$PARENT_ID" tag in /proc/self/mountinfo.

Ah, OK.

Thanks a lot for the explanation!

> For the gory details see Documentation/filesystems/sharedsubtree.txt

Not sure whether I want to *cough* O:)

Max


--WDB7GMBz84t3sPeKFMKQSSDlFSWqHgEWq--

--EwsuK18nZn2W7T7QSjzF9UHriesKfQycx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6pSYUACgkQ9AfbAGHV
z0BcVAf/Zq6s9xku0URumDj4hVZWaSNCyJaeFYkIsG3rnD1YJgm865JXXNKGVeED
tk4ls7lGyIF12/cisyRUm5EYNv9gIjk7sFrW6PJzh7I5OaLrQoE8OcG/Px0Bcg6B
TGuEEXVj3BJiDY0Pc9l4ljeI/HGG/PxftRMRosHzvV2TWwh/M1p487NMYyWMsW61
P+h4E19uXJjLLsVdrqYpN6fvOuvsRgwGY/n39dRNKqeMsDdTNDse9v1AcYHWaI34
XPYrD4M/7Rxh9IUMcZe/bpkAgQQ4cojKvegtCf7f2xI8nn+9UgqFZlRM76RW3QcI
AaTEUahZHB72K3GhOaQgN2ZrP6hCvA==
=i23r
-----END PGP SIGNATURE-----

--EwsuK18nZn2W7T7QSjzF9UHriesKfQycx--

