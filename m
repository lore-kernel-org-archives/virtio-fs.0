Date: Thu, 8 Aug 2019 11:26:51 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190808102651.GD2852@work-vm>
References: <20190807093152.10964-1-dgilbert@redhat.com>
	<20190807124537.GA18557@redhat.com> <20190807131715.GE2867@work-vm>
	<20190807132955.GC18557@redhat.com>
	<20190808094546.GC31963@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808094546.GC31963@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix lo_destroy crash in
 g_hash_table_foreach_remove
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Aug 07, 2019 at 09:29:55AM -0400, Vivek Goyal wrote:
> > On Wed, Aug 07, 2019 at 02:17:15PM +0100, Dr. David Alan Gilbert wrote:
> > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > On Wed, Aug 07, 2019 at 10:31:52AM +0100, Dr. David Alan Gilbert (git) wrote:
> > > > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > > > 
> > > > > This fixes a crash in lo_destroy since g_hash_table_foreach_remove
> > > > > doesn't like the hashtable changing as it iterates, and unref_inode
> > > > > will remove entries.
> > > > 
> > > > Hi David,
> > > > 
> > > > Got two questions.
> > > > 
> > > > - Shouldn't we take a lo->mutex to make sure parallel hash table
> > > >   modifications are not happening.
> > > 
> > > See Stefan's big comment (which I just changed the function name in)
> > > which explains that we can't take lo->mutex
> > 
> > That comment says that unref_inode() takes the lock and that's why
> > we can't take it.
> > 
> > But that's easy to fix. We just have to come up with another helper which
> > does not take lock and asssumes lock has already been taken.
> > 
> > /* This assumes lo->lock is already held */
> > __unref_inode()
> > {
> > }
> 
> Nice idea.  It would be cleaner to drop the comments and introduce a
> unref_inode_locked() function so we can follow the usual locking regime.
> 
> (Linux uses __foo() but double underscore identifiers are reserved in
> the C language standard, so IMO it's better to avoid them).

OK< yeh that's easy enough to do.

> 
> > > 
> > > > - Also before destroying lo, should we sever connection so that any
> > > >   requests which come after lo_destroy() are not entertained.
> > > 
> > > No, because in some situations lo_destroy does not happen at the end;
> > > e.g. it happens during a umount and we still have the connection
> > > to be able to remount it.
> > 
> > Ok, so we don't sever the connection completely. But we don't expect to
> > process further requests till a new INIT has been done, isn't it?
> > 
> > IOW, once lo_destroy() is received, we cleanup any pending state from
> > the mount and if any requests are received from client, we error them
> > out.
> > 
> > And start processing requests normally when a new INIT has been
> > received.
> > 
> > Atleast that was my understanding of the design.
> 
> There is a state machine that does:
> 
> 1. Drain in-flight requests when DESTROY is received.

Hmm does that drain happen in the reboot case where there wasn't
actually a destroy message? (fuse_session_process_buf_int 
where it calls se->op.destroy explicitly)

Dave

> 2. Process DESTROY in a serialized fashion.
> 3. Forbid any requests until the next INIT.  <-- requests queued after
> 						 DESTROY are rejected
> 						 here
> 4. Process INIT in a serialized fashion.
> 
> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

