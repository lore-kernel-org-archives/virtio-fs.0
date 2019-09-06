Date: Fri, 6 Sep 2019 11:52:10 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906105210.GP5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-9-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4IFtMBbmeqbTM/ox"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-9-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 08/18] virtiofs: Drain all pending requests
 during ->remove time
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--4IFtMBbmeqbTM/ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2019 at 03:48:49PM -0400, Vivek Goyal wrote:
> +static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
> +{
> +	WARN_ON(fsvq->in_flight < 0);
> +
> +	/* Wait for in flight requests to finish.*/
> +	while (1) {
> +		spin_lock(&fsvq->lock);
> +		if (!fsvq->in_flight) {
> +			spin_unlock(&fsvq->lock);
> +			break;
> +		}
> +		spin_unlock(&fsvq->lock);
> +		usleep_range(1000, 2000);
> +	}

I think all contexts that call this allow sleeping so we could avoid
usleep here.

--4IFtMBbmeqbTM/ox
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yOloACgkQnKSrs4Gr
c8gmeQgAoJQJeQAjTj+aeNGzBdb4oLsqKKM6Q+4z3dqyaIM7pOTsdgiPZ/q1DA5U
3/e2c4UFDTEg+r9xvEx5FFgBiPFrpwGU3N8mroPEUY9yueCllNsIZmS0y8n76YDb
dCAPCksGMF4o9AWlHAMnxFoao+EfbsJd1mNU/7f7hFqFQoAuCu64321mwhqtOO+V
PXUqk6wTZtWxPAzvZCO93D4DuUfrW7jzHRNyvCvgPiJLCTU43uptr1PDJKuDCxAp
Sqpb5jJevhxuwbc84hIEnKY/0ERKxjky+XWBsHHc1Yy/CWAdNCyU0tW8OuUaG5+k
FF9UbW4BK3wqyzMhWOd/4jDbTz6oyA==
=x8L/
-----END PGP SIGNATURE-----

--4IFtMBbmeqbTM/ox--

