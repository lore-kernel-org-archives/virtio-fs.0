Return-Path: <aesteve@redhat.com>
MIME-Version: 1.0
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-21-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-21-alex.bennee@linaro.org>
From: Albert Esteve <aesteve@redhat.com>
Date: Fri, 1 Sep 2023 12:00:44 +0200
Message-ID: <CADSE00KVM=xgRDjFcnePXcPr+uqHk15BRpotJr3G2_uR8N1U1A@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000008a51730604493c18"
Subject: Re: [Virtio-fs] [RFC PATCH v3 20/20] hw/virtio: allow
 vhost-user-device to be driven by backend
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

--0000000000008a51730604493c18
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 10, 2023 at 6:44=E2=80=AFPM Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:

> Instead of requiring all the information up front allow the
> vhost_dev_init to complete and then see what information we have from
> the backend.
>
> This does change the order around somewhat.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> ---
>  hw/virtio/vhost-user-device.c | 45 +++++++++++++++++++++++++----------
>  1 file changed, 32 insertions(+), 13 deletions(-)
>
> diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.=
c
> index 0109d4829d..b30b6265fb 100644
> --- a/hw/virtio/vhost-user-device.c
> +++ b/hw/virtio/vhost-user-device.c
> @@ -243,7 +243,6 @@ static void vub_device_realize(DeviceState *dev, Erro=
r
> **errp)
>  {
>      VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
>      VHostUserBase *vub =3D VHOST_USER_BASE(dev);
> -    int ret;
>
>      if (!vub->chardev.chr) {
>          error_setg(errp, "vhost-user-device: missing chardev");
> @@ -254,13 +253,43 @@ static void vub_device_realize(DeviceState *dev,
> Error **errp)
>          return;
>      }
>
> +    if (vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
> +                       VHOST_BACKEND_TYPE_USER, 0, errp)!=3D0) {
> +        error_setg(errp, "vhost-user-device: unable to start connection"=
);
> +        return;
> +    }
> +
> +    if (vub->vhost_dev.specs.device_id) {
> +        if (vub->virtio_id && vub->virtio_id !=3D
> vub->vhost_dev.specs.device_id) {
> +            error_setg(errp, "vhost-user-device: backend id %d doesn't
> match cli %d",
> +                       vub->vhost_dev.specs.device_id, vub->virtio_id);
> +            return;
> +        }
> +        vub->virtio_id =3D vub->vhost_dev.specs.device_id;
> +    }
> +
>      if (!vub->virtio_id) {
> -        error_setg(errp, "vhost-user-device: need to define device id");
> +        error_setg(errp, "vhost-user-device: need to define or be told
> device id");
>          return;
>      }
>
> +    if (vub->vhost_dev.specs.min_vqs) {
> +        if (vub->num_vqs) {
> +            if (vub->num_vqs < vub->vhost_dev.specs.min_vqs ||
> +                vub->num_vqs > vub->vhost_dev.specs.max_vqs) {
> +                error_setg(errp,
> +                           "vhost-user-device: selected nvqs (%d) out of
> bounds (%d->%d)",
> +                           vub->num_vqs,
> +                           vub->vhost_dev.specs.min_vqs,
> vub->vhost_dev.specs.max_vqs);
> +                return;
> +            }
> +        } else {
> +            vub->num_vqs =3D vub->vhost_dev.specs.min_vqs;
> +        }
> +    }
> +
>      if (!vub->num_vqs) {
> -        vub->num_vqs =3D 1; /* reasonable default? */
> +        error_setg(errp, "vhost-user-device: need to define number of
> vqs");
>      }
>
>      /*
> @@ -287,16 +316,6 @@ static void vub_device_realize(DeviceState *dev,
> Error **errp)
>                          virtio_add_queue(vdev, 4, vub_handle_output));
>      }
>
> -    vub->vhost_dev.nvqs =3D vub->num_vqs;
>

Who sets `vub->vhost_dev.nvqs` after removing this line?
Why having `vub->num_vqs` in the first place? In vub_start for example we
still
use `vub->vhost_dev.nvqs`, and we pass `vhost_dev` to other functions that
use its `nvqs`, so `num_vqs` is redundant and requires a logic to
copy/initialise `vhost_dev.nvqs`.

Maybe it would be better to initialse `nvqs` through a function, in the
device file, instead of doing:
`vub->num_vqs =3D 2;`
We could have:
`vub_set_nvqs(vub, 2);`
Or something along those lines. And the function will have all the internal
logic in this commit, i.e.,
checking the boundaries, setting the `vhost_dev.nvqs` value, printing the
error, etc.
So we can save the extra variable, and the logic to copy the value to the
device.


> -
> -    /* connect to backend */
> -    ret =3D vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> -
> -    if (ret < 0) {
> -        do_vhost_user_cleanup(vdev, vub);
> -    }
> -
>      qemu_chr_fe_set_handlers(&vub->chardev, NULL, NULL, vub_event, NULL,
>                               dev, NULL, true);
>  }
> --
> 2.39.2
>
>
>

--0000000000008a51730604493c18
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><div dir=3D"ltr" class=3D"gmail_sign=
ature"><div dir=3D"ltr"><br></div></div></div></div><br><div class=3D"gmail=
_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Jul 10, 2023 at 6:44=
=E2=80=AFPM Alex Benn=C3=A9e &lt;<a href=3D"mailto:alex.bennee@linaro.org">=
alex.bennee@linaro.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">Instead of requiring all the information up front all=
ow the<br>
vhost_dev_init to complete and then see what information we have from<br>
the backend.<br>
<br>
This does change the order around somewhat.<br>
<br>
Signed-off-by: Alex Benn=C3=A9e &lt;<a href=3D"mailto:alex.bennee@linaro.or=
g" target=3D"_blank">alex.bennee@linaro.org</a>&gt;<br>
---<br>
=C2=A0hw/virtio/vhost-user-device.c | 45 +++++++++++++++++++++++++---------=
-<br>
=C2=A01 file changed, 32 insertions(+), 13 deletions(-)<br>
<br>
diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c<=
br>
index 0109d4829d..b30b6265fb 100644<br>
--- a/hw/virtio/vhost-user-device.c<br>
+++ b/hw/virtio/vhost-user-device.c<br>
@@ -243,7 +243,6 @@ static void vub_device_realize(DeviceState *dev, Error =
**errp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);<br>
=C2=A0 =C2=A0 =C2=A0VHostUserBase *vub =3D VHOST_USER_BASE(dev);<br>
-=C2=A0 =C2=A0 int ret;<br>
<br>
=C2=A0 =C2=A0 =C2=A0if (!vub-&gt;chardev.chr) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error_setg(errp, &quot;vhost-user-device:=
 missing chardev&quot;);<br>
@@ -254,13 +253,43 @@ static void vub_device_realize(DeviceState *dev, Erro=
r **errp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
=C2=A0 =C2=A0 =C2=A0}<br>
<br>
+=C2=A0 =C2=A0 if (vhost_dev_init(&amp;vub-&gt;vhost_dev, &amp;vub-&gt;vhos=
t_user,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0VHOST_BACKEND_TYPE_USER, 0, errp)!=3D0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp, &quot;vhost-user-device: unab=
le to start connection&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 if (vub-&gt;vhost_dev.specs.device_id) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vub-&gt;virtio_id &amp;&amp; vub-&gt;virti=
o_id !=3D vub-&gt;vhost_dev.specs.device_id) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp, &quot;vhost-use=
r-device: backend id %d doesn&#39;t match cli %d&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0vub-&gt;vhost_dev.specs.device_id, vub-&gt;virtio_id);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;virtio_id =3D vub-&gt;vhost_dev.specs.=
device_id;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
=C2=A0 =C2=A0 =C2=A0if (!vub-&gt;virtio_id) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp, &quot;vhost-user-device: need=
 to define device id&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp, &quot;vhost-user-device: need=
 to define or be told device id&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
=C2=A0 =C2=A0 =C2=A0}<br>
<br>
+=C2=A0 =C2=A0 if (vub-&gt;vhost_dev.specs.min_vqs) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vub-&gt;num_vqs) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vub-&gt;num_vqs &lt; vub-&gt=
;vhost_dev.specs.min_vqs ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;num_vqs &g=
t; vub-&gt;vhost_dev.specs.max_vqs) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp,<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&quot;vhost-user-device: selected nvqs (%d) out of =
bounds (%d-&gt;%d)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0vub-&gt;num_vqs,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0vub-&gt;vhost_dev.specs.min_vqs, vub-&gt;vhost_dev.=
specs.max_vqs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;num_vqs =3D vub-&gt;vhos=
t_dev.specs.min_vqs;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 }<br>
+<br>
=C2=A0 =C2=A0 =C2=A0if (!vub-&gt;num_vqs) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 vub-&gt;num_vqs =3D 1; /* reasonable default? =
*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 error_setg(errp, &quot;vhost-user-device: need=
 to define number of vqs&quot;);<br>
=C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0/*<br>
@@ -287,16 +316,6 @@ static void vub_device_realize(DeviceState *dev, Error=
 **errp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0virtio_add_queue(vdev, 4, vub_handle_output));<br>
=C2=A0 =C2=A0 =C2=A0}<br>
<br>
-=C2=A0 =C2=A0 vub-&gt;vhost_dev.nvqs =3D vub-&gt;num_vqs;<br></blockquote>=
<div><br></div><div>Who sets `vub-&gt;vhost_dev.nvqs` after removing this l=
ine?</div><div>Why having `vub-&gt;num_vqs` in the first place? In vub_star=
t for example we still</div><div>use `vub-&gt;vhost_dev.nvqs`, and we pass =
`vhost_dev` to other functions that</div><div>use its `nvqs`, so `num_vqs` =
is redundant and requires a logic to copy/initialise `vhost_dev.nvqs`.</div=
><div><br></div><div>Maybe it would be better to initialse=C2=A0`nvqs` thro=
ugh a function, in the device file, instead of doing:</div><div>`vub-&gt;nu=
m_vqs =3D 2;`</div><div>We could have:<br></div><div>`vub_set_nvqs(vub, 2);=
`</div><div>Or something along those lines. And the function will have all =
the internal logic in this commit, i.e.,<br></div><div>checking the boundar=
ies, setting the `vhost_dev.nvqs` value, printing the error, etc.</div><div=
>So we can save the extra variable, and the logic to copy the value to the =
device.</div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
-<br>
-=C2=A0 =C2=A0 /* connect to backend */<br>
-=C2=A0 =C2=A0 ret =3D vhost_dev_init(&amp;vub-&gt;vhost_dev, &amp;vub-&gt;=
vhost_user,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0VHOST_BACKEND_TYPE_USER, 0, errp);<br>
-<br>
-=C2=A0 =C2=A0 if (ret &lt; 0) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_vhost_user_cleanup(vdev, vub);<br>
-=C2=A0 =C2=A0 }<br>
-<br>
=C2=A0 =C2=A0 =C2=A0qemu_chr_fe_set_handlers(&amp;vub-&gt;chardev, NULL, NU=
LL, vub_event, NULL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev, NULL, true);<br>
=C2=A0}<br>
-- <br>
2.39.2<br>
<br>
<br>
</blockquote></div></div>

--0000000000008a51730604493c18--

