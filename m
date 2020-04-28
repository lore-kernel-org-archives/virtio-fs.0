References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <8aa9aea2-cc5d-f9b5-5cdb-b5e596ef89aa@redhat.com>
Date: Tue, 28 Apr 2020 08:06:30 +0200
MIME-Version: 1.0
In-Reply-To: <20200427175902.GM2923@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="zOPKgSvGA9aD5ncr3lfdc5QsGlK365KXv"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zOPKgSvGA9aD5ncr3lfdc5QsGlK365KXv
Content-Type: multipart/mixed; boundary="jx7TNYgfYlBaxII1dZA4uAvXh65J08ksL"

--jx7TNYgfYlBaxII1dZA4uAvXh65J08ksL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 27.04.20 19:59, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> Currently, setup_mounts() bind-mounts the shared directory without
>> MS_REC.  This makes all submounts disappear.
>>
>> Pass MS_REC so that the guest can see submounts again.
>=20
> Thanks!
>=20
>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>=20
> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?

Well, I bisected it and landed at 3ca8a2b1.  So while the problematic
line may have been introduced by 5baa3b8e, it wasn=E2=80=99t used until 3=
ca8a2b1.

>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>> ---
>>  tools/virtiofsd/passthrough_ll.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passth=
rough_ll.c
>> index 4c35c95b25..9d7f863e66 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
>>      int oldroot;
>>      int newroot;
>> =20
>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source=
, source);
>>          exit(1);
>>      }
>=20
> Do we want MS_SLAVE to pick up future mounts that might happenf rom the=

> host?

Hm.  So first it looks to me from the man page like one shouldn=E2=80=99t=
 give
MS_SLAVE on the first mount() call but kind of only use it for remounts
(in the list at the start, =E2=80=9CCreate a bind mount=E2=80=9D is separ=
ate from
=E2=80=9CChange the propagation type of an existing mount=E2=80=9D, and t=
he man page
later says =E2=80=9CThe only other flags that can be specified while chan=
ging
the propagation type are MS_REC (described below) and MS_SILENT (which
is ignored).=E2=80=9D).

Second, even if I do change the propagation type to MS_SLAVE in a second
call, mounts done after qemu has been started don=E2=80=99t show up in th=
e guest
(for me).

So while it sounds correct, I can=E2=80=99t see it having an effect, actu=
ally.

> What's the interaction between this and the MS_REC|MS_SLAVE that we hav=
e
> a few lines above for / ?

Good question.  It would seem to me that there isn=E2=80=99t any.  That p=
revious
mount call just sets MS_REC | MS_SLAVE for the whole mount namespace,
and then we do a new mount here (by default from / to /) that needs its
own flags.

(More interesting is perhaps why we have that other mount() call below,
which again sets MS_REC | MS_SLAVE for the old (not-yet-bind-mounted) /.
 I can=E2=80=99t imagine that to have any effect.)

Max


--jx7TNYgfYlBaxII1dZA4uAvXh65J08ksL--

--zOPKgSvGA9aD5ncr3lfdc5QsGlK365KXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6nx+YACgkQ9AfbAGHV
z0BVWwf+O8Uh7ZUmSnV29FWnmLRugDDUamw5nwW1PD7NS/gyI4eZhFgmqqweFeDY
pDo1/O1QZgWQix94UR4oSz1YWkKs5RTnT7oK6TTVXCoXzv7E+KSxipbeZWYmAXGE
pPLHBJA6f7iozo4NjPMce4+EPAIEC/gl8DOhw6rzFJuioyghYBYE7F7ZfhkxGpJY
q+gs20BDRymK0BzYt5TuZQ5q0LzQvVbBsgtnJ6dFUEPCB0FrCC3hDVmTnLPm5Pdm
aitOlNptlgyj+TTA2Msz3w7QIK2VGO0x3/EMlS7kkNV1vm8Nkq065/PT2/k0ur6R
coGxfV2GruNEVjsf59vEMzLrRmnMaQ==
=Mzh7
-----END PGP SIGNATURE-----

--zOPKgSvGA9aD5ncr3lfdc5QsGlK365KXv--

