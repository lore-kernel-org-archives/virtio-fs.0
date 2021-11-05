Date: Fri, 5 Nov 2021 10:30:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YYU/7269JX2neLjz@redhat.com>
References: <CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
	<20211027132319.GA7873@quack2.suse.cz>
	<YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
	<CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<20211103100900.GB20482@quack2.suse.cz>
	<CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com>
	<20211104100316.GA10060@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104100316.GA10060@quack2.suse.cz>
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jan Kara <jack@suse.cz>
Cc: Steve French <sfrench@samba.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Nov 04, 2021 at 11:03:16AM +0100, Jan Kara wrote:
> On Wed 03-11-21 18:36:06, Vivek Goyal wrote:
> > On Wed, Nov 03, 2021 at 01:17:36PM +0200, Amir Goldstein wrote:
> > > > > > > Hi Jan,
> > > > > > >
> > > > > > > Agreed. That's what Ioannis is trying to say. That some of the remote events
> > > > > > > can be lost if fuse/guest local inode is unlinked. I think problem exists
> > > > > > > both for shared and non-shared directory case.
> > > > > > >
> > > > > > > With local filesystems we have a control that we can first queue up
> > > > > > > the event in buffer before we remove local watches. With events travelling
> > > > > > > from a remote server, there is no such control/synchronization. It can
> > > > > > > very well happen that events got delayed in the communication path
> > > > > > > somewhere and local watches went away and now there is no way to
> > > > > > > deliver those events to the application.
> > > > > >
> > > > > > So after thinking for some time about this I have the following question
> > > > > > about the architecture of this solution: Why do you actually have local
> > > > > > fsnotify watches at all? They seem to cause quite some trouble... I mean
> > > > > > cannot we have fsnotify marks only on FUSE server and generate all events
> > > > > > there? When e.g. file is created from the client, client tells the server
> > > > > > about creation, the server performs the creation which generates the
> > > > > > fsnotify event, that is received by the server and forwared back to the
> > > > > > client which just queues it into notification group's queue for userspace
> > > > > > to read it.
> > > > > >
> > > > > > Now with this architecture there's no problem with duplicate events for
> > > > > > local & server notification marks, similarly there's no problem with lost
> > > > > > events after inode deletion because events received by the client are
> > > > > > directly queued into notification queue without any checking whether inode
> > > > > > is still alive etc. Would this work or am I missing something?
> > > > > >
> > > > >
> > > > > What about group #1 that wants mask A and group #2 that wants mask B
> > > > > events?
> > > > >
> > > > > Do you propose to maintain separate event queues over the protocol?
> > > > > Attach a "recipient list" to each event?
> > > >
> > > > Yes, that was my idea. Essentially when we see group A creates mark on FUSE
> > > > for path P, we notify server, it will create notification group A on the
> > > > server (if not already existing - there we need some notification group
> > > > identifier unique among all clients), and place mark for it on path P. Then
> > > > the full stream of notification events generated for group A on the server
> > > > will just be forwarded to the client and inserted into the A's notification
> > > > queue. IMO this is very simple solution to implement - you just need to
> > > > forward mark addition / removal events from the client to the server and you
> > > > forward event stream from the server to the client. Everything else is
> > > > handled by the fsnotify infrastructure on the server.
> > > >
> > > > > I just don't see how this can scale other than:
> > > > > - Local marks and connectors manage the subscriptions on local machine
> > > > > - Protocol updates the server with the combined masks for watched objects
> > > >
> > > > I agree that depending on the usecase and particular FUSE filesystem
> > > > performance of this solution may be a concern. OTOH the only additional
> > > > cost of this solution I can see (compared to all those processes just
> > > > watching files locally) is the passing of the events from the server to the
> > > > client. For local FUSE filesystems such as virtiofs this should be rather
> > > > cheap since you have to do very little processing for each generated event.
> > > > For filesystems such as sshfs, I can imagine this would be a bigger deal.
> > > >
> > > > Also one problem I can see with my proposal is that it will have problems
> > > > with stuff such as leases - i.e., if the client does not notify the server
> > > > of the changes quickly but rather batches local operations and tells the
> > > > server about them only on special occasions. I don't know enough about FUSE
> > > > filesystems to tell whether this is a frequent problem or not.
> > > >
> > > > > I think that the "post-mortem events" issue could be solved by keeping an
> > > > > S_DEAD fuse inode object in limbo just for the mark.
> > > > > When a remote server sends FS_IN_IGNORED or FS_DELETE_SELF for
> > > > > an inode, the fuse client inode can be finally evicted.
> > > > > I haven't tried to see how hard that would be to implement.
> > > >
> > > > Sure, there can be other solutions to this particular problem. I just
> > > > want to discuss the other architecture to see why we cannot to it in a
> > > > simple way :).
> > > >
> > > 
> > > Fair enough.
> > > 
> > > Beyond the scalability aspects, I think that a design that exposes the group
> > > to the remote server and allows to "inject" events to the group queue
> > > will prevent
> > > users from useful features going forward.
> > > 
> > > For example, fanotify ignored_mask could be added to a group, even on
> > > a mount mark, even if the remote server only supports inode marks and it
> > > would just work.
> > > 
> > > Another point of view for the post-mortem events:
> > > As Miklos once noted and as you wrote above, for cache coherency and leases,
> > > an async notification queue is not adequate and synchronous notifications are
> > > too costly, so there needs to be some shared memory solution involving guest
> > > cache invalidation by host.
> > 
> > Any shared memory solution works only limited setup. If server is remote
> > on other machine, there is no sharing. I am hoping that this can be
> > generic enough to support other remote filesystems down the line.
> 
> OK, so do I understand both you and Amir correctly that you think that
> always relying on the FUSE server for generating the events and just piping
> them to the client is not long-term viable design for FUSE? Mostly because
> caching of modifications on the client is essentially inevitable and hence
> generating events from the server would be unreliable (delayed too much)?

Hi Jan,

Actually I had not even thought about operation caching in clients. IIUC,
as of now we only have modes to support caching of buffered writes in fuse
(which can be flushed later, -o writeback). Other file operations should go
to server.

To me, it sounds reasonable for FUSE server to generate events and that's
what we are doing in this RFC proposal. So idea is that an application
is effectively watching and receiving events for changes happening at
remote server.

As of now local events will be supressed so if some operations are local
to client only, then events will not be generated or will be generated
late when server sees those changes.

I am not sure if supressing all local events will serve all use cases
in long term though. For example, Amir was mentioning about fanotify,
events on mount objects and it might make sense to generate local
events there.

So initial implementation could be about, application either get local
events or remote events (based on filesystem). Down the line more
complicated modes can emerge where some combination of local and remote
events could be generated and applications could specify it. That
probably will be extension of fanotiy/inotify API.

Thanks
Vivek

