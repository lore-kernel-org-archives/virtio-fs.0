Date: Fri, 6 Sep 2019 13:00:09 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906120009.GV5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-15-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OlucDFihBVSxvK/7"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-15-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 14/18] virtiofs: Add a fuse_iqueue operation
 to put() reference
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


--OlucDFihBVSxvK/7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2019 at 03:48:55PM -0400, Vivek Goyal wrote:
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 85e2dcad68c1..04e2c000d63f 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -479,6 +479,11 @@ struct fuse_iqueue_ops {
>  	 */
>  	void (*wake_pending_and_unlock)(struct fuse_iqueue *fiq)
>  		__releases(fiq->waitq.lock);
> +
> +	/**
> +	 * Put a reference on fiq_priv.

I'm a bit confused about fiq->priv's role in this.  The callback takes
struct fuse_iqueue *fiq as the argument, not void *priv, so it could
theoretically do more than just release priv.

I think one of the following would be clearer:

 /**
  * Drop a reference to fiq->priv.
  */
 void (*put_priv)(void *priv);

Or:

 /**
  * Clean up when fuse_iqueue is destroyed.
  */
 void (*release)(struct fuse_iqueue *fiq);

In the second case fuse_conn_put() shouldn't check fiq->priv.

--OlucDFihBVSxvK/7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1ySkkACgkQnKSrs4Gr
c8ivNAf+NYLja/k2E1pzgRX+58rLDkzT6qfQX2XKwJVUqTns/MMKaTPd/OJkf+hW
4ubt3/0sb0kFtAsyffCUY7NiLFRWbanKCEZzP1RLN/ciK2l6bGJldM5TCC0AjMXi
waisC1VR9iopyR8dEIZpZZykVQEjY2CF2UvUJwzCBph382sQM25+a6OpUQ8N2FSI
7/7VMBVILOpdeBDum2QijFCXREuqvk0Si2Kg47nTq+muuOCD/mrGg7byV/pWPvyY
2l3YzL/W0S03phxm8SlNegD0jQ9nr8po2bcY1coriYMz6WSqxDbBwmbb9Izr3aXD
phrdP6+MgQk6AvUlXsmFd/yzwtYC4Q==
=lftV
-----END PGP SIGNATURE-----

--OlucDFihBVSxvK/7--

