DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Hfr1U1u54B5z+2TDhCIlkn/C9E6xJ4XW+ib0tMp4Pzs=;
	b=Wh47PKFl/xUR4AggGbZjc9Cd6Qdg5sF1igTRuAAly0DgHzwD/z6oTvpqhk0kgV5C+h
	hJjD76xP3CipZJrf8242ilsSm2d4FWYZ3zqrbrxgyWkN21AfS2a8ZWGqGBJ0wZukXvPD
	MUb52YcZFIXd9mWgQ7Y38AljypTj5wbjayvVigcOoBYoGPjwrBXMWLYicBKNNxL22Vwn
	j81TqYnrjCPQMWtgOufxeH5lEx6DLdMx2BQXb7o5Y8cogslebb0cOCTTAZb3EPDohQe7
	n6DW5v3ofTU3bZPaY1By2KUoY/c39YkQ4wNGL5Ky9MOYfxuOmTG3fDjPfI1+CahYTgIX
	PWhQ==
MIME-Version: 1.0
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
	<YIfmaleNOwhLLD9W@work-vm>
In-Reply-To: <YIfmaleNOwhLLD9W@work-vm>
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 27 Apr 2021 12:53:01 +0200
Message-ID: <CAD-LL6gvoz0t4UND-CNdazciFoFE6ZVJ8ncZbfM3b37c8ECzbw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000085df6a05c0f211b2"
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

--00000000000085df6a05c0f211b2
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > Replaced the calls to malloc()/calloc() and their respective
> > calls to free() of iovec structs with GLib's allocation and
> > deallocation functions.
> >
> > Also, in one instance, used g_new0() instead of a calloc() call plus
> > a null-checking assertion.
> >
> > iovec structs were created locally and freed as the function
> > ends. Hence, I used g_autofree and removed the respective calls to
> > free().
> >
> > In one instance, a struct fuse_ioctl_iovec pointer is returned from a
> > function, namely, fuse_ioctl_iovec_copy. There, I used g_steal_pointer()
> > in conjunction with g_autofree, this gives the ownership of the pointer
> > to the calling function and still auto-frees the memory when the calling
> > function finishes (maintaining the symantics of previous code).
> >
> > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
> >  tools/virtiofsd/fuse_virtio.c   |  6 +-----
> >  2 files changed, 8 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/virtiofsd/fuse_lowlevel.c
> b/tools/virtiofsd/fuse_lowlevel.c
> > index 812cef6ef6..f965299ad9 100644
> > --- a/tools/virtiofsd/fuse_lowlevel.c
> > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error,
> const void *arg,
> >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
> >  {
> >      int res;
> > -    struct iovec *padded_iov;
> > +    g_autofree struct iovec *padded_iov;
> >
> > -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> > +    padded_iov = g_try_new(struct iovec, count + 1);
> >      if (padded_iov == NULL) {
> >          return fuse_reply_err(req, ENOMEM);
> >      }
> > @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const struct
> iovec *iov, int count)
> >      count++;
> >
> >      res = send_reply_iov(req, 0, padded_iov, count);
> > -    free(padded_iov);
> >
> >      return res;
> >  }
>
> OK.
>
> > @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, uint64_t idx)
> >  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct
> iovec *iov,
> >                                                        size_t count)
> >  {
> > -    struct fuse_ioctl_iovec *fiov;
> > +    g_autofree struct fuse_ioctl_iovec *fiov;
> >      size_t i;
> >
> > -    fiov = malloc(sizeof(fiov[0]) * count);
> > +    fiov = g_try_new(fuse_ioctl_iovec, count);
> >      if (!fiov) {
> >          return NULL;
> >      }
> > @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec
> *fuse_ioctl_iovec_copy(const struct iovec *iov,
> >          fiov[i].len = iov[i].iov_len;
> >      }
> >
> > -    return fiov;
> > +    return g_steal_pointer(&fiov);
> >  }
>
> This is OK, but doesn't gain anything - marking it as g_autofree'ing and
> always stealing is no benefit.
>
> >
> >  int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> > @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const
> struct iovec *in_iov,
> >
> >      res = send_reply_iov(req, 0, iov, count);
> >  out:
> > -    free(in_fiov);
> > -    free(out_fiov);
> > -
>
> I don't think you can do that - I think you're relying here on the
> g_autofree from fuse_ioclt_iovec_copy - but my understanding is that
> doesn't work; g_autofree is scoped, so it's designed to free at the end
> of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn't know that the
> ion_fiov were allocated that way, so it won't get autocleaned up.
>
>
In GLib's documentation, it is clarified (w.r.t. g_autoptr but I think
similar logic applies to g_autofree)
that g_steal_pointer() "This can be very useful when combined with
g_autoptr() to prevent
the return value of a function from being automatically freed."
I think, but not 100% clear of course, that this means that the
g_autoptr-annotated memory
does not get freed at the end of the current scope, and  its "scope" is
migrated to the calling
function(to be honest I don't know how would they implement that but maybe
this is the case).
Otherwise why bother with g_autoptr'ing memory that we don't want to free
automatically and
would like to return to the calling function?

The first example in Memory Allocation: GLib Reference Manual (gnome.org)
<https://developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointer>
does
annotate
the memory as g_autoptr and then returns it through g_steal_pointer. With
your logic, I think that
this example would be wrong(?)

Mr. Hajnoczi already reviewed this patch  Re: [PATCH 2/8] virtiofds:
Changed allocations of iovec to GLib's functi
<https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg08459.html>
in a previous version and this v2 patch series is supposed to only contain
already-reviewed patches and
remove bad ones


> >      return res;
> >
> >  enomem:
> > @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int result,
> const void *buf, size_t size)
> >  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec
> *iov,
> >                           int count)
> >  {
> > -    struct iovec *padded_iov;
> > +    g_autofree struct iovec *padded_iov;
> >      struct fuse_ioctl_out arg;
> >      int res;
> >
> > -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> > +    padded_iov = g_try_new(struct iovec, count + 2);
> >      if (padded_iov == NULL) {
> >          return fuse_reply_err(req, ENOMEM);
> >      }
> > @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result,
> const struct iovec *iov,
> >      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
> >
> >      res = send_reply_iov(req, 0, padded_iov, count + 2);
> > -    free(padded_iov);
> >
> >      return res;
> >  }
>
> OK
>
> > diff --git a/tools/virtiofsd/fuse_virtio.c
> b/tools/virtiofsd/fuse_virtio.c
> > index 3e13997406..07e5d91a9f 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session *se,
> struct fuse_chan *ch,
> >       * Build a copy of the the in_sg iov so we can skip bits in it,
> >       * including changing the offsets
> >       */
> > -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec), in_num);
> > -    assert(in_sg_cpy);
> > +    g_autofree struct iovec *in_sg_cpy = g_new0(struct iovec, in_num);
> >      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
> >      /* These get updated as we skip */
> >      struct iovec *in_sg_ptr = in_sg_cpy;
> > @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session *se,
> struct fuse_chan *ch,
> >              ret = errno;
> >              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m) len=%zd\n",
> >                       __func__, len);
> > -            free(in_sg_cpy);
> >              goto err;
> >          }
> >          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n",
> __func__,
> > @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct fuse_session *se,
> struct fuse_chan *ch,
> >          if (ret != len) {
> >              fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
> >              ret = EIO;
> > -            free(in_sg_cpy);
> >              goto err;
> >          }
> >          in_sg_left -= ret;
> >          len -= ret;
> >      } while (in_sg_left);
> > -    free(in_sg_cpy);
>
> Yes, this is where the autofree really helps; getting rid of a few
> free's.
>
> Dave
>
> >      /* Need to fix out->len on EOF */
> >      if (len) {
> > --
> > 2.25.1
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>
Thanks,
Mahmoud

--00000000000085df6a05c0f211b2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><br></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert &lt=
;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redhat.com</a>&gt; wrote:<=
br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">* Mahmoud Mandou=
r (<a href=3D"mailto:ma.mandourr@gmail.com" target=3D"_blank">ma.mandourr@g=
mail.com</a>) wrote:<br>
&gt; Replaced the calls to malloc()/calloc() and their respective<br>
&gt; calls to free() of iovec structs with GLib&#39;s allocation and<br>
&gt; deallocation functions.<br>
&gt; <br>
&gt; Also, in one instance, used g_new0() instead of a calloc() call plus<b=
r>
&gt; a null-checking assertion.<br>
&gt; <br>
&gt; iovec structs were created locally and freed as the function<br>
&gt; ends. Hence, I used g_autofree and removed the respective calls to<br>
&gt; free().<br>
&gt; <br>
&gt; In one instance, a struct fuse_ioctl_iovec pointer is returned from a<=
br>
&gt; function, namely, fuse_ioctl_iovec_copy. There, I used g_steal_pointer=
()<br>
&gt; in conjunction with g_autofree, this gives the ownership of the pointe=
r<br>
&gt; to the calling function and still auto-frees the memory when the calli=
ng<br>
&gt; function finishes (maintaining the symantics of previous code).<br>
&gt; <br>
&gt; Signed-off-by: Mahmoud Mandour &lt;<a href=3D"mailto:ma.mandourr@gmail=
.com" target=3D"_blank">ma.mandourr@gmail.com</a>&gt;<br>
&gt; Reviewed-by: Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com=
" target=3D"_blank">stefanha@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------<br>
&gt;=C2=A0 tools/virtiofsd/fuse_virtio.c=C2=A0 =C2=A0|=C2=A0 6 +-----<br>
&gt;=C2=A0 2 files changed, 8 insertions(+), 17 deletions(-)<br>
&gt; <br>
&gt; diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lo=
wlevel.c<br>
&gt; index 812cef6ef6..f965299ad9 100644<br>
&gt; --- a/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; +++ b/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error, c=
onst void *arg,<br>
&gt;=C2=A0 int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int =
count)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 1) * sizeof(struct iovec=
));<br>
&gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iovec, count + 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_reply_err(req, ENOMEM);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const struct io=
vec *iov, int count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 count++;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, padded_iov, count);=
<br>
&gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt;=C2=A0 }<br>
<br>
OK.<br>
<br>
&gt; @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, uint64_t idx=
)<br>
&gt;=C2=A0 static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const stru=
ct iovec *iov,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t count)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 struct fuse_ioctl_iovec *fiov;<br>
&gt; +=C2=A0 =C2=A0 g_autofree struct fuse_ioctl_iovec *fiov;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 size_t i;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 fiov =3D malloc(sizeof(fiov[0]) * count);<br>
&gt; +=C2=A0 =C2=A0 fiov =3D g_try_new(fuse_ioctl_iovec, count);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (!fiov) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec *fuse_ioctl_iovec_c=
opy(const struct iovec *iov,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fiov[i].len =3D iov[i].iov_len;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 return fiov;<br>
&gt; +=C2=A0 =C2=A0 return g_steal_pointer(&amp;fiov);<br>
&gt;=C2=A0 }<br>
<br>
This is OK, but doesn&#39;t gain anything - marking it as g_autofree&#39;in=
g and<br>
always stealing is no benefit.<br>
<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *i=
n_iov,<br>
&gt; @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const s=
truct iovec *in_iov,<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, iov, count);<br>
&gt;=C2=A0 out:<br>
&gt; -=C2=A0 =C2=A0 free(in_fiov);<br>
&gt; -=C2=A0 =C2=A0 free(out_fiov);<br>
&gt; -<br>
<br>
I don&#39;t think you can do that - I think you&#39;re relying here on the<=
br>
g_autofree from fuse_ioclt_iovec_copy - but my understanding is that<br>
doesn&#39;t work; g_autofree is scoped, so it&#39;s designed to free at the=
 end<br>
of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn&#39;t know that the<=
br>
ion_fiov were allocated that way, so it won&#39;t get autocleaned up.<br>
<br></blockquote><div><br></div><div>In GLib&#39;s documentation, it is cla=
rified (w.r.t. g_autoptr but I think similar logic applies to g_autofree)</=
div><div>that g_steal_pointer() &quot;This can be very useful when combined=
 with g_autoptr() to prevent=C2=A0</div><div>the return value of a function=
 from being automatically freed.&quot;</div><div>I think, but not 100% clea=
r of course, that this means that the g_autoptr-annotated memory</div><div>=
does not get freed at the end of the current scope, and=C2=A0 its=C2=A0&quo=
t;scope&quot; is migrated to the calling</div><div>function(to be honest I =
don&#39;t know how would they implement that but maybe this is the case).</=
div><div>Otherwise why bother with g_autoptr&#39;ing memory that we don&#39=
;t want to free automatically and</div><div>would like to return to the cal=
ling function?</div><div><br></div><div>The first example in=C2=A0<a href=
=3D"https://developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-s=
teal-pointer">Memory Allocation: GLib Reference Manual (gnome.org)</a>=C2=
=A0does annotate</div><div>the memory as g_autoptr and then returns it thro=
ugh g_steal_pointer. With your logic, I think that</div><div>this example w=
ould be wrong(?)</div><div><br></div><div>Mr. Hajnoczi already reviewed thi=
s patch=C2=A0=C2=A0<a href=3D"https://lists.gnu.org/archive/html/qemu-devel=
/2021-03/msg08459.html">Re: [PATCH 2/8] virtiofds: Changed allocations of i=
ovec to GLib&#39;s functi</a></div><div>in a previous version and this v2 p=
atch series is supposed to only contain already-reviewed patches and</div><=
div>remove bad ones</div><div>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);p=
adding-left:1ex">
&gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 enomem:<br>
&gt; @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int result,=
 const void *buf, size_t size)<br>
&gt;=C2=A0 int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struc=
t iovec *iov,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0int count)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 struct fuse_ioctl_out arg;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 2) * sizeof(struct iovec=
));<br>
&gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iovec, count + 2);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_reply_err(req, ENOMEM);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int resul=
t, const struct iovec *iov,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 memcpy(&amp;padded_iov[2], iov, count * sizeof(str=
uct iovec));<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0, padded_iov, count +=
 2);<br>
&gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt;=C2=A0 }<br>
<br>
OK<br>
<br>
&gt; diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virt=
io.c<br>
&gt; index 3e13997406..07e5d91a9f 100644<br>
&gt; --- a/tools/virtiofsd/fuse_virtio.c<br>
&gt; +++ b/tools/virtiofsd/fuse_virtio.c<br>
&gt; @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session *se, =
struct fuse_chan *ch,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* Build a copy of the the in_sg iov so we ca=
n skip bits in it,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* including changing the offsets<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; -=C2=A0 =C2=A0 struct iovec *in_sg_cpy =3D calloc(sizeof(struct iovec)=
, in_num);<br>
&gt; -=C2=A0 =C2=A0 assert(in_sg_cpy);<br>
&gt; +=C2=A0 =C2=A0 g_autofree struct iovec *in_sg_cpy =3D g_new0(struct io=
vec, in_num);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in=
_num);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 /* These get updated as we skip */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 struct iovec *in_sg_ptr =3D in_sg_cpy;<br>
&gt; @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session *se, =
struct fuse_chan *ch,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D errno;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_DEBU=
G, &quot;%s: preadv failed (%m) len=3D%zd\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0__func__, len);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in_sg_cpy);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_DEBUG, &quot;%s: p=
readv ret=3D%d len=3D%zd\n&quot;, __func__,<br>
&gt; @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct fuse_session *se=
, struct fuse_chan *ch,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D len) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_DEBU=
G, &quot;%s: ret!=3Dlen\n&quot;, __func__);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D EIO;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in_sg_cpy);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_sg_left -=3D ret;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len -=3D ret;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 } while (in_sg_left);<br>
&gt; -=C2=A0 =C2=A0 free(in_sg_cpy);<br>
<br>
Yes, this is where the autofree really helps; getting rid of a few<br>
free&#39;s.<br>
<br>
Dave<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 /* Need to fix out-&gt;len on EOF */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (len) {<br>
&gt; -- <br>
&gt; 2.25.1<br>
&gt; <br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br></blockquote><div><br></div><div>Thanks,</div><div>Mahmoud=C2=A0</div><=
/div></div></div></div></div>

--00000000000085df6a05c0f211b2--

