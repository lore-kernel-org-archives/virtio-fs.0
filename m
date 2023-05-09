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
 <CAJaqyWdAyVaLJykLEkHwK3BpcvP2RPJQ1ok02F9LRe26QT75Aw@mail.gmail.com>
 <c082fe16-6c83-3445-67fc-26da718d5479@redhat.com>
In-Reply-To: <c082fe16-6c83-3445-67fc-26da718d5479@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 9 May 2023 17:26:21 +0200
Message-ID: <CAJaqyWf3JdGucdpH2Xd7f-W1vuFB2QdLfBX+skzfy9Dv-ZwdNQ@mail.gmail.com>
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
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Tue, May 9, 2023 at 11:01=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> =
wrote:
>
> On 09.05.23 08:31, Eugenio Perez Martin wrote:
> > On Mon, May 8, 2023 at 9:12=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat=
.com> wrote:
>
> [...]
>
> >> VHOST_USER_GET_VRING_BASE itself isn't really enough because it stops =
a
> >> specific virtqueue but not the whole device. Unfortunately stopping al=
l
> >> virtqueues is not the same as SUSPEND since spontaneous device activit=
y
> >> is possible independent of any virtqueue (e.g. virtio-scsi events and
> >> maybe virtio-net link status).
> >>
> >> That's why I think SUSPEND is necessary for a solution that's generic
> >> enough to cover all device types.
> >>
> > I agree.
> >
> > In particular virtiofsd is already resetting all the device at
> > VHOST_USER_GET_VRING_BASE if I'm not wrong, so that's even more of a
> > reason to implement suspend call.
>
> Oh, no, just the vring in question.  Not the whole device.
>
> In addition, we still need the GET_VRING_BASE call anyway, because,
> well, we want to restore the vring on the destination via SET_VRING_BASE.
>

Ok, that makes sense, sorry for the confusion!

Thanks!

