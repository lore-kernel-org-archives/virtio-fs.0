Date: Mon, 15 Feb 2021 09:24:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210215142415.GA3331@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-8-dgilbert@redhat.com>
	<CAJFHJrqioXu7K8Z=dFgMQDWoKoNK3pddcgf9znCS72BR4WHSYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrqioXu7K8Z=dFgMQDWoKoNK3pddcgf9znCS72BR4WHSYA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 07/24] DAX: virtio-fs: Add vhost-user slave
 commands for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, marcandre.lureau@redhat.com

On Mon, Feb 15, 2021 at 07:35:53PM +0900, Chirantan Ekbote wrote:
> On Wed, Feb 10, 2021 at 4:04 AM Dr. David Alan Gilbert (git)
> <dgilbert@redhat.com> wrote:
> >
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > +
> > +typedef struct {
> > +    /* Offsets within the file being mapped */
> > +    uint64_t fd_offset[VHOST_USER_FS_SLAVE_ENTRIES];
> > +    /* Offsets within the cache */
> > +    uint64_t c_offset[VHOST_USER_FS_SLAVE_ENTRIES];
> > +    /* Lengths of sections */
> > +    uint64_t len[VHOST_USER_FS_SLAVE_ENTRIES];
> > +    /* Flags, from VHOST_USER_FS_FLAG_* */
> > +    uint64_t flags[VHOST_USER_FS_SLAVE_ENTRIES];
> > +} VhostUserFSSlaveMsg;
> > +
> 
> Is it too late to change this?  This struct allocates space for up to
> 8 entries but most of the time the server will only try to set up one
> mapping at a time so only 32 out of the 256 bytes in the message are
> actually being used.  We're just wasting time memcpy'ing bytes that
> will never be used.  Is there some reason this can't be dynamically
> sized?  Something like:
> 
> typedef struct {
>     /* Number of mapping requests */
>     uint16_t num_requests;
>     /* `num_requests` mapping requests */
>    MappingRequest requests[];
> } VhostUserFSSlaveMsg;
> 
> typedef struct {
>     /* Offset within the file being mapped */
>     uint64_t fd_offset;
>     /* Offset within the cache */
>     uint64_t c_offset;
>     /* Length of section */
>     uint64_t len;
>     /* Flags, from VHOST_USER_FS_FLAG_* */
>     uint64_t flags;
> } MappingRequest;
> 
> The current pre-allocated structure both wastes space when there are
> fewer than 8 requests and requires extra messages to be sent when
> there are more than 8 requests.  I realize that in the grand scheme of
> things copying 224 extra bytes is basically not noticeable but it just
> irks me that we could fix this really easily before it gets propagated
> to too many other places.

Sounds like a reasonable idea. We probably will have to dynamically
allocate memory for removemapping, hopefully that does not have a
performance impact.

Vivek

