Return-Path: <mst@redhat.com>
Date: Sat, 7 Oct 2023 17:29:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231007172809-mutt-send-email-mst@kernel.org>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-3-hreitz@redhat.com>
 <20231005173859.GC1342722@fedora>
 <851b7629-2302-5624-eb81-6839e250991e@redhat.com>
 <20231006044753-mutt-send-email-mst@kernel.org>
 <483bedcf-9c55-6977-f82c-5ce611ca5769@redhat.com>
 <3523c3c6-cd0c-947d-cf84-d648ef813f66@redhat.com>
MIME-Version: 1.0
In-Reply-To: <3523c3c6-cd0c-947d-cf84-d648ef813f66@redhat.com>
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

On Fri, Oct 06, 2023 at 03:58:44PM +0200, Hanna Czenczek wrote:
> On 06.10.23 15:55, Hanna Czenczek wrote:
> > On 06.10.23 10:49, Michael S. Tsirkin wrote:
> > > On Fri, Oct 06, 2023 at 09:53:53AM +0200, Hanna Czenczek wrote:
> > > > On 05.10.23 19:38, Stefan Hajnoczi wrote:
> > > > > On Wed, Oct 04, 2023 at 02:58:58PM +0200, Hanna Czenczek wrote:
> 
> [...]
> 
> > > > >    ``VHOST_USER_GET_VRING_BASE``
> > > > >      :id: 11
> > > > >      :equivalent ioctl: ``VHOST_USER_GET_VRING_BASE``
> > > > >      :request payload: vring state description
> > > > > -  :reply payload: vring state description
> > > > > +  :reply payload: vring descriptor index/indices
> > > > > +
> > > > > +  Stops the vring and returns the current descriptor index
> > > > > or indices:
> > > > > +
> > > > > +    * For a split virtqueue, returns only the 16-bit next descriptor
> > > > > +      index in the *Available Ring*.  The index in the *Used Ring* is
> > > > > +      controlled by the guest driver and can be read from the vring
> > > > > I find "is controlled by the guest driver" confusing. The
> > > > > device writes
> > > > > the Used Ring index. The driver only reads it. The device is
> > > > > the active
> > > > > party here.
> > > > Er, good point.  That breaks the whole reasoning.  Then I don’t
> > > > understand
> > > > why we do get/set the available ring index and not the used ring
> > > > index.  Do
> > > > you know why?
> > > It's simple. used ring index in memory is controlled by the device and
> > > reflects device state.
> > 
> > Exactly, it’s device state, that’s why I thought the front-end needs to
> > ensure its read and restored around the reset we currently have in
> > vhost_dev_stop()/start().
> > 
> > > device can just read it back to restore.
> > 
> > I find it strange that the device is supposed to read its own state from
> > memory.
> > 
> > > available ring index in memory is controlled by driver and does
> > > not reflect device state.
> > 
> > Why can’t the device read the available index from memory?  That value
> > is put into memory by the driver precisely so the device can read it
> > from there.
> 
> Ah, wait, is the idea that the device may have an internal available index
> counter that reflects what descriptor it has already fetched? I.e. this
> index will lag behind the one in memory, and the difference are new
> descriptors that the device still needs to read? If that internal counter is
> the index that’s get/set here, then yes, that makes a lot of sense.
> 
> Hanna

Exactly. And this gets eventually written out as used index.

-- 
MST

