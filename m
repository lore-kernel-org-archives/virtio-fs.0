Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
 <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
 <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
In-Reply-To: <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 18 Apr 2023 10:09:30 +0200
Message-ID: <CAJaqyWfaDVZDJtMvPUhdRE283e80rB3WFd3RF9i=buaBYG=PKA@mail.gmail.com>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Mon, Apr 17, 2023 at 9:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.com=
> wrote:
>
> On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <eperezma@redhat.com> =
wrote:
> >
> > On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin wrote:
> > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@=
redhat.com> wrote:
> > > > >
> > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > > > So-called "internal" virtio-fs migration refers to transporting=
 the
> > > > > > back-end's (virtiofsd's) state through qemu's migration stream.=
  To do
> > > > > > this, we need to be able to transfer virtiofsd's internal state=
 to and
> > > > > > from virtiofsd.
> > > > > >
> > > > > > Because virtiofsd's internal state will not be too large, we be=
lieve it
> > > > > > is best to transfer it as a single binary blob after the stream=
ing
> > > > > > phase.  Because this method should be useful to other vhost-use=
r
> > > > > > implementations, too, it is introduced as a general-purpose add=
ition to
> > > > > > the protocol, not limited to vhost-user-fs.
> > > > > >
> > > > > > These are the additions to the protocol:
> > > > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATO=
RY_STATE:
> > > > > >   This feature signals support for transferring state, and is a=
dded so
> > > > > >   that migration can fail early when the back-end has no suppor=
t.
> > > > > >
> > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end negotiat=
e a pipe
> > > > > >   over which to transfer the state.  The front-end sends an FD =
to the
> > > > > >   back-end into/from which it can write/read its state, and the=
 back-end
> > > > > >   can decide to either use it, or reply with a different FD for=
 the
> > > > > >   front-end to override the front-end's choice.
> > > > > >   The front-end creates a simple pipe to transfer the state, bu=
t maybe
> > > > > >   the back-end already has an FD into/from which it has to writ=
e/read
> > > > > >   its state, in which case it will want to override the simple =
pipe.
> > > > > >   Conversely, maybe in the future we find a way to have the fro=
nt-end
> > > > > >   get an immediate FD for the migration stream (in some cases),=
 in which
> > > > > >   case we will want to send this to the back-end instead of cre=
ating a
> > > > > >   pipe.
> > > > > >   Hence the negotiation: If one side has a better idea than a p=
lain
> > > > > >   pipe, we will want to use that.
> > > > > >
> > > > > > - CHECK_DEVICE_STATE: After the state has been transferred thro=
ugh the
> > > > > >   pipe (the end indicated by EOF), the front-end invokes this f=
unction
> > > > > >   to verify success.  There is no in-band way (through the pipe=
) to
> > > > > >   indicate failure, so we need to check explicitly.
> > > > > >
> > > > > > Once the transfer pipe has been established via SET_DEVICE_STAT=
E_FD
> > > > > > (which includes establishing the direction of transfer and migr=
ation
> > > > > > phase), the sending side writes its data into the pipe, and the=
 reading
> > > > > > side reads it until it sees an EOF.  Then, the front-end will c=
heck for
> > > > > > success via CHECK_DEVICE_STATE, which on the destination side i=
ncludes
> > > > > > checking for integrity (i.e. errors during deserialization).
> > > > > >
> > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > ---
> > > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > > > >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++=
++++++++
> > > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > > >  4 files changed, 287 insertions(+)
> > > > > >
> > > > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/vir=
tio/vhost-backend.h
> > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > >  } VhostSetConfigType;
> > > > > >
> > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > +    /* Transfer state from back-end (device) to front-end */
> > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > +    /* Transfer state from front-end to back-end (device) */
> > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > +} VhostDeviceStateDirection;
> > > > > > +
> > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > +    /* The device (and all its vrings) is stopped */
> > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > +} VhostDeviceStatePhase;
> > > > >
> > > > > vDPA has:
> > > > >
> > > > >   /* Suspend a device so it does not process virtqueue requests a=
nymore
> > > > >    *
> > > > >    * After the return of ioctl the device must preserve all the n=
ecessary state
> > > > >    * (the virtqueue vring base plus the possible device specific =
states) that is
> > > > >    * required for restoring in the future. The device must not ch=
ange its
> > > > >    * configuration after that point.
> > > > >    */
> > > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > > >
> > > > >   /* Resume a device so it can resume processing virtqueue reques=
ts
> > > > >    *
> > > > >    * After the return of this ioctl the device will have restored=
 all the
> > > > >    * necessary states and it is fully operational to continue pro=
cessing the
> > > > >    * virtqueue descriptors.
> > > > >    */
> > > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > > >
> > > > > I wonder if it makes sense to import these into vhost-user so tha=
t the
> > > > > difference between kernel vhost and vhost-user is minimized. It's=
 okay
> > > > > if one of them is ahead of the other, but it would be nice to avo=
id
> > > > > overlapping/duplicated functionality.
> > > > >
> > > >
> > > > That's what I had in mind in the first versions. I proposed VHOST_S=
TOP
> > > > instead of VHOST_VDPA_STOP for this very reason. Later it did chang=
e
> > > > to SUSPEND.
> > >
> > > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> > > ioctl(VHOST_VDPA_RESUME).
> > >
> > > The doc comments in <linux/vdpa.h> don't explain how the device can
> > > leave the suspended state. Can you clarify this?
> > >
> >
> > Do you mean in what situations or regarding the semantics of _RESUME?
> >
> > To me resume is an operation mainly to resume the device in the event
> > of a VM suspension, not a migration. It can be used as a fallback code
> > in some cases of migration failure though, but it is not currently
> > used in qemu.
>
> Is a "VM suspension" the QEMU HMP 'stop' command?
>
> I guess the reason why QEMU doesn't call RESUME anywhere is that it
> resets the device in vhost_dev_stop()?
>

The actual reason for not using RESUME is that the ioctl was added
after the SUSPEND design in qemu. Same as this proposal, it is was not
needed at the time.

In the case of vhost-vdpa net, the only usage of suspend is to fetch
the vq indexes, and in case of error vhost already fetches them from
guest's used ring way before vDPA, so it has little usage.

> Does it make sense to combine SUSPEND and RESUME with Hanna's
> SET_DEVICE_STATE_FD? For example, non-iterative migration works like
> this:
> - Saving the device's state is done by SUSPEND followed by
> SET_DEVICE_STATE_FD. If the guest needs to continue executing (e.g.
> savevm command or migration failed), then RESUME is called to
> continue.

I think the previous steps make sense at vhost_dev_stop, not virtio
savevm handlers. To start spreading this logic to more places of qemu
can bring confusion.

> - Loading the device's state is done by SUSPEND followed by
> SET_DEVICE_STATE_FD, followed by RESUME.
>

I think the restore makes more sense after reset and before driver_ok,
suspend does not seem a right call there. SUSPEND implies there may be
other operations before, so the device may have processed some
requests wrong, as it is not in the right state.

Thanks!

