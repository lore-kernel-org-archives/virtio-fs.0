Return-Path: <mst@redhat.com>
Date: Sat, 7 Oct 2023 17:27:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231007171812-mutt-send-email-mst@kernel.org>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-3-hreitz@redhat.com>
 <20231005173859.GC1342722@fedora>
 <851b7629-2302-5624-eb81-6839e250991e@redhat.com>
 <20231006044753-mutt-send-email-mst@kernel.org>
 <483bedcf-9c55-6977-f82c-5ce611ca5769@redhat.com>
MIME-Version: 1.0
In-Reply-To: <483bedcf-9c55-6977-f82c-5ce611ca5769@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 2/8] vhost-user.rst: Improve
 [GS]ET_VRING_BASE doc
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: virtio-fs@redhat.com, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>

On Fri, Oct 06, 2023 at 03:55:56PM +0200, Hanna Czenczek wrote:
> On 06.10.23 10:49, Michael S. Tsirkin wrote:
> > On Fri, Oct 06, 2023 at 09:53:53AM +0200, Hanna Czenczek wrote:
> > > On 05.10.23 19:38, Stefan Hajnoczi wrote:
> > > > On Wed, Oct 04, 2023 at 02:58:58PM +0200, Hanna Czenczek wrote:
> > > > > GET_VRING_BASE does not mention that it stops the respective ring.  Fix
> > > > > that.
> > > > > 
> > > > > Furthermore, it is not fully clear what the "base offset" these
> > > > > commands' documentation refers to is; an offset could be many things.
> > > > > Be more precise and verbose about it, especially given that these
> > > > > commands use different payload structures depending on whether the vring
> > > > > is split or packed.
> > > > > 
> > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > ---
> > > > >    docs/interop/vhost-user.rst | 66 ++++++++++++++++++++++++++++++++++---
> > > > >    1 file changed, 62 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> > > > > index 2f68e67a1a..50f5acebe5 100644
> > > > > --- a/docs/interop/vhost-user.rst
> > > > > +++ b/docs/interop/vhost-user.rst
> > > > > @@ -108,6 +108,37 @@ A vring state description
> > > > >    :num: a 32-bit number
> > > > > +A vring descriptor index for split virtqueues
> > > > > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > +
> > > > > ++-------------+---------------------+
> > > > > +| vring index | index in avail ring |
> > > > > ++-------------+---------------------+
> > > > > +
> > > > > +:vring index: 32-bit index of the respective virtqueue
> > > > > +
> > > > > +:index in avail ring: 32-bit value, of which currently only the lower 16
> > > > > +  bits are used:
> > > > > +
> > > > > +  - Bits 0–15: Next descriptor index in the *Available Ring*
> > > > I think we need to say more to make this implementable just by reading
> > > > the spec:
> > > > 
> > > >     Index of the next *Available Ring* descriptor that the back-end will
> > > >     process. This is a free-running index that is not wrapped by the ring
> > > >     size.
> > > Sure, thanks.
> > > 
> > > > Feel free to rephrase.
> > > > 
> > > > > +  - Bits 16–31: Reserved (set to zero)
> > > > > +
> > > > > +Vring descriptor indices for packed virtqueues
> > > > > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > +
> > > > > ++-------------+--------------------+
> > > > > +| vring index | descriptor indices |
> > > > > ++-------------+--------------------+
> > > > > +
> > > > > +:vring index: 32-bit index of the respective virtqueue
> > > > > +
> > > > > +:descriptor indices: 32-bit value:
> > > > > +
> > > > > +  - Bits 0–14: Index in the *Available Ring*
> > > > Same here.
> > > > 
> > > > > +  - Bit 15: Driver (Available) Ring Wrap Counter
> > > > > +  - Bits 16–30: Index in the *Used Ring*
> > > > Same here.
> > > > 
> > > > > +  - Bit 31: Device (Used) Ring Wrap Counter
> > > > > +
> > > > >    A vring address description
> > > > >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > @@ -1031,18 +1062,45 @@ Front-end message types
> > > > >    ``VHOST_USER_SET_VRING_BASE``
> > > > >      :id: 10
> > > > >      :equivalent ioctl: ``VHOST_SET_VRING_BASE``
> > > > > -  :request payload: vring state description
> > > > > +  :request payload: vring descriptor index/indices
> > > > >      :reply payload: N/A
> > > > > -  Sets the base offset in the available vring.
> > > > > +  Sets the next index to use for descriptors in this vring:
> > > > > +
> > > > > +  * For a split virtqueue, sets only the next descriptor index in the
> > > > > +    *Available Ring*.  The device is supposed to read the next index in
> > > > > +    the *Used Ring* from the respective vring structure in guest memory.
> > > > > +
> > > > > +  * For a packed virtqueue, both indices are supplied, as they are not
> > > > > +    explicitly available in memory.
> > > > > +
> > > > > +  Consequently, the payload type is specific to the type of virt queue
> > > > > +  (*a vring descriptor index for split virtqueues* vs. *vring descriptor
> > > > > +  indices for packed virtqueues*).
> > > > >    ``VHOST_USER_GET_VRING_BASE``
> > > > >      :id: 11
> > > > >      :equivalent ioctl: ``VHOST_USER_GET_VRING_BASE``
> > > > >      :request payload: vring state description
> > > > > -  :reply payload: vring state description
> > > > > +  :reply payload: vring descriptor index/indices
> > > > > +
> > > > > +  Stops the vring and returns the current descriptor index or indices:
> > > > > +
> > > > > +    * For a split virtqueue, returns only the 16-bit next descriptor
> > > > > +      index in the *Available Ring*.  The index in the *Used Ring* is
> > > > > +      controlled by the guest driver and can be read from the vring
> > > > I find "is controlled by the guest driver" confusing. The device writes
> > > > the Used Ring index. The driver only reads it. The device is the active
> > > > party here.
> > > Er, good point.  That breaks the whole reasoning.  Then I don’t understand
> > > why we do get/set the available ring index and not the used ring index.  Do
> > > you know why?
> > It's simple. used ring index in memory is controlled by the device and
> > reflects device state.
> 
> Exactly, it’s device state, that’s why I thought the front-end needs to
> ensure its read and restored around the reset we currently have in
> vhost_dev_stop()/start().
> 
> > device can just read it back to restore.
> 
> I find it strange that the device is supposed to read its own state from
> memory.

/me shrugs. It puts it there, why not read it back. Duplicating state
is not usually a good idea - leads to bugs.

> > available ring index in memory is controlled by driver and does
> > not reflect device state.
> 
> Why can’t the device read the available index from memory?  That value is
> put into memory by the driver precisely so the device can read it from
> there.
> 
> Hanna

Consider an example of RX ring for net device. buffers might be
available but device does not use them until packets arrive.  what I
think you could say is that actually just the used index should be
sufficient. So I think main thing GET_BASE does is stop the ring. As for
the value returned, we can if we want to validate that it matches used
ring index.

-- 
MST

