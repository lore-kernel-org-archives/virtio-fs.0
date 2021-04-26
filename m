DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PWkah+fwPe33ZZcVqLDlcUWqo58D207f7qzlEj7nZwY=;
	b=GCyXjZT/CpYO/4ULivAxhOfL2e
	t0+fXiuhp77Toc2bpsmMyGA5pKlvXqdOCQ6BY6f9QcP7f02vrnAGfLg/qTL3PqwbxefsOH5XwkviN
	NGsMJi1ldPNllb+6J6c3TQhT0VsyOM8pqoJ6n4WgGNpxLiF05zsb2N7BNR5LSpzTiwLzL4L+2XP8j
	szX8OM40R/GksXzf/AZUIdGzO6iVgiyvWY+IEYZpWbUVY8OmfA+xG7HSQof2Yn3OokpD+UCJpUbei
	eOAVq+Twf6Xf8U2cVBFX3h4rvP1hzJixGETipmVcMHFX16aMbfe3yMQgr5SHicD71ImR99HvawHwx
	2YsP+Oag==
Date: Mon, 26 Apr 2021 19:02:11 +0100
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20210426180211.GP235567@casper.infradead.org>
References: <20210423130723.1673919-1-vgoyal@redhat.com>
	<20210423130723.1673919-2-vgoyal@redhat.com>
	<20210426134632.GM235567@casper.infradead.org>
	<20210426175217.GD1741690@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210426175217.GD1741690@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 1/3] dax: Add an enum for specifying dax
	wakup mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jack@suse.cz, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com

On Mon, Apr 26, 2021 at 01:52:17PM -0400, Vivek Goyal wrote:
> On Mon, Apr 26, 2021 at 02:46:32PM +0100, Matthew Wilcox wrote:
> > On Fri, Apr 23, 2021 at 09:07:21AM -0400, Vivek Goyal wrote:
> > > +enum dax_wake_mode {
> > > +	WAKE_NEXT,
> > > +	WAKE_ALL,
> > > +};
> > 
> > Why define them in this order when ...
> > 
> > > @@ -196,7 +207,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
> > >  	 * must be in the waitqueue and the following check will see them.
> > >  	 */
> > >  	if (waitqueue_active(wq))
> > > -		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
> > > +		__wake_up(wq, TASK_NORMAL, mode == WAKE_ALL ? 0 : 1, &key);
> > 
> > ... they're used like this?  This is almost as bad as
> > 
> > enum bool {
> > 	true,
> > 	false,
> > };
> 
> Hi Matthew,
> 
> So you prefer that I should switch order of WAKE_NEXT and WAKE_ALL? 
> 
> enum dax_wake_mode {
> 	WAKE_ALL,
> 	WAKE_NEXT,
> };

That, yes.

> And then do following to wake task.
> 
> if (waitqueue_active(wq))
> 	__wake_up(wq, TASK_NORMAL, mode, &key);

No, the third argument to __wake_up() is a count, not an enum.  It just so
happens that '0' means 'all' and we only ever wake up 1 and not, say, 5.
So the logical way to define the enum is ALL, NEXT which _just happens
to match_ the usage of __wake_up().

