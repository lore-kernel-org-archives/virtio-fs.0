DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=A8O85o6lgvWqsKqu6sualjszBe00dRmXIMrhjAWDjC8=;
	b=a28J4qMBKKAfAQ8gNhiMFCvPYBdwzGTXGihDPqzYv4l4oMxHbUOYABbcToDMpjicJK
	gVQ7rM/7S/Qe49ng1TJo8Sex7Jc4huD3AIq2r1g9g209z0OTNiQ953TjYwuo21kJoSRF
	jRw6u4g5EwE33a35jzGvw9ZY8St3JsBrFrwrEHF/y2AKffzAMgG14kjciO288anaut6m
	w+uu+mCIcrN1ro8jJG4srDcxKAXi9j7GkOzrsdvkDmE2Kbli11re+ssVzNS9eRDKfiP5
	o3oKZ2AiXqSdnxF0CcV9w70Go3PDmD3aQ6NBZLNWvF0KtYZ6MjsPa1XnzJon1Sk7HSKn
	vh9g==
MIME-Version: 1.0
References: <2148A6EA-09CC-4DD2-8E03-8D51633D4137@apple.com>
	<CAOssrKdGOL3Zqmhz4VGEccWw8N0tp1kP7qooB8gN7JOi5+5gew@mail.gmail.com>
	<20210322164704.GD446288@redhat.com>
	<20210323115451.oxe4a4go32brca7z@mhamilton>
	<20210323134733.GA483930@redhat.com>
In-Reply-To: <20210323134733.GA483930@redhat.com>
From: Eric Ernst <eric.g.ernst@gmail.com>
Date: Tue, 23 Mar 2021 07:52:22 -0700
Message-ID: <CAAQbG+UxuFYKiNAL0=dUg1oSVs0tqf7vi0C4xVA6h6ft77UcNQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000012e07705be35550d"
Subject: Re: [Virtio-fs] Large memory consumption by virtiofsd,
 suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Eric Ernst <eric_ernst@apple.com>

--00000000000012e07705be35550d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 6:47 AM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Mar 23, 2021 at 12:55:26PM +0100, Sergio Lopez wrote:
> > On Mon, Mar 22, 2021 at 12:47:04PM -0400, Vivek Goyal wrote:
> > > On Mon, Mar 22, 2021 at 05:09:32PM +0100, Miklos Szeredi wrote:
> > > > On Mon, Mar 22, 2021 at 6:52 AM Eric Ernst <eric_ernst@apple.com>
> wrote:
> > > > >
> > > > > Hey ya=E2=80=99ll,
> > > > >
> > > > > One challenge I=E2=80=99ve been looking at is how to setup an app=
ropriate
> memory cgroup limit for workloads that are leveraging virtiofs (ie, runni=
ng
> pods with Kata Containers). I noticed that memory usage of the daemon
> itself can grow considerably depending on the workload; though much more
> than I=E2=80=99d expect.
> > > > >
> > > > > I=E2=80=99m running workload that simply runs a build on kernel s=
ources
> with -j3. In doing this, the source of the linux kernel are shared via
> virtiofs (no DAX), so as the build goes on, there are a lot of files
> opened, closed, as well as created. The rss memory of virtiofsd grows int=
o
> several hundreds of MBs.
> > > > >
> > > > > When taking a look, I=E2=80=99m suspecting that virtiofsd is carr=
ying out
> the opens, but never actually closing fds. In the guest, I=E2=80=99m seei=
ng fd=E2=80=99s on
> the order of 10-40 for all the container processes as it runs, whereas I
> see the number of fds for virtiofsd continually increasing, reaching over
> 80,000 fds. I=E2=80=99m guessing this isn=E2=80=99t expected?
> > > >
> > > > The reason could be that guest is keeping a ref on the inodes
> > > > (dcache->dentry->inode) and current implementation of server keeps =
an
> > > > O_PATH fd open for each inode referenced by the client.
> > > >
> > > > One way to avoid this is to use the "cache=3Dnone" option, which fo=
rces
> > > > the client to drop dentries immediately from the cache if not in us=
e.
> > > > This is not desirable if cache is actually in use.
> > > >
> > > > The memory use of the server should still be limited by the memory
> use
> > > > of the guest:  if there's memory pressure in the guest kernel, then
> it
> > > > will clean out caches, which results in the memory use decreasing i=
n
> > > > the server as well.  If the server memory use looks unbounded, that
> > > > might be indicative of too much memory used for dcache in the guest
> > > > (cat /proc/slabinfo | grep ^dentry).     Can you verify?
> > >
> > > Hi Miklos,
> > >
> > > Apart from above, we identified one more issue on IRC. I asked Eric
> > > to drop caches manually in guest. (echo 3 > /proc/sys/vm/drop_caches)
> > > and while it reduced the fds open it did not seem to free up
> significant
> > > amount of memory.
> > >
> > > So question remains where is that memory. One possibility is that we
> > > have memory allocated for mapping arrays (inode and fd). These arrays
> > > only grow and never shrink. So they can lock down some memory.
> > >
> > > But still, lot of lo_inode memory should have been freed when
> > > echo 3 > /proc/sys/vm/drop_caches was done. Why all that did not
> > > show up in virtiofsd RSS usage, that's kind of little confusing.
> >
> > Are you including "RssShmem" in "RSS usage"? If so, that could be
> > misleading. When virtiofsd[-rs] touches pages that reside in the
> > memory mapping that's shared with QEMU, those pages are accounted
> > in the virtiofsd[-rs] process's RssShmem too.
> >
> > In other words, the RSS value of the virtiofsd[-rs] process may be
> > overinflated because it includes pages that are actually shared
> > (there's no a second copy of them) with the QEMU process.
> >
> > This can be observed using a tool like "smem". Here's an example
> >
> >  - This virtiofsd-rs process appears to have a RSS of ~633 MiB
> >
> > root       13879 46.1  7.9 8467492 649132 pts/1  Sl+  11:33   0:52
> ./target/debug/virtiofsd-rs
> > root       13947 69.3 13.4 5638580 1093876 pts/0 Sl+  11:33   1:14
> qemu-system-x86_64
> >
> >  - In /proc/13879/status we can observe most of that memory is
> >    actually RssShmem:
> >
> > RssAnon:          9624 kB
> > RssFile:          5136 kB
> > RssShmem:       634372 kB
>
> Hi Sergio,
>
> Thanks for this observation about RssShmem. I also ran virtiofsd and
> observed memory usage just now and it indeed looks like that only
> RssShmem usage is very high.
>
> RssAnon:            4884 kB
> RssFile:            1900 kB
> RssShmem:        1050244 kB
>
> And as you point out that this memory is being shared with QEMU. So
> looks like from cgroup point of view, we should put virtiofsd and
> qemu in same cgroup and have a combined memory limit so that this
> shared memory is accounting looks proper.
>
> Eric, does this sound reasonable.
>

Sergio, Vivek --

Today QEMU/virtiofsd do live within the same memory cgroup, and are bound
by that same overhead I need to introduce. Good to know regarding the
sharing (this restores some sanity to my observations, thank you!), but the
real crux of the problem is two items:
 1) the FDs are held long after the application in guest is done with them
because of dentry cache in the guest (when cache=3Dauto for virtiofsd).
 2) virtiofsd/QEMU is holding on to the memory after the fds are released

--Eric



>
> Thanks
> Vivek
>
> >
> >  - In "smem", we can see a similar amount of RSS, but the PSS is
> >    roughly half the size because "smem" is splitting it up between
> >    virtiofsd-rs and QEMU:
> >
> > [root@localhost ~]# smem -P virtiofsd-rs -P qemu
> >   PID User     Command                         Swap      USS      PSS
>   RSS
> > 13879 root     ./target/debug/virtiofsd-rs        0    13412   337019
>  662392
> > 13947 root     qemu-system-x86_64 -enable-        0   434224   760096
> 1094392
> >
> >  - If we terminate the virtiofsd-rs process, the output of "smem" now
> >    shows that QEMU's PSS has grown to account for the PSS that was
> >    previously assigned to virtiofsd-rs too, so we can confirm that was
> >    memory shared between both processes.
> >
> >   PID User     Command                         Swap      USS      PSS
>   RSS
> > 13947 root     qemu-system-x86_64 -enable-        0  1082656  1084966
> 1095692
> >
> > Just to be 100% sure, I've also run "heaptrack" on a virtiofsd-rs
> > instance, and can confirm that the actual heap usage of the process
> > was around 5-6 MiB.
> >
> > Sergio.
>
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>

--00000000000012e07705be35550d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Mar 23, 2021 at 6:47 AM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-style:solid;border-left-color:rgb=
(204,204,204);padding-left:1ex">On Tue, Mar 23, 2021 at 12:55:26PM +0100, S=
ergio Lopez wrote:<br>
&gt; On Mon, Mar 22, 2021 at 12:47:04PM -0400, Vivek Goyal wrote:<br>
&gt; &gt; On Mon, Mar 22, 2021 at 05:09:32PM +0100, Miklos Szeredi wrote:<b=
r>
&gt; &gt; &gt; On Mon, Mar 22, 2021 at 6:52 AM Eric Ernst &lt;<a href=3D"ma=
ilto:eric_ernst@apple.com" target=3D"_blank">eric_ernst@apple.com</a>&gt; w=
rote:<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Hey ya=E2=80=99ll,<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; One challenge I=E2=80=99ve been looking at is how to se=
tup an appropriate memory cgroup limit for workloads that are leveraging vi=
rtiofs (ie, running pods with Kata Containers). I noticed that memory usage=
 of the daemon itself can grow considerably depending on the workload; thou=
gh much more than I=E2=80=99d expect.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I=E2=80=99m running workload that simply runs a build o=
n kernel sources with -j3. In doing this, the source of the linux kernel ar=
e shared via virtiofs (no DAX), so as the build goes on, there are a lot of=
 files opened, closed, as well as created. The rss memory of virtiofsd grow=
s into several hundreds of MBs.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; When taking a look, I=E2=80=99m suspecting that virtiof=
sd is carrying out the opens, but never actually closing fds. In the guest,=
 I=E2=80=99m seeing fd=E2=80=99s on the order of 10-40 for all the containe=
r processes as it runs, whereas I see the number of fds for virtiofsd conti=
nually increasing, reaching over 80,000 fds. I=E2=80=99m guessing this isn=
=E2=80=99t expected?<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The reason could be that guest is keeping a ref on the inode=
s<br>
&gt; &gt; &gt; (dcache-&gt;dentry-&gt;inode) and current implementation of =
server keeps an<br>
&gt; &gt; &gt; O_PATH fd open for each inode referenced by the client.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; One way to avoid this is to use the &quot;cache=3Dnone&quot;=
 option, which forces<br>
&gt; &gt; &gt; the client to drop dentries immediately from the cache if no=
t in use.<br>
&gt; &gt; &gt; This is not desirable if cache is actually in use.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The memory use of the server should still be limited by the =
memory use<br>
&gt; &gt; &gt; of the guest:=C2=A0 if there&#39;s memory pressure in the gu=
est kernel, then it<br>
&gt; &gt; &gt; will clean out caches, which results in the memory use decre=
asing in<br>
&gt; &gt; &gt; the server as well.=C2=A0 If the server memory use looks unb=
ounded, that<br>
&gt; &gt; &gt; might be indicative of too much memory used for dcache in th=
e guest<br>
&gt; &gt; &gt; (cat /proc/slabinfo | grep ^dentry).=C2=A0 =C2=A0 =C2=A0Can =
you verify?<br>
&gt; &gt; <br>
&gt; &gt; Hi Miklos,<br>
&gt; &gt; <br>
&gt; &gt; Apart from above, we identified one more issue on IRC. I asked Er=
ic<br>
&gt; &gt; to drop caches manually in guest. (echo 3 &gt; /proc/sys/vm/drop_=
caches)<br>
&gt; &gt; and while it reduced the fds open it did not seem to free up sign=
ificant<br>
&gt; &gt; amount of memory.<br>
&gt; &gt; <br>
&gt; &gt; So question remains where is that memory. One possibility is that=
 we<br>
&gt; &gt; have memory allocated for mapping arrays (inode and fd). These ar=
rays<br>
&gt; &gt; only grow and never shrink. So they can lock down some memory.<br=
>
&gt; &gt; <br>
&gt; &gt; But still, lot of lo_inode memory should have been freed when<br>
&gt; &gt; echo 3 &gt; /proc/sys/vm/drop_caches was done. Why all that did n=
ot<br>
&gt; &gt; show up in virtiofsd RSS usage, that&#39;s kind of little confusi=
ng.<br>
&gt; <br>
&gt; Are you including &quot;RssShmem&quot; in &quot;RSS usage&quot;? If so=
, that could be<br>
&gt; misleading. When virtiofsd[-rs] touches pages that reside in the<br>
&gt; memory mapping that&#39;s shared with QEMU, those pages are accounted<=
br>
&gt; in the virtiofsd[-rs] process&#39;s RssShmem too.<br>
&gt; <br>
&gt; In other words, the RSS value of the virtiofsd[-rs] process may be<br>
&gt; overinflated because it includes pages that are actually shared<br>
&gt; (there&#39;s no a second copy of them) with the QEMU process.<br>
&gt; <br>
&gt; This can be observed using a tool like &quot;smem&quot;. Here&#39;s an=
 example<br>
&gt; <br>
&gt;=C2=A0 - This virtiofsd-rs process appears to have a RSS of ~633 MiB<br=
>
&gt;=C2=A0 <br>
&gt; root=C2=A0 =C2=A0 =C2=A0 =C2=A013879 46.1=C2=A0 7.9 8467492 649132 pts=
/1=C2=A0 Sl+=C2=A0 11:33=C2=A0 =C2=A00:52 ./target/debug/virtiofsd-rs<br>
&gt; root=C2=A0 =C2=A0 =C2=A0 =C2=A013947 69.3 13.4 5638580 1093876 pts/0 S=
l+=C2=A0 11:33=C2=A0 =C2=A01:14 qemu-system-x86_64<br>
&gt; <br>
&gt;=C2=A0 - In /proc/13879/status we can observe most of that memory is<br=
>
&gt;=C2=A0 =C2=A0 actually RssShmem:<br>
&gt; <br>
&gt; RssAnon:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 9624 kB<br>
&gt; RssFile:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5136 kB<br>
&gt; RssShmem:=C2=A0 =C2=A0 =C2=A0 =C2=A0634372 kB<br>
<br>
Hi Sergio,<br>
<br>
Thanks for this observation about RssShmem. I also ran virtiofsd and<br>
observed memory usage just now and it indeed looks like that only<br>
RssShmem usage is very high.<br>
<br>
RssAnon:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 4884 kB<br>
RssFile:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1900 kB<br>
RssShmem:=C2=A0 =C2=A0 =C2=A0 =C2=A0 1050244 kB<br>
<br>
And as you point out that this memory is being shared with QEMU. So<br>
looks like from cgroup point of view, we should put virtiofsd and<br>
qemu in same cgroup and have a combined memory limit so that this<br>
shared memory is accounting looks proper.<br>
<br>
Eric, does this sound reasonable.<br></blockquote><div><br></div><div>Sergi=
o, Vivek --</div><div><br></div><div>Today QEMU/virtiofsd=C2=A0do live with=
in the same memory cgroup, and are bound by that same overhead I need to in=
troduce. Good to know regarding the sharing (this restores some sanity to m=
y observations, thank you!), but the real crux of the problem is two items:=
</div><div>=C2=A01) the FDs are held long after the application in guest is=
 done with them because of dentry cache in the guest (when cache=3Dauto for=
 virtiofsd).</div><div>=C2=A02) virtiofsd/QEMU is holding on to the memory =
after the fds are released</div><div><br></div><div>--Eric</div><div><br></=
div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;border-left-col=
or:rgb(204,204,204);padding-left:1ex">
<br>
Thanks<br>
Vivek<br>
<br>
&gt; <br>
&gt;=C2=A0 - In &quot;smem&quot;, we can see a similar amount of RSS, but t=
he PSS is<br>
&gt;=C2=A0 =C2=A0 roughly half the size because &quot;smem&quot; is splitti=
ng it up between<br>
&gt;=C2=A0 =C2=A0 virtiofsd-rs and QEMU:<br>
&gt; <br>
&gt; [root@localhost ~]# smem -P virtiofsd-rs -P qemu<br>
&gt;=C2=A0 =C2=A0PID User=C2=A0 =C2=A0 =C2=A0Command=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Swap=
=C2=A0 =C2=A0 =C2=A0 USS=C2=A0 =C2=A0 =C2=A0 PSS=C2=A0 =C2=A0 =C2=A0 RSS <b=
r>
&gt; 13879 root=C2=A0 =C2=A0 =C2=A0./target/debug/virtiofsd-rs=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 13412=C2=A0 =C2=A0337019=C2=A0 =C2=A0662392 <=
br>
&gt; 13947 root=C2=A0 =C2=A0 =C2=A0qemu-system-x86_64 -enable-=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0=C2=A0 =C2=A0434224=C2=A0 =C2=A0760096=C2=A0 1094392 <br>
&gt; <br>
&gt;=C2=A0 - If we terminate the virtiofsd-rs process, the output of &quot;=
smem&quot; now<br>
&gt;=C2=A0 =C2=A0 shows that QEMU&#39;s PSS has grown to account for the PS=
S that was<br>
&gt;=C2=A0 =C2=A0 previously assigned to virtiofsd-rs too, so we can confir=
m that was<br>
&gt;=C2=A0 =C2=A0 memory shared between both processes.<br>
&gt; <br>
&gt;=C2=A0 =C2=A0PID User=C2=A0 =C2=A0 =C2=A0Command=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Swap=
=C2=A0 =C2=A0 =C2=A0 USS=C2=A0 =C2=A0 =C2=A0 PSS=C2=A0 =C2=A0 =C2=A0 RSS <b=
r>
&gt; 13947 root=C2=A0 =C2=A0 =C2=A0qemu-system-x86_64 -enable-=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0=C2=A0 1082656=C2=A0 1084966=C2=A0 1095692 <br>
&gt; <br>
&gt; Just to be 100% sure, I&#39;ve also run &quot;heaptrack&quot; on a vir=
tiofsd-rs<br>
&gt; instance, and can confirm that the actual heap usage of the process<br=
>
&gt; was around 5-6 MiB.<br>
&gt; <br>
&gt; Sergio.<br>
<br>
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
</blockquote></div></div>

--00000000000012e07705be35550d--

