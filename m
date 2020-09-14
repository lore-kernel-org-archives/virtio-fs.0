MIME-Version: 1.0
References: <20200825155140.GA16427@stefanha-x1.localdomain>
	<CAA2ifQz5ffEGx6a+gN_S38ZiMkpcUaZwNiZBLtwsE2kmKiqjeA@mail.gmail.com>
	<20200914145936.GA629589@stefanha-x1.localdomain>
In-Reply-To: <20200914145936.GA629589@stefanha-x1.localdomain>
From: Gal Hammer <ghammer@redhat.com>
Date: Mon, 14 Sep 2020 20:54:34 +0300
Message-ID: <CAA2ifQyL4b-8FLkwocf+oPmhTthBtnG94pdJjPspukDaLCHrJg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000ca8c7d05af49ba11"
Subject: Re: [Virtio-fs] Windows drivers in Fedora virtio-win ISO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, o.popov@livelace.ru

--000000000000ca8c7d05af49ba11
Content-Type: text/plain; charset="UTF-8"

Hi Stefan,

On Mon, 14 Sep 2020 at 17:59, Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Wed, Sep 02, 2020 at 11:09:47AM +0300, Gal Hammer wrote:
> > On Tue, 25 Aug 2020 at 18:51, Stefan Hajnoczi <stefanha@redhat.com>
> wrote:
> >
> > > Hi Gal,
> > > On #virtio-fs freenode IRC it was just mentioned that the Fedora
> > > virtio-win "latest" ISO now includes virtio-fs drivers:
> > >
> > > 15:48 < livelace> It looks like virtio-win contains some virtiofs stuff
> > > 15:49 < livelace> 07/15/2020  06:22 PM            55,496 viofs.sys
> > >
> > >
> > We did a quiet launch.
> >
> >
> > > This is great news! We've had questions about the status of Windows
> > > support recently and this will help many users.
> > >
> > > Can you provide a HowTo for the virtio-fs website
> > > (https://virtio-fs.gitlab.io/) so there are instructions on installing
> > > and using the driver?
> > >
> > >
> > I can write a few lines on how to manually install it. Unless there is an
> > installer that I'm not familiar with.
>
> Thank you!
>

There's nothing to it. I submitted a merge request via virtio-fs's gitlab
site.

    Gal.


>
> Stefan
>

--000000000000ca8c7d05af49ba11
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_defa=
ult" style=3D"font-family:verdana,sans-serif">Hi Stefan,</div></div><br><di=
v class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 14 Se=
p 2020 at 17:59, Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com"=
>stefanha@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-sty=
le:solid;border-left-color:rgb(204,204,204);padding-left:1ex">On Wed, Sep 0=
2, 2020 at 11:09:47AM +0300, Gal Hammer wrote:<br>
&gt; On Tue, 25 Aug 2020 at 18:51, Stefan Hajnoczi &lt;<a href=3D"mailto:st=
efanha@redhat.com" target=3D"_blank">stefanha@redhat.com</a>&gt; wrote:<br>
&gt; <br>
&gt; &gt; Hi Gal,<br>
&gt; &gt; On #virtio-fs freenode IRC it was just mentioned that the Fedora<=
br>
&gt; &gt; virtio-win &quot;latest&quot; ISO now includes virtio-fs drivers:=
<br>
&gt; &gt;<br>
&gt; &gt; 15:48 &lt; livelace&gt; It looks like virtio-win contains some vi=
rtiofs stuff<br>
&gt; &gt; 15:49 &lt; livelace&gt; 07/15/2020=C2=A0 06:22 PM=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 55,496 viofs.sys<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; We did a quiet launch.<br>
&gt; <br>
&gt; <br>
&gt; &gt; This is great news! We&#39;ve had questions about the status of W=
indows<br>
&gt; &gt; support recently and this will help many users.<br>
&gt; &gt;<br>
&gt; &gt; Can you provide a HowTo for the virtio-fs website<br>
&gt; &gt; (<a href=3D"https://virtio-fs.gitlab.io/" rel=3D"noreferrer" targ=
et=3D"_blank">https://virtio-fs.gitlab.io/</a>) so there are instructions o=
n installing<br>
&gt; &gt; and using the driver?<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; I can write a few lines on how to manually install it. Unless there is=
 an<br>
&gt; installer that I&#39;m not familiar with.<br>
<br>
Thank you!<br></blockquote><div><br></div><div><div class=3D"gmail_default"=
 style=3D"font-family:verdana,sans-serif">There&#39;s nothing to it. I subm=
itted a merge request via virtio-fs&#39;s gitlab site.</div><div class=3D"g=
mail_default" style=3D"font-family:verdana,sans-serif"><br></div><div class=
=3D"gmail_default" style=3D"font-family:verdana,sans-serif">=C2=A0 =C2=A0 G=
al.</div></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;bord=
er-left-color:rgb(204,204,204);padding-left:1ex">
<br>
Stefan<br>
</blockquote></div></div></div>

--000000000000ca8c7d05af49ba11--

