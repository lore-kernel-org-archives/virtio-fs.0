Date: Thu, 27 May 2021 17:57:21 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK/PcSYNVKhomZak@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-10-dgilbert@redhat.com>
	<YJKomatE4qqje5cY@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKomatE4qqje5cY@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 09/26] DAX: virtio-fs: Add vhost-user
 slave commands for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:43PM +0100, Dr. David Alan Gilbert (git) wrote:
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index dd0a02aa99..169a146e72 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -45,6 +45,72 @@ static const int user_feature_bits[] = {
> >  #define DAX_WINDOW_PROT PROT_NONE
> >  #endif
> >  
> > +/*
> > + * The message apparently had 'received_size' bytes, check this
> > + * matches the count in the message.
> > + *
> > + * Returns true if the size matches.
> > + */
> > +static bool check_slave_message_entries(const VhostUserFSSlaveMsg *sm,
> > +                                        int received_size)
> > +{
> > +    int tmp;
> > +
> > +    /*
> > +     * VhostUserFSSlaveMsg consists of a body followed by 'n' entries,
> > +     * (each VhostUserFSSlaveMsgEntry).  There's a maximum of
> > +     * VHOST_USER_FS_SLAVE_MAX_ENTRIES of these.
> > +     */
> > +    if (received_size <= sizeof(VhostUserFSSlaveMsg)) {
> 
> received_size is an int and we risk hitting checking against the coerced
> size_t value but then using the signed int received_size later. It's
> safer to convert to size_t once and then use that size_t value
> everywhere later.

Done.

> > +typedef struct {
> > +    /* Offsets within the file being mapped */
> > +    uint64_t fd_offset;
> > +    /* Offsets within the cache */
> > +    uint64_t c_offset;
> > +    /* Lengths of sections */
> > +    uint64_t len;
> > +    /* Flags, from VHOST_USER_FS_FLAG_* */
> > +    uint64_t flags;
> > +} VhostUserFSSlaveMsgEntry;
> > +
> > +typedef struct {
> > +    /* Number of entries */
> > +    uint16_t count;
> > +    /* Spare */
> > +    uint16_t align;
> 
> VhostUserFSSlaveMsgEntry is aligned to 64 bits, so the 16-bit align
> field is not sufficient for full alignment.

Ah, interesting; fixed to:

typedef struct {
    /* Generic flags for the overall message */
    uint32_t flags;
    /* Number of entries */
    uint16_t count;
    /* Spare */
    uint16_t align;
} VhostUserFSSlaveMsgHdr;

or do I actually need to have a uint64_t in there?

Dave


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

