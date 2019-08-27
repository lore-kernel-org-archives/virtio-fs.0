References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-5-vgoyal@redhat.com>
	<5D63392C.3030404@huawei.com> <20190826130607.GB3561@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D64FAD2.2050906@huawei.com>
Date: Tue, 27 Aug 2019 17:41:38 +0800
MIME-Version: 1.0
In-Reply-To: <20190826130607.GB3561@redhat.com>
Content-Type: text/plain; charset="windows-1252"
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



On 2019/8/26 21:06, Vivek Goyal wrote:
> On Mon, Aug 26, 2019 at 09:43:08AM +0800, piaojun wrote:
> 
> [..]
>>> +static bool vp_get_shm_region(struct virtio_device *vdev,
>>> +			      struct virtio_shm_region *region, u8 id)
>>> +{
>>> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>> +	struct pci_dev *pci_dev = vp_dev->pci_dev;
>>> +	u8 bar;
>>> +	u64 offset, len;
>>> +	phys_addr_t phys_addr;
>>> +	size_t bar_len;
>>> +	char *bar_name;
>>
>> 'char *bar_name' should be cleaned up to avoid compiling warning. And I
>> wonder if you mix tab and blankspace for code indent? Or it's just my
>> email display problem?
> 
> Will get rid of now unused bar_name. 
> 
OK

> Generally git flags if there are tab/space issues. I did not see any. So
> if you see something, point it out and I will fix it.
> 

cohuck found the same indent problem and pointed them in another email.

Jun

