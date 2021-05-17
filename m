Date: Mon, 17 May 2021 09:08:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210517130816.GC546943@horse.lan>
References: <20210511213736.281016-1-vgoyal@redhat.com>
	<20210511213736.281016-8-vgoyal@redhat.com>
	<5ad6f5e9-0a12-54ce-163a-532f916cc8e8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5ad6f5e9-0a12-54ce-163a-532f916cc8e8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 7/7] virtiofsd: Set req->reply_sent right
 after sending reply
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, May 13, 2021 at 03:50:13PM -0500, Connor Kuehl wrote:
> On 5/11/21 4:37 PM, Vivek Goyal wrote:
> > There is no reason to set it in label "err". We should be able to set
> > it right after sending reply. It is easier to read.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> > index aa53808ef9..b1767dd5b9 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -446,12 +446,9 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> >      vu_queue_notify(dev, q);
> >      pthread_mutex_unlock(&qi->vq_lock);
> >      vu_dispatch_unlock(qi->virtio_dev);
> > +    req->reply_sent = true;
> >  
> >  err:
> 
> Just a really minor comment: after all these changes, I would venture
> that "out" is a more appropriate label name than "err" at this point.

May be. This path is used both by error path as well as success path. Just
that value of "ret" changes. I am not particular about it. So I will
change this to "out".

Thanks
Vivek
> 
> > -    if (ret == 0) {
> > -        req->reply_sent = true;
> > -    }
> > -
> >      return ret;
> >  }
> >  
> > 
> 

