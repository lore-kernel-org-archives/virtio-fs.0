Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681760004; x=1684352004;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=C4jc7kY4hMOKIb7LeRwCztF6vfL7uf5k0IumTcQQepY=;
 b=rCR5CD2robkihYNsuZKsRRxjNMKjI3baF4qaDe+tktHHAZMA7974i4E/LJ+z2vN7Qk
 LIZwB+dzh9msk2Ac3NMtm/MSw6ef4BHWNN40lqle6f4SaX5f2x36iFThYE1TFNDE47jf
 Iwx2SlcjyGkIZehZ72b5pyhl7SH53VPP+YKtwtAK7zqLwyaclcbSDn7UlmtkxHIlJdJa
 fqIcCC6J0BzLkyg/aXVTtrD/5zM8Vj9XoVOUa5Z0QK4WYFORbRbcMSzskktIbBTPSi3/
 8z7HVpOPKLKGeZU9PK0pikgazXSUrVgj3Pe5h9nKMhQm/0gfQGF387DTe6SXazSTxBZh
 6W9Q==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
 <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
In-Reply-To: <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 17 Apr 2023 15:33:12 -0400
Message-ID: <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
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
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <eperezma@redhat.com> wr=
ote:
>
> On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin wrote:
> > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@re=
dhat.com> wrote:
> > > >
> > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > > So-called "internal" virtio-fs migration refers to transporting t=
he
> > > > > back-end's (virtiofsd's) state through qemu's migration stream.  =
To do
> > > > > this, we need to be able to transfer virtiofsd's internal state t=
o and
> > > > > from virtiofsd.
> > > > >
> > > > > Because virtiofsd's internal state will not be too large, we beli=
eve it
> > > > > is best to transfer it as a single binary blob after the streamin=
g
> > > > > phase.  Because this method should be useful to other vhost-user
> > > > > implementations, too, it is introduced as a general-purpose addit=
ion to
> > > > > the protocol, not limited to vhost-user-fs.
> > > > >
> > > > > These are the additions to the protocol:
> > > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY=
_STATE:
> > > > >   This feature signals support for transferring state, and is add=
ed so
> > > > >   that migration can fail early when the back-end has no support.
> > > > >
> > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate =
a pipe
> > > > >   over which to transfer the state.  The front-end sends an FD to=
 the
> > > > >   back-end into/from which it can write/read its state, and the b=
ack-end
> > > > >   can decide to either use it, or reply with a different FD for t=
he
> > > > >   front-end to override the front-end's choice.
> > > > >   The front-end creates a simple pipe to transfer the state, but =
maybe
> > > > >   the back-end already has an FD into/from which it has to write/=
read
> > > > >   its state, in which case it will want to override the simple pi=
pe.
> > > > >   Conversely, maybe in the future we find a way to have the front=
-end
> > > > >   get an immediate FD for the migration stream (in some cases), i=
n which
> > > > >   case we will want to send this to the back-end instead of creat=
ing a
> > > > >   pipe.
> > > > >   Hence the negotiation: If one side has a better idea than a pla=
in
> > > > >   pipe, we will want to use that.
> > > > >
> > > > > - CHECK_DEVICE_STATE: After the state has been transferred throug=
h the
> > > > >   pipe (the end indicated by EOF), the front-end invokes this fun=
ction
> > > > >   to verify success.  There is no in-band way (through the pipe) =
to
> > > > >   indicate failure, so we need to check explicitly.
> > > > >
> > > > > Once the transfer pipe has been established via SET_DEVICE_STATE_=
FD
> > > > > (which includes establishing the direction of transfer and migrat=
ion
> > > > > phase), the sending side writes its data into the pipe, and the r=
eading
> > > > > side reads it until it sees an EOF.  Then, the front-end will che=
ck for
> > > > > success via CHECK_DEVICE_STATE, which on the destination side inc=
ludes
> > > > > checking for integrity (i.e. errors during deserialization).
> > > > >
> > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > ---
> > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > > >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++=
++++++
> > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > >  4 files changed, 287 insertions(+)
> > > > >
> > > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virti=
o/vhost-backend.h
> > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > >  } VhostSetConfigType;
> > > > >
> > > > > +typedef enum VhostDeviceStateDirection {
> > > > > +    /* Transfer state from back-end (device) to front-end */
> > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > +    /* Transfer state from front-end to back-end (device) */
> > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > +} VhostDeviceStateDirection;
> > > > > +
> > > > > +typedef enum VhostDeviceStatePhase {
> > > > > +    /* The device (and all its vrings) is stopped */
> > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > +} VhostDeviceStatePhase;
> > > >
> > > > vDPA has:
> > > >
> > > >   /* Suspend a device so it does not process virtqueue requests any=
more
> > > >    *
> > > >    * After the return of ioctl the device must preserve all the nec=
essary state
> > > >    * (the virtqueue vring base plus the possible device specific st=
ates) that is
> > > >    * required for restoring in the future. The device must not chan=
ge its
> > > >    * configuration after that point.
> > > >    */
> > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > >
> > > >   /* Resume a device so it can resume processing virtqueue requests
> > > >    *
> > > >    * After the return of this ioctl the device will have restored a=
ll the
> > > >    * necessary states and it is fully operational to continue proce=
ssing the
> > > >    * virtqueue descriptors.
> > > >    */
> > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > >
> > > > I wonder if it makes sense to import these into vhost-user so that =
the
> > > > difference between kernel vhost and vhost-user is minimized. It's o=
kay
> > > > if one of them is ahead of the other, but it would be nice to avoid
> > > > overlapping/duplicated functionality.
> > > >
> > >
> > > That's what I had in mind in the first versions. I proposed VHOST_STO=
P
> > > instead of VHOST_VDPA_STOP for this very reason. Later it did change
> > > to SUSPEND.
> >
> > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> > ioctl(VHOST_VDPA_RESUME).
> >
> > The doc comments in <linux/vdpa.h> don't explain how the device can
> > leave the suspended state. Can you clarify this?
> >
>
> Do you mean in what situations or regarding the semantics of _RESUME?
>
> To me resume is an operation mainly to resume the device in the event
> of a VM suspension, not a migration. It can be used as a fallback code
> in some cases of migration failure though, but it is not currently
> used in qemu.

Is a "VM suspension" the QEMU HMP 'stop' command?

I guess the reason why QEMU doesn't call RESUME anywhere is that it
resets the device in vhost_dev_stop()?

Does it make sense to combine SUSPEND and RESUME with Hanna's
SET_DEVICE_STATE_FD? For example, non-iterative migration works like
this:
- Saving the device's state is done by SUSPEND followed by
SET_DEVICE_STATE_FD. If the guest needs to continue executing (e.g.
savevm command or migration failed), then RESUME is called to
continue.
- Loading the device's state is done by SUSPEND followed by
SET_DEVICE_STATE_FD, followed by RESUME.

Stefan

