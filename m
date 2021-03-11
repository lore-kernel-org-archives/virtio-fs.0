Date: Thu, 11 Mar 2021 18:52:17 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YEpm4YCYN2zuyD8w@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-8-dgilbert@redhat.com>
	<CAJFHJrqioXu7K8Z=dFgMQDWoKoNK3pddcgf9znCS72BR4WHSYA@mail.gmail.com>
	<YEoJzfLRy/Kk6SOf@work-vm> <20210311135050.GA145441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311135050.GA145441@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 07/24] DAX: virtio-fs: Add vhost-user slave
 commands for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, marcandre.lureau@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Thu, Mar 11, 2021 at 12:15:09PM +0000, Dr. David Alan Gilbert wrote:
> > * Chirantan Ekbote (chirantan@chromium.org) wrote:
> > > On Wed, Feb 10, 2021 at 4:04 AM Dr. David Alan Gilbert (git)
> > > <dgilbert@redhat.com> wrote:
> > > >
> > > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > > +
> > > > +typedef struct {
> > > > +    /* Offsets within the file being mapped */
> > > > +    uint64_t fd_offset[VHOST_USER_FS_SLAVE_ENTRIES];
> > > > +    /* Offsets within the cache */
> > > > +    uint64_t c_offset[VHOST_USER_FS_SLAVE_ENTRIES];
> > > > +    /* Lengths of sections */
> > > > +    uint64_t len[VHOST_USER_FS_SLAVE_ENTRIES];
> > > > +    /* Flags, from VHOST_USER_FS_FLAG_* */
> > > > +    uint64_t flags[VHOST_USER_FS_SLAVE_ENTRIES];
> > > > +} VhostUserFSSlaveMsg;
> > > > +
> > > 
> > > Is it too late to change this?  This struct allocates space for up to
> > > 8 entries but most of the time the server will only try to set up one
> > > mapping at a time so only 32 out of the 256 bytes in the message are
> > > actually being used.  We're just wasting time memcpy'ing bytes that
> > > will never be used.  Is there some reason this can't be dynamically
> > > sized?  Something like:
> > > 
> > > typedef struct {
> > >     /* Number of mapping requests */
> > >     uint16_t num_requests;
> > >     /* `num_requests` mapping requests */
> > >    MappingRequest requests[];
> > > } VhostUserFSSlaveMsg;
> > > 
> > > typedef struct {
> > >     /* Offset within the file being mapped */
> > >     uint64_t fd_offset;
> > >     /* Offset within the cache */
> > >     uint64_t c_offset;
> > >     /* Length of section */
> > >     uint64_t len;
> > >     /* Flags, from VHOST_USER_FS_FLAG_* */
> > >     uint64_t flags;
> > > } MappingRequest;
> > > 
> > > The current pre-allocated structure both wastes space when there are
> > > fewer than 8 requests and requires extra messages to be sent when
> > > there are more than 8 requests.  I realize that in the grand scheme of
> > > things copying 224 extra bytes is basically not noticeable but it just
> > > irks me that we could fix this really easily before it gets propagated
> > > to too many other places.
> > 
> > So this has come out as:
> > 
> > typedef struct {
> >     /* Offsets within the file being mapped */
> >     uint64_t fd_offset;
> >     /* Offsets within the cache */
> >     uint64_t c_offset;
> >     /* Lengths of sections */
> >     uint64_t len;
> >     /* Flags, from VHOST_USER_FS_FLAG_* */
> >     uint64_t flags;
> > } VhostUserFSSlaveMsgEntry;
> >  
> > typedef struct {
> >     /* Generic flags for the overall message */
> >     uint32_t flags;
> >     /* Number of entries */
> >     uint16_t count;
> >     /* Spare */
> >     uint16_t align;
> >  
> >     VhostUserFSSlaveMsgEntry entries[];
> > } VhostUserFSSlaveMsg;
> > 
> > which seems to work OK.
> > I've still got a:
> > #define VHOST_USER_FS_SLAVE_MAX_ENTRIES 8
> 
> Hi Dave,
> 
> So if we were to raise this limit down the line, will it be just a matter
> of changing this numebr and recompile qemu + virtiofsd? Or this is just
> a limit on sender and qemu does not care.

They have to agree; 
> If qemu cares about number of entries, then it will be good to raise this
> limit to say 32 or 64.

I've bumped it to 32.

Dave

> Otherwise new definitions look good.
> 
> Thanks
> Vivek
> 
> > 
> > to limit the size VhostUserFSSlaveMsg can get to.
> > The variable length array makes the union in the reader a bit more
> > hairy, but it's OK.
> > 
> > Dave
> > 
> > > Chirantan
> > > 
> > > > --
> > > > 2.29.2
> > > >
> > > > _______________________________________________
> > > > Virtio-fs mailing list
> > > > Virtio-fs@redhat.com
> > > > https://www.redhat.com/mailman/listinfo/virtio-fs
> > > >
> > > 
> > -- 
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

