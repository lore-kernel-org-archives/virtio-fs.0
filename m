Date: Wed, 7 Aug 2019 09:29:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190807132955.GC18557@redhat.com>
References: <20190807093152.10964-1-dgilbert@redhat.com>
	<20190807124537.GA18557@redhat.com> <20190807131715.GE2867@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807131715.GE2867@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 07, 2019 at 02:17:15PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Wed, Aug 07, 2019 at 10:31:52AM +0100, Dr. David Alan Gilbert (git) wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > 
> > > This fixes a crash in lo_destroy since g_hash_table_foreach_remove
> > > doesn't like the hashtable changing as it iterates, and unref_inode
> > > will remove entries.
> > 
> > Hi David,
> > 
> > Got two questions.
> > 
> > - Shouldn't we take a lo->mutex to make sure parallel hash table
> >   modifications are not happening.
> 
> See Stefan's big comment (which I just changed the function name in)
> which explains that we can't take lo->mutex

That comment says that unref_inode() takes the lock and that's why
we can't take it.

But that's easy to fix. We just have to come up with another helper which
does not take lock and asssumes lock has already been taken.

/* This assumes lo->lock is already held */
__unref_inode()
{
}

> 
> > - Also before destroying lo, should we sever connection so that any
> >   requests which come after lo_destroy() are not entertained.
> 
> No, because in some situations lo_destroy does not happen at the end;
> e.g. it happens during a umount and we still have the connection
> to be able to remount it.

Ok, so we don't sever the connection completely. But we don't expect to
process further requests till a new INIT has been done, isn't it?

IOW, once lo_destroy() is received, we cleanup any pending state from
the mount and if any requests are received from client, we error them
out.

And start processing requests normally when a new INIT has been
received.

Atleast that was my understanding of the design.

Thanks
Vivek

> 
> Dave
> 
> > Thanks
> > Vivek
> > 
> > > 
> > > Avoid the g_hash_table_foreach_remove and use a dummy iterator to find
> > > one element of the table at a time.
> > > 
> > > Fixes: virtiofsd: fix lo_destroy() resource leaks
> > > 
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  contrib/virtiofsd/passthrough_ll.c | 27 +++++++++++++--------------
> > >  1 file changed, 13 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > > index cc9c175047..321bbb20be 100644
> > > --- a/contrib/virtiofsd/passthrough_ll.c
> > > +++ b/contrib/virtiofsd/passthrough_ll.c
> > > @@ -2445,18 +2445,6 @@ static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
> > >  	fuse_reply_err(req, ret);
> > >  }
> > >  
> > > -static int destroy_inode_cb(gpointer key, gpointer value, gpointer user_data)
> > > -{
> > > -        struct lo_inode *inode = value;
> > > -        struct lo_data *lo = user_data;
> > > -
> > > -        /* inode->nlookup is normally protected by lo->mutex but see the
> > > -         * comment in lo_destroy().
> > > -         */
> > > -        unref_inode(lo, inode, inode->nlookup);
> > > -        return TRUE;
> > > -}
> > > -
> > >  static void lo_destroy(void *userdata, struct fuse_session *se)
> > >  {
> > >  	struct lo_data *lo = (struct lo_data*) userdata;
> > > @@ -2474,10 +2462,21 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
> > >          /* Normally lo->mutex must be taken when traversing lo->inodes but
> > >           * lo_destroy() is a serialized request so no races are possible here.
> > >           *
> > > -         * In addition, we cannot acquire lo->mutex since destroy_inode_cb() takes it
> > > +         * In addition, we cannot acquire lo->mutex since unref_inode() takes it
> > >           * too and this would result in a recursive lock.
> > >           */
> > > -        g_hash_table_foreach_remove(lo->inodes, destroy_inode_cb, lo);
> > > +        while (true) {
> > > +                GHashTableIter iter;
> > > +                gpointer key, value;
> > > +
> > > +                g_hash_table_iter_init(&iter, lo->inodes);
> > > +                if (!g_hash_table_iter_next(&iter, &key, &value)) {
> > > +                        break;
> > > +                }
> > > +
> > > +                struct lo_inode *inode = value;
> > > +                unref_inode(lo, inode, inode->nlookup);
> > > +        }
> > >  }
> > >  
> > >  static struct fuse_lowlevel_ops lo_oper = {
> > > -- 
> > > 2.21.0
> > > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

