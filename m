Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bR+QsZxUK+r8idZNfvoAxVw7628EdiEVCLzuj2MO+fY=;
 b=thbs6Am/DYTlHNafElVuqJ9o8yjjhSP7RgMqDDsKPo+o9AMVV4tKf2aLWxcwMh0mpYuJXSb5wC52Z7fzD8HbVXWJMGVDGsA13GYfgQcAzZVszSHlNupFn5r1DM/+3K9o7ENU5gv2kZRZtTyz8S+qeA8pny5oHfkzCBQOfVb4t0W2GluZCakcjMqyVF75ltTYyeE2NO/yqmRyxvhJY3ediqpr/vf9TokB6jEnZiEvxkXz7W1QrtpE+B79hcjB30OCJEcXT6rwI41kjQlLqE//ClRlk11gUsJZVmMsB/+tRcyeVPDxALa87b92ZoJNZ4ov226syr0dhs46L9fkbi4l7g==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Fri, 19 Aug 2022 06:40:22 +0000
Message-ID: <BY5PR14MB389379520B42AD44BFF1E29C866C9@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Ys1rH9Mn6fKh35p7@redhat.com>
 <BY5PR14MB3893F904F74C93FF851811D686869@BY5PR14MB3893.namprd14.prod.outlook.com>
In-Reply-To: <BY5PR14MB3893F904F74C93FF851811D686869@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/related;
 boundary="_004_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_";
 type="multipart/alternative"
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_004_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_"

--_000_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

Hi Vivek,

I was able to map multiple UIDs/GIDs from virtiofsd to outside by doing the=
 following =96


  1.  Executed virtiofs as a new user (virtiofs)
  2.  Enabled  --sandbox namespace
  3.  Disabled the call to setup_id_mappings inside virtiofsd sandbox
  4.  Setup a range for UIDs/GIDs in the namespace in /etc/subuid and /etc/=
subgid
  5.  Wrote the id_map for virtiofs sandbox (new namespace) using newidmap =
utiity from commandline with root permissions

I had to do 3 (disable the call to setup_id_mappings inside virtiofsd sandb=
ox) since the id_map can be only written once (enforced by the kernel). Whe=
n we tried to add the mappings in the setup_id_mappings call that did not w=
ork since the kernel checks for any mapping outside the namespace and rejec=
ts it unless it is coming from a root user.

Will it be useful if we could make a command line parameter that makes he c=
all to setup_id_mappings optional? The assumption would be that the user wi=
ll make these mappings outside of virtiofsd using newidmap tool.

Thanks
Prashant


Sent from Mail<https://go.microsoft.com/fwlink/?LinkId=3D550986> for Window=
s

From: Pra.. Dew..<mailto:linux_learner@outlook.com>
Sent: Tuesday, July 12, 2022 4:14 PM
To: Vivek Goyal<mailto:vgoyal@redhat.com>
Cc: virtio-fs@redhat.com<mailto:virtio-fs@redhat.com>
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host

Thank you so much!!! We are using the Rust version now. I will try out the =
suggestions below. Thanks for the guidance.

From: Vivek Goyal <vgoyal@redhat.com>
Sent: Tuesday, July 12, 2022 12:37 PM
To: Pra.. Dew.. <linux_learner@outlook.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host

On Fri, Jul 08, 2022 at 08:18:19PM +0000, Pra.. Dew.. wrote:
> We have been able to setup virtiofs between guest and host (QEMU 6.2/Linu=
x 5.15). We run virtiofsd as a non-root user in the host. We did not want t=
o run it as a root user in order to minimize the attack surface. We run it =
as a virtiofs user. When we create a file in the shared folder, the permiss=
ion of the file is virtiofs user and virtiofs group. When we read that file=
 from the guest it shows virtiofs user (only the uid) and nobody group. The=
 goal is to restrict the access of the file to a few services in the guest =
(not give access to all services). We tried to create a group in the guest =
and tried to move the file in the new group. However chown gives "bad descr=
iptor." Is there a better way of doing this? Any input is really appreciate=
d. Thank you so much!

Hi,

Are you using C version of virtiofsd (from qemu) or rust version of
virtiofsd found here.

https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitlab.=
com%2Fvirtio-fs%2Fvirtiofsd&amp;data=3D05%7C01%7C%7C66056c4b61b0405d2a7008d=
a640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932262768755509%7=
CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi=
LCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DVFeOhTiZfwYU5QK4XNjRx%2F3WqfDyiI=
60v%2FV1x9UJD%2BU%3D&amp;reserved=3D0<https://nam12.safelinks.protection.ou=
tlook.com/?url=3Dhttps%3A%2F%2Fgitlab.com%2Fvirtio-fs%2Fvirtiofsd&data=3D05=
%7C01%7C%7C3d9cbe944a2b4857787308da645c53a1%7C84df9e7fe9f640afb435aaaaaaaaa=
aaa%7C1%7C0%7C637932644970283564%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD=
AiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D8S=
nXegzp66wvw3Wi%2FXZ8j%2Fw1BzVmeed6Nv6vouQ%2BzWY%3D&reserved=3D0>

I would recommend using rust version of virtiofsd now and as German
suggested in another email, let unprivileged user launch a user namespace
and run virtiofsd inside that. That should allow you to do arbitrary
uid/gid switching inside guest.

Thanks
Vivek

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistm=
an.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;data=3D05%7C01%7C%7C6605=
6c4b61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C6=
37932262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM=
zIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3Dq%2FAbKkN3lnM=
CLaOo8bO6ZCpjxes%2BJcvTnqY7y3JFFa0%3D&amp;reserved=3D0<https://nam12.safeli=
nks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistman.redhat.com%2Fmailma=
n%2Flistinfo%2Fvirtio-fs&data=3D05%7C01%7C%7C3d9cbe944a2b4857787308da645c53=
a1%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932644970283564%7CUnknow=
n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI=
6Mn0%3D%7C3000%7C%7C%7C&sdata=3DEeP3iCctKyIXttDv%2BwvtgG3MzMepqXWp0Vu2hmJ%2=
BlbQ%3D&reserved=3D0>


--_000_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
=09{mso-style-priority:34;
=09margin-top:0in;
=09margin-right:0in;
=09margin-bottom:0in;
=09margin-left:.5in;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
.MsoChpDefault
=09{mso-style-type:export-only;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
/* List Definitions */
@list l0
=09{mso-list-id:1901406205;
=09mso-list-type:hybrid;
=09mso-list-template-ids:-1418153794 -1 67698713 67698715 67698703 67698713=
 67698715 67698703 67698713 67698715;}
@list l0:level1
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level2
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level3
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l0:level4
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level5
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level6
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l0:level7
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level8
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level9
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
ol
=09{margin-bottom:0in;}
ul
=09{margin-bottom:0in;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"#954F72" style=3D"word-wrap:bre=
ak-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi Vivek,</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I was able to map multiple UIDs/GIDs from virtiofsd =
to outside by doing the following =96</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<ol style=3D"margin-top:0in" start=3D"1" type=3D"1">
<li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 =
lfo1">Executed virtiofs as a new user (virtiofs)</li><li class=3D"MsoListPa=
ragraph" style=3D"margin-left:0in;mso-list:l0 level1 lfo1">Enabled &nbsp;--=
sandbox namespace</li><li class=3D"MsoListParagraph" style=3D"margin-left:0=
in;mso-list:l0 level1 lfo1">Disabled the call to
<i>setup_id_mappings</i> inside virtiofsd sandbox<o:p></o:p></li><li class=
=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 lfo1">Set=
up a range for UIDs/GIDs in the namespace in /etc/subuid and /etc/subgid</l=
i><li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level=
1 lfo1">Wrote the id_map for virtiofs sandbox (new namespace) using newidma=
p utiity from commandline with root permissions</li></ol>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b>I had to do 3 (disable the call to setup_id_mappi=
ngs inside virtiofsd sandbox) since the id_map can be only written once (en=
forced by the kernel).
</b>When we tried to add the mappings in the setup_id_mappings call that di=
d not work since the kernel checks for any mapping outside the namespace an=
d rejects it unless it is coming from a root user.</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Will it be useful if we could make a command line pa=
rameter that makes he call to setup_id_mappings optional? The assumption wo=
uld be that the user will make these mappings outside of virtiofsd using ne=
widmap tool.
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks</p>
<p class=3D"MsoNormal">Prashant</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b><o:p>&nbsp;</o:p></b></p>
<p class=3D"MsoNormal">Sent from <a href=3D"https://go.microsoft.com/fwlink=
/?LinkId=3D550986">
Mail</a> for Windows</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div style=3D"mso-element:para-border-div;border:none;border-top:solid #E1E=
1E1 1.0pt;padding:3.0pt 0in 0in 0in">
<p class=3D"MsoNormal" style=3D"border:none;padding:0in"><b>From: </b><a hr=
ef=3D"mailto:linux_learner@outlook.com">Pra.. Dew..</a><br>
<b>Sent: </b>Tuesday, July 12, 2022 4:14 PM<br>
<b>To: </b><a href=3D"mailto:vgoyal@redhat.com">Vivek Goyal</a><br>
<b>Cc: </b><a href=3D"mailto:virtio-fs@redhat.com">virtio-fs@redhat.com</a>=
<br>
<b>Subject: </b>Re: [Virtio-fs] Ownership of a file shared between guest an=
d host</p>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;color:black">Thank y=
ou&nbsp;so much!!! We are using the Rust version now. I will try out the su=
ggestions below. Thanks for the guidance.<o:p></o:p></span></p>
</div>
<p class=3D"MsoNormal"><img border=3D"0" width=3D"282" height=3D"1" style=
=3D"width:2.9416in;height:.0125in" id=3D"Horizontal_x0020_Line_x0020_1" src=
=3D"cid:image001.png@01D8B35B.E1147600"><o:p></o:p></p>
<div id=3D"divRplyFwdMsg">
<p class=3D"MsoNormal"><b><span style=3D"color:black">From:</span></b><span=
 style=3D"color:black"> Vivek Goyal &lt;vgoyal@redhat.com&gt;<br>
<b>Sent:</b> Tuesday, July 12, 2022 12:37 PM<br>
<b>To:</b> Pra.. Dew.. &lt;linux_learner@outlook.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] Ownership of a file shared between guest an=
d host</span>
<o:p></o:p></p>
<div>
<p class=3D"MsoNormal">&nbsp;<o:p></o:p></p>
</div>
</div>
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt">On Fri, Jul 08, 2022 =
at 08:18:19PM +0000, Pra.. Dew.. wrote:<br>
&gt; We have been able to setup virtiofs between guest and host (QEMU 6.2/L=
inux 5.15). We run virtiofsd as a non-root user in the host. We did not wan=
t to run it as a root user in order to minimize the attack surface. We run =
it as a virtiofs user. When we create
 a file in the shared folder, the permission of the file is virtiofs user a=
nd virtiofs group. When we read that file from the guest it shows virtiofs =
user (only the uid) and nobody group. The goal is to restrict the access of=
 the file to a few services in the
 guest (not give access to all services). We tried to create a group in the=
 guest and tried to move the file in the new group. However chown gives &qu=
ot;bad descriptor.&quot; Is there a better way of doing this? Any input is =
really appreciated. Thank you so much!<br>
<br>
Hi,<br>
<br>
Are you using C version of virtiofsd (from qemu) or rust version of<br>
virtiofsd found here.<br>
<br>
<a href=3D"https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2=
F%2Fgitlab.com%2Fvirtio-fs%2Fvirtiofsd&amp;data=3D05%7C01%7C%7C3d9cbe944a2b=
4857787308da645c53a1%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932644=
970283564%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBT=
iI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D8SnXegzp66wvw3Wi%2FXZ=
8j%2Fw1BzVmeed6Nv6vouQ%2BzWY%3D&amp;reserved=3D0">https://nam12.safelinks.p=
rotection.outlook.com/?url=3Dhttps%3A%2F%2Fgitlab.com%2Fvirtio-fs%2Fvirtiof=
sd&amp;amp;data=3D05%7C01%7C%7C66056c4b61b0405d2a7008da640357c8%7C84df9e7fe=
9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932262768755509%7CUnknown%7CTWFpbGZsb3=
d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000=
%7C%7C%7C&amp;amp;sdata=3DVFeOhTiZfwYU5QK4XNjRx%2F3WqfDyiI60v%2FV1x9UJD%2BU=
%3D&amp;amp;reserved=3D0</a><br>
<br>
I would recommend using rust version of virtiofsd now and as German<br>
suggested in another email, let unprivileged user launch a user namespace<b=
r>
and run virtiofsd inside that. That should allow you to do arbitrary<br>
uid/gid switching inside guest.<br>
<br>
Thanks<br>
Vivek<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; Virtio-fs@redhat.com<br>
&gt; <a href=3D"https://nam12.safelinks.protection.outlook.com/?url=3Dhttps=
%3A%2F%2Flistman.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;data=3D05%=
7C01%7C%7C3d9cbe944a2b4857787308da645c53a1%7C84df9e7fe9f640afb435aaaaaaaaaa=
aa%7C1%7C0%7C637932644970283564%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDA=
iLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=
=3DEeP3iCctKyIXttDv%2BwvtgG3MzMepqXWp0Vu2hmJ%2BlbQ%3D&amp;reserved=3D0">
https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistman=
.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;amp;data=3D05%7C01%7C%7C66=
056c4b61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7=
C637932262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l=
uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;amp;sdata=3Dq%2FAbK=
kN3lnMCLaOo8bO6ZCpjxes%2BJcvTnqY7y3JFFa0%3D&amp;amp;reserved=3D0</a><o:p></=
o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_--

--_004_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_
Content-Type: image/png; name="A2F48238F66E49458DEB42C5C515153F.png"
Content-Description: A2F48238F66E49458DEB42C5C515153F.png
Content-Disposition: inline; filename="A2F48238F66E49458DEB42C5C515153F.png";
	size=155; creation-date="Fri, 19 Aug 2022 06:40:21 GMT";
	modification-date="Fri, 19 Aug 2022 06:40:21 GMT"
Content-ID: <image001.png@01D8B35B.E1147600>
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAAsIAAAADCAYAAACZOWnhAAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAwSURBVGhD7dYBEQAwCAMxpM8Z0jaGjaZ3qYav
2QUAgEB7PQ4AAIT4/SuEAQBIU/0AJceDhMrB3v0AAAAASUVORK5CYII=
--_004_BY5PR14MB389379520B42AD44BFF1E29C866C9BY5PR14MB3893namp_--

