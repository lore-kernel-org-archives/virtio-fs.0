Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1D3D4118
	for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 07:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125081; cv=none; b=VThyfrDZYwepI0JUwdf7OtfOjuSPlGPNULlPHfWZnKBOqofavl+wnecMy6z3gfTY1wEdK/BqQKBEevKeRIECVAC3FWonxCecWB3l4GH8RifD/fRrU2QfN1kFieO3ZC4bNXT5o+lY3I1qnqyQUOgzj89IHBwnBNCg2NzF3F1lLPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125081; c=relaxed/simple;
	bh=O9phaCMNj18FnxNU2e4RVow0NQ5FdQn25/vqb7Uv7nk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAcUwPEqdrBbopMr2+NHQL5v6jpc1TQC0F11bku2isWKtN1LbSAc7P8XiywTvU2hC35EA3wL33qtbO+CcA/5iurfrpY94JnhWf1mHa7Ys7aYHp9oftC5LwrJRjIVO4vIDKeez66WoHs8VPBdA/AzPdFQf88zekOjmB0q5ok0dsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=lItwiR/j; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="lItwiR/j"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67J7amgi038287
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 19 Aug 2026 16:36:48 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=sU0gqa4C+i3Xz2UlWLl4+rqgtHs/aOVm+MzXGyzQm4g=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787125008; v=1;
        b=lItwiR/j8w2LKyyTdkM2hL+ZRowXzBrAKHKCXkPgyRn7xrlZnl0wpHJ2Rqo61o4V
         kwexDyi+RPCivTfeLuXB+xqGjtdnmC3NoHMCJDoZVCA+92SdUukKPZywAM53Rr2r
         oe29jjESDW4DMTye1/lZkKiFqUCtm0PGnz+seaJdxA366tExwTw52Ief6YJKF6Nj
         PZI6GTAXRGGAkZoUHp3TBRxqAJlMBGdBgBpFNbAu1yhLLslhnthoX2x/fvqAw9A2
         9mxQsyjx03Z9iSHW23v0Zom8z5SITXtx+sq+0XneO3cZcb0NLSDvnbuCNN7yqf7I
         zyHTljMNoKeM4XhJ/Damog==
Message-ID: <ab5f4ec8-0ef3-49df-94c1-b7145d4153d4@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 19 Aug 2026 16:36:47 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 07/13] hw/virtio/vhost-user: create isolation
 region
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
        virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        zhenwei pi <zhenwei.pi@linux.dev>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>,
        20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/08/18 14:12, Connor Kite wrote:
> If memory isolation mode is active for the vhost-user device adds
> features to:
> - Gather the size required for bounce buffers and vrings in shared
>    isolation region
> - Allocate the required space in an anonymous file
> - Create a vhost-iova-tree with space to map entire isolation region
> - Map guest memory regions and shared vrings into the tree
> - Release these resources upon backend cleanup
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 136 insertions(+)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 1c003e4d9d..7e9233e174 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>   #include "hw/virtio/vhost-backend.h"
>   #include "hw/virtio/virtio.h"
>   #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-iova-tree.h"
>   #include "chardev/char-fe.h"
>   #include "io/channel-socket.h"
>   #include "system/kvm.h"
> @@ -25,6 +26,7 @@
>   #include "qemu/main-loop.h"
>   #include "qemu/uuid.h"
>   #include "qemu/sockets.h"
> +#include "qemu/memfd.h"
>   #include "system/runstate.h"
>   #include "system/cryptodev.h"
>   #include "migration/postcopy-ram.h"
> @@ -320,6 +322,17 @@ static VhostUserMsg m __attribute__ ((unused));
>   /* The version of the protocol we support */
>   #define VHOST_USER_VERSION    (0x1)
>   
> +/* Memory region shared with back-end when memory-isolation is active */
> +typedef struct {
> +    void *shared_mem_addr; /* mapped shared memory */
> +    VhostIOVATree *tree; /* controls mapping of regions into IOVA space */
> +    void *vring_hva_addr; /* beginning of vring region in shared memory */
> +    size_t vring_region_size; /* amount of shared memory reserved for vrings */
> +    size_t size; /* size of the mapped shared memory */
> +    int fd; /* descriptor of anonymous file backing shared iso region */
> +    Int128 iso_iova_offset; /* translation from IOVA to hva of iso region */

This Int128 usage is misleading. The value derived from iso_iova_offset 
is always consumed with int128_get64(), which asserts the value fits in 
64-bit. But we actually need to enforce that the address before 
translation resides in the shared memory. So making iso_iova_offset 
Int128 is not a good way to assert the real invariant.

Furthermore, "[PATCH RFC v2 10/13] hw/virtio/vhost-user: handle data 
movement with shadow vqs" has:

     ptrdiff_t offset = u->iso_mem_ctx.iso_iova_offset;

If defined(CONFIG_INT128) && !defined(CONFIG_TCG_INTERPRETER), this will 
overflow with u->iso_mem_ctx.iso_iova_offset > PTRDIFF_MAX. Otherwise, 
Int128 will be a struct, which causes a compilation error.

uintptr_t is sufficient if the invariant is enforced in some alternative 
way. A negative offset would be represented as wraparound, and a 
positive one will never result in wraparound. Just always ensure the 
address before translation resides in the shared memory.

Regards,
Akihiko Odaki

> +} IsolationModeCtx;
> +
>   struct vhost_user {
>       struct vhost_dev *dev;
>       /* Shared between vhost devs of the same virtio device */
> @@ -353,6 +366,9 @@ struct vhost_user {
>        * by the backend (see @features).
>        */
>       uint64_t protocol_features;
> +
> +    /* Data specfic to isolated memory mode */
> +    IsolationModeCtx iso_mem_ctx;
>   };
>   
>   struct scrub_regions {
> @@ -1112,6 +1128,125 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static void cleanup_isolation_regions(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +    if (u->iso_mem_ctx.shared_mem_addr) {
> +        vhost_iova_tree_delete(u->iso_mem_ctx.tree);
> +        qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
> +                        u->iso_mem_ctx.size,
> +                        u->iso_mem_ctx.fd);
> +        memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
> +    }
> +}
> +
> +__attribute__((unused))
> +static int init_isolation_regions(struct vhost_dev *dev,
> +                                  VhostUserMsg *msg,
> +                                  int *fds, size_t *fd_num)
> +{
> +    Error *err = NULL;
> +    struct vhost_user *u = dev->opaque;
> +    uint32_t nregions = dev->mem->nregions;
> +
> +    g_autofree DMAMap *buffer_regions = g_new0(DMAMap, nregions);
> +    size_t buffer_reg_size = 0;
> +    size_t total_vring_size = 0;
> +    size_t total_mmap_size;
> +    char *reg_name;
> +    uint64_t first_IOVA_addr;
> +    uint64_t last_IOVA_addr;

Variables should be lower_case_with_underscores as per:
docs/devel/style.rst

> +    DMAMap *map;
> +    DMAMap vring_map;
> +    int r;
> +
> +    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
> +
> +    /* In case of reset, clear old regions */
> +    cleanup_isolation_regions(dev);
> +
> +    /* Gather information for bounce buffers to be mapped */
> +    for (u_int32_t i = 0; i < nregions; i++) {
> +        hwaddr size = ROUND_UP(dev->mem->regions[i].memory_size,
> +                      qemu_real_host_page_size());
> +        buffer_regions[i].size = size - 1;
> +        buffer_regions[i].perm = IOMMU_RW;
> +
> +        buffer_reg_size += size;
> +    }
> +
> +    /* Get space required for all vrings */
> +    for (int i = 0; i < dev->nvqs; i++) {
> +        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
> +        total_vring_size += vhost_svq_vring_total_size(dev->vdev, vq);
> +    }
> +
> +    total_mmap_size = buffer_reg_size + total_vring_size;
> +    u->iso_mem_ctx.size = total_mmap_size;
> +
> +    /* Allocate and map an anonymous file to hold the isolation region */
> +    reg_name = g_strconcat("iso_mem_", dev->vdev->name, NULL);
> +    u->iso_mem_ctx.shared_mem_addr = qemu_memfd_alloc(reg_name,
> +                                     total_mmap_size,
> +                                     F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                                     &u->iso_mem_ctx.fd, &err);
> +
> +    assert(u->iso_mem_ctx.fd >= 0);
> +    g_free(reg_name);
> +
> +    if (err) {
> +        error_report_err(err);
> +        cleanup_isolation_regions(dev);
> +        return -1;
> +    }
> +
> +    /* vhost-iova-tree enforces non-zero lower address */
> +    first_IOVA_addr = qemu_real_host_page_size();
> +    last_IOVA_addr = first_IOVA_addr + total_mmap_size - 1;
> +    assert(last_IOVA_addr > first_IOVA_addr);
> +
> +    /* Use 128-bit operation in case of large negative offset */
> +    u->iso_mem_ctx.iso_iova_offset =
> +        int128_sub(int128_make64((uint64_t)u->iso_mem_ctx.shared_mem_addr),
> +        int128_make64(first_IOVA_addr));
> +
> +    /*
> +     * Instantiates iova tree sized to map bounce buffers and vrings to the
> +     * isolation region in host va.
> +     */
> +    u->iso_mem_ctx.tree =
> +        vhost_iova_tree_new(first_IOVA_addr, last_IOVA_addr);
> +
> +    /* Map vrings into IOVA tree */
> +    vring_map.perm = IOMMU_RW;
> +    vring_map.size = total_vring_size - 1;
> +    r = vhost_iova_tree_map_alloc(u->iso_mem_ctx.tree, &vring_map,
> +                                  (hwaddr)u->iso_mem_ctx.shared_mem_addr);
> +
> +    if (r != IOVA_OK) {
> +        cleanup_isolation_regions(dev);
> +        return r;
> +    }
> +
> +    u->iso_mem_ctx.vring_hva_addr = (void *)int128_get64(
> +                                    int128_add(int128_make64(vring_map.iova),
> +                                               u->iso_mem_ctx.iso_iova_offset));
> +    u->iso_mem_ctx.vring_region_size = total_vring_size;
> +
> +    for (int i = 0; i < nregions; i++) {
> +        map = &buffer_regions[i];
> +        r = vhost_iova_tree_map_alloc_gpa(u->iso_mem_ctx.tree, map,
> +                                          dev->mem->regions[i].guest_phys_addr);
> +
> +        if (r != IOVA_OK) {
> +            cleanup_isolation_regions(dev);
> +            return r;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -2684,6 +2819,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
>       g_free(u->region_rb_offset);
>       u->region_rb_offset = NULL;
>       u->region_rb_len = 0;
> +    cleanup_isolation_regions(dev);
>       g_free(u);
>       dev->opaque = 0;
>   
> 

