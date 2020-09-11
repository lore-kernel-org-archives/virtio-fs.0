Date: Fri, 11 Sep 2020 11:32:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911103259.GI94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-8-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-8-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 7/9] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net


--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:46:01PM +0200, Max Reitz wrote:
> @@ -176,13 +177,22 @@ static ssize_t fuse_conn_congestion_threshold_write=
(struct file *file,
> =20
>  	spin_lock(&fc->bg_lock);
>  	fc->congestion_threshold =3D val;
> -	if (fc->sb) {
> +
> +	/*
> +	 * Get any fuse_mount belonging to this fuse_conn; s_bdi is
> +	 * shared between all of them
> +	 */
> +	if (!list_empty(&fc->mounts))
> +		first_fm =3D list_first_entry(&fc->mounts, struct fuse_mount,
> +					    fc_entry);
=2E..
> @@ -263,14 +273,20 @@ static struct dentry *fuse_ctl_add_dentry(struct de=
ntry *parent,
>  int fuse_ctl_add_conn(struct fuse_conn *fc)
>  {
>  	struct dentry *parent;
> +	struct fuse_mount *first_fm;
>  	char name[32];
> =20
>  	if (!fuse_control_sb)
>  		return 0;
> =20
> +	if (list_empty(&fc->mounts))
> +		return 0;
> +
> +	first_fm =3D list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
> +	sprintf(name, "%u", first_fm->dev);

How does locking work for struct fuse_mount? Are there any locking rules
that can be documented?

Stefan

--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUlsACgkQnKSrs4Gr
c8iawAf+LTrcj5bAe3VWp8yEarEWBuGVWAfq5m2VOm4sWKW1VnKXVZOoDYByNVrW
f68RCrXWSxSuubKKQnCgDjaaK62K7DNWMCMNq6tNFBQq6mqz1wsB9um7v0JpUPWH
e4Zq7UjekpavdX5tk10v9vW+2FrqUaJlBqXaacQtXVimsOhjAd7cnX1ukTNaarrx
znYFgxVFFjmeqJIknR5adGEUY5S/RMR6oTPvtPyx61+yDPByfLI61P0tTxGoBksX
BzE3O1GnO154sNU8a1z1Fpsq0nlnlWAnEa8J9NNPpfTd6nXoAXUasEBJTuM8C4Fi
wDCzip0v1T0d8tUnd/Op/k6u/UHkAw==
=bi90
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--

