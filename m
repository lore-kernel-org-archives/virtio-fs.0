References: <20210409100627.451573-1-groug@kaod.org>
From: Stefan Weil <sw@weilnetz.de>
Message-ID: <daa895d8-7fbc-e4f5-3cfe-29cae4cd193a@weilnetz.de>
Date: Fri, 9 Apr 2021 17:11:13 +0200
MIME-Version: 1.0
In-Reply-To: <20210409100627.451573-1-groug@kaod.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
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

Am 09.04.21 um 12:06 schrieb Greg Kurz:

> It is bad practice to put an expression with a side-effect in
> assert() because the side-effect won't happen if the code is
> compiled with -DNDEBUG.
>
> Use an intermediate variable. Consolidate this in an macro to
> have proper line numbers when the assertion is hit.
>
> virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:
>   Assertion `fchdir_res == 0' failed.
> Aborted
>
>    2796          /* fchdir should not fail here */
> =>2797          FCHDIR_NOFAIL(lo->proc_self_fd);
>    2798          ret = getxattr(procname, name, value, size);
>    2799          FCHDIR_NOFAIL(lo->root.fd);
>
> Fixes: bdfd66788349 ("virtiofsd: Fix xattr operations")
> Cc: misono.tomohiro@jp.fujitsu.com
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   tools/virtiofsd/passthrough_ll.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 1553d2ef454f..6592f96f685e 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2723,6 +2723,11 @@ static int xattr_map_server(const struct lo_data 
*lo, const char *server_name,
>       return -ENODATA;
>   }
>   
> +#define FCHDIR_NOFAIL(fd) do {                         \
> +        int fchdir_res = fchdir(fd);                   \
> +        assert(fchdir_res == 0);                       \
> +    } while (0)
> +
>   static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>   


I am afraid that this will raise a compiler warning (or error with 
-Werror) when NDEBUG is defined because the variable is unused in that 
case ([-Wunused-variable]).

I suggest to use different implementations of the macro depending on NDEBUG.

Stefan




