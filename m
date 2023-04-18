Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681850426; x=1684442426;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KvkvuzaJt9OOxJHdmTgp0E8UaPpTItbiElJerMv19pE=;
 b=OiZCn2OkiVk8lbOW58CrEN8S8D+oCufJShwnc72o7QUILp+lNlsOBoPMimtR8dSXy5
 oOy5o4180qle5bE9HkWN3B3Wsv7x7KyK7XqFQj+ECg0okIX0TA6o5t/thhOPFSqUD88m
 E23NtvNDK1dpi7X195/5jO5W84aKxZUKPLZaB8TIdlHZFx/zslJ7LvhTi3PadpFwqBe+
 23c4fBSnFQbLbpQoq2fXAaidPx9FgITgUF5M4P3faaH+aZsgwDyg3B6JSYHWBtn3UzxQ
 xXQQjgTZZJCILjZq/RYhX/jjeSzNqfLvtKwmfmegsz6HAN7SpcYFavYpNa2JLaE1E5eG
 EaDQ==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
 <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
 <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
 <CAJaqyWfaDVZDJtMvPUhdRE283e80rB3WFd3RF9i=buaBYG=PKA@mail.gmail.com>
 <20230418175924.GB4041499@fedora>
 <CAJaqyWd9Ec7hpfv_NUDxOuwK4weyRTm-cVNOuv8VTiGVzyYjHQ@mail.gmail.com>
In-Reply-To: <CAJaqyWd9Ec7hpfv_NUDxOuwK4weyRTm-cVNOuv8VTiGVzyYjHQ@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 18 Apr 2023 16:40:13 -0400
Message-ID: <CAJSP0QWx_9TJa_0QRfhNg6JQemAWCc0ZagvkSxj15bbM5tGD4w@mail.gmail.com>
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

On Tue, 18 Apr 2023 at 14:31, Eugenio Perez Martin <eperezma@redhat.com> wr=
ote:
>
> On Tue, Apr 18, 2023 at 7:59=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Tue, Apr 18, 2023 at 10:09:30AM +0200, Eugenio Perez Martin wrote:
> > > On Mon, Apr 17, 2023 at 9:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gma=
il.com> wrote:
> > > >
> > > > On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <eperezma@redhat=
.com> wrote:
> > > > >
> > > > > On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stefanha=
@redhat.com> wrote:
> > > > > >
> > > > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin =
wrote:
> > > > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <ste=
fanha@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wr=
ote:
> > > > > > > > > So-called "internal" virtio-fs migration refers to transp=
orting the
> > > > > > > > > back-end's (virtiofsd's) state through qemu's migration s=
tream.  To do
> > > > > > > > > this, we need to be able to transfer virtiofsd's internal=
 state to and
> > > > > > > > > from virtiofsd.
> > > > > > > > >
> > > > > > > > > Because virtiofsd's internal state will not be too large,=
 we believe it
> > > > > > > > > is best to transfer it as a single binary blob after the =
streaming
> > > > > > > > > phase.  Because this method should be useful to other vho=
st-user
> > > > > > > > > implementations, too, it is introduced as a general-purpo=
se addition to
> > > > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > > > >
> > > > > > > > > These are the additions to the protocol:
> > > > > > > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_M=
IGRATORY_STATE:
> > > > > > > > >   This feature signals support for transferring state, an=
d is added so
> > > > > > > > >   that migration can fail early when the back-end has no =
support.
> > > > > > > > >
> > > > > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end ne=
gotiate a pipe
> > > > > > > > >   over which to transfer the state.  The front-end sends =
an FD to the
> > > > > > > > >   back-end into/from which it can write/read its state, a=
nd the back-end
> > > > > > > > >   can decide to either use it, or reply with a different =
FD for the
> > > > > > > > >   front-end to override the front-end's choice.
> > > > > > > > >   The front-end creates a simple pipe to transfer the sta=
te, but maybe
> > > > > > > > >   the back-end already has an FD into/from which it has t=
o write/read
> > > > > > > > >   its state, in which case it will want to override the s=
imple pipe.
> > > > > > > > >   Conversely, maybe in the future we find a way to have t=
he front-end
> > > > > > > > >   get an immediate FD for the migration stream (in some c=
ases), in which
> > > > > > > > >   case we will want to send this to the back-end instead =
of creating a
> > > > > > > > >   pipe.
> > > > > > > > >   Hence the negotiation: If one side has a better idea th=
an a plain
> > > > > > > > >   pipe, we will want to use that.
> > > > > > > > >
> > > > > > > > > - CHECK_DEVICE_STATE: After the state has been transferre=
d through the
> > > > > > > > >   pipe (the end indicated by EOF), the front-end invokes =
this function
> > > > > > > > >   to verify success.  There is no in-band way (through th=
e pipe) to
> > > > > > > > >   indicate failure, so we need to check explicitly.
> > > > > > > > >
> > > > > > > > > Once the transfer pipe has been established via SET_DEVIC=
E_STATE_FD
> > > > > > > > > (which includes establishing the direction of transfer an=
d migration
> > > > > > > > > phase), the sending side writes its data into the pipe, a=
nd the reading
> > > > > > > > > side reads it until it sees an EOF.  Then, the front-end =
will check for
> > > > > > > > > success via CHECK_DEVICE_STATE, which on the destination =
side includes
> > > > > > > > > checking for integrity (i.e. errors during deserializatio=
n).
> > > > > > > > >
> > > > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > > > ---
> > > > > > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > > > > > > >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++=
++++++++++++++
> > > > > > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > > > > > >  4 files changed, 287 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/=
hw/virtio/vhost-backend.h
> > > > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > > > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > > > >  } VhostSetConfigType;
> > > > > > > > >
> > > > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > > > +    /* Transfer state from back-end (device) to front-en=
d */
> > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > > > +    /* Transfer state from front-end to back-end (device=
) */
> > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > > > +} VhostDeviceStateDirection;
> > > > > > > > > +
> > > > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > > > +    /* The device (and all its vrings) is stopped */
> > > > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > > > +} VhostDeviceStatePhase;
> > > > > > > >
> > > > > > > > vDPA has:
> > > > > > > >
> > > > > > > >   /* Suspend a device so it does not process virtqueue requ=
ests anymore
> > > > > > > >    *
> > > > > > > >    * After the return of ioctl the device must preserve all=
 the necessary state
> > > > > > > >    * (the virtqueue vring base plus the possible device spe=
cific states) that is
> > > > > > > >    * required for restoring in the future. The device must =
not change its
> > > > > > > >    * configuration after that point.
> > > > > > > >    */
> > > > > > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > > > > > >
> > > > > > > >   /* Resume a device so it can resume processing virtqueue =
requests
> > > > > > > >    *
> > > > > > > >    * After the return of this ioctl the device will have re=
stored all the
> > > > > > > >    * necessary states and it is fully operational to contin=
ue processing the
> > > > > > > >    * virtqueue descriptors.
> > > > > > > >    */
> > > > > > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > > > > > >
> > > > > > > > I wonder if it makes sense to import these into vhost-user =
so that the
> > > > > > > > difference between kernel vhost and vhost-user is minimized=
. It's okay
> > > > > > > > if one of them is ahead of the other, but it would be nice =
to avoid
> > > > > > > > overlapping/duplicated functionality.
> > > > > > > >
> > > > > > >
> > > > > > > That's what I had in mind in the first versions. I proposed V=
HOST_STOP
> > > > > > > instead of VHOST_VDPA_STOP for this very reason. Later it did=
 change
> > > > > > > to SUSPEND.
> > > > > >
> > > > > > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> > > > > > ioctl(VHOST_VDPA_RESUME).
> > > > > >
> > > > > > The doc comments in <linux/vdpa.h> don't explain how the device=
 can
> > > > > > leave the suspended state. Can you clarify this?
> > > > > >
> > > > >
> > > > > Do you mean in what situations or regarding the semantics of _RES=
UME?
> > > > >
> > > > > To me resume is an operation mainly to resume the device in the e=
vent
> > > > > of a VM suspension, not a migration. It can be used as a fallback=
 code
> > > > > in some cases of migration failure though, but it is not currentl=
y
> > > > > used in qemu.
> > > >
> > > > Is a "VM suspension" the QEMU HMP 'stop' command?
> > > >
> > > > I guess the reason why QEMU doesn't call RESUME anywhere is that it
> > > > resets the device in vhost_dev_stop()?
> > > >
> > >
> > > The actual reason for not using RESUME is that the ioctl was added
> > > after the SUSPEND design in qemu. Same as this proposal, it is was no=
t
> > > needed at the time.
> > >
> > > In the case of vhost-vdpa net, the only usage of suspend is to fetch
> > > the vq indexes, and in case of error vhost already fetches them from
> > > guest's used ring way before vDPA, so it has little usage.
> > >
> > > > Does it make sense to combine SUSPEND and RESUME with Hanna's
> > > > SET_DEVICE_STATE_FD? For example, non-iterative migration works lik=
e
> > > > this:
> > > > - Saving the device's state is done by SUSPEND followed by
> > > > SET_DEVICE_STATE_FD. If the guest needs to continue executing (e.g.
> > > > savevm command or migration failed), then RESUME is called to
> > > > continue.
> > >
> > > I think the previous steps make sense at vhost_dev_stop, not virtio
> > > savevm handlers. To start spreading this logic to more places of qemu
> > > can bring confusion.
> >
> > I don't think there is a way around extending the QEMU vhost's code
> > model. The current model in QEMU's vhost code is that the backend is
> > reset when the VM stops. This model worked fine for stateless devices
> > but it doesn't work for stateful devices.
> >
> > Imagine a vdpa-gpu device: you cannot reset the device in
> > vhost_dev_stop() and expect the GPU to continue working when
> > vhost_dev_start() is called again because all its state has been lost.
> > The guest driver will send requests that references a virtio-gpu
> > resources that no longer exist.
> >
> > One solution is to save the device's state in vhost_dev_stop(). I think
> > this is what you're suggesting. It requires keeping a copy of the state
> > and then loading the state again in vhost_dev_start(). I don't think
> > this approach should be used because it requires all stateful devices t=
o
> > support live migration (otherwise they break across HMP 'stop'/'cont').
> > Also, the device state for some devices may be large and it would also
> > become more complicated when iterative migration is added.
> >
> > Instead, I think the QEMU vhost code needs to be structured so that
> > struct vhost_dev has a suspended state:
> >
> >         ,---------.
> >         v         |
> >   started ------> stopped
> >     \   ^
> >      \  |
> >       -> suspended
> >
> > The device doesn't lose state when it enters the suspended state. It ca=
n
> > be resumed again.
> >
> > This is why I think SUSPEND/RESUME need to be part of the solution.
>
> I agree with all of this, especially after realizing vhost_dev_stop is
> called before the last request of the state in the iterative
> migration.
>
> However I think we can move faster with the virtiofsd migration code,
> as long as we agree on the vhost-user messages it will receive. This
> is because we already agree that the state will be sent in one shot
> and not iteratively, so it will be small.
>
> I understand this may change in the future, that's why I proposed to
> start using iterative right now. However it may make little sense if
> it is not used in the vhost-user device. I also understand that other
> devices may have a bigger state so it will be needed for them.

Can you summarize how you'd like save to work today? I'm not sure what
you have in mind.

Stefan

