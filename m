DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=m5GDNlZImjcNOmlN8PS6z2t7dHZKU1pm0yP/krGV/fM=;
	b=IvxJ0L0/WOHgkgtNL8C42ZuGGH1X1AubOMqlQzxIUOaLiwVf6SDzSMJmikwVXUWZXY
	i/1T2uPGd3Qo1bTYzqLHtDwSM1/srF+tCl7XETVXPkR2zsZ+/WGfoQ3Y0iU8HESKOG6i
	OIR3WaWYpApLpFvy4OcFUhDzrko8fkYbRXZEWUOd1CGcVgsxyQszaz0i5sYFX3gMfO+x
	K/qvJDbswcolv71OESAV+P933tt5ao7RagfeQyP0B5vOma44ynFuYsPy/UgdszDPlS6y
	XILEA17H2P7FdVghjLbRu3t0E5FAQp37SuW7vKiOFnav+7OWK0vCb37ezf3kfY6UWyvE
	uItg==
MIME-Version: 1.0
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
	<YIfmaleNOwhLLD9W@work-vm>
	<CAD-LL6gvoz0t4UND-CNdazciFoFE6ZVJ8ncZbfM3b37c8ECzbw@mail.gmail.com>
	<YIfu9eV41U6vT6iP@work-vm>
In-Reply-To: <YIfu9eV41U6vT6iP@work-vm>
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 27 Apr 2021 13:08:39 +0200
Message-ID: <CAD-LL6gCTagzmR-NXZiBTJH+LOH0D4wHigVow1e0bVfyVcm4PQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000007a90ee05c0f24997"
Subject: Re: [Virtio-fs] [PATCH v2 2/7] virtiofds: Changed allocations of
	iovec to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, qemu-devel@nongnu.org

--0000000000007a90ee05c0f24997
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 27, 2021 at 1:01 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert <
> dgilbert@redhat.com>
> > wrote:
> >
> > > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > > Replaced the calls to malloc()/calloc() and their respective
> > > > calls to free() of iovec structs with GLib's allocation and
> > > > deallocation functions.
> > > >
> > > > Also, in one instance, used g_new0() instead of a calloc() call plus
> > > > a null-checking assertion.
> > > >
> > > > iovec structs were created locally and freed as the function
> > > > ends. Hence, I used g_autofree and removed the respective calls to
> > > > free().
> > > >
> > > > In one instance, a struct fuse_ioctl_iovec pointer is returned from a
> > > > function, namely, fuse_ioctl_iovec_copy. There, I used
> g_steal_pointer()
> > > > in conjunction with g_autofree, this gives the ownership of the
> pointer
> > > > to the calling function and still auto-frees the memory when the
> calling
> > > > function finishes (maintaining the symantics of previous code).
> > > >
> > > > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > ---
> > > >  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
> > > >  tools/virtiofsd/fuse_virtio.c   |  6 +-----
> > > >  2 files changed, 8 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/tools/virtiofsd/fuse_lowlevel.c
> > > b/tools/virtiofsd/fuse_lowlevel.c
> > > > index 812cef6ef6..f965299ad9 100644
> > > > --- a/tools/virtiofsd/fuse_lowlevel.c
> > > > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > > > @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error,
> > > const void *arg,
> > > >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int
> count)
> > > >  {
> > > >      int res;
> > > > -    struct iovec *padded_iov;
> > > > +    g_autofree struct iovec *padded_iov;
> > > >
> > > > -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> > > > +    padded_iov = g_try_new(struct iovec, count + 1);
> > > >      if (padded_iov == NULL) {
> > > >          return fuse_reply_err(req, ENOMEM);
> > > >      }
> > > > @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const struct
> > > iovec *iov, int count)
> > > >      count++;
> > > >
> > > >      res = send_reply_iov(req, 0, padded_iov, count);
> > > > -    free(padded_iov);
> > > >
> > > >      return res;
> > > >  }
> > >
> > > OK.
> > >
> > > > @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, uint64_t
> idx)
> > > >  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct
> > > iovec *iov,
> > > >                                                        size_t count)
> > > >  {
> > > > -    struct fuse_ioctl_iovec *fiov;
> > > > +    g_autofree struct fuse_ioctl_iovec *fiov;
> > > >      size_t i;
> > > >
> > > > -    fiov = malloc(sizeof(fiov[0]) * count);
> > > > +    fiov = g_try_new(fuse_ioctl_iovec, count);
> > > >      if (!fiov) {
> > > >          return NULL;
> > > >      }
> > > > @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec
> > > *fuse_ioctl_iovec_copy(const struct iovec *iov,
> > > >          fiov[i].len = iov[i].iov_len;
> > > >      }
> > > >
> > > > -    return fiov;
> > > > +    return g_steal_pointer(&fiov);
> > > >  }
> > >
> > > This is OK, but doesn't gain anything - marking it as g_autofree'ing
> and
> > > always stealing is no benefit.
> > >
> > > >
> > > >  int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec
> *in_iov,
> > > > @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const
> > > struct iovec *in_iov,
> > > >
> > > >      res = send_reply_iov(req, 0, iov, count);
> > > >  out:
> > > > -    free(in_fiov);
> > > > -    free(out_fiov);
> > > > -
> > >
> > > I don't think you can do that - I think you're relying here on the
> > > g_autofree from fuse_ioclt_iovec_copy - but my understanding is that
> > > doesn't work; g_autofree is scoped, so it's designed to free at the end
> > > of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn't know that the
> > > ion_fiov were allocated that way, so it won't get autocleaned up.
> > >
> > >
> > In GLib's documentation, it is clarified (w.r.t. g_autoptr but I think
> > similar logic applies to g_autofree)
> > that g_steal_pointer() "This can be very useful when combined with
> > g_autoptr() to prevent
> > the return value of a function from being automatically freed."
> > I think, but not 100% clear of course, that this means that the
> > g_autoptr-annotated memory
> > does not get freed at the end of the current scope, and  its "scope" is
> > migrated to the calling
> > function(to be honest I don't know how would they implement that but
> maybe
> > this is the case).
> > Otherwise why bother with g_autoptr'ing memory that we don't want to free
> > automatically and
> > would like to return to the calling function?
> >
> > The first example in Memory Allocation: GLib Reference Manual (gnome.org
> )
> > <
> https://developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointer
> >
> > does
> > annotate
> > the memory as g_autoptr and then returns it through g_steal_pointer. With
> > your logic, I think that
> > this example would be wrong(?)
>
> The example is correct but not quite the case you have;  the
> g_steal_pointer stops the g_autoptr freeing it at the end of the current
> scope; but it doesn't cause it to be free'd later - the caller can't
> tell that the function that did the allocation had a g_autofree in it;
> once you get outside of the function, the pointer is just a normal
> pointer that needs free or g_free on.
>
> I think that this is logical, yes. I think that I understand now. Can you
please instruct
me on what to do with the patch? Do you want me to resend the entire patch
series
and amend this one?


>
> > Mr. Hajnoczi already reviewed this patch  Re: [PATCH 2/8] virtiofds:
> > Changed allocations of iovec to GLib's functi
> > <https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg08459.html>
> > in a previous version and this v2 patch series is supposed to only
> contain
> > already-reviewed patches and
> > remove bad ones
>
> But he didn't spot this particular problem.
>
> Dave
>
> >
> > > >      return res;
> > > >
> > > >  enomem:
> > > > @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int
> result,
> > > const void *buf, size_t size)
> > > >  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct
> iovec
> > > *iov,
> > > >                           int count)
> > > >  {
> > > > -    struct iovec *padded_iov;
> > > > +    g_autofree struct iovec *padded_iov;
> > > >      struct fuse_ioctl_out arg;
> > > >      int res;
> > > >
> > > > -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> > > > +    padded_iov = g_try_new(struct iovec, count + 2);
> > > >      if (padded_iov == NULL) {
> > > >          return fuse_reply_err(req, ENOMEM);
> > > >      }
> > > > @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int
> result,
> > > const struct iovec *iov,
> > > >      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
> > > >
> > > >      res = send_reply_iov(req, 0, padded_iov, count + 2);
> > > > -    free(padded_iov);
> > > >
> > > >      return res;
> > > >  }
> > >
> > > OK
> > >
> > > > diff --git a/tools/virtiofsd/fuse_virtio.c
> > > b/tools/virtiofsd/fuse_virtio.c
> > > > index 3e13997406..07e5d91a9f 100644
> > > > --- a/tools/virtiofsd/fuse_virtio.c
> > > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > > @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session *se,
> > > struct fuse_chan *ch,
> > > >       * Build a copy of the the in_sg iov so we can skip bits in it,
> > > >       * including changing the offsets
> > > >       */
> > > > -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec), in_num);
> > > > -    assert(in_sg_cpy);
> > > > +    g_autofree struct iovec *in_sg_cpy = g_new0(struct iovec,
> in_num);
> > > >      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
> > > >      /* These get updated as we skip */
> > > >      struct iovec *in_sg_ptr = in_sg_cpy;
> > > > @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session *se,
> > > struct fuse_chan *ch,
> > > >              ret = errno;
> > > >              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m)
> len=%zd\n",
> > > >                       __func__, len);
> > > > -            free(in_sg_cpy);
> > > >              goto err;
> > > >          }
> > > >          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n",
> > > __func__,
> > > > @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct fuse_session
> *se,
> > > struct fuse_chan *ch,
> > > >          if (ret != len) {
> > > >              fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
> > > >              ret = EIO;
> > > > -            free(in_sg_cpy);
> > > >              goto err;
> > > >          }
> > > >          in_sg_left -= ret;
> > > >          len -= ret;
> > > >      } while (in_sg_left);
> > > > -    free(in_sg_cpy);
> > >
> > > Yes, this is where the autofree really helps; getting rid of a few
> > > free's.
> > >
> > > Dave
> > >
> > > >      /* Need to fix out->len on EOF */
> > > >      if (len) {
> > > > --
> > > > 2.25.1
> > > >
> > > --
> > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > >
> > >
> > Thanks,
> > Mahmoud
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>
Thanks,
Mahmoud

--0000000000007a90ee05c0f24997
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Apr 27, 2021 at 1:01 PM Dr. D=
avid Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redha=
t.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">* Mahmoud Mandour (<a href=3D"mailto:ma.mandourr@gmail.com" target=3D"=
_blank">ma.mandourr@gmail.com</a>) wrote:<br>
&gt; On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert &lt;<a href=3D=
"mailto:dgilbert@redhat.com" target=3D"_blank">dgilbert@redhat.com</a>&gt;<=
br>
&gt; wrote:<br>
&gt; <br>
&gt; &gt; * Mahmoud Mandour (<a href=3D"mailto:ma.mandourr@gmail.com" targe=
t=3D"_blank">ma.mandourr@gmail.com</a>) wrote:<br>
&gt; &gt; &gt; Replaced the calls to malloc()/calloc() and their respective=
<br>
&gt; &gt; &gt; calls to free() of iovec structs with GLib&#39;s allocation =
and<br>
&gt; &gt; &gt; deallocation functions.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Also, in one instance, used g_new0() instead of a calloc() c=
all plus<br>
&gt; &gt; &gt; a null-checking assertion.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; iovec structs were created locally and freed as the function=
<br>
&gt; &gt; &gt; ends. Hence, I used g_autofree and removed the respective ca=
lls to<br>
&gt; &gt; &gt; free().<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; In one instance, a struct fuse_ioctl_iovec pointer is return=
ed from a<br>
&gt; &gt; &gt; function, namely, fuse_ioctl_iovec_copy. There, I used g_ste=
al_pointer()<br>
&gt; &gt; &gt; in conjunction with g_autofree, this gives the ownership of =
the pointer<br>
&gt; &gt; &gt; to the calling function and still auto-frees the memory when=
 the calling<br>
&gt; &gt; &gt; function finishes (maintaining the symantics of previous cod=
e).<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Signed-off-by: Mahmoud Mandour &lt;<a href=3D"mailto:ma.mand=
ourr@gmail.com" target=3D"_blank">ma.mandourr@gmail.com</a>&gt;<br>
&gt; &gt; &gt; Reviewed-by: Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@=
redhat.com" target=3D"_blank">stefanha@redhat.com</a>&gt;<br>
&gt; &gt; &gt; ---<br>
&gt; &gt; &gt;=C2=A0 tools/virtiofsd/fuse_lowlevel.c | 19 +++++++----------=
--<br>
&gt; &gt; &gt;=C2=A0 tools/virtiofsd/fuse_virtio.c=C2=A0 =C2=A0|=C2=A0 6 +-=
----<br>
&gt; &gt; &gt;=C2=A0 2 files changed, 8 insertions(+), 17 deletions(-)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; diff --git a/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; b/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; index 812cef6ef6..f965299ad9 100644<br>
&gt; &gt; &gt; --- a/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; +++ b/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, in=
t error,<br>
&gt; &gt; const void *arg,<br>
&gt; &gt; &gt;=C2=A0 int fuse_reply_iov(fuse_req_t req, const struct iovec =
*iov, int count)<br>
&gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 1) * sizeof(st=
ruct iovec));<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iovec, count =
+ 1);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_reply_err(req,=
 ENOMEM);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const=
 struct<br>
&gt; &gt; iovec *iov, int count)<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 count++;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, padded_io=
v, count);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; OK.<br>
&gt; &gt;<br>
&gt; &gt; &gt; @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, ui=
nt64_t idx)<br>
&gt; &gt; &gt;=C2=A0 static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(=
const struct<br>
&gt; &gt; iovec *iov,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t count=
)<br>
&gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 struct fuse_ioctl_iovec *fiov;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct fuse_ioctl_iovec *fiov;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 size_t i;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 fiov =3D malloc(sizeof(fiov[0]) * count);<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 fiov =3D g_try_new(fuse_ioctl_iovec, count);<=
br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (!fiov) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec<br>
&gt; &gt; *fuse_ioctl_iovec_copy(const struct iovec *iov,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fiov[i].len =3D iov[i].iov=
_len;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 return fiov;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 return g_steal_pointer(&amp;fiov);<br>
&gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; This is OK, but doesn&#39;t gain anything - marking it as g_autof=
ree&#39;ing and<br>
&gt; &gt; always stealing is no benefit.<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 int fuse_reply_ioctl_retry(fuse_req_t req, const struc=
t iovec *in_iov,<br>
&gt; &gt; &gt; @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t re=
q, const<br>
&gt; &gt; struct iovec *in_iov,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, iov, coun=
t);<br>
&gt; &gt; &gt;=C2=A0 out:<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 free(in_fiov);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 free(out_fiov);<br>
&gt; &gt; &gt; -<br>
&gt; &gt;<br>
&gt; &gt; I don&#39;t think you can do that - I think you&#39;re relying he=
re on the<br>
&gt; &gt; g_autofree from fuse_ioclt_iovec_copy - but my understanding is t=
hat<br>
&gt; &gt; doesn&#39;t work; g_autofree is scoped, so it&#39;s designed to f=
ree at the end<br>
&gt; &gt; of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn&#39;t know=
 that the<br>
&gt; &gt; ion_fiov were allocated that way, so it won&#39;t get autocleaned=
 up.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; In GLib&#39;s documentation, it is clarified (w.r.t. g_autoptr but I t=
hink<br>
&gt; similar logic applies to g_autofree)<br>
&gt; that g_steal_pointer() &quot;This can be very useful when combined wit=
h<br>
&gt; g_autoptr() to prevent<br>
&gt; the return value of a function from being automatically freed.&quot;<b=
r>
&gt; I think, but not 100% clear of course, that this means that the<br>
&gt; g_autoptr-annotated memory<br>
&gt; does not get freed at the end of the current scope, and=C2=A0 its &quo=
t;scope&quot; is<br>
&gt; migrated to the calling<br>
&gt; function(to be honest I don&#39;t know how would they implement that b=
ut maybe<br>
&gt; this is the case).<br>
&gt; Otherwise why bother with g_autoptr&#39;ing memory that we don&#39;t w=
ant to free<br>
&gt; automatically and<br>
&gt; would like to return to the calling function?<br>
&gt; <br>
&gt; The first example in Memory Allocation: GLib Reference Manual (<a href=
=3D"http://gnome.org" rel=3D"noreferrer" target=3D"_blank">gnome.org</a>)<b=
r>
&gt; &lt;<a href=3D"https://developer.gnome.org/glib/stable/glib-Memory-All=
ocation.html#g-steal-pointer" rel=3D"noreferrer" target=3D"_blank">https://=
developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointer=
</a>&gt;<br>
&gt; does<br>
&gt; annotate<br>
&gt; the memory as g_autoptr and then returns it through g_steal_pointer. W=
ith<br>
&gt; your logic, I think that<br>
&gt; this example would be wrong(?)<br>
<br>
The example is correct but not quite the case you have;=C2=A0 the<br>
g_steal_pointer stops the g_autoptr freeing it at the end of the current<br=
>
scope; but it doesn&#39;t cause it to be free&#39;d later - the caller can&=
#39;t<br>
tell that the function that did the allocation had a g_autofree in it;<br>
once you get outside of the function, the pointer is just a normal<br>
pointer that needs free or g_free on.<br>
<br></blockquote><div>I think that this is logical, yes. I think that I und=
erstand now. Can you please instruct</div><div>me on what to do with the pa=
tch? Do you want me to resend the entire patch series</div><div>and amend t=
his one?</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">
<br>
&gt; Mr. Hajnoczi already reviewed this patch=C2=A0 Re: [PATCH 2/8] virtiof=
ds:<br>
&gt; Changed allocations of iovec to GLib&#39;s functi<br>
&gt; &lt;<a href=3D"https://lists.gnu.org/archive/html/qemu-devel/2021-03/m=
sg08459.html" rel=3D"noreferrer" target=3D"_blank">https://lists.gnu.org/ar=
chive/html/qemu-devel/2021-03/msg08459.html</a>&gt;<br>
&gt; in a previous version and this v2 patch series is supposed to only con=
tain<br>
&gt; already-reviewed patches and<br>
&gt; remove bad ones<br>
<br>
But he didn&#39;t spot this particular problem.<br>
<br>
Dave<br>
<br>
&gt; <br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 enomem:<br>
&gt; &gt; &gt; @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, i=
nt result,<br>
&gt; &gt; const void *buf, size_t size)<br>
&gt; &gt; &gt;=C2=A0 int fuse_reply_ioctl_iov(fuse_req_t req, int result, c=
onst struct iovec<br>
&gt; &gt; *iov,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int count)<br>
&gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 struct fuse_ioctl_out arg;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 2) * sizeof(st=
ruct iovec));<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iovec, count =
+ 2);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_reply_err(req,=
 ENOMEM);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req,=
 int result,<br>
&gt; &gt; const struct iovec *iov,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 memcpy(&amp;padded_iov[2], iov, count * =
sizeof(struct iovec));<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, padded_io=
v, count + 2);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; OK<br>
&gt; &gt;<br>
&gt; &gt; &gt; diff --git a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; index 3e13997406..07e5d91a9f 100644<br>
&gt; &gt; &gt; --- a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; +++ b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_ses=
sion *se,<br>
&gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* Build a copy of the the in_sg io=
v so we can skip bits in it,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* including changing the offsets<b=
r>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *in_sg_cpy =3D calloc(sizeof(str=
uct iovec), in_num);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 assert(in_sg_cpy);<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *in_sg_cpy =3D g_new0=
(struct iovec, in_num);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 memcpy(in_sg_cpy, in_sg, sizeof(struct i=
ovec) * in_num);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 /* These get updated as we skip */<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 struct iovec *in_sg_ptr =3D in_sg_cpy;<b=
r>
&gt; &gt; &gt; @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_ses=
sion *se,<br>
&gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D errn=
o;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUS=
E_LOG_DEBUG, &quot;%s: preadv failed (%m) len=3D%zd\n&quot;,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0__func__, len);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in_sg_cpy);<=
br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;<br=
>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_DEBUG, &=
quot;%s: preadv ret=3D%d len=3D%zd\n&quot;,<br>
&gt; &gt; __func__,<br>
&gt; &gt; &gt; @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct fuse_s=
ession *se,<br>
&gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D len) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUS=
E_LOG_DEBUG, &quot;%s: ret!=3Dlen\n&quot;, __func__);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D EIO;=
<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in_sg_cpy);<=
br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;<br=
>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_sg_left -=3D ret;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len -=3D ret;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 } while (in_sg_left);<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 free(in_sg_cpy);<br>
&gt; &gt;<br>
&gt; &gt; Yes, this is where the autofree really helps; getting rid of a fe=
w<br>
&gt; &gt; free&#39;s.<br>
&gt; &gt;<br>
&gt; &gt; Dave<br>
&gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 /* Need to fix out-&gt;len on EOF */<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (len) {<br>
&gt; &gt; &gt; --<br>
&gt; &gt; &gt; 2.25.1<br>
&gt; &gt; &gt;<br>
&gt; &gt; --<br>
&gt; &gt; Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" t=
arget=3D"_blank">dgilbert@redhat.com</a> / Manchester, UK<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; Thanks,<br>
&gt; Mahmoud<br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br></blockquote><div><br></div><div>Thanks,</div><div>Mahmoud=C2=A0</div><=
/div></div>

--0000000000007a90ee05c0f24997--

