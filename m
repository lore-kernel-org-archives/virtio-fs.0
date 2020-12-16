DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=9fnpAvE5cvx4psKZfIgT8ea/t2bWC5A1iyXueQ+Z9O4=;
	b=OyOeWRA9kTPuYNqgEcwYn1Doim9ZU0+vSe6vc8txT/56OyARIqyW9J65BOSkr0sh8q
	AF5MB/FnyFjuWvg4VufJtu7tUfc0R0RNhYW4x2rbr/dxhn1Z7QSNkmB5OK8NMPvdfyma
	3XrdLrRtFbKidSbeevAyGklKa8nN90RbKCDDxV4A9YwuofO4mlDG7Da/EAbVo+s9LL6D
	URPpK0k8Ujyd7sC0aRM2yQaVtrtSM6g4Fr9bMWjyMMFCFrqSMy3FcmeSqdbg3Nq44sRA
	XHb6PGR6NjjC40m3HjCcWb/45PNtQ4chbKhLxAALEIg2GeacCchbf4NxkVWmfzgEpJl2
	6n/g==
MIME-Version: 1.0
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Wed, 16 Dec 2020 19:36:40 +0400
Message-ID: <CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000ecc9c805b696a4f4"
Subject: Re: [Virtio-fs] [RFC PATCH 0/9] Support for Virtio-fs daemon crash
	reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>

--000000000000ecc9c805b696a4f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Tue, Dec 15, 2020 at 8:22 PM Jiachen Zhang <
zhangjiachen.jaycee@bytedance.com> wrote:

> Hi, all
>
> We implement virtio-fs crash reconnection in this patchset. The crash
> reconnection of virtiofsd here is completely transparent to guest, no
> remount in guest is needed, even the inflight requests can be handled
> normally after reconnection. We are looking forward to any comments.
>
> Thanks,
> Jiachen
>
>
> OVERVIEW:
>
> To support virtio-fs crash reconnection, we need to support the recovery
> of 1) inflight FUSE request, and 2) virtiofsd internal status information=
.
>
> Fortunately, QEMU's vhost-user reconnection framework already supports
> inflight I/O tracking by using VHOST_USER_GET_INFLIGHT_FD and
> VHOST_USER_SET_INFLIGHT_FD (see 5ad204bf2 and 5f9ff1eff for details).
> As the FUSE requests are transferred by virtqueue I/O requests, by using
> the vhost-user inflight I/O tracking, we can recover the inflight FUSE
> requests.
>
> To support virtiofsd internal status recovery, we introduce 4 new
> vhost-user message types. As shown in the following diagram, two of them
> are used to persist shared lo_maps and opened fds to QEMU, the other two
> message types are used to restore the status when reconnecting.
>
>                                VHOST_USER_SLAVE_SHM
>                                VHOST_USER_SLAVE_FD
>     +--------------+       Persist       +--------------------+
>     |              <---------------------+                    |
>     |     QEMU     |                     |  Virtio-fs Daemon  |
>     |              +--------------------->                    |
>     +--------------+       Restore       +--------------------+
>             VHOST_USER_SET_SHM
>             VHOST_USER_SET_FD
>
> Although the 4 newly added message types are to support virtiofsd
> reconnection in this patchset, it might be potential in other situation.
> So we keep in mind to make them more general when add them to vhost
> related source files. VHOST_USER_SLAVE_SHM and VHOST_USER_SET_SHM can be
> used for memory sharing between a vhost-user daemon and QEMU,
> VHOST_USER_SLAVE_FD and VHOST_USER_SET_FD would be useful if we want to
> shared opened fds between QEMU process and vhost-user daemon process.
>

Before adding new messages to the already complex vhost-user protocol, can
we evaluate other options?

First thing that came to my mind is that the memory state could be saved to
disk or with a POSIX shared memory object.

Eventually, the protocol could just pass around the fds, and not make a
special treatment for shared memory.

Then I remember systemd has a pretty good API & protocol for this sort of
thing: sd_notify(3) (afaik, it is quite easy to implement a minimal handler=
)

You can store fds with FDSTORE=3D1 (with an optional associated FDNAME).
sd_listen_fds() & others to get them back (note: passed by inheritance only
I think). systemd seems to not make shm a special case either, just treat
it like an opened fd to restore.

If we consider backend processes are going to be managed by libvirt or even
a systemd service, is it a better alternative? sd_notify() offers a number
of interesting features as well to monitor services.


>
> USAGE and NOTES:
>
> - The commits are rebased to a recent QEMU master commit b4d939133dca0fa2=
b.
>
> - ",reconnect=3D1" should be added to the "-chardev socket" of
> vhost-user-fs-pci
> in the QEMU command line, for example:
>
>     qemu-system-x86_64 ... \
>     -chardev socket,id=3Dchar0,path=3D/tmp/vhostqemu,reconnect=3D1 \
>     -device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmyf=
s \
>     ...
>
> - We add new options for virtiofsd to enable or disable crash reconnectio=
n.
> And some options are not supported by crash reconnection. So add followin=
g
> options to virtiofsd to enable reconnection:
>
>     virtiofsd ... -o reconnect -o no_mount_ns -o no_flock -o no_posix_loc=
k
>     -o no_xattr ...
>
> - The reasons why virtiofsd-side locking, extended attributes, and mount
> namespace are not supported is explained in the commit message of the 6th
> patch (virtiofsd: Add two new options for crash reconnection).
>
> - The 9th patch is a work-around that will not affect the overall
> correctness.
> We remove the qsort related codes because we found that when resubmit_num
> is
> larger than 64, seccomp will kill the virtiofsd process.
>
> - Support for dax version virtiofsd is very possible and requires almost =
no
> additional change to this patchset.
>
>
> Jiachen Zhang (9):
>   vhost-user-fs: Add support for reconnection of vhost-user-fs backend
>   vhost: Add vhost-user message types for sending shared memory and file
>     fds
>   vhost-user-fs: Support virtiofsd crash reconnection
>   libvhost-user: Add vhost-user message types for sending shared memory
>     and file fds
>   virtiofsd: Convert the struct lo_map array to a more flatten layout
>   virtiofsd: Add two new options for crash reconnection
>   virtiofsd: Persist/restore lo_map and opened fds to/from QEMU
>   virtiofsd: Ensure crash consistency after reconnection
>   virtiofsd: (work around) Comment qsort in inflight I/O tracking
>
>  contrib/libvhost-user/libvhost-user.c | 106 +++-
>  contrib/libvhost-user/libvhost-user.h |  70 +++
>  docs/interop/vhost-user.rst           |  41 ++
>  hw/virtio/vhost-user-fs.c             | 334 ++++++++++-
>  hw/virtio/vhost-user.c                | 123 ++++
>  hw/virtio/vhost.c                     |  42 ++
>  include/hw/virtio/vhost-backend.h     |   6 +
>  include/hw/virtio/vhost-user-fs.h     |  16 +-
>  include/hw/virtio/vhost.h             |  42 ++
>  tools/virtiofsd/fuse_lowlevel.c       |  24 +-
>  tools/virtiofsd/fuse_virtio.c         |  44 ++
>  tools/virtiofsd/fuse_virtio.h         |   1 +
>  tools/virtiofsd/helper.c              |   9 +
>  tools/virtiofsd/passthrough_helpers.h |   2 +-
>  tools/virtiofsd/passthrough_ll.c      | 830 ++++++++++++++++++--------
>  tools/virtiofsd/passthrough_seccomp.c |   1 +
>  16 files changed, 1413 insertions(+), 278 deletions(-)
>
> --
> 2.20.1
>
>
>

--=20
Marc-Andr=C3=A9 Lureau

--000000000000ecc9c805b696a4f4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi<br></div><br><div class=3D"gmail_quote=
"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Dec 15, 2020 at 8:22 PM Jia=
chen Zhang &lt;<a href=3D"mailto:zhangjiachen.jaycee@bytedance.com">zhangji=
achen.jaycee@bytedance.com</a>&gt; wrote:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">Hi, all<br>
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
saved to disk or with a POSIX shared memory object.</div><div><br></div><di=
v>Eventually, the protocol could just pass around the fds, and not make a s=
pecial treatment for shared memory.</div><div><br></div><div>Then I remembe=
r systemd has a pretty good API &amp; protocol for this sort of thing: sd_n=
otify(3) (afaik, it is quite easy to implement a minimal handler)</div><div=
><br></div><div>You can store fds with <span class=3D"gmail-term">FDSTORE=
=3D1 (with an optional associated <span class=3D"gmail-term">FDNAME). sd_li=
sten_fds() &amp; others to get them back (note: passed by inheritance only =
I think). systemd seems to not make shm a special case either, just treat i=
t like an opened fd to restore. <br></span></span></div><div><span class=3D=
"gmail-term"><span class=3D"gmail-term"><br></span></span></div><div>If we =
consider backend processes are going to be managed by libvirt or even a sys=
temd service, is it a better alternative? sd_notify() offers a number of in=
teresting features as well to monitor services.<br></div><div> <br></div><b=
lockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-le=
ft:1px solid rgb(204,204,204);padding-left:1ex">
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
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature">Marc-Andr=C3=A9 Lureau<br></div></div>

--000000000000ecc9c805b696a4f4--

