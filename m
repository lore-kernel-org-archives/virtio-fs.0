Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93D63A380C
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897650; cv=none; b=uLf4QMtUNRqQ0OABN2Grf+ZdTl0KutfOVj/+WJedkhZAxWctYanKVxiMzojd/nEYT9wdsrYO1GgbNnT1UK+/TsiTN0C8jvsSxIu0qwdJ54MNkqClM10zb1PTcJEnD9HwWxWY8b1n5qkH1olW1C9Xs8O9HBGlSPqW9tsb/Qvu7H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897650; c=relaxed/simple;
	bh=ptyC6CSW5ZJwEfT1nzw5VO4PGfGwI64C+xYR6cAPtxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ceT2xXWS5jURus7cTnKnvxTli2YlR5VvsigFkn2mTcaTN9k4fQvqmP6y/q+yb3cKkYxhDXLA1MNDlLYCTByMLrptF8K5T+YSRcgXrUhmRih+wwnP8xesFMPD3QfJsWf6PCkTd0ZxGket7zUtN54oUWP3VVFMHFWCJOdjYv56phM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=FHruRpKP; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="FHruRpKP"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OCrTpH079605
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 21:53:29 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=swlNFhClk9/N7RnNUcRjVYZolczmGr+JWUwncsjWQJc=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784897609; v=1;
        b=FHruRpKPar6FJHKFO3+DoRdg3S8WXCgHCD9nEL79IcUv1GXo9jadsZ0Rv0KWayeA
         3o95OxRNT/2W7G5W9TK1Kk+O77Tyl3YiHDzaw1UEIOsk3v/3h5uBpdcxPXrtORWk
         TFEwzOIlu45QsL2FGsiGSIhzrYxZRzYizY9JyaTkOZGJLwyc4SqUPUGk8/YtkUZI
         dq6S0WIRDJKYaJX6DHMlIEFgixbQDQQTC0JAJZXOnNeWMvTjW6eAuYVnb228oTnO
         Ye/z3XhHS4y8hxQB0/LrHEr5yTUt0OorGz5Nq0gHbacHudiMcEFWDV7l2rDy9Q8a
         j4vBk99ikiYnpINSAete2g==
Message-ID: <9f5869df-0484-456e-8060-b3a9f74a388b@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 21:53:29 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Haixu Cui <quic_haixcui@quicinc.com>,
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
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
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
>   hw/virtio/vhost-user.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 129 insertions(+)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index f296b63fb9..710cf966f8 100644
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
> @@ -320,6 +322,13 @@ static VhostUserMsg m __attribute__ ((unused));
>   /* The version of the protocol we support */
>   #define VHOST_USER_VERSION    (0x1)
>   
> +typedef struct IsolationRegion {
> +    uint64_t base_addr;
> +    uint64_t vring_base_addr;
> +    uint64_t size;
> +    int iso_fd;
> +} IsolationRegion;
> +
>   struct vhost_user {
>       struct vhost_dev *dev;
>       /* Shared between vhost devs of the same virtio device */
> @@ -353,6 +362,10 @@ struct vhost_user {
>        * by the backend (see @features).
>        */
>       uint64_t protocol_features;
> +
> +    /* Isolated memory data*/
> +    struct IsolationRegion iso_memory;
> +    VhostIOVATree *iso_iova_tree;
>   };
>   
>   struct scrub_regions {
> @@ -1109,6 +1122,121 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +/* TODO: Is there any notifier cleanup required here?*/
> +static void cleanup_isolation_regions(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +    if (u->iso_memory.base_addr) {
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +        u->iso_iova_tree = NULL;
> +        memset(&u->iso_memory, 0, sizeof(IsolationRegion));
> +        qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memory.size,
> +                         u->iso_memory.iso_fd);

u->iso_memory is zeroed before they are read here.

> +        u->iso_memory.base_addr = 0;
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
> +    uint64_t buffer_reg_size = 0;
> +    DMAMap newEntry = {

This should be new_entry as per: docs/devel/style.rst

> +        .perm = IOMMU_RW
> +    };
> +    g_autoptr(GArray) buffer_regions =
> +        g_array_new(FALSE, TRUE, sizeof(DMAMap));
> +
> +    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
> +
> +    /* In case of reset, clear old regions*/
> +    if (u->iso_memory.base_addr != 0) {
> +        cleanup_isolation_regions(dev);
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +    }

The check of u->iso_memory.base_addr is redundant; 
cleanup_isolation_regions() performs that check.

cleanup_isolation_regions() also calls vhost_iova_tree_delete(), so the 
duplicate call of the function leads to use-after-free and double-free.

> +
> +    /* Gather information for bounce buffers to be mapped */
> +    for (int i = 0; i < nregions; i++) {
> +        struct vhost_memory_region *dev_region = &dev->mem->regions[i];
> +        hwaddr size = ROUND_UP(dev_region->memory_size,
> +                      qemu_real_host_page_size());
> +        newEntry.translated_addr = dev_region->guest_phys_addr;
> +        newEntry.size = size - 1;
> +        buffer_reg_size += size;
> +        g_array_append_val(buffer_regions, newEntry);
> +    }
> +
> +    int num;
> +    size_t desc_size;
> +    size_t avail_size;
> +    size_t driver_area_size;
> +    size_t device_area_size;
> +    size_t total_vring_size = 0;
> +    size_t total_mmap_size;
> +
> +    /* Get space required for all vrings */
> +    for (int j = 0; j < dev->nvqs; j++) {
> +        num = virtio_queue_get_num(dev->vdev, dev->vq_index + j);
> +        desc_size = sizeof(vring_desc_t) * num;
> +        avail_size = offsetof(vring_avail_t, ring[num]) +
> +                        sizeof(uint16_t);
> +        driver_area_size = ROUND_UP(desc_size + avail_size,
> +                            qemu_real_host_page_size());
> +        device_area_size = ROUND_UP(offsetof(vring_used_t, ring[num]) +
> +                                    sizeof(uint16_t),
> +                                    qemu_real_host_page_size());
> +        total_vring_size += driver_area_size + device_area_size;
> +    }
> +
> +    total_mmap_size = buffer_reg_size + total_vring_size;
> +
> +    /* Allocate and map an anonymous file to hold the isolation region */
> +    u->iso_memory.base_addr = (uint64_t) qemu_memfd_alloc("iso_r",
> +                              total_mmap_size,
> +                              F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                              &u->iso_memory.iso_fd, &err);
> +    u->iso_memory.size = total_mmap_size;
> +
> +    if (err) {
> +        error_report_err(err);
> +        cleanup_isolation_regions(dev);
> +        return -1;
> +    }
> +
> +    uint64_t last_addr = int128_get64(int128_add(u->iso_memory.base_addr,
> +                                                 total_mmap_size - 1));
> +
> +    /*
> +     * Instantiates iova tree sized to map bounce buffers and vrings to the
> +     * isolation region in host va.
> +     */
> +    u->iso_iova_tree = vhost_iova_tree_new(u->iso_memory.base_addr, last_addr);
> +
> +    assert(&u->iso_memory.iso_fd >= 0);
> +    DMAMap *map;
> +    DMAMap vring_map = {
> +        .perm = IOMMU_RW,
> +        .size = total_vring_size - 1,
> +        /*vrings are allocated on tree first, so will be assigned base addr*/
> +        .translated_addr = u->iso_memory.base_addr
> +    };
> +
> +    vhost_iova_tree_map_alloc(u->iso_iova_tree, &vring_map,
> +                              vring_map.translated_addr);
> +    u->iso_memory.vring_base_addr = vring_map.iova;
> +    for (int i = 0; i < buffer_regions->len; i++) {
> +        map = &g_array_index(buffer_regions, DMAMap, i);
> +        vhost_iova_tree_map_alloc_gpa(u->iso_iova_tree, map,
> +                                      map->translated_addr);

I wonder if it is fine to dismiss return values of 
vhost_iova_tree_map_alloc() and vhost_iova_tree_map_alloc_gpa().

Regards,
Akihiko Odaki

> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -2681,6 +2809,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
>       g_free(u->region_rb_offset);
>       u->region_rb_offset = NULL;
>       u->region_rb_len = 0;
> +    cleanup_isolation_regions(dev);
>       g_free(u);
>       dev->opaque = 0;
>   
> 

