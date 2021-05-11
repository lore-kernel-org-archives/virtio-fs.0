Date: Tue, 11 May 2021 16:37:13 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJqkqYvWAAw3hZBG@stefanha-x1.localdomain>
References: <BY5PR11MB44018CADDC7A5C04F3D32BC4EA539@BY5PR11MB4401.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EpkZhP9CHS3Tbg1c"
Content-Disposition: inline
In-Reply-To: <BY5PR11MB44018CADDC7A5C04F3D32BC4EA539@BY5PR11MB4401.namprd11.prod.outlook.com>
Subject: Re: [Virtio-fs] vhost-user reconnection and crash recovery
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>


--EpkZhP9CHS3Tbg1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 11, 2021 at 03:00:05PM +0000, Boeuf, Sebastien wrote:
> But what about the vhost-user backend initialization? Does
> QEMU go again through initializing memory table, vrings, etc...
> since it can't assume anything from the backend?

Yes, the initial protocol messages are the same after reconnection.

In QEMU's vhost-user-blk implementation there is a special code path
involving vhost_dev_get_inflight(). This fetches and restores inflight
virtqueue request state. The restore logic is called by
vhost_user_blk_connect(). Aside from that reconnect is the same as
establishing a new connection.

Stefan

--EpkZhP9CHS3Tbg1c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCapKkACgkQnKSrs4Gr
c8gNMgf+LzkxGK+rAezE6rmKw5eBWnTropxCouXYMwtLqrMhzJjjrxV5GUwiQSyG
08xsNOvph3M+HGbB+EU3YFxBMTqGdvlgcrGdp9GoO6hrEI2eKMUVFtJQGxh8WMcD
u04bc2vdYUnip8CeX7/3t8SQzEpBeJVYwrH/Pewpu8v2vktfFqGu9J7yjAQTHG/A
jl/+2C0v5E0lqq8Pw4eJBy2eMC7UncfItFIRJqB6SkML8AcKzBWRSmm/H8E2/KDT
p4rGYMHdsJqpzviuZiut2AdFqCSWr8VXjP8jgAkYSb4ZB6Bw+XyeN6Z1iXcNmOHh
m6zoZ7b8eN0loaMo9Yxn/d2mjVU8dA==
=4Jtb
-----END PGP SIGNATURE-----

--EpkZhP9CHS3Tbg1c--

