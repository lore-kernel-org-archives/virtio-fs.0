From: Fotis Xenakis <foxen@windowslive.com>
Date: Wed, 28 Oct 2020 11:10:54 +0000
Message-ID: <AM0PR03MB62922FA422BE92E54BAAC06FA6170@AM0PR03MB6292.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_AM0PR03MB62922FA422BE92E54BAAC06FA6170AM0PR03MB6292eurp_"
Subject: Re: [Virtio-fs] Architecture diagram license
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

--_000_AM0PR03MB62922FA422BE92E54BAAC06FA6170AM0PR03MB6292eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2020 at 11:31:54PM +0000, Fotis Xenakis wrote:
> OSv is a unikernel happily running on QEMU/KVM, supporting different file=
systems. Virtio-fs is a great fit for unikernels: it offers an escape route=
 from rebuilding images for every change and very competitive performance j=
ust to name a couple of factors.
> I decided as part of my thesis to tackle read-only virtio-fs DAX window s=
upport on the OSv side (nothing big, no comparison to linux). This has been=
 merged and works on OSv and I 've been working on evaluating it (spoiler: =
it works very nicely and performance is pretty good).
> Unfortunately, the thesis containing the detailed evaluation is mostly in=
 Greek, in any case you can find it here https://github.com/foxeng/diploma.=
 When time allows, I will also do an English write-up for sharing. If anyon=
e's interested, I 'll make sure to post it here too!

You are welcome to write a guest post on the QEMU blog
(https://qemu.org/blog/) that gives an overview of OSv and the virtio-fs
device interface. I imagine people would be interested in learning about
both these topics.

The git repo for the QEMU website and blog is here:
https://gitlab.com/qemu-project/qemu-web

You can create a new blog post by dropping a Markdown file into _posts/.
Images can be added to screenshots/ directory.

The blog post can be sent to the QEMU mailing list using
git-send-email(1) with Thomas Huth <thuth@redhat.com> CCed. Please also
CC virtio-fs@redhat.com and we'll review it.
Thank you very much for the invite and the detailed instructions!
I 'd be very glad to do this and will go ahead upon first chance.

Fotis
Stefan

--_000_AM0PR03MB62922FA422BE92E54BAAC06FA6170AM0PR03MB6292eurp_
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
<div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
On Mon, Oct 26, 2020 at 11:31:54PM +0000, Fotis Xenakis wrote:<br>
&gt; OSv is a unikernel happily running on QEMU/KVM, supporting different f=
ilesystems. Virtio-fs is a great fit for unikernels: it offers an escape ro=
ute from rebuilding images for every change and very competitive performanc=
e just to name a couple of factors.<br>
&gt; I decided as part of my thesis to tackle read-only virtio-fs DAX windo=
w support on the OSv side (nothing big, no comparison to linux). This has b=
een merged and works on OSv and I 've been working on evaluating it (spoile=
r: it works very nicely and performance
 is pretty good).<br>
&gt; Unfortunately, the thesis containing the detailed evaluation is mostly=
 in Greek, in any case you can find it here
<a href=3D"https://github.com/foxeng/diploma" target=3D"_blank" rel=3D"noop=
ener noreferrer" data-auth=3D"NotApplicable">
https://github.com/foxeng/diploma</a>. When time allows, I will also do an =
English write-up for sharing. If anyone's interested, I 'll make sure to po=
st it here too!<br>
<br>
You are welcome to write a guest post on the QEMU blog<br>
(<a href=3D"https://qemu.org/blog/" target=3D"_blank" rel=3D"noopener noref=
errer" data-auth=3D"NotApplicable">https://qemu.org/blog/</a>) that gives a=
n overview of OSv and the virtio-fs<br>
device interface. I imagine people would be interested in learning about<br=
>
<div>both these topics.</div>
<div><br>
</div>
The git repo for the QEMU website and blog is here:<br>
<a href=3D"https://gitlab.com/qemu-project/qemu-web" target=3D"_blank" rel=
=3D"noopener noreferrer" data-auth=3D"NotApplicable">https://gitlab.com/qem=
u-project/qemu-web</a><br>
<br>
You can create a new blog post by dropping a Markdown file into _posts/.<br=
>
Images can be added to screenshots/ directory.<br>
<br>
The blog post can be sent to the QEMU mailing list using<br>
git-send-email(1) with Thomas Huth &lt;thuth@redhat.com&gt; CCed. Please al=
so<br>
<div>CC virtio-fs@redhat.com and we'll review it.</div>
</blockquote>
<div>Thank you very much for the invite and the detailed instructions!</div=
>
<div>I 'd be very glad to do this and will go ahead upon first chance.</div=
>
<div><br>
</div>
<div>Fotis</div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
Stefan<br>
</blockquote>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_AM0PR03MB62922FA422BE92E54BAAC06FA6170AM0PR03MB6292eurp_--

