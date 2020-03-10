Date: Tue, 10 Mar 2020 17:27:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20200310172603-mutt-send-email-mst@kernel.org>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-5-vgoyal@redhat.com>
	<20200310071043-mutt-send-email-mst@kernel.org>
	<20200310184720.GD38440@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200310184720.GD38440@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
Cc: kbuild test robot <lkp@intel.com>, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Tue, Mar 10, 2020 at 02:47:20PM -0400, Vivek Goyal wrote:
> On Tue, Mar 10, 2020 at 07:12:25AM -0400, Michael S. Tsirkin wrote:
> [..]
> > > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > > +			      struct virtio_shm_region *region, u8 id)
> > > +{
> > > +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > +	struct pci_dev *pci_dev = vp_dev->pci_dev;
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
> > > +	ret = pci_request_region(pci_dev, bar, "virtio-pci-shm");
> > > +	if (ret < 0) {
> > > +		dev_err(&pci_dev->dev, "%s: failed to request BAR\n",
> > > +			__func__);
> > > +		return false;
> > > +	}
> > > +
> > > +	phys_addr = pci_resource_start(pci_dev, bar);
> > > +	bar_len = pci_resource_len(pci_dev, bar);
> > > +
> > > +        if (offset + len > bar_len) {
> > > +                dev_err(&pci_dev->dev,
> > > +                        "%s: bar shorter than cap offset+len\n",
> > > +                        __func__);
> > > +                return false;
> > > +        }
> > > +
> > 
> > Something wrong with indentation here.
> 
> Will fix all indentation related issues in this patch.
> 
> > Also as long as you are validating things, it's worth checking
> > offset + len does not overflow.
> 
> Something like addition of following lines?
> 
> +       if ((offset + len) < offset) {
> +               dev_err(&pci_dev->dev, "%s: cap offset+len overflow detected\n",
> +                       __func__);
> +               return false;
> +       }
> 
> Vivek

That should do it.


