Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
 <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
 <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
 <CAJaqyWfaDVZDJtMvPUhdRE283e80rB3WFd3RF9i=buaBYG=PKA@mail.gmail.com>
 <20230418175924.GB4041499@fedora>
 <CAJaqyWd9Ec7hpfv_NUDxOuwK4weyRTm-cVNOuv8VTiGVzyYjHQ@mail.gmail.com>
 <CAJSP0QWx_9TJa_0QRfhNg6JQemAWCc0ZagvkSxj15bbM5tGD4w@mail.gmail.com>
 <a95c1ad494ce5f8d7f27af788708966e7ba1925a.camel@redhat.com>
 <20230508191235.GA926999@fedora>
In-Reply-To: <20230508191235.GA926999@fedora>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 9 May 2023 08:31:53 +0200
Message-ID: <CAJaqyWdAyVaLJykLEkHwK3BpcvP2RPJQ1ok02F9LRe26QT75Aw@mail.gmail.com>
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
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Mon, May 8, 2023 at 9:12=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
>
> On Thu, Apr 20, 2023 at 03:27:51PM +0200, Eugenio P=C3=A9rez wrote:
> > On Tue, 2023-04-18 at 16:40 -0400, Stefan Hajnoczi wrote:
> > > On Tue, 18 Apr 2023 at 14:31, Eugenio Perez Martin <eperezma@redhat.c=
om>
> > > wrote:
> > > > On Tue, Apr 18, 2023 at 7:59=E2=80=AFPM Stefan Hajnoczi <stefanha@r=
edhat.com> wrote:
> > > > > On Tue, Apr 18, 2023 at 10:09:30AM +0200, Eugenio Perez Martin wr=
ote:
> > > > > > On Mon, Apr 17, 2023 at 9:33=E2=80=AFPM Stefan Hajnoczi <stefan=
ha@gmail.com>
> > > > > > wrote:
> > > > > > > On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <
> > > > > > > eperezma@redhat.com> wrote:
> > > > > > > > On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <st=
efanha@redhat.com
> > > > > > > > > wrote:
> > > > > > > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez M=
artin
> > > > > > > > > wrote:
> > > > > > > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnocz=
i <
> > > > > > > > > > stefanha@redhat.com> wrote:
> > > > > > > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenc=
zek
> > > > > > > > > > > wrote:
> > > > > > > > > > > > So-called "internal" virtio-fs migration refers to
> > > > > > > > > > > > transporting the
> > > > > > > > > > > > back-end's (virtiofsd's) state through qemu's migra=
tion
> > > > > > > > > > > > stream.  To do
> > > > > > > > > > > > this, we need to be able to transfer virtiofsd's in=
ternal
> > > > > > > > > > > > state to and
> > > > > > > > > > > > from virtiofsd.
> > > > > > > > > > > >
> > > > > > > > > > > > Because virtiofsd's internal state will not be too =
large, we
> > > > > > > > > > > > believe it
> > > > > > > > > > > > is best to transfer it as a single binary blob afte=
r the
> > > > > > > > > > > > streaming
> > > > > > > > > > > > phase.  Because this method should be useful to oth=
er vhost-
> > > > > > > > > > > > user
> > > > > > > > > > > > implementations, too, it is introduced as a general=
-purpose
> > > > > > > > > > > > addition to
> > > > > > > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > > > > > > >
> > > > > > > > > > > > These are the additions to the protocol:
> > > > > > > > > > > > - New vhost-user protocol feature
> > > > > > > > > > > > VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
> > > > > > > > > > > >   This feature signals support for transferring sta=
te, and
> > > > > > > > > > > > is added so
> > > > > > > > > > > >   that migration can fail early when the back-end h=
as no
> > > > > > > > > > > > support.
> > > > > > > > > > > >
> > > > > > > > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-=
end
> > > > > > > > > > > > negotiate a pipe
> > > > > > > > > > > >   over which to transfer the state.  The front-end =
sends an
> > > > > > > > > > > > FD to the
> > > > > > > > > > > >   back-end into/from which it can write/read its st=
ate, and
> > > > > > > > > > > > the back-end
> > > > > > > > > > > >   can decide to either use it, or reply with a diff=
erent FD
> > > > > > > > > > > > for the
> > > > > > > > > > > >   front-end to override the front-end's choice.
> > > > > > > > > > > >   The front-end creates a simple pipe to transfer t=
he state,
> > > > > > > > > > > > but maybe
> > > > > > > > > > > >   the back-end already has an FD into/from which it=
 has to
> > > > > > > > > > > > write/read
> > > > > > > > > > > >   its state, in which case it will want to override=
 the
> > > > > > > > > > > > simple pipe.
> > > > > > > > > > > >   Conversely, maybe in the future we find a way to =
have the
> > > > > > > > > > > > front-end
> > > > > > > > > > > >   get an immediate FD for the migration stream (in =
some
> > > > > > > > > > > > cases), in which
> > > > > > > > > > > >   case we will want to send this to the back-end in=
stead of
> > > > > > > > > > > > creating a
> > > > > > > > > > > >   pipe.
> > > > > > > > > > > >   Hence the negotiation: If one side has a better i=
dea than
> > > > > > > > > > > > a plain
> > > > > > > > > > > >   pipe, we will want to use that.
> > > > > > > > > > > >
> > > > > > > > > > > > - CHECK_DEVICE_STATE: After the state has been tran=
sferred
> > > > > > > > > > > > through the
> > > > > > > > > > > >   pipe (the end indicated by EOF), the front-end in=
vokes
> > > > > > > > > > > > this function
> > > > > > > > > > > >   to verify success.  There is no in-band way (thro=
ugh the
> > > > > > > > > > > > pipe) to
> > > > > > > > > > > >   indicate failure, so we need to check explicitly.
> > > > > > > > > > > >
> > > > > > > > > > > > Once the transfer pipe has been established via
> > > > > > > > > > > > SET_DEVICE_STATE_FD
> > > > > > > > > > > > (which includes establishing the direction of trans=
fer and
> > > > > > > > > > > > migration
> > > > > > > > > > > > phase), the sending side writes its data into the p=
ipe, and
> > > > > > > > > > > > the reading
> > > > > > > > > > > > side reads it until it sees an EOF.  Then, the fron=
t-end
> > > > > > > > > > > > will check for
> > > > > > > > > > > > success via CHECK_DEVICE_STATE, which on the destin=
ation
> > > > > > > > > > > > side includes
> > > > > > > > > > > > checking for integrity (i.e. errors during deserial=
ization).
> > > > > > > > > > > >
> > > > > > > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > > > > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++=
++++++
> > > > > > > > > > > >  hw/virtio/vhost-user.c            | 147
> > > > > > > > > > > > ++++++++++++++++++++++++++++++
> > > > > > > > > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > > > > > > > > >  4 files changed, 287 insertions(+)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType =
{
> > > > > > > > > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > > > > > > >  } VhostSetConfigType;
> > > > > > > > > > > >
> > > > > > > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > > > > > > +    /* Transfer state from back-end (device) to fr=
ont-end
> > > > > > > > > > > > */
> > > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > > > > > > +    /* Transfer state from front-end to back-end (=
device)
> > > > > > > > > > > > */
> > > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > > > > > > +} VhostDeviceStateDirection;
> > > > > > > > > > > > +
> > > > > > > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > > > > > > +    /* The device (and all its vrings) is stopped =
*/
> > > > > > > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > > > > > > +} VhostDeviceStatePhase;
> > > > > > > > > > >
> > > > > > > > > > > vDPA has:
> > > > > > > > > > >
> > > > > > > > > > >   /* Suspend a device so it does not process virtqueu=
e
> > > > > > > > > > > requests anymore
> > > > > > > > > > >    *
> > > > > > > > > > >    * After the return of ioctl the device must preser=
ve all
> > > > > > > > > > > the necessary state
> > > > > > > > > > >    * (the virtqueue vring base plus the possible devi=
ce
> > > > > > > > > > > specific states) that is
> > > > > > > > > > >    * required for restoring in the future. The device=
 must not
> > > > > > > > > > > change its
> > > > > > > > > > >    * configuration after that point.
> > > > > > > > > > >    */
> > > > > > > > > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0=
x7D)
> > > > > > > > > > >
> > > > > > > > > > >   /* Resume a device so it can resume processing virt=
queue
> > > > > > > > > > > requests
> > > > > > > > > > >    *
> > > > > > > > > > >    * After the return of this ioctl the device will h=
ave
> > > > > > > > > > > restored all the
> > > > > > > > > > >    * necessary states and it is fully operational to =
continue
> > > > > > > > > > > processing the
> > > > > > > > > > >    * virtqueue descriptors.
> > > > > > > > > > >    */
> > > > > > > > > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0=
x7E)
> > > > > > > > > > >
> > > > > > > > > > > I wonder if it makes sense to import these into vhost=
-user so
> > > > > > > > > > > that the
> > > > > > > > > > > difference between kernel vhost and vhost-user is min=
imized.
> > > > > > > > > > > It's okay
> > > > > > > > > > > if one of them is ahead of the other, but it would be=
 nice to
> > > > > > > > > > > avoid
> > > > > > > > > > > overlapping/duplicated functionality.
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > That's what I had in mind in the first versions. I prop=
osed
> > > > > > > > > > VHOST_STOP
> > > > > > > > > > instead of VHOST_VDPA_STOP for this very reason. Later =
it did
> > > > > > > > > > change
> > > > > > > > > > to SUSPEND.
> > > > > > > > >
> > > > > > > > > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and n=
ot
> > > > > > > > > ioctl(VHOST_VDPA_RESUME).
> > > > > > > > >
> > > > > > > > > The doc comments in <linux/vdpa.h> don't explain how the =
device
> > > > > > > > > can
> > > > > > > > > leave the suspended state. Can you clarify this?
> > > > > > > > >
> > > > > > > >
> > > > > > > > Do you mean in what situations or regarding the semantics o=
f
> > > > > > > > _RESUME?
> > > > > > > >
> > > > > > > > To me resume is an operation mainly to resume the device in=
 the
> > > > > > > > event
> > > > > > > > of a VM suspension, not a migration. It can be used as a fa=
llback
> > > > > > > > code
> > > > > > > > in some cases of migration failure though, but it is not cu=
rrently
> > > > > > > > used in qemu.
> > > > > > >
> > > > > > > Is a "VM suspension" the QEMU HMP 'stop' command?
> > > > > > >
> > > > > > > I guess the reason why QEMU doesn't call RESUME anywhere is t=
hat it
> > > > > > > resets the device in vhost_dev_stop()?
> > > > > > >
> > > > > >
> > > > > > The actual reason for not using RESUME is that the ioctl was ad=
ded
> > > > > > after the SUSPEND design in qemu. Same as this proposal, it is =
was not
> > > > > > needed at the time.
> > > > > >
> > > > > > In the case of vhost-vdpa net, the only usage of suspend is to =
fetch
> > > > > > the vq indexes, and in case of error vhost already fetches them=
 from
> > > > > > guest's used ring way before vDPA, so it has little usage.
> > > > > >
> > > > > > > Does it make sense to combine SUSPEND and RESUME with Hanna's
> > > > > > > SET_DEVICE_STATE_FD? For example, non-iterative migration wor=
ks like
> > > > > > > this:
> > > > > > > - Saving the device's state is done by SUSPEND followed by
> > > > > > > SET_DEVICE_STATE_FD. If the guest needs to continue executing=
 (e.g.
> > > > > > > savevm command or migration failed), then RESUME is called to
> > > > > > > continue.
> > > > > >
> > > > > > I think the previous steps make sense at vhost_dev_stop, not vi=
rtio
> > > > > > savevm handlers. To start spreading this logic to more places o=
f qemu
> > > > > > can bring confusion.
> > > > >
> > > > > I don't think there is a way around extending the QEMU vhost's co=
de
> > > > > model. The current model in QEMU's vhost code is that the backend=
 is
> > > > > reset when the VM stops. This model worked fine for stateless dev=
ices
> > > > > but it doesn't work for stateful devices.
> > > > >
> > > > > Imagine a vdpa-gpu device: you cannot reset the device in
> > > > > vhost_dev_stop() and expect the GPU to continue working when
> > > > > vhost_dev_start() is called again because all its state has been =
lost.
> > > > > The guest driver will send requests that references a virtio-gpu
> > > > > resources that no longer exist.
> > > > >
> > > > > One solution is to save the device's state in vhost_dev_stop(). I=
 think
> > > > > this is what you're suggesting. It requires keeping a copy of the=
 state
> > > > > and then loading the state again in vhost_dev_start(). I don't th=
ink
> > > > > this approach should be used because it requires all stateful dev=
ices to
> > > > > support live migration (otherwise they break across HMP 'stop'/'c=
ont').
> > > > > Also, the device state for some devices may be large and it would=
 also
> > > > > become more complicated when iterative migration is added.
> > > > >
> > > > > Instead, I think the QEMU vhost code needs to be structured so th=
at
> > > > > struct vhost_dev has a suspended state:
> > > > >
> > > > >         ,---------.
> > > > >         v         |
> > > > >   started ------> stopped
> > > > >     \   ^
> > > > >      \  |
> > > > >       -> suspended
> > > > >
> > > > > The device doesn't lose state when it enters the suspended state.=
 It can
> > > > > be resumed again.
> > > > >
> > > > > This is why I think SUSPEND/RESUME need to be part of the solutio=
n.
> >
> > I just realize that we can add an arrow from suspended to stopped, isn'=
t it?
>
> Yes, it could be used in the case of a successful live migration:
> [started] -> vhost_dev_suspend() [suspended] -> vhost_dev_stop() [stopped=
]
>
> > "Started" before seems to imply the device may process descriptors afte=
r
> > suspend.
>
> Yes, in the case of a failed live migration:
> [started] -> vhost_dev_suspend() [suspended] -> vhost_dev_resume() [start=
ed]
>

I meant "the device may (is allowed) to process descriptors after
suspend and before stopped". I think we have the same view here, just
trying to specify the semantics here as completely as possible :).

> > > >
> > > > I agree with all of this, especially after realizing vhost_dev_stop=
 is
> > > > called before the last request of the state in the iterative
> > > > migration.
> > > >
> > > > However I think we can move faster with the virtiofsd migration cod=
e,
> > > > as long as we agree on the vhost-user messages it will receive. Thi=
s
> > > > is because we already agree that the state will be sent in one shot
> > > > and not iteratively, so it will be small.
> > > >
> > > > I understand this may change in the future, that's why I proposed t=
o
> > > > start using iterative right now. However it may make little sense i=
f
> > > > it is not used in the vhost-user device. I also understand that oth=
er
> > > > devices may have a bigger state so it will be needed for them.
> > >
> > > Can you summarize how you'd like save to work today? I'm not sure wha=
t
> > > you have in mind.
> > >
> >
> > I think we're trying to find a solution that satisfies many things.  On=
 one
> > side, we're assuming that the virtiofsd state will be small enough to b=
e
> > assumable it will not require iterative migration in the short term.  H=
owever,
> > we also want to support iterative migration, for the shake of *other* f=
uture
> > vhost devices that may need it.
> >
> > I also think we should prioritize the protocols stability, in the sense=
 of not
> > adding calls that we will not reuse for iterative LM.  Being vhost-user=
 protocol
> > more important to maintain than the qemu migration.
> >
> > To implement the changes you mention will be needed in the future.  But=
 we have
> > already set that the virtiofsd is small, so we can just fetch them by t=
he same
> > time than we send VHOST_USER_GET_VRING_BASE message and send the status=
 with the
> > proposed non-iterative approach.
>
> VHOST_USER_GET_VRING_BASE itself isn't really enough because it stops a
> specific virtqueue but not the whole device. Unfortunately stopping all
> virtqueues is not the same as SUSPEND since spontaneous device activity
> is possible independent of any virtqueue (e.g. virtio-scsi events and
> maybe virtio-net link status).
>
> That's why I think SUSPEND is necessary for a solution that's generic
> enough to cover all device types.
>

I agree.

In particular virtiofsd is already resetting all the device at
VHOST_USER_GET_VRING_BASE if I'm not wrong, so that's even more of a
reason to implement suspend call.

Thanks!

> > If we agree on that, now the question is how to fetch them from the dev=
ice.  The
> > answers are a little bit scattered in the mail threads, but I think we =
agree on:
> > a) We need to signal that the device must stop processing requests.
> > b) We need a way for the device to dump the state.
> >
> > At this moment I think any proposal satisfies a), and pipe satisfies be=
tter b).
> > With proper backend feature flags, the device may support to start writ=
ing to
> > the pipe before SUSPEND so we can implement iterative migration on top.
> >
> > Does that makes sense?
>
> Yes, and that sounds like what Hanna is proposing for b) plus our
> discussion about SUSPEND/RESUME in order to achieve a).
>
> Stefan

