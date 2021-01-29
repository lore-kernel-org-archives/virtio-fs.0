Date: Fri, 29 Jan 2021 13:03:09 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210129130309.1e769bdc@bahia.lan>
In-Reply-To: <20210126183336.GB3239@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-2-vgoyal@redhat.com>
	<20210126165600.7bbe369d@bahia.lan>
	<20210126183336.GB3239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/6] virtiofsd: Drop ->vu_dispatch_rwlock
 while waiting for thread to exit
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, marcandre.lureau@redhat.com

On Tue, 26 Jan 2021 13:33:36 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

[...]
 
> > 
> > Also, since pthread_rwlock_wrlock() can fail, I think we should
> > always check it's return value, at least with an assert() like
> > already done elsewhere.
> 
> Will check return code of pthread_rwlock_wrlock() and probably use
> assert().
> 

It turns out that pthread_rwlock_rdlock() and pthread_rwlock_unlock() can
also fail for various reasons that would likely indicate a programming
error, but their return values are never checked anywhere.

I have a patch to address this globally in this file. Should I post it
now or you prefer this series goes first ?

> Vivek
> 
> > 
> > >      for (int i = 0; i < se->virtio_dev->nqueues; i++) {
> > >          if (!se->virtio_dev->qi[i]) {
> > >              continue;
> > > @@ -961,6 +974,7 @@ int virtio_loop(struct fuse_session *se)
> > >          fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func__, i);
> > >          fv_queue_cleanup_thread(se->virtio_dev, i);
> > >      }
> > > +    pthread_rwlock_unlock(&se->virtio_dev->vu_dispatch_rwlock);
> > >  
> > >      fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);
> > >  
> > 
> 

