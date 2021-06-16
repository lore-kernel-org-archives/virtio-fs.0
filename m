Date: Wed, 16 Jun 2021 13:36:10 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YMnwOs9bxKLB8wSL@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-27-dgilbert@redhat.com>
	<YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
	<20210506160223.GA277745@redhat.com>
	<YJj3RSxXKZHxmiKu@stefanha-x1.localdomain>
	<20210510152324.GB150402@horse>
	<YJlSHZ0vzNtCAjkJ@stefanha-x1.localdomain>
	<YK/uUUZI3zy9k8Vk@work-vm> <YMIv5odJWdkbJzWL@work-vm>
	<YMI8fS6m8CjtUtmE@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMI8fS6m8CjtUtmE@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, Jun 10, 2021 at 04:29:42PM +0100, Dr. David Alan Gilbert wrote:
> > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > 
> > <snip>
> > 
> > > > Instead I was thinking about VHOST_USER_DMA_READ/WRITE messages
> > > > containing the address (a device IOVA, it could just be a guest physical
> > > > memory address in most cases) and the length. The WRITE message would
> > > > also contain the data that the vhost-user device wishes to write. The
> > > > READ message reply would contain the data that the device read from
> > > > QEMU.
> > > > 
> > > > QEMU would implement this using QEMU's address_space_read/write() APIs.
> > > > 
> > > > So basically just a new vhost-user protocol message to do a memcpy(),
> > > > but with guest addresses and vIOMMU support :).
> > > 
> > > This doesn't actually feel that hard - ignoring vIOMMU for a minute
> > > which I know very little about - I'd have to think where the data
> > > actually flows, probably the slave fd.
> > > 
> > > > The vhost-user device will need to do bounce buffering so using these
> > > > new messages is slower than zero-copy I/O to shared guest RAM.
> > > 
> > > I guess the theory is it's only in the weird corner cases anyway.
> 
> The feature is also useful if DMA isolation is desirable (i.e.
> security/reliability are more important than performance). Once this new
> vhost-user protocol feature is available it will be possible to run
> vhost-user devices without shared memory or with limited shared memory
> (e.g. just the vring).

I don't see it ever being efficient, so that case is going to be pretty
limited.

> > The direction I'm going is something like the following;
> > the idea is that the master will have to handle the requests on a
> > separate thread, to avoid any problems with side effects from the memory
> > accesses; the slave will then have to parkt he requests somewhere and
> > handle them later.
> > 
> > 
> > From 07aacff77c50c8a2b588b2513f2dfcfb8f5aa9df Mon Sep 17 00:00:00 2001
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > Date: Thu, 10 Jun 2021 15:34:04 +0100
> > Subject: [PATCH] WIP: vhost-user: DMA type interface
> > 
> > A DMA type interface where the slave can ask for a stream of bytes
> > to be read/written to the guests memory by the master.
> > The interface is asynchronous, since a request may have side effects
> > inside the guest.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  docs/interop/vhost-user.rst               | 33 +++++++++++++++++++++++
> >  hw/virtio/vhost-user.c                    |  4 +++
> >  subprojects/libvhost-user/libvhost-user.h | 24 +++++++++++++++++
> >  3 files changed, 61 insertions(+)
> 
> Use of the word "RAM" in this patch is a little unclear since we need
> these new messages precisely when it's not ordinary guest RAM :-). Maybe
> referring to the address space is more general.

Yeh, I'll try and spot those.

> > diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> > index 9ebd05e2bf..b9b5322147 100644
> > --- a/docs/interop/vhost-user.rst
> > +++ b/docs/interop/vhost-user.rst
> > @@ -1347,6 +1347,15 @@ Master message types
> >    query the backend for its device status as defined in the Virtio
> >    specification.
> >  
> > +``VHOST_USER_MEM_DATA``
> > +  :id: 41
> > +  :equivalent ioctl: N/A
> > +  :slave payload: N/A
> > +  :master payload: ``struct VhostUserMemReply``
> > +
> > +  This message is an asynchronous response to a ``VHOST_USER_SLAVE_MEM_ACCESS``
> > +  message.  Where the request was for the master to read data, this
> > +  message will be followed by the data that was read.
> 
> Please explain why this message is asynchronous. Implementors will need
> to understand the gotchas around deadlocks, etc.

I've added:
  Making this a separate asynchronous response message (rather than just a reply
  to the ``VHOST_USER_SLAVE_MEM_ACCESS``) makes it much easier for the master
  to deal with any side effects the access may have, and in particular avoid
  deadlocks they might cause if an access triggers another vhost_user message.

> >  
> >  Slave message types
> >  -------------------
> > @@ -1469,6 +1478,30 @@ Slave message types
> >    The ``VHOST_USER_FS_FLAG_MAP_W`` flag must be set in the ``flags`` field to
> >    write to the file from RAM.
> >  
> > +``VHOST_USER_SLAVE_MEM_ACCESS``
> > +  :id: 9
> > +  :equivalent ioctl: N/A
> > +  :slave payload: ``struct VhostUserMemAccess``
> > +  :master payload: N/A
> > +
> > +  Requests that the master perform a range of memory accesses on behalf
> > +  of the slave that the slave can't perform itself.
> > +
> > +  The ``VHOST_USER_MEM_FLAG_TO_MASTER`` flag must be set in the ``flags``
> > +  field for the slave to write data into the RAM of the master.   In this
> > +  case the data to write follows the ``VhostUserMemAccess`` on the fd.
> > +  The ``VHOST_USER_MEM_FLAG_FROM_MASTER`` flag must be set in the ``flags``
> > +  field for the slave to read data from the RAM of the master.
> > +
> > +  When the master has completed the access it replies on the main fd with
> > +  a ``VHOST_USER_MEM_DATA`` message.
> > +
> > +  The master is allowed to complete part of the request and reply stating
> > +  the amount completed, leaving it to the slave to resend further components.
> > +  This may happen to limit memory allocations in the master or to simplify
> > +  the implementation.
> > +
> > +
> >  .. _reply_ack:
> >  
> >  VHOST_USER_PROTOCOL_F_REPLY_ACK
> > diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> > index 39a0e55cca..a3fefc4c1d 100644
> > --- a/hw/virtio/vhost-user.c
> > +++ b/hw/virtio/vhost-user.c
> > @@ -126,6 +126,9 @@ typedef enum VhostUserRequest {
> >      VHOST_USER_GET_MAX_MEM_SLOTS = 36,
> >      VHOST_USER_ADD_MEM_REG = 37,
> >      VHOST_USER_REM_MEM_REG = 38,
> > +    VHOST_USER_SET_STATUS = 39,
> > +    VHOST_USER_GET_STATUS = 40,
> > +    VHOST_USER_MEM_DATA = 41,
> >      VHOST_USER_MAX
> >  } VhostUserRequest;
> >  
> > @@ -139,6 +142,7 @@ typedef enum VhostUserSlaveRequest {
> >      VHOST_USER_SLAVE_FS_MAP = 6,
> >      VHOST_USER_SLAVE_FS_UNMAP = 7,
> >      VHOST_USER_SLAVE_FS_IO = 8,
> > +    VHOST_USER_SLAVE_MEM_ACCESS = 9,
> >      VHOST_USER_SLAVE_MAX
> >  }  VhostUserSlaveRequest;
> >  
> > diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
> > index eee611a2f6..b5444f4f6f 100644
> > --- a/subprojects/libvhost-user/libvhost-user.h
> > +++ b/subprojects/libvhost-user/libvhost-user.h
> > @@ -109,6 +109,9 @@ typedef enum VhostUserRequest {
> >      VHOST_USER_GET_MAX_MEM_SLOTS = 36,
> >      VHOST_USER_ADD_MEM_REG = 37,
> >      VHOST_USER_REM_MEM_REG = 38,
> > +    VHOST_USER_SET_STATUS = 39,
> > +    VHOST_USER_GET_STATUS = 40,
> > +    VHOST_USER_MEM_DATA = 41,
> >      VHOST_USER_MAX
> >  } VhostUserRequest;
> >  
> > @@ -122,6 +125,7 @@ typedef enum VhostUserSlaveRequest {
> >      VHOST_USER_SLAVE_FS_MAP = 6,
> >      VHOST_USER_SLAVE_FS_UNMAP = 7,
> >      VHOST_USER_SLAVE_FS_IO = 8,
> > +    VHOST_USER_SLAVE_MEM_ACCESS = 9,
> >      VHOST_USER_SLAVE_MAX
> >  }  VhostUserSlaveRequest;
> >  
> > @@ -220,6 +224,24 @@ typedef struct VhostUserInflight {
> >      uint16_t queue_size;
> >  } VhostUserInflight;
> >  
> > +/* For the flags field of VhostUserMemAccess and VhostUserMemReply */
> > +#define VHOST_USER_MEM_FLAG_TO_MASTER (1u << 0)
> > +#define VHOST_USER_MEM_FLAG_FROM_MASTER (1u << 1)
> > +typedef struct VhostUserMemAccess {
> > +    uint32_t id; /* Included in the reply */
> > +    uint32_t flags;
> 
> Is VHOST_USER_MEM_FLAG_TO_MASTER | VHOST_USER_MEM_FLAG_FROM_MASTER
> valid?

No; I've changed the docs to state:
  One (and only one) of the ``VHOST_USER_MEM_FLAG_TO_MASTER`` and
  ``VHOST_USER_MEM_FLAG_FROM_MASTER`` flags must be set in the ``flags`` field.

> > +    uint64_t addr; /* In the bus address of the device */
> 
> Please check the spec for preferred terminology. "bus address" isn't
> used in the spec, so there's probably another term for it.

I'm not seeing anything useful in the virtio spec; it mostly talks about
guest physical addresses; it does say 'bus addresses' in the definition
of 'VIRTIO_F_ACCESS_PLATFORM' .

> > +    uint64_t len;  /* In bytes */
> > +} VhostUserMemAccess;
> > +
> > +typedef struct VhostUserMemReply {
> > +    uint32_t id; /* From the request */
> > +    uint32_t flags;
> 
> Are any flags defined?

Currently they're a copy of the TO/FROM _MASTER flags that were in the
request; which are useful to the device to make it easy to know whether
there's data following on the stream.

> > +    uint32_t err; /* 0 on success */
> > +    uint32_t align;
> 
> Is this a reserved padding field? "align" is confusing because it could
> refer to some kind of memory alignment value. "reserved" or "padding" is
> clearer.

Changed to 'padding'

Dave

> > +    uint64_t len;
> > +} VhostUserMemReply;
> > +
> >  #if defined(_WIN32) && (defined(__x86_64__) || defined(__i386__))
> >  # define VU_PACKED __attribute__((gcc_struct, packed))
> >  #else
> > @@ -248,6 +270,8 @@ typedef struct VhostUserMsg {
> >          VhostUserVringArea area;
> >          VhostUserInflight inflight;
> >          VhostUserFSSlaveMsgMax fs_max;
> > +        VhostUserMemAccess memaccess;
> > +        VhostUserMemReply  memreply;
> >      } payload;
> >  
> >      int fds[VHOST_MEMORY_BASELINE_NREGIONS];
> > -- 
> > 2.31.1
> > 
> > -- 
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > 


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

