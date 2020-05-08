References: <20200506153258.238687-1-mreitz@redhat.com>
	<20200507205349.GD47645@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <ca1e4ae3-44c8-3ffc-92e9-023f9a4bb9a0@redhat.com>
Date: Fri, 8 May 2020 09:31:47 +0200
MIME-Version: 1.0
In-Reply-To: <20200507205349.GD47645@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="K1Eoi9Ye5ZgvkhedjFiVftDOJkCyzaUcS"
Subject: Re: [Virtio-fs] [RFC] Duplicate submounts in the guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K1Eoi9Ye5ZgvkhedjFiVftDOJkCyzaUcS
Content-Type: multipart/mixed; boundary="vcYNKDlFQQTQ6D6Tvf6myaZq5DnS4365Y"

--vcYNKDlFQQTQ6D6Tvf6myaZq5DnS4365Y
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07.05.20 22:53, Vivek Goyal wrote:
> On Wed, May 06, 2020 at 05:32:58PM +0200, Max Reitz wrote:
>> Hi,
>>
>> This RFC consists of two patch series, one for virtiofsd (i.e., to be
>> applied to the qemu repo), and one for Linux.
>>
>> The problem it wants to solve is that virtiofsd just passes through th=
e
>> stat.st_ino value from the host to the guest, without taking stat.st_d=
ev
>> into account.  Therefore, it is generally impossible to uniquely
>> identify nodes in the guest by their st_dev/st_ino combinations.
>>
>> One way to fix this would be to derive some algorithm to derive a uniq=
ue
>> st_ino value from the st_dev/st_ino combination on the host, but this =
is
>> not always possible.
>>
>> So what this series does it basically passing through st_dev alongside=

>> st_ino: We can let the guest create auto-mounted submounts for every
>> host mount point, so that they get their own dedicated st_dev.  This i=
s
>> similar to what NFS does with the crossmnt option.
>>
>> Announcing submounts to the guest (the FUSE client) is done by the FUS=
E
>> server (virtiofsd) of setting st_rdev to a non-zero value (e.g. st_dev=
)
>> for every mount point.
>>
>> In this version here, duplicate mounts on the host (same st_dev) will
>> not necessarily have the same st_dev in the guest.  That would be more=

>> complicated to implement, and there is probably no real need to.
>=20
> Hi Max,
>=20
> What's duplicate mount. Is it two bind bounts created from same
> filesystem.

For example; or the same filesystem from the same device twice
(mount /dev/loop0 a; mount /dev/loop0 b).

> So two bind mounts which have same st_dev on host, will appear to come
> from two different devices in guest (different st_dev), right?

Yes.

Max


--vcYNKDlFQQTQ6D6Tvf6myaZq5DnS4365Y--

--K1Eoi9Ye5ZgvkhedjFiVftDOJkCyzaUcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl61CuMACgkQ9AfbAGHV
z0DAyAf/bOPvJ82dPn/EcVAoFI+Ax6fkoLclZwI1aDNT2LuC18wmXYTRYW+iMBeY
z6VHnn5FFEjLQpr9jtgyua5Ugtq1/PpgdWGZbEcEeld/V7y0FZqZDb4AI2g0hKBq
O08f4eRYa9vZ5y4CivtWdAGzEcnq4IzcaIzccfiTRm8XHmlypYGM6aIermWz3y4L
otioZ0YQhRG7xLAbyRYrn81Lw0Lb5B/uJW5N7kzL2o6dPH/EDLNyIYGktPREN6S4
9PGXDXL17aW6Jd1r8dFuScmU+I4YKWK3ixHIE/JzXhmG37a9Ge6Gq3J9V0ClIVWq
PFlktzebAIlT+6kQXrCjHsoYgeclmw==
=9Jqu
-----END PGP SIGNATURE-----

--K1Eoi9Ye5ZgvkhedjFiVftDOJkCyzaUcS--

