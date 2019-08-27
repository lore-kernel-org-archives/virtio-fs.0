Date: Tue, 27 Aug 2019 10:34:57 +0200
From: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20190827103457.35927d9d.cohuck@redhat.com>
In-Reply-To: <20190821175720.25901-5-vgoyal@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 04/19] virtio: Implement get_shm_region for
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
Cc: kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>, linux-fsdevel@vger.kernel.org

On Wed, 21 Aug 2019 13:57:05 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> 
> On PCI the shm regions are found using capability entries;
> find a region by searching for the capability.
> 
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: kbuild test robot <lkp@intel.com>

An s-o-b by a test robot looks a bit odd.

> ---
>  drivers/virtio/virtio_pci_modern.c | 108 +++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_pci.h    |  11 ++-
>  2 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 7abcc50838b8..1cdedd93f42a 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -443,6 +443,112 @@ static void del_vq(struct virtio_pci_vq_info *info)
>  	vring_del_virtqueue(vq);
>  }
>  
> +static int virtio_pci_find_shm_cap(struct pci_dev *dev,
> +                                   u8 required_id,
> +                                   u8 *bar, u64 *offset, u64 *len)
> +{
> +	int pos;
> +
> +        for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);

Indentation looks a bit off here.

> +             pos > 0;
> +             pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
> +		u8 type, cap_len, id;
> +                u32 tmp32;

Here as well.

> +                u64 res_offset, res_length;
> +
> +		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +                                                         cfg_type),
> +                                     &type);
> +                if (type != VIRTIO_PCI_CAP_SHARED_MEMORY_CFG)

And here.

> +                        continue;
> +
> +		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +                                                         cap_len),
> +                                     &cap_len);
> +		if (cap_len != sizeof(struct virtio_pci_cap64)) {
> +		        printk(KERN_ERR "%s: shm cap with bad size offset: %d size: %d\n",
> +                               __func__, pos, cap_len);

Probably better to use dev_warn() instead of printk.

> +                        continue;
> +                }

Indentation looks off again (might be a space vs tabs issue; maybe
check the whole patch for indentation problems?)

> +
> +		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +                                                         id),
> +                                     &id);
> +                if (id != required_id)
> +                        continue;
> +
> +                /* Type, and ID match, looks good */
> +                pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
> +                                                         bar),
> +                                     bar);
> +
> +                /* Read the lower 32bit of length and offset */
> +                pci_read_config_dword(dev, pos + offsetof(struct virtio_pci_cap, offset),
> +                                      &tmp32);
> +                res_offset = tmp32;
> +                pci_read_config_dword(dev, pos + offsetof(struct virtio_pci_cap, length),
> +                                      &tmp32);
> +                res_length = tmp32;
> +
> +                /* and now the top half */
> +                pci_read_config_dword(dev,
> +                                      pos + offsetof(struct virtio_pci_cap64,
> +                                                     offset_hi),
> +                                      &tmp32);
> +                res_offset |= ((u64)tmp32) << 32;
> +                pci_read_config_dword(dev,
> +                                      pos + offsetof(struct virtio_pci_cap64,
> +                                                     length_hi),
> +                                      &tmp32);
> +                res_length |= ((u64)tmp32) << 32;
> +
> +                *offset = res_offset;
> +                *len = res_length;
> +
> +                return pos;
> +        }
> +        return 0;
> +}
> +
> +static bool vp_get_shm_region(struct virtio_device *vdev,
> +			      struct virtio_shm_region *region, u8 id)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);

This whole function looks like it is indented incorrectly.

> +	struct pci_dev *pci_dev = vp_dev->pci_dev;
> +	u8 bar;
> +	u64 offset, len;
> +	phys_addr_t phys_addr;
> +	size_t bar_len;
> +	char *bar_name;
> +	int ret;
> +
> +	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
> +		return false;
> +	}

You can drop the curly braces.

> +
> +	ret = pci_request_region(pci_dev, bar, "virtio-pci-shm");
> +	if (ret < 0) {
> +		dev_err(&pci_dev->dev, "%s: failed to request BAR\n",
> +			__func__);
> +		return false;
> +	}
> +
> +	phys_addr = pci_resource_start(pci_dev, bar);
> +	bar_len = pci_resource_len(pci_dev, bar);
> +
> +        if (offset + len > bar_len) {
> +                dev_err(&pci_dev->dev,
> +                        "%s: bar shorter than cap offset+len\n",
> +                        __func__);
> +                return false;
> +        }
> +
> +	region->len = len;
> +	region->addr = (u64) phys_addr + offset;
> +
> +	return true;
> +}
> +
>  static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>  	.get		= NULL,
>  	.set		= NULL,

Apart from the coding style nits, the logic of the patch looks sane to
me.

(...)

As does the rest of the patch.

