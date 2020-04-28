References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<8aa9aea2-cc5d-f9b5-5cdb-b5e596ef89aa@redhat.com>
	<20200428095935.GA2794@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <537eb3fe-d930-1d8e-1597-1b73831d0623@redhat.com>
Date: Tue, 28 Apr 2020 12:13:14 +0200
MIME-Version: 1.0
In-Reply-To: <20200428095935.GA2794@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ZSsyBjZKdka6iJkrHCtJc6NPPhvKrYh2D"
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
--ZSsyBjZKdka6iJkrHCtJc6NPPhvKrYh2D
Content-Type: multipart/mixed; boundary="sGOz0g6p87dklTrbhaM7lkcYZN6yEs9fj"

--sGOz0g6p87dklTrbhaM7lkcYZN6yEs9fj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28.04.20 11:59, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> On 27.04.20 19:59, Dr. David Alan Gilbert wrote:
>>> * Max Reitz (mreitz@redhat.com) wrote:
>>>> Currently, setup_mounts() bind-mounts the shared directory without
>>>> MS_REC.  This makes all submounts disappear.
>>>>
>>>> Pass MS_REC so that the guest can see submounts again.
>>>
>>> Thanks!
>>>
>>>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
>>>
>>> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
>>
>> Well, I bisected it and landed at 3ca8a2b1.  So while the problematic
>> line may have been introduced by 5baa3b8e, it wasn=E2=80=99t used unti=
l 3ca8a2b1.
>=20
> OK, I'd rather stick with the Fixes: for the patch that was actually
> wrong.

Why not both? :)

>>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>>> ---
>>>>  tools/virtiofsd/passthrough_ll.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/pass=
through_ll.c
>>>> index 4c35c95b25..9d7f863e66 100644
>>>> --- a/tools/virtiofsd/passthrough_ll.c
>>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
>>>>      int oldroot;
>>>>      int newroot;
>>>> =20
>>>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
>>>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
>>>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", sour=
ce, source);
>>>>          exit(1);
>>>>      }
>>>
>>> Do we want MS_SLAVE to pick up future mounts that might happenf rom t=
he
>>> host?
>>
>> Hm.  So first it looks to me from the man page like one shouldn=E2=80=99=
t give
>> MS_SLAVE on the first mount() call but kind of only use it for remount=
s
>> (in the list at the start, =E2=80=9CCreate a bind mount=E2=80=9D is se=
parate from
>> =E2=80=9CChange the propagation type of an existing mount=E2=80=9D, an=
d the man page
>> later says =E2=80=9CThe only other flags that can be specified while c=
hanging
>> the propagation type are MS_REC (described below) and MS_SILENT (which=

>> is ignored).=E2=80=9D).
>>
>> Second, even if I do change the propagation type to MS_SLAVE in a seco=
nd
>> call, mounts done after qemu has been started don=E2=80=99t show up in=
 the guest
>> (for me).
>>
>> So while it sounds correct, I can=E2=80=99t see it having an effect, a=
ctually.
>=20
> That's unfortunate; but I guess we can debug that separately
>=20
>>> What's the interaction between this and the MS_REC|MS_SLAVE that we h=
ave
>>> a few lines above for / ?
>>
>> Good question.  It would seem to me that there isn=E2=80=99t any.  Tha=
t previous
>> mount call just sets MS_REC | MS_SLAVE for the whole mount namespace,
>> and then we do a new mount here (by default from / to /) that needs it=
s
>> own flags.
>>
>> (More interesting is perhaps why we have that other mount() call below=
,
>> which again sets MS_REC | MS_SLAVE for the old (not-yet-bind-mounted) =
/.
>>  I can=E2=80=99t imagine that to have any effect.)
>=20
> Is that just trying to be careful before the umount2 so it doesn't try
> to unmount something useful?

Perhaps, but still, it shouldn=E2=80=99t matter.  I rather suspect that
setup_namespaces() and setup_mounts() were developed (or taken from
elsewhere) independently, so they both have to work independently, and
thus they do overlapping stuff.

Max


--sGOz0g6p87dklTrbhaM7lkcYZN6yEs9fj--

--ZSsyBjZKdka6iJkrHCtJc6NPPhvKrYh2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6oAboACgkQ9AfbAGHV
z0CVhAf+IuToXHK0o9w6hHjFtn1Lhg+/OO+5TZYh1wZIHI7gKBHmgW6dvJ05ya6o
d+NpukoaT/KY5E7n/T/Z/OfBdsYGHbJAEF/HSWLgA7wg2ydPc7+lxO6ETzdwUlDq
wL4W9cyZYcjQ7DlhPlBX5yxbclPhhih2ZqXgm3yIk6qiGmLhw7+8IG9Gt5LNr5xR
7AvA0h4hXpTdggb6UzFJW1zaAz7VF1rqWYB0jOKqPO/EkP35rc7FDvrdvkcwmnrH
CqkZbaApc98HavdMO5oNk3ZbqrwTl2BKUjPT4yWxUY1ifHCx8Fz7wWt+a7x8b8TO
ykAU8yhFzhetHgadA3t0qcrqXyvlxg==
=qz4M
-----END PGP SIGNATURE-----

--ZSsyBjZKdka6iJkrHCtJc6NPPhvKrYh2D--

