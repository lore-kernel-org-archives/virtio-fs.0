Date: Thu, 11 Feb 2021 14:17:34 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211141734.GQ247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-17-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uRjmd8ppyyws0Tml"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-17-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 16/24] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
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


--uRjmd8ppyyws0Tml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:16PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Define a new slave command 'VHOST_USER_SLAVE_FS_IO' for a
> client to ask qemu to perform a read/write from an fd directly
> to GPA.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/interop/vhost-user.rst               | 11 +++
>  hw/virtio/trace-events                    |  6 ++
>  hw/virtio/vhost-user-fs.c                 | 84 +++++++++++++++++++++++
>  hw/virtio/vhost-user.c                    |  4 ++
>  include/hw/virtio/vhost-user-fs.h         |  2 +
>  subprojects/libvhost-user/libvhost-user.h |  1 +
>  6 files changed, 108 insertions(+)
>=20
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 1deedd3407..821712f4a2 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1452,6 +1452,17 @@ Slave message types
>    multiple chunks can be unmapped in one command.
>    A reply is generated indicating whether unmapping succeeded.
> =20
> +``VHOST_USER_SLAVE_FS_IO``
> +  :id: 9
> +  :equivalent ioctl: N/A
> +  :slave payload: fd + n * (offset + address + len)

Please clarify the payload representation. This is not enough for
someone to implement the spec.

> +  :master payload: N/A
> +
> +  Requests that the QEMU performs IO directly from an fd to guest memory

To avoid naming a particular VMM:

s/the QEMU performs IO/IO be performed/

> +  on behalf of the daemon; this is normally for a case where a memory re=
gion
> +  isn't visible to the daemon. slave payload has flags which determine
> +  the direction of IO operation.

Please document the payload flags in the spec.

> +
>  .. _reply_ack:
> =20
>  VHOST_USER_PROTOCOL_F_REPLY_ACK
> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> index c62727f879..20557a078e 100644
> --- a/hw/virtio/trace-events
> +++ b/hw/virtio/trace-events
> @@ -53,6 +53,12 @@ vhost_vdpa_get_features(void *dev, uint64_t features) =
"dev: %p features: 0x%"PRI
>  vhost_vdpa_set_owner(void *dev) "dev: %p"
>  vhost_vdpa_vq_get_addr(void *dev, void *vq, uint64_t desc_user_addr, uin=
t64_t avail_user_addr, uint64_t used_user_addr) "dev: %p vq: %p desc_user_a=
ddr: 0x%"PRIx64" avail_user_addr: 0x%"PRIx64" used_user_addr: 0x%"PRIx64
> =20
> +# vhost-user-fs.c
> +
> +vhost_user_fs_slave_io_loop(const char *name, uint64_t owr, int is_ram, =
int is_romd, size_t size) "region %s with internal offset 0x%"PRIx64 " ram=
=3D%d romd=3D%d mrs.size=3D%zd"
> +vhost_user_fs_slave_io_loop_res(ssize_t transferred) "%zd"
> +vhost_user_fs_slave_io_exit(int res, size_t done) "res: %d done: %zd"
> +
>  # virtio.c
>  virtqueue_alloc_element(void *elem, size_t sz, unsigned in_num, unsigned=
 out_num) "elem %p size %zd in_num %u out_num %u"
>  virtqueue_fill(void *vq, const void *elem, unsigned int len, unsigned in=
t idx) "vq %p elem %p len %u idx %u"
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 5f2fca4d82..357bc1d04e 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -23,6 +23,8 @@
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
> +#include "exec/address-spaces.h"
> +#include "trace.h"
> =20
>  /*
>   * The powerpc kernel code expects the memory to be accessible during
> @@ -155,6 +157,88 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev =
*dev,
>      return (uint64_t)res;
>  }
> =20
> +uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveM=
sg *sm,
> +                                int fd)
> +{
> +    VHostUserFS *fs =3D VHOST_USER_FS(dev->vdev);
> +    if (!fs) {
> +        /* Shouldn't happen - but seen it in error paths */
> +        error_report("Bad fs ptr");
> +        return (uint64_t)-1;
> +    }

Same pointer casting issue as with map/unmap.

> +
> +    unsigned int i;
> +    int res =3D 0;
> +    size_t done =3D 0;
> +
> +    if (fd < 0) {
> +        error_report("Bad fd for map");
> +        return (uint64_t)-1;
> +    }
> +
> +    for (i =3D 0; i < VHOST_USER_FS_SLAVE_ENTRIES && !res; i++) {
> +        if (sm->len[i] =3D=3D 0) {
> +            continue;
> +        }
> +
> +        size_t len =3D sm->len[i];
> +        hwaddr gpa =3D sm->c_offset[i];
> +
> +        while (len && !res) {
> +            MemoryRegionSection mrs =3D memory_region_find(get_system_me=
mory(),
> +                                                         gpa, len);
> +            size_t mrs_size =3D (size_t)int128_get64(mrs.size);

If there is a vIOMMU then the vhost-user device backend should be
restricted to just areas of guest RAM that are mapped. I think this can
be achieved by using the vhost-user-fs device's address space instead of
get_system_memory(). For example, virtio_pci_get_dma_as().

> +
> +            if (!mrs_size) {
> +                error_report("No guest region found for 0x%" HWADDR_PRIx=
, gpa);
> +                res =3D -EFAULT;
> +                break;
> +            }
> +
> +            trace_vhost_user_fs_slave_io_loop(mrs.mr->name,
> +                                          (uint64_t)mrs.offset_within_re=
gion,
> +                                          memory_region_is_ram(mrs.mr),
> +                                          memory_region_is_romd(mrs.mr),
> +                                          (size_t)mrs_size);
> +
> +            void *hostptr =3D qemu_map_ram_ptr(mrs.mr->ram_block,
> +                                             mrs.offset_within_region);
> +            ssize_t transferred;
> +            if (sm->flags[i] & VHOST_USER_FS_FLAG_MAP_R) {

The flag name is specific to map requests but it's shared with the IO
request. Perhaps rename the flags?

> +                /* Read from file into RAM */
> +                if (mrs.mr->readonly) {
> +                    res =3D -EFAULT;
> +                    break;
> +                }
> +                transferred =3D pread(fd, hostptr, mrs_size, sm->fd_offs=
et[i]);
> +            } else {
> +                /* Write into file from RAM */
> +                assert((sm->flags[i] & VHOST_USER_FS_FLAG_MAP_W));

The vhost-user device backend must not be able to crash the VMM. Please
use an if statement and fail the request if the flags are invalid
instead of assert().

> +                transferred =3D pwrite(fd, hostptr, mrs_size, sm->fd_off=
set[i]);
> +            }
> +            trace_vhost_user_fs_slave_io_loop_res(transferred);
> +            if (transferred < 0) {
> +                res =3D -errno;
> +                break;
> +            }
> +            if (!transferred) {
> +                /* EOF */
> +                break;
> +            }
> +
> +            done +=3D transferred;
> +            len -=3D transferred;

Is gpa +=3D transferred missing so that this loop can handle crossing
MemoryRegion boundaries?

sm->fd_offset[i] also needs to be put into a local variable and
incremented by transferred each time around the loop.

--uRjmd8ppyyws0Tml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlPH4ACgkQnKSrs4Gr
c8gnNgf+KhArgBSgDZy8b5OVDuCl1yfLW6woYT3n7G6vj31jxXRIhPfHhv32Xwsk
RgGUZbwbzOG3xG+HVzhfHxg8zn47598XjWdzopbT23s/nIRbN3fDnWyEbiYALc+m
hlCReXA9dVyrHqHQuyor9nKhZjqqD7tUa++lFHMZ/XlhR62wVXveYcko9ohZdz55
kHmf6KDOJh5oig96HJ/gg2dHLstPsBa5SzK8Hiz9lD59R41nFiShK+/mrhTUCUdf
nWJuTeKDOahiNUQlR/1MWKQ7Wulc3jfKcu7dtzhYVM3vuItaa1eVo3sFm7/nm8ba
1mNTCT7U/MHBu21iPgY+agDd5AeYSQ==
=6XVS
-----END PGP SIGNATURE-----

--uRjmd8ppyyws0Tml--

