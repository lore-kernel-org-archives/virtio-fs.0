MIME-Version: 1.0
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEZDOcFr80tZGWd@redhat.com>
	<YgGM6pA2sXEAMa3a@redhat.com> <YgIw+juiHLCXEhNn@redhat.com>
In-Reply-To: <YgIw+juiHLCXEhNn@redhat.com>
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 9 Feb 2022 11:24:29 +0100
Message-ID: <CAJh=p+65FWDbze_86RqBKtd=at_Cj6E2YmUz=5pE29fd--zzwA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000004ffcb505d7933fd3"
Subject: Re: [Virtio-fs] [PATCH v5 0/9] virtiofsd: Add support for file
 security context at file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

--0000000000004ffcb505d7933fd3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 8, 2022 at 11:44 PM Daniel P. Berrang=C3=A9 <berrange@redhat.co=
m>
wrote:

> On Mon, Feb 07, 2022 at 04:19:38PM -0500, Vivek Goyal wrote:
> > On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrang=C3=A9 wrote=
:
> > > On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
> > > > Hi,
> > > >
> > > > This is V5 of the patches. I posted V4 here.
> > > >
> > > >
> https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> > > >
> > > > These will allow us to support SELinux with virtiofs. This will sen=
d
> > > > SELinux context at file creation to server and server can set it on
> > > > file.
> > >
> > > I've not entirely figured it out from the code, so easier for me
> > > to ask...
> > >
> > > How is the SELinux labelled stored on the host side ? It is stored
> > > directly in the security.* xattr namespace,
> >
> > [ CC Dan Walsh ]
> >
> > I just tried to test the mode where I don't do xattr remapping and try
> > to set /proc/pid/attr/fscreate with the context I want to set. It will
> > set security.selinux xattr on host.
> >
> > But write to /proc/pid/attr/fscreate fails if host does not recognize
> > the label sent by guest. I am running virtiofsd with unconfined_t but
> > it still fails because guest is trying to create a file with
> > "test_filesystem_filetranscon_t" and host does not recognize this
> > label. Seeing following in audit logs.
> >
> > type=3DSELINUX_ERR msg=3Daudit(1644268262.666:8111): op=3Dfscreate
> invalid_context=3D"unconfined_u:object_r:test_filesystem_filetranscon_t:s=
0"
>
> Yes, that's to be expected if the host policy doesn't know about the
> label that the guest is using.
>
> IOW, non-mapping case is only useful if you have a very good match
> between host + guest OS policy. This could be useful for an app
> like Kata because their guest is not a full OS, it is something
> special purpose and tightly controlled.
>
> > So if we don't remap xattrs and host has SELinux enabled, then it
> probably
> > work in very limited circumstances where host and guest policies don't
> > conflict. I guess its like running fedora 34 guest on fedora 34 host.
> > I suspect that this will see very limited use. Though I have put the
> > code in for the sake of completeness.
>
> For general purpose guest OS virtualization remapping is going to be
> effectuively mandatory.  The non-mapped case only usable when you tightly
> control the guest OS packages from the host.
>


If remap is recommended, why not make it mandatory or automatic?,
for instance, '-o security_label' either requires '-o xattrmap=3D' or
automatically makes
the mapping with the 'trusted' prefix, while  '-o security_label=3Dnomap'
doesn't, so you
can choose whatever you want.

(I'm not suggesting the 'nomap' name, I'm terrible choosing names)

--=20
German

--0000000000004ffcb505d7933fd3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Feb 8, 2022 at 11:44 PM Danie=
l P. Berrang=C3=A9 &lt;<a href=3D"mailto:berrange@redhat.com" target=3D"_bl=
ank">berrange@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On Mon, Feb 07, 2022 at 04:19:38PM -0500, Vivek Goy=
al wrote:<br>
&gt; On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrang=C3=A9 wrot=
e:<br>
&gt; &gt; On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:<br>
&gt; &gt; &gt; Hi,<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; This is V5 of the patches. I posted V4 here.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; <a href=3D"https://listman.redhat.com/archives/virtio-fs/202=
2-January/msg00041.html" rel=3D"noreferrer" target=3D"_blank">https://listm=
an.redhat.com/archives/virtio-fs/2022-January/msg00041.html</a><br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; These will allow us to support SELinux with virtiofs. This w=
ill send<br>
&gt; &gt; &gt; SELinux context at file creation to server and server can se=
t it on<br>
&gt; &gt; &gt; file.<br>
&gt; &gt; <br>
&gt; &gt; I&#39;ve not entirely figured it out from the code, so easier for=
 me<br>
&gt; &gt; to ask...<br>
&gt; &gt; <br>
&gt; &gt; How is the SELinux labelled stored on the host side ? It is store=
d<br>
&gt; &gt; directly in the security.* xattr namespace,<br>
&gt; <br>
&gt; [ CC Dan Walsh ]<br>
&gt; <br>
&gt; I just tried to test the mode where I don&#39;t do xattr remapping and=
 try<br>
&gt; to set /proc/pid/attr/fscreate with the context I want to set. It will=
<br>
&gt; set security.selinux xattr on host.<br>
&gt; <br>
&gt; But write to /proc/pid/attr/fscreate fails if host does not recognize<=
br>
&gt; the label sent by guest. I am running virtiofsd with unconfined_t but<=
br>
&gt; it still fails because guest is trying to create a file with<br>
&gt; &quot;test_filesystem_filetranscon_t&quot; and host does not recognize=
 this<br>
&gt; label. Seeing following in audit logs.<br>
&gt; <br>
&gt; type=3DSELINUX_ERR msg=3Daudit(1644268262.666:8111): op=3Dfscreate inv=
alid_context=3D&quot;unconfined_u:object_r:test_filesystem_filetranscon_t:s=
0&quot;<br>
<br>
Yes, that&#39;s to be expected if the host policy doesn&#39;t know about th=
e<br>
label that the guest is using.<br>
<br>
IOW, non-mapping case is only useful if you have a very good match<br>
between host + guest OS policy. This could be useful for an app<br>
like Kata because their guest is not a full OS, it is something<br>
special purpose and tightly controlled.<br>
<br>
&gt; So if we don&#39;t remap xattrs and host has SELinux enabled, then it =
probably<br>
&gt; work in very limited circumstances where host and guest policies don&#=
39;t<br>
&gt; conflict. I guess its like running fedora 34 guest on fedora 34 host. =
<br>
&gt; I suspect that this will see very limited use. Though I have put the<b=
r>
&gt; code in for the sake of completeness.<br>
<br>
For general purpose guest OS virtualization remapping is going to be<br>
effectuively mandatory.=C2=A0 The non-mapped case only usable when you tigh=
tly<br>
control the guest OS packages from the host.<br clear=3D"all"></blockquote>=
</div><div><br></div><div><br></div><div>If remap is recommended, why not m=
ake it mandatory or automatic?,</div><div>for instance, &#39;-o security_la=
bel&#39; either requires &#39;-o xattrmap=3D&#39; or automatically makes</d=
iv><div> the mapping with the &#39;trusted&#39; prefix, while=C2=A0 &#39;-o=
 security_label=3Dnomap&#39; doesn&#39;t, so you</div><div> can choose what=
ever you want.<br></div><div><br></div><div>(I&#39;m not suggesting the &#3=
9;nomap&#39; name, I&#39;m terrible choosing names)<br></div><div><br></div=
>-- <br><div dir=3D"ltr"><div dir=3D"ltr">German<br></div></div></div>

--0000000000004ffcb505d7933fd3--

