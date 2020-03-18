In-Reply-To: <20200317104151.414e2a0b@redhat.com>
From: "Gong Su" <gongsu@us.ibm.com>
Date: Tue, 17 Mar 2020 21:59:03 -0500
References: <OFACFEEE57.45B9F1BC-ON0025852E.0026B45E-8525852E.0026EB59@notes.na.collabserv.com>
	<20200317104151.414e2a0b@redhat.com>
Message-Id: <OF35F17EC3.6AA6F64F-ON0025852F.00105593-8525852F.001064B6@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: multipart/related; 
	Boundary="0__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303"
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

--0__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303
Content-type: multipart/alternative; 
	Boundary="1__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303"

--1__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=WINDOWS-1252


Great! I'll give it a shot and see what happens. Thanks.



From:=09Igor Mammedov <imammedo@redhat.com>
To:=09"Gong Su" <gongsu@us.ibm.com>
Cc:=09Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert"
            <dgilbert@redhat.com>, virtio-fs@redhat.com
Date:=0903/17/2020 05:50 AM
Subject:=09[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)



On Tue, 17 Mar 2020 02:05:06 -0500
"Gong Su" <gongsu@us.ibm.com> wrote:

>
>
> Hi Igor, just wondering if there is any updates on getting the patches
that
> will allow shared memory without -numa (not supported on s390 yet)?
Thanks.

it's already upstream.

there is a new upstream option -machine memory-backend=3D...
that allows to set custom backend for main RAM

> __________________
>
> Hi Igor, that would be great. Thanks.
>
>
>
> From:=09=09 Igor Mammedov <imammedo@redhat.com>
> To:=09=09 "Gong Su" <gongsu@us.ibm.com>
> Cc:=09=09 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Cornelia Huck
>             <cohuck@redhat.com>, virtio-fs@redhat.com
> Date:=09=09 12/13/2019 08:17 AM
> Subject:=09=09 [EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)
>
>
>
> On Thu, 12 Dec 2019 14:10:32 -0500
> "Gong Su" <gongsu@us.ibm.com> wrote:
>
> >
> > Thanks Dave. That was quick!
> >
> > Igor, any idea when this will happen? :-)
> If you need early sneak peek, I can post common + s390 patches.
>
>
> > From:=09=09 =09=09  "Dr. David Alan Gilbert"
<dgilbert@redhat.com>
> > To:=09=09 =09=09  Gong Su <gongsu@us.ibm.com>
> > Cc:=09=09 =09=09  virtio-fs@redhat.com, Cornelia Huck
<cohuck@redhat.com>
> > Date:=09=09 =09=09  12/12/2019 01:59 PM
> > Subject:=09=09 =09=09  [EXTERNAL] Re: [Virtio-fs] virtio-fs
on zLinux (s390x)
> >
> >
> >
> > * Gong Su (gongsu@us.ibm.com) wrote:
> > >
> > >
> > > Hi Stefan, I'm resending my questions to the list per your request.
> > >
> > > Basically, I'm trying to see if I can get virtio-fs to work on
zLinux.
> > > Following the instructions on
> >
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_howto-2Dqemu.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcS=
zS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q=
_7M&s=3DpkvbWd3P-tWRpKPww5iwoPHLE_HnkenEEJhywABpRuc&e=3D

>
> >   I
> > > was able to compile all the pieces but when I tried to run qemu I
> > realized
> > > that it needs -numa option which isn't supported on s390x yet.
> > >
> > > I have talked to Christian Borntraeger (whom I worked with on other
> > > projects before) and he indicated that he had a plan to add -numa
> support
> > > for s390x but currently is busy on other things.
> > >
> > > So I'm trying to see if there are other ways for me to go forward
> without
> > > having to wait for Christian. I see two options:
> > >
> > > 1. Merge virtiofsd into qemu itself. In the "Interchangeability"
> section
> > of
> > > the virtio-fs design page (
> >
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__virtio-2Dfs.gitlab.i=
o_design.html&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgEPUcSzS0GcR=
EznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=
=3D2VrG3dsgZcdW8uO6ZBiGtRgNp4X1z3d8TMXnUdHhfCc&e=3D

>
> >  ), it
> > > mentioned that "It is also possible to forego vhost-user and emulate
> the
> > > virtio-fs device directly inside the hypervisor, although this may
> result
> > > in poor isolation and security." Since each guest typically gets its
> own
> > > qemu process, maybe this is acceptable for some use cases. In
exchange,
> > you
> > > get the benefit of not having to carve out a chunk of memory
> > from /dev/shm
> > > (and maybe simpler communication between virtiofsd and qemu).
> > > 2. Use something other than -numa to share memory between virtiofsd
and
> > > qemu that's supported on zLinux. I'm not entirely familiar with qemu
so
> I
> > > have no idea whether this is possible or not.
> >
> > Hi,
> >   My understanding is that Igor Mammedov (imammedo@redhat.com) has
plans
> > to allow 'shared' to be set on main memory, so we wouldn't need the
numa
> > code.
> >
> > Dave
> >
> > > Thanks.
> >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > >
> >
>
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_mailm=
an_listinfo_virtio-2Dfs&d=3DDwIFAg&c=3Djf_iaSHvJObTbx-siA1ZOg&r=3Dtf-1fDxgE=
PUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=3DbKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6=
Qb5Q_7M&s=3DO41fLQGJCOR0-Aj2Y4nziy3aTYTOCzaH8Lahe7xhBK8&e=3D

>
> >
> >
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >
> >
> >
> >
>
>
>




--1__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303
Content-type: text/html; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 9 URL's were un-rewritten

<html><body><p><font size=3D"2">Great! I'll give it a shot and see what hap=
pens. Thanks.</font><br><br><img width=3D"16" height=3D"16" src=3D"cid:1__=
=3D8FBB0FBCDF83D3038f9e8a93df938690918c8FB@" border=3D"0" alt=3D"Inactive h=
ide details for Igor Mammedov ---03/17/2020 05:50:22 AM---On Tue, 17 Mar 20=
20 02:05:06 -0500 &quot;Gong Su&quot; &lt;gongsu@us.ibm"><font size=3D"2" c=
olor=3D"#424282">Igor Mammedov ---03/17/2020 05:50:22 AM---On Tue, 17 Mar 2=
020 02:05:06 -0500 &quot;Gong Su&quot; &lt;gongsu@us.ibm.com&gt; wrote:</fo=
nt><br><br><font size=3D"2" color=3D"#5F5F5F">From:        </font><font siz=
e=3D"2">Igor Mammedov &lt;imammedo@redhat.com&gt;</font><br><font size=3D"2=
" color=3D"#5F5F5F">To:        </font><font size=3D"2">&quot;Gong Su&quot; =
&lt;gongsu@us.ibm.com&gt;</font><br><font size=3D"2" color=3D"#5F5F5F">Cc: =
       </font><font size=3D"2">Cornelia Huck &lt;cohuck@redhat.com&gt;, &qu=
ot;Dr. David Alan Gilbert&quot; &lt;dgilbert@redhat.com&gt;, virtio-fs@redh=
at.com</font><br><font size=3D"2" color=3D"#5F5F5F">Date:        </font><fo=
nt size=3D"2">03/17/2020 05:50 AM</font><br><font size=3D"2" color=3D"#5F5F=
5F">Subject:        </font><font size=3D"2">[EXTERNAL] Re: [Virtio-fs] virt=
io-fs on zLinux (s390x)</font><br><hr width=3D"100%" size=3D"2" align=3D"le=
ft" noshade style=3D"color:#8091A5; "><br><br><br><tt><font size=3D"2">On T=
ue, 17 Mar 2020 02:05:06 -0500<br>&quot;Gong Su&quot; &lt;gongsu@us.ibm.com=
&gt; wrote:<br><br>&gt; <br>&gt; <br>&gt; Hi Igor, just wondering if there =
is any updates on getting the patches that<br>&gt; will allow shared memory=
 without -numa (not supported on s390 yet)? Thanks.<br><br>it's already ups=
tream.<br><br>there is a new upstream option -machine memory-backend=3D...<=
br>that allows to set custom backend for main RAM<br><br>&gt; _____________=
_____<br>&gt; <br>&gt; Hi Igor, that would be great. Thanks.<br>&gt; <br>&g=
t; <br>&gt; <br>&gt; From:                 Igor Mammedov &lt;imammedo@redha=
t.com&gt;<br>&gt; To:                 &quot;Gong Su&quot; &lt;gongsu@us.ibm=
.com&gt;<br>&gt; Cc:                 &quot;Dr. David Alan Gilbert&quot; &lt=
;dgilbert@redhat.com&gt;, Cornelia Huck<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &lt;cohuck@redhat.com&gt;, virtio-fs@redhat.com<br>&gt; Date=
:                 12/13/2019 08:17 AM<br>&gt; Subject:                 [EXT=
ERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)<br>&gt; <br>&gt; <br>&gt=
; <br>&gt; On Thu, 12 Dec 2019 14:10:32 -0500<br>&gt; &quot;Gong Su&quot; &=
lt;gongsu@us.ibm.com&gt; wrote:<br>&gt; <br>&gt; &gt;<br>&gt; &gt; Thanks D=
ave. That was quick!<br>&gt; &gt;<br>&gt; &gt; Igor, any idea when this wil=
l happen? :-)<br>&gt; If you need early sneak peek, I can post common + s39=
0 patches.<br>&gt; <br>&gt; <br>&gt; &gt; From:                            =
      &nbsp;&quot;Dr. David Alan Gilbert&quot; &lt;dgilbert@redhat.com&gt;<=
br>&gt; &gt; To:                                  &nbsp;Gong Su &lt;gongsu@=
us.ibm.com&gt;<br>&gt; &gt; Cc:                                  &nbsp;virt=
io-fs@redhat.com, Cornelia Huck &lt;cohuck@redhat.com&gt;<br>&gt; &gt; Date=
:                                  &nbsp;12/12/2019 01:59 PM<br>&gt; &gt; S=
ubject:                                  &nbsp;[EXTERNAL] Re: [Virtio-fs] v=
irtio-fs on zLinux (s390x)<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &=
gt; * Gong Su (gongsu@us.ibm.com) wrote:<br>&gt; &gt; &gt;<br>&gt; &gt; &gt=
;<br>&gt; &gt; &gt; Hi Stefan, I'm resending my questions to the list per y=
our request.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Basically, I'm trying to s=
ee if I can get virtio-fs to work on zLinux.<br>&gt; &gt; &gt; Following th=
e instructions on<br>&gt; &gt;<br>&gt; </font></tt><tt><font size=3D"2"><a =
href=3D"https://virtio-fs.gitlab.io/howto-qemu.html">https://virtio-fs.gitl=
ab.io/howto-qemu.html</a></font></tt><tt><font size=3D"2"><br>&gt; <br>&gt;=
 &gt; &nbsp; I<br>&gt; &gt; &gt; was able to compile all the pieces but whe=
n I tried to run qemu I<br>&gt; &gt; realized<br>&gt; &gt; &gt; that it nee=
ds -numa option which isn't supported on s390x yet.<br>&gt; &gt; &gt;<br>&g=
t; &gt; &gt; I have talked to Christian Borntraeger (whom I worked with on =
other<br>&gt; &gt; &gt; projects before) and he indicated that he had a pla=
n to add -numa<br>&gt; support<br>&gt; &gt; &gt; for s390x but currently is=
 busy on other things.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; So I'm trying to=
 see if there are other ways for me to go forward<br>&gt; without<br>&gt; &=
gt; &gt; having to wait for Christian. I see two options:<br>&gt; &gt; &gt;=
<br>&gt; &gt; &gt; 1. Merge virtiofsd into qemu itself. In the &quot;Interc=
hangeability&quot;<br>&gt; section<br>&gt; &gt; of<br>&gt; &gt; &gt; the vi=
rtio-fs design page (<br>&gt; &gt;<br>&gt; </font></tt><tt><font size=3D"2"=
><a href=3D"https://virtio-fs.gitlab.io/design.html">https://virtio-fs.gitl=
ab.io/design.html</a></font></tt><tt><font size=3D"2"><br>&gt; <br>&gt; &gt=
; &nbsp;), it<br>&gt; &gt; &gt; mentioned that &quot;It is also possible to=
 forego vhost-user and emulate<br>&gt; the<br>&gt; &gt; &gt; virtio-fs devi=
ce directly inside the hypervisor, although this may<br>&gt; result<br>&gt;=
 &gt; &gt; in poor isolation and security.&quot; Since each guest typically=
 gets its<br>&gt; own<br>&gt; &gt; &gt; qemu process, maybe this is accepta=
ble for some use cases. In exchange,<br>&gt; &gt; you<br>&gt; &gt; &gt; get=
 the benefit of not having to carve out a chunk of memory<br>&gt; &gt; from=
 /dev/shm<br>&gt; &gt; &gt; (and maybe simpler communication between virtio=
fsd and qemu).<br>&gt; &gt; &gt; 2. Use something other than -numa to share=
 memory between virtiofsd and<br>&gt; &gt; &gt; qemu that's supported on zL=
inux. I'm not entirely familiar with qemu so<br>&gt; I<br>&gt; &gt; &gt; ha=
ve no idea whether this is possible or not.<br>&gt; &gt;<br>&gt; &gt; Hi,<b=
r>&gt; &gt; &nbsp; My understanding is that Igor Mammedov (imammedo@redhat.=
com) has plans<br>&gt; &gt; to allow 'shared' to be set on main memory, so =
we wouldn't need the numa<br>&gt; &gt; code.<br>&gt; &gt;<br>&gt; &gt; Dave=
<br>&gt; &gt;<br>&gt; &gt; &gt; Thanks.<br>&gt; &gt;<br>&gt; &gt; &gt; ____=
___________________________________________<br>&gt; &gt; &gt; Virtio-fs mai=
ling list<br>&gt; &gt; &gt; Virtio-fs@redhat.com<br>&gt; &gt; &gt;<br>&gt; =
&gt;<br>&gt; </font></tt><tt><font size=3D"2"><a href=3D"https://www.redhat=
.com/mailman/listinfo/virtio-fs">https://www.redhat.com/mailman/listinfo/vi=
rtio-fs</a></font></tt><tt><font size=3D"2"><br>&gt; <br>&gt; &gt;<br>&gt; =
&gt;<br>&gt; &gt; --<br>&gt; &gt; Dr. David Alan Gilbert / dgilbert@redhat.=
com / Manchester, UK<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br=
>&gt; <br>&gt; <br>&gt; <br><br></font></tt><br><br><BR>
</body></html>

--1__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303--

--0__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303
Content-type: image/gif; 
	name="graycol.gif"
Content-Disposition: inline; filename="graycol.gif"
Content-ID: <1__=8FBB0FBCDF83D3038f9e8a93df938690918c8FB@>
Content-Transfer-Encoding: base64

R0lGODlhEAAQAKECAMzMzAAAAP///wAAACH5BAEAAAIALAAAAAAQABAAAAIXlI+py+0PopwxUbpu
ZRfKZ2zgSJbmSRYAIf4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7
--0__=8FBB0FBCDF83D3038f9e8a93df938690918c8FBB0FBCDF83D303--

