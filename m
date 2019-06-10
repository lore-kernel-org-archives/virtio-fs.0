Date: Mon, 10 Jun 2019 15:10:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190610191059.GC29869@redhat.com>
References: <20190607193704.GC23125@redhat.com>
	<20190610190025.GH22439@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610190025.GH22439@work-vm>
Subject: Re: [Virtio-fs] [PATCH V2] virtiofsd: Support remote posix locks
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

On Mon, Jun 10, 2019 at 08:00:26PM +0100, Dr. David Alan Gilbert wrote:

[..]
> >  struct lo_map_elem {
> >  	union {
> >  		struct lo_inode *inode;
> > @@ -86,6 +92,8 @@ struct lo_inode {
> >  	struct lo_key key;
> >  	uint64_t refcount; /* protected by lo->mutex */
> >  	fuse_ino_t fuse_ino;
> > +	pthread_mutex_t plock_mutex;
> > +	GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
> >  };
> >  
> >  struct lo_cred {
> > @@ -105,6 +113,7 @@ struct lo_data {
> >  	int norace;
> >  	int writeback;
> >  	int flock;
> > +	int posix_lock;
> >  	int xattr;
> >  	const char *source;
> >  	double timeout;
> > @@ -133,6 +142,10 @@ static const struct fuse_opt lo_opts[] =
> >  	  offsetof(struct lo_data, flock), 1 },
> >  	{ "no_flock",
> >  	  offsetof(struct lo_data, flock), 0 },
> > +	{ "posix_lock",
> > +	  offsetof(struct lo_data, posix_lock), 0 },
> 
> Shouldn't that be 1                             ^ ?
> 

Good catch. Havind said that, I am wondering why do we need this
"posix_lock" knob given we enable it by default. I guess only place it
could be useful if user wanted to force a certain behavior without knowing
what's the daemon default. Also defaults could change down the line.

I will post V3.

Vivek

