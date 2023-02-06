Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RLgX2o3MJyCY39k40u5lR5tLh/jUqo6iE0+PE7qVR88=;
 b=Br3tjDPnDvGAnipp5G/8bGWT/PfHcJ8nrXD43nxqg0M9sWz7brgGzyRrB0v3yttsh1
 xEtsXOKor2zNtvFpJkW8KworUJ3tjR+dmAjLj9u3P2kIB9wR4WLk1G/Z72RM0T9v0z75
 /mojI+Fs26WeIks5A894krmauVIpGjGQ+mtaPeU3CAR9pkwftmCjVwQf19zefIHq4dHq
 8h6RYkqXC3ipl30prW8VcuM1I1GmQyc0BxvbbGT+VlJBMrK9qwCUv8O6vpAiXxVtEEUf
 U8iUvHePRYVtcIQR4MNOigLt2QRNIn8MxrLV9z9gBvcg1bhS2f5sUXjRpq4tdnjFEVAV
 nq0Q==
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
In-Reply-To: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 6 Feb 2023 11:27:29 -0500
Message-ID: <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
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

On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> Hi Stefan,
>
> For true virtio-fs migration, we need to migrate the daemon=E2=80=99s (ba=
ck
> end=E2=80=99s) state somehow.  I=E2=80=99m addressing you because you had=
 a talk on this
> topic at KVM Forum 2021. :)
>
> As far as I understood your talk, the only standardized way to migrate a
> vhost-user back end=E2=80=99s state is via dbus-vmstate.  I believe that
> interface is unsuitable for our use case, because we will need to
> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
> been chosen arbitrarily, but the introducing commit=E2=80=99s message say=
s that
> it=E2=80=99s based on the idea that the data must be supplied basically
> immediately anyway (due to both dbus and qemu migration requirements),
> and I don=E2=80=99t think we can meet that requirement.

Yes, dbus-vmstate is the available today. It's independent of
vhost-user and VIRTIO.

> Has there been progress on the topic of standardizing a vhost-user back
> end state migration channel besides dbus-vmstate?  I=E2=80=99ve looked ar=
ound
> but didn=E2=80=99t find anything.  If there isn=E2=80=99t anything yet, i=
s there still
> interest in the topic?

Not that I'm aware of. There are two parts to the topic of VIRTIO
device state migration:
1. Defining an interface for migrating VIRTIO/vDPA/vhost/vhost-user
devices. It doesn't need to be implemented in all these places
immediately, but the design should consider that each of these
standards will need to participate in migration sooner or later. It
makes sense to choose an interface that works for all or most of these
interfaces instead of inventing something vhost-user-specific.
2. Defining standard device state formats so VIRTIO implementations
can interoperate.

> Of course, we could use a channel that completely bypasses qemu, but I
> think we=E2=80=99d like to avoid that if possible.  First, this would req=
uire
> adding functionality to virtiofsd to configure this channel.  Second,
> not storing the state in the central VM state means that migrating to
> file doesn=E2=80=99t work (well, we could migrate to a dedicated state fi=
le,
> but...).  Third, setting up such a channel after virtiofsd has sandboxed
> itself is hard.  I guess we should set up the migration channel before
> sandboxing, which constrains runtime configuration (basically this would
> only allow us to set up a listening server, I believe).  Well, and
> finally, it isn=E2=80=99t a standard way, which won=E2=80=99t be great if=
 we=E2=80=99re planning
> to add a standard way anyway.

Yes, live migration is hard enough. Duplicating it is probably not
going to make things better. It would still be necessary to support
saving to file as well as live migration.

There are two high-level approaches to the migration interface:
1. The whitebox approach where the vhost-user back-end implements
device-specific messages to get/set migration state (e.g.
VIRTIO_FS_GET_DEVICE_STATE with a struct virtio_fs_device_state
containing the state of the FUSE session or multiple fine-grained
messages that extract pieces of state). The hypervisor is responsible
for the actual device state serialization.
2. The blackbox approach where the vhost-user back-end implements the
device state serialization itself and just produces a blob of data.

An example of the whitebox approach is the existing vhost migration
interface - except that it doesn't really support device-specific
state, only generic virtqueue state.

An example of the blackbox approach is the VFIO v2 migration interface:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/linux/vfio.h#n867

Another aspect to consider is whether save/load is sufficient or if
the full iterative migration model needs to be exposed by the
interface. VFIO migration is an example of the full iterative model
while dbus-vmstate is just save/load. Devices with large amounts of
state need the full iterative model while simple devices just need
save/load.

Regarding virtiofs, I think the device state is not
implementation-specific. Different implementations may have different
device states (e.g. in-memory file system implementation versus POSIX
file system-backed implementation), but the device state produced by
https://gitlab.com/virtio-fs/virtiofsd can probably also be loaded by
another implementation.

My suggestion is blackbox migration with a full iterative interface.
The reason I like the blackbox approach is that a device's device
state is encapsulated in the device implementation and does not
require coordinating changes across other codebases (e.g. vDPA and
vhost kernel interface, vhost-user protocol, QEMU, etc). A blackbox
interface only needs to be defined and implemented once. After that,
device implementations can evolve without constant changes at various
layers.

So basically, something like VFIO v2 migration but for vhost-user
(with an eye towards vDPA and VIRTIO support in the future).

Should we schedule a call with Jason, Michael, Juan, David, etc to
discuss further? That way there's less chance of spending weeks
working on something only to be asked to change the approach later.

Stefan

