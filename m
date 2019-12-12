In-Reply-To: <20191212185900.GE4282@work-vm>
From: "Gong Su" <gongsu@us.ibm.com>
Date: Thu, 12 Dec 2019 14:10:32 -0500
References: <OFEFF035BA.8C1142AF-ON002584CE.006405E7-852584CE.0067F3AB@notes.na.collabserv.com>
	<20191212185900.GE4282@work-vm>
Message-Id: <OFBB122325.E2F3CC73-ON002584CE.006880E8-852584CE.006955C9@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: multipart/related; 
	Boundary="0__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678"
Subject: Re: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, imammedo@redhat.com, Cornelia Huck <cohuck@redhat.com>

--0__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678
Content-type: multipart/alternative; 
	Boundary="1__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678"

--1__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=WINDOWS-1252


Thanks Dave. That was quick!

Igor, any idea when this will happen? :-)



From:=09"Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:=09Gong Su <gongsu@us.ibm.com>
Cc:=09virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>
Date:=0912/12/2019 01:59 PM
Subject:=09[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)



* Gong Su (gongsu@us.ibm.com) wrote:
>
>
> Hi Stefan, I'm resending my questions to the list per your request.
>
> Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
> Following the instructions on
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_howto-2Dqemu.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcS=
zS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q=
_7M&s=3DpkvbWd3P-tWRpKPww5iwoPHLE_HnkenEEJhywABpRuc&e=3D
  I
> was able to compile all the pieces but when I tried to run qemu I
realized
> that it needs -numa option which isn't supported on s390x yet.
>
> I have talked to Christian Borntraeger (whom I worked with on other
> projects before) and he indicated that he had a plan to add -numa support
> for s390x but currently is busy on other things.
>
> So I'm trying to see if there are other ways for me to go forward without
> having to wait for Christian. I see two options:
>
> 1. Merge virtiofsd into qemu itself. In the "Interchangeability" section
of
> the virtio-fs design page (
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_design.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcSzS0GcR=
EznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=
=3D2VrG3dsgZcdW8uO6ZBiGtRgNp4X1z3d8TMXnUdHhfCc&e=3D
 ), it
> mentioned that "It is also possible to forego vhost-user and emulate the
> virtio-fs device directly inside the hypervisor, although this may result
> in poor isolation and security." Since each guest typically gets its own
> qemu process, maybe this is acceptable for some use cases. In exchange,
you
> get the benefit of not having to carve out a chunk of memory
from /dev/shm
> (and maybe simpler communication between virtiofsd and qemu).
> 2. Use something other than -numa to share memory between virtiofsd and
> qemu that's supported on zLinux. I'm not entirely familiar with qemu so I
> have no idea whether this is possible or not.

Hi,
  My understanding is that Igor Mammedov (imammedo@redhat.com) has plans
to allow 'shared' to be set on main memory, so we wouldn't need the numa
code.

Dave

> Thanks.

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_mailm=
an_listinfo_virtio-2Dfs&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgE=
PUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6=
Qb5Q_7M&s=3DO41fLQGJCOR0-Aj2Y4nziy3aTYTOCzaH8Lahe7xhBK8&e=3D


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK





--1__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678
Content-type: text/html; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 9 URL's were un-rewritten

<html><body><p><font size=3D"2">Thanks Dave. That was quick!</font><br><br>=
<font size=3D"2">Igor, any idea when this will happen? :-)</font><br><br><i=
mg width=3D"16" height=3D"16" src=3D"cid:1__=3D8FBB0E5DDFFB06788f9e8a93df93=
8690918c8FB@" border=3D"0" alt=3D"Inactive hide details for &quot;Dr. David=
 Alan Gilbert&quot; ---12/12/2019 01:59:15 PM---* Gong Su (gongsu@us.ibm.co=
m) wrote: &gt;"><font size=3D"2" color=3D"#424282">&quot;Dr. David Alan Gil=
bert&quot; ---12/12/2019 01:59:15 PM---* Gong Su (gongsu@us.ibm.com) wrote:=
 &gt;</font><br><br><font size=3D"2" color=3D"#5F5F5F">From:        </font>=
<font size=3D"2">&quot;Dr. David Alan Gilbert&quot; &lt;dgilbert@redhat.com=
&gt;</font><br><font size=3D"2" color=3D"#5F5F5F">To:        </font><font s=
ize=3D"2">Gong Su &lt;gongsu@us.ibm.com&gt;</font><br><font size=3D"2" colo=
r=3D"#5F5F5F">Cc:        </font><font size=3D"2">virtio-fs@redhat.com, Corn=
elia Huck &lt;cohuck@redhat.com&gt;</font><br><font size=3D"2" color=3D"#5F=
5F5F">Date:        </font><font size=3D"2">12/12/2019 01:59 PM</font><br><f=
ont size=3D"2" color=3D"#5F5F5F">Subject:        </font><font size=3D"2">[E=
XTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)</font><br><hr width=3D=
"100%" size=3D"2" align=3D"left" noshade style=3D"color:#8091A5; "><br><br>=
<br><tt><font size=3D"2">* Gong Su (gongsu@us.ibm.com) wrote:<br>&gt; <br>&=
gt; <br>&gt; Hi Stefan, I'm resending my questions to the list per your req=
uest.<br>&gt; <br>&gt; Basically, I'm trying to see if I can get virtio-fs =
to work on zLinux.<br>&gt; Following the instructions on </font></tt><tt><f=
ont size=3D"2"><a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html">http=
s://virtio-fs.gitlab.io/howto-qemu.html</a></font></tt><tt><font size=3D"2"=
>&nbsp; I<br>&gt; was able to compile all the pieces but when I tried to ru=
n qemu I realized<br>&gt; that it needs -numa option which isn't supported =
on s390x yet.<br>&gt; <br>&gt; I have talked to Christian Borntraeger (whom=
 I worked with on other<br>&gt; projects before) and he indicated that he h=
ad a plan to add -numa support<br>&gt; for s390x but currently is busy on o=
ther things.<br>&gt; <br>&gt; So I'm trying to see if there are other ways =
for me to go forward without<br>&gt; having to wait for Christian. I see tw=
o options:<br>&gt; <br>&gt; 1. Merge virtiofsd into qemu itself. In the &qu=
ot;Interchangeability&quot; section of<br>&gt; the virtio-fs design page (<=
/font></tt><tt><font size=3D"2"><a href=3D"https://virtio-fs.gitlab.io/desi=
gn.html">https://virtio-fs.gitlab.io/design.html</a></font></tt><tt><font s=
ize=3D"2">&nbsp;), it<br>&gt; mentioned that &quot;It is also possible to f=
orego vhost-user and emulate the<br>&gt; virtio-fs device directly inside t=
he hypervisor, although this may result<br>&gt; in poor isolation and secur=
ity.&quot; Since each guest typically gets its own<br>&gt; qemu process, ma=
ybe this is acceptable for some use cases. In exchange, you<br>&gt; get the=
 benefit of not having to carve out a chunk of memory from /dev/shm<br>&gt;=
 (and maybe simpler communication between virtiofsd and qemu).<br>&gt; 2. U=
se something other than -numa to share memory between virtiofsd and<br>&gt;=
 qemu that's supported on zLinux. I'm not entirely familiar with qemu so I<=
br>&gt; have no idea whether this is possible or not.<br><br>Hi,<br> &nbsp;=
My understanding is that Igor Mammedov (imammedo@redhat.com) has plans<br>t=
o allow 'shared' to be set on main memory, so we wouldn't need the numa<br>=
code.<br><br>Dave<br><br>&gt; Thanks.<br><br>&gt; _________________________=
______________________<br>&gt; Virtio-fs mailing list<br>&gt; Virtio-fs@red=
hat.com<br>&gt; </font></tt><tt><font size=3D"2"><a href=3D"https://www.red=
hat.com/mailman/listinfo/virtio-fs">https://www.redhat.com/mailman/listinfo=
/virtio-fs</a></font></tt><tt><font size=3D"2">&nbsp;<br><br>--<br>Dr. Davi=
d Alan Gilbert / dgilbert@redhat.com / Manchester, UK<br><br><br></font></t=
t><br><br><BR>
</body></html>

--1__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678--

--0__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678
Content-type: image/gif; 
	name="graycol.gif"
Content-Disposition: inline; filename="graycol.gif"
Content-ID: <1__=8FBB0E5DDFFB06788f9e8a93df938690918c8FB@>
Content-Transfer-Encoding: base64

R0lGODlhEAAQAKECAMzMzAAAAP///wAAACH5BAEAAAIALAAAAAAQABAAAAIXlI+py+0PopwxUbpu
ZRfKZ2zgSJbmSRYAIf4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7
--0__=8FBB0E5DDFFB06788f9e8a93df938690918c8FBB0E5DDFFB0678--

