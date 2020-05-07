References: <20200506153832.240812-1-mreitz@redhat.com>
	<20200506154010.241055-2-mreitz@redhat.com>
	<20200506160411.GO2743@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <52f6dc62-496e-2337-72dc-a9b762732848@redhat.com>
Date: Thu, 7 May 2020 12:56:04 +0200
MIME-Version: 1.0
In-Reply-To: <20200506160411.GO2743@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="yuzO0kdxLhw3JYH4TbktOSIDZgAlU0bwS"
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yuzO0kdxLhw3JYH4TbktOSIDZgAlU0bwS
Content-Type: multipart/mixed; boundary="fJhHQnqN6VVlN1v0P4o1Abphd2GctHMzK"

--fJhHQnqN6VVlN1v0P4o1Abphd2GctHMzK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06.05.20 18:04, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> Whenever we encounter a directory with an st_dev that differs from tha=
t
>> of its parent, we set st_rdev accordingly so the guest can create a
>> submount for it.
>>
>> Make this behavior optional, so submounts are only announced to the
>> guest with the announce_submounts option.  Some users may prefer the
>> current behavior, so that the guest learns nothing about the host moun=
t
>> structure.
>>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>=20
> Does this need to be wired to a flag in the INIT message (like say
> FUSE_ASYNC_READ) to indicate that the kernel/daemon supports this, or i=
s
> it really safe just to start sending the changed rdev?

I supposed it to be safe, given that rdev is never used for anything but
device files, so basically it was just a reserved field for directories.

Max


--fJhHQnqN6VVlN1v0P4o1Abphd2GctHMzK--

--yuzO0kdxLhw3JYH4TbktOSIDZgAlU0bwS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6z6UQACgkQ9AfbAGHV
z0C0mAf7BWyq31NXvnuIqeEPWfO37dv71m4JlLxbjPWhOXfoXW8VrNGfE1alZK5W
oYgqpzyMRODXDcDgf/9HJJBnPeP7kOp3oZ+5X2K9d7wtAvJ2Eg0lafzGT5/3GYeB
aaA8Rex9SyVL4QbloUBp0l1K+/eKSvvP53ctFa7VjqIqZkWWjVrRk+CyIkLVWvTz
kdbcU5LjGG5LGA49prqhaERAjwX3MAkRCK8T82GLOavadzyKrXU0p8jkTmIDakJL
oZTATudSSQ7kKiPR8YZzNMy4+zRH1rT1hlPcszV64hVNCTRDXppl7832mzR3sBAt
XExumZhH5whr4zTkbyAkoVSjj+98iQ==
=561L
-----END PGP SIGNATURE-----

--yuzO0kdxLhw3JYH4TbktOSIDZgAlU0bwS--

