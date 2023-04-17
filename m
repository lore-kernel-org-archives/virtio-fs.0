Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
In-Reply-To: <20230417153810.GE3852722@fedora>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 17 Apr 2023 21:09:35 +0200
Message-ID: <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin wrote:
> > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> > >
> > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > So-called "internal" virtio-fs migration refers to transporting the
> > > > back-end's (virtiofsd's) state through qemu's migration stream.  To=
 do
> > > > this, we need to be able to transfer virtiofsd's internal state to =
and
> > > > from virtiofsd.
> > > >
> > > > Because virtiofsd's internal state will not be too large, we believ=
e it
> > > > is best to transfer it as a single binary blob after the streaming
> > > > phase.  Because this method should be useful to other vhost-user
> > > > implementations, too, it is introduced as a general-purpose additio=
n to
> > > > the protocol, not limited to vhost-user-fs.
> > > >
> > > > These are the additions to the protocol:
> > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_S=
TATE:
> > > >   This feature signals support for transferring state, and is added=
 so
> > > >   that migration can fail early when the back-end has no support.
> > > >
> > > > - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a =
pipe
> > > >   over which to transfer the state.  The front-end sends an FD to t=
he
> > > >   back-end into/from which it can write/read its state, and the bac=
k-end
> > > >   can decide to either use it, or reply with a different FD for the
> > > >   front-end to override the front-end's choice.
> > > >   The front-end creates a simple pipe to transfer the state, but ma=
ybe
> > > >   the back-end already has an FD into/from which it has to write/re=
ad
> > > >   its state, in which case it will want to override the simple pipe=
.
> > > >   Conversely, maybe in the future we find a way to have the front-e=
nd
> > > >   get an immediate FD for the migration stream (in some cases), in =
which
> > > >   case we will want to send this to the back-end instead of creatin=
g a
> > > >   pipe.
> > > >   Hence the negotiation: If one side has a better idea than a plain
> > > >   pipe, we will want to use that.
> > > >
> > > > - CHECK_DEVICE_STATE: After the state has been transferred through =
the
> > > >   pipe (the end indicated by EOF), the front-end invokes this funct=
ion
> > > >   to verify success.  There is no in-band way (through the pipe) to
> > > >   indicate failure, so we need to check explicitly.
> > > >
> > > > Once the transfer pipe has been established via SET_DEVICE_STATE_FD
> > > > (which includes establishing the direction of transfer and migratio=
n
> > > > phase), the sending side writes its data into the pipe, and the rea=
ding
> > > > side reads it until it sees an EOF.  Then, the front-end will check=
 for
> > > > success via CHECK_DEVICE_STATE, which on the destination side inclu=
des
> > > > checking for integrity (i.e. errors during deserialization).
> > > >
> > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > ---
> > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++=
++++
> > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > >  4 files changed, 287 insertions(+)
> > > >
> > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/=
vhost-backend.h
> > > > index ec3fbae58d..5935b32fe3 100644
> > > > --- a/include/hw/virtio/vhost-backend.h
> > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > >  } VhostSetConfigType;
> > > >
> > > > +typedef enum VhostDeviceStateDirection {
> > > > +    /* Transfer state from back-end (device) to front-end */
> > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > +    /* Transfer state from front-end to back-end (device) */
> > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > +} VhostDeviceStateDirection;
> > > > +
> > > > +typedef enum VhostDeviceStatePhase {
> > > > +    /* The device (and all its vrings) is stopped */
> > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > +} VhostDeviceStatePhase;
> > >
> > > vDPA has:
> > >
> > >   /* Suspend a device so it does not process virtqueue requests anymo=
re
> > >    *
> > >    * After the return of ioctl the device must preserve all the neces=
sary state
> > >    * (the virtqueue vring base plus the possible device specific stat=
es) that is
> > >    * required for restoring in the future. The device must not change=
 its
> > >    * configuration after that point.
> > >    */
> > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > >
> > >   /* Resume a device so it can resume processing virtqueue requests
> > >    *
> > >    * After the return of this ioctl the device will have restored all=
 the
> > >    * necessary states and it is fully operational to continue process=
ing the
> > >    * virtqueue descriptors.
> > >    */
> > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > >
> > > I wonder if it makes sense to import these into vhost-user so that th=
e
> > > difference between kernel vhost and vhost-user is minimized. It's oka=
y
> > > if one of them is ahead of the other, but it would be nice to avoid
> > > overlapping/duplicated functionality.
> > >
> >
> > That's what I had in mind in the first versions. I proposed VHOST_STOP
> > instead of VHOST_VDPA_STOP for this very reason. Later it did change
> > to SUSPEND.
>
> I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> ioctl(VHOST_VDPA_RESUME).
>
> The doc comments in <linux/vdpa.h> don't explain how the device can
> leave the suspended state. Can you clarify this?
>

Do you mean in what situations or regarding the semantics of _RESUME?

To me resume is an operation mainly to resume the device in the event
of a VM suspension, not a migration. It can be used as a fallback code
in some cases of migration failure though, but it is not currently
used in qemu.

Thanks!

