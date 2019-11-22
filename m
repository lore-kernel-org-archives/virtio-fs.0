Date: Fri, 22 Nov 2019 08:45:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191122134547.GC8636@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-2-vgoyal@redhat.com>
	<20191122100713.GB464656@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100713.GB464656@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: Release file locks using
	F_UNLCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org

On Fri, Nov 22, 2019 at 10:07:13AM +0000, Stefan Hajnoczi wrote:
> On Fri, Nov 15, 2019 at 03:55:40PM -0500, Vivek Goyal wrote:
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index bc214df0c7..028e7da273 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -936,6 +936,14 @@ static void put_shared(struct lo_data *lo, struct lo_inode *inode)
> >  	}
> >  }
> >  
> > +static void release_plock(gpointer data)
> 
> The name posix_locks_value_destroy() would be clearer because it matches
> g_hash_table_new_full() terminology and the function cannot be confused
> with a lock acquire/release operation.

Ok, will use this name.

> 
> This patch conflicts with the cleanups that are currently being made to
> virtiofsd:
> https://github.com/stefanha/qemu/commit/1e493175feca58a81a2d0cbdac93b92e5425d850#diff-ca2dea995d1e6cdb95c8a47c7cca51ceR773

Yes it will. I see you are removing element from hash table on lo_flush().
This works fine today but with waiting locks, we drop the
inode->plock_mutex lock and then wait for the lock and expect
"lo_inode_plock" to not go away.

So I don't think you can remove the element from hash table upon
lo_flush(). May be we can refcount lo_inode_plock structure and first
release all the locks using setlk(UNLCK) and then drop the reference. If
this is last refernce, it will be freed.

And waiting lock code, will obtain a refernce under inode->posix_locks
and then wait for lock outside the lock.

IOW, I will say don't do this optimization of lookup + remove because
it will not work with blocking locks.

Thanks
Vivek

