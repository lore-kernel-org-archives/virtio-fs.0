MIME-Version: 1.0
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
	<CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
	<YXhIm3mOvPsueWab@redhat.com>
In-Reply-To: <YXhIm3mOvPsueWab@redhat.com>
From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Tue, 26 Oct 2021 15:14:10 -0400
Message-ID: <CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000060399c05cf464a55"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

--00000000000060399c05cf464a55
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 26, 2021 at 2:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Oct 26, 2021 at 08:59:44PM +0300, Amir Goldstein wrote:
> > On Tue, Oct 26, 2021 at 7:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Tue, Oct 26, 2021 at 06:23:50PM +0300, Amir Goldstein wrote:
> > >
> > > [..]
> > > > > 3) The lifetime of the local watch in the guest kernel is very
> > > > > important. Specifically, there is a possibility that the guest
> does not
> > > > > receive remote events on time, if it removes its local watch on the
> > > > > target or deletes the inode (and thus the guest kernel removes the
> watch).
> > > > > In these cases the guest kernel removes the local watch before the
> > > > > remote events arrive from the host (virtiofsd) and as such the
> guest
> > > > > kernel drops all the remote events for the target inode (since the
> > > > > corresponding local watch does not exist anymore).
> > >
> > > So this is one of the issues which has been haunting us in virtiofs. If
> > > a file is removed, for local events, event is generated first and
> > > then watch is removed. But in case of remote filesystems, it is racy.
> > > It is possible that by the time event arrives, watch is already gone
> > > and application never sees the delete event.
> > >
> > > Not sure how to address this issue.
> >
>
> > Can you take me through the scenario step by step.
> > I am not sure I understand the exact sequence of the race.
>
> Ioannis, please correct me If I get something wrong. You know exact
> details much more than me.
>
> A. Say a guest process unlinks a file.
> B. Fuse sends an unlink request to server (virtiofsd)
> C. File is unlinked on host. Assume there are no other users so inode
>    will be freed as well. And event will be generated on host and watch
>    removed.
> D. Now Fuse server will send a unlink request reply. unlink notification
>    might still be in kernel buffers or still be in virtiofsd or could
>    be in virtiofs virtqueue.
> E. Fuse client will receive unlink reply and remove local watch.
>
> Fuse reply and notification event are now traveling in parallel on
> different virtqueues and there is no connection between these two. And
> it could very well happen that fuse reply comes first, gets processed
> first and local watch is removed. And notification is processed right
> after but by then local watch is gone and filesystem will be forced to
> drop event.
>
> As of now situation is more complicated in virtiofsd. We don't keep
> file handle open for file and keep an O_PATH fd open for each file.
> That means in step D above, inode on host is not freed yet and unlink
> event is not generated yet. When unlink reply reaches fuse client,
> it sends FORGET messages to server, and then server closes O_PATH fd
> and then host generates unlink events. By that time its too late,
> guest has already remove local watches (and triggered removal of
> remote watches too).
>
> This second problem probably can be solved by using file handles, but
> basic race will still continue to be there.
>
> > If it is local file removal that causes watch to be removed,
> > then don't drop local events and you are good to go.
> > Is it something else?
>
> - If remote events are enabled, then idea will be that user space gets
>   and event when file is actually removed from server, right? Now it
>   is possible that another VM has this file open and file has not been
>   yet removed. So local event only tells you that file has been removed
>   in guest VM (or locally) but does not tell anything about the state
>   of file on server. (It has been unlinked on server but inode continues
>   to be alive internall).
>
> - If user receives both local and remote delete event, it will be
>   confusing. I guess if we want to see both the events, then there
>   has to be some sort of info in event which classifies whether event
>   is local or remote. And let application act accordingly.
>
> Thanks
> Vivek
>
>
Hello Amir!

Sorry for taking part in the conversation a bit late.  Vivek was on point
with the
example he gave but the race is a bit more generic than only the DELETE
event.

Let's say that a guest process monitors an inode for OPEN events:

1) The same guest process or another guest process opens the file (related
to the
monitored inode), and then closes and immediately deletes the file/inode.
2) The FUSE server (virtiofsd) will mimic the operations of the guest
process:
     a) Will open the file on the host side and thus a remote OPEN event is
going to
     be generated on the host and sent to the guest.
     b) Will unlink the remote inode and if no other host process uses the
inode then the
     inode will be freed and a DELETE event is going to be generated on the
host and sent
     to the guest (However, due to how virtiofsd works and Vivek mentioned,
this step won't
     happen immediately)

The problem here is that the OPEN event might still be travelling towards
the guest in the
virtqueues and arrives after the guest has already deleted its local inode.
While the remote event (OPEN) received by the guest is valid, its fsnotify
subsystem will drop it since the local inode is not there.

-- 
Ioannis Angelakopoulos
Software Engineer Intern at Red Hat

--00000000000060399c05cf464a55
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Oct 26, 2021 at 2:27 PM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com" target=3D"_blank">vgoyal@re=
dhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-le=
ft:1ex">On Tue, Oct 26, 2021 at 08:59:44PM +0300, Amir Goldstein wrote:<br>
&gt; On Tue, Oct 26, 2021 at 7:18 PM Vivek Goyal &lt;<a href=3D"mailto:vgoy=
al@redhat.com" target=3D"_blank">vgoyal@redhat.com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; On Tue, Oct 26, 2021 at 06:23:50PM +0300, Amir Goldstein wrote:<b=
r>
&gt; &gt;<br>
&gt; &gt; [..]<br>
&gt; &gt; &gt; &gt; 3) The lifetime of the local watch in the guest kernel =
is very<br>
&gt; &gt; &gt; &gt; important. Specifically, there is a possibility that th=
e guest does not<br>
&gt; &gt; &gt; &gt; receive remote events on time, if it removes its local =
watch on the<br>
&gt; &gt; &gt; &gt; target or deletes the inode (and thus the guest kernel =
removes the watch).<br>
&gt; &gt; &gt; &gt; In these cases the guest kernel removes the local watch=
 before the<br>
&gt; &gt; &gt; &gt; remote events arrive from the host (virtiofsd) and as s=
uch the guest<br>
&gt; &gt; &gt; &gt; kernel drops all the remote events for the target inode=
 (since the<br>
&gt; &gt; &gt; &gt; corresponding local watch does not exist anymore).<br>
&gt; &gt;<br>
&gt; &gt; So this is one of the issues which has been haunting us in virtio=
fs. If<br>
&gt; &gt; a file is removed, for local events, event is generated first and=
<br>
&gt; &gt; then watch is removed. But in case of remote filesystems, it is r=
acy.<br>
&gt; &gt; It is possible that by the time event arrives, watch is already g=
one<br>
&gt; &gt; and application never sees the delete event.<br>
&gt; &gt;<br>
&gt; &gt; Not sure how to address this issue.<br>
&gt; <br>
<br>
&gt; Can you take me through the scenario step by step.<br>
&gt; I am not sure I understand the exact sequence of the race.<br>
<br>
Ioannis, please correct me If I get something wrong. You know exact<br>
details much more than me.<br>
<br>
A. Say a guest process unlinks a file.<br>
B. Fuse sends an unlink request to server (virtiofsd)<br>
C. File is unlinked on host. Assume there are no other users so inode<br>
=C2=A0 =C2=A0will be freed as well. And event will be generated on host and=
 watch<br>
=C2=A0 =C2=A0removed.<br>
D. Now Fuse server will send a unlink request reply. unlink notification<br=
>
=C2=A0 =C2=A0might still be in kernel buffers or still be in virtiofsd or c=
ould<br>
=C2=A0 =C2=A0be in virtiofs virtqueue.<br>
E. Fuse client will receive unlink reply and remove local watch.<br><br></b=
lockquote><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Fuse reply and notification event are now traveling in parallel on<br>
different virtqueues and there is no connection between these two. And<br>
it could very well happen that fuse reply comes first, gets processed<br>
first and local watch is removed. And notification is processed right<br>
after but by then local watch is gone and filesystem will be forced to<br>
drop event.<br>
<br>
As of now situation is more complicated in virtiofsd. We don&#39;t keep<br>
file handle open for file and keep an O_PATH fd open for each file.<br>
That means in step D above, inode on host is not freed yet and unlink<br>
event is not generated yet. When unlink reply reaches fuse client,<br>
it sends FORGET messages to server, and then server closes O_PATH fd<br>
and then host generates unlink events. By that time its too late,<br>
guest has already remove local watches (and triggered removal of<br>
remote watches too).<br>
<br>
This second problem probably can be solved by using file handles, but<br>
basic race will still continue to be there.<br>
<br>
&gt; If it is local file removal that causes watch to be removed,<br>
&gt; then don&#39;t drop local events and you are good to go.<br>
&gt; Is it something else?<br>
<br>
- If remote events are enabled, then idea will be that user space gets<br>
=C2=A0 and event when file is actually removed from server, right? Now it<b=
r>
=C2=A0 is possible that another VM has this file open and file has not been=
<br>
=C2=A0 yet removed. So local event only tells you that file has been remove=
d<br>
=C2=A0 in guest VM (or locally) but does not tell anything about the state<=
br>
=C2=A0 of file on server. (It has been unlinked on server but inode continu=
es<br>
=C2=A0 to be alive internall).<br>
<br>
- If user receives both local and remote delete event, it will be<br>
=C2=A0 confusing. I guess if we want to see both the events, then there<br>
=C2=A0 has to be some sort of info in event which classifies whether event<=
br>
=C2=A0 is local or remote. And let application act accordingly.<br>
<br>
Thanks<br>
Vivek<br>
<br>
</blockquote></div><div><br>Hello Amir!=C2=A0</div><div><br></div><div>Sorr=
y for taking part in the conversation a bit late.=C2=A0 Vivek was on point =
with the</div><div>example he gave but the race is a bit more generic than =
only the DELETE event.</div><div><br></div><div>Let&#39;s say that a guest =
process monitors an inode for OPEN events:</div><div><br></div><div>1) The =
same guest process or another guest process opens the file (related to the<=
/div><div>monitored inode), and then closes and immediately deletes the fil=
e/inode.</div><div>2) The FUSE server (virtiofsd) will mimic the operations=
 of the guest process:</div><div>=C2=A0 =C2=A0 =C2=A0a) Will open the file =
on the host side and thus a remote OPEN event is going to=C2=A0</div><div>=
=C2=A0 =C2=A0 =C2=A0be generated on the host and sent to the guest.</div><d=
iv>=C2=A0 =C2=A0 =C2=A0b) Will unlink the remote inode and if no other host=
 process uses the inode then the</div><div>=C2=A0 =C2=A0 =C2=A0inode will b=
e freed and a DELETE event is going to be generated on the host and sent</d=
iv><div>=C2=A0 =C2=A0 =C2=A0to the guest (However, due to how virtiofsd=C2=
=A0works and Vivek mentioned, this step won&#39;t=C2=A0</div><div>=C2=A0 =
=C2=A0 =C2=A0happen immediately)</div><div><br></div><div>The problem here =
is that the OPEN event might still be travelling towards the guest in the</=
div><div>virtqueues and arrives after the guest has already deleted its loc=
al inode.=C2=A0</div><div>While the remote event (OPEN) received by the gue=
st is valid, its fsnotify</div><div>subsystem will drop it since the local =
inode is not there.</div><div><br></div>-- <br><div dir=3D"ltr"><div dir=3D=
"ltr">Ioannis Angelakopoulos<div>Software Engineer Intern at Red Hat</div><=
/div></div></div>

--00000000000060399c05cf464a55--

