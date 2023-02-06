Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <CAJSP0QUO3i+tLfDE0sdNRePnoaqJ7TL29izmk5sDzRt83Ds8tQ@mail.gmail.com>
 (Stefan Hajnoczi's message of "Mon, 6 Feb 2023 16:16:22 -0500")
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <87mt5qv76d.fsf@secure.mitica>
 <CAJSP0QUO3i+tLfDE0sdNRePnoaqJ7TL29izmk5sDzRt83Ds8tQ@mail.gmail.com>
Reply-To: quintela@redhat.com
Date: Tue, 07 Feb 2023 00:58:27 +0100
Message-ID: <87ilgeuz18.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?utf-8?Q?Marc-Andr?= =?utf-8?Q?=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>

Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Mon, 6 Feb 2023 at 16:02, Juan Quintela <quintela@redhat.com> wrote:
>> The last two bits are on my ToDo list for the near future, but not done.
>>
>> If we ended having lots of so big devices, we are going to have to think
>> about downtimes in the order of dozens of seconds, not subsecond.
>>
>> So, if you are planning doing this in the near future, this is a good
>> time to discuss this.
>
> Can you explain the dirty bitmap requirement you mentioned further, given that:
> 1. vhost-user has dirty memory logging already, so DMA is covered.
> 2. An iterative interface allows the device to keep generating more
> state, so does QEMU really need to know if parts of the previously
> emitted binary blob have become dirty? It might allow QEMU to minimize
> the size of the savevm file, but only if the overwritten data has the
> same size.
>
> Is a dirty bitmap for the device state necessary?

Not for that.  My fault.  I was talking about a dirty bitmap because
that is how it is implemented in vfio.  Notice that qemu don't see that
bitmap.  But the device can enter the iterative stage.

The reason that I ask is if you can enter the iterative stage to send
stuff before the last stage.

If you don't have something similar to that, you need to send that in
one go, and that is going to take really a lot of time.

When we are talking about NVidia GPU's, they have two kinds of state:
- Frame buffer: they can (or at some point would have) a dirty bitmap
  and they can enter the iterative stage.
- They have internal state that is not visible to the user, that state
  is big (around 1GB) and they can't enter the iterative stage, because
  they can't know if the guest, the card, or whoever has changed that.

For vhost device:
- what is the "typical" amount of state.
- if it is more than a few megabytes, is there a way to send parts of it
  before the ending stage?  That is what I asked for a dirty bitmap for
  it, but it can be anything else.  Just that vhost-user keep track of
  what has sent to the other side and then have less state for the last
  stage?
  

Later, Juan.

