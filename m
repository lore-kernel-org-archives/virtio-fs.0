Date: Fri, 3 Jan 2020 13:43:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200103184317.GC13350@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
	<20190826115316.GB21051@infradead.org>
	<20190826203326.GB13860@redhat.com>
	<20190826205829.GC13860@redhat.com>
	<20200103141235.GA13350@redhat.com>
	<CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
	<CAPcyv4jM8s8T5ifv0c2eyqaBu3f2bd_j+fQHmJttZAajZ-we=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jM8s8T5ifv0c2eyqaBu3f2bd_j+fQHmJttZAajZ-we=g@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 02/19] dax: Pass dax_dev to
	dax_writeback_mapping_range()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 03, 2020 at 10:18:22AM -0800, Dan Williams wrote:

> I'll also circle back to your question about
> partitions on patch1.

Hi Dan,

I was playing with having sector information in dax device (and not having
to look back at bdev). I was thinking of something as follows.

- Create a new structure/handle which also contains offset into dax device
  in sectors. Say.

  struct dax_handle {
  	sector_t start_sect;
  	struct dax_device *dax_dev;
  }

 This handle will have pointer to the actual dax device.

- Modify dax_get_by_bdev(struct block_device *bdev) to return dax_handle
  (instead of dax device).

  struct dax_handle *dax_get_by_bdev(struct block_device *bdev);

  This will create dax_handle. Find dax_device from hash table and
  initialize dax_handle.

  dax_handle->start_sect = get_start_sect(bdev);
  dax_handle->dax_dev = dax_dev;

  Now filesystem and stacked block devices can get pointer to dax_handle
  using block device and they can use this handle to refer to underlying
  dax device partition.

- Now dax_handle can be passed around and hopefully we can get rid of
  passing around bdev in many of the dax interfaces. And partition offset
  information has now moved into dax_handle.

- For the use cases which don't have a bdev (like virtiofs), we can
  provide another helper to get dax_handle with offset 0. And then
  we should not need a bdev to be able to use dax API.

Does this sound like a reasonable step in the direction of getting rid
of this assumption that every dax_device has associated block_device.

Thanks
Vivek

