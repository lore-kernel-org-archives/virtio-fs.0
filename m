Date: Wed, 11 Mar 2020 17:34:05 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200311173405.GI281087@stefanha-x1.localdomain>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-5-vgoyal@redhat.com>
	<20200310110437.GI140737@stefanha-x1.localdomain>
	<20200310181936.GC38440@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TKDEsImF70pdVIl+"
Content-Disposition: inline
In-Reply-To: <20200310181936.GC38440@redhat.com>
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


--TKDEsImF70pdVIl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2020 at 02:19:36PM -0400, Vivek Goyal wrote:
> On Tue, Mar 10, 2020 at 11:04:37AM +0000, Stefan Hajnoczi wrote:
> > On Wed, Mar 04, 2020 at 11:58:29AM -0500, Vivek Goyal wrote:
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 7abcc50838b8..52f179411015 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -443,6 +443,111 @@ static void del_vq(struct virtio_pci_vq_info *i=
nfo)
> > >  	vring_del_virtqueue(vq);
> > >  }
> > > =20
> > > +static int virtio_pci_find_shm_cap(struct pci_dev *dev,
> > > +                                   u8 required_id,
> > > +                                   u8 *bar, u64 *offset, u64 *len)
> > > +{
> > > +	int pos;
> > > +
> > > +        for (pos =3D pci_find_capability(dev, PCI_CAP_ID_VNDR);
> >=20
> > Please fix the mixed tabs vs space indentation in this patch.
>=20
> Will do. There are plenty of these in this patch.
>=20
> >=20
> > > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > > +			      struct virtio_shm_region *region, u8 id)
> > > +{
> > > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > > +	struct pci_dev *pci_dev =3D vp_dev->pci_dev;
> > > +	u8 bar;
> > > +	u64 offset, len;
> > > +	phys_addr_t phys_addr;
> > > +	size_t bar_len;
> > > +	int ret;
> > > +
> > > +	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
> > > +		return false;
> > > +	}
> > > +
> > > +	ret =3D pci_request_region(pci_dev, bar, "virtio-pci-shm");
> > > +	if (ret < 0) {
> > > +		dev_err(&pci_dev->dev, "%s: failed to request BAR\n",
> > > +			__func__);
> > > +		return false;
> > > +	}
> > > +
> > > +	phys_addr =3D pci_resource_start(pci_dev, bar);
> > > +	bar_len =3D pci_resource_len(pci_dev, bar);
> > > +
> > > +        if (offset + len > bar_len) {
> > > +                dev_err(&pci_dev->dev,
> > > +                        "%s: bar shorter than cap offset+len\n",
> > > +                        __func__);
> > > +                return false;
> > > +        }
> > > +
> > > +	region->len =3D len;
> > > +	region->addr =3D (u64) phys_addr + offset;
> > > +
> > > +	return true;
> > > +}
> >=20
> > Missing pci_release_region()?
>=20
> Good catch. We don't have a mechanism to call pci_relese_region() and=20
> virtio-mmio device's ->get_shm_region() implementation does not even
> seem to reserve the resources.
>=20
> So how about we leave this resource reservation to the caller.
> ->get_shm_region() just returns the addr/len pair of requested resource.
>=20
> Something like this patch.
>=20
> ---
>  drivers/virtio/virtio_pci_modern.c |    8 --------
>  fs/fuse/virtio_fs.c                |   13 ++++++++++---
>  2 files changed, 10 insertions(+), 11 deletions(-)
>=20
> Index: redhat-linux/fs/fuse/virtio_fs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- redhat-linux.orig/fs/fuse/virtio_fs.c	2020-03-10 09:13:34.624565666 -=
0400
> +++ redhat-linux/fs/fuse/virtio_fs.c	2020-03-10 14:11:10.970284651 -0400
> @@ -763,11 +763,18 @@ static int virtio_fs_setup_dax(struct vi
>  	if (!have_cache) {
>  		dev_notice(&vdev->dev, "%s: No cache capability\n", __func__);
>  		return 0;
> -	} else {
> -		dev_notice(&vdev->dev, "Cache len: 0x%llx @ 0x%llx\n",
> -			   cache_reg.len, cache_reg.addr);
>  	}
> =20
> +	if (!devm_request_mem_region(&vdev->dev, cache_reg.addr, cache_reg.len,
> +				     dev_name(&vdev->dev))) {
> +		dev_warn(&vdev->dev, "could not reserve region addr=3D0x%llx"
> +			 " len=3D0x%llx\n", cache_reg.addr, cache_reg.len);
> +		return -EBUSY;
> +        }
> +
> +	dev_notice(&vdev->dev, "Cache len: 0x%llx @ 0x%llx\n", cache_reg.len,
> +		   cache_reg.addr);
> +
>  	pgmap =3D devm_kzalloc(&vdev->dev, sizeof(*pgmap), GFP_KERNEL);
>  	if (!pgmap)
>  		return -ENOMEM;
> Index: redhat-linux/drivers/virtio/virtio_pci_modern.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- redhat-linux.orig/drivers/virtio/virtio_pci_modern.c	2020-03-10 08:51=
:36.886565666 -0400
> +++ redhat-linux/drivers/virtio/virtio_pci_modern.c	2020-03-10 13:43:15.1=
68753543 -0400
> @@ -511,19 +511,11 @@ static bool vp_get_shm_region(struct vir
>  	u64 offset, len;
>  	phys_addr_t phys_addr;
>  	size_t bar_len;
> -	int ret;
> =20
>  	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
>  		return false;
>  	}
> =20
> -	ret =3D pci_request_region(pci_dev, bar, "virtio-pci-shm");
> -	if (ret < 0) {
> -		dev_err(&pci_dev->dev, "%s: failed to request BAR\n",
> -			__func__);
> -		return false;
> -	}
> -
>  	phys_addr =3D pci_resource_start(pci_dev, bar);
>  	bar_len =3D pci_resource_len(pci_dev, bar);

Do pci_resource_start()/pci_resource_len() work on a BAR where
pci_request_region() hasn't been called yet?  (I haven't checked the
code, sorry...)

Assuming yes, then my next question is whether devm_request_mem_region()
works in both the VIRTIO PCI and MMIO cases?

If yes, then this looks like a solution, though the need for
devm_request_mem_region() should be explained in the vp_get_shm_region()
doc comments so that callers remember to make that call.  Or maybe it
can be included in vp_get_shm_region().

Stefan

--TKDEsImF70pdVIl+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5pIQ0ACgkQnKSrs4Gr
c8hRcwgAllE7XHaHgyhW//Kd35rBaIMwficvtTMl5oYcfsKBVGTrjWnaAYzbseXT
s/UX6DzqH/qO3skX5n9rq5tlVwW1POLhLYSjtXB0GFeC/utVMyQKrcdlYUAYeHFF
bROTGHuMNT0b3YbZiiHbA08BWfcuTOfhtzEwUPajlf+D8LvY11d1lyDGXb2GxcRI
vIx5hpsok29/NpOn2KgYcUSTZ1f8jk7mHnMscCRjvp9o8WJVCt7nIT2tJYYRuOKE
+VCiza9iW/P8w+PrwdQj1lraakETWKPmDXQPjCz5BUyyDrqDJr7RMDY+KdPrll0l
kDFkAzr2D64PwzwaXaM3sNXecZXK4w==
=pAoo
-----END PGP SIGNATURE-----

--TKDEsImF70pdVIl+--

