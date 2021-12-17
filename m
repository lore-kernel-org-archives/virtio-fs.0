Date: Fri, 17 Dec 2021 09:15:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbybZQHaSxV5MXkI@redhat.com>
References: <CAOQ4uxjfCs=+Of69U6moOJ9T6_zDb1wcrLXWu4DROVme1cNnfQ@mail.gmail.com>
	<YbobZMGEl6sl+gcX@redhat.com>
	<CAOQ4uxj9XZNhHB3y9LuGcUJYp-i4f-LXQa2tzX8AkZpRERH+8w@mail.gmail.com>
	<Ybo/5h9umGlinaM4@redhat.com>
	<CAOQ4uxheVq-YHkT9eOu3vUNt1RU4Wa6MkyzXXLboHE_Pj6-6tw@mail.gmail.com>
	<CAOQ4uxjzW7mt0pqA+K_sEJokYcv_D3e7axAOWLXxQ84bZDnfcw@mail.gmail.com>
	<YbtoQGKflkChU8lZ@redhat.com>
	<CAOQ4uxhucsMYO1YdHdLDPBJEaoOOyXb57wFJgijQznis2feE1A@mail.gmail.com>
	<Ybu8gBglHi+xikww@redhat.com>
	<CAOQ4uxj6FKZr_QWRN_Ts14+dcT1cxR6PmtZCJEyp2chCGKVh7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj6FKZr_QWRN_Ts14+dcT1cxR6PmtZCJEyp2chCGKVh7w@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stef Bon <stefbon@gmail.com>

On Fri, Dec 17, 2021 at 06:21:28AM +0200, Amir Goldstein wrote:
> > Ok, lets spend some time on figuring out how the fsnotify_out struct
> > should look like to meet the needs of fanotify as well.
> >
> > >
> > > I thought you passed the name as buffer in iov array.
> > > Or maybe that's not how it works?
> > >
> > > My suggestion:
> > > 1. Reserve a zero padded 64bit member for future child nodeid
> > >     in struct fuse_notify_fsnotify_out
> >
> > Ok, I think this doable. So right now it can send only one nodeid. You
> > basically want to have capability to send two 64bit nodeids in same
> > event, right. This is useful where you might want to send nodeid
> > of dir and nodeid of child object, IIUC.
> 
> Correct, but I forgot to mention (I mentioned it earlier in review) that the
> protocol should send nodeid+generation
> this is not related to file handles.
> It is needed to avoid reporting an event on the wrong object
> when FUSE reuses nodeid.

Makes sense. Will add generation id as well for each nodeid.

> 
> >
> > Maybe we should add a 64bit field for some sort of flags also which
> > might give additional informatin about the event.
> >
> > It might look like.
> >
> > struct fuse_notify_fsnotify_out {
> >         uint64_t inode;
> >         uint64_t mask;
> 
> So you may want to cram 32bit gen above and make mask 32bit
> depending on how much you really need to save space in the event queue.

May be. Not sure if mask needs to be 64bit or not. 

Alternatively, use 32bit generation and reserve 32bit for future use.

uint32_t generation;
uint32_t reserved;
uint64_t mask

I think our biggest memory usage will come from "name" and rest seems
very small in comparison. So I am not too worried about saving little
bit of space here.

> 
> >         uint32_t namelen;
> >         uint32_t cookie;
> >         /* Can carry additional info about the event */
> >         uint64_t flags;
> >         /* Reserved for future use. Possibly another inode node id */
> >         uint64_t reserved;
> 
> Same here, we will need ino+gen for child

Right. May be I can reduce the flag to 32 bit instead and use rest 32bit
for generation.

uint32_t flags
uint32_t reserved (for genearation possibly)
uint64_t reserved (for another inode id).

So this might look as follows.

struct fuse_notify_fsnotify_out {
        uint64_t inode;
        uint32_t generation;
        uint32_t reserved;
        uint64_t mask;
        uint32_t namelen;
        uint32_t cookie;
        /* Can carry additional info about the event */
        uint32_t flags;
        /* Reserved for future use. Another inode node id and generation */
        uint32_t reserved;
        uint64_t reserved;
};

> 
> > };
> >
> > > 2. For FS_RENAME, will we be able to pass 4 buffers in iov?
> > >     src_fuse_notify_fsnotify_out, src_name,
> > >     dst_fuse_notify_fsnotify_out, dst_name
> >
> > So it is sort of two fsnotify events travelling in same event. We will
> > have to have some sort of information in the src_fuse_notify_fsnotify_out
> > which signals that another fsnotify_out is following. May be that's
> > where fsnotify_flags->field can be used. Set a bit to signal another
> > fsnotify_out is part of same event and this will also mean first one
> > is src and second one is dst.
> >
> > Challenge I see is "src_name" and "dst_name", especially in the context
> > of virtio queues.
> >
> > So we have a notification queue and for each notification, driver
> > allocates a fixed amount of memory for each element and queues these
> > elements in virtqueue. Server side pops these elements, places
> > notification info in this vq element and sends back.
> >
> > So basically size of notification buffer needs to be known in advance,
> > because these are allocated by driver (and not device/server). And
> > that's the reason virtio spec has added a new filed "notify_buf_size"
> > in device configuration space. Using this field device lets the driver
> > know how much memory to allocate for each notification element.
> >
> > IOW, we can put variable sized elements in notifiation but max size
> > of that variable length needs to be fixed in advance and needs to
> > be told to driver at device initialization time.
> >
> > So what can be the max length of "src_name" and "dst_name"? Is it fair
> > to use NAME_MAX to determine max length of name. So say "255" bytes
> > (not including null) for each name. That means notify_buf_size will
> > be.
> >
> > notify_buf_size = 2 * 255 + 2 * sizeof(struct fuse_notify_fsnotify_out);
> >
> 
> Can you push two subsequent elements to the events queue atomically?
> If you can, then it is not a problem to queue the FS_MOVED_FROM
> event (with one name) followed by FS_MOVED_TO event with
> a self generated cookie in response to FAN_RENAME event on virtiofsd
> server and rejoin them in virtiofs client.

Hmm..., so basically break down FAN_RENAME event into two events joined
by cookie and send them separately. I guess sounds reasonable because
it helps reduce the max size of event.

What do you mean by "atomically"? Do you mean strict ordering and these
two events are right after each other. But if they are joined by cookie,
we don't have to enforce it. Driver should be able to maintain an internal
list and queue the event and wait for pair event to arrive. This also
means that these broken down events will have to be joined back, possibly
by some fsnotify helper.

We will probably need a flag to differentiate whether its the case of
broken down FAN_RENAME or not. Because in this case driver will wait
for second event to arrive. But if it is regular FS_MOVED_FROM event,
then don't wait and deliver it to user space.

Driver will have to be careful to not block actual event queue event
while waiting for pair event to arrive. It should create a copy and
add virtqueue element back to notification queue. Otherwise deadlock
is possible where all elements in virtqueue are being used to wait for
pair event and no free elements are available to actually send paired
event.

> 
> You see, I don't mind using the rename cookie API as long as rejoining
> the disjoint events is possible for reporting the joint event to fanotify user.

Right this will allow server to join independent FAN_MOVED_FROM and
FAN_MOVED_TO if need be.

> 
> In case virtiofsd backend is implemented with inotify, it will receive and
> report only disjoint events and in that case, FAN_RENAME cannot be
> requested by fanotify user which is fine, as long as it will be possible
> with another implementation of virtiofsd server down the road.

Fair enough. In simplest form, virtiofsd will support FAN_RENAME only if
host kernel fanotify supports FAN_RENAME. 

In more advanced form, virtiofsd (or other server) can wait for two
events and then join and report as FAN_RENAME with user space generated
cookie.

I think I like this idea of reporting two events joined by cookie to
reduce the size of event. Will give it a try.

Thanks
Vivek

