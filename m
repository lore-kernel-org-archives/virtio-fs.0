Date: Tue, 10 Mar 2020 16:29:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200310202946.GE38440@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-3-vgoyal@redhat.com>
	<20200310151906.GA670549@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310151906.GA670549@iweiny-DESK2.sc.intel.com>
Subject: Re: [Virtio-fs] [PATCH 02/20] dax: Create a range version of
 dax_layout_busy_page()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ira Weiny <ira.weiny@intel.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org

On Tue, Mar 10, 2020 at 08:19:07AM -0700, Ira Weiny wrote:
> On Wed, Mar 04, 2020 at 11:58:27AM -0500, Vivek Goyal wrote:
> >  
> > +	/* If end == 0, all pages from start to till end of file */
> > +	if (!end) {
> > +		end_idx = ULONG_MAX;
> > +		len = 0;
> 
> I find this a bit odd to specify end == 0 for ULONG_MAX...
> 
> >  }
> > +EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
> > +
> > +/**
> > + * dax_layout_busy_page - find first pinned page in @mapping
> > + * @mapping: address space to scan for a page with ref count > 1
> > + *
> > + * DAX requires ZONE_DEVICE mapped pages. These pages are never
> > + * 'onlined' to the page allocator so they are considered idle when
> > + * page->count == 1. A filesystem uses this interface to determine if
> > + * any page in the mapping is busy, i.e. for DMA, or other
> > + * get_user_pages() usages.
> > + *
> > + * It is expected that the filesystem is holding locks to block the
> > + * establishment of new mappings in this address_space. I.e. it expects
> > + * to be able to run unmap_mapping_range() and subsequently not race
> > + * mapping_mapped() becoming true.
> > + */
> > +struct page *dax_layout_busy_page(struct address_space *mapping)
> > +{
> > +	return dax_layout_busy_page_range(mapping, 0, 0);
> 
> ... other functions I have seen specify ULONG_MAX here.  Which IMO makes this
> call site more clear.

I think I looked at unmap_mapping_range() where holelen=0 implies till the
end of file and followed same pattern.

But I agree that LLONG_MAX (end is of type loff_t) is probably more
intuitive. I will change it.

Vivek

