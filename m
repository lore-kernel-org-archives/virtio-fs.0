Return-Path: <stefanha@redhat.com>
Date: Mon, 8 May 2023 15:12:35 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230508191235.GA926999@fedora>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="ktahPsbQqG+ks/jL"
Content-Disposition: inline
In-Reply-To: <a95c1ad494ce5f8d7f27af788708966e7ba1925a.camel@redhat.com>
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
To: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--ktahPsbQqG+ks/jL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 03:27:51PM +0200, Eugenio P=C3=A9rez wrote:
> On Tue, 2023-04-18 at 16:40 -0400, Stefan Hajnoczi wrote:
> > On Tue, 18 Apr 2023 at 14:31, Eugenio Perez Martin <eperezma@redhat.com>
> > wrote:
> > > On Tue, Apr 18, 2023 at 7:59=E2=80=AFPM Stefan Hajnoczi <stefanha@red=
hat.com> wrote:
> > > > On Tue, Apr 18, 2023 at 10:09:30AM +0200, Eugenio Perez Martin wrot=
e:
> > > > > On Mon, Apr 17, 2023 at 9:33=E2=80=AFPM Stefan Hajnoczi <stefanha=
@gmail.com>
> > > > > wrote:
> > > > > > On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <
> > > > > > eperezma@redhat.com> wrote:
> > > > > > > On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stef=
anha@redhat.com
> > > > > > > > wrote:
> > > > > > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Mar=
tin
> > > > > > > > wrote:
> > > > > > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <
> > > > > > > > > stefanha@redhat.com> wrote:
> > > > > > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek
> > > > > > > > > > wrote:
> > > > > > > > > > > So-called "internal" virtio-fs migration refers to
> > > > > > > > > > > transporting the
> > > > > > > > > > > back-end's (virtiofsd's) state through qemu's migrati=
on
> > > > > > > > > > > stream.  To do
> > > > > > > > > > > this, we need to be able to transfer virtiofsd's inte=
rnal
> > > > > > > > > > > state to and
> > > > > > > > > > > from virtiofsd.
> > > > > > > > > > >=20
> > > > > > > > > > > Because virtiofsd's internal state will not be too la=
rge, we
> > > > > > > > > > > believe it
> > > > > > > > > > > is best to transfer it as a single binary blob after =
the
> > > > > > > > > > > streaming
> > > > > > > > > > > phase.  Because this method should be useful to other=
 vhost-
> > > > > > > > > > > user
> > > > > > > > > > > implementations, too, it is introduced as a general-p=
urpose
> > > > > > > > > > > addition to
> > > > > > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > > > > > >=20
> > > > > > > > > > > These are the additions to the protocol:
> > > > > > > > > > > - New vhost-user protocol feature
> > > > > > > > > > > VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
> > > > > > > > > > >   This feature signals support for transferring state=
, and
> > > > > > > > > > > is added so
> > > > > > > > > > >   that migration can fail early when the back-end has=
 no
> > > > > > > > > > > support.
> > > > > > > > > > >=20
> > > > > > > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end
> > > > > > > > > > > negotiate a pipe
> > > > > > > > > > >   over which to transfer the state.  The front-end se=
nds an
> > > > > > > > > > > FD to the
> > > > > > > > > > >   back-end into/from which it can write/read its stat=
e, and
> > > > > > > > > > > the back-end
> > > > > > > > > > >   can decide to either use it, or reply with a differ=
ent FD
> > > > > > > > > > > for the
> > > > > > > > > > >   front-end to override the front-end's choice.
> > > > > > > > > > >   The front-end creates a simple pipe to transfer the=
 state,
> > > > > > > > > > > but maybe
> > > > > > > > > > >   the back-end already has an FD into/from which it h=
as to
> > > > > > > > > > > write/read
> > > > > > > > > > >   its state, in which case it will want to override t=
he
> > > > > > > > > > > simple pipe.
> > > > > > > > > > >   Conversely, maybe in the future we find a way to ha=
ve the
> > > > > > > > > > > front-end
> > > > > > > > > > >   get an immediate FD for the migration stream (in so=
me
> > > > > > > > > > > cases), in which
> > > > > > > > > > >   case we will want to send this to the back-end inst=
ead of
> > > > > > > > > > > creating a
> > > > > > > > > > >   pipe.
> > > > > > > > > > >   Hence the negotiation: If one side has a better ide=
a than
> > > > > > > > > > > a plain
> > > > > > > > > > >   pipe, we will want to use that.
> > > > > > > > > > >=20
> > > > > > > > > > > - CHECK_DEVICE_STATE: After the state has been transf=
erred
> > > > > > > > > > > through the
> > > > > > > > > > >   pipe (the end indicated by EOF), the front-end invo=
kes
> > > > > > > > > > > this function
> > > > > > > > > > >   to verify success.  There is no in-band way (throug=
h the
> > > > > > > > > > > pipe) to
> > > > > > > > > > >   indicate failure, so we need to check explicitly.
> > > > > > > > > > >=20
> > > > > > > > > > > Once the transfer pipe has been established via
> > > > > > > > > > > SET_DEVICE_STATE_FD
> > > > > > > > > > > (which includes establishing the direction of transfe=
r and
> > > > > > > > > > > migration
> > > > > > > > > > > phase), the sending side writes its data into the pip=
e, and
> > > > > > > > > > > the reading
> > > > > > > > > > > side reads it until it sees an EOF.  Then, the front-=
end
> > > > > > > > > > > will check for
> > > > > > > > > > > success via CHECK_DEVICE_STATE, which on the destinat=
ion
> > > > > > > > > > > side includes
> > > > > > > > > > > checking for integrity (i.e. errors during deserializ=
ation).
> > > > > > > > > > >=20
> > > > > > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > > > > > ---
> > > > > > > > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > > > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++=
++++
> > > > > > > > > > >  hw/virtio/vhost-user.c            | 147
> > > > > > > > > > > ++++++++++++++++++++++++++++++
> > > > > > > > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > > > > > > > >  4 files changed, 287 insertions(+)
> > > > > > > > > > >=20
> > > > > > > > > > > diff --git a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > > > > > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > > > > > >  } VhostSetConfigType;
> > > > > > > > > > >=20
> > > > > > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > > > > > +    /* Transfer state from back-end (device) to fron=
t-end
> > > > > > > > > > > */
> > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > > > > > +    /* Transfer state from front-end to back-end (de=
vice)
> > > > > > > > > > > */
> > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > > > > > +} VhostDeviceStateDirection;
> > > > > > > > > > > +
> > > > > > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > > > > > +    /* The device (and all its vrings) is stopped */
> > > > > > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > > > > > +} VhostDeviceStatePhase;
> > > > > > > > > >=20
> > > > > > > > > > vDPA has:
> > > > > > > > > >=20
> > > > > > > > > >   /* Suspend a device so it does not process virtqueue
> > > > > > > > > > requests anymore
> > > > > > > > > >    *
> > > > > > > > > >    * After the return of ioctl the device must preserve=
 all
> > > > > > > > > > the necessary state
> > > > > > > > > >    * (the virtqueue vring base plus the possible device
> > > > > > > > > > specific states) that is
> > > > > > > > > >    * required for restoring in the future. The device m=
ust not
> > > > > > > > > > change its
> > > > > > > > > >    * configuration after that point.
> > > > > > > > > >    */
> > > > > > > > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7=
D)
> > > > > > > > > >=20
> > > > > > > > > >   /* Resume a device so it can resume processing virtqu=
eue
> > > > > > > > > > requests
> > > > > > > > > >    *
> > > > > > > > > >    * After the return of this ioctl the device will have
> > > > > > > > > > restored all the
> > > > > > > > > >    * necessary states and it is fully operational to co=
ntinue
> > > > > > > > > > processing the
> > > > > > > > > >    * virtqueue descriptors.
> > > > > > > > > >    */
> > > > > > > > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7=
E)
> > > > > > > > > >=20
> > > > > > > > > > I wonder if it makes sense to import these into vhost-u=
ser so
> > > > > > > > > > that the
> > > > > > > > > > difference between kernel vhost and vhost-user is minim=
ized.
> > > > > > > > > > It's okay
> > > > > > > > > > if one of them is ahead of the other, but it would be n=
ice to
> > > > > > > > > > avoid
> > > > > > > > > > overlapping/duplicated functionality.
> > > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > That's what I had in mind in the first versions. I propos=
ed
> > > > > > > > > VHOST_STOP
> > > > > > > > > instead of VHOST_VDPA_STOP for this very reason. Later it=
 did
> > > > > > > > > change
> > > > > > > > > to SUSPEND.
> > > > > > > >=20
> > > > > > > > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> > > > > > > > ioctl(VHOST_VDPA_RESUME).
> > > > > > > >=20
> > > > > > > > The doc comments in <linux/vdpa.h> don't explain how the de=
vice
> > > > > > > > can
> > > > > > > > leave the suspended state. Can you clarify this?
> > > > > > > >=20
> > > > > > >=20
> > > > > > > Do you mean in what situations or regarding the semantics of
> > > > > > > _RESUME?
> > > > > > >=20
> > > > > > > To me resume is an operation mainly to resume the device in t=
he
> > > > > > > event
> > > > > > > of a VM suspension, not a migration. It can be used as a fall=
back
> > > > > > > code
> > > > > > > in some cases of migration failure though, but it is not curr=
ently
> > > > > > > used in qemu.
> > > > > >=20
> > > > > > Is a "VM suspension" the QEMU HMP 'stop' command?
> > > > > >=20
> > > > > > I guess the reason why QEMU doesn't call RESUME anywhere is tha=
t it
> > > > > > resets the device in vhost_dev_stop()?
> > > > > >=20
> > > > >=20
> > > > > The actual reason for not using RESUME is that the ioctl was added
> > > > > after the SUSPEND design in qemu. Same as this proposal, it is wa=
s not
> > > > > needed at the time.
> > > > >=20
> > > > > In the case of vhost-vdpa net, the only usage of suspend is to fe=
tch
> > > > > the vq indexes, and in case of error vhost already fetches them f=
rom
> > > > > guest's used ring way before vDPA, so it has little usage.
> > > > >=20
> > > > > > Does it make sense to combine SUSPEND and RESUME with Hanna's
> > > > > > SET_DEVICE_STATE_FD? For example, non-iterative migration works=
 like
> > > > > > this:
> > > > > > - Saving the device's state is done by SUSPEND followed by
> > > > > > SET_DEVICE_STATE_FD. If the guest needs to continue executing (=
e.g.
> > > > > > savevm command or migration failed), then RESUME is called to
> > > > > > continue.
> > > > >=20
> > > > > I think the previous steps make sense at vhost_dev_stop, not virt=
io
> > > > > savevm handlers. To start spreading this logic to more places of =
qemu
> > > > > can bring confusion.
> > > >=20
> > > > I don't think there is a way around extending the QEMU vhost's code
> > > > model. The current model in QEMU's vhost code is that the backend is
> > > > reset when the VM stops. This model worked fine for stateless devic=
es
> > > > but it doesn't work for stateful devices.
> > > >=20
> > > > Imagine a vdpa-gpu device: you cannot reset the device in
> > > > vhost_dev_stop() and expect the GPU to continue working when
> > > > vhost_dev_start() is called again because all its state has been lo=
st.
> > > > The guest driver will send requests that references a virtio-gpu
> > > > resources that no longer exist.
> > > >=20
> > > > One solution is to save the device's state in vhost_dev_stop(). I t=
hink
> > > > this is what you're suggesting. It requires keeping a copy of the s=
tate
> > > > and then loading the state again in vhost_dev_start(). I don't think
> > > > this approach should be used because it requires all stateful devic=
es to
> > > > support live migration (otherwise they break across HMP 'stop'/'con=
t').
> > > > Also, the device state for some devices may be large and it would a=
lso
> > > > become more complicated when iterative migration is added.
> > > >=20
> > > > Instead, I think the QEMU vhost code needs to be structured so that
> > > > struct vhost_dev has a suspended state:
> > > >=20
> > > >         ,---------.
> > > >         v         |
> > > >   started ------> stopped
> > > >     \   ^
> > > >      \  |
> > > >       -> suspended
> > > >=20
> > > > The device doesn't lose state when it enters the suspended state. I=
t can
> > > > be resumed again.
> > > >=20
> > > > This is why I think SUSPEND/RESUME need to be part of the solution.
>=20
> I just realize that we can add an arrow from suspended to stopped, isn't =
it?

Yes, it could be used in the case of a successful live migration:
[started] -> vhost_dev_suspend() [suspended] -> vhost_dev_stop() [stopped]

> "Started" before seems to imply the device may process descriptors after
> suspend.

Yes, in the case of a failed live migration:
[started] -> vhost_dev_suspend() [suspended] -> vhost_dev_resume() [started]

> > >=20
> > > I agree with all of this, especially after realizing vhost_dev_stop is
> > > called before the last request of the state in the iterative
> > > migration.
> > >=20
> > > However I think we can move faster with the virtiofsd migration code,
> > > as long as we agree on the vhost-user messages it will receive. This
> > > is because we already agree that the state will be sent in one shot
> > > and not iteratively, so it will be small.
> > >=20
> > > I understand this may change in the future, that's why I proposed to
> > > start using iterative right now. However it may make little sense if
> > > it is not used in the vhost-user device. I also understand that other
> > > devices may have a bigger state so it will be needed for them.
> >=20
> > Can you summarize how you'd like save to work today? I'm not sure what
> > you have in mind.
> >=20
>=20
> I think we're trying to find a solution that satisfies many things.  On o=
ne
> side, we're assuming that the virtiofsd state will be small enough to be
> assumable it will not require iterative migration in the short term.  How=
ever,
> we also want to support iterative migration, for the shake of *other* fut=
ure
> vhost devices that may need it.
>=20
> I also think we should prioritize the protocols stability, in the sense o=
f not
> adding calls that we will not reuse for iterative LM.  Being vhost-user p=
rotocol
> more important to maintain than the qemu migration.
>=20
> To implement the changes you mention will be needed in the future.  But w=
e have
> already set that the virtiofsd is small, so we can just fetch them by the=
 same
> time than we send VHOST_USER_GET_VRING_BASE message and send the status w=
ith the
> proposed non-iterative approach.

VHOST_USER_GET_VRING_BASE itself isn't really enough because it stops a
specific virtqueue but not the whole device. Unfortunately stopping all
virtqueues is not the same as SUSPEND since spontaneous device activity
is possible independent of any virtqueue (e.g. virtio-scsi events and
maybe virtio-net link status).

That's why I think SUSPEND is necessary for a solution that's generic
enough to cover all device types.

> If we agree on that, now the question is how to fetch them from the devic=
e.  The
> answers are a little bit scattered in the mail threads, but I think we ag=
ree on:
> a) We need to signal that the device must stop processing requests.
> b) We need a way for the device to dump the state.
>=20
> At this moment I think any proposal satisfies a), and pipe satisfies bett=
er b).=20
> With proper backend feature flags, the device may support to start writin=
g to
> the pipe before SUSPEND so we can implement iterative migration on top.
>=20
> Does that makes sense?

Yes, and that sounds like what Hanna is proposing for b) plus our
discussion about SUSPEND/RESUME in order to achieve a).

Stefan

--ktahPsbQqG+ks/jL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRZSaMACgkQnKSrs4Gr
c8iwDAgAsSFuuhaCT6DUkdfSAvkz5ItZ+Ykh8GKriDkMLjOOlWBuAu5SgdZTuzaR
30ob6cXtFyUHXKKSA8EXQxxVQNNk8wsMRNtKl5F7Y70BiKEhepFN6ZSc0SzNy4cH
txtculF9tSTmp+y2FdtTeP7EoLiq41Vad4Kn7hRndCHZibEQbY5a30K8c1XB396q
8skfupchZk94lueCf8kbDuOvZNUY4fQXbOUrn/Yux/mC/DDADVbCPZVUfO30wV0h
MdaBYgicr2qv8IyCqT38FrjGP6qHk80E95UQ9kfy3yAAc5XZTH0JDSg8l/gd6FdT
ypG27gPV2M4cqfiEvjicxgBYMeivUQ==
=KVY5
-----END PGP SIGNATURE-----

--ktahPsbQqG+ks/jL--
