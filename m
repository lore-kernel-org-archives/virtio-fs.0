References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
	<8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
	<20200430085812.GC2874@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <94924861-d934-0151-aca5-19ea9eb211e1@redhat.com>
Date: Thu, 30 Apr 2020 11:21:47 +0200
MIME-Version: 1.0
In-Reply-To: <20200430085812.GC2874@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="QfIUrViZs5Euqaf87kfYpcqVjvFsO1FSh"
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QfIUrViZs5Euqaf87kfYpcqVjvFsO1FSh
Content-Type: multipart/mixed; boundary="54ZYs4vew8w0glUUsJpzbmIWuUUfoegiz"

--54ZYs4vew8w0glUUsJpzbmIWuUUfoegiz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 30.04.20 10:58, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> On 29.04.20 16:57, Dr. David Alan Gilbert wrote:
>>> * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
>>>> * Max Reitz (mreitz@redhat.com) wrote:
>>>>> Currently, setup_mounts() bind-mounts the shared directory without
>>>>> MS_REC.  This makes all submounts disappear.
>>>>>
>>>>> Pass MS_REC so that the guest can see submounts again.
>>>>
>>>> Thanks!
>>>>
>>>>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>>>>
>>>> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
>>>>
>>>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>>>> ---
>>>>>  tools/virtiofsd/passthrough_ll.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/pas=
sthrough_ll.c
>>>>> index 4c35c95b25..9d7f863e66 100644
>>>>> --- a/tools/virtiofsd/passthrough_ll.c
>>>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>>>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
>>>>>      int oldroot;
>>>>>      int newroot;
>>>>> =20
>>>>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>>>>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {=

>>>>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", sou=
rce, source);
>>>>>          exit(1);
>>>>>      }
>>>>
>>>> Do we want MS_SLAVE to pick up future mounts that might happenf rom =
the
>>>> host?
>>>> What's the interaction between this and the MS_REC|MS_SLAVE that we =
have
>>>> a few lines above for / ?
>>>
>>> Just to confirm something from vgoyal, and what had confused me about=

>>> why we hadn't spotted this earlier.
>>>
>>> Even without this patch, the SLAVE stuff worked so if you start the
>>> daemon and *then* mount under the shared directory, the guest sees it=

>>> with or without this patch.
>>
>> Hm, I don=E2=80=99t.  Do you really?
>=20
> Yes! With your patch reverted:
>=20
> Start virtiofsd, mount in the guest:
>=20
> host:
> # ./virtiofsd --socket-path=3D/tmp/vhostqemu -o source=3D/home/dgilbert=
/virtio-fs/fs  -o log_level=3Dwarn -o no_writeback
>=20
> guest:
> # mount -t virtiofs myfs /sysroot

OK, for some reason I didn=E2=80=99t try to mount in the guest first, but=
 did
the host mount after starting virtiofsd.

My mount test uses multiple mounts, and two of them I see mounted, but
three I still don=E2=80=99t see mounted.

Let me see whether I can come up with something reproducible that isn=E2=80=
=99t
a script.

[...]

> Maybe this is related to what Vivek said about default behaviours on
> systemd's, what does:
>=20
> # findmnt -o +PROPAGATION
> TARGET    SOURCE         FSTYPE     OPTIONS                            =
                                                      PROPAGATION
> /         /dev/mapper/fedora_dgilbert--t580-root
> =E2=94=82                        xfs        rw,relatime,seclabel,attr2,=
inode64,logbufs=3D8,logbsize=3D32k,noquota                        shared
>=20
> say for your source=3D directory?

I have Fedora, too, so pretty much the same.

Max


--54ZYs4vew8w0glUUsJpzbmIWuUUfoegiz--

--QfIUrViZs5Euqaf87kfYpcqVjvFsO1FSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6qmKsACgkQ9AfbAGHV
z0Db1wf/aIFXWLNFxAHC+g0QoZDUd6nlDlqu3qi7Sf1sJNv0r8mlCEXWMcPn1IN8
jl/vrGskXH6tEM0KuzpQI/H9NEwIQ/nLfnJvNR/taEfFCAx+/PH+QTxh6GA25Xzy
YzUEbeO6+P9wrO/YSeaT/CGVn88U20gA4e/Gyjq7YBxACq/bF7uGvwmCyPoDOqm0
1A9TZkyy54WGSqyzbPrxBtUa2ULMiEwwvjVnTXamOvikVL+oCiopxi/30i1/aRsP
bUNZuJP/1tGFIMazN5R0YnXbTFuvUISe+bFKhkXR7OUEvsJON+lHejJVL1XfZg3Z
AB7ZVxdNAGQKhFhs2vUAvHj0JFS/cg==
=UzY4
-----END PGP SIGNATURE-----

--QfIUrViZs5Euqaf87kfYpcqVjvFsO1FSh--

