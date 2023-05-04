Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1683234879; x=1685826879;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=27wGPxASm5D+OJrXzX3KXHSg8htD14xi5K9Gkzx1etg=;
 b=kyHG+qjKZRuvxbYA8KdXuG4oZYiqefaG6Te/H+s9G2VqFBKZndiXgJZdUzLvnKmJCr
 scQIunjh8kXYZQNJDCcLqbxs+Fr6uUprMyFaOfG/lTWbDPShe1ovhIk2hBM+NqeWMkNi
 /ooC+JQXLszql7pTRmGqaJ9DN2Xt33l0rzEj13R/bhOKxoLkGEf05pDstseNoh9nCgGX
 c6k3rIPtXlGY/6qp2ckpHUmsBN5tnOuaPn8aKd4CVN84qFLxpzDVi/8CNGld/SiY2Pwa
 V5MDERvoPVJXHSQCYhDdwJ67j3FRNG5ptZrlKIVau7cOuPzkWb0wH0BYgBt/rSefQ53L
 JA/w==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
In-Reply-To: <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 4 May 2023 17:14:27 -0400
Message-ID: <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>

On Thu, 4 May 2023 at 13:39, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 11.04.23 17:05, Hanna Czenczek wrote:
>
> [...]
>
> > Hanna Czenczek (4):
> >    vhost: Re-enable vrings after setting features
> >    vhost-user: Interface for migration state transfer
> >    vhost: Add high-level state save/load functions
> >    vhost-user-fs: Implement internal migration
>
> I=E2=80=99m trying to write v2, and my intention was to keep the code
> conceptually largely the same, but include in the documentation change
> thoughts and notes on how this interface is to be used in the future,
> when e.g. vDPA =E2=80=9Cextensions=E2=80=9D come over to vhost-user.  My =
plan was to,
> based on that documentation, discuss further.
>
> But now I=E2=80=99m struggling to even write that documentation because i=
t=E2=80=99s not
> clear to me what exactly the result of the discussion was, so I need to
> stop even before that.
>
> So as far as I understand, we need/want SUSPEND/RESUME for two reasons:
> 1. As a signal to the back-end when virt queues are no longer to be
> processed, so that it is clear that it will not do that when asked for
> migration state.
> 2. Stateful devices that support SET_STATUS receive a status of 0 when
> the VM is stopped, which supposedly resets the internal state. While
> suspended, device state is frozen, so as far as I understand, SUSPEND
> before SET_STATUS would have the status change be deferred until RESUME.

I'm not sure about SUSPEND -> SET_STATUS 0 -> RESUME. I guess the
device would be reset right away and it would either remain suspended
or be resumed as part of reset :).

Unfortunately the concepts of SUSPEND/RESUME and the Device Status
Field are orthogonal and there is no spec that explains how they
interact.

>
> I don=E2=80=99t want to hang myself up on 2 because it doesn=E2=80=99t re=
ally seem
> important to this series, but: Why does a status of 0 reset the internal
> state?  [Note: This is all virtio_reset() seems to do, set the status to
> 0.]  The vhost-user specification only points to the virtio
> specification, which doesn=E2=80=99t say anything to that effect. Instead=
, an
> explicit device reset is mentioned, which would be
> VHOST_USER_RESET_DEVICE, i.e. something completely different. Because
> RESET_DEVICE directly contradicts SUSPEND=E2=80=99s description, I would =
like to
> think that invoking RESET_DEVICE on a SUSPEND-ed device is just invalid.

The vhost-user protocol didn't have the concept of the VIRTIO Device
Status Field until SET_STATUS was added.

In order to participate in the VIRTIO device lifecycle to some extent,
the pre-SET_STATUS vhost-user protocol relied on vhost-user-specific
messages like RESET_DEVICE.

At the VIRTIO level, devices are reset by setting the Device Status
Field to 0. All state is lost and the Device Initialization process
must be followed to make the device operational again.

Existing vhost-user backends don't implement SET_STATUS 0 (it's new).

It's messy and not your fault. I think QEMU should solve this by
treating stateful devices differently from non-stateful devices. That
way existing vhost-user backends continue to work and new stateful
devices can also be supported.

>
> Is it that a status 0 won=E2=80=99t explicitly reset the internal state, =
but
> because it does mean that the driver is unbound, the state should
> implicitly be reset?

I think the fundamental problem is that transports like virtio-pci put
registers back in their initialization state upon reset, so internal
state is lost.

The VIRTIO spec does not go into detail on device state across reset
though, so I don't think much more can be said about the semantics.

> Anyway.  1 seems to be the relevant point for migration.  As far as I
> understand, currently, a vhost-user back-end has no way of knowing when
> to stop processing virt queues.  Basically, rings can only transition
> from stopped to started, but not vice versa.  The vhost-user
> specification has this bit: =E2=80=9COnce the source has finished migrati=
on,
> rings will be stopped by the source. No further update must be done
> before rings are restarted.=E2=80=9D  It just doesn=E2=80=99t say how the=
 front-end lets
> the back-end know that the rings are (to be) stopped.  So this seems
> like a pre-existing problem for stateless migration.  Unless this is
> communicated precisely by setting the device status to 0?

No, my understanding is different. The vhost-user spec says the
backend must "stop [the] ring upon receiving
``VHOST_USER_GET_VRING_BASE``". The "Ring states" section goes into
more detail and adds the concept of enabled/disabled too.

SUSPEND is stronger than GET_VRING_BASE though. GET_VRING_BASE only
applies to a single virtqueue, whereas SUSPEND acts upon the entire
device, including non-virtqueue aspects like Configuration Change
Notifications (VHOST_USER_BACKEND_CONFIG_CHANGE_MSG).

You can approximate SUSPEND today by sending GET_VRING_BASE for all
virtqueues. I think in practice this does fully stop the device even
if the spec doesn't require it.

If we want minimal changes to vhost-user, then we could rely on
GET_VRING_BASE to suspend and SET_VRING_ENABLE to resume. And
SET_STATUS 0 must not be sent so that the device's state is not lost.

However, this approach means this effort needs to be redone when it's
time to add stateful device support to vDPA and the QEMU vhost code
will become more complex. I think it's better to agree on a proper
model that works for both vhost-user and vhost-vdpa now to avoid more
hacks/special cases.

> Naturally, what I want to know most of all is whether you believe I can
> get away without SUSPEND/RESUME for now.  To me, it seems like honestly
> not really, only when turning two blind eyes, because otherwise we can=E2=
=80=99t
> ensure that virtiofsd isn=E2=80=99t still processing pending virt queue r=
equests
> when the state transfer is begun, even when the guest CPUs are already
> stopped.  Of course, virtiofsd could stop queue processing right there
> and then, but=E2=80=A6  That feels like a hack that in the grand scheme o=
f
> things just isn=E2=80=99t necessary when we could =E2=80=9Cjust=E2=80=9D =
introduce
> SUSPEND/RESUME into vhost-user for exactly this.
>
> Beyond the SUSPEND/RESUME question, I understand everything can stay
> as-is for now, as the design doesn=E2=80=99t seem to conflict too badly w=
ith
> possible future extensions for other migration phases or more finely
> grained migration phase control between front-end and back-end.
>
> Did I at least roughly get the gist?

One part we haven't discussed much: I'm not sure how much trouble
you'll face due to the fact that QEMU assumes vhost devices can be
reset across vhost_dev_stop() -> vhost_dev_start(). I don't think we
should keep a copy of the state in-memory just so it can be restored
in vhost_dev_start(). I think it's better to change QEMU's vhost code
to leave stateful devices suspended (but not reset) across
vhost_dev_stop() -> vhost_dev_start(), maybe by introducing
vhost_dev_suspend() and vhost_dev_resume(). Have you thought about
this aspect?

Stefan

