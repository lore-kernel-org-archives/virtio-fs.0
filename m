DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=aVWMu4BQWRyHyd01ehyCVpNb0rwxHTCgoW7Sb+vyrGs=;
	b=nnflVOw1rYD89HVoVW59Wlh+vCmKjuZ2sBSWZmQya7EHHQe9a7V+J2qE/JCFTt25yx
	yr1tfzKFG7KvOnSZkUUQkLfIdBG+YqK136kIBadCgOTFCUkopvwKjJzJtJeThNduUY+4
	oKyQ1vV8IVFqFX1oCD9FNXcG3YlrtTt4G7TEUktkBfL/06k+ttW3P6L1CZtiEj2goEIS
	tKPdqkd9TTHdVeoPICBmPcV78o5pcTzyrtHO2XB5NTGzKa7V8qa5ytPGSFHQYVcgXiQj
	el6foHJV99w5hJ3hEEncZZ2tjLcSkLTe1G3xLtox0rkfT+kirIIHAA/GLq57JV71a11s
	t69g==
MIME-Version: 1.0
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<20201215162119.27360-10-zhangjiachen.jaycee@bytedance.com>
	<20210204121538.GH3039@work-vm>
In-Reply-To: <20210204121538.GH3039@work-vm>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Thu, 4 Feb 2021 22:20:05 +0800
Message-ID: <CAFQAk7jEsMD_FM0D+MyL4rzDPUOXsRpKw53nPmLoH_7-Tx3pDw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f54dbb05ba83661c"
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 9/9] virtiofsd: (work
 around) Comment qsort in inflight I/O tracking
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, QEMU <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>

--000000000000f54dbb05ba83661c
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 4, 2021 at 8:16 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> > This is a work around. The qsort function will malloc memory instead of
> use
> > stack memory when the resubmit_num is larger than 64 (total size larger
> than
> > 1024 Bytes). This will cause seccomp kill virtiofsd, so we comment qsort.
> > This work around will not affect the correctness of inflight I/O
> tracking.
> >
> > Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
> That's an odd hack!   Just follow the audit log to see what seccomp was
> upset by and add the right syscall.
>
> Dave
>
>
We recently found the cause is sysinfo (2). We will revert this and add
sysinfo to the
whitelist in the 2nd version patchset. Thanks!

Jiachen



> > ---
> >  contrib/libvhost-user/libvhost-user.c | 18 ------------------
> >  1 file changed, 18 deletions(-)
> >
> > diff --git a/contrib/libvhost-user/libvhost-user.c
> b/contrib/libvhost-user/libvhost-user.c
> > index 8c97013e59..c226d5d915 100644
> > --- a/contrib/libvhost-user/libvhost-user.c
> > +++ b/contrib/libvhost-user/libvhost-user.c
> > @@ -1167,20 +1167,6 @@ vu_check_queue_msg_file(VuDev *dev, VhostUserMsg
> *vmsg)
> >      return true;
> >  }
> >
> > -static int
> > -inflight_desc_compare(const void *a, const void *b)
> > -{
> > -    VuVirtqInflightDesc *desc0 = (VuVirtqInflightDesc *)a,
> > -                        *desc1 = (VuVirtqInflightDesc *)b;
> > -
> > -    if (desc1->counter > desc0->counter &&
> > -        (desc1->counter - desc0->counter) < VIRTQUEUE_MAX_SIZE * 2) {
> > -        return 1;
> > -    }
> > -
> > -    return -1;
> > -}
> > -
> >  static int
> >  vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
> >  {
> > @@ -1236,10 +1222,6 @@ vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
> >              }
> >          }
> >
> > -        if (vq->resubmit_num > 1) {
> > -            qsort(vq->resubmit_list, vq->resubmit_num,
> > -                  sizeof(VuVirtqInflightDesc), inflight_desc_compare);
> > -        }
> >          vq->counter = vq->resubmit_list[0].counter + 1;
> >      }
> >
> > --
> > 2.20.1
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>

--000000000000f54dbb05ba83661c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Feb 4, 2021 at 8:16 PM Dr. Da=
vid Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redhat=
.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">* Jiachen Zhang (<a href=3D"mailto:zhangjiachen.jaycee@bytedance.com" t=
arget=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>) wrote:<br>
&gt; This is a work around. The qsort function will malloc memory instead o=
f use<br>
&gt; stack memory when the resubmit_num is larger than 64 (total size large=
r than<br>
&gt; 1024 Bytes). This will cause seccomp kill virtiofsd, so we comment qso=
rt.<br>
&gt; This work around will not affect the correctness of inflight I/O track=
ing.<br>
&gt; <br>
&gt; Signed-off-by: Jiachen Zhang &lt;<a href=3D"mailto:zhangjiachen.jaycee=
@bytedance.com" target=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>&gt;=
<br>
&gt; Signed-off-by: Xie Yongji &lt;<a href=3D"mailto:xieyongji@bytedance.co=
m" target=3D"_blank">xieyongji@bytedance.com</a>&gt;<br>
<br>
That&#39;s an odd hack!=C2=A0 =C2=A0Just follow the audit log to see what s=
eccomp was<br>
upset by and add the right syscall.<br>
<br>
Dave<br>
<br></blockquote><div><br></div><div>We recently found the cause is sysinfo=
 (2). We will revert this and add sysinfo to the</div><div>whitelist in the=
 2nd version patchset. Thanks!</div><div><br></div><div>Jiachen</div><div><=
br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
>
&gt; ---<br>
&gt;=C2=A0 contrib/libvhost-user/libvhost-user.c | 18 ------------------<br=
>
&gt;=C2=A0 1 file changed, 18 deletions(-)<br>
&gt; <br>
&gt; diff --git a/contrib/libvhost-user/libvhost-user.c b/contrib/libvhost-=
user/libvhost-user.c<br>
&gt; index 8c97013e59..c226d5d915 100644<br>
&gt; --- a/contrib/libvhost-user/libvhost-user.c<br>
&gt; +++ b/contrib/libvhost-user/libvhost-user.c<br>
&gt; @@ -1167,20 +1167,6 @@ vu_check_queue_msg_file(VuDev *dev, VhostUserMs=
g *vmsg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 return true;<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -static int<br>
&gt; -inflight_desc_compare(const void *a, const void *b)<br>
&gt; -{<br>
&gt; -=C2=A0 =C2=A0 VuVirtqInflightDesc *desc0 =3D (VuVirtqInflightDesc *)a=
,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 *desc1 =3D (VuVirtqInflightDesc *)b;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (desc1-&gt;counter &gt; desc0-&gt;counter &amp;&amp;=
<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 (desc1-&gt;counter - desc0-&gt;counter) &=
lt; VIRTQUEUE_MAX_SIZE * 2) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 return -1;<br>
&gt; -}<br>
&gt; -<br>
&gt;=C2=A0 static int<br>
&gt;=C2=A0 vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)<br>
&gt;=C2=A0 {<br>
&gt; @@ -1236,10 +1222,6 @@ vu_check_queue_inflights(VuDev *dev, VuVirtq *v=
q)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (vq-&gt;resubmit_num &gt; 1) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 qsort(vq-&gt;resubmit_list,=
 vq-&gt;resubmit_num,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof=
(VuVirtqInflightDesc), inflight_desc_compare);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vq-&gt;counter =3D vq-&gt;resubmit_l=
ist[0].counter + 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -- <br>
&gt; 2.20.1<br>
&gt; <br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br>
</blockquote></div></div>

--000000000000f54dbb05ba83661c--

