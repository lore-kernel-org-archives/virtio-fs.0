Return-Path: <kkostiuk@redhat.com>
MIME-Version: 1.0
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
 <20221110100629.61496-2-akihiko.odaki@daynix.com>
 <CAPMcbCrGkXzeZex_veDYV8HSMMzH8d=zy1jkf21t4qFekGmDpg@mail.gmail.com>
 <f3895076-5ccc-4542-8cc5-635a99cff182@daynix.com>
In-Reply-To: <f3895076-5ccc-4542-8cc5-635a99cff182@daynix.com>
From: Konstantin Kostiuk <kkostiuk@redhat.com>
Date: Thu, 21 Sep 2023 12:52:58 +0300
Message-ID: <CAPMcbCpwJb+uE0U_d+NYScVest1QGB3extUZ9xM10YeGM0-tVQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000a29d5b0605db7524"
Subject: Re: [Virtio-fs] [PATCH v2 01/10] qga: Remove platform GUID
 definitions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>

--000000000000a29d5b0605db7524
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Akihiko,

Thanks for ping.
I will merge this commit with other qga fixes.

Best Regards,
Konstantin Kostiuk.


On Thu, Sep 21, 2023 at 10:58=E2=80=AFAM Akihiko Odaki <akihiko.odaki@dayni=
x.com>
wrote:

> On 2022/11/17 18:45, Konstantin Kostiuk wrote:
> > Reviewed-by: Konstantin Kostiuk <kkostiuk@redhat.com
> > <mailto:kkostiuk@redhat.com>>
> >
> > Will merge this patch in QGA series
> >
> > On Thu, Nov 10, 2022 at 12:06 PM Akihiko Odaki <akihiko.odaki@daynix.co=
m
> > <mailto:akihiko.odaki@daynix.com>> wrote:
> >
> >     GUID_DEVINTERFACE_DISK and GUID_DEVINTERFACE_STORAGEPORT are alread=
y
> >     defined by MinGW-w64. They are not only unnecessary, but can lead t=
o
> >     duplicate definition errors at link time with some unknown conditio=
n.
> >
> >     Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com
> >     <mailto:akihiko.odaki@daynix.com>>
> >     ---
> >       qga/commands-win32.c | 7 -------
> >       1 file changed, 7 deletions(-)
> >
> >     diff --git a/qga/commands-win32.c b/qga/commands-win32.c
> >     index ec9f55b453..dde5d401bb 100644
> >     --- a/qga/commands-win32.c
> >     +++ b/qga/commands-win32.c
> >     @@ -506,13 +506,6 @@ static GuestDiskBusType
> >     find_bus_type(STORAGE_BUS_TYPE bus)
> >           return win2qemu[(int)bus];
> >       }
> >
> >     -DEFINE_GUID(GUID_DEVINTERFACE_DISK,
> >     -        0x53f56307L, 0xb6bf, 0x11d0, 0x94, 0xf2,
> >     -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
> >     -DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,
> >     -        0x2accfe60L, 0xc130, 0x11d2, 0xb0, 0x82,
> >     -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
> >     -
> >       static void get_pci_address_for_device(GuestPCIAddress *pci,
> >                                              HDEVINFO dev_info)
> >       {
> >     --
> >     2.38.1
> >
>
> Hi Konstantin,
>
> This patch seems missed since then. Can you merge it?
>
> Regards,
> Akihiko Odaki
>
>

--000000000000a29d5b0605db7524
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Akihiko,</div><div><br></div><div>Thanks for ping.=
 <br></div><div>I will merge this commit with other qga fixes.<br></div><di=
v><br></div><div><div><div><div dir=3D"ltr" class=3D"gmail_signature" data-=
smartmail=3D"gmail_signature"><div dir=3D"ltr"><div>Best Regards,</div><div=
>Konstantin Kostiuk.</div></div></div></div><br></div></div></div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 21,=
 2023 at 10:58=E2=80=AFAM Akihiko Odaki &lt;<a href=3D"mailto:akihiko.odaki=
@daynix.com">akihiko.odaki@daynix.com</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">On 2022/11/17 18:45, Konstantin Kostiu=
k wrote:<br>
&gt; Reviewed-by: Konstantin Kostiuk &lt;<a href=3D"mailto:kkostiuk@redhat.=
com" target=3D"_blank">kkostiuk@redhat.com</a> <br>
&gt; &lt;mailto:<a href=3D"mailto:kkostiuk@redhat.com" target=3D"_blank">kk=
ostiuk@redhat.com</a>&gt;&gt;<br>
&gt; <br>
&gt; Will merge this patch in QGA series<br>
&gt; <br>
&gt; On Thu, Nov 10, 2022 at 12:06 PM Akihiko Odaki &lt;<a href=3D"mailto:a=
kihiko.odaki@daynix.com" target=3D"_blank">akihiko.odaki@daynix.com</a> <br=
>
&gt; &lt;mailto:<a href=3D"mailto:akihiko.odaki@daynix.com" target=3D"_blan=
k">akihiko.odaki@daynix.com</a>&gt;&gt; wrote:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0GUID_DEVINTERFACE_DISK and GUID_DEVINTERFACE_STORAG=
EPORT are already<br>
&gt;=C2=A0 =C2=A0 =C2=A0defined by MinGW-w64. They are not only unnecessary=
, but can lead to<br>
&gt;=C2=A0 =C2=A0 =C2=A0duplicate definition errors at link time with some =
unknown condition.<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0Signed-off-by: Akihiko Odaki &lt;<a href=3D"mailto:=
akihiko.odaki@daynix.com" target=3D"_blank">akihiko.odaki@daynix.com</a><br=
>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:akihiko.odaki@daynix.c=
om" target=3D"_blank">akihiko.odaki@daynix.com</a>&gt;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0qga/commands-win32.c | 7 -------<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01 file changed, 7 deletions(-)<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0diff --git a/qga/commands-win32.c b/qga/commands-wi=
n32.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0index ec9f55b453..dde5d401bb 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0--- a/qga/commands-win32.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0+++ b/qga/commands-win32.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -506,13 +506,6 @@ static GuestDiskBusType<br>
&gt;=C2=A0 =C2=A0 =C2=A0find_bus_type(STORAGE_BUS_TYPE bus)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return win2qemu[(int)bus];<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0-DEFINE_GUID(GUID_DEVINTERFACE_DISK,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x53f56307L, 0xb6bf, 0=
x11d0, 0x94, 0xf2,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x00, 0xa0, 0xc9, 0x1e=
, 0xfb, 0x8b);<br>
&gt;=C2=A0 =C2=A0 =C2=A0-DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x2accfe60L, 0xc130, 0=
x11d2, 0xb0, 0x82,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x00, 0xa0, 0xc9, 0x1e=
, 0xfb, 0x8b);<br>
&gt;=C2=A0 =C2=A0 =C2=A0-<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0static void get_pci_address_for_device(Guest=
PCIAddress *pci,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 HDEVINFO dev_info)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0-- <br>
&gt;=C2=A0 =C2=A0 =C2=A02.38.1<br>
&gt; <br>
<br>
Hi Konstantin,<br>
<br>
This patch seems missed since then. Can you merge it?<br>
<br>
Regards,<br>
Akihiko Odaki<br>
<br>
</blockquote></div>

--000000000000a29d5b0605db7524--

