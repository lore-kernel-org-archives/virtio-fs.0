Date: Thu, 11 Feb 2021 09:59:36 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211095936.GB247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 01/24] DAX: vhost-user: Rework slave return
	values
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 09, 2021 at 07:02:01PM +0000, Dr. David Alan Gilbert (git) wrote:
> +static uint64_t vhost_user_slave_handle_vring_host_notifier(
> +                struct vhost_dev *dev,
> +               VhostUserVringArea *area,
> +               int fd)

Indentation looks off. Only worth changing if you respin.

> @@ -1398,7 +1399,8 @@ static void slave_read(void *opaque)
>      struct vhost_user *u = dev->opaque;
>      VhostUserHeader hdr = { 0, };
>      VhostUserPayload payload = { 0, };
> -    int size, ret = 0;
> +    int size;
> +    uint64_t ret = 0;
>      struct iovec iov;
>      struct msghdr msgh;
>      int fd[VHOST_USER_SLAVE_MAX_FDS];
> @@ -1472,7 +1474,7 @@ static void slave_read(void *opaque)
>          break;
>      default:
>          error_report("Received unexpected msg type: %d.", hdr.request);
> -        ret = -EINVAL;
> +        ret = (uint64_t)-EINVAL;

The !!ret was removed below so it would have previously been true (1).
Now it has changed value.

If there is no specific reason to change the value, please keep it true
(1) just in case a vhost-user device backend depends on that value.

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlAAgACgkQnKSrs4Gr
c8j1Kgf/fZt238LWQCca4Gpguk6XJFxiYj3jOx2sPqTTORynV35/etPqJfQrFOE6
diwJ/x4F2XmowMmraAX8TQ+nTer6sRxE6CWuJfv3j/I9XIlB9g4nQY+PH8SU/DFy
v1X2RjcWwbTWHC/xMF3abyP8kjBAuqLJ94nLf9ACPVfl2m21rLditeiZ6qPkqiOD
Idpn3i1uO+EGLsZhbLaAYH68O7gberHE7dy8VxWEiw9EteHYybJNOX3uxPSd63M/
LEgJOmq3Ykr1UxfjQx8jHKVc6wQmYtq2XcwcM6hyEyOUKLgrLBAaLRu6T9M6ud1h
nMALP8DtZI/jtq/8Fluy2fm0iAFVsQ==
=+Zqx
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--

