Date: Mon, 5 Aug 2019 19:57:51 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190805185751.GB17658@work-vm>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190801165409.20121-4-stefanha@redhat.com>
	<20190805151708.GN13734@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805151708.GN13734@work-vm>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: fix lo_destroy() resource
	leaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Now that lo_destroy() is serialized we can call unref_inode() so that
> > all inode resources are freed.
> > 
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 43 ++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 23 deletions(-)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index a81c01d0d1..02a5e97326 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1340,28 +1340,6 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
> >  	}
> >  }
> >  
> > -static int unref_all_inodes_cb(gpointer key, gpointer value,
> > -			       gpointer user_data)
> > -{
> > -	struct lo_inode *inode  = value;
> > -	struct lo_data *lo = user_data;
> > -
> > -	inode->nlookup = 0;
> > -	lo_map_remove(&lo->ino_map, inode->fuse_ino);
> > -	close(inode->fd);
> > -	lo_inode_put(lo, &inode); /* Drop our refcount from lo_do_lookup() */
> > -
> > -	return TRUE;
> > -}
> > -
> > -static void unref_all_inodes(struct lo_data *lo)
> > -{
> > -	pthread_mutex_lock(&lo->mutex);
> > -	g_hash_table_foreach_remove(lo->inodes, unref_all_inodes_cb, lo);
> > -	pthread_mutex_unlock(&lo->mutex);
> > -
> > -}
> > -
> >  static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
> >  {
> >  	struct lo_data *lo = lo_data(req);
> > @@ -2462,6 +2440,18 @@ static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
> >  	fuse_reply_err(req, ret);
> >  }
> >  
> > +static int destroy_inode_cb(gpointer key, gpointer value, gpointer user_data)
> > +{
> > +        struct lo_inode *inode = value;
> > +        struct lo_data *lo = user_data;
> > +
> > +        /* inode->nlookup is normally protected by lo->mutex but see the
> > +         * comment in lo_destroy().
> > +         */
> > +        unref_inode(lo, inode, inode->nlookup);
> > +        return TRUE;
> > +}
> > +
> >  static void lo_destroy(void *userdata, struct fuse_session *se)
> >  {
> >  	struct lo_data *lo = (struct lo_data*) userdata;
> > @@ -2475,7 +2465,14 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
> >                          fuse_err("%s: unmap during destroy failed\n", __func__);
> >                  }
> >          }
> > -	unref_all_inodes(lo);
> > +
> > +        /* Normally lo->mutex must be taken when traversing lo->inodes but
> > +         * lo_destroy() is a serialized request so no races are possible here.
> > +         *
> > +         * In addition, we cannot acquire lo->mutex since destroy_inode_cb() takes it
> > +         * too and this would result in a recursive lock.
> > +         */
> > +        g_hash_table_foreach_remove(lo->inodes, destroy_inode_cb, lo);

I'm seeing a crash here if I ctrl-c the virtiofsd after it's got an
active mount:

(process:3219): GLib-CRITICAL **: 18:42:08.334: g_hash_table_foreach_remove_or_steal: assertion 'version == hash_table->version' failed

(I only get the debug if I give seccomp both getpeername and ioctl;
I think glib is trying to get to syslog and wants getpeername
and I'm guessing ioctl to do something funky with the terminal).

Dave

> >  }
> >  
> >  static struct fuse_lowlevel_ops lo_oper = {
> > -- 
> > 2.21.0
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

