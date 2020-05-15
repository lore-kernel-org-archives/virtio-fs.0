From: Fotis Xenakis <foxen@windowslive.com>
Date: Fri, 15 May 2020 16:50:31 +0000
Message-ID: <VI1PR03MB4383EAFC7403141AB2278802A6BD0@VI1PR03MB4383.eurprd03.prod.outlook.com>
References: <VI1PR03MB438360F20BFF32EC2AE5ACCEA6BF0@VI1PR03MB4383.eurprd03.prod.outlook.com>,
	<20200515034814.GB49087@rsjd01523.et2sqa>
In-Reply-To: <20200515034814.GB49087@rsjd01523.et2sqa>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="_000_VI1PR03MB4383EAFC7403141AB2278802A6BD0VI1PR03MB4383eurp_"
Subject: Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setupmapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "bo.liu@linux.alibaba.com" <bo.liu@linux.alibaba.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_VI1PR03MB4383EAFC7403141AB2278802A6BD0VI1PR03MB4383eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

From: Liu Bo <bo.liu@linux.alibaba.com>
Sent: Friday, May 15, 2020 06:48
To: Fotis Xenakis <foxen@windowslive.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setupmappin=
g

On Wed, May 13, 2020 at 07:33:56PM +0300, Fotis Xenakis wrote:
> Currently, during FUSE_SETUPMAPPING, virtiofsd passes the wrong file
> descriptor for the file to mmap() to QEMU (specifically, it passes the
> file handle as requested from the guest).
>
> This fixes it, using lo_fi_fd() to map the file handle to the right file
> descriptor on the host.
>

Looks good, guest has been setting fi as NULL though.
As far as I can see, this function is only called from [1], which passes fi=
 as NULL only when the file handle passed from the guest is (uint64_t)-1. I=
n my testing this was never the case though.

Reference:
[1] https://gitlab.com/virtio-fs/qemu/-/blob/21336c0f3d05a97f5c409bbc894c19=
d87259655c/tools/virtiofsd/fuse_lowlevel.c#L1930
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>


> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrou=
gh_ll.c
> index e09d557d74..44bb24eb5e 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2709,7 +2709,7 @@ static void lo_setupmapping(fuse_req_t req, fuse_in=
o_t ino, uint64_t foffset,
>      msg.flags[0] =3D vhu_flags;
>
>      if (fi) {
> -        fd =3D fi->fh;
> +        fd =3D lo_fi_fd(req, fi);
>      } else {
>          res =3D asprintf(&buf, "%i", lo_fd(req, ino));
>          if (res =3D=3D -1) {
> --
> 2.26.2
>
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--_000_VI1PR03MB4383EAFC7403141AB2278802A6BD0VI1PR03MB4383eurp_
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
<blockquote style=3D"border-left: 3px solid rgb(200, 200, 200); border-top-=
color: rgb(200, 200, 200); border-right-color: rgb(200, 200, 200); border-b=
ottom-color: rgb(200, 200, 200); padding-left: 1ex; margin-left: 0.8ex; col=
or: rgb(102, 102, 102);">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" co=
lor=3D"#000000" style=3D"font-size:11pt"><b>From:</b> Liu Bo &lt;bo.liu@lin=
ux.alibaba.com&gt;<br>
<b>Sent:</b> Friday, May 15, 2020 06:48<br>
<b>To:</b> Fotis Xenakis &lt;foxen@windowslive.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setu=
pmapping</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">On Wed, May 13, 2020 at 07:33:56PM &#43;0300, Foti=
s Xenakis wrote:<br>
&gt; Currently, during FUSE_SETUPMAPPING, virtiofsd passes the wrong file<b=
r>
&gt; descriptor for the file to mmap() to QEMU (specifically, it passes the=
<br>
&gt; file handle as requested from the guest).<br>
&gt; <br>
&gt; This fixes it, using lo_fi_fd() to map the file handle to the right fi=
le<br>
&gt; descriptor on the host.<br>
&gt;<br>
<br>
Looks good, guest has been setting fi as NULL though.<br>
</div>
</span></font></div>
</blockquote>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">As far as I can see, this function is only called =
from [1], which passes fi as NULL only when the file handle passed from the=
 guest is (uint64_t)-1. In my testing this was never the case though.</div>
<div class=3D"PlainText"><br>
</div>
<div class=3D"PlainText">Reference:</div>
<div class=3D"PlainText">[1]&nbsp;<a href=3D"https://gitlab.com/virtio-fs/q=
emu/-/blob/21336c0f3d05a97f5c409bbc894c19d87259655c/tools/virtiofsd/fuse_lo=
wlevel.c#L1930" id=3D"LPNoLP164453">https://gitlab.com/virtio-fs/qemu/-/blo=
b/21336c0f3d05a97f5c409bbc894c19d87259655c/tools/virtiofsd/fuse_lowlevel.c#=
L1930</a><br>
<blockquote style=3D"border-left: 3px solid rgb(200, 200, 200); border-top-=
color: rgb(200, 200, 200); border-right-color: rgb(200, 200, 200); border-b=
ottom-color: rgb(200, 200, 200); padding-left: 1ex; margin-left: 0.8ex; col=
or: rgb(102, 102, 102);">
Reviewed-by: Liu Bo &lt;bo.liu@linux.alibaba.com&gt;<br>
<br>
<br>
&gt; Signed-off-by: Fotis Xenakis &lt;foxen@windowslive.com&gt;<br>
&gt; ---<br>
&gt;&nbsp; tools/virtiofsd/passthrough_ll.c | 2 &#43;-<br>
&gt;&nbsp; 1 file changed, 1 insertion(&#43;), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passth=
rough_ll.c<br>
&gt; index e09d557d74..44bb24eb5e 100644<br>
&gt; --- a/tools/virtiofsd/passthrough_ll.c<br>
&gt; &#43;&#43;&#43; b/tools/virtiofsd/passthrough_ll.c<br>
&gt; @@ -2709,7 &#43;2709,7 @@ static void lo_setupmapping(fuse_req_t req, =
fuse_ino_t ino, uint64_t foffset,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; msg.flags[0] =3D vhu_flags;<br>
&gt;&nbsp; <br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (fi) {<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fd =3D fi-&gt;fh;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fd =3D lo_fi_fd(req, f=
i);<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; res =3D asprintf=
(&amp;buf, &quot;%i&quot;, lo_fd(req, ino));<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (res =3D=3D -=
1) {<br>
&gt; -- <br>
&gt; 2.26.2<br>
&gt; <br>
&gt; <br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; Virtio-fs@redhat.com<br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/virtio-fs">https://=
www.redhat.com/mailman/listinfo/virtio-fs</a><br>
</blockquote>
</div>
</span></font></div>
</body>
</html>

--_000_VI1PR03MB4383EAFC7403141AB2278802A6BD0VI1PR03MB4383eurp_--

