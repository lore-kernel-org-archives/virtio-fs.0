Date: Thu, 11 Feb 2021 10:25:55 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211102555.GG247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-7-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-7-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 06/24] DAX: virtio-fs: Add cache BAR
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


--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:06PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> @@ -46,6 +51,26 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *=
vpci_dev, Error **errp)
>      }
> =20
>      qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> +    cachesize =3D dev->vdev.conf.cache_size;
> +
> +    /*
> +     * The bar starts with the data/DAX cache
> +     * Others will be added later.
> +     */
> +    memory_region_init(&dev->cachebar, OBJECT(vpci_dev),
> +                       "vhost-fs-pci-cachebar", cachesize);

s/vhost-fs/vhost-user-fs/ for consistency. Only worth changing if you
respin.

> +    if (cachesize) {
> +        memory_region_add_subregion(&dev->cachebar, 0, &dev->vdev.cache);
> +        virtio_pci_add_shm_cap(vpci_dev, VIRTIO_FS_PCI_CACHE_BAR, 0, cac=
hesize,
> +                               VIRTIO_FS_SHMCAP_ID_CACHE);
> +    }
> +
> +    /* After 'realized' so the memory region exists */
> +    pci_register_bar(&vpci_dev->pci_dev, VIRTIO_FS_PCI_CACHE_BAR,
> +                     PCI_BASE_ADDRESS_SPACE_MEMORY |
> +                     PCI_BASE_ADDRESS_MEM_PREFETCH |
> +                     PCI_BASE_ADDRESS_MEM_TYPE_64,
> +                     &dev->cachebar);

Please include a comment explainig why it's okay to use BAR 2, which is
already used for the virtio-pci modern io bar (off by default):

    /*
     * virtio pci bar layout used by default.
     * subclasses can re-arrange things if needed.
     *
     *   region 0   --  virtio legacy io bar
     *   region 1   --  msi-x bar
     *   region 2   --  virtio modern io bar (off by default)
     *   region 4+5 --  virtio modern memory (64bit) bar
     *
     */

I guess the idea is that the io bar is available since it's off by
default. What happens if the io bar is enabled?

Should this bar registration should be conditional (only when cache size
is greater than 0)?

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlBjMACgkQnKSrs4Gr
c8jgpggAoNEPtR4HQ7BVPbSA4ugAaffqqeoLpyqr7Kf864GsSdgEZC7+SlSZjfxl
vme32YgLleKLA4f0S72KtPwbdrJepO6tWAhdmzCK40NWDah+IpyM1I5rsSqDpB8y
D2UgNh5px6RiCEiitxkAqwSLydIPEkvlH94SJUJ9wKqNiDi9DjI+81+CCMZ4FdDf
XpcBpUU7HYvnu5BScBwwcb94dU2Dog+VcQ9q3I5FAdg2u91oW2QK14apT8xjuyo8
0ZlHZuqcFV9jvr6pexc4XDBY8vdLa8UecG650rShNDIHC7PoZCkx1lif3yUjGE/R
gbEG5u/6cWXrfjW7mVsuTfRww4DbqQ==
=2swU
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--

