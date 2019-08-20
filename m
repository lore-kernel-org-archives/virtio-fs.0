Date: Tue, 20 Aug 2019 11:06:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190820100643.GF9855@stefanha-x1.localdomain>
References: <20190812210455.12540-1-msys.mizuma@gmail.com>
	<20190812210455.12540-4-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Content-Disposition: inline
In-Reply-To: <20190812210455.12540-4-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtio-fs: add tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2019 at 05:04:55PM -0400, Masayoshi Mizuma wrote:
> @@ -251,6 +259,11 @@ static void virtio_fs_hiprio_dispatch_work(struct wo=
rk_struct *work)
>  		notify =3D virtqueue_kick_prepare(vq);
>  		spin_unlock(&fsvq->lock);
> =20
> +		trace_virtio_fs_hiprio_request_dispatched(
> +			forget->ih.opcode, forget->ih.unique,
> +			forget->ih.nodeid, forget->ih.len,
> +			notify);
> +

It is safer to trace the request before placing it in the queue and
before releasing fsvq->lock.  I'm concerned that a fast device may
complete the request and invoke virtio_fs_hiprio_done_work() so that
kfree(req) is called before we've finished tracing it.

(We cannot rely on virtqueue_notify() because devices may poll the
virtqueue, so as soon as the request has been added to the virtqueue it
may be completed.)

> @@ -914,6 +931,10 @@ static int virtio_fs_enqueue_req(struct virtqueue *v=
q, struct fuse_req *req)
> =20
>  	spin_unlock(&fsvq->lock);
> =20
> +	trace_virtio_fs_request_dispatched(
> +		req->in.h.opcode, req->in.h.unique,
> +		req->in.h.nodeid, req->in.h.len, req->flags, notify);
> +
>  	if (notify)
>  		virtqueue_notify(vq);

Same here, we no longer control the lifetime of req so it's not safe to
access it after virtqueue_add_sgs() + spin_unlock(&fsvq->lock).

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1bxjMACgkQnKSrs4Gr
c8hSWwgAuI3+nMDrFczxg4eZjNxA+13a3+YllARvTB0AFuV8jzIO8HS5yE7KIFPj
Nne7VHMZ+78OJrXm4NguTDccRu1jSIHTk9W0mr85FekzBGdDWtyeuyWnL7YKv5ZA
1oz70NSEDtEdGmxKGSYZ/iZ9qHYfQJz803G6VKmJo9hpwREGLU4i01h4XcGg5Doi
P8fZ3iMq3LxwovqlQ825GYoZJNeyJfQIenVUU88b1HGV1K599oRp1vxqqrdFpEZ7
hZff6aus2krtfT7uBPesCNntQqD5AsQs2/aOri7yujnWAYS7nCTngTvJ/DmDUJAX
gggwJzWiAzgR5nbhRNekyKPxUIx/Yw==
=n8so
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--

