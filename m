DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=w09NnjLy/XDgP/6Ycxq0e/UdbjCoO+MB49x0tUmpqiA=;
	b=B15ph/5ev8Od1mtww2uaqWEVac9bbP6L/Q/eo/6qyDIruwIY4FPwDfOb0C4gnmurt5
	gFii31q1zEsP4GNI3oW545rXbCzBCJam9Wwm6oc6CWwvk1e2lzFR4Q63CqX/GykVwbpe
	7oNs4Q6b7TOjqdeng0QDOLTJEQc36z9xTfE8uzaYsAguaapCS1Arp4dKhlIeRPhyge7T
	EPTuK0hnOYQToK5LZtWul9N4iVQ3AxYr1iBFXwB0VFdam8ToltlJc8SJDgDtUJlw7yT5
	eXMFgVGcF+HqtL+NKXdNLRq0ElgYoyn8x/Jbn4jk42pHhtBuPp/vYAeiXgOAuhIeJqXC
	8Qqg==
MIME-Version: 1.0
References: <BY5PR11MB44018CADDC7A5C04F3D32BC4EA539@BY5PR11MB4401.namprd11.prod.outlook.com>
	<CAFQAk7jhNzMqh9VcsxUmsqxM25K=cR546hpNUY+5M50-UHSg-A@mail.gmail.com>
	<YJzirr/g1DlZr4X8@work-vm>
In-Reply-To: <YJzirr/g1DlZr4X8@work-vm>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Thu, 13 May 2021 16:51:09 +0800
Message-ID: <CAFQAk7iDPOKyxR4X_smGH=mBqDccWJUXooMJ+gyXRoaBt2yg4g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000249ffd05c2323bd1"
Subject: Re: [Virtio-fs] [External] Re: host-user reconnection and crash
	recovery
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Yongji Xie <xieyongji@bytedance.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, fam.zheng@bytedance.com

--000000000000249ffd05c2323bd1
Content-Type: text/plain; charset="UTF-8"

On Thu, May 13, 2021 at 4:26 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> > Hi Stefan and Sebastien,
> >
> > I think I should give some background context from my perspective.
> >
> > For the virtiofsd crash reconnection (recovery) to QEMU, as said by
> > Stefan, we discussed the possible implementation on the bi-weekly
> virtio-fs
> > call. I had also sent an RFC patch to the virtio-fs mail-list (
> >
> https://patchwork.kernel.org/project/qemu-devel/cover/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com/
> ),
> > we also have some discussion on the further revision direction in that
> > mail.
> >
> > We also have some needs to support virtiofsd crash recovery when it is
> used
> > with cloud-hypervisor (
> https://github.com/cloud-hypervisor/cloud-hypervisor).
> > However, the virtiofsd crash reconnection RFC patch relies on
> > QEMU's vhost-user socket reconnection feature and QEMU's vhost-user
> > inflight I/O tracking feature, which are both not supported by
> > cloud-hypervisor.
> >
> > So I also issued an initial pull-request of cloud-hypervisor vhost-user
> > socket reconnection (
> > https://github.com/cloud-hypervisor/cloud-hypervisor/pull/2387), which
> is
> > reviewed by Sebastien. Based on vhost-user socket reconnection, we also
> > want to further develop vhost-user inflight I/O tracking feature for
> > cloud-hypervisor, and finally to support virtiofsd crash reconnection.
> >
> > I am sorry for the delayed patch-revision of the two patch sets. I hope I
> > can free up some time in these two months to make some further progress.
>
> I'm curious what your use case is for virtiofsd crash
> recovery/reconnection - is there some reason you expect the daemon to
> crash or need to be restarted more than the whole VM?
>
> In the case of vhost-user networking with dpdk I can see the case where
> there is a central networking switch process shared between many VMs; so
> wanting to restart that without restarting all the VMs makes sense to
> me; where each VM has it's own virtiofsd I don't understand the use as
> much.
>
>
Hi Dave,

Yes, we want to restart virtiofsd without restarting the whole VM. One
reason is to avoid I/O hang caused by virtiofs daemon crash. Another
important reason to support virtiofsd live-upgrade for virtiofsd's bug or
security fixes based on virtiofsd reconnection.

All the best,
Jiachen



> Dave
>
> > All the best,
> > Jiachen
> >
> > On Tue, May 11, 2021 at 11:02 PM Boeuf, Sebastien <
> sebastien.boeuf@intel.com>
> > wrote:
> >
> > > Hi Stefan,
> > >
> > > Thanks for the explanation.
> > >
> > > So reconnection for vhost-user is not a well defined behavior,
> > > and QEMU is doing its best to retry when possible, depending
> > > on each device.
> > >
> > > The guest does not know about it, so it's never notified that
> > > the device needs to be reset.
> > >
> > > But what about the vhost-user backend initialization? Does
> > > QEMU go again through initializing memory table, vrings, etc...
> > > since it can't assume anything from the backend?
> > >
> > > Thanks,
> > > Sebastien
> > >
> > > ------------------------------
> > > *From:* Stefan Hajnoczi
> > > *Sent:* Tuesday, May 11, 2021 2:45 PM
> > > *To:* Boeuf, Sebastien
> > > *Cc:* virtio-fs@redhat.com; qemu-devel@nongnu.org
> > > *Subject:* vhost-user reconnection and crash recovery
> > >
> > > Hi Sebastien,
> > > On #virtio-fs IRC you asked:
> > >
> > >  I have a vhost-user question regarding disconnection/reconnection. How
> > >  should this be handled? Let's say the vhost-user backend disconnects,
> > >  and reconnects later on, does QEMU reset the virtio device by
> notifying
> > >  the guest? Or does it simply reconnects to the backend without letting
> > >  the guest know about what happened?
> > >
> > > The vhost-user protocol does not have a generic reconnection solution.
> > > Reconnection is handled on a case-by-case basis because device-specific
> > > and implementation-specific state is involved.
> > >
> > > The vhost-user-fs-pci device in QEMU has not been tested with
> > > reconnection as far as I know.
> > >
> > > The ideal reconnection behavior is to resume the device from its
> > > previous state without disrupting the guest. Device state must survive
> > > reconnection in order for this to work. Neither QEMU virtiofsd nor
> > > virtiofsd-rs implement this today.
> > >
> > > virtiofs has a lot of state, making it particularly difficult to
> support
> > > either DEVICE_NEEDS_RESET or transparent vhost-user reconnection. We
> > > have discussed virtiofs crash recovery on the bi-weekly virtiofs call
> > > (https://etherpad.opendev.org/p/virtiofs-external-meeting). If you
> want
> > > to work on this then joining the call would be a good starting point to
> > > coordinate with others.
> > >
> > > One approach for transparent crash recovery is for virtiofsd to keep
> its
> > > state in tmpfs (e.g. inode/fd mappings) and open fds shared with a
> > > clone(2) process via CLONE_FILES. This way the virtiofsd process can
> > > terminate but its state persists in memory thanks to its clone process.
> > > The clone can then be used to launch the new virtiofsd process from the
> > > old state. This would allow the device to resume transparently with
> QEMU
> > > only reconnecting the vhost-user UNIX domain socket. This is an idea
> > > that we discussed in the bi-weekly virtiofs call.
> > >
> > > You mentioned device reset. VIRTIO 1.1 has the Device Status Field
> > > DEVICE_NEEDS_RESET flat that the device can use to tell the driver that
> > > a reset is necessary. This feature is present in the specification but
> > > not implemented in the Linux guest drivers. Again the reason is that
> > > handling it requires driver-specific logic for restoring state after
> > > reset...otherwise the device reset would be visible to userspace.
> > >
> > > Stefan
> > >
> > > ---------------------------------------------------------------------
> > > Intel Corporation SAS (French simplified joint stock company)
> > > Registered headquarters: "Les Montalets"- 2, rue de Paris,
> > > 92196 Meudon Cedex, France
> > > Registration Number:  302 456 199 R.C.S. NANTERRE
> > > Capital: 4,572,000 Euros
> > >
> > > This e-mail and any attachments may contain confidential material for
> > > the sole use of the intended recipient(s). Any review or distribution
> > > by others is strictly prohibited. If you are not the intended
> > > recipient, please contact the sender and delete all copies.
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/virtio-fs
> > >
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>

--000000000000249ffd05c2323bd1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, May 13, 2021 at 4:26 PM Dr. D=
avid Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redha=
t.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">* Jiachen Zhang (<a href=3D"mailto:zhangjiachen.jaycee@bytedance.com" =
target=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>) wrote:<br>
&gt; Hi Stefan and Sebastien,<br>
&gt; <br>
&gt; I think I should give some background context from my perspective.<br>
&gt; <br>
&gt; For the virtiofsd crash reconnection (recovery) to QEMU, as said by<br=
>
&gt; Stefan, we discussed the possible implementation on the bi-weekly virt=
io-fs<br>
&gt; call. I had also sent an RFC patch to the virtio-fs mail-list (<br>
&gt; <a href=3D"https://patchwork.kernel.org/project/qemu-devel/cover/20201=
215162119.27360-1-zhangjiachen.jaycee@bytedance.com/" rel=3D"noreferrer" ta=
rget=3D"_blank">https://patchwork.kernel.org/project/qemu-devel/cover/20201=
215162119.27360-1-zhangjiachen.jaycee@bytedance.com/</a>),<br>
&gt; we also have some discussion on the further revision direction in that=
<br>
&gt; mail.<br>
&gt; <br>
&gt; We also have some needs to support virtiofsd crash recovery when it is=
 used<br>
&gt; with cloud-hypervisor (<a href=3D"https://github.com/cloud-hypervisor/=
cloud-hypervisor" rel=3D"noreferrer" target=3D"_blank">https://github.com/c=
loud-hypervisor/cloud-hypervisor</a>).<br>
&gt; However, the virtiofsd crash reconnection RFC patch relies on<br>
&gt; QEMU&#39;s vhost-user socket reconnection feature and QEMU&#39;s vhost=
-user<br>
&gt; inflight I/O tracking feature, which are both not supported by<br>
&gt; cloud-hypervisor.<br>
&gt; <br>
&gt; So I also issued an initial pull-request of cloud-hypervisor vhost-use=
r<br>
&gt; socket reconnection (<br>
&gt; <a href=3D"https://github.com/cloud-hypervisor/cloud-hypervisor/pull/2=
387" rel=3D"noreferrer" target=3D"_blank">https://github.com/cloud-hypervis=
or/cloud-hypervisor/pull/2387</a>), which is<br>
&gt; reviewed by Sebastien. Based on vhost-user socket reconnection, we als=
o<br>
&gt; want to further develop vhost-user inflight I/O tracking feature for<b=
r>
&gt; cloud-hypervisor, and finally to support virtiofsd crash reconnection.=
<br>
&gt; <br>
&gt; I am sorry for the delayed patch-revision of the two patch sets. I hop=
e I<br>
&gt; can free up some time in these two months to make some further progres=
s.<br>
<br>
I&#39;m curious what your use case is for virtiofsd crash<br>
recovery/reconnection - is there some reason you expect the daemon to<br>
crash or need to be restarted more than the whole VM?<br>
<br>
In the case of vhost-user networking with dpdk I can see the case where<br>
there is a central networking switch process shared between many VMs; so<br=
>
wanting to restart that without restarting all the VMs makes sense to<br>
me; where each VM has it&#39;s own virtiofsd I don&#39;t understand the use=
 as<br>
much.<br>
<br></blockquote><div><br></div><div>Hi Dave,</div><div><br></div><div>Yes,=
 we want to restart virtiofsd without restarting the whole VM. One reason i=
s to avoid I/O hang caused by virtiofs daemon crash. Another important reas=
on to support virtiofsd live-upgrade for virtiofsd&#39;s bug or security fi=
xes based on virtiofsd reconnection.</div><div><br></div><div>All the best,=
</div><div>Jiachen</div><div><br></div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
Dave<br>
<br>
&gt; All the best,<br>
&gt; Jiachen<br>
&gt; <br>
&gt; On Tue, May 11, 2021 at 11:02 PM Boeuf, Sebastien &lt;<a href=3D"mailt=
o:sebastien.boeuf@intel.com" target=3D"_blank">sebastien.boeuf@intel.com</a=
>&gt;<br>
&gt; wrote:<br>
&gt; <br>
&gt; &gt; Hi Stefan,<br>
&gt; &gt;<br>
&gt; &gt; Thanks for the explanation.<br>
&gt; &gt;<br>
&gt; &gt; So reconnection for vhost-user is not a well defined behavior,<br=
>
&gt; &gt; and QEMU is doing its best to retry when possible, depending<br>
&gt; &gt; on each device.<br>
&gt; &gt;<br>
&gt; &gt; The guest does not know about it, so it&#39;s never notified that=
<br>
&gt; &gt; the device needs to be reset.<br>
&gt; &gt;<br>
&gt; &gt; But what about the vhost-user backend initialization? Does<br>
&gt; &gt; QEMU go again through initializing memory table, vrings, etc...<b=
r>
&gt; &gt; since it can&#39;t assume anything from the backend?<br>
&gt; &gt;<br>
&gt; &gt; Thanks,<br>
&gt; &gt; Sebastien<br>
&gt; &gt;<br>
&gt; &gt; ------------------------------<br>
&gt; &gt; *From:* Stefan Hajnoczi<br>
&gt; &gt; *Sent:* Tuesday, May 11, 2021 2:45 PM<br>
&gt; &gt; *To:* Boeuf, Sebastien<br>
&gt; &gt; *Cc:* <a href=3D"mailto:virtio-fs@redhat.com" target=3D"_blank">v=
irtio-fs@redhat.com</a>; <a href=3D"mailto:qemu-devel@nongnu.org" target=3D=
"_blank">qemu-devel@nongnu.org</a><br>
&gt; &gt; *Subject:* vhost-user reconnection and crash recovery<br>
&gt; &gt;<br>
&gt; &gt; Hi Sebastien,<br>
&gt; &gt; On #virtio-fs IRC you asked:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 I have a vhost-user question regarding disconnection/reconn=
ection. How<br>
&gt; &gt;=C2=A0 should this be handled? Let&#39;s say the vhost-user backen=
d disconnects,<br>
&gt; &gt;=C2=A0 and reconnects later on, does QEMU reset the virtio device =
by notifying<br>
&gt; &gt;=C2=A0 the guest? Or does it simply reconnects to the backend with=
out letting<br>
&gt; &gt;=C2=A0 the guest know about what happened?<br>
&gt; &gt;<br>
&gt; &gt; The vhost-user protocol does not have a generic reconnection solu=
tion.<br>
&gt; &gt; Reconnection is handled on a case-by-case basis because device-sp=
ecific<br>
&gt; &gt; and implementation-specific state is involved.<br>
&gt; &gt;<br>
&gt; &gt; The vhost-user-fs-pci device in QEMU has not been tested with<br>
&gt; &gt; reconnection as far as I know.<br>
&gt; &gt;<br>
&gt; &gt; The ideal reconnection behavior is to resume the device from its<=
br>
&gt; &gt; previous state without disrupting the guest. Device state must su=
rvive<br>
&gt; &gt; reconnection in order for this to work. Neither QEMU virtiofsd no=
r<br>
&gt; &gt; virtiofsd-rs implement this today.<br>
&gt; &gt;<br>
&gt; &gt; virtiofs has a lot of state, making it particularly difficult to =
support<br>
&gt; &gt; either DEVICE_NEEDS_RESET or transparent vhost-user reconnection.=
 We<br>
&gt; &gt; have discussed virtiofs crash recovery on the bi-weekly virtiofs =
call<br>
&gt; &gt; (<a href=3D"https://etherpad.opendev.org/p/virtiofs-external-meet=
ing" rel=3D"noreferrer" target=3D"_blank">https://etherpad.opendev.org/p/vi=
rtiofs-external-meeting</a>). If you want<br>
&gt; &gt; to work on this then joining the call would be a good starting po=
int to<br>
&gt; &gt; coordinate with others.<br>
&gt; &gt;<br>
&gt; &gt; One approach for transparent crash recovery is for virtiofsd to k=
eep its<br>
&gt; &gt; state in tmpfs (e.g. inode/fd mappings) and open fds shared with =
a<br>
&gt; &gt; clone(2) process via CLONE_FILES. This way the virtiofsd process =
can<br>
&gt; &gt; terminate but its state persists in memory thanks to its clone pr=
ocess.<br>
&gt; &gt; The clone can then be used to launch the new virtiofsd process fr=
om the<br>
&gt; &gt; old state. This would allow the device to resume transparently wi=
th QEMU<br>
&gt; &gt; only reconnecting the vhost-user UNIX domain socket. This is an i=
dea<br>
&gt; &gt; that we discussed in the bi-weekly virtiofs call.<br>
&gt; &gt;<br>
&gt; &gt; You mentioned device reset. VIRTIO 1.1 has the Device Status Fiel=
d<br>
&gt; &gt; DEVICE_NEEDS_RESET flat that the device can use to tell the drive=
r that<br>
&gt; &gt; a reset is necessary. This feature is present in the specificatio=
n but<br>
&gt; &gt; not implemented in the Linux guest drivers. Again the reason is t=
hat<br>
&gt; &gt; handling it requires driver-specific logic for restoring state af=
ter<br>
&gt; &gt; reset...otherwise the device reset would be visible to userspace.=
<br>
&gt; &gt;<br>
&gt; &gt; Stefan<br>
&gt; &gt;<br>
&gt; &gt; -----------------------------------------------------------------=
----<br>
&gt; &gt; Intel Corporation SAS (French simplified joint stock company)<br>
&gt; &gt; Registered headquarters: &quot;Les Montalets&quot;- 2, rue de Par=
is,<br>
&gt; &gt; 92196 Meudon Cedex, France<br>
&gt; &gt; Registration Number:=C2=A0 302 456 199 R.C.S. NANTERRE<br>
&gt; &gt; Capital: 4,572,000 Euros<br>
&gt; &gt;<br>
&gt; &gt; This e-mail and any attachments may contain confidential material=
 for<br>
&gt; &gt; the sole use of the intended recipient(s). Any review or distribu=
tion<br>
&gt; &gt; by others is strictly prohibited. If you are not the intended<br>
&gt; &gt; recipient, please contact the sender and delete all copies.<br>
&gt; &gt; _______________________________________________<br>
&gt; &gt; Virtio-fs mailing list<br>
&gt; &gt; <a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-=
fs@redhat.com</a><br>
&gt; &gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs"=
 rel=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/li=
stinfo/virtio-fs</a><br>
&gt; &gt;<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; <a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@re=
dhat.com</a><br>
&gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=
=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/listin=
fo/virtio-fs</a><br>
<br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br>
</blockquote></div></div>

--000000000000249ffd05c2323bd1--

