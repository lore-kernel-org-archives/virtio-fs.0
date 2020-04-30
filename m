References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
Date: Thu, 30 Apr 2020 10:06:38 +0200
MIME-Version: 1.0
In-Reply-To: <20200429145720.GA2835@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="VfMXd0A9lsKHTdtmnEIgup0HHc6Fg85BM"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, vgoyal@redhat.com
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VfMXd0A9lsKHTdtmnEIgup0HHc6Fg85BM
Content-Type: multipart/mixed; boundary="O6YdhWTZKzSi3jxH66oRrf9TqiXKGl3wy"

--O6YdhWTZKzSi3jxH66oRrf9TqiXKGl3wy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29.04.20 16:57, Dr. David Alan Gilbert wrote:
> * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
>> * Max Reitz (mreitz@redhat.com) wrote:
>>> Currently, setup_mounts() bind-mounts the shared directory without
>>> MS_REC.  This makes all submounts disappear.
>>>
>>> Pass MS_REC so that the guest can see submounts again.
>>
>> Thanks!
>>
>>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>>
>> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
>>
>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>> ---
>>>  tools/virtiofsd/passthrough_ll.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passt=
hrough_ll.c
>>> index 4c35c95b25..9d7f863e66 100644
>>> --- a/tools/virtiofsd/passthrough_ll.c
>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
>>>      int oldroot;
>>>      int newroot;
>>> =20
>>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
>>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", sourc=
e, source);
>>>          exit(1);
>>>      }
>>
>> Do we want MS_SLAVE to pick up future mounts that might happenf rom th=
e
>> host?
>> What's the interaction between this and the MS_REC|MS_SLAVE that we ha=
ve
>> a few lines above for / ?
>=20
> Just to confirm something from vgoyal, and what had confused me about
> why we hadn't spotted this earlier.
>=20
> Even without this patch, the SLAVE stuff worked so if you start the
> daemon and *then* mount under the shared directory, the guest sees it
> with or without this patch.

Hm, I don=E2=80=99t.  Do you really?

Max


--O6YdhWTZKzSi3jxH66oRrf9TqiXKGl3wy--

--VfMXd0A9lsKHTdtmnEIgup0HHc6Fg85BM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6qhw4ACgkQ9AfbAGHV
z0D4FQgApig8MgU761qQRHR9UZjX6LlUXBHFihv6ncKrjUojgtA6xJIs/jZSfX/W
JVs/+tEqr5Pa60/u5kW5Cl05/rzPuwJNa7O/fvuZCemoMMM1U/iMAqO365qOcBBv
xyJTufrX01PYh7u7w9LTpcg/hkoXC2xIue6z5jVNa/QqvOSI9Z5EUoSO/lDnVIKx
IfJqNfyhQ5bDxXNYiiGHwX19RRtoMNsPid3b+0ZHr++Fc17KrTOvXlm3wwdu0qEd
XGoldjorvPsVTTT/6iYCvE1JiGPqWcFpSvQunGQmzqfml1F33KjFtrNLLW13ZS6V
p3wDvg3E00UeXf9s8Q5XZz9KqmGe+Q==
=9HSK
-----END PGP SIGNATURE-----

--VfMXd0A9lsKHTdtmnEIgup0HHc6Fg85BM--

