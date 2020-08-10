Date: Mon, 10 Aug 2020 10:50:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200810145019.GB455528@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-5-vgoyal@redhat.com>
	<20200810100327-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810100327-mutt-send-email-mst@kernel.org>
Subject: Re: [Virtio-fs] [PATCH v2 04/20] virtio: Implement get_shm_region
 for PCI transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Aug 10, 2020 at 10:05:17AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 07, 2020 at 03:55:10PM -0400, Vivek Goyal wrote:
> > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > 
> > On PCI the shm regions are found using capability entries;
> > find a region by searching for the capability.
> > 
> > Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Signed-off-by: kbuild test robot <lkp@intel.com>
> > Cc: kvm@vger.kernel.org
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 

[..]
> > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > +			      struct virtio_shm_region *region, u8 id)
> > +{
> > +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > +	struct pci_dev *pci_dev = vp_dev->pci_dev;
> > +	u8 bar;
> > +	u64 offset, len;
> > +	phys_addr_t phys_addr;
> > +	size_t bar_len;
> > +
> > +	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
> > +		return false;
> > +	}
> > +
> > +	phys_addr = pci_resource_start(pci_dev, bar);
> > +	bar_len = pci_resource_len(pci_dev, bar);
> > +
> > +	if ((offset + len) < offset) {
> > +		dev_err(&pci_dev->dev, "%s: cap offset+len overflow detected\n",
> > +			__func__);
> > +		return false;
> > +	}
> > +
> > +	if (offset + len > bar_len) {
> > +		dev_err(&pci_dev->dev, "%s: bar shorter than cap offset+len\n",
> > +			__func__);
> > +		return false;
> > +	}
> 
> Maybe move this to a common header so the checks can be reused by
> other transports? Can be a patch on top.

Will do as patch on top once these patches get merged. 

Thanks
Vivek

