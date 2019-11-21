Date: Thu, 21 Nov 2019 16:00:01 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191121160001.GC445244@stefanha-x1.localdomain>
References: <20191115205705.2046-1-vgoyal@redhat.com>
	<20191115205705.2046-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
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


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:57:03PM -0500, Vivek Goyal wrote:
> @@ -1004,6 +1008,7 @@ __releases(fiq->lock)
>  	spin_unlock(&fiq->lock);
> =20
>  	fs =3D fiq->priv;
> +	queue_id =3D fs->first_reqq_idx;

The TODO should be moved here.

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3WtIEACgkQnKSrs4Gr
c8gp1wf9FsjNknItwwiYqgaMkCFsD/lJY+7ZWvz25GCPp4aHChGQMvg/GBxEXbUs
d2n5sxD4UcV/wmUt3amPMondoXmfLu//QOg0X5+ftyWLbVK7Tq0rO+hPkysOeP+6
2svIACl5UtYuzU3SxRS5nY3CGZ3/HxLKgJyLVhorSNXacI6ijRHZLnLDEqXU/90o
GCVuxTJfvf8UMQ42KSjwmCM+hyWb9HlNj/NoSZ63K8Zq6Y41N45bx+36k9J8LIlQ
UaFITc5HT6wWTHN0tVJxRQVsV5ZEBx1lauzDLxKCsD47+AJOMDhX/5mbVkndJZS/
xuPiSOtg8Is+zto/rTm+wN9K4/gEAw==
=Cosk
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--

