From: Fotis Xenakis <foxen@windowslive.com>
Date: Mon, 26 Oct 2020 23:31:54 +0000
Message-ID: <AM0PR03MB6292A6819675EF4384D80510A6190@AM0PR03MB6292.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_AM0PR03MB6292A6819675EF4384D80510A6190AM0PR03MB6292eurp_"
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

--_000_AM0PR03MB6292A6819675EF4384D80510A6190AM0PR03MB6292eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Okay, in that case this is my written confirmation that you may use the
https://creativecommons.org/licenses/by-sa/4.0/ license on the
architecture.svg file.
Thank you!
I'll send a separate patch to explicitly apply the license to the entire
virtio-fs website.

By the way, how are you using virtio-fs in your thesis? It would be
interesting to hear what you are working on.
OSv is a unikernel happily running on QEMU/KVM, supporting different filesy=
stems. Virtio-fs is a great fit for unikernels: it offers an escape route f=
rom rebuilding images for every change and very competitive performance jus=
t to name a couple of factors.
I decided as part of my thesis to tackle read-only virtio-fs DAX window sup=
port on the OSv side (nothing big, no comparison to linux). This has been m=
erged and works on OSv and I 've been working on evaluating it (spoiler: it=
 works very nicely and performance is pretty good).
Unfortunately, the thesis containing the detailed evaluation is mostly in G=
reek, in any case you can find it here https://github.com/foxeng/diploma. W=
hen time allows, I will also do an English write-up for sharing. If anyone'=
s interested, I 'll make sure to post it here too!

By the way, I 'd like to congratulate and thank everyone involved in the pr=
oject for your amazing work, both in terms of concept, implementation and l=
anding it upstream in the relevant projects. Personally, I find virtio-fs f=
ills a much-needed gap and is an elegant, versatile solution at that too. I=
n addition, it fits the unikernel use-cases very nicely: very roughly, what=
 one could do with e.g. Docker and a bind mount can now be done with OSv an=
d virtio-fs, usability-wise.
Finally, the virtiofsd Rust effort is very exciting: it's really nice seein=
g Rust used in real-world, big projects like this. Hope it delivers!

Fotis
Stefan

--_000_AM0PR03MB6292A6819675EF4384D80510A6190AM0PR03MB6292eurp_
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
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
Okay, in that case this is my written confirmation that you may use the<br>
<a href=3D"https://creativecommons.org/licenses/by-sa/4.0/" target=3D"_blan=
k" rel=3D"noopener noreferrer" data-auth=3D"NotApplicable">https://creative=
commons.org/licenses/by-sa/4.0/</a> license on the<br>
<div>architecture.svg file.<br>
</div>
</blockquote>
<div>Thank you!</div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
I'll send a separate patch to explicitly apply the license to the entire<br=
>
virtio-fs website.<br>
<br>
By the way, how are you using virtio-fs in your thesis? It would be<br>
<div>interesting to hear what you are working on.</div>
</blockquote>
<div>OSv is a unikernel happily running on QEMU/KVM, supporting different f=
ilesystems. Virtio-fs is a great fit for unikernels: it offers an escape ro=
ute from rebuilding images for every change and very competitive performanc=
e just to name a couple of factors.</div>
<div>I decided as part of my thesis to tackle read-only virtio-fs DAX windo=
w support on the OSv side (nothing big, no comparison to linux). This has b=
een merged and works on OSv and I 've been working on evaluating it (spoile=
r: it works very nicely and performance
 is pretty good).</div>
<div>Unfortunately, the thesis containing the detailed evaluation is mostly=
 in Greek, in any case you can find it here&nbsp;<a href=3D"https://github.=
com/foxeng/diploma" id=3D"LPlnk955035">https://github.com/foxeng/diploma</a=
>. When time allows, I will also do an English
 write-up for sharing. If anyone's interested, I 'll make sure to post it h=
ere too!</div>
<div><br>
</div>
<div>By the way, I 'd like to congratulate and thank everyone involved in t=
he project for your amazing work, both in terms of concept, implementation =
and landing it upstream in the relevant projects. Personally, I find virtio=
-fs fills a much-needed gap and
 is an elegant, versatile solution at that too. In addition, it fits the un=
ikernel use-cases very nicely: very roughly, what one could do with e.g. Do=
cker and a bind mount can now be done with OSv and virtio-fs, usability-wis=
e.</div>
<div>Finally, the virtiofsd Rust effort is very exciting: it's really nice =
seeing Rust used in real-world, big projects like this. Hope it delivers!</=
div>
<div><br>
</div>
<div>Fotis</div>
<blockquote class=3D"quotableTextTraining" style=3D"border-left: 3px solid =
rgb(200, 200, 200); border-top-color: rgb(200, 200, 200); border-right-colo=
r: rgb(200, 200, 200); border-bottom-color: rgb(200, 200, 200); padding-lef=
t: 1ex; margin-left: 0.8ex; color: rgb(102, 102, 102);">
<div><span style=3D"color: rgb(102, 102, 102);">Stefan</span><br>
</div>
</blockquote>
</div>
</span></font></div>
</body>
</html>

--_000_AM0PR03MB6292A6819675EF4384D80510A6190AM0PR03MB6292eurp_--

