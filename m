Date: Fri, 6 Sep 2019 13:06:57 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906120657.GZ5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-19-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H7BIH7T1fRJ3RGOi"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-19-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 18/18] virtiofs: Remove TODO item from
 virtio_fs_free_devs()
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


--H7BIH7T1fRJ3RGOi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:59PM -0400, Vivek Goyal wrote:
> virtio_fs_free_devs() is now called from ->kill_sb(). By this time
> all device queues have been quiesced. I am assuming that while
> ->kill_sb() is in progress, another mount instance will wait for
> it to finish (sb->s_umount mutex provides mutual exclusion).
>=20
> W.r.t ->remove path, we should be fine as we are not touching vdev
> or virtqueues. And we have reference on virtio_fs object, so we know
> rest of the data structures are valid.
>=20
> So I can't see the need of any additional locking yet.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--H7BIH7T1fRJ3RGOi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yS+EACgkQnKSrs4Gr
c8hs9gf+K5gZQL97pXObXjA7p0E5N+4Mu7Z87yZAklDhpHu9q0fe3y4R1Mgfbav4
2LIQdjT1jkJl0MxWr5p90E65k9EIXHqDWalOtCobxdFYDbw9IOKOtm6cbp6qbQQX
iURNmLJIf7q4+rIu5ekeRtb8/DmshZJ1zWdbYvegrvMcaRIP+PT2NcBiccFSKX24
yZ0VlxNOfXZIvXSirKuKn29sKtaLlqbmwtsLGIctcryosKZAS6TP7SJ0iUIh1q83
v3jAjTJE+YIybDSFbuFE0bkKHNm2zKrZLKoUL+tI4GC6l0FoE1zk5yJPU+qNKTr+
nx5oaJ/l0rx/cb7cpVXU9vB5xXNlSA==
=mSQ0
-----END PGP SIGNATURE-----

--H7BIH7T1fRJ3RGOi--

