Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681758511; x=1684350511;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=kqmJ0u2JcL/PLkPPs6RH032zB5ZsNtlEvdwJ+5hnxzw=;
 b=gjJybOmBHM9YYpUHCXKdI9BKElpWX59zrFQJl/SqHOABzAY6TNLnz3gLM5XpcpBBSx
 +qMAzUEsc7fPTvlXBRioEmpSLlT5sXPpjbOe8432EaI8mH7o1c/69a7vfXz/b42JPmju
 IDlYlcB/Ctn+P+4/MNmfm4pLTnIM5bBxAymcyw/5TxB5CzyE3D+2/sihygpD22nRerq9
 6Fq4AUYXhp2YmAuvM/96xu5NvPPskBKBNT31CpAxfnOpo1atSw8nrWg0QedG1Ggy7AK+
 Tb9O/ao1h0k7erZq7FFOjzyLNpYa4t62i65ZKGmApfq1ejXXtuWGNd5M9LgMFH7WOPIy
 xWBg==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <246691c3-2287-7472-3615-7ec0f074445c@redhat.com>
 <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
 <b0cd4f54-94ed-09a4-cec2-e81f36da4008@redhat.com>
 <CAJaqyWegMfuc8s6bKdxdM4uVixmhy-F3xUUyOCYS1yGDXoiVZA@mail.gmail.com>
 <20230417151840.GD3852722@fedora>
 <CAJaqyWeTBXStyxty4G5qpiG=UoZkmOmr75hHaC3H21kJfK=idg@mail.gmail.com>
In-Reply-To: <CAJaqyWeTBXStyxty4G5qpiG=UoZkmOmr75hHaC3H21kJfK=idg@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 17 Apr 2023 15:08:19 -0400
Message-ID: <CAJSP0QWmFgJvVPLDo2eoFapj8GCmDjaaEygAaywZwHuH=_q=rQ@mail.gmail.com>
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

On Mon, 17 Apr 2023 at 14:56, Eugenio Perez Martin <eperezma@redhat.com> wr=
ote:
>
> On Mon, Apr 17, 2023 at 5:18=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Fri, Apr 14, 2023 at 05:17:02PM +0200, Eugenio Perez Martin wrote:
> > > On Thu, Apr 13, 2023 at 7:55=E2=80=AFPM Hanna Czenczek <hreitz@redhat=
.com> wrote:
> > > >
> > > > On 13.04.23 13:38, Stefan Hajnoczi wrote:
> > > > > On Thu, 13 Apr 2023 at 05:24, Hanna Czenczek <hreitz@redhat.com> =
wrote:
> > > > >> On 12.04.23 23:06, Stefan Hajnoczi wrote:
> > > > >>> On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > Basically, what I=E2=80=99m hearing is that I need to implement a d=
ifferent
> > > > feature that has no practical impact right now, and also fix bugs a=
round
> > > > it along the way...
> > > >
> > >
> > > To fix this properly requires iterative device migration in qemu as
> > > far as I know, instead of using VMStates [1]. This way the state is
> > > requested to virtiofsd before the device reset.
> >
> > I don't follow. Many devices are fine with non-iterative migration. The=
y
> > shouldn't be forced to do iterative migration.
> >
>
> Sorry I think I didn't express myself well. I didn't mean to force
> virtiofsd to support the iterative migration, but to use the device
> iterative migration API in QEMU to send the needed commands before
> vhost_dev_stop. In that regard, the device or the vhost-user commands
> would not require changes.
>
> I think it is convenient in the long run for virtiofsd, as if the
> state grows so much that it's not feasible to fetch it in one shot
> there is no need to make changes in the qemu migration protocol. I
> think it is not unlikely in virtiofs, but maybe I'm missing something
> obvious and it's state will never grow.

I don't understand. vCPUs are still running at that point and the
device state could change. It's not safe to save the full device state
until vCPUs have stopped (after vhost_dev_stop).

If you're suggestion somehow doing non-iterative migration but during
the iterative phase, then I don't think that's possible?

Stefan

