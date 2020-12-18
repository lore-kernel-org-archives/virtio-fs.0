DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=tadUb1mLO1Y4dNiRanHmwmh3nmd+pPnI+tPV8J5UTEQ=;
	b=c+qgze8l6MKf28RZbY9eVfOqqeOjC/cf2IHhr6q3n+ODVv9Yr+5qVgThVAeTEJs+lM
	+0y+RWAgoKpdPfZNCkL/gqYvrt+O6ooxlA1MrhsXl/HydjBv/28XSOb3lliukVeGVjTN
	G56thtswjPziVblqJCI8unG1Cr13qoPajorLP/EmH3olBbc8aEqfl5fftK7mjQejbaSU
	hnHPiLcKNby91dC/x5OMMoUUT/K6FRlm/TnY6gI2J1ZMJLWmTC4HKFL4oFZbY+ei35vy
	JKUxxry6f2f0FETzN9+1cUegCEKkX5eaMFrVMYIBwlefZhdJ6Wcyh62O3xVicrRidYyQ
	WM3A==
MIME-Version: 1.0
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
In-Reply-To: <CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Fri, 18 Dec 2020 17:39:34 +0800
Message-ID: <CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000800f3e05b6b9e3bc"
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
	Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>

--000000000000800f3e05b6b9e3bc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2020 at 11:36 PM Marc-Andr=C3=A9 Lureau <
marcandre.lureau@gmail.com> wrote:

> Hi
>
> On Tue, Dec 15, 2020 at 8:22 PM Jiachen Zhang <
> zhangjiachen.jaycee@bytedance.com> wrote:
>
>> Hi, all
>>
>> We implement virtio-fs crash reconnection in this patchset. The crash
>> reconnection of virtiofsd here is completely transparent to guest, no
>> remount in guest is needed, even the inflight requests can be handled
>> normally after reconnection. We are looking forward to any comments.
>>
>> Thanks,
>> Jiachen
>>
>>
>> OVERVIEW:
>>
>> To support virtio-fs crash reconnection, we need to support the recovery
>> of 1) inflight FUSE request, and 2) virtiofsd internal status informatio=
n.
>>
>> Fortunately, QEMU's vhost-user reconnection framework already supports
>> inflight I/O tracking by using VHOST_USER_GET_INFLIGHT_FD and
>> VHOST_USER_SET_INFLIGHT_FD (see 5ad204bf2 and 5f9ff1eff for details).
>> As the FUSE requests are transferred by virtqueue I/O requests, by using
>> the vhost-user inflight I/O tracking, we can recover the inflight FUSE
>> requests.
>>
>> To support virtiofsd internal status recovery, we introduce 4 new
>> vhost-user message types. As shown in the following diagram, two of them
>> are used to persist shared lo_maps and opened fds to QEMU, the other two
>> message types are used to restore the status when reconnecting.
>>
>>                                VHOST_USER_SLAVE_SHM
>>                                VHOST_USER_SLAVE_FD
>>     +--------------+       Persist       +--------------------+
>>     |              <---------------------+                    |
>>     |     QEMU     |                     |  Virtio-fs Daemon  |
>>     |              +--------------------->                    |
>>     +--------------+       Restore       +--------------------+
>>             VHOST_USER_SET_SHM
>>             VHOST_USER_SET_FD
>>
>> Although the 4 newly added message types are to support virtiofsd
>> reconnection in this patchset, it might be potential in other situation.
>> So we keep in mind to make them more general when add them to vhost
>> related source files. VHOST_USER_SLAVE_SHM and VHOST_USER_SET_SHM can be
>> used for memory sharing between a vhost-user daemon and QEMU,
>> VHOST_USER_SLAVE_FD and VHOST_USER_SET_FD would be useful if we want to
>> shared opened fds between QEMU process and vhost-user daemon process.
>>
>
> Before adding new messages to the already complex vhost-user protocol, ca=
n
> we evaluate other options?
>
> First thing that came to my mind is that the memory state could be saved
> to disk or with a POSIX shared memory object.
>
>
Eventually, the protocol could just pass around the fds, and not make a
> special treatment for shared memory.
>
> Then I remember systemd has a pretty good API & protocol for this sort of
> thing: sd_notify(3) (afaik, it is quite easy to implement a minimal handl=
er)
>
> You can store fds with FDSTORE=3D1 (with an optional associated FDNAME).
> sd_listen_fds() & others to get them back (note: passed by inheritance on=
ly
> I think). systemd seems to not make shm a special case either, just treat
> it like an opened fd to restore.
>
> If we consider backend processes are going to be managed by libvirt or
> even a systemd service, is it a better alternative? sd_notify() offers a
> number of interesting features as well to monitor services.
>
>

Thanks for the suggestions. Actually, we choose to save all state
information to QEMU because a virtiofsd has the same lifecycle as its
QEMU master. However, saving things to a file do avoid communication with
QEMU, and we no longer need to increase the complexity of vhost-user
protocol. The suggestion to save fds to the systemd is also very reasonable
if we don't consider the lifecycle issues, we will try it.

All the best,
Jiachen



>>
>> USAGE and NOTES:
>>
>> - The commits are rebased to a recent QEMU master commit
>> b4d939133dca0fa2b.
>>
>> - ",reconnect=3D1" should be added to the "-chardev socket" of
>> vhost-user-fs-pci
>> in the QEMU command line, for example:
>>
>>     qemu-system-x86_64 ... \
>>     -chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu,reconnect=3D1 \
>>     -device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmy=
fs \
>>     ...
>>
>> - We add new options for virtiofsd to enable or disable crash
>> reconnection.
>> And some options are not supported by crash reconnection. So add followi=
ng
>> options to virtiofsd to enable reconnection:
>>
>>     virtiofsd ... -o reconnect -o no_mount_ns -o no_flock -o no_posix_lo=
ck
>>     -o no_xattr ...
>>
>> - The reasons why virtiofsd-side locking, extended attributes, and mount
>> namespace are not supported is explained in the commit message of the 6t=
h
>> patch (virtiofsd: Add two new options for crash reconnection).
>>
>> - The 9th patch is a work-around that will not affect the overall
>> correctness.
>> We remove the qsort related codes because we found that when resubmit_nu=
m
>> is
>> larger than 64, seccomp will kill the virtiofsd process.
>>
>> - Support for dax version virtiofsd is very possible and requires almost
>> no
>> additional change to this patchset.
>>
>>
>> Jiachen Zhang (9):
>>   vhost-user-fs: Add support for reconnection of vhost-user-fs backend
>>   vhost: Add vhost-user message types for sending shared memory and file
>>     fds
>>   vhost-user-fs: Support virtiofsd crash reconnection
>>   libvhost-user: Add vhost-user message types for sending shared memory
>>     and file fds
>>   virtiofsd: Convert the struct lo_map array to a more flatten layout
>>   virtiofsd: Add two new options for crash reconnection
>>   virtiofsd: Persist/restore lo_map and opened fds to/from QEMU
>>   virtiofsd: Ensure crash consistency after reconnection
>>   virtiofsd: (work around) Comment qsort in inflight I/O tracking
>>
>>  contrib/libvhost-user/libvhost-user.c | 106 +++-
>>  contrib/libvhost-user/libvhost-user.h |  70 +++
>>  docs/interop/vhost-user.rst           |  41 ++
>>  hw/virtio/vhost-user-fs.c             | 334 ++++++++++-
>>  hw/virtio/vhost-user.c                | 123 ++++
>>  hw/virtio/vhost.c                     |  42 ++
>>  include/hw/virtio/vhost-backend.h     |   6 +
>>  include/hw/virtio/vhost-user-fs.h     |  16 +-
>>  include/hw/virtio/vhost.h             |  42 ++
>>  tools/virtiofsd/fuse_lowlevel.c       |  24 +-
>>  tools/virtiofsd/fuse_virtio.c         |  44 ++
>>  tools/virtiofsd/fuse_virtio.h         |   1 +
>>  tools/virtiofsd/helper.c              |   9 +
>>  tools/virtiofsd/passthrough_helpers.h |   2 +-
>>  tools/virtiofsd/passthrough_ll.c      | 830 ++++++++++++++++++--------
>>  tools/virtiofsd/passthrough_seccomp.c |   1 +
>>  16 files changed, 1413 insertions(+), 278 deletions(-)
>>
>> --
>> 2.20.1
>>
>>
>>
>
> --
> Marc-Andr=C3=A9 Lureau
>

--000000000000800f3e05b6b9e3bc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Wed, Dec 16, 2020 at 11:36 PM Marc=
-Andr=C3=A9 Lureau &lt;<a href=3D"mailto:marcandre.lureau@gmail.com">marcan=
dre.lureau@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex"><div dir=3D"ltr"><div dir=3D"ltr">Hi<br></div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Dec 15,=
 2020 at 8:22 PM Jiachen Zhang &lt;<a href=3D"mailto:zhangjiachen.jaycee@by=
tedance.com" target=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>&gt; wr=
ote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi, all<br>
<br>
We implement virtio-fs crash reconnection in this patchset. The crash<br>
reconnection of virtiofsd here is completely transparent to guest, no<br>
remount in guest is needed, even the inflight requests can be handled<br>
normally after reconnection. We are looking forward to any comments. <br>
<br>
Thanks,<br>
Jiachen<br>
<br>
<br>
OVERVIEW:<br>
<br>
To support virtio-fs crash reconnection, we need to support the recovery<br=
>
of 1) inflight FUSE request, and 2) virtiofsd internal status information.<=
br>
<br>
Fortunately, QEMU&#39;s vhost-user reconnection framework already supports<=
br>
inflight I/O tracking by using VHOST_USER_GET_INFLIGHT_FD and<br>
VHOST_USER_SET_INFLIGHT_FD (see 5ad204bf2 and 5f9ff1eff for details).<br>
As the FUSE requests are transferred by virtqueue I/O requests, by using<br=
>
the vhost-user inflight I/O tracking, we can recover the inflight FUSE<br>
requests.<br>
<br>
To support virtiofsd internal status recovery, we introduce 4 new<br>
vhost-user message types. As shown in the following diagram, two of them<br=
>
are used to persist shared lo_maps and opened fds to QEMU, the other two<br=
>
message types are used to restore the status when reconnecting.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VHOST_USER_SLAVE_SHM<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VHOST_USER_SLAVE_FD<br>
=C2=A0 =C2=A0 +--------------+=C2=A0 =C2=A0 =C2=A0 =C2=A0Persist=C2=A0 =C2=
=A0 =C2=A0 =C2=A0+--------------------+<br>
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;-------=
--------------+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0QEMU=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 Virti=
o-fs Daemon=C2=A0 |<br>
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +----------=
-----------&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 +--------------+=C2=A0 =C2=A0 =C2=A0 =C2=A0Restore=C2=A0 =C2=
=A0 =C2=A0 =C2=A0+--------------------+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 VHOST_USER_SET_SHM<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 VHOST_USER_SET_FD<br>
<br>
Although the 4 newly added message types are to support virtiofsd<br>
reconnection in this patchset, it might be potential in other situation.<br=
>
So we keep in mind to make them more general when add them to vhost<br>
related source files. VHOST_USER_SLAVE_SHM and VHOST_USER_SET_SHM can be<br=
>
used for memory sharing between a vhost-user daemon and QEMU,<br>
VHOST_USER_SLAVE_FD and VHOST_USER_SET_FD would be useful if we want to<br>
shared opened fds between QEMU process and vhost-user daemon process.<br></=
blockquote><div><br></div><div>Before adding new messages to the already co=
mplex vhost-user protocol, can we evaluate other options?</div><div><br></d=
iv><div>First thing that came to my mind is that the memory state could be =
saved to disk or with a POSIX shared memory object.</div><div>=C2=A0<br></d=
iv></div></div></blockquote><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x"><div dir=3D"ltr"><div class=3D"gmail_quote"><div></div><div>Eventually, =
the protocol could just pass around the fds, and not make a special treatme=
nt for shared memory.</div><div><br></div><div>Then I remember systemd has =
a pretty good API &amp; protocol for this sort of thing: sd_notify(3) (afai=
k, it is quite easy to implement a minimal handler)</div><div><br></div><di=
v>You can store fds with <span>FDSTORE=3D1 (with an optional associated <sp=
an>FDNAME). sd_listen_fds() &amp; others to get them back (note: passed by =
inheritance only I think). systemd seems to not make shm a special case eit=
her, just treat it like an opened fd to restore. <br></span></span></div><d=
iv><span><span><br></span></span></div><div>If we consider backend processe=
s are going to be managed by libvirt or even a systemd service, is it a bet=
ter alternative? sd_notify() offers a number of interesting features as wel=
l to monitor services.<br></div><div><br></div></div></div></blockquote><di=
v><br></div><div><br></div><div><div>Thanks for the suggestions. Actually, =
we choose to save all state information to QEMU because a virtiofsd has the=
 same lifecycle as its QEMU=C2=A0master. However, saving things to a file d=
o avoid=C2=A0communication with QEMU, and we no longer need to increase the=
 complexity of vhost-user protocol. The suggestion to save fds to the syste=
md is also very reasonable if we don&#39;t consider the lifecycle issues, w=
e will try it.</div></div><div><br></div><div>All the best,</div><div>Jiach=
en</div><div><br></div><div><br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex"><div dir=3D"ltr"><div class=3D"gmail_quote"><div></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex">
<br>
<br>
USAGE and NOTES:<br>
<br>
- The commits are rebased to a recent QEMU master commit b4d939133dca0fa2b.=
<br>
<br>
- &quot;,reconnect=3D1&quot; should be added to the &quot;-chardev socket&q=
uot; of vhost-user-fs-pci<br>
in the QEMU command line, for example:<br>
<br>
=C2=A0 =C2=A0 qemu-system-x86_64 ... \<br>
=C2=A0 =C2=A0 -chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu,reconnect=3D=
1 \<br>
=C2=A0 =C2=A0 -device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,t=
ag=3Dmyfs \<br>
=C2=A0 =C2=A0 ...<br>
<br>
- We add new options for virtiofsd to enable or disable crash reconnection.=
<br>
And some options are not supported by crash reconnection. So add following<=
br>
options to virtiofsd to enable reconnection:<br>
<br>
=C2=A0 =C2=A0 virtiofsd ... -o reconnect -o no_mount_ns -o no_flock -o no_p=
osix_lock<br>
=C2=A0 =C2=A0 -o no_xattr ...<br>
<br>
- The reasons why virtiofsd-side locking, extended attributes, and mount<br=
>
namespace are not supported is explained in the commit message of the 6th<b=
r>
patch (virtiofsd: Add two new options for crash reconnection).<br>
<br>
- The 9th patch is a work-around that will not affect the overall correctne=
ss.<br>
We remove the qsort related codes because we found that when resubmit_num i=
s<br>
larger than 64, seccomp will kill the virtiofsd process.<br>
<br>
- Support for dax version virtiofsd is very possible and requires almost no=
<br>
additional change to this patchset.<br>
<br>
<br>
Jiachen Zhang (9):<br>
=C2=A0 vhost-user-fs: Add support for reconnection of vhost-user-fs backend=
<br>
=C2=A0 vhost: Add vhost-user message types for sending shared memory and fi=
le<br>
=C2=A0 =C2=A0 fds<br>
=C2=A0 vhost-user-fs: Support virtiofsd crash reconnection<br>
=C2=A0 libvhost-user: Add vhost-user message types for sending shared memor=
y<br>
=C2=A0 =C2=A0 and file fds<br>
=C2=A0 virtiofsd: Convert the struct lo_map array to a more flatten layout<=
br>
=C2=A0 virtiofsd: Add two new options for crash reconnection<br>
=C2=A0 virtiofsd: Persist/restore lo_map and opened fds to/from QEMU<br>
=C2=A0 virtiofsd: Ensure crash consistency after reconnection<br>
=C2=A0 virtiofsd: (work around) Comment qsort in inflight I/O tracking<br>
<br>
=C2=A0contrib/libvhost-user/libvhost-user.c | 106 +++-<br>
=C2=A0contrib/libvhost-user/libvhost-user.h |=C2=A0 70 +++<br>
=C2=A0docs/interop/vhost-user.rst=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 41 ++<br>
=C2=A0hw/virtio/vhost-user-fs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 334 ++++++++++-<br>
=C2=A0hw/virtio/vhost-user.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 123 ++++<br>
=C2=A0hw/virtio/vhost.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 42 ++<br>
=C2=A0include/hw/virtio/vhost-backend.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A06 =
+<br>
=C2=A0include/hw/virtio/vhost-user-fs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 16 +-<br=
>
=C2=A0include/hw/virtio/vhost.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 42 ++<br>
=C2=A0tools/virtiofsd/fuse_lowlevel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 24 =
+-<br>
=C2=A0tools/virtiofsd/fuse_virtio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 44 ++<br>
=C2=A0tools/virtiofsd/fuse_virtio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 =C2=A01 +<br>
=C2=A0tools/virtiofsd/helper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A09 +<br>
=C2=A0tools/virtiofsd/passthrough_helpers.h |=C2=A0 =C2=A02 +-<br>
=C2=A0tools/virtiofsd/passthrough_ll.c=C2=A0 =C2=A0 =C2=A0 | 830 ++++++++++=
++++++++--------<br>
=C2=A0tools/virtiofsd/passthrough_seccomp.c |=C2=A0 =C2=A01 +<br>
=C2=A016 files changed, 1413 insertions(+), 278 deletions(-)<br>
<br>
-- <br>
2.20.1<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr">Marc-Andr=
=C3=A9 Lureau<br></div></div>
</blockquote></div></div>

--000000000000800f3e05b6b9e3bc--

