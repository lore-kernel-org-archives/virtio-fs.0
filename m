Date: Tue, 10 Mar 2020 11:04:37 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200310110437.GI140737@stefanha-x1.localdomain>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <20200304165845.3081-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 04/20] virtio: Implement get_shm_region for
	PCI transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org


--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 11:58:29AM -0500, Vivek Goyal wrote:
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_p=
ci_modern.c
> index 7abcc50838b8..52f179411015 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -443,6 +443,111 @@ static void del_vq(struct virtio_pci_vq_info *info)
>  	vring_del_virtqueue(vq);
>  }
> =20
> +static int virtio_pci_find_shm_cap(struct pci_dev *dev,
> +                                   u8 required_id,
> +                                   u8 *bar, u64 *offset, u64 *len)
> +{
> +	int pos;
> +
> +        for (pos =3D pci_find_capability(dev, PCI_CAP_ID_VNDR);

Please fix the mixed tabs vs space indentation in this patch.

> +static bool vp_get_shm_region(struct virtio_device *vdev,
> +			      struct virtio_shm_region *region, u8 id)
> +{
> +	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> +	struct pci_dev *pci_dev =3D vp_dev->pci_dev;
> +	u8 bar;
> +	u64 offset, len;
> +	phys_addr_t phys_addr;
> +	size_t bar_len;
> +	int ret;
> +
> +	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
> +		return false;
> +	}
> +
> +	ret =3D pci_request_region(pci_dev, bar, "virtio-pci-shm");
> +	if (ret < 0) {
> +		dev_err(&pci_dev->dev, "%s: failed to request BAR\n",
> +			__func__);
> +		return false;
> +	}
> +
> +	phys_addr =3D pci_resource_start(pci_dev, bar);
> +	bar_len =3D pci_resource_len(pci_dev, bar);
> +
> +        if (offset + len > bar_len) {
> +                dev_err(&pci_dev->dev,
> +                        "%s: bar shorter than cap offset+len\n",
> +                        __func__);
> +                return false;
> +        }
> +
> +	region->len =3D len;
> +	region->addr =3D (u64) phys_addr + offset;
> +
> +	return true;
> +}

Missing pci_release_region()?

--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5ndEUACgkQnKSrs4Gr
c8jLYwf/exeUl3WphEdcCDBZB1FzUfCmswGzkwrT92YXIdpwgJZrl688mmhjXloi
GJqsnE3BX20JSmDOw3KlRiByhAEaz2HwKpdjT62Xq3CBRMLDemAymoDsGtjlanVK
fdmw17AJzX01wpcPW2ek87jGaHwygYHt4GFrE9NH+TiB7WVU0EfXmaF1fbVREkT1
VGzPZqY0xpWl3g12g9P0BCrftqa0PyLG29aHHG5NFs7kbTNaej5NcBOUjxEvk9jB
3mS+w/vUz7cdZPyj0BxxVjNN6udpyi83i4QdTzgLKilwD9x1VhvtnVVJiOdXOdvm
h4bns2UcpEqEvyaSsVzo3jlYx+OeRw==
=74o7
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--

