References: <20210409100627.451573-1-groug@kaod.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <3f3b6729-4380-40a2-4349-a235422e4535@redhat.com>
Date: Fri, 9 Apr 2021 12:23:31 +0200
MIME-Version: 1.0
In-Reply-To: <20210409100627.451573-1-groug@kaod.org>
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
To: Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 4/9/21 12:06 PM, Greg Kurz wrote:
> It is bad practice to put an expression with a side-effect in
> assert() because the side-effect won't happen if the code is
> compiled with -DNDEBUG.
>=20
> Use an intermediate variable. Consolidate this in an macro to
> have proper line numbers when the assertion is hit.
>=20
> virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:
>  Assertion `fchdir_res =3D=3D 0' failed.
> Aborted
>=20
>   2796          /* fchdir should not fail here */
> =3D>2797          FCHDIR_NOFAIL(lo->proc_self_fd);
>   2798          ret =3D getxattr(procname, name, value, size);
>   2799          FCHDIR_NOFAIL(lo->root.fd);
>=20
> Fixes: bdfd66788349 ("virtiofsd: Fix xattr operations")
> Cc: misono.tomohiro@jp.fujitsu.com
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

