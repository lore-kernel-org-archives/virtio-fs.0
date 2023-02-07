Return-Path: <hreitz@redhat.com>
Message-ID: <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
Date: Tue, 7 Feb 2023 10:08:23 +0100
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On 06.02.23 17:27, Stefan Hajnoczi wrote:
> On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
>> Hi Stefan,
>>
>> For true virtio-fs migration, we need to migrate the daemon’s (back
>> end’s) state somehow.  I’m addressing you because you had a talk on this
>> topic at KVM Forum 2021. :)
>>
>> As far as I understood your talk, the only standardized way to migrate a
>> vhost-user back end’s state is via dbus-vmstate.  I believe that
>> interface is unsuitable for our use case, because we will need to
>> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
>> been chosen arbitrarily, but the introducing commit’s message says that
>> it’s based on the idea that the data must be supplied basically
>> immediately anyway (due to both dbus and qemu migration requirements),
>> and I don’t think we can meet that requirement.
> Yes, dbus-vmstate is the available today. It's independent of
> vhost-user and VIRTIO.
>
>> Has there been progress on the topic of standardizing a vhost-user back
>> end state migration channel besides dbus-vmstate?  I’ve looked around
>> but didn’t find anything.  If there isn’t anything yet, is there still
>> interest in the topic?
> Not that I'm aware of. There are two parts to the topic of VIRTIO
> device state migration:
> 1. Defining an interface for migrating VIRTIO/vDPA/vhost/vhost-user
> devices. It doesn't need to be implemented in all these places
> immediately, but the design should consider that each of these
> standards will need to participate in migration sooner or later. It
> makes sense to choose an interface that works for all or most of these
> interfaces instead of inventing something vhost-user-specific.
> 2. Defining standard device state formats so VIRTIO implementations
> can interoperate.
>
>> Of course, we could use a channel that completely bypasses qemu, but I
>> think we’d like to avoid that if possible.  First, this would require
>> adding functionality to virtiofsd to configure this channel.  Second,
>> not storing the state in the central VM state means that migrating to
>> file doesn’t work (well, we could migrate to a dedicated state file,
>> but...).  Third, setting up such a channel after virtiofsd has sandboxed
>> itself is hard.  I guess we should set up the migration channel before
>> sandboxing, which constrains runtime configuration (basically this would
>> only allow us to set up a listening server, I believe).  Well, and
>> finally, it isn’t a standard way, which won’t be great if we’re planning
>> to add a standard way anyway.
> Yes, live migration is hard enough. Duplicating it is probably not
> going to make things better. It would still be necessary to support
> saving to file as well as live migration.
>
> There are two high-level approaches to the migration interface:
> 1. The whitebox approach where the vhost-user back-end implements
> device-specific messages to get/set migration state (e.g.
> VIRTIO_FS_GET_DEVICE_STATE with a struct virtio_fs_device_state
> containing the state of the FUSE session or multiple fine-grained
> messages that extract pieces of state). The hypervisor is responsible
> for the actual device state serialization.
> 2. The blackbox approach where the vhost-user back-end implements the
> device state serialization itself and just produces a blob of data.

Implementing this through device-specific messages sounds quite nice to 
me, and I think this would work for the blackbox approach, too. The 
virtio-fs device in qemu (the front end stub) would provide that data as 
its VM state then, right?

I’m not sure at this point whether it is sensible to define a 
device-specific standard for the state (i.e. the whitebox approach).  I 
think that it may be too rigid if we decide to extend it in the future.  
As far as I understand, the benefit is that it would allow for 
interoperability between different virtio-fs back end implementations, 
which isn’t really a concern right now.  If we need this in the future, 
I’m sure we can extend the protocol further to alternatively use 
standardized state.  (Which can easily be turned back into a blob if 
compatibility requires it.)

I think we’ll probably want a mix of both, where it is standardized that 
the state consists of information about each FUSE inode and each open 
handle, but that information itself is treated as a blob.

> An example of the whitebox approach is the existing vhost migration
> interface - except that it doesn't really support device-specific
> state, only generic virtqueue state.
>
> An example of the blackbox approach is the VFIO v2 migration interface:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/vfio.h#n867
>
> Another aspect to consider is whether save/load is sufficient or if
> the full iterative migration model needs to be exposed by the
> interface. VFIO migration is an example of the full iterative model
> while dbus-vmstate is just save/load. Devices with large amounts of
> state need the full iterative model while simple devices just need
> save/load.

Yes, we will probably need an iterative model.  Splitting the state into 
information about each FUSE inode/handle (so that single inodes/handles 
can be updated if needed) should help accomplish this.

> Regarding virtiofs, I think the device state is not
> implementation-specific. Different implementations may have different
> device states (e.g. in-memory file system implementation versus POSIX
> file system-backed implementation), but the device state produced by
> https://gitlab.com/virtio-fs/virtiofsd can probably also be loaded by
> another implementation.

Difficult to say.  What seems universal to us now may well not be, 
because we’re just seeing our own implementation.  I think we’ll just 
serialize it in a way that makes sense to us now, and hope it’ll make 
sense to others too should the need arise.

> My suggestion is blackbox migration with a full iterative interface.
> The reason I like the blackbox approach is that a device's device
> state is encapsulated in the device implementation and does not
> require coordinating changes across other codebases (e.g. vDPA and
> vhost kernel interface, vhost-user protocol, QEMU, etc). A blackbox
> interface only needs to be defined and implemented once. After that,
> device implementations can evolve without constant changes at various
> layers.

Agreed.

> So basically, something like VFIO v2 migration but for vhost-user
> (with an eye towards vDPA and VIRTIO support in the future).
>
> Should we schedule a call with Jason, Michael, Juan, David, etc to
> discuss further? That way there's less chance of spending weeks
> working on something only to be asked to change the approach later.

Sure, sounds good!  I’ve taken a look into what state we’ll need to 
migrate already, but I’ll take a more detailed look now so that it’s 
clear what our requirements are.

Hanna

