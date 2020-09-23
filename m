DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
	s=selector2-intel-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=hhqtfHB6JrNgAIBF1vFBQCIfu39yMEp89kM+oht6Yag=;
	b=wqFKk6uGDNRlN3722KrnZkq1fL7AwIkafX9eAH8j/T7TDKU+r2zHgsNPx8TOkbAa6fIb9xrP6KfIRVYD5WdJjPVTEn8EcOWMgREm4Ke3FhMIFNEAM0lxOL7VO+TJrBRtZpS9z18SpdxNG3dJB5S5QDCD2vIaIfj46QQuDjIQvpM=
From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Wed, 23 Sep 2020 06:30:32 +0000
Message-ID: <SN6PR11MB29435D8F16B579FB717FE1E5EA380@SN6PR11MB2943.namprd11.prod.outlook.com>
References: <bd4b7ab761dcb47f3b6ebf7fc065f5040a314056.camel@intel.com>,
	<20200922181635.GE57620@redhat.com>
In-Reply-To: <20200922181635.GE57620@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="_000_SN6PR11MB29435D8F16B579FB717FE1E5EA380SN6PR11MB2943namp_"
Content-Language: en-US
Subject: Re: [Virtio-fs] Branch with patches on top of Linux 5.9-rcX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_SN6PR11MB29435D8F16B579FB717FE1E5EA380SN6PR11MB2943namp_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

That's great! Thanks Vivek :)

Sebastien
________________________________
From: Vivek Goyal <vgoyal@redhat.com>
Sent: Tuesday, September 22, 2020 8:16 PM
To: Boeuf, Sebastien <sebastien.boeuf@intel.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
Subject: Re: Branch with patches on top of Linux 5.9-rcX

On Tue, Sep 22, 2020 at 09:10:27AM +0000, Boeuf, Sebastien wrote:
> Hi,
>
> I was wondering if you had a branch ready with the virtio-fs patches
> rebased on top 5.9-rcX?
>

Hi Sebastien,

I am waiting for DAX patches to be merged in 5.10 and then you can
pull from upstream directly.

In the meantime, everything is in Miklos's tree and you should be able
to pull from there as well.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=3D=
for-next

Is there still a need for me to take patches from Miklos's tree and
push on virtiof-fs-dev?

Vivek


> Thanks,
> Sebastien
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris,
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris,=20
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_000_SN6PR11MB29435D8F16B579FB717FE1E5EA380SN6PR11MB2943namp_
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
That's great! Thanks Vivek :)</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Sebastien<br>
</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Vivek Goyal &lt;vgoya=
l@redhat.com&gt;<br>
<b>Sent:</b> Tuesday, September 22, 2020 8:16 PM<br>
<b>To:</b> Boeuf, Sebastien &lt;sebastien.boeuf@intel.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: Branch with patches on top of Linux 5.9-rcX</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Tue, Sep 22, 2020 at 09:10:27AM +0000, Boeuf, S=
ebastien wrote:<br>
&gt; Hi,<br>
&gt; <br>
&gt; I was wondering if you had a branch ready with the virtio-fs patches<b=
r>
&gt; rebased on top 5.9-rcX?<br>
&gt; <br>
<br>
Hi Sebastien,<br>
<br>
I am waiting for DAX patches to be merged in 5.10 and then you can<br>
pull from upstream directly.<br>
<br>
In the meantime, everything is in Miklos's tree and you should be able<br>
to pull from there as well.<br>
<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.gi=
t/log/?h=3Dfor-next">https://git.kernel.org/pub/scm/linux/kernel/git/mszere=
di/fuse.git/log/?h=3Dfor-next</a><br>
<br>
Is there still a need for me to take patches from Miklos's tree and<br>
push on virtiof-fs-dev?<br>
<br>
Vivek<br>
<br>
<br>
&gt; Thanks,<br>
&gt; Sebastien<br>
&gt; ---------------------------------------------------------------------<=
br>
&gt; Intel Corporation SAS (French simplified joint stock company)<br>
&gt; Registered headquarters: &quot;Les Montalets&quot;- 2, rue de Paris, <=
br>
&gt; 92196 Meudon Cedex, France<br>
&gt; Registration Number:&nbsp; 302 456 199 R.C.S. NANTERRE<br>
&gt; Capital: 4,572,000 Euros<br>
&gt; <br>
&gt; This e-mail and any attachments may contain confidential material for<=
br>
&gt; the sole use of the intended recipient(s). Any review or distribution<=
br>
&gt; by others is strictly prohibited. If you are not the intended<br>
&gt; recipient, please contact the sender and delete all copies.<br>
<br>
</div>
</span></font></div>
<p>---------------------------------------------------------------------<br=
>
Intel Corporation SAS (French simplified joint stock company)<br>
Registered headquarters: "Les Montalets"- 2, rue de Paris, <br>
92196 Meudon Cedex, France<br>
Registration Number:&nbsp; 302 456 199 R.C.S. NANTERRE<br>
Capital: 4,572,000 Euros</p>

<p>This e-mail and any attachments may contain confidential material for<br=
>
the sole use of the intended recipient(s). Any review or distribution<br>
by others is strictly prohibited. If you are not the intended<br>
recipient, please contact the sender and delete all copies.</p></body>
</html>

--_000_SN6PR11MB29435D8F16B579FB717FE1E5EA380SN6PR11MB2943namp_--

