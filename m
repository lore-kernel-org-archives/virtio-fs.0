Date: Thu, 11 Feb 2021 12:37:38 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211123738.GK247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-11-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Z9t8O/5YJLB6LEUl"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-11-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 10/24] DAX: virtiofsd: Add setup/remove
 mappings fuse commands
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


--Z9t8O/5YJLB6LEUl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 09, 2021 at 07:02:10PM +0000, Dr. David Alan Gilbert (git) wrote:
> +static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
> +                             struct fuse_mbuf_iter *iter)
> +{
> +    struct fuse_removemapping_in *arg;
> +    struct fuse_removemapping_one *one;
> +
> +    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> +    if (!arg || arg->count <= 0) {

arg->count is unsigned so < is tautologous.

> +        fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
> +        fuse_reply_err(req, EINVAL);
> +        return;
> +    }
> +
> +    one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));

arg->count * sizeof(*one) is an integer overflow on 32-bit hosts. I
think we should be more defensive here since this input comes from the
guest.

--Z9t8O/5YJLB6LEUl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlJRIACgkQnKSrs4Gr
c8i8awf/RhrbE9cnGzWrshMc17CgNSicST+cxDf3GUa1GdIdf+/fuxm0hfXfN1D5
zLUlrCUyTMw15HF/mWfEiT/oGt9PdOcj5S+51KCyLDEthQOVuxKomnPhR+1kvCs7
lSqQw1Z1SiIaeb7sQirS5mpPr1jnPSkjgrbvKrzVAwQ6ZgxGT3sCJME/D/0migTA
zxy0vzbyxp3P8sGFq2zvPb/x96KC9TTOc6koqnctXE5bQuFmlK630zEBgyFUr47b
1bG+JwV04luqE8m8p6vwyHOXG5muidz4hvh4SWWjJuqK1dOOEvGD0ElaTU5vRcuV
Q/B9WBCSdjQA2bZrO8YewZLj2Pi6NQ==
=ndWR
-----END PGP SIGNATURE-----

--Z9t8O/5YJLB6LEUl--

