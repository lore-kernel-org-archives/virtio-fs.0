Return-Path: <aesteve@redhat.com>
MIME-Version: 1.0
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-11-alex.bennee@linaro.org>
 <20230710155653-mutt-send-email-mst@kernel.org>
 <CADSE00KvkezAHR_BGGwV5MT-KstLaZzMGM+gxpfm+91aqdRwmg@mail.gmail.com>
 <87r0njp5ci.fsf@linaro.org>
In-Reply-To: <87r0njp5ci.fsf@linaro.org>
From: Albert Esteve <aesteve@redhat.com>
Date: Fri, 1 Sep 2023 10:34:00 +0200
Message-ID: <CADSE00+N0U9MTtBH1SNsp_utDK4VHVXHBvWoheGXhtWmwAwuag@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000068e9d806044806ad"
Subject: Re: [Virtio-fs] [PATCH v3 10/20] hw/virtio: add config support to
 vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

--00000000000068e9d806044806ad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31, 2023 at 6:03=E2=80=AFPM Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:

>
> Albert Esteve <aesteve@redhat.com> writes:
>
> > Sorry to bring up this post, it's been a while since you posted.
> > But I have been testing the patch the last couple of days.
> >
> > On Mon, Jul 10, 2023 at 9:58=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com>
> wrote:
> >
> >  On Mon, Jul 10, 2023 at 04:35:12PM +0100, Alex Benn=C3=A9e wrote:
> >  > To use the generic device the user will need to provide the config
> >  > region size via the command line. We also add a notifier so the gues=
t
> >  > can be pinged if the remote daemon updates the config.
> >  >
> >  > With these changes:
> >  >
> >  >   -device vhost-user-device-pci,virtio-id=3D41,num_vqs=3D2,config_si=
ze=3D8
> >  >
> >  > is equivalent to:
> >  >
> >  >   -device vhost-user-gpio-pci
> >  >
> >  > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> >
> >  This one I think it's best to defer until we get a better
> >  handle on how we want the configuration to look.
> >
> >  > ---
> >  >  include/hw/virtio/vhost-user-device.h |  1 +
> >  >  hw/virtio/vhost-user-device.c         | 58
> ++++++++++++++++++++++++++-
> >  >  2 files changed, 58 insertions(+), 1 deletion(-)
> >  >
> >  > diff --git a/include/hw/virtio/vhost-user-device.h
> b/include/hw/virtio/vhost-user-device.h
> >  > index 9105011e25..3ddf88a146 100644
> >  > --- a/include/hw/virtio/vhost-user-device.h
> >  > +++ b/include/hw/virtio/vhost-user-device.h
> >  > @@ -22,6 +22,7 @@ struct VHostUserBase {
> >  >      CharBackend chardev;
> >  >      uint16_t virtio_id;
> >  >      uint32_t num_vqs;
> >  > +    uint32_t config_size;
> >  >      /* State tracking */
> >  >      VhostUserState vhost_user;
> >  >      struct vhost_virtqueue *vhost_vq;
> >  > diff --git a/hw/virtio/vhost-user-device.c
> b/hw/virtio/vhost-user-device.c
> >  > index b0239fa033..2b028cae08 100644
> >  > --- a/hw/virtio/vhost-user-device.c
> >  > +++ b/hw/virtio/vhost-user-device.c
> >  > @@ -117,6 +117,42 @@ static uint64_t vub_get_features(VirtIODevice
> *vdev,
> >  >      return vub->vhost_dev.features & ~(1ULL <<
> VHOST_USER_F_PROTOCOL_FEATURES);
> >  >  }
> >  >
> >  > +/*
> >  > + * To handle VirtIO config we need to know the size of the config
> >  > + * space. We don't cache the config but re-fetch it from the guest
> >  > + * every time in case something has changed.
> >  > + */
> >  > +static void vub_get_config(VirtIODevice *vdev, uint8_t *config)
> >  > +{
> >  > +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> >  > +    Error *local_err =3D NULL;
> >  > +
> >  > +    /*
> >  > +     * There will have been a warning during vhost_dev_init, but le=
ts
> >  > +     * assert here as nothing will go right now.
> >  > +     */
> >  > +    g_assert(vub->config_size && vub->vhost_user.supports_config =
=3D=3D
> true);
> >  > +
> >  > +    if (vhost_dev_get_config(&vub->vhost_dev, config,
> >  > +                             vub->config_size, &local_err)) {
> >  > +        error_report_err(local_err);
> >  > +    }
> >  > +}
> >  > +
> >  > +/*
> >  > + * When the daemon signals an update to the config we just need to
> >  > + * signal the guest as we re-read the config on demand above.
> >  > + */
> >  > +static int vub_config_notifier(struct vhost_dev *dev)
> >  > +{
> >  > +    virtio_notify_config(dev->vdev);
> >  > +    return 0;
> >  > +}
> >  > +
> >  > +const VhostDevConfigOps vub_config_ops =3D {
> >  > +    .vhost_dev_config_notifier =3D vub_config_notifier,
> >  > +};
> >  > +
> >  >  static void vub_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> >  >  {
> >  >      /*
> >  > @@ -141,12 +177,21 @@ static int vub_connect(DeviceState *dev)
> >  >  {
> >  >      VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
> >  >      VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> >  > +    struct vhost_dev *vhost_dev =3D &vub->vhost_dev;
> >  >
> >  >      if (vub->connected) {
> >  >          return 0;
> >  >      }
> >  >      vub->connected =3D true;
> >  >
> >  > +    /*
> >  > +     * If we support VHOST_USER_GET_CONFIG we must enable the
> notifier
> >  > +     * so we can ping the guest when it updates.
> >  > +     */
> >  > +    if (vub->vhost_user.supports_config) {
> >  > +        vhost_dev_set_config_notifier(vhost_dev, &vub_config_ops);
> >  > +    }
> >  > +
> >  >      /* restore vhost state */
> >  >      if (virtio_device_started(vdev, vdev->status)) {
> >  >          vub_start(vdev);
> >  > @@ -214,11 +259,20 @@ static void vub_device_realize(DeviceState
> *dev, Error **errp)
> >  >          vub->num_vqs =3D 1; /* reasonable default? */
> >  >      }
> >  >
> >  > +    /*
> >  > +     * We can't handle config requests unless we know the size of t=
he
> >  > +     * config region, specialisations of the vhost-user-device will
> be
> >  > +     * able to set this.
> >  > +     */
> >  > +    if (vub->config_size) {
> >  > +        vub->vhost_user.supports_config =3D true;
> >  > +    }
> >
> > Shouldn't the `supports_config =3D true' be set before we call
> vhost_dev_init() a few lines above?
> > Otherwise, we end up checking the `supports_config` attribute from
> within `vhost_user_backend_init()` (in vhost_user
> > source file)
> > before the VhostUserState is set, causing this warning to pop if the
> backend supports the CONFIG feature:
> > ```
> > qemu-system-x86_64: warning: vhost-user backend supports
> VHOST_USER_PROTOCOL_F_CONFIG but QEMU does
> > not.
> > ```
>
> I allude to that in the comments for vub_get_config() further up.
>

Ah, true. Sorry I missed it. Still not sure that allowing the warning is a
good idea.
Either the warning is not relevant anymore or the logic is not correct.
In my case the connection was breaking because the driver was receiving
a wrong configuration, even though the backend was sending correct data.
Qemu disables the F_CONFIG bit from the backend features when the
warning is printed, and I assume that was causing the issue that the
config fields were all 0'd when the driver asked for it.


> However the more I look at this the more confused I am about the
> original intention of the flag I added (*blush*). I think we need to
> handle the following cases:
>
>  - the virtio device has no config space
>  - the virtio device has config space, emulated inside qemu
>  - the virtio vhost device has config space, emulated inside qemu
>  - the virtio vhost device has config space, handled by vhost
>
> for the final case the qemu internals need to be able to handle the
> signalling of updates to the config by the vhost device by way of the
> notifier.
>
> In the case of a "standalone" vhost-user daemon we won't even know if
> there is a config space until we have connected to it and queried its
> size via protocol messages.
>
> Maybe we need two fields?
>
>   - supports_remote_config (device is capable of handling remote config)
>   - config_location one of { NONE, LOCAL, REMOTE }
>
>
Mmh, when setting the config location, if remote config is not supported
and the location
is remote, we could force the flag to NONE, and then we only need the
`config_location`.
It already tells us both if supported, and where to find it.

>
> >  > +
> >  >      if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> >  >          return;
> >  >      }
> >  >
> >  > -    virtio_init(vdev, vub->virtio_id, 0);
> >  > +    virtio_init(vdev, vub->virtio_id, vub->config_size);
> >  >
> >  >      /*
> >  >       * Disable guest notifiers, by default all notifications will b=
e
> via the
> >  > @@ -268,6 +322,7 @@ static void vub_class_init(ObjectClass *klass,
> void *data)
> >  >      vdc->realize =3D vub_device_realize;
> >  >      vdc->unrealize =3D vub_device_unrealize;
> >  >      vdc->get_features =3D vub_get_features;
> >  > +    vdc->get_config =3D vub_get_config;
> >  >      vdc->set_status =3D vub_set_status;
> >  >  }
> >  >
> >  > @@ -295,6 +350,7 @@ static Property vud_properties[] =3D {
> >  >      DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
> >  >      DEFINE_PROP_UINT16("virtio-id", VHostUserBase, virtio_id, 0),
> >  >      DEFINE_PROP_UINT32("num_vqs", VHostUserBase, num_vqs, 1),
> >  > +    DEFINE_PROP_UINT32("config_size", VHostUserBase, config_size, 0=
),
> >  >      DEFINE_PROP_END_OF_LIST(),
> >  >  };
> >  >
> >  > --
> >  > 2.39.2
>
>
> --
> Alex Benn=C3=A9e
> Virtualisation Tech Lead @ Linaro
>
>

--00000000000068e9d806044806ad
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><div dir=3D"ltr" class=3D"gmail_sign=
ature"><div dir=3D"ltr"><br></div></div></div></div><br><div class=3D"gmail=
_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Aug 31, 2023 at 6:03=
=E2=80=AFPM Alex Benn=C3=A9e &lt;<a href=3D"mailto:alex.bennee@linaro.org">=
alex.bennee@linaro.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex"><br>
Albert Esteve &lt;<a href=3D"mailto:aesteve@redhat.com" target=3D"_blank">a=
esteve@redhat.com</a>&gt; writes:<br>
<br>
&gt; Sorry to bring up this post, it&#39;s been a while since you posted.<b=
r>
&gt; But I have been testing the patch the last couple of days.<br>
&gt;<br>
&gt; On Mon, Jul 10, 2023 at 9:58=E2=80=AFPM Michael S. Tsirkin &lt;<a href=
=3D"mailto:mst@redhat.com" target=3D"_blank">mst@redhat.com</a>&gt; wrote:<=
br>
&gt;<br>
&gt;=C2=A0 On Mon, Jul 10, 2023 at 04:35:12PM +0100, Alex Benn=C3=A9e wrote=
:<br>
&gt;=C2=A0 &gt; To use the generic device the user will need to provide the=
 config<br>
&gt;=C2=A0 &gt; region size via the command line. We also add a notifier so=
 the guest<br>
&gt;=C2=A0 &gt; can be pinged if the remote daemon updates the config.<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt; With these changes:<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0-device vhost-user-device-pci,virtio-id=3D41,nu=
m_vqs=3D2,config_size=3D8<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt; is equivalent to:<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0-device vhost-user-gpio-pci<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt; Signed-off-by: Alex Benn=C3=A9e &lt;<a href=3D"mailto:alex.=
bennee@linaro.org" target=3D"_blank">alex.bennee@linaro.org</a>&gt;<br>
&gt;<br>
&gt;=C2=A0 This one I think it&#39;s best to defer until we get a better<br=
>
&gt;=C2=A0 handle on how we want the configuration to look.<br>
&gt;<br>
&gt;=C2=A0 &gt; ---<br>
&gt;=C2=A0 &gt;=C2=A0 include/hw/virtio/vhost-user-device.h |=C2=A0 1 +<br>
&gt;=C2=A0 &gt;=C2=A0 hw/virtio/vhost-user-device.c=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0| 58 ++++++++++++++++++++++++++-<br>
&gt;=C2=A0 &gt;=C2=A0 2 files changed, 58 insertions(+), 1 deletion(-)<br>
&gt;=C2=A0 &gt; <br>
&gt;=C2=A0 &gt; diff --git a/include/hw/virtio/vhost-user-device.h b/includ=
e/hw/virtio/vhost-user-device.h<br>
&gt;=C2=A0 &gt; index 9105011e25..3ddf88a146 100644<br>
&gt;=C2=A0 &gt; --- a/include/hw/virtio/vhost-user-device.h<br>
&gt;=C2=A0 &gt; +++ b/include/hw/virtio/vhost-user-device.h<br>
&gt;=C2=A0 &gt; @@ -22,6 +22,7 @@ struct VHostUserBase {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 CharBackend chardev;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 uint16_t virtio_id;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 uint32_t num_vqs;<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 uint32_t config_size;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 /* State tracking */<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 VhostUserState vhost_user;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 struct vhost_virtqueue *vhost_vq;<br>
&gt;=C2=A0 &gt; diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhos=
t-user-device.c<br>
&gt;=C2=A0 &gt; index b0239fa033..2b028cae08 100644<br>
&gt;=C2=A0 &gt; --- a/hw/virtio/vhost-user-device.c<br>
&gt;=C2=A0 &gt; +++ b/hw/virtio/vhost-user-device.c<br>
&gt;=C2=A0 &gt; @@ -117,6 +117,42 @@ static uint64_t vub_get_features(VirtI=
ODevice *vdev,<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 return vub-&gt;vhost_dev.features &amp;=
 ~(1ULL &lt;&lt; VHOST_USER_F_PROTOCOL_FEATURES);<br>
&gt;=C2=A0 &gt;=C2=A0 }<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; +/*<br>
&gt;=C2=A0 &gt; + * To handle VirtIO config we need to know the size of the=
 config<br>
&gt;=C2=A0 &gt; + * space. We don&#39;t cache the config but re-fetch it fr=
om the guest<br>
&gt;=C2=A0 &gt; + * every time in case something has changed.<br>
&gt;=C2=A0 &gt; + */<br>
&gt;=C2=A0 &gt; +static void vub_get_config(VirtIODevice *vdev, uint8_t *co=
nfig)<br>
&gt;=C2=A0 &gt; +{<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 VHostUserBase *vub =3D VHOST_USER_BASE(vdev)=
;<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 Error *local_err =3D NULL;<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 /*<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* There will have been a warning durin=
g vhost_dev_init, but lets<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* assert here as nothing will go right=
 now.<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0*/<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 g_assert(vub-&gt;config_size &amp;&amp; vub-=
&gt;vhost_user.supports_config =3D=3D true);<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 if (vhost_dev_get_config(&amp;vub-&gt;vhost_=
dev, config,<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vub-&gt;config_size, &amp;l=
ocal_err)) {<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 error_report_err(local_err);<b=
r>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 }<br>
&gt;=C2=A0 &gt; +}<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt; +/*<br>
&gt;=C2=A0 &gt; + * When the daemon signals an update to the config we just=
 need to<br>
&gt;=C2=A0 &gt; + * signal the guest as we re-read the config on demand abo=
ve.<br>
&gt;=C2=A0 &gt; + */<br>
&gt;=C2=A0 &gt; +static int vub_config_notifier(struct vhost_dev *dev)<br>
&gt;=C2=A0 &gt; +{<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 virtio_notify_config(dev-&gt;vdev);<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 return 0;<br>
&gt;=C2=A0 &gt; +}<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt; +const VhostDevConfigOps vub_config_ops =3D {<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 .vhost_dev_config_notifier =3D vub_config_no=
tifier,<br>
&gt;=C2=A0 &gt; +};<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt;=C2=A0 static void vub_handle_output(VirtIODevice *vdev, Vir=
tQueue *vq)<br>
&gt;=C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 /*<br>
&gt;=C2=A0 &gt; @@ -141,12 +177,21 @@ static int vub_connect(DeviceState *d=
ev)<br>
&gt;=C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 VirtIODevice *vdev =3D VIRTIO_DEVICE(de=
v);<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 VHostUserBase *vub =3D VHOST_USER_BASE(=
vdev);<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 struct vhost_dev *vhost_dev =3D &amp;vub-&gt=
;vhost_dev;<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 if (vub-&gt;connected) {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 vub-&gt;connected =3D true;<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 /*<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* If we support VHOST_USER_GET_CONFIG =
we must enable the notifier<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* so we can ping the guest when it upd=
ates.<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0*/<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 if (vub-&gt;vhost_user.supports_config) {<br=
>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 vhost_dev_set_config_notifier(=
vhost_dev, &amp;vub_config_ops);<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 }<br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 /* restore vhost state */<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 if (virtio_device_started(vdev, vdev-&g=
t;status)) {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vub_start(vdev);<br>
&gt;=C2=A0 &gt; @@ -214,11 +259,20 @@ static void vub_device_realize(Device=
State *dev, Error **errp)<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;num_vqs =3D 1; /*=
 reasonable default? */<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 /*<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* We can&#39;t handle config requests =
unless we know the size of the<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* config region, specialisations of th=
e vhost-user-device will be<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0* able to set this.<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0*/<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 if (vub-&gt;config_size) {<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;vhost_user.supports_co=
nfig =3D true;<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 }<br>
&gt;<br>
&gt; Shouldn&#39;t the `supports_config =3D true&#39; be set before we call=
 vhost_dev_init() a few lines above?<br>
&gt; Otherwise, we end up checking the `supports_config` attribute from wit=
hin `vhost_user_backend_init()` (in vhost_user<br>
&gt; source file)<br>
&gt; before the VhostUserState is set, causing this warning to pop if the b=
ackend supports the CONFIG feature:<br>
&gt; ```<br>
&gt; qemu-system-x86_64: warning: vhost-user backend supports VHOST_USER_PR=
OTOCOL_F_CONFIG but QEMU does<br>
&gt; not.<br>
&gt; ```<br>
<br>
I allude to that in the comments for vub_get_config() further up.<br></bloc=
kquote><div><br></div><div>Ah, true. Sorry I missed it. Still not sure that=
 allowing the warning is a good idea.</div><div>Either the warning is not r=
elevant anymore or the logic is not correct.</div><div>In my case the conne=
ction was breaking because the driver was receiving</div><div>a wrong confi=
guration, even though the backend was sending correct data.</div><div>Qemu =
disables the F_CONFIG bit from the backend features when the</div><div>warn=
ing is printed, and I assume that was causing the issue that the</div><div>=
config fields were all 0&#39;d when the driver asked for it.</div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">
However the more I look at this the more confused I am about the<br>
original intention of the flag I added (*blush*). I think we need to<br>
handle the following cases:<br>
<br>
=C2=A0- the virtio device has no config space<br>
=C2=A0- the virtio device has config space, emulated inside qemu<br>
=C2=A0- the virtio vhost device has config space, emulated inside qemu<br>
=C2=A0- the virtio vhost device has config space, handled by vhost<br>
<br>
for the final case the qemu internals need to be able to handle the<br>
signalling of updates to the config by the vhost device by way of the<br>
notifier.<br>
<br>
In the case of a &quot;standalone&quot; vhost-user daemon we won&#39;t even=
 know if<br>
there is a config space until we have connected to it and queried its<br>
size via protocol messages.<br>
<br>
Maybe we need two fields?<br>
<br>
=C2=A0 - supports_remote_config (device is capable of handling remote confi=
g)<br>
=C2=A0 - config_location one of { NONE, LOCAL, REMOTE }<br>
<br></blockquote><div><br></div><div>Mmh, when setting the config location,=
 if remote config is not supported and the location</div><div>is remote, we=
 could force the flag to NONE, and then we only need the `config_location`.=
</div><div>It already tells us both if supported, and where to find it.=C2=
=A0</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 <br>
&gt;=C2=A0 &gt; +<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 if (!vhost_user_init(&amp;vub-&gt;vhost=
_user, &amp;vub-&gt;chardev, errp)) {<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; -=C2=A0 =C2=A0 virtio_init(vdev, vub-&gt;virtio_id, 0);<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 virtio_init(vdev, vub-&gt;virtio_id, vub-&gt=
;config_size);<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 /*<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* Disable guest notifiers, by def=
ault all notifications will be via the<br>
&gt;=C2=A0 &gt; @@ -268,6 +322,7 @@ static void vub_class_init(ObjectClass =
*klass, void *data)<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 vdc-&gt;realize =3D vub_device_realize;=
<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 vdc-&gt;unrealize =3D vub_device_unreal=
ize;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 vdc-&gt;get_features =3D vub_get_featur=
es;<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 vdc-&gt;get_config =3D vub_get_config;<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 vdc-&gt;set_status =3D vub_set_status;<=
br>
&gt;=C2=A0 &gt;=C2=A0 }<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; @@ -295,6 +350,7 @@ static Property vud_properties[] =3D {<=
br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 DEFINE_PROP_CHR(&quot;chardev&quot;, VH=
ostUserBase, chardev),<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 DEFINE_PROP_UINT16(&quot;virtio-id&quot=
;, VHostUserBase, virtio_id, 0),<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 DEFINE_PROP_UINT32(&quot;num_vqs&quot;,=
 VHostUserBase, num_vqs, 1),<br>
&gt;=C2=A0 &gt; +=C2=A0 =C2=A0 DEFINE_PROP_UINT32(&quot;config_size&quot;, =
VHostUserBase, config_size, 0),<br>
&gt;=C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 DEFINE_PROP_END_OF_LIST(),<br>
&gt;=C2=A0 &gt;=C2=A0 };<br>
&gt;=C2=A0 &gt;=C2=A0 <br>
&gt;=C2=A0 &gt; -- <br>
&gt;=C2=A0 &gt; 2.39.2<br>
<br>
<br>
-- <br>
Alex Benn=C3=A9e<br>
Virtualisation Tech Lead @ Linaro<br>
<br>
</blockquote></div></div>

--00000000000068e9d806044806ad--

