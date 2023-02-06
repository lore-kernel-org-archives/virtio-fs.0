Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 (Stefan Hajnoczi's message of "Mon, 6 Feb 2023 11:27:29 -0500")
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
Reply-To: quintela@redhat.com
Date: Mon, 06 Feb 2023 22:02:34 +0100
Message-ID: <87mt5qv76d.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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
> On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
>>
>> Hi Stefan,
>>
>> For true virtio-fs migration, we need to migrate the daemon=E2=80=99s (b=
ack
>> end=E2=80=99s) state somehow.  I=E2=80=99m addressing you because you ha=
d a talk on this
>> topic at KVM Forum 2021. :)
>>
>> As far as I understood your talk, the only standardized way to migrate a
>> vhost-user back end=E2=80=99s state is via dbus-vmstate.  I believe that
>> interface is unsuitable for our use case, because we will need to
>> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
>> been chosen arbitrarily, but the introducing commit=E2=80=99s message sa=
ys that
>> it=E2=80=99s based on the idea that the data must be supplied basically
>> immediately anyway (due to both dbus and qemu migration requirements),
>> and I don=E2=80=99t think we can meet that requirement.
>
> Yes, dbus-vmstate is the available today. It's independent of
> vhost-user and VIRTIO.

Once that we are here:
- typical size of your starte (either vhost-user or whatever)
- what are the posibilities that you can enter the iterative stage
  negotiation (i.e. that you can create a dirty bitmap about your state)

>> Has there been progress on the topic of standardizing a vhost-user back
>> end state migration channel besides dbus-vmstate?  I=E2=80=99ve looked a=
round
>> but didn=E2=80=99t find anything.  If there isn=E2=80=99t anything yet, =
is there still
>> interest in the topic?
>
> Not that I'm aware of. There are two parts to the topic of VIRTIO
> device state migration:
> 1. Defining an interface for migrating VIRTIO/vDPA/vhost/vhost-user
> devices.

Related topic: I am having to do right now vfio devices migration.  That
is basically hardware with huge binary blobs.  But they are "learning"
to have a dirty bitmap.  Current GPU's are already on the 128GB range,
so it is really needed.

> It doesn't need to be implemented in all these places
> immediately, but the design should consider that each of these
> standards will need to participate in migration sooner or later. It
> makes sense to choose an interface that works for all or most of these
> interfaces instead of inventing something vhost-user-specific.

In vfio, we really need to use binary blobs.  Here I don't know what to
do here.  In one side, "understading" what is through the channel makes
things way easier.  On the other hand, learning vmstate or similar is
complicated.

The other thing that we *think* is going to be needed is something like
what we do with cpus. cpu models and flags.  Too many flags.

Why?  Because once that they are at it, they want to be able to migrate
from one card, lets say Mellanox^wNVidia Connection-CX5 to
Connection-CX6, with not necessarily the same levels of firmawere.
I.e. fun.

> 2. Defining standard device state formats so VIRTIO implementations
> can interoperate.

I have no clue here.

>> Of course, we could use a channel that completely bypasses qemu, but I
>> think we=E2=80=99d like to avoid that if possible.  First, this would re=
quire
>> adding functionality to virtiofsd to configure this channel.  Second,
>> not storing the state in the central VM state means that migrating to
>> file doesn=E2=80=99t work (well, we could migrate to a dedicated state f=
ile,
>> but...).

How much is migration to file used in practice?
I would like to have some information here.
It could be necessary probably to be able to encrypt it.  And that is a
(different) whole can of worms.

>> Third, setting up such a channel after virtiofsd has sandboxed
>> itself is hard.  I guess we should set up the migration channel before
>> sandboxing, which constrains runtime configuration (basically this would
>> only allow us to set up a listening server, I believe).  Well, and
>> finally, it isn=E2=80=99t a standard way, which won=E2=80=99t be great i=
f we=E2=80=99re planning
>> to add a standard way anyway.
>
> Yes, live migration is hard enough. Duplicating it is probably not
> going to make things better. It would still be necessary to support
> saving to file as well as live migration.

The other problem of NOT using migration infrastructure is firewalls.
Live Migration only uses a single port.  It uses as many sockets as it
needs with multifd, but use the same port to make life easier for
libvirt/management app.

Adding a new port for each vhost-user devices is not going to fly with
admins.

> There are two high-level approaches to the migration interface:
> 1. The whitebox approach where the vhost-user back-end implements
> device-specific messages to get/set migration state (e.g.
> VIRTIO_FS_GET_DEVICE_STATE with a struct virtio_fs_device_state
> containing the state of the FUSE session or multiple fine-grained
> messages that extract pieces of state). The hypervisor is responsible
> for the actual device state serialization.
> 2. The blackbox approach where the vhost-user back-end implements the
> device state serialization itself and just produces a blob of data.

If your state is big enough, you are going to need a dirty bitmap or
something similar.  Independently if you use white or black box
approach.

100gigabit network ~ 10GB/s transfer.
1GB of state takes 1second downtime.

And 100gigabit is not common now.  If you are stuck at 10gigabit, then
you can only transfer 1GB in 1 second downtime.

And we are getting to the point when we have multiple vhost-user/vfio
devices, etc.

Another problem that we are working with right now is bitmaps.  Just
synchronizing them takes forever.  Take a 6TB guest:

6TB guest ~ 6TB/4KB ~ 1.600.000 pages, i.e. the size of the bitmap in bits
1.600.000 entries /8 bits/byte - 200.000 bytes - 200MB each bitmap.

If we end needing one for memory, and one for each vfio device, and
another for each vhost device, that makes synchronization,
... interesting to say the less.  We could start using GPU's to
synhronize bitmaps O:-)

> An example of the whitebox approach is the existing vhost migration
> interface - except that it doesn't really support device-specific
> state, only generic virtqueue state.
>
> An example of the blackbox approach is the VFIO v2 migration interface:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/uapi/linux/vfio.h#n867
>
> Another aspect to consider is whether save/load is sufficient or if
> the full iterative migration model needs to be exposed by the
> interface. VFIO migration is an example of the full iterative model
> while dbus-vmstate is just save/load. Devices with large amounts of
> state need the full iterative model while simple devices just need
> save/load.

This is why I asked the size of vhost devices or whatever it is called
this week O:-)

> Regarding virtiofs, I think the device state is not
> implementation-specific. Different implementations may have different
> device states (e.g. in-memory file system implementation versus POSIX
> file system-backed implementation), but the device state produced by
> https://gitlab.com/virtio-fs/virtiofsd can probably also be loaded by
> another implementation.
>
> My suggestion is blackbox migration with a full iterative interface.
> The reason I like the blackbox approach is that a device's device
> state is encapsulated in the device implementation and does not
> require coordinating changes across other codebases (e.g. vDPA and
> vhost kernel interface, vhost-user protocol, QEMU, etc). A blackbox
> interface only needs to be defined and implemented once. After that,
> device implementations can evolve without constant changes at various
> layers.
>
> So basically, something like VFIO v2 migration but for vhost-user
> (with an eye towards vDPA and VIRTIO support in the future).
>
> Should we schedule a call with Jason, Michael, Juan, David, etc to
> discuss further? That way there's less chance of spending weeks
> working on something only to be asked to change the approach later.

We are discussing this with vfio.

Basically what we have asked vfio to support is:
- enter the interative stage to explain how much dirty memory do they
  have.  We need this to calculate downtimes.  See my last PULL request
  to see how I implemented it.
  I generalized save_state_pending() for save_live devices to
  state_pending_estimate() and state_pending_exact().
  Only device that use different implementations for that values right
  now is ram.  But I expect more to use it.
  The idea is that with estimate, you give an estimate of how much you
  think is pending, but without trying too hard.
  ram returns how much dirty bits are on the ram dirty bitmap now.
  with the _exact() one, you try very hard to give a "more" correct
  size.  It is called when according to the estimates, we have few dirty
  memory that we could enter last stage migration.

- My next project is creating a new multifd thread for each vfio device
  that requires it.  It does right now:
  * we give a channel for the device, nothing else will use it
  * a thread on the sending side/recovering side for the device
  * we notify when we have ended the iterative stage, so they can start
  * they can use the channel how they want, as it is on the ending
    stage, they can transfer full speed.

- They asked for a way to stop migration if we can not arrive to
  downtime needed.  If with current speed, the maximum amount of dirty
  memory that we can transmit is 512MB, and vfio tells us that they have
  more than 512MB only by itself, we now this will never converge, so we
  have to abort migration.  In the case of vfio devices, the device
  state depends of guest configuration, and it is not going ta change
  until guest change configuration.

The last two bits are on my ToDo list for the near future, but not done.

If we ended having lots of so big devices, we are going to have to think
about downtimes in the order of dozens of seconds, not subsecond.

So, if you are planning doing this in the near future, this is a good
time to discuss this.

Later, Juan.

> Stefan

