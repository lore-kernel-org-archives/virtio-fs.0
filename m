Date: Fri, 6 Sep 2019 13:05:34 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906120534.GX5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-17-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZcaUvQ23gCOmDTXi"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-17-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 16/18] virtiofs: Use virtio_fs_mutex for
 races w.r.t ->remove and mount path
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


--ZcaUvQ23gCOmDTXi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:57PM -0400, Vivek Goyal wrote:
> It is possible that a mount is in progress and device is being removed at
> the same time. Use virtio_fs_mutex to avoid races.
>=20
> This also takes care of bunch of races and removes some TODO items.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)

Let's move to a per-device mutex in the future.  That way a single
device that fails to drain/complete requests will not hang all other
virtio-fs instances.  This is fine for now.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ZcaUvQ23gCOmDTXi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yS44ACgkQnKSrs4Gr
c8gUCQf+Lirs+hHg5s88TZfhFQDIDlsjp7llI3ghi4VGGjOuWrHpg5U7YPVCoG+A
+0eiFCQiNg4fqbw/TLcaT8YknKoReHjLZb8waWsV+NWa4EVPLLcQHM4NPVMQpHXg
/CNlyVrgI608sj4hndY5xrbKsnmJdSUBedMLU7nNpnl2dId2yIHYMzHrwsce+Fth
a0bRjYBP1KZqXLaiTi+D7ytBAdRcIyacS+pJ8eeOOk+wOgWaoeQx8oZUfy6/IXyq
hZ+zZpC6c7xcxaNJqgvs+eBG3oQBFJHWCqRtFJad+TSEPgSNOiRU/fcVTAR1Anmj
czpMpNPM8lGfcpjr4tW456SPBRyiVw==
=nWjp
-----END PGP SIGNATURE-----

--ZcaUvQ23gCOmDTXi--

