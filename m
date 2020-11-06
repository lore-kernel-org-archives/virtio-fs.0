From: Fotis Xenakis <foxen@windowslive.com>
Date: Fri, 6 Nov 2020 22:43:48 +0000
Message-ID: <AM0PR03MB62922C93066A83FBB8480E5EA6ED0@AM0PR03MB6292.eurprd03.prod.outlook.com>
References: <AM0PR03MB629226965B72D3808EFB8795A6EF0@AM0PR03MB6292.eurprd03.prod.outlook.com>,
	<20201106181155.GR3576@work-vm>
In-Reply-To: <20201106181155.GR3576@work-vm>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_AM0PR03MB62922C93066A83FBB8480E5EA6ED0AM0PR03MB6292eurp_"
Subject: Re: [Virtio-fs] [qemu-web PATCH v2] Add virtio-fs in OSv overview
 blog post
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "thuth@redhat.com" <thuth@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

--_000_AM0PR03MB62922C93066A83FBB8480E5EA6ED0AM0PR03MB6292eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

From: Dr. David Alan Gilbert <dgilbert@redhat.com>
* Fotis Xenakis (foxen@windowslive.com) wrote:
> This post briefly goes over the main points of virtio-fs and OSv, a
> unikernel running under QEMU/KVM and taking advantage of its virtio-fs
> implementation.
>
> Changes since v1:
> - Fixed wording and links, as suggested by Thomas Huth.
> - Added a short example of virtio-fs usage in OSv.
>
> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>

> +One central point is OSv's support for booting from virtio-fs: this enab=
les
> +deploying a modified version or a whole new application **without rebuil=
ding**
> +the image, just by adjusting its root file system contents on the host. =
Last,
> +owing to the DAX window practically providing low-overhead access to the=
 host's
> +page cache, scalability is also expected to excel, with it being a commo=
n
> +concern due to the potentially high density of unikernels per host.

Hi Fotis,
Hello Dave,
  Since I'm not used to unikernels, I'm a little confused by this; I'd
appreciate some explanation.

  In your unikernel, does the root filesystem just contain data?  I mean
being a 'unikernel' aren't all the binaries and support all linked into
the kernel itself?
Short answer: the root file system doesn't contain only data, the
executable can also be loaded from it. Although a unikernel, it
supports both the embedded-in-kernel and separate-filesystem
approaches.

OSv is more heavy-weight than most unikernels, in the sense that it
supports a lot of features found in general-purpose OSs. One could
just describe it as a specialized, light-weight OS. On the filesystem
side, it's actually pretty close e.g. to Linux: it has a VFS and multiple
filesystems:

  *   pseudo-fs (devfs and others)
  *   ramfs, which is indeed embedded into the kernel
  *   ZFS and ROFS, on regular block devices
  *   NFS, virtio-fs

Also like Linux, it initially boots into its initramfs (embedded in the
kernel) and then typically mounts a root file system from a device
(ZFS, ROFS or virtio-fs), before executing the application code.

In case this is not clear, please feel free to ask further!

Fotis

Dave
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


--_000_AM0PR03MB62922C93066A83FBB8480E5EA6ED0AM0PR03MB6292eurp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
</div>
<div dir=3D"ltr"><font face=3D"Calibri, sans-serif" color=3D"#000000" style=
=3D"font-size:11pt"><b>From:</b> Dr. David Alan Gilbert &lt;dgilbert@redhat=
.com&gt;<br>
</font></div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
<div id=3D"divRplyFwdMsg" dir=3D"ltr">
<div>* Fotis Xenakis (foxen@windowslive.com) wrote:<br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">&gt; This post briefly goes over the main points o=
f virtio-fs and OSv, a<br>
&gt; unikernel running under QEMU/KVM and taking advantage of its virtio-fs=
<br>
&gt; implementation.<br>
&gt; <br>
&gt; Changes since v1:<br>
&gt; - Fixed wording and links, as suggested by Thomas Huth.<br>
&gt; - Added a short example of virtio-fs usage in OSv.<br>
&gt; <br>
&gt; Signed-off-by: Fotis Xenakis &lt;foxen@windowslive.com&gt;<br>
<br>
&gt; +One central point is OSv's support for booting from virtio-fs: this e=
nables<br>
&gt; +deploying a modified version or a whole new application **without reb=
uilding**<br>
&gt; +the image, just by adjusting its root file system contents on the hos=
t. Last,<br>
&gt; +owing to the DAX window practically providing low-overhead access to =
the host's<br>
&gt; +page cache, scalability is also expected to excel, with it being a co=
mmon<br>
&gt; +concern due to the potentially high density of unikernels per host.<b=
r>
<br>
</div>
<div class=3D"PlainText">Hi Fotis,<br>
</div>
</span></font></div>
</blockquote>
<div class=3D"PlainText">Hello Dave,</div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">&nbsp; Since I'm not used to unikernels, I'm a lit=
tle confused by this; I'd<br>
appreciate some explanation.<br>
<br>
&nbsp; In your unikernel, does the root filesystem just contain data?&nbsp;=
 I mean<br>
being a 'unikernel' aren't all the binaries and support all linked into<br>
</div>
<div class=3D"PlainText">the kernel itself?<br>
</div>
</span></font></div>
</blockquote>
<div class=3D"PlainText">Short answer: the root file system doesn't contain=
 only data, the</div>
<div class=3D"PlainText">executable can also be loaded from it. Although a =
unikernel, it</div>
<div class=3D"PlainText">supports both the embedded-in-kernel and separate-=
filesystem</div>
<div class=3D"PlainText">approaches.</div>
<div class=3D"PlainText"><br>
</div>
<div class=3D"PlainText">OSv is more heavy-weight than most unikernels, in =
the sense that it<br>
</div>
<div class=3D"PlainText">supports a lot of features found in general-purpos=
e OSs. One could</div>
<div class=3D"PlainText">just describe it as a specialized, light-weight OS=
. On the filesystem</div>
<div class=3D"PlainText">side, it's actually pretty close e.g. to Linux: it=
 has a VFS and multiple</div>
<div class=3D"PlainText">filesystems:</div>
<div class=3D"PlainText">
<ul>
<li>pseudo-fs (devfs and others)</li><li>ramfs, which is indeed embedded in=
to the kernel</li><li>ZFS and ROFS, on regular block devices</li><li>NFS, v=
irtio-fs<br>
</li></ul>
<div>Also like Linux, it initially boots into its initramfs (embedded in th=
e</div>
<div>kernel) and then typically mounts a root file system from a device</di=
v>
<div>(ZFS, ROFS or virtio-fs), before executing the application code.</div>
<div><br>
</div>
<div>In case this is not clear, please feel free to ask further!</div>
<div><br>
</div>
<div>Fotis</div>
</div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText"><br>
Dave<br>
-- <br>
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK<br>
</div>
</span></font></div>
</blockquote>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText"><br>
</div>
</span></font></div>
</body>
</html>

--_000_AM0PR03MB62922C93066A83FBB8480E5EA6ED0AM0PR03MB6292eurp_--

