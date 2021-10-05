Date: Tue, 5 Oct 2021 09:26:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVxSdmNsNXm4DU1z@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-13-vgoyal@redhat.com>
	<YVsYmHhbjPs/LEUc@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsYmHhbjPs/LEUc@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 12/13] virtiofsd: Implement blocking posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Oct 04, 2021 at 04:07:04PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:36AM -0400, Vivek Goyal wrote:
> > As of now we don't support fcntl(F_SETLKW) and if we see one, we return
> > -EOPNOTSUPP.
> > 
> > Change that by accepting these requests and returning a reply
> > immediately asking caller to wait. Once lock is available, send a
> > notification to the waiter indicating lock is available.
> > 
> > In response to lock request, we are returning error value as "1", which
> > signals to client to queue the lock request internally and later client
> > will get a notification which will signal lock is taken (or error). And
> > then fuse client should wake up the guest process.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_lowlevel.c  | 37 ++++++++++++++++-
> >  tools/virtiofsd/fuse_lowlevel.h  | 26 ++++++++++++
> >  tools/virtiofsd/fuse_virtio.c    | 50 ++++++++++++++++++++---
> >  tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++----
> >  4 files changed, 167 insertions(+), 16 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> > index e4679c73ab..2e7f4b786d 100644
> > --- a/tools/virtiofsd/fuse_lowlevel.c
> > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > @@ -179,8 +179,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
> >          .unique = req->unique,
> >          .error = error,
> >      };
> > -
> > -    if (error <= -1000 || error > 0) {
> > +    /* error = 1 has been used to signal client to wait for notificaiton */
> 
> s/notificaiton/notification/

Will fix. I have made too many spelling mistakes. :-(

> 
> > +    if (error <= -1000 || error > 1) {
> >          fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n", error);
> >          out.error = -ERANGE;
> >      }
> > @@ -290,6 +290,11 @@ int fuse_reply_err(fuse_req_t req, int err)
> >      return send_reply(req, -err, NULL, 0);
> >  }
> >  
> > +int fuse_reply_wait(fuse_req_t req)
> > +{
> > +    return send_reply(req, 1, NULL, 0);
> > +}
> > +
> >  void fuse_reply_none(fuse_req_t req)
> >  {
> >      fuse_free_req(req);
> > @@ -2165,6 +2170,34 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid,
> >      send_reply_ok(req, NULL, 0);
> >  }
> >  
> > +static int send_notify_iov(struct fuse_session *se, int notify_code,
> > +                           struct iovec *iov, int count)
> > +{
> > +    struct fuse_out_header out;
> > +    if (!se->got_init) {
> > +        return -ENOTCONN;
> > +    }
> > +    out.unique = 0;
> > +    out.error = notify_code;
> 
> Please fully initialize all fuse_out_header fields so it's obvious that
> there is no accidental information leak from virtiofsd to the guest:
> 
>   struct fuse_out_header out = {
>       .error = notify_code,
>   };
> 
> The host must not expose uninitialized memory to the guest (just like
> the kernel vs userspace). fuse_send_msg() initializes out.len later, but
> to be on the safe side I think we should be explicit here.

Agreed. Its better to be explicit here and initialize fuse_out_header
fully. Will do.

Vivek

