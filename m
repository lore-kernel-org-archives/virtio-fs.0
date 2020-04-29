References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
	<CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
	<20200428191523.GU2794@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <0da9422f-6399-6ef0-1042-4b2b90d49ed8@redhat.com>
Date: Wed, 29 Apr 2020 10:31:08 +0200
MIME-Version: 1.0
In-Reply-To: <20200428191523.GU2794@work-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Fa6z0x3Hyua25I2PFGnHyAkbwADmM0xmU"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fa6z0x3Hyua25I2PFGnHyAkbwADmM0xmU
Content-Type: multipart/mixed; boundary="amDNFfKQLvJWzDQB1r9C5KjbfYuHngW6g"

--amDNFfKQLvJWzDQB1r9C5KjbfYuHngW6g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28.04.20 21:15, Dr. David Alan Gilbert wrote:
> * Miklos Szeredi (mszeredi@redhat.com) wrote:
>> On Tue, Apr 28, 2020 at 4:52 PM Stefan Hajnoczi <stefanha@redhat.com> =
wrote:
>>>
>>> On Mon, Apr 27, 2020 at 06:59:02PM +0100, Dr. David Alan Gilbert wrot=
e:
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
>>>>>
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
>>>
>>> There are two separate concepts:
>>>
>>> 1. Mount namespaces.  The virtiofsd process is sandboxed and lives in=

>>>    its own mount namespace.  Therefore it does not share the mounts t=
hat
>>>    the rest of the host system sees.
>>>
>>> 2. Propagation type.  This is related to bind mounts so that mount
>>>    operations that happen in one bind-mounted location can also appea=
r
>>>    in other bind-mounted locations.
>>>
>>> Since virtiofsd is in a separate mount namespace, does the propagatio=
n
>>> type even have any effect?
>>
>> It's a complicated thing.  Current setup results in propagation
>> happening to the cloned namespace, but not to the bind mounted root.
>>
>> Why?  Because setting mounts "slave" after unshare, results in the
>> propagation being stopped at that point.  To make it propagate
>> further, change it back to "shared".  Note: the result changing to
>> "slave" and then to "shared" results in breaking the backward
>> propagation to the original namespace, but allowing propagation
>> further down the chain.
>=20
> Do you mean on the "/" ?
>=20
> So our current sequence is:
>=20
>    (new namespace)
>  1)    if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
>  2)   if (mount("proc", "/proc", "proc",
>            ....
>  3)   if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
>  4)  (chdir newroot, pivot, chdir oldroot)
>  5)   if (mount("", ".", "", MS_SLAVE | MS_REC, NULL) < 0) {
>  6)   if (umount2(".", MNT_DETACH) < 0) {
>=20
> So are you saying we need a:
>        if (mount(NULL, "/", NULL, MS_REC | MS_SHARED, NULL) < 0) {
>=20
>   and can this go straight after (1) ?

Isn=E2=80=99t MS_SHARED and MS_SLAVE mutually exclusive, that is, both ar=
e just
different propagation types?  So shouldn=E2=80=99t putting this after (1)=
 be
effectively the same as replacing (1)?

Max


--amDNFfKQLvJWzDQB1r9C5KjbfYuHngW6g--

--Fa6z0x3Hyua25I2PFGnHyAkbwADmM0xmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6pO0wACgkQ9AfbAGHV
z0AcVAf/fevwv5zOzFlL6k+o2MbLUT3qtjfeX2Px9ONYHLV8ENTebgNk8XU6IVij
Ptkw8nkTyjoCccK0WejZzSrWun+dKlOLrEMsXNOEMsI7ildSLWXQq7dHkQH8xVRG
QUGtrSNoT/VoWgU0GjomKXYQbLqMYcgSnRn5oNVh+kGH2UYOD+1Z4k7p4mnnLyad
Gn94GElfFOvvVTduQPSYiUMj9r+TjWFr7Yfdq3QqrFmqCNPnr2PE2AyZy1sA7o4z
aS2t7ARU3qDHZ7b8dlyUXwg5GRt4o+F/mIcsotc1Y42t4/K63ju9StodN60yqS0i
PCWUNW5gF/HH5DypfXQHC3nzu9VBxQ==
=MqzQ
-----END PGP SIGNATURE-----

--Fa6z0x3Hyua25I2PFGnHyAkbwADmM0xmU--

