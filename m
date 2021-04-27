Date: Tue, 27 Apr 2021 10:48:30 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIfd7p/xDy8RqA1M@work-vm>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-2-ma.mandourr@gmail.com>
	<20210420190334.GE1529659@redhat.com>
	<CAD-LL6jeKzfY5ehBU_D6Bnpm53jNneecWLvYs_seGTOmZ=Am6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-LL6jeKzfY5ehBU_D6Bnpm53jNneecWLvYs_seGTOmZ=Am6Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/7] virtiofsd: Changed allocations of
 fuse_req to GLib functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Mahmoud Mandour <ma.mandourr@gmail.com>
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> On Tue, Apr 20, 2021 at 9:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Tue, Apr 20, 2021 at 05:46:36PM +0200, Mahmoud Mandour wrote:
> > > Replaced the allocation and deallocation of fuse_req structs
> > > using calloc()/free() call pairs to a GLib's g_try_new0()
> > > and g_free().
> >
> > Hi,
> >
> > What's the context of these patches. I see all of them are switching
> > to glib functions. Why to do that? What's the advantage.
> >
> > Vivek
> >
> > >
> > > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > ---
> > >  tools/virtiofsd/fuse_lowlevel.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/virtiofsd/fuse_lowlevel.c
> > b/tools/virtiofsd/fuse_lowlevel.c
> > > index 58e32fc963..812cef6ef6 100644
> > > --- a/tools/virtiofsd/fuse_lowlevel.c
> > > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > > @@ -106,7 +106,7 @@ static void list_add_req(struct fuse_req *req,
> > struct fuse_req *next)
> > >  static void destroy_req(fuse_req_t req)
> > >  {
> > >      pthread_mutex_destroy(&req->lock);
> > > -    free(req);
> > > +    g_free(req);
> > >  }
> > >
> > >  void fuse_free_req(fuse_req_t req)
> > > @@ -130,7 +130,7 @@ static struct fuse_req *fuse_ll_alloc_req(struct
> > fuse_session *se)
> > >  {
> > >      struct fuse_req *req;
> > >
> > > -    req = (struct fuse_req *)calloc(1, sizeof(struct fuse_req));
> > > +    req = g_try_new0(struct fuse_req, 1);
> > >      if (req == NULL) {
> > >          fuse_log(FUSE_LOG_ERR, "fuse: failed to allocate request\n");
> > >      } else {
> > > @@ -1684,7 +1684,7 @@ static struct fuse_req *check_interrupt(struct
> > fuse_session *se,
> > >          if (curr->u.i.unique == req->unique) {
> > >              req->interrupted = 1;
> > >              list_del_req(curr);
> > > -            free(curr);
> > > +            g_free(curr);
> > >              return NULL;
> > >          }
> > >      }
> > > --
> > > 2.25.1
> > >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/virtio-fs
> >
> >
> Hello Vivek,
> 
> Taken from the Qemu Coding Style document in the documentation:
> "Use of the malloc/free/realloc/calloc/valloc/memalign/posix_memalign APIs
> is not allowed in the QEMU codebase. Instead of these routines, use the
> GLib memory allocation routines
> g_malloc/g_malloc0/g_new/g_new0/g_realloc/g_free or QEMU’s
> qemu_memalign/qemu_blockalign/qemu_vfree APIs."
> It's also in the bite-sized contributions page as a task.

Yes I think generally that's OK; note that virtiofsd is a little unusual
in that a lot of it is imported from an external library and then
changed; so we've not done a lot of these type of qemu-speicific styles.

Dave

> Thanks,
> Mahmoud

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

