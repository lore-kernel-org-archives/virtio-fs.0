Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681901877; x=1684493877;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=/G1sK8Jh15riGAz1xV1lWtlF/Mn3PHL0U2zrssLXsOo=;
 b=Yjs3clCo/W9K6m9xEkj8Uicv0SxZDUqdCZf4TfYht1GorbLa7jxOj5YyjXYRmyve+e
 zYoFfteKGxEQRsyTevuBzvJm1F9pj3QrW/0Ocqcjzzp41nQGQxZyaAtZZ1ZLvGDSrMBB
 MRR9phcd/KaXBKdbABdg9xOIy2KOhH62L/WGNAgq2Pn1QD33iKi2vczU4ybW/nsRMVFN
 GGeCcehai+yCTHmEND7eV37Vpcgt1saM1x+4VGkN1xQ6zNlgQhBbEIzMi2ziIYKmTFf/
 s+VZfszdybKNtQYNhaU33loBEu5xAK3a403P4jd+6FacLcHGnIp82IvlO42Cryb1Xh61
 3wOQ==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <246691c3-2287-7472-3615-7ec0f074445c@redhat.com>
 <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
 <b0cd4f54-94ed-09a4-cec2-e81f36da4008@redhat.com>
 <CAJaqyWegMfuc8s6bKdxdM4uVixmhy-F3xUUyOCYS1yGDXoiVZA@mail.gmail.com>
 <e4cc0882-c6e0-a830-45d6-e3aab398ab98@redhat.com>
In-Reply-To: <e4cc0882-c6e0-a830-45d6-e3aab398ab98@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 19 Apr 2023 06:57:44 -0400
Message-ID: <CAJSP0QWJJn7=Ck_5TCnGd5DLx9Rwmr_SvS2+nU89eU1A8=pUSQ@mail.gmail.com>
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
Cc: Eugenio Perez Martin <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Wed, 19 Apr 2023 at 06:45, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 14.04.23 17:17, Eugenio Perez Martin wrote:
> > On Thu, Apr 13, 2023 at 7:55=E2=80=AFPM Hanna Czenczek <hreitz@redhat.c=
om> wrote:
>
> [...]
>
> >> Basically, what I=E2=80=99m hearing is that I need to implement a diff=
erent
> >> feature that has no practical impact right now, and also fix bugs arou=
nd
> >> it along the way...
> >>
> > To fix this properly requires iterative device migration in qemu as
> > far as I know, instead of using VMStates [1]. This way the state is
> > requested to virtiofsd before the device reset.
> >
> > What does virtiofsd do when the state is totally sent? Does it keep
> > processing requests and generating new state or is only a one shot
> > that will suspend the daemon? If it is the second I think it still can
> > be done in one shot at the end, always indicating "no more state" at
> > save_live_pending and sending all the state at
> > save_live_complete_precopy.
>
> This sounds to me as if we should reset all devices during migration,
> and I don=E2=80=99t understand that.  virtiofsd will not immediately proc=
ess
> requests when the state is sent, because the device is still stopped,
> but when it is re-enabled (e.g. because of a failed migration), it will
> have retained its state and continue processing requests as if nothing
> happened.  A reset would break this and other stateful back-ends, as I
> think Stefan has mentioned somewhere else.
>
> It seems to me as if there are devices that need a reset, and so need
> suspend+resume around it, but I also think there are back-ends that
> don=E2=80=99t, where this would only unnecessarily complicate the back-en=
d
> implementation.

Existing vhost-user backends must continue working, so I think having
two code paths is (almost) unavoidable.

One approach is to add SUSPEND/RESUME to the vhost-user protocol with
a corresponding VHOST_USER_PROTOCOL_F_SUSPEND feature bit. vhost-user
frontends can identify backends that support SUSPEND/RESUME instead of
device reset. Old vhost-user backends will continue to use device
reset.

I said avoiding two code paths is almost unavoidable. It may be
possible to rely on existing VHOST_USER_GET_VRING_BASE's semantics (it
stops a single virtqueue) instead of SUSPEND. RESUME is replaced by
VHOST_USER_SET_VRING_* and gets the device going again. However, I'm
not 100% sure if this will work (even for all existing devices). It
would require carefully studying both the spec and various
implementations to see if it's viable. There's a chance of losing the
performance optimization that VHOST_USER_SET_STATUS provided to DPDK
if the device is not reset.

In my opinion SUSPEND/RESUME is the cleanest way to do this.

Stefan

