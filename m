Date: Fri, 11 Sep 2020 11:22:16 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102216.GB94280@stefanha-x1.localdomain>
References: <20200909184028.262297-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20200909184028.262297-1-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/8] virtiofsd: Announce submounts to the
	guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2020 at 08:40:20PM +0200, Max Reitz wrote:
> We want to (be able to) announce the host mount structure of the shared
> directory to the guest so it can replicate that structure.  This ensures
> that whenever the combination of st_dev and st_ino is unique on the
> host, it will be unique in the guest as well.

Great, thank you for solving the long-standing inode collision problem!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bT9gACgkQnKSrs4Gr
c8hNGwgAg4Xh++jzhmM9iDbsA9LVl1TcM7KBkySTROkWPcU0j/PlOWTfwrJTkZkd
4fkxoPOQnBoNUPEsAX06Y2UOQvCRWtRZu/m/JyrIIy/UNgffTta5FjCEgyZbOcFA
qSeb1iihUSkU8AMneplFis4yosc/R849IgrXCICNjSh6HtE8GkXWyOi3qW0ZLbPF
S4y9HZCBUW30kGDk80F2Y6lyvcVggyHJuHwOJWsD+tE5jGO0iFBpL7b9V7EpQJ3o
raNBl4SxueutlbTCvG0/r9Qvy/hin+NKB4v5sclGy7laBsHMwYPIM5yTCg1zeY23
s+I2eDcPpLSd6kaPjF7/Y2Imj2gm6w==
=je+o
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--

