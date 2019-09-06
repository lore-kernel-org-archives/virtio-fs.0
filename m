Date: Fri, 6 Sep 2019 11:45:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906104549.GL5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="L/Qt9NZ8t00Dhfad"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 04/18] virtiofs: Check connected state for
 VQ_REQUEST queue as well
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


--L/Qt9NZ8t00Dhfad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:45PM -0400, Vivek Goyal wrote:
> Right now we are checking ->connected state only for VQ_HIPRIO. Now we wa=
nt
> to make use of this method for all queues. So check it for VQ_REQUEST as
> well.
>=20
> This will be helpful if device has been removed and virtqueue is gone. In
> that case ->connected will be false and request can't be submitted anymore
> and user space will see error -ENOTCONN.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--L/Qt9NZ8t00Dhfad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yONwACgkQnKSrs4Gr
c8hiJQf/RcdMwTruxvR/8Bl1CjfN+mUt21UCtv0K/otHklhGEdna7AzGT1QFFBqi
iyQUlYckbqC72mhKLNOWT/I8JJkq3jUS+xUf2i/qzNv/4B3yVfCFazfumOIcb7P+
XriTd61VYMSaPfJRPXLvn+oxLknVB9LohRBQHZc0ljt339uGCt9YBlc38G2/XRud
PT41SRg8rwBjDyfqx3OVTzL7kgxdXaM5ZbUJo24/To3ZQdmzO/QWWDJqUCGi0kCQ
r5x6rkMUjd9gZCIUcgio7ourUi3+gfQA+sIQHU3FUH+UCyL7+nM5XM61n7t80BpH
P8ACIKgUO0IDNTm9uaTHnuUTZAUrrw==
=+Vva
-----END PGP SIGNATURE-----

--L/Qt9NZ8t00Dhfad--

