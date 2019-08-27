Date: Tue, 27 Aug 2019 10:39:43 +0200
From: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20190827103943.4c6c9342.cohuck@redhat.com>
In-Reply-To: <20190821175720.25901-6-vgoyal@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 05/19] virtio: Implement get_shm_region for
 MMIO transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>, linux-fsdevel@vger.kernel.org

On Wed, 21 Aug 2019 13:57:06 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> 
> On MMIO a new set of registers is defined for finding SHM
> regions.  Add their definitions and use them to find the region.
> 
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> ---
>  drivers/virtio/virtio_mmio.c     | 32 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_mmio.h | 11 +++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index e09edb5c5e06..5c07985c8cb8 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -500,6 +500,37 @@ static const char *vm_bus_name(struct virtio_device *vdev)
>  	return vm_dev->pdev->name;
>  }
>  
> +static bool vm_get_shm_region(struct virtio_device *vdev,
> +			      struct virtio_shm_region *region, u8 id)
> +{
> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> +	u64 len, addr;
> +
> +	/* Select the region we're interested in */
> +	writel(id, vm_dev->base + VIRTIO_MMIO_SHM_SEL);
> +
> +	/* Read the region size */
> +	len = (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_LOW);
> +	len |= (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_HIGH) << 32;
> +
> +	region->len = len;
> +
> +	/* Check if region length is -1. If that's the case, the shared memory
> +	 * region does not exist and there is no need to proceed further.
> +	 */
> +	if (len == ~(u64)0) {
> +		return false;
> +	}

I think the curly braces should be dropped here.

> +
> +	/* Read the region base address */
> +	addr = (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_BASE_LOW);
> +	addr |= (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_BASE_HIGH) << 32;
> +
> +	region->addr = addr;
> +
> +	return true;
> +}
> +
>  static const struct virtio_config_ops virtio_mmio_config_ops = {
>  	.get		= vm_get,
>  	.set		= vm_set,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

