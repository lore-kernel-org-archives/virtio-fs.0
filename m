Date: Tue, 27 Apr 2021 19:41:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIha2UGITOiJpEoy@work-vm>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
	<YIfmaleNOwhLLD9W@work-vm>
	<CAD-LL6gvoz0t4UND-CNdazciFoFE6ZVJ8ncZbfM3b37c8ECzbw@mail.gmail.com>
	<YIfu9eV41U6vT6iP@work-vm>
	<CAD-LL6gCTagzmR-NXZiBTJH+LOH0D4wHigVow1e0bVfyVcm4PQ@mail.gmail.com>
	<YIf2d8HuyPqwqt9C@work-vm>
	<CAD-LL6jK7LC5p8FBgHRgsUQnaWgn3gNXONXNwn44pb99sna_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-LL6jK7LC5p8FBgHRgsUQnaWgn3gNXONXNwn44pb99sna_ag@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/7] virtiofds: Changed allocations of
 iovec to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Mahmoud Mandour <ma.mandourr@gmail.com>
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, qemu-devel@nongnu.org

* Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> On Tue, Apr 27, 2021 at 1:33 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
> wrote:
> 
> > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > On Tue, Apr 27, 2021 at 1:01 PM Dr. David Alan Gilbert <
> > dgilbert@redhat.com>
> > > wrote:
> > >
> > > > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > > > On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert <
> > > > dgilbert@redhat.com>
> > > > > wrote:
> > > > >
> > > > > > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > > > > > Replaced the calls to malloc()/calloc() and their respective
> > > > > > > calls to free() of iovec structs with GLib's allocation and
> > > > > > > deallocation functions.
> > > > > > >
> > > > > > > Also, in one instance, used g_new0() instead of a calloc() call
> > plus
> > > > > > > a null-checking assertion.
> > > > > > >
> > > > > > > iovec structs were created locally and freed as the function
> > > > > > > ends. Hence, I used g_autofree and removed the respective calls
> > to
> > > > > > > free().
> > > > > > >
> > > > > > > In one instance, a struct fuse_ioctl_iovec pointer is returned
> > from a
> > > > > > > function, namely, fuse_ioctl_iovec_copy. There, I used
> > > > g_steal_pointer()
> > > > > > > in conjunction with g_autofree, this gives the ownership of the
> > > > pointer
> > > > > > > to the calling function and still auto-frees the memory when the
> > > > calling
> > > > > > > function finishes (maintaining the symantics of previous code).
> > > > > > >
> > > > > > > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > > > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > ---
> > > > > > >  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
> > > > > > >  tools/virtiofsd/fuse_virtio.c   |  6 +-----
> > > > > > >  2 files changed, 8 insertions(+), 17 deletions(-)
> > > > > > >
> > > > > > > diff --git a/tools/virtiofsd/fuse_lowlevel.c
> > > > > > b/tools/virtiofsd/fuse_lowlevel.c
> > > > > > > index 812cef6ef6..f965299ad9 100644
> > > > > > > --- a/tools/virtiofsd/fuse_lowlevel.c
> > > > > > > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > > > > > > @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int
> > error,
> > > > > > const void *arg,
> > > > > > >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int
> > > > count)
> > > > > > >  {
> > > > > > >      int res;
> > > > > > > -    struct iovec *padded_iov;
> > > > > > > +    g_autofree struct iovec *padded_iov;
> > > > > > >
> > > > > > > -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> > > > > > > +    padded_iov = g_try_new(struct iovec, count + 1);
> > > > > > >      if (padded_iov == NULL) {
> > > > > > >          return fuse_reply_err(req, ENOMEM);
> > > > > > >      }
> > > > > > > @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const
> > struct
> > > > > > iovec *iov, int count)
> > > > > > >      count++;
> > > > > > >
> > > > > > >      res = send_reply_iov(req, 0, padded_iov, count);
> > > > > > > -    free(padded_iov);
> > > > > > >
> > > > > > >      return res;
> > > > > > >  }
> > > > > >
> > > > > > OK.
> > > > > >
> > > > > > > @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req,
> > uint64_t
> > > > idx)
> > > > > > >  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const
> > struct
> > > > > > iovec *iov,
> > > > > > >                                                        size_t
> > count)
> > > > > > >  {
> > > > > > > -    struct fuse_ioctl_iovec *fiov;
> > > > > > > +    g_autofree struct fuse_ioctl_iovec *fiov;
> > > > > > >      size_t i;
> > > > > > >
> > > > > > > -    fiov = malloc(sizeof(fiov[0]) * count);
> > > > > > > +    fiov = g_try_new(fuse_ioctl_iovec, count);
> > > > > > >      if (!fiov) {
> > > > > > >          return NULL;
> > > > > > >      }
> > > > > > > @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec
> > > > > > *fuse_ioctl_iovec_copy(const struct iovec *iov,
> > > > > > >          fiov[i].len = iov[i].iov_len;
> > > > > > >      }
> > > > > > >
> > > > > > > -    return fiov;
> > > > > > > +    return g_steal_pointer(&fiov);
> > > > > > >  }
> > > > > >
> > > > > > This is OK, but doesn't gain anything - marking it as
> > g_autofree'ing
> > > > and
> > > > > > always stealing is no benefit.
> > > > > >
> > > > > > >
> > > > > > >  int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec
> > > > *in_iov,
> > > > > > > @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req,
> > const
> > > > > > struct iovec *in_iov,
> > > > > > >
> > > > > > >      res = send_reply_iov(req, 0, iov, count);
> > > > > > >  out:
> > > > > > > -    free(in_fiov);
> > > > > > > -    free(out_fiov);
> > > > > > > -
> > > > > >
> > > > > > I don't think you can do that - I think you're relying here on the
> > > > > > g_autofree from fuse_ioclt_iovec_copy - but my understanding is
> > that
> > > > > > doesn't work; g_autofree is scoped, so it's designed to free at
> > the end
> > > > > > of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn't know that
> > the
> > > > > > ion_fiov were allocated that way, so it won't get autocleaned up.
> > > > > >
> > > > > >
> > > > > In GLib's documentation, it is clarified (w.r.t. g_autoptr but I
> > think
> > > > > similar logic applies to g_autofree)
> > > > > that g_steal_pointer() "This can be very useful when combined with
> > > > > g_autoptr() to prevent
> > > > > the return value of a function from being automatically freed."
> > > > > I think, but not 100% clear of course, that this means that the
> > > > > g_autoptr-annotated memory
> > > > > does not get freed at the end of the current scope, and  its "scope"
> > is
> > > > > migrated to the calling
> > > > > function(to be honest I don't know how would they implement that but
> > > > maybe
> > > > > this is the case).
> > > > > Otherwise why bother with g_autoptr'ing memory that we don't want to
> > free
> > > > > automatically and
> > > > > would like to return to the calling function?
> > > > >
> > > > > The first example in Memory Allocation: GLib Reference Manual (
> > gnome.org
> > > > )
> > > > > <
> > > >
> > https://developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointer
> > > > >
> > > > > does
> > > > > annotate
> > > > > the memory as g_autoptr and then returns it through g_steal_pointer.
> > With
> > > > > your logic, I think that
> > > > > this example would be wrong(?)
> > > >
> > > > The example is correct but not quite the case you have;  the
> > > > g_steal_pointer stops the g_autoptr freeing it at the end of the
> > current
> > > > scope; but it doesn't cause it to be free'd later - the caller can't
> > > > tell that the function that did the allocation had a g_autofree in it;
> > > > once you get outside of the function, the pointer is just a normal
> > > > pointer that needs free or g_free on.
> > > >
> > > > I think that this is logical, yes. I think that I understand now. Can
> > you
> > > please instruct
> > > me on what to do with the patch? Do you want me to resend the entire
> > patch
> > > series
> > > and amend this one?
> >
> > Just resend this one as a '[PATCH v3 2/7]'
> >
> > Dave
> >
> > >
> > > >
> > > > > Mr. Hajnoczi already reviewed this patch  Re: [PATCH 2/8] virtiofds:
> > > > > Changed allocations of iovec to GLib's functi
> > > > > <https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg08459.html
> > >
> > > > > in a previous version and this v2 patch series is supposed to only
> > > > contain
> > > > > already-reviewed patches and
> > > > > remove bad ones
> > > >
> > > > But he didn't spot this particular problem.
> > > >
> > > > Dave
> > > >
> > > > >
> > > > > > >      return res;
> > > > > > >
> > > > > > >  enomem:
> > > > > > > @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int
> > > > result,
> > > > > > const void *buf, size_t size)
> > > > > > >  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const
> > struct
> > > > iovec
> > > > > > *iov,
> > > > > > >                           int count)
> > > > > > >  {
> > > > > > > -    struct iovec *padded_iov;
> > > > > > > +    g_autofree struct iovec *padded_iov;
> > > > > > >      struct fuse_ioctl_out arg;
> > > > > > >      int res;
> > > > > > >
> > > > > > > -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> > > > > > > +    padded_iov = g_try_new(struct iovec, count + 2);
> > > > > > >      if (padded_iov == NULL) {
> > > > > > >          return fuse_reply_err(req, ENOMEM);
> > > > > > >      }
> > > > > > > @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int
> > > > result,
> > > > > > const struct iovec *iov,
> > > > > > >      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
> > > > > > >
> > > > > > >      res = send_reply_iov(req, 0, padded_iov, count + 2);
> > > > > > > -    free(padded_iov);
> > > > > > >
> > > > > > >      return res;
> > > > > > >  }
> > > > > >
> > > > > > OK
> > > > > >
> > > > > > > diff --git a/tools/virtiofsd/fuse_virtio.c
> > > > > > b/tools/virtiofsd/fuse_virtio.c
> > > > > > > index 3e13997406..07e5d91a9f 100644
> > > > > > > --- a/tools/virtiofsd/fuse_virtio.c
> > > > > > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > > > > > @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session
> > *se,
> > > > > > struct fuse_chan *ch,
> > > > > > >       * Build a copy of the the in_sg iov so we can skip bits in
> > it,
> > > > > > >       * including changing the offsets
> > > > > > >       */
> > > > > > > -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec),
> > in_num);
> > > > > > > -    assert(in_sg_cpy);
> > > > > > > +    g_autofree struct iovec *in_sg_cpy = g_new0(struct iovec,
> > > > in_num);
> > > > > > >      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
> > > > > > >      /* These get updated as we skip */
> > > > > > >      struct iovec *in_sg_ptr = in_sg_cpy;
> > > > > > > @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session
> > *se,
> > > > > > struct fuse_chan *ch,
> > > > > > >              ret = errno;
> > > > > > >              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m)
> > > > len=%zd\n",
> > > > > > >                       __func__, len);
> > > > > > > -            free(in_sg_cpy);
> > > > > > >              goto err;
> > > > > > >          }
> > > > > > >          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n",
> > > > > > __func__,
> > > > > > > @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct
> > fuse_session
> > > > *se,
> > > > > > struct fuse_chan *ch,
> > > > > > >          if (ret != len) {
> > > > > > >              fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n",
> > __func__);
> > > > > > >              ret = EIO;
> > > > > > > -            free(in_sg_cpy);
> > > > > > >              goto err;
> > > > > > >          }
> > > > > > >          in_sg_left -= ret;
> > > > > > >          len -= ret;
> > > > > > >      } while (in_sg_left);
> > > > > > > -    free(in_sg_cpy);
> > > > > >
> > > > > > Yes, this is where the autofree really helps; getting rid of a few
> > > > > > free's.
> > > > > >
> > > > > > Dave
> > > > > >
> > > > > > >      /* Need to fix out->len on EOF */
> > > > > > >      if (len) {
> > > > > > > --
> > > > > > > 2.25.1
> > > > > > >
> > > > > > --
> > > > > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > > > > >
> > > > > >
> > > > > Thanks,
> > > > > Mahmoud
> > > > --
> > > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > > >
> > > >
> > > Thanks,
> > > Mahmoud
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >
> >
> I sent a v3 of this patch, and I used the --in-reply-to and put the
> message-id of your latest
> email but despite this, it was sent as a separate thread, I apologise.
> That's the link of the thread
> [PATCH v3 2/7] virtiofsd: Changed allocations of iovec to GLib's functio
> (gnu.org)
> <https://lists.gnu.org/archive/html/qemu-devel/2021-04/msg05559.html>
> and if you think that it'd better be here, I'll send it again manually as a
> reply to this mailing series.

Thanks, it's actually shown up in the same thread for me.

Dave

> Mahmoud
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

