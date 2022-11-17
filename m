Return-Path: <kkostiuk@redhat.com>
MIME-Version: 1.0
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
 <20221110100629.61496-2-akihiko.odaki@daynix.com>
In-Reply-To: <20221110100629.61496-2-akihiko.odaki@daynix.com>
From: Konstantin Kostiuk <kkostiuk@redhat.com>
Date: Thu, 17 Nov 2022 11:45:21 +0200
Message-ID: <CAPMcbCrGkXzeZex_veDYV8HSMMzH8d=zy1jkf21t4qFekGmDpg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000003c364405eda773b4"
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

--0000000000003c364405eda773b4
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Konstantin Kostiuk <kkostiuk@redhat.com>

Will merge this patch in QGA series

On Thu, Nov 10, 2022 at 12:06 PM Akihiko Odaki <akihiko.odaki@daynix.com>
wrote:

> GUID_DEVINTERFACE_DISK and GUID_DEVINTERFACE_STORAGEPORT are already
> defined by MinGW-w64. They are not only unnecessary, but can lead to
> duplicate definition errors at link time with some unknown condition.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  qga/commands-win32.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/qga/commands-win32.c b/qga/commands-win32.c
> index ec9f55b453..dde5d401bb 100644
> --- a/qga/commands-win32.c
> +++ b/qga/commands-win32.c
> @@ -506,13 +506,6 @@ static GuestDiskBusType
> find_bus_type(STORAGE_BUS_TYPE bus)
>      return win2qemu[(int)bus];
>  }
>
> -DEFINE_GUID(GUID_DEVINTERFACE_DISK,
> -        0x53f56307L, 0xb6bf, 0x11d0, 0x94, 0xf2,
> -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
> -DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,
> -        0x2accfe60L, 0xc130, 0x11d2, 0xb0, 0x82,
> -        0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
> -
>  static void get_pci_address_for_device(GuestPCIAddress *pci,
>                                         HDEVINFO dev_info)
>  {
> --
> 2.38.1
>
>

--0000000000003c364405eda773b4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Reviewed-by: Konstantin Kostiuk &lt;<a href=3D"mailto=
:kkostiuk@redhat.com" target=3D"_blank">kkostiuk@redhat.com</a>&gt;</div><d=
iv><br></div><div>Will merge this patch in QGA series <br></div></div><br><=
div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Nov=
 10, 2022 at 12:06 PM Akihiko Odaki &lt;<a href=3D"mailto:akihiko.odaki@day=
nix.com">akihiko.odaki@daynix.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">GUID_DEVINTERFACE_DISK and GUID_DEVINTERFA=
CE_STORAGEPORT are already<br>
defined by MinGW-w64. They are not only unnecessary, but can lead to<br>
duplicate definition errors at link time with some unknown condition.<br>
<br>
Signed-off-by: Akihiko Odaki &lt;<a href=3D"mailto:akihiko.odaki@daynix.com=
" target=3D"_blank">akihiko.odaki@daynix.com</a>&gt;<br>
---<br>
=C2=A0qga/commands-win32.c | 7 -------<br>
=C2=A01 file changed, 7 deletions(-)<br>
<br>
diff --git a/qga/commands-win32.c b/qga/commands-win32.c<br>
index ec9f55b453..dde5d401bb 100644<br>
--- a/qga/commands-win32.c<br>
+++ b/qga/commands-win32.c<br>
@@ -506,13 +506,6 @@ static GuestDiskBusType find_bus_type(STORAGE_BUS_TYPE=
 bus)<br>
=C2=A0 =C2=A0 =C2=A0return win2qemu[(int)bus];<br>
=C2=A0}<br>
<br>
-DEFINE_GUID(GUID_DEVINTERFACE_DISK,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x53f56307L, 0xb6bf, 0x11d0, 0x94, 0xf2,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);<br>
-DEFINE_GUID(GUID_DEVINTERFACE_STORAGEPORT,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x2accfe60L, 0xc130, 0x11d2, 0xb0, 0x82,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);<br>
-<br>
=C2=A0static void get_pci_address_for_device(GuestPCIAddress *pci,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 HDEVINFO=
 dev_info)<br>
=C2=A0{<br>
-- <br>
2.38.1<br>
<br>
</blockquote></div>

--0000000000003c364405eda773b4--

