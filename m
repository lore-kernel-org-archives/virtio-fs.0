From: "Gong Su" <gongsu@us.ibm.com>
Date: Tue, 17 Mar 2020 02:05:06 -0500
Message-Id: <OFACFEEE57.45B9F1BC-ON0025852E.0026B45E-8525852E.0026EB59@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: multipart/related; 
	Boundary="0__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE"
Subject: Re: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Igor Mammedov <imammedo@redhat.com>
Cc: virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>

--0__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE
Content-type: multipart/alternative; 
	Boundary="1__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE"

--1__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=WINDOWS-1252



Hi Igor, just wondering if there is any updates on getting the patches that
will allow shared memory without -numa (not supported on s390 yet)? Thanks.

__________________

Hi Igor, that would be great. Thanks.



From:=09Igor Mammedov <imammedo@redhat.com>
To:=09"Gong Su" <gongsu@us.ibm.com>
Cc:=09"Dr. David Alan Gilbert" <dgilbert@redhat.com>, Cornelia Huck
            <cohuck@redhat.com>, virtio-fs@redhat.com
Date:=0912/13/2019 08:17 AM
Subject:=09[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)



On Thu, 12 Dec 2019 14:10:32 -0500
"Gong Su" <gongsu@us.ibm.com> wrote:

>
> Thanks Dave. That was quick!
>
> Igor, any idea when this will happen? :-)
If you need early sneak peek, I can post common + s390 patches.


> From:=09=09 "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> To:=09=09 Gong Su <gongsu@us.ibm.com>
> Cc:=09=09 virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>
> Date:=09=09 12/12/2019 01:59 PM
> Subject:=09=09 [EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)
>
>
>
> * Gong Su (gongsu@us.ibm.com) wrote:
> >
> >
> > Hi Stefan, I'm resending my questions to the list per your request.
> >
> > Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
> > Following the instructions on
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_howto-2Dqemu.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcS=
zS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q=
_7M&s=3DpkvbWd3P-tWRpKPww5iwoPHLE_HnkenEEJhywABpRuc&e=3D

>   I
> > was able to compile all the pieces but when I tried to run qemu I
> realized
> > that it needs -numa option which isn't supported on s390x yet.
> >
> > I have talked to Christian Borntraeger (whom I worked with on other
> > projects before) and he indicated that he had a plan to add -numa
support
> > for s390x but currently is busy on other things.
> >
> > So I'm trying to see if there are other ways for me to go forward
without
> > having to wait for Christian. I see two options:
> >
> > 1. Merge virtiofsd into qemu itself. In the "Interchangeability"
section
> of
> > the virtio-fs design page (
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_design.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcSzS0GcR=
EznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=
=3D2VrG3dsgZcdW8uO6ZBiGtRgNp4X1z3d8TMXnUdHhfCc&e=3D

>  ), it
> > mentioned that "It is also possible to forego vhost-user and emulate
the
> > virtio-fs device directly inside the hypervisor, although this may
result
> > in poor isolation and security." Since each guest typically gets its
own
> > qemu process, maybe this is acceptable for some use cases. In exchange,
> you
> > get the benefit of not having to carve out a chunk of memory
> from /dev/shm
> > (and maybe simpler communication between virtiofsd and qemu).
> > 2. Use something other than -numa to share memory between virtiofsd and
> > qemu that's supported on zLinux. I'm not entirely familiar with qemu so
I
> > have no idea whether this is possible or not.
>
> Hi,
>   My understanding is that Igor Mammedov (imammedo@redhat.com) has plans
> to allow 'shared' to be set on main memory, so we wouldn't need the numa
> code.
>
> Dave
>
> > Thanks.
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> >
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_mailm=
an_listinfo_virtio-2Dfs&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgE=
PUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6=
Qb5Q_7M&s=3DO41fLQGJCOR0-Aj2Y4nziy3aTYTOCzaH8Lahe7xhBK8&e=3D

>
>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>
>
>




--1__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE
Content-type: text/html; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 9 URL's were un-rewritten

<html><body><p><font size=3D"2">Hi Igor, just wondering if there is any upd=
ates on getting the patches that will allow shared memory without -numa (no=
t supported on s390 yet)? Thanks.</font><br><br><font size=3D"2">__________=
________</font><br><br><font size=3D"2">Hi Igor, that would be great. Thank=
s.</font><br><br><img width=3D"16" height=3D"16" src=3D"cid:1__=3D8FBB0FBDD=
FB532CE8f9e8a93df938690918c8FB@" border=3D"0" alt=3D"Inactive hide details =
for Igor Mammedov ---12/13/2019 08:17:53 AM---On Thu, 12 Dec 2019 14:10:32 =
-0500 &quot;Gong Su&quot; &lt;gongsu@us.ibm"><font size=3D"2" color=3D"#424=
282">Igor Mammedov ---12/13/2019 08:17:53 AM---On Thu, 12 Dec 2019 14:10:32=
 -0500 &quot;Gong Su&quot; &lt;gongsu@us.ibm.com&gt; wrote:</font><br><br><=
font size=3D"2" color=3D"#5F5F5F">From:        </font><font size=3D"2">Igor=
 Mammedov &lt;imammedo@redhat.com&gt;</font><br><font size=3D"2" color=3D"#=
5F5F5F">To:        </font><font size=3D"2">&quot;Gong Su&quot; &lt;gongsu@u=
s.ibm.com&gt;</font><br><font size=3D"2" color=3D"#5F5F5F">Cc:        </fon=
t><font size=3D"2">&quot;Dr. David Alan Gilbert&quot; &lt;dgilbert@redhat.c=
om&gt;, Cornelia Huck &lt;cohuck@redhat.com&gt;, virtio-fs@redhat.com</font=
><br><font size=3D"2" color=3D"#5F5F5F">Date:        </font><font size=3D"2=
">12/13/2019 08:17 AM</font><br><font size=3D"2" color=3D"#5F5F5F">Subject:=
        </font><font size=3D"2">[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLi=
nux (s390x)</font><br><hr width=3D"100%" size=3D"2" align=3D"left" noshade =
style=3D"color:#8091A5; "><br><br><br><tt><font size=3D"2">On Thu, 12 Dec 2=
019 14:10:32 -0500<br>&quot;Gong Su&quot; &lt;gongsu@us.ibm.com&gt; wrote:<=
br><br>&gt; <br>&gt; Thanks Dave. That was quick!<br>&gt; <br>&gt; Igor, an=
y idea when this will happen? :-)<br>If you need early sneak peek, I can po=
st common + s390 patches.<br><br> <br>&gt; From:                 &quot;Dr. =
David Alan Gilbert&quot; &lt;dgilbert@redhat.com&gt;<br>&gt; To:           =
      Gong Su &lt;gongsu@us.ibm.com&gt;<br>&gt; Cc:                 virtio-=
fs@redhat.com, Cornelia Huck &lt;cohuck@redhat.com&gt;<br>&gt; Date:       =
          12/12/2019 01:59 PM<br>&gt; Subject:                 [EXTERNAL] R=
e: [Virtio-fs] virtio-fs on zLinux (s390x)<br>&gt; <br>&gt; <br>&gt; <br>&g=
t; * Gong Su (gongsu@us.ibm.com) wrote:<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &=
gt; Hi Stefan, I'm resending my questions to the list per your request.<br>=
&gt; &gt;<br>&gt; &gt; Basically, I'm trying to see if I can get virtio-fs =
to work on zLinux.<br>&gt; &gt; Following the instructions on<br>&gt; </fon=
t></tt><tt><font size=3D"2"><a href=3D"https://virtio-fs.gitlab.io/howto-qe=
mu.html">https://virtio-fs.gitlab.io/howto-qemu.html</a></font></tt><tt><fo=
nt size=3D"2"><br>&gt; &nbsp; I<br>&gt; &gt; was able to compile all the pi=
eces but when I tried to run qemu I<br>&gt; realized<br>&gt; &gt; that it n=
eeds -numa option which isn't supported on s390x yet.<br>&gt; &gt;<br>&gt; =
&gt; I have talked to Christian Borntraeger (whom I worked with on other<br=
>&gt; &gt; projects before) and he indicated that he had a plan to add -num=
a support<br>&gt; &gt; for s390x but currently is busy on other things.<br>=
&gt; &gt;<br>&gt; &gt; So I'm trying to see if there are other ways for me =
to go forward without<br>&gt; &gt; having to wait for Christian. I see two =
options:<br>&gt; &gt;<br>&gt; &gt; 1. Merge virtiofsd into qemu itself. In =
the &quot;Interchangeability&quot; section<br>&gt; of<br>&gt; &gt; the virt=
io-fs design page (<br>&gt; </font></tt><tt><font size=3D"2"><a href=3D"htt=
ps://virtio-fs.gitlab.io/design.html">https://virtio-fs.gitlab.io/design.ht=
ml</a></font></tt><tt><font size=3D"2"><br>&gt; &nbsp;), it<br>&gt; &gt; me=
ntioned that &quot;It is also possible to forego vhost-user and emulate the=
<br>&gt; &gt; virtio-fs device directly inside the hypervisor, although thi=
s may result<br>&gt; &gt; in poor isolation and security.&quot; Since each =
guest typically gets its own<br>&gt; &gt; qemu process, maybe this is accep=
table for some use cases. In exchange,<br>&gt; you<br>&gt; &gt; get the ben=
efit of not having to carve out a chunk of memory<br>&gt; from /dev/shm<br>=
&gt; &gt; (and maybe simpler communication between virtiofsd and qemu).<br>=
&gt; &gt; 2. Use something other than -numa to share memory between virtiof=
sd and<br>&gt; &gt; qemu that's supported on zLinux. I'm not entirely famil=
iar with qemu so I<br>&gt; &gt; have no idea whether this is possible or no=
t.<br>&gt; <br>&gt; Hi,<br>&gt; &nbsp; My understanding is that Igor Mammed=
ov (imammedo@redhat.com) has plans<br>&gt; to allow 'shared' to be set on m=
ain memory, so we wouldn't need the numa<br>&gt; code.<br>&gt; <br>&gt; Dav=
e<br>&gt; <br>&gt; &gt; Thanks.<br>&gt; <br>&gt; &gt; _____________________=
__________________________<br>&gt; &gt; Virtio-fs mailing list<br>&gt; &gt;=
 Virtio-fs@redhat.com<br>&gt; &gt;<br>&gt; </font></tt><tt><font size=3D"2"=
><a href=3D"https://www.redhat.com/mailman/listinfo/virtio-fs">https://www.=
redhat.com/mailman/listinfo/virtio-fs</a></font></tt><tt><font size=3D"2"><=
br>&gt; <br>&gt; <br>&gt; --<br>&gt; Dr. David Alan Gilbert / dgilbert@redh=
at.com / Manchester, UK<br>&gt; <br>&gt; <br>&gt; <br>&gt; <br><br></font><=
/tt><br><br><BR>
</body></html>

--1__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE--

--0__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE
Content-type: image/gif; 
	name="graycol.gif"
Content-Disposition: inline; filename="graycol.gif"
Content-ID: <1__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FB@>
Content-Transfer-Encoding: base64

R0lGODlhEAAQAKECAMzMzAAAAP///wAAACH5BAEAAAIALAAAAAAQABAAAAIXlI+py+0PopwxUbpu
ZRfKZ2zgSJbmSRYAIf4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7
--0__=8FBB0FBDDFB532CE8f9e8a93df938690918c8FBB0FBDDFB532CE--

