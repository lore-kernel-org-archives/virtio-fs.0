Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20230601; t=1695756660; x=1696361460; darn=redhat.com;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=C1kuldS5meDUlBVUbaZd7WrrihYFiRKnvLa+X7UK/0Q=;
 b=Sr4mQW/xXCx3XqeORpzGcbfPkcGgzb7ouicOSMkLXp6+Hxyf+dnskXLFtDI4JxYhkZ
 ysbXdmTeV0h4Mz63M6Um4TJ8SIUh1R9ULYitnaZsQSrJz2+hNA5mdfaZjtzyVPr4ZdB/
 ibM+RSgpZp/jpbBo0ZQj+Pb2GesjgKifpRxmkQNcqMocrAEurUZ6tKV8zmPmNWFfU2ut
 swGeji3BkY07BHGv0restvh6vIIk/okehccUzoqhQwRpS3Jo4342ZixL0ntZ/JhfJuEu
 NHqWc/C9YY2UAFnvUqva/hQ5aO3OL3t0D8mCuSBVibsImpp0NHfftsc/If2EeWhFs5bw
 ISbQ==
MIME-Version: 1.0
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230915102531.55894-3-hreitz@redhat.com>
 <20230925191508.GC323580@fedora>
 <de0387fc-0342-a3bf-7d72-3130e94c50cd@redhat.com>
In-Reply-To: <de0387fc-0342-a3bf-7d72-3130e94c50cd@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 26 Sep 2023 15:30:47 -0400
Message-ID: <CAJSP0QWPHejS96Jyb0rYnO39R0EDTc4yhxfkzmBkAOJQdY0NnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v3 2/5] vhost-user.rst: Clarify
 enabling/disabling vrings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>

On Tue, 26 Sept 2023 at 09:55, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 25.09.23 21:15, Stefan Hajnoczi wrote:
> > On Fri, Sep 15, 2023 at 12:25:27PM +0200, Hanna Czenczek wrote:
> >> Currently, the vhost-user documentation says that rings are to be
> >> initialized in a disabled state when VHOST_USER_F_PROTOCOL_FEATURES is
> >> negotiated.  However, by the time of feature negotiation, all rings ha=
ve
> >> already been initialized, so it is not entirely clear what this means.
> >>
> >> At least the vhost-user-backend Rust crate's implementation interprete=
d
> >> it to mean that whenever this feature is negotiated, all rings are to
> >> put into a disabled state, which means that every SET_FEATURES call
> >> would disable all rings, effectively halting the device.  This is
> >> problematic because the VHOST_F_LOG_ALL feature is also set or cleared
> >> this way, which happens during migration.  Doing so should not halt th=
e
> >> device.
> >>
> >> Other implementations have interpreted this to mean that the device is
> >> to be initialized with all rings disabled, and a subsequent SET_FEATUR=
ES
> >> call that does not set VHOST_USER_F_PROTOCOL_FEATURES will enable all =
of
> >> them.  Here, SET_FEATURES will never disable any ring.
> >>
> >> This interpretation does not suffer the problem of unintentionally
> >> halting the device whenever features are set or cleared, so it seems
> >> better and more reasonable.
> >>
> >> We should clarify this in the documentation.
> >>
> >> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> >> ---
> >>   docs/interop/vhost-user.rst | 20 ++++++++++++++------
> >>   1 file changed, 14 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> >> index bb4dd0fd60..9b9b802c60 100644
> >> --- a/docs/interop/vhost-user.rst
> >> +++ b/docs/interop/vhost-user.rst
> >> @@ -409,12 +409,20 @@ and stop ring upon receiving ``VHOST_USER_GET_VR=
ING_BASE``.
> >>
> >>   Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
> >>
> >> -If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
> >> -ring starts directly in the enabled state.
> >> -
> >> -If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring i=
s
> >> -initialized in a disabled state and is enabled by
> >> -``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
> >> +If ``VHOST_USER_SET_FEATURES`` does not negotiate
> >> +``VHOST_USER_F_PROTOCOL_FEATURES``, rings are enabled immediately whe=
n
> >> +started.
> >> +
> >> +If ``VHOST_USER_SET_FEATURES`` does negotiate
> >> +``VHOST_USER_F_PROTOCOL_FEATURES``, each ring will remain in the disa=
bled
> >> +state until ``VHOST_USER_SET_VRING_ENABLE`` enables it with parameter=
 1.
> >> +
> >> +Back-end implementations that support ``VHOST_USER_F_PROTOCOL_FEATURE=
S``
> >> +should implement this by initializing each ring in a disabled state, =
and
> >> +enabling them when ``VHOST_USER_SET_FEATURES`` is used without
> >> +negotiating ``VHOST_USER_F_PROTOCOL_FEATURES``.  Other than that, rin=
gs
> >> +should only be enabled and disabled through
> >> +``VHOST_USER_SET_VRING_ENABLE``.
> > The "Ring states" section starts by saying there are three states:
> > "stopped", "started but disabled", and "started and enabled". But this
> > patch talks about a "disabled state". Can you rephrase this patch to us=
e
> > the exact state names defined earlier in the spec?
>
> I would not want to do that.  We had the exact problem that the spec
> wanted to remain high-level, and was not reflecting exactly what
> existing implementations did, which resulted in confusion (at least for
> me and the vhost Rust crates authors).
>
> Notably, the existing implementations I=E2=80=99m aware of track
> enabled/disabled even before the ring is started, exactly as formulated
> here.
>
> If we changed this to read something like =E2=80=9CIf VHOST_USER_SET_FEAT=
URES is
> ever called without negotiating VHOST_USER_F_PROTOCOL_FEATURES, the ring
> must be enabled immediately when it is started; otherwise, when the ring
> is started and VHOST_USER_F_PROTOCOL_FEATURES has always been set in
> every VHOST_USER_SET_FEATURES call, the ring should be disabled when
> started.=E2=80=9D then this would conflict with the existing implementati=
ons:
>
> We never disallow VHOST_USER_SET_VRING_ENABLE when the ring is stopped.
> Existing implementations track enabled/disabled before the rings are
> started, and they initialize this state to =E2=80=9Cdisabled=E2=80=9D, se=
tting it to
> =E2=80=9Cenabled=E2=80=9D on receiving VHOST_USER_SET_FEATURES without
> VHOST_USER_F_PROTOCOL_FEATURES, as described above.  Therefore, if you
> call VHOST_USER_SET_VRING_ENABLE 1 before the ring is started, the ring
> will start enabled even with VHOST_USER_F_PROTOCOL_FEATURES.  This is
> not possible if you only have three states.
>
> Maybe we should rather clarify that enabled/disabled is tracked even
> while the ring is stopped.

Yes, please. The beginning of the "Ring states" section is confusing
because it claims there are three states but later text doesn't use
those states. Instead it treats started/stopped and enabled/disabled
as independent.

If the entire "Ring states" section consistently talks about
started/stopped and enabled/disabled as independent, then that would
make it easier to understand.

Stefan

