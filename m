Date: Tue, 27 Apr 2021 11:57:38 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YIfuInAdhqff2Ddq@redhat.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
	<YIfmaleNOwhLLD9W@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIfmaleNOwhLLD9W@work-vm>
Subject: Re: [Virtio-fs] [PATCH v2 2/7] virtiofds: Changed allocations of
 iovec to GLib's functions
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>, qemu-devel@nongnu.org

On Tue, Apr 27, 2021 at 11:24:42AM +0100, Dr. David Alan Gilbert wrote:
> * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > Replaced the calls to malloc()/calloc() and their respective
> > calls to free() of iovec structs with GLib's allocation and
> > deallocation functions.
> > 
> > Also, in one instance, used g_new0() instead of a calloc() call plus
> > a null-checking assertion.
> > 
> > iovec structs were created locally and freed as the function
> > ends. Hence, I used g_autofree and removed the respective calls to
> > free().
> > 
> > In one instance, a struct fuse_ioctl_iovec pointer is returned from a
> > function, namely, fuse_ioctl_iovec_copy. There, I used g_steal_pointer()
> > in conjunction with g_autofree, this gives the ownership of the pointer
> > to the calling function and still auto-frees the memory when the calling
> > function finishes (maintaining the symantics of previous code).
> > 
> > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
> >  tools/virtiofsd/fuse_virtio.c   |  6 +-----
> >  2 files changed, 8 insertions(+), 17 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> > index 812cef6ef6..f965299ad9 100644
> > --- a/tools/virtiofsd/fuse_lowlevel.c
> > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error, const void *arg,
> >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
> >  {
> >      int res;
> > -    struct iovec *padded_iov;
> > +    g_autofree struct iovec *padded_iov;
> >  
> > -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> > +    padded_iov = g_try_new(struct iovec, count + 1);
> >      if (padded_iov == NULL) {
> >          return fuse_reply_err(req, ENOMEM);
> >      }
> > @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
> >      count++;
> >  
> >      res = send_reply_iov(req, 0, padded_iov, count);
> > -    free(padded_iov);
> >  
> >      return res;
> >  }
> 
> OK.
> 
> > @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, uint64_t idx)
> >  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct iovec *iov,
> >                                                        size_t count)
> >  {
> > -    struct fuse_ioctl_iovec *fiov;
> > +    g_autofree struct fuse_ioctl_iovec *fiov;
> >      size_t i;
> >  
> > -    fiov = malloc(sizeof(fiov[0]) * count);
> > +    fiov = g_try_new(fuse_ioctl_iovec, count);
> >      if (!fiov) {
> >          return NULL;
> >      }
> > @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct iovec *iov,
> >          fiov[i].len = iov[i].iov_len;
> >      }
> >  
> > -    return fiov;
> > +    return g_steal_pointer(&fiov);
> >  }
> 
> This is OK, but doesn't gain anything - marking it as g_autofree'ing and
> always stealing is no benefit.

Think of it as proactive bug prevention - if someone later inserts a
second "return NULL" error condition somewhere in the middle of the
method, we've safely free the iovec. This method is pretty trivial
so in reality that's not likely to happen, but if we're going to use
g_autofree, it is worth using it universally through a file, so it
sets expectations for future contributors.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

