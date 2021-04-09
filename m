References: <20210409100627.451573-1-groug@kaod.org>
	<daa895d8-7fbc-e4f5-3cfe-29cae4cd193a@weilnetz.de>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <94bab651-8514-3f16-b61e-0f33a8e2d248@redhat.com>
Date: Fri, 9 Apr 2021 17:24:09 +0200
MIME-Version: 1.0
In-Reply-To: <daa895d8-7fbc-e4f5-3cfe-29cae4cd193a@weilnetz.de>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix side-effect in assert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Weil <sw@weilnetz.de>, Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

Hi Stefan,

On 4/9/21 5:11 PM, Stefan Weil wrote:
> Am 09.04.21 um 12:06 schrieb Greg Kurz:
>=20
>> It is bad practice to put an expression with a side-effect in
>> assert() because the side-effect won't happen if the code is
>> compiled with -DNDEBUG.
>>
>> Use an intermediate variable. Consolidate this in an macro to
>> have proper line numbers when the assertion is hit.
>>
>> virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:
>> =A0 Assertion `fchdir_res =3D=3D 0' failed.
>> Aborted
>>
>> =A0=A0 2796=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* fchdir should not fail here */
>> =3D>2797=A0=A0=A0=A0=A0=A0=A0=A0=A0 FCHDIR_NOFAIL(lo->proc_self_fd);
>> =A0=A0 2798=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D getxattr(procname, name, =
value, size);
>> =A0=A0 2799=A0=A0=A0=A0=A0=A0=A0=A0=A0 FCHDIR_NOFAIL(lo->root.fd);
>>
>> Fixes: bdfd66788349 ("virtiofsd: Fix xattr operations")
>> Cc: misono.tomohiro@jp.fujitsu.com
>> Signed-off-by: Greg Kurz <groug@kaod.org>
>> ---
>> =A0 tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++--------
>> =A0 1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c
>> b/tools/virtiofsd/passthrough_ll.c
>> index 1553d2ef454f..6592f96f685e 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -2723,6 +2723,11 @@ static int xattr_map_server(const struct lo_data =

> *lo, const char *server_name,
>> =A0=A0=A0=A0=A0 return -ENODATA;
>> =A0 }
>> =A0 +#define FCHDIR_NOFAIL(fd) do {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
>> +=A0=A0=A0=A0=A0=A0=A0 int fchdir_res =3D fchdir(fd);=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
>> +=A0=A0=A0=A0=A0=A0=A0 assert(fchdir_res =3D=3D 0);=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
>> +=A0=A0=A0 } while (0)
>> +
>> =A0 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char
>> *in_name,
>> =A0=20
>=20
>=20
> I am afraid that this will raise a compiler warning (or error with
> -Werror) when NDEBUG is defined because the variable is unused in that
> case ([-Wunused-variable]).
>=20
> I suggest to use different implementations of the macro depending on
> NDEBUG.

QEMU doesn't build with NDEBUG, see commit 262a69f4282
("osdep.h: Prohibit disabling assert() in supported builds").

Regards,

Phil.

