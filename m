References: <20200506153258.238687-1-mreitz@redhat.com>
	<20200506155212.GN2743@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <64d463d9-310c-3738-c80e-14c446add130@redhat.com>
Date: Thu, 7 May 2020 12:50:23 +0200
MIME-Version: 1.0
In-Reply-To: <20200506155212.GN2743@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="B8O9n2RaGMQtSnjnfXe7RQcwz6LAKpMvk"
Subject: Re: [Virtio-fs] [RFC] Duplicate submounts in the guest
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
--B8O9n2RaGMQtSnjnfXe7RQcwz6LAKpMvk
Content-Type: multipart/mixed; boundary="VtrdiTyMv9boViL6nfLRdrRvAVdqjnCjq"

--VtrdiTyMv9boViL6nfLRdrRvAVdqjnCjq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06.05.20 17:52, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
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
>=20
> Nice;  this should probably get cc'd to fuse-devel and/or put as a pull=

> into their github to see what they have to say.

Sure, I just thought maybe I should gather some opinions here first. :)

Max


--VtrdiTyMv9boViL6nfLRdrRvAVdqjnCjq--

--B8O9n2RaGMQtSnjnfXe7RQcwz6LAKpMvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6z5+8ACgkQ9AfbAGHV
z0DFEgf/bP32iD7NhqOCbKVnhZKrRNrhSRqbuufNxeRQ4oIIUf5ruRVnVdYlCrsd
bHToGJIkfAo7lC06uYpepWLQJbWQBU/VqtFD0DV21NywViG45X5s0/4PEe1x5+b1
bXpca2bmYlpdO2J9tEHVlxDUIgG1VrMlCDh+Sua4BixUyMh173T/4g0wGKRkVR7/
+omSmhmCWYzWSygI9s+LYbTTE9kG1v0XRbBzX3Mk5eRxeZJCFFHJkz2ggdwr6hLo
X7+CciTjn7Nt/f4rQ5WGeNypiv/ulhXCRn5NHt4YhB3iE632EvhWu0puKknf1cET
/6YkzLi/29Nde7ia8t/t39n5bOkl4w==
=hjY6
-----END PGP SIGNATURE-----

--B8O9n2RaGMQtSnjnfXe7RQcwz6LAKpMvk--

