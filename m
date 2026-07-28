Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF63AEB29
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785261586; cv=none; b=KxXNVesC/qN4AslUMDXUouJE11l+IzRUxsgYV04saTHijHAXDH0E306KAKeDAsMqoX71VMqxD2iMbRPe68UeTEYW2KW+yggd7hlV5l6iZwIOfgukkP+TTfrqEEjnop24M20URR17LyY76IBDhugzO5q8VKU1BiTdWADMxfIR2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785261586; c=relaxed/simple;
	bh=exzXHhzIJcSQ48gl26iO7NoK+5rXEx3axQSAyfbjo44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kI+ll51NQ6kMAegXJtbsD/sL74HHUp9kSlfjvy6G2CAD0LSgPrPx1Pj0fy4MFRVDuuTVI/t6ldpQuTU6iTQ+ozrPclrwWiqnlbrl4jEASXiRFpYNAafn8pknp3Its0qUABerLhLjfE04mMnab3uyXIEiyQLi7/5Ps/kx9kHaOnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6COXi/f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6COXi/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785261584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS0EzTAQDiqM2NCjwARPepeKeyD6JcAXZzR3bdlB7Tw=;
	b=d6COXi/f38M28VM14EDKyNojeRE38OTEoGoutKw1v3EQ+aIj6ThcuAVykGoDtfBdvqlC5r
	0IY3WliIqRjofEgA7wff0gTnSF439AlCpcpwKZglfqcYRd/h3HRxNda0/1yyoHybqhCUIs
	Spjk4uXSDl2ln07tWZQNRQMIlJQlTO8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-IQMTAg7WOgKLtMfjyeIIWw-1; Tue,
 28 Jul 2026 13:59:38 -0400
X-MC-Unique: IQMTAg7WOgKLtMfjyeIIWw-1
X-Mimecast-MFC-AGG-ID: IQMTAg7WOgKLtMfjyeIIWw_1785261576
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8521019560B7;
	Tue, 28 Jul 2026 17:59:35 +0000 (UTC)
Received: from localhost (unknown [10.2.17.47])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA5A1180044F;
	Tue, 28 Jul 2026 17:59:32 +0000 (UTC)
Date: Tue, 28 Jul 2026 13:59:31 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Haixu Cui <quic_haixcui@quicinc.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Milan Zamazal <mzamazal@redhat.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alyssa Ross <hi@alyssa.is>,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
Message-ID: <20260728175931.GI371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eVHUeOInXn1sYibu"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

--eVHUeOInXn1sYibu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:10PM -0700, Connor Kite wrote:
> If memory isolation mode is active for the vhost-user device adds
> features to:
> - Gather the size required for bounce buffers and vrings in shared
>   isolation region
> - Allocate the required space in an anonymous file
> - Create a vhost-iova-tree with space to map entire isolation region
> - Map guest memory regions and shared vrings into the tree
> - Release these resources upon backend cleanup
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-user.c | 129 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 129 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index f296b63fb9..710cf966f8 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>  #include "hw/virtio/vhost-backend.h"
>  #include "hw/virtio/virtio.h"
>  #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-iova-tree.h"
>  #include "chardev/char-fe.h"
>  #include "io/channel-socket.h"
>  #include "system/kvm.h"
> @@ -25,6 +26,7 @@
>  #include "qemu/main-loop.h"
>  #include "qemu/uuid.h"
>  #include "qemu/sockets.h"
> +#include "qemu/memfd.h"
>  #include "system/runstate.h"
>  #include "system/cryptodev.h"
>  #include "migration/postcopy-ram.h"
> @@ -320,6 +322,13 @@ static VhostUserMsg m __attribute__ ((unused));
>  /* The version of the protocol we support */
>  #define VHOST_USER_VERSION    (0x1)
> =20
> +typedef struct IsolationRegion {
> +    uint64_t base_addr;
> +    uint64_t vring_base_addr;
> +    uint64_t size;
> +    int iso_fd;
> +} IsolationRegion;

The purpose of the base_addr and vring_base_addr fields is not obvious.
I suggest adjusting the types, names, and adding comments to make the
purpose clearer:

  typedef struct {
      void *mem;           /* mapped shared memory */
      size_t size;
      uint64_t vring_iova;
      int fd;              /* shared memory fd */
  } IsolationRegion;

> +
>  struct vhost_user {
>      struct vhost_dev *dev;
>      /* Shared between vhost devs of the same virtio device */
> @@ -353,6 +362,10 @@ struct vhost_user {
>       * by the backend (see @features).
>       */
>      uint64_t protocol_features;
> +
> +    /* Isolated memory data*/
> +    struct IsolationRegion iso_memory;

struct is not necessary since there is a typedef:

  IsolationRegion iso_memory;

> +    VhostIOVATree *iso_iova_tree;

The IOVA tree seems to be closely used with IsolationRegion. Maybe this
field should move into IsolationRegion?

>  };
> =20
>  struct scrub_regions {
> @@ -1109,6 +1122,121 @@ static int vhost_user_set_mem_table_postcopy(stru=
ct vhost_dev *dev,
>      return 0;
>  }
> =20
> +/* TODO: Is there any notifier cleanup required here?*/
> +static void cleanup_isolation_regions(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u =3D dev->opaque;
> +    if (u->iso_memory.base_addr) {
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +        u->iso_iova_tree =3D NULL;
> +        memset(&u->iso_memory, 0, sizeof(IsolationRegion));
> +        qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memor=
y.size,
> +                         u->iso_memory.iso_fd);
> +        u->iso_memory.base_addr =3D 0;
> +    }
> +}
> +
> +__attribute__((unused))
> +static int init_isolation_regions(struct vhost_dev *dev,
> +                                  VhostUserMsg *msg,
> +                                  int *fds, size_t *fd_num)
> +{
> +    Error *err =3D NULL;
> +    struct vhost_user *u =3D dev->opaque;
> +    uint32_t nregions =3D dev->mem->nregions;
> +    uint64_t buffer_reg_size =3D 0;
> +    DMAMap newEntry =3D {
> +        .perm =3D IOMMU_RW
> +    };
> +    g_autoptr(GArray) buffer_regions =3D
> +        g_array_new(FALSE, TRUE, sizeof(DMAMap));
> +
> +    msg->hdr.request =3D VHOST_USER_SET_MEM_TABLE;
> +
> +    /* In case of reset, clear old regions*/
> +    if (u->iso_memory.base_addr !=3D 0) {
> +        cleanup_isolation_regions(dev);
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +    }
> +
> +    /* Gather information for bounce buffers to be mapped */
> +    for (int i =3D 0; i < nregions; i++) {

nregions is uint32_t, so i should also be uint32_t to avoid
signed/unsigned comparisons.

> +        struct vhost_memory_region *dev_region =3D &dev->mem->regions[i];
> +        hwaddr size =3D ROUND_UP(dev_region->memory_size,
> +                      qemu_real_host_page_size());
> +        newEntry.translated_addr =3D dev_region->guest_phys_addr;
> +        newEntry.size =3D size - 1;
> +        buffer_reg_size +=3D size;
> +        g_array_append_val(buffer_regions, newEntry);
> +    }
> +
> +    int num;
> +    size_t desc_size;
> +    size_t avail_size;
> +    size_t driver_area_size;
> +    size_t device_area_size;
> +    size_t total_vring_size =3D 0;
> +    size_t total_mmap_size;
> +
> +    /* Get space required for all vrings */
> +    for (int j =3D 0; j < dev->nvqs; j++) {
> +        num =3D virtio_queue_get_num(dev->vdev, dev->vq_index + j);
> +        desc_size =3D sizeof(vring_desc_t) * num;
> +        avail_size =3D offsetof(vring_avail_t, ring[num]) +
> +                        sizeof(uint16_t);
> +        driver_area_size =3D ROUND_UP(desc_size + avail_size,
> +                            qemu_real_host_page_size());
> +        device_area_size =3D ROUND_UP(offsetof(vring_used_t, ring[num]) +
> +                                    sizeof(uint16_t),
> +                                    qemu_real_host_page_size());
> +        total_vring_size +=3D driver_area_size + device_area_size;

Please avoid duplicating the memory layout calculations. When packed
vring support is added to vhost-shadow-virtqueue.c this will become more
complex and it should be done in a single place. vhost-shadow-virtque.c
should expose an API for the size calculation.

> +    }
> +
> +    total_mmap_size =3D buffer_reg_size + total_vring_size;
> +
> +    /* Allocate and map an anonymous file to hold the isolation region */
> +    u->iso_memory.base_addr =3D (uint64_t) qemu_memfd_alloc("iso_r",

Please make the name unique (e.g. using dev->vdev->name).

> +                              total_mmap_size,
> +                              F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                              &u->iso_memory.iso_fd, &err);
> +    u->iso_memory.size =3D total_mmap_size;
> +
> +    if (err) {
> +        error_report_err(err);
> +        cleanup_isolation_regions(dev);
> +        return -1;
> +    }
> +
> +    uint64_t last_addr =3D int128_get64(int128_add(u->iso_memory.base_ad=
dr,
> +                                                 total_mmap_size - 1));
> +
> +    /*
> +     * Instantiates iova tree sized to map bounce buffers and vrings to =
the
> +     * isolation region in host va.
> +     */
> +    u->iso_iova_tree =3D vhost_iova_tree_new(u->iso_memory.base_addr, la=
st_addr);

Is it possible to use 0 as the IOVA base address so that QEMU's
addresses aren't leaked to the vhost-user back-end? It's good security
practice not to reveal memory addresses to the outside world because
that information can be used to defeat address space randomization or
infer memory addresses of other data structures.

> +
> +    assert(&u->iso_memory.iso_fd >=3D 0);

The dereference operator should not be used here, it's the iso_fd value
that is being tested.

> +    DMAMap *map;
> +    DMAMap vring_map =3D {
> +        .perm =3D IOMMU_RW,
> +        .size =3D total_vring_size - 1,
> +        /*vrings are allocated on tree first, so will be assigned base a=
ddr*/
> +        .translated_addr =3D u->iso_memory.base_addr

Why is this field assigned here, I think this field is used as the
output of vhost_iova_tree_map_alloc() rather than an input (e.g. see
vhost_vdpa_svq_map_rings())?

> +    };
> +
> +    vhost_iova_tree_map_alloc(u->iso_iova_tree, &vring_map,
> +                              vring_map.translated_addr);
> +    u->iso_memory.vring_base_addr =3D vring_map.iova;
> +    for (int i =3D 0; i < buffer_regions->len; i++) {
> +        map =3D &g_array_index(buffer_regions, DMAMap, i);
> +        vhost_iova_tree_map_alloc_gpa(u->iso_iova_tree, map,
> +                                      map->translated_addr);
> +    }
> +
> +    return 0;
> +}
> +
>  static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                      struct vhost_memory *mem)
>  {
> @@ -2681,6 +2809,7 @@ static int vhost_user_backend_cleanup(struct vhost_=
dev *dev)
>      g_free(u->region_rb_offset);
>      u->region_rb_offset =3D NULL;
>      u->region_rb_len =3D 0;
> +    cleanup_isolation_regions(dev);
>      g_free(u);
>      dev->opaque =3D 0;
> =20
>=20
> --=20
> 2.43.0
>=20

--eVHUeOInXn1sYibu
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpo7gMACgkQnKSrs4Gr
c8jNVQf+Poa/X1HyBYzQTgFsy72tIiN0Bwr8wmcum0Vf38D+2M7XV9+BOvmTqrpa
WcsBmzrObSUb2USMP4TfKc5uojTEmmt1lttMeHBjMBjvX1QzmFCyOBUK5FMetHd4
3Fnvqrr1dcIMEGgsN+gaCqDXJp0SV6suYjsjilYtitJB+4r3vqqHvh4TqrM6Zurl
zSMxCsUAqr/7ZueoHe0FdJPL9j3XIsFZztJUyl3+5FpWaejjr1N/tIf2uLX35B3a
s9z5wjDMRAbbhRlQUw1lzl1ss2JA6AIe6otJXMI9+pJ17n3lH9Zrrz/1SE8vwknd
SrPehXGEg8u4T6TpdOAxxACtD65EPQ==
=VyXq
-----END PGP SIGNATURE-----

--eVHUeOInXn1sYibu--

