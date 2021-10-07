Date: Thu, 7 Oct 2021 14:32:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YV89S46OMGOVN8zZ@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
	<20210930143850.1188628-8-vgoyal@redhat.com>
	<CAJfpegtdftj7jQFu+4LBjysiAJ-hhLHkBC_KhowfJtepvZqaoQ@mail.gmail.com>
	<YV3LBNM3jnGBBzwS@redhat.com>
	<CAJfpegtoNSXFwiiFuU0tczogS6NFqeodLaxcr0Ax5d=dG0-utw@mail.gmail.com>
	<YV8Ca/wP9HDWJITq@redhat.com>
	<CAJfpegsguYZ3y5G6Rj4hoxEOn2ObnUVajTVhtyvm4ZSeFqGtFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsguYZ3y5G6Rj4hoxEOn2ObnUVajTVhtyvm4ZSeFqGtFw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 7/8] virtiofs: Add new notification type
	FUSE_NOTIFY_LOCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org

On Thu, Oct 07, 2021 at 08:11:13PM +0200, Miklos Szeredi wrote:
> On Thu, 7 Oct 2021 at 16:22, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Oct 07, 2021 at 03:45:40PM +0200, Miklos Szeredi wrote:
> > > On Wed, 6 Oct 2021 at 18:13, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > On Wed, Oct 06, 2021 at 03:02:36PM +0200, Miklos Szeredi wrote:
> > > > > On Thu, 30 Sept 2021 at 16:39, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > >
> > > > > > Add a new notification type FUSE_NOTIFY_LOCK. This notification can be
> > > > > > sent by file server to signifiy that a previous locking request has
> > > > > > completed and actual caller should be woken up.
> > > > >
> > > > > Shouldn't this also be generic instead of lock specific?
> > > > >
> > > > > I.e. generic header  + original outarg.
> > > >
> > > > Hi Miklos,
> > > >
> > > > I am not sure I understand the idea. Can you please elaborate a bit more.
> > > >
> > > > IIUC, "fuse_out_header + original outarg"  is format for responding
> > > > to regular fuse requests. If we use that it will become like responding
> > > > to same request twice. First time we responded with ->error=1 so that
> > > > caller can wait and second time we respond with actual outarg (if
> > > > there is one depending on the type of request).
> > > >
> > > > IOW, this will become more like implementing blocking of request in
> > > > client in a more generic manner.
> > > >
> > > > But outarg, depends on type of request (In case of locking there is
> > > > none). And outarg memory is allocated by driver and filled by server.
> > > > In case of notifications, driver is allocating the memory but it
> > > > does not know what will come in notification and how much memory
> > > > to allocate. So it relies on device telling it how much memory
> > > > to allocate in general so that bunch of pre-defined notification
> > > > types can fit in (fs->notify_buf_size).
> > > >
> > > > I modeled this on the same lines as other fuse notifications where
> > > > server sends notifications with following format.
> > > >
> > > > fuse_out_header + <structure based on notification type>
> > > >
> > > > out_header->unique is 0 for notifications to differentiate notifications
> > > > from request reply.
> > > >
> > > > out_header->error contains the code of actual notification being sent.
> > > > ex. FUSE_NOTIFY_INVAL_INODE or FUSE_NOTIFY_LOCK or FUSE_NOTIFY_DELETE.
> > > > Right now virtiofs supports only one notification type. But in future
> > > > we can introduce more types (to support inotify stuff etc).
> > > >
> > > > In short, I modeled this on existing notion of fuse notifications
> > > > (and not fuse reply). And given notifications are asynchronous,
> > > > we don't know what were original outarg. In fact they might
> > > > be generated not necessarily in response to a request. And that's
> > > > why this notion of defining a type of notification (FUSE_NOTIFY_LOCK)
> > > > and then let driver decide how to handle this notification.
> > > >
> > > > I might have completely misunderstood your suggestion. Please help
> > > > me understand.
> > >
> > > Okay, so we are expecting this mechanism to be only used for blocking
> > > locks.
> >
> > Yes, as of now it is only being used only for blocking locks. So there
> > are two parts to it.
> >
> > A. For a blocking operation, server can reply with error=1, and that's
> >    a signal to client to wait for a notification to arrive later. And
> >    fuse client will not complete the request and instead will queue it
> >    in one of the internal lists.
> >
> > B. Later server will send a fuse notification event (FUSE_NOTIFY_LOCK)
> >    when it has acquired the lock. This notification will have unique
> >    number of request for which this notification has been generated.
> >    Fuse client will search for the request with expected unique number
> >    in the list and complete the request.
> >
> > I think part A is generic in the sense it could be used for other
> > kind of blocking requests as well down the line, where server is
> > doing the blocking operation on behalf of client and will send
> > notification later. Part B is very specific to blocking locks though.
> 
> I don't really get why B is specific to blocking locks. But anyway...
> we are only implementing it for blocking locks for now.

Hmm.., I am wondering do I have to make notification specific to
lock. All it is doing is returning an "error" code which signifies
either operation completed successfully or represents error code
if error occurred.

This probably could be more generic. May be I can call this
notification FUSE_NOTIFY_OP_COMPLETE. This notification is
just signalling that a previously issued request has completed.
Request is identified by notify->unique and result of blocking operation
is in notify->error. So that way it is more generic and can be
used for other kind of operations too (and not just locking).

> 
> >
> > > That makes sense, but then locking ops should be setting a
> > > flag indicating that this is locking op.  I.e. in fuse_setlk():
> > >
> > >     args.blocking_lock = true;
> > >
> > > And this should be verified when the reply with the positive error comes back.
> >
> > So this args.blocking_lock, goes to server as well? Or this is something
> > internal to fuse client so that client can decide whether ->error=1 is
> > a valid response or not. IOW, client is trying to do verification
> > whether server should have generated ->error=1 or not for this specific
> > request.
> 
> Right, it's for the client.

Got it. Will implement it.

Thanks
Vivek

