Date: Wed, 21 Apr 2021 13:39:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210421173931.GF1579961@redhat.com>
References: <20210419213636.1514816-1-vgoyal@redhat.com>
	<20210419213636.1514816-3-vgoyal@redhat.com>
	<20210420093420.2eed3939@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420093420.2eed3939@bahia.lan>
Subject: Re: [Virtio-fs] [PATCH v3 2/3] dax: Add a wakeup mode parameter to
 put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: jack@suse.cz, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com

On Tue, Apr 20, 2021 at 09:34:20AM +0200, Greg Kurz wrote:
> On Mon, 19 Apr 2021 17:36:35 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > As of now put_unlocked_entry() always wakes up next waiter. In next
> > patches we want to wake up all waiters at one callsite. Hence, add a
> > parameter to the function.
> > 
> > This patch does not introduce any change of behavior.
> > 
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/dax.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 00978d0838b1..f19d76a6a493 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -275,11 +275,12 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> >  	finish_wait(wq, &ewait.wait);
> >  }
> >  
> > -static void put_unlocked_entry(struct xa_state *xas, void *entry)
> > +static void put_unlocked_entry(struct xa_state *xas, void *entry,
> > +			       enum dax_entry_wake_mode mode)
> >  {
> >  	/* If we were the only waiter woken, wake the next one */
> 
> With this change, the comment is no longer accurate since the
> function can now wake all waiters if passed mode == WAKE_ALL.
> Also, it paraphrases the code which is simple enough, so I'd
> simply drop it.

Ok, I will get rid of this comment. Agreed that code is simple
enough. And frankly speaking I don't even understand "If we were the
only waiter woken" part. How do we know that only this caller
was woken.

Vivek

> 
> This is minor though and it shouldn't prevent this fix to go
> forward.
> 
> Reviewed-by: Greg Kurz <groug@kaod.org>
> 
> >  	if (entry && !dax_is_conflict(entry))
> > -		dax_wake_entry(xas, entry, WAKE_NEXT);
> > +		dax_wake_entry(xas, entry, mode);
> >  }
> >  
> >  /*
> > @@ -633,7 +634,7 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
> >  			entry = get_unlocked_entry(&xas, 0);
> >  		if (entry)
> >  			page = dax_busy_page(entry);
> > -		put_unlocked_entry(&xas, entry);
> > +		put_unlocked_entry(&xas, entry, WAKE_NEXT);
> >  		if (page)
> >  			break;
> >  		if (++scanned % XA_CHECK_SCHED)
> > @@ -675,7 +676,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
> >  	mapping->nrexceptional--;
> >  	ret = 1;
> >  out:
> > -	put_unlocked_entry(&xas, entry);
> > +	put_unlocked_entry(&xas, entry, WAKE_NEXT);
> >  	xas_unlock_irq(&xas);
> >  	return ret;
> >  }
> > @@ -954,7 +955,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
> >  	return ret;
> >  
> >   put_unlocked:
> > -	put_unlocked_entry(xas, entry);
> > +	put_unlocked_entry(xas, entry, WAKE_NEXT);
> >  	return ret;
> >  }
> >  
> > @@ -1695,7 +1696,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
> >  	/* Did we race with someone splitting entry or so? */
> >  	if (!entry || dax_is_conflict(entry) ||
> >  	    (order == 0 && !dax_is_pte_entry(entry))) {
> > -		put_unlocked_entry(&xas, entry);
> > +		put_unlocked_entry(&xas, entry, WAKE_NEXT);
> >  		xas_unlock_irq(&xas);
> >  		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
> >  						      VM_FAULT_NOPAGE);
> 

