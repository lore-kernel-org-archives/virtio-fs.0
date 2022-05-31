Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIi2EGnDNZNox4NtnyaH4vBbkYzcm0lmHCcO8hNlSPU=;
 b=oYe8xRsA0odN1frwqzzJFffY85mMEjx519wRLSwFUtjt2/WQ4c2pxd/6WXiDdFYXj5csrpx6qR/bsEhjEoC7ZGzwSSYk4+pfncztA4F3oBayzqm4IFj9pE916+XUoE+oFhDmAL4b8iurZt8JGS+MhGB5wDKJOh4P+6HY77+/lakUNW4EBEgNg86XuXlQHF9ULaiP79W/JSn+CA6EJeoV63MfrdX9HpAO9rhm4/2abfH9PNgplOIFTc1VgYDnf1Bah8QJM2eoV/XO/Fam9UpPTgW+np38Hahp+cM7EcSDIZt1mzYLx9djBUrpikL4zuLgk+1/dN3ZRgEfxVsPWFY4PQ==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Tue, 31 May 2022 22:25:12 +0000
Message-ID: <BY5PR14MB3893602BAEFA362A5C62485386DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
 <20220526080646.vsfmqgxyiglhe64r@mhamilton> <YpVBKsogLU8/5kiV@redhat.com>
In-Reply-To: <YpVBKsogLU8/5kiV@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB3893602BAEFA362A5C62485386DC9BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Sergio Lopez <slp@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB3893602BAEFA362A5C62485386DC9BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you so much Vivek. I enabled the trace in the code itself and ran it.=
 The only message I got was InvalidParam message below. I did not get any o=
ther message.  We are going to try changing the structure [VhostUserMemRegM=
sg]  padding to see if that fixes the problem. Is there anything else we sh=
ould try?
________________________________
From: Vivek Goyal <vgoyal@redhat.com>
Sent: Monday, May 30, 2022 10:11 PM
To: Sergio Lopez <slp@redhat.com>; Prashant Dewan <linux_learner@outlook.co=
m>
Cc: Stefan Hajnoczi <stefanha@redhat.com>; virtio-fs@redhat.com <virtio-fs@=
redhat.com>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed

On Thu, May 26, 2022 at 10:06:46AM +0200, Sergio Lopez wrote:
> On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan Hajnoczi wrote:
> > On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:
> > > Hello Stefan,
> > >
> > > Here is the output from virtofsd..
> > >
> > > ------------------------------------
> > > - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-=
26 04:41:57 UTC. --
> > > May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user de=
vice daemon.<<Placeholder: run this daemon as non-privileged user>>.
> > > May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO =
 virtiofsd] Waiting for vhost-user socket connection...
> > > May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T0=
4:27:11Z INFO  virtiofsd] Client connected, servicing requests
> > > May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T0=
4:27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidP=
aram)

So looks like following gave error message. There is no error messsage
from the actual thread which failed. This is just the main thread
waiting.

    if let Err(e) =3D daemon.wait() {
        match e {
            HandleRequest(PartialMessage) =3D> info!("Client disconnected, =
shutting down"),
            _ =3D> error!("Waiting for daemon failed: {:?}", e),
        }
    }

I can't find "InvalidParam" in rust virtiofsd code. Does that mean,
that this error is being returned by one of the crates we are using.

Prashant, you could try running rust virtiofsd with option "-d" to enable
debug messages and that might show something interesting.

Also, if you are able to reproduce the problem all the time, I think
you can start virtiofsd under gdb and see where exactly is it failing.

Thanks
Vivek

> >
> > virtiofsd terminated. I have CCed Sergio and German, who may have
> > suggestions about what to check next.
>
> Hi,
>
> Could you please tell us which QEMU version are you running, and paste
> here the its command line?
>
> Thanks,
> Sergio.



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistm=
an.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;data=3D05%7C01%7C%7Cc4d5=
792347234799874008da42896937%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C6=
37895455186641964%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM=
zIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3Dox5y7KH0Djioo=
IeJ367DZiexKQutIouWSCi5OLld%2BNY%3D&amp;reserved=3D0


--_000_BY5PR14MB3893602BAEFA362A5C62485386DC9BY5PR14MB3893namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Thank you&nbsp;so much Vivek. I enabled the trace in the code itself and ra=
n it. The only message I got was InvalidParam message below. I did not get =
any other message.&nbsp; We are going to try changing the structure [<span =
style=3D"color:rgb(32, 31, 30);font-family:&quot;Segoe UI&quot;, &quot;Sego=
e UI Web (West European)&quot;, &quot;Segoe UI&quot;, -apple-system, BlinkM=
acSystemFont, Roboto, &quot;Helvetica Neue&quot;, sans-serif;font-size:14.6=
667px;background-color:rgb(255, 255, 255);display:inline !important">VhostU=
serMemRegMsg]<span>&nbsp;</span></span>
 padding to see if that fixes the problem. Is there anything else we should=
 try?&nbsp;</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Vivek Goyal &lt;vgoya=
l@redhat.com&gt;<br>
<b>Sent:</b> Monday, May 30, 2022 10:11 PM<br>
<b>To:</b> Sergio Lopez &lt;slp@redhat.com&gt;; Prashant Dewan &lt;linux_le=
arner@outlook.com&gt;<br>
<b>Cc:</b> Stefan Hajnoczi &lt;stefanha@redhat.com&gt;; virtio-fs@redhat.co=
m &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] vhost_set_vring_kick failed</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Thu, May 26, 2022 at 10:06:46AM +0200, Sergio L=
opez wrote:<br>
&gt; On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan Hajnoczi wrote:<br>
&gt; &gt; On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:<b=
r>
&gt; &gt; &gt; Hello Stefan,<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; Here is the output from virtofsd..<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; ------------------------------------<br>
&gt; &gt; &gt; - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu=
 2022-05-26 04:41:57 UTC. --<br>
&gt; &gt; &gt; May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhos=
t-user device daemon.&lt;&lt;Placeholder: run this daemon as non-privileged=
 user&gt;&gt;.<br>
&gt; &gt; &gt; May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:=
13Z INFO&nbsp; virtiofsd] Waiting for vhost-user socket connection...<br>
&gt; &gt; &gt; May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [202=
2-05-26T04:27:11Z INFO&nbsp; virtiofsd] Client connected, servicing request=
s<br>
&gt; &gt; &gt; May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [202=
2-05-26T04:27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest=
(InvalidParam)<br>
<br>
So looks like following gave error message. There is no error messsage<br>
from the actual thread which failed. This is just the main thread<br>
waiting.<br>
<br>
&nbsp;&nbsp;&nbsp; if let Err(e) =3D daemon.wait() {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; match e {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HandleRe=
quest(PartialMessage) =3D&gt; info!(&quot;Client disconnected, shutting dow=
n&quot;),<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _ =3D&gt=
; error!(&quot;Waiting for daemon failed: {:?}&quot;, e),<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; }<br>
<br>
I can't find &quot;InvalidParam&quot; in rust virtiofsd code. Does that mea=
n,<br>
that this error is being returned by one of the crates we are using.<br>
<br>
Prashant, you could try running rust virtiofsd with option &quot;-d&quot; t=
o enable<br>
debug messages and that might show something interesting.<br>
<br>
Also, if you are able to reproduce the problem all the time, I think<br>
you can start virtiofsd under gdb and see where exactly is it failing.<br>
<br>
Thanks<br>
Vivek<br>
<br>
&gt; &gt; <br>
&gt; &gt; virtiofsd terminated. I have CCed Sergio and German, who may have=
<br>
&gt; &gt; suggestions about what to check next.<br>
&gt; <br>
&gt; Hi,<br>
&gt; <br>
&gt; Could you please tell us which QEMU version are you running, and paste=
<br>
&gt; here the its command line?<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Sergio.<br>
<br>
<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; Virtio-fs@redhat.com<br>
&gt; <a href=3D"https://nam12.safelinks.protection.outlook.com/?url=3Dhttps=
%3A%2F%2Flistman.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;amp;data=
=3D05%7C01%7C%7Cc4d5792347234799874008da42896937%7C84df9e7fe9f640afb435aaaa=
aaaaaaaa%7C1%7C0%7C637895455186641964%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL=
jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;a=
mp;sdata=3Dox5y7KH0DjiooIeJ367DZiexKQutIouWSCi5OLld%2BNY%3D&amp;amp;reserve=
d=3D0">
https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistman=
.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;amp;data=3D05%7C01%7C%7Cc4=
d5792347234799874008da42896937%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7=
C637895455186641964%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l=
uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;amp;sdata=3Dox5y7KH=
0DjiooIeJ367DZiexKQutIouWSCi5OLld%2BNY%3D&amp;amp;reserved=3D0</a><br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_BY5PR14MB3893602BAEFA362A5C62485386DC9BY5PR14MB3893namp_--

