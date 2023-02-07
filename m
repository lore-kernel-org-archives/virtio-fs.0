Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=N91uCJQb7VMYP1jpRNDIHzLFLRyU/8a5wJzvMLDGHlE=;
 b=U6NFacVhiIcMkuGmSI4bgrEErMYgeQZ92rI+Xa4Dw/bl6yRA17gcEc+PWErhuC97gV
 9j1XhX/N3MB3K/oe+NlEDLWjkheI8ojFxqwUl4zYdEaKzarFyNKdim/N8x+C4200ADcu
 N3n2dAMH3LWCN7al6ou/2eggjTPQncw9RbV1irWeq+o4vytaFuxZisSdOJIZEATQQUGC
 uyOoHI+/OMU45rjzj8BH/ncvSUncCV67xa1YMMXoBPQz3/VbuQ6IMZ9hIlUV2qC9FwXC
 db92B49gVoGirO92QtXanf+Lo7WwPab8B8wPDXCxMLsjMsXJXvurzFsD/gShAb4nAVkr
 JJig==
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
In-Reply-To: <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 7 Feb 2023 07:29:03 -0500
Message-ID: <CAJSP0QWA5j8J_nsUWwh5a18XsoJxjtRutLQzXT6JT1LwLbxCCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On Tue, 7 Feb 2023 at 04:08, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 06.02.23 17:27, Stefan Hajnoczi wrote:
> > On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
> >> Hi Stefan,
> >>
> >> For true virtio-fs migration, we need to migrate the daemon=E2=80=99s =
(back
> >> end=E2=80=99s) state somehow.  I=E2=80=99m addressing you because you =
had a talk on this
> >> topic at KVM Forum 2021. :)
> >>
> >> As far as I understood your talk, the only standardized way to migrate=
 a
> >> vhost-user back end=E2=80=99s state is via dbus-vmstate.  I believe th=
at
> >> interface is unsuitable for our use case, because we will need to
> >> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
> >> been chosen arbitrarily, but the introducing commit=E2=80=99s message =
says that
> >> it=E2=80=99s based on the idea that the data must be supplied basicall=
y
> >> immediately anyway (due to both dbus and qemu migration requirements),
> >> and I don=E2=80=99t think we can meet that requirement.
> > Yes, dbus-vmstate is the available today. It's independent of
> > vhost-user and VIRTIO.
> >
> >> Has there been progress on the topic of standardizing a vhost-user bac=
k
> >> end state migration channel besides dbus-vmstate?  I=E2=80=99ve looked=
 around
> >> but didn=E2=80=99t find anything.  If there isn=E2=80=99t anything yet=
, is there still
> >> interest in the topic?
> > Not that I'm aware of. There are two parts to the topic of VIRTIO
> > device state migration:
> > 1. Defining an interface for migrating VIRTIO/vDPA/vhost/vhost-user
> > devices. It doesn't need to be implemented in all these places
> > immediately, but the design should consider that each of these
> > standards will need to participate in migration sooner or later. It
> > makes sense to choose an interface that works for all or most of these
> > interfaces instead of inventing something vhost-user-specific.
> > 2. Defining standard device state formats so VIRTIO implementations
> > can interoperate.
> >
> >> Of course, we could use a channel that completely bypasses qemu, but I
> >> think we=E2=80=99d like to avoid that if possible.  First, this would =
require
> >> adding functionality to virtiofsd to configure this channel.  Second,
> >> not storing the state in the central VM state means that migrating to
> >> file doesn=E2=80=99t work (well, we could migrate to a dedicated state=
 file,
> >> but...).  Third, setting up such a channel after virtiofsd has sandbox=
ed
> >> itself is hard.  I guess we should set up the migration channel before
> >> sandboxing, which constrains runtime configuration (basically this wou=
ld
> >> only allow us to set up a listening server, I believe).  Well, and
> >> finally, it isn=E2=80=99t a standard way, which won=E2=80=99t be great=
 if we=E2=80=99re planning
> >> to add a standard way anyway.
> > Yes, live migration is hard enough. Duplicating it is probably not
> > going to make things better. It would still be necessary to support
> > saving to file as well as live migration.
> >
> > There are two high-level approaches to the migration interface:
> > 1. The whitebox approach where the vhost-user back-end implements
> > device-specific messages to get/set migration state (e.g.
> > VIRTIO_FS_GET_DEVICE_STATE with a struct virtio_fs_device_state
> > containing the state of the FUSE session or multiple fine-grained
> > messages that extract pieces of state). The hypervisor is responsible
> > for the actual device state serialization.
> > 2. The blackbox approach where the vhost-user back-end implements the
> > device state serialization itself and just produces a blob of data.
>
> Implementing this through device-specific messages sounds quite nice to
> me, and I think this would work for the blackbox approach, too. The
> virtio-fs device in qemu (the front end stub) would provide that data as
> its VM state then, right?

Yes. In the blackbox approach the QEMU vhost-user-fs device's vmstate
contains a blob field. The contents of the blob come from the
vhost-user-fs back-end and are not parsed/modified by QEMU.

> I=E2=80=99m not sure at this point whether it is sensible to define a
> device-specific standard for the state (i.e. the whitebox approach).  I
> think that it may be too rigid if we decide to extend it in the future.
> As far as I understand, the benefit is that it would allow for
> interoperability between different virtio-fs back end implementations,
> which isn=E2=80=99t really a concern right now.  If we need this in the f=
uture,
> I=E2=80=99m sure we can extend the protocol further to alternatively use
> standardized state.  (Which can easily be turned back into a blob if
> compatibility requires it.)
>
> I think we=E2=80=99ll probably want a mix of both, where it is standardiz=
ed that
> the state consists of information about each FUSE inode and each open
> handle, but that information itself is treated as a blob.
>
> > An example of the whitebox approach is the existing vhost migration
> > interface - except that it doesn't really support device-specific
> > state, only generic virtqueue state.
> >
> > An example of the blackbox approach is the VFIO v2 migration interface:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/include/uapi/linux/vfio.h#n867
> >
> > Another aspect to consider is whether save/load is sufficient or if
> > the full iterative migration model needs to be exposed by the
> > interface. VFIO migration is an example of the full iterative model
> > while dbus-vmstate is just save/load. Devices with large amounts of
> > state need the full iterative model while simple devices just need
> > save/load.
>
> Yes, we will probably need an iterative model.  Splitting the state into
> information about each FUSE inode/handle (so that single inodes/handles
> can be updated if needed) should help accomplish this.
>
> > Regarding virtiofs, I think the device state is not
> > implementation-specific. Different implementations may have different
> > device states (e.g. in-memory file system implementation versus POSIX
> > file system-backed implementation), but the device state produced by
> > https://gitlab.com/virtio-fs/virtiofsd can probably also be loaded by
> > another implementation.
>
> Difficult to say.  What seems universal to us now may well not be,
> because we=E2=80=99re just seeing our own implementation.  I think we=E2=
=80=99ll just
> serialize it in a way that makes sense to us now, and hope it=E2=80=99ll =
make
> sense to others too should the need arise.

When writing this I thought about the old QEMU C virtiofsd and the
current Rust virtiofsd. I'm pretty sure they could be made to migrate
between each other. We don't need to implement that, but it shows that
the device state is not specific to just 1 implementation.

> > My suggestion is blackbox migration with a full iterative interface.
> > The reason I like the blackbox approach is that a device's device
> > state is encapsulated in the device implementation and does not
> > require coordinating changes across other codebases (e.g. vDPA and
> > vhost kernel interface, vhost-user protocol, QEMU, etc). A blackbox
> > interface only needs to be defined and implemented once. After that,
> > device implementations can evolve without constant changes at various
> > layers.
>
> Agreed.
>
> > So basically, something like VFIO v2 migration but for vhost-user
> > (with an eye towards vDPA and VIRTIO support in the future).
> >
> > Should we schedule a call with Jason, Michael, Juan, David, etc to
> > discuss further? That way there's less chance of spending weeks
> > working on something only to be asked to change the approach later.
>
> Sure, sounds good!  I=E2=80=99ve taken a look into what state we=E2=80=99=
ll need to
> migrate already, but I=E2=80=99ll take a more detailed look now so that i=
t=E2=80=99s
> clear what our requirements are.

Another thing that will be important is the exact interface for
iterative migration. VFIO v1 migration had some limitations and
changed semantics in v2. Learning from that would be good.

Stefan

