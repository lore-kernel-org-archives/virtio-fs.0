Date: Thu, 21 Nov 2019 16:00:45 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191121160045.GD445244@stefanha-x1.localdomain>
References: <20191115205705.2046-1-vgoyal@redhat.com>
	<20191115205705.2046-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20191115205705.2046-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofs: Add an index to keep track of
 first request queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:57:03PM -0500, Vivek Goyal wrote:
> @@ -990,7 +994,7 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq =
*fsvq,
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->lock)
>  {
> -	unsigned int queue_id =3D VQ_REQUEST; /* TODO multiqueue */
> +	unsigned int queue_id;
>  	struct virtio_fs *fs;
>  	struct fuse_req *req;
>  	struct virtio_fs_vq *fsvq;

Sorry, I removed too much context in my reply.  This TODO...

> @@ -1004,6 +1008,7 @@ __releases(fiq->lock)
>  	spin_unlock(&fiq->lock);
> =20
>  	fs =3D fiq->priv;
> +	queue_id =3D fs->first_reqq_idx;

=2E..should be moved here.

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3WtK0ACgkQnKSrs4Gr
c8gQ3Af+PW0BnVxXMs0ogKUzltp1vxcPYfq4/js7a6Q7fcsgCdJFpoDIxKkfC1t0
/N8JzkRrlqCdSBJ9Y4dvTl7jE4eSK/gVTBcjPt/BM0UY4vr5uLVD4lEtBI56yman
Nz4nZfZ2llDrIBy1mJy1lih/7bzt/q+qLKwkTKytDpJ9B+cFAJNZzLkFRPni+whc
2rooMFvXYAa7r6fCV0SjtL8RHCK4G2d12GdWsR0/8bJjxCBW6ponacxps7JWn8fi
soqP8w5UNmGKAvYZmIkDLOHM7HhpdBKqInNQ4e6ZJCawPNvsKOcv3b+dqrcfgTDe
iKEo4xRR0AEwcKybfAjhs62bsVLopg==
=UlMv
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--

