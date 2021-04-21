Date: Wed, 21 Apr 2021 13:21:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210421172130.GE1579961@redhat.com>
References: <20210419213636.1514816-1-vgoyal@redhat.com>
	<20210419213636.1514816-2-vgoyal@redhat.com>
	<20210421092440.GM8706@quack2.suse.cz>
	<20210421155631.GC1579961@redhat.com>
	<20210421161624.GJ3596236@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421161624.GJ3596236@casper.infradead.org>
Subject: Re: [Virtio-fs] [PATCH v3 1/3] dax: Add an enum for specifying dax
	wakup mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com

On Wed, Apr 21, 2021 at 05:16:24PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 21, 2021 at 11:56:31AM -0400, Vivek Goyal wrote:
> > +/**
> > + * enum dax_entry_wake_mode: waitqueue wakeup toggle
> 
> s/toggle/behaviour/ ?

Will do.

> 
> > + * @WAKE_NEXT: wake only the first waiter in the waitqueue
> > + * @WAKE_ALL: wake all waiters in the waitqueue
> > + */
> > +enum dax_entry_wake_mode {
> > +	WAKE_NEXT,
> > +	WAKE_ALL,
> > +};
> > +
> >  static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
> >  		void *entry, struct exceptional_entry_key *key)
> >  {
> > @@ -182,7 +192,8 @@ static int wake_exceptional_entry_func(w
> >   * The important information it's conveying is whether the entry at
> >   * this index used to be a PMD entry.
> >   */
> > -static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
> > +static void dax_wake_entry(struct xa_state *xas, void *entry,
> > +			   enum dax_entry_wake_mode mode)
> 
> It's an awfully verbose name.  'dax_wake_mode'?

Sure. Will change.

Vivek
> 

