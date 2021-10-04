Date: Mon, 4 Oct 2021 15:54:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsVp4rPILhz+/Eh@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-11-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Z+FomQ254OgZIFhd"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-11-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 10/13] virtiofsd: Custom threadpool for
 remote blocking posix locks requests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--Z+FomQ254OgZIFhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:34AM -0400, Vivek Goyal wrote:
> Add a new custom threadpool using posix threads that specifically
> service locking requests.
>=20
> In the case of a fcntl(SETLKW) request, if the guest is waiting
> for a lock or locks and issues a hard-reboot through SYSRQ then virtiofsd
> unblocks the blocked threads by sending a signal to them and waking
> them up.
>=20
> The current threadpool (GThreadPool) is not adequate to service the
> locking requests that result in a thread blocking. That is because
> GLib does not provide an API to cancel the request while it is
> serviced by a thread. In addition, a user might be running virtiofsd
> without a threadpool (--thread-pool-size=3D0), thus a locking request
> that blocks, will block the main virtqueue thread that services requests
> from servicing any other requests.
>=20
> The only exception occurs when the lock is of type F_UNLCK. In this case
> the request is serviced by the main virtqueue thread or a GThreadPool
> thread to avoid a deadlock, when all the threads in the custom threadpool
> are blocked.
>=20
> Then virtiofsd proceeds to cleanup the state of the threads, release
> them back to the system and re-initialize.

Is there another way to cancel SETLKW without resorting to a new thread
pool? Since this only matters when shutting down or restarting, can we
close all plock->fd file descriptors to kick the GThreadPool workers out
of fnctl()?

>=20
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c         |  90 ++++++-
>  tools/virtiofsd/meson.build           |   1 +
>  tools/virtiofsd/passthrough_seccomp.c |   1 +
>  tools/virtiofsd/tpool.c               | 331 ++++++++++++++++++++++++++
>  tools/virtiofsd/tpool.h               |  18 ++
>  5 files changed, 440 insertions(+), 1 deletion(-)
>  create mode 100644 tools/virtiofsd/tpool.c
>  create mode 100644 tools/virtiofsd/tpool.h
>=20
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 3b720c5d4a..c67c2e0e7a 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -20,6 +20,7 @@
>  #include "fuse_misc.h"
>  #include "fuse_opt.h"
>  #include "fuse_virtio.h"
> +#include "tpool.h"
> =20
>  #include <sys/eventfd.h>
>  #include <sys/socket.h>
> @@ -612,6 +613,60 @@ out:
>      free(req);
>  }
> =20
> +/*
> + * If the request is a locking request, use a custom locking thread pool.
> + */
> +static bool use_lock_tpool(gpointer data, gpointer user_data)
> +{
> +    struct fv_QueueInfo *qi =3D user_data;
> +    struct fuse_session *se =3D qi->virtio_dev->se;
> +    FVRequest *req =3D data;
> +    VuVirtqElement *elem =3D &req->elem;
> +    struct fuse_buf fbuf =3D {};
> +    struct fuse_in_header *inhp;
> +    struct fuse_lk_in *lkinp;
> +    size_t lk_req_len;
> +    /* The 'out' part of the elem is from qemu */
> +    unsigned int out_num =3D elem->out_num;
> +    struct iovec *out_sg =3D elem->out_sg;
> +    size_t out_len =3D iov_size(out_sg, out_num);
> +    bool use_custom_tpool =3D false;
> +
> +    /*
> +     * If notifications are not enabled, no point in using cusotm lock
> +     * thread pool.
> +     */
> +    if (!se->notify_enabled) {
> +        return false;
> +    }
> +
> +    assert(se->bufsize > sizeof(struct fuse_in_header));
> +    lk_req_len =3D sizeof(struct fuse_in_header) + sizeof(struct fuse_lk=
_in);
> +
> +    if (out_len < lk_req_len) {
> +        return false;
> +    }
> +
> +    fbuf.mem =3D g_malloc(se->bufsize);
> +    copy_from_iov(&fbuf, out_num, out_sg, lk_req_len);

This looks inefficient: for every FUSE request we now malloc se->bufsize
and then copy lk_req_len bytes, only to free the memory again.

Is it possible to keep lk_req_len bytes on the stack instead?

--Z+FomQ254OgZIFhd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbFacACgkQnKSrs4Gr
c8gBBgf/SjkAY3cbcX+VAOrCSPviGcgx7hxVc6MFQDC3AqygPX/X/MAHncPoXxYq
ug/wH6P/4ls/Fzf06KX0EwaWKlTr9+HdGA1nYbGXmxEJ5BsYhPcj/ipGuiGDEcap
BKVxyD/Qtd1sCaqYR0P3AGua22wYIhrD3O9RUINrDoL9MdWB5aIhThnabQ2/6NFO
S6UL3EaknNQAT8mpdgTcnWPVqrCcNWHCjdfxPO8QL/6Be5LAYJzLKWJkX6AIEnv1
JEM/T3jT2GijYHPBBMLl3qV3CCARdOBkM+OFf7xWr5YlD003n5rSUovuTRV7mcBf
LrhCsPN3vd5wpuz949rAlc5zH7x8qg==
=2V8P
-----END PGP SIGNATURE-----

--Z+FomQ254OgZIFhd--

