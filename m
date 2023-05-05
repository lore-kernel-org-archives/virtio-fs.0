Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <71e47e3e-880d-38d8-c1b0-3287c60365e4@redhat.com>
In-Reply-To: <71e47e3e-880d-38d8-c1b0-3287c60365e4@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 5 May 2023 16:26:08 +0200
Message-ID: <CAJaqyWe13QxuC9BNBULJ1xu1saWE9Y3ET8eEef-7qtyL5R73SQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Fri, May 5, 2023 at 11:51=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> =
wrote:
>
> (By the way, thanks for the explanations :))
>
> On 05.05.23 11:03, Hanna Czenczek wrote:
> > On 04.05.23 23:14, Stefan Hajnoczi wrote:
>
> [...]
>
> >> I think it's better to change QEMU's vhost code
> >> to leave stateful devices suspended (but not reset) across
> >> vhost_dev_stop() -> vhost_dev_start(), maybe by introducing
> >> vhost_dev_suspend() and vhost_dev_resume(). Have you thought about
> >> this aspect?
> >
> > Yes and no; I mean, I haven=E2=80=99t in detail, but I thought this is =
what=E2=80=99s
> > meant by suspending instead of resetting when the VM is stopped.
>
> So, now looking at vhost_dev_stop(), one problem I can see is that
> depending on the back-end, different operations it does will do
> different things.
>
> It tries to stop the whole device via vhost_ops->vhost_dev_start(),
> which for vDPA will suspend the device, but for vhost-user will reset it
> (if F_STATUS is there).
>
> It disables all vrings, which doesn=E2=80=99t mean stopping, but may be
> necessary, too.  (I haven=E2=80=99t yet really understood the use of disa=
bled
> vrings, I heard that virtio-net would have a need for it.)
>
> It then also stops all vrings, though, so that=E2=80=99s OK.  And because=
 this
> will always do GET_VRING_BASE, this is actually always the same
> regardless of transport.
>
> Finally (for this purpose), it resets the device status via
> vhost_ops->vhost_reset_status().  This is only implemented on vDPA, and
> this is what resets the device there.
>
>
> So vhost-user resets the device in .vhost_dev_start, but vDPA only does
> so in .vhost_reset_status.  It would seem better to me if vhost-user
> would also reset the device only in .vhost_reset_status, not in
> .vhost_dev_start.  .vhost_dev_start seems precisely like the place to
> run SUSPEND/RESUME.
>

I think the same. I just saw It's been proposed at [1].

> Another question I have (but this is basically what I wrote in my last
> email) is why we even call .vhost_reset_status here.  If the device
> and/or all of the vrings are already stopped, why do we need to reset
> it?  Na=C3=AFvely, I had assumed we only really need to reset the device =
if
> the guest changes, so that a new guest driver sees a freshly initialized
> device.
>

I don't know why we didn't need to call it :). I'm assuming the
previous vhost-user net did fine resetting vq indexes, using
VHOST_USER_SET_VRING_BASE. But I don't know about more complex
devices.

The guest can reset the device, or write 0 to the PCI config status,
at any time. How does virtiofs handle it, being stateful?

Thanks!

[1] https://lore.kernel.org/qemu-devel/20230501230409.274178-1-stefanha@red=
hat.com/

