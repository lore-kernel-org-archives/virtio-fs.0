Date: Tue, 27 Aug 2019 10:46:09 +0200
From: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20190827104609.234a536b.cohuck@redhat.com>
In-Reply-To: <20190827103457.35927d9d.cohuck@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-5-vgoyal@redhat.com>
	<20190827103457.35927d9d.cohuck@redhat.com>
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

On Tue, 27 Aug 2019 10:34:57 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 21 Aug 2019 13:57:05 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:

> > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > +			      struct virtio_shm_region *region, u8 id)
> > +{
> > +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);  
> 
> This whole function looks like it is indented incorrectly.

Hmpf, it looks like my mail client is squashing tabs, so the
indentation looks off here, but is probably fine :) It's the function
above that seems to have a mix of spaces and tabs.

> 
> > +	struct pci_dev *pci_dev = vp_dev->pci_dev;
> > +	u8 bar;
> > +	u64 offset, len;
> > +	phys_addr_t phys_addr;
> > +	size_t bar_len;
> > +	char *bar_name;
> > +	int ret;

