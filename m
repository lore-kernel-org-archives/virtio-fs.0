DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=1t/a5HPf5K1zKF82Co4qwlnXPRjbSx51TrdbFAD6pY0=;
	b=e0MWN5cIJmOI71TrABVkYDmGEYhSs5VnlhSAWjIaoofr317UULuZNO7iYVq6N57mmN
	kImJM9qPrdpksBR5enmyoAADgI32xq89NOCrIpmve5uYU85Nle7rzoPHD/I2oV2apUta
	v+bo2pDLnwFFPUda8a2n/O18mKHay8FFQ9zckuRYYKNxKttPS2W6xNWJ5t3rwYV98h8J
	rhhfmDFAspkhZEMmDvgeIzFDZ/0hdNhoNCYFtD5vX8Z0qh1RvDwXX+SjQMPF+57M5pnk
	p+Bmhbli2fzGKm2a2/3fMMOsUomvZ7tS43ovP/i/CKGVKi1tltTIyjdz9C+1g2SiF77I
	uFCA==
MIME-Version: 1.0
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
	<YIfmaleNOwhLLD9W@work-vm>
	<CAD-LL6gvoz0t4UND-CNdazciFoFE6ZVJ8ncZbfM3b37c8ECzbw@mail.gmail.com>
	<YIfu9eV41U6vT6iP@work-vm>
	<CAD-LL6gCTagzmR-NXZiBTJH+LOH0D4wHigVow1e0bVfyVcm4PQ@mail.gmail.com>
	<YIf2d8HuyPqwqt9C@work-vm>
In-Reply-To: <YIf2d8HuyPqwqt9C@work-vm>
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 27 Apr 2021 20:19:53 +0200
Message-ID: <CAD-LL6jK7LC5p8FBgHRgsUQnaWgn3gNXONXNwn44pb99sna_ag@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000ac36fc05c0f84fc6"
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

--000000000000ac36fc05c0f84fc6
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 27, 2021 at 1:33 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > On Tue, Apr 27, 2021 at 1:01 PM Dr. David Alan Gilbert <
> dgilbert@redhat.com>
> > wrote:
> >
> > > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > > On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert <
> > > dgilbert@redhat.com>
> > > > wrote:
> > > >
> > > > > * Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> > > > > > Replaced the calls to malloc()/calloc() and their respective
> > > > > > calls to free() of iovec structs with GLib's allocation and
> > > > > > deallocation functions.
> > > > > >
> > > > > > Also, in one instance, used g_new0() instead of a calloc() call
> plus
> > > > > > a null-checking assertion.
> > > > > >
> > > > > > iovec structs were created locally and freed as the function
> > > > > > ends. Hence, I used g_autofree and removed the respective calls
> to
> > > > > > free().
> > > > > >
> > > > > > In one instance, a struct fuse_ioctl_iovec pointer is returned
> from a
> > > > > > function, namely, fuse_ioctl_iovec_copy. There, I used
> > > g_steal_pointer()
> > > > > > in conjunction with g_autofree, this gives the ownership of the
> > > pointer
> > > > > > to the calling function and still auto-frees the memory when the
> > > calling
> > > > > > function finishes (maintaining the symantics of previous code).
> > > > > >
> > > > > > Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> > > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > ---
> > > > > >  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
> > > > > >  tools/virtiofsd/fuse_virtio.c   |  6 +-----
> > > > > >  2 files changed, 8 insertions(+), 17 deletions(-)
> > > > > >
> > > > > > diff --git a/tools/virtiofsd/fuse_lowlevel.c
> > > > > b/tools/virtiofsd/fuse_lowlevel.c
> > > > > > index 812cef6ef6..f965299ad9 100644
> > > > > > --- a/tools/virtiofsd/fuse_lowlevel.c
> > > > > > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > > > > > @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int
> error,
> > > > > const void *arg,
> > > > > >  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int
> > > count)
> > > > > >  {
> > > > > >      int res;
> > > > > > -    struct iovec *padded_iov;
> > > > > > +    g_autofree struct iovec *padded_iov;
> > > > > >
> > > > > > -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> > > > > > +    padded_iov = g_try_new(struct iovec, count + 1);
> > > > > >      if (padded_iov == NULL) {
> > > > > >          return fuse_reply_err(req, ENOMEM);
> > > > > >      }
> > > > > > @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const
> struct
> > > > > iovec *iov, int count)
> > > > > >      count++;
> > > > > >
> > > > > >      res = send_reply_iov(req, 0, padded_iov, count);
> > > > > > -    free(padded_iov);
> > > > > >
> > > > > >      return res;
> > > > > >  }
> > > > >
> > > > > OK.
> > > > >
> > > > > > @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req,
> uint64_t
> > > idx)
> > > > > >  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const
> struct
> > > > > iovec *iov,
> > > > > >                                                        size_t
> count)
> > > > > >  {
> > > > > > -    struct fuse_ioctl_iovec *fiov;
> > > > > > +    g_autofree struct fuse_ioctl_iovec *fiov;
> > > > > >      size_t i;
> > > > > >
> > > > > > -    fiov = malloc(sizeof(fiov[0]) * count);
> > > > > > +    fiov = g_try_new(fuse_ioctl_iovec, count);
> > > > > >      if (!fiov) {
> > > > > >          return NULL;
> > > > > >      }
> > > > > > @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec
> > > > > *fuse_ioctl_iovec_copy(const struct iovec *iov,
> > > > > >          fiov[i].len = iov[i].iov_len;
> > > > > >      }
> > > > > >
> > > > > > -    return fiov;
> > > > > > +    return g_steal_pointer(&fiov);
> > > > > >  }
> > > > >
> > > > > This is OK, but doesn't gain anything - marking it as
> g_autofree'ing
> > > and
> > > > > always stealing is no benefit.
> > > > >
> > > > > >
> > > > > >  int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec
> > > *in_iov,
> > > > > > @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req,
> const
> > > > > struct iovec *in_iov,
> > > > > >
> > > > > >      res = send_reply_iov(req, 0, iov, count);
> > > > > >  out:
> > > > > > -    free(in_fiov);
> > > > > > -    free(out_fiov);
> > > > > > -
> > > > >
> > > > > I don't think you can do that - I think you're relying here on the
> > > > > g_autofree from fuse_ioclt_iovec_copy - but my understanding is
> that
> > > > > doesn't work; g_autofree is scoped, so it's designed to free at
> the end
> > > > > of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn't know that
> the
> > > > > ion_fiov were allocated that way, so it won't get autocleaned up.
> > > > >
> > > > >
> > > > In GLib's documentation, it is clarified (w.r.t. g_autoptr but I
> think
> > > > similar logic applies to g_autofree)
> > > > that g_steal_pointer() "This can be very useful when combined with
> > > > g_autoptr() to prevent
> > > > the return value of a function from being automatically freed."
> > > > I think, but not 100% clear of course, that this means that the
> > > > g_autoptr-annotated memory
> > > > does not get freed at the end of the current scope, and  its "scope"
> is
> > > > migrated to the calling
> > > > function(to be honest I don't know how would they implement that but
> > > maybe
> > > > this is the case).
> > > > Otherwise why bother with g_autoptr'ing memory that we don't want to
> free
> > > > automatically and
> > > > would like to return to the calling function?
> > > >
> > > > The first example in Memory Allocation: GLib Reference Manual (
> gnome.org
> > > )
> > > > <
> > >
> https://developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointer
> > > >
> > > > does
> > > > annotate
> > > > the memory as g_autoptr and then returns it through g_steal_pointer.
> With
> > > > your logic, I think that
> > > > this example would be wrong(?)
> > >
> > > The example is correct but not quite the case you have;  the
> > > g_steal_pointer stops the g_autoptr freeing it at the end of the
> current
> > > scope; but it doesn't cause it to be free'd later - the caller can't
> > > tell that the function that did the allocation had a g_autofree in it;
> > > once you get outside of the function, the pointer is just a normal
> > > pointer that needs free or g_free on.
> > >
> > > I think that this is logical, yes. I think that I understand now. Can
> you
> > please instruct
> > me on what to do with the patch? Do you want me to resend the entire
> patch
> > series
> > and amend this one?
>
> Just resend this one as a '[PATCH v3 2/7]'
>
> Dave
>
> >
> > >
> > > > Mr. Hajnoczi already reviewed this patch  Re: [PATCH 2/8] virtiofds:
> > > > Changed allocations of iovec to GLib's functi
> > > > <https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg08459.html
> >
> > > > in a previous version and this v2 patch series is supposed to only
> > > contain
> > > > already-reviewed patches and
> > > > remove bad ones
> > >
> > > But he didn't spot this particular problem.
> > >
> > > Dave
> > >
> > > >
> > > > > >      return res;
> > > > > >
> > > > > >  enomem:
> > > > > > @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int
> > > result,
> > > > > const void *buf, size_t size)
> > > > > >  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const
> struct
> > > iovec
> > > > > *iov,
> > > > > >                           int count)
> > > > > >  {
> > > > > > -    struct iovec *padded_iov;
> > > > > > +    g_autofree struct iovec *padded_iov;
> > > > > >      struct fuse_ioctl_out arg;
> > > > > >      int res;
> > > > > >
> > > > > > -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> > > > > > +    padded_iov = g_try_new(struct iovec, count + 2);
> > > > > >      if (padded_iov == NULL) {
> > > > > >          return fuse_reply_err(req, ENOMEM);
> > > > > >      }
> > > > > > @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int
> > > result,
> > > > > const struct iovec *iov,
> > > > > >      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
> > > > > >
> > > > > >      res = send_reply_iov(req, 0, padded_iov, count + 2);
> > > > > > -    free(padded_iov);
> > > > > >
> > > > > >      return res;
> > > > > >  }
> > > > >
> > > > > OK
> > > > >
> > > > > > diff --git a/tools/virtiofsd/fuse_virtio.c
> > > > > b/tools/virtiofsd/fuse_virtio.c
> > > > > > index 3e13997406..07e5d91a9f 100644
> > > > > > --- a/tools/virtiofsd/fuse_virtio.c
> > > > > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > > > > @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session
> *se,
> > > > > struct fuse_chan *ch,
> > > > > >       * Build a copy of the the in_sg iov so we can skip bits in
> it,
> > > > > >       * including changing the offsets
> > > > > >       */
> > > > > > -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec),
> in_num);
> > > > > > -    assert(in_sg_cpy);
> > > > > > +    g_autofree struct iovec *in_sg_cpy = g_new0(struct iovec,
> > > in_num);
> > > > > >      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
> > > > > >      /* These get updated as we skip */
> > > > > >      struct iovec *in_sg_ptr = in_sg_cpy;
> > > > > > @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session
> *se,
> > > > > struct fuse_chan *ch,
> > > > > >              ret = errno;
> > > > > >              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m)
> > > len=%zd\n",
> > > > > >                       __func__, len);
> > > > > > -            free(in_sg_cpy);
> > > > > >              goto err;
> > > > > >          }
> > > > > >          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n",
> > > > > __func__,
> > > > > > @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct
> fuse_session
> > > *se,
> > > > > struct fuse_chan *ch,
> > > > > >          if (ret != len) {
> > > > > >              fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n",
> __func__);
> > > > > >              ret = EIO;
> > > > > > -            free(in_sg_cpy);
> > > > > >              goto err;
> > > > > >          }
> > > > > >          in_sg_left -= ret;
> > > > > >          len -= ret;
> > > > > >      } while (in_sg_left);
> > > > > > -    free(in_sg_cpy);
> > > > >
> > > > > Yes, this is where the autofree really helps; getting rid of a few
> > > > > free's.
> > > > >
> > > > > Dave
> > > > >
> > > > > >      /* Need to fix out->len on EOF */
> > > > > >      if (len) {
> > > > > > --
> > > > > > 2.25.1
> > > > > >
> > > > > --
> > > > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > > > >
> > > > >
> > > > Thanks,
> > > > Mahmoud
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
I sent a v3 of this patch, and I used the --in-reply-to and put the
message-id of your latest
email but despite this, it was sent as a separate thread, I apologise.
That's the link of the thread
[PATCH v3 2/7] virtiofsd: Changed allocations of iovec to GLib's functio
(gnu.org)
<https://lists.gnu.org/archive/html/qemu-devel/2021-04/msg05559.html>
and if you think that it'd better be here, I'll send it again manually as a
reply to this mailing series.

Mahmoud

--000000000000ac36fc05c0f84fc6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><br></div><div dir=3D"lt=
r"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote"><div dir=3D"lt=
r" class=3D"gmail_attr">On Tue, Apr 27, 2021 at 1:33 PM Dr. David Alan Gilb=
ert &lt;<a href=3D"mailto:dgilbert@redhat.com" target=3D"_blank">dgilbert@r=
edhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">* Mahmoud Mandour (<a href=3D"mailto:ma.mandourr@gmail.com" targ=
et=3D"_blank">ma.mandourr@gmail.com</a>) wrote:<br>
&gt; On Tue, Apr 27, 2021 at 1:01 PM Dr. David Alan Gilbert &lt;<a href=3D"=
mailto:dgilbert@redhat.com" target=3D"_blank">dgilbert@redhat.com</a>&gt;<b=
r>
&gt; wrote:<br>
&gt; <br>
&gt; &gt; * Mahmoud Mandour (<a href=3D"mailto:ma.mandourr@gmail.com" targe=
t=3D"_blank">ma.mandourr@gmail.com</a>) wrote:<br>
&gt; &gt; &gt; On Tue, Apr 27, 2021 at 12:25 PM Dr. David Alan Gilbert &lt;=
<br>
&gt; &gt; <a href=3D"mailto:dgilbert@redhat.com" target=3D"_blank">dgilbert=
@redhat.com</a>&gt;<br>
&gt; &gt; &gt; wrote:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; * Mahmoud Mandour (<a href=3D"mailto:ma.mandourr@gmail.=
com" target=3D"_blank">ma.mandourr@gmail.com</a>) wrote:<br>
&gt; &gt; &gt; &gt; &gt; Replaced the calls to malloc()/calloc() and their =
respective<br>
&gt; &gt; &gt; &gt; &gt; calls to free() of iovec structs with GLib&#39;s a=
llocation and<br>
&gt; &gt; &gt; &gt; &gt; deallocation functions.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Also, in one instance, used g_new0() instead of a =
calloc() call plus<br>
&gt; &gt; &gt; &gt; &gt; a null-checking assertion.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; iovec structs were created locally and freed as th=
e function<br>
&gt; &gt; &gt; &gt; &gt; ends. Hence, I used g_autofree and removed the res=
pective calls to<br>
&gt; &gt; &gt; &gt; &gt; free().<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; In one instance, a struct fuse_ioctl_iovec pointer=
 is returned from a<br>
&gt; &gt; &gt; &gt; &gt; function, namely, fuse_ioctl_iovec_copy. There, I =
used<br>
&gt; &gt; g_steal_pointer()<br>
&gt; &gt; &gt; &gt; &gt; in conjunction with g_autofree, this gives the own=
ership of the<br>
&gt; &gt; pointer<br>
&gt; &gt; &gt; &gt; &gt; to the calling function and still auto-frees the m=
emory when the<br>
&gt; &gt; calling<br>
&gt; &gt; &gt; &gt; &gt; function finishes (maintaining the symantics of pr=
evious code).<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Signed-off-by: Mahmoud Mandour &lt;<a href=3D"mail=
to:ma.mandourr@gmail.com" target=3D"_blank">ma.mandourr@gmail.com</a>&gt;<b=
r>
&gt; &gt; &gt; &gt; &gt; Reviewed-by: Stefan Hajnoczi &lt;<a href=3D"mailto=
:stefanha@redhat.com" target=3D"_blank">stefanha@redhat.com</a>&gt;<br>
&gt; &gt; &gt; &gt; &gt; ---<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 tools/virtiofsd/fuse_lowlevel.c | 19 +++++++=
------------<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 tools/virtiofsd/fuse_virtio.c=C2=A0 =C2=A0|=
=C2=A0 6 +-----<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 2 files changed, 8 insertions(+), 17 deletio=
ns(-)<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; diff --git a/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; &gt; b/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; &gt; &gt; index 812cef6ef6..f965299ad9 100644<br>
&gt; &gt; &gt; &gt; &gt; --- a/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; &gt; &gt; +++ b/tools/virtiofsd/fuse_lowlevel.c<br>
&gt; &gt; &gt; &gt; &gt; @@ -217,9 +217,9 @@ static int send_reply(fuse_req=
_t req, int error,<br>
&gt; &gt; &gt; &gt; const void *arg,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 int fuse_reply_iov(fuse_req_t req, const str=
uct iovec *iov, int<br>
&gt; &gt; count)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov=
;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 1) *=
 sizeof(struct iovec));<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iov=
ec, count + 1);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<=
br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_repl=
y_err(req, ENOMEM);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt; @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t =
req, const struct<br>
&gt; &gt; &gt; &gt; iovec *iov, int count)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 count++;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0,=
 padded_iov, count);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; OK.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req=
_t req, uint64_t<br>
&gt; &gt; idx)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 static struct fuse_ioctl_iovec *fuse_ioctl_i=
ovec_copy(const struct<br>
&gt; &gt; &gt; &gt; iovec *iov,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 s=
ize_t count)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 struct fuse_ioctl_iovec *fiov;<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct fuse_ioctl_iovec =
*fiov;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 size_t i;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 fiov =3D malloc(sizeof(fiov[0]) * c=
ount);<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 fiov =3D g_try_new(fuse_ioctl_iovec=
, count);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (!fiov) {<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt; @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec=
<br>
&gt; &gt; &gt; &gt; *fuse_ioctl_iovec_copy(const struct iovec *iov,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fiov[i].len =3D =
iov[i].iov_len;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 return fiov;<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 return g_steal_pointer(&amp;fiov);<=
br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; This is OK, but doesn&#39;t gain anything - marking it =
as g_autofree&#39;ing<br>
&gt; &gt; and<br>
&gt; &gt; &gt; &gt; always stealing is no benefit.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 int fuse_reply_ioctl_retry(fuse_req_t req, c=
onst struct iovec<br>
&gt; &gt; *in_iov,<br>
&gt; &gt; &gt; &gt; &gt; @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fus=
e_req_t req, const<br>
&gt; &gt; &gt; &gt; struct iovec *in_iov,<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0,=
 iov, count);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 out:<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 free(in_fiov);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 free(out_fiov);<br>
&gt; &gt; &gt; &gt; &gt; -<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I don&#39;t think you can do that - I think you&#39;re =
relying here on the<br>
&gt; &gt; &gt; &gt; g_autofree from fuse_ioclt_iovec_copy - but my understa=
nding is that<br>
&gt; &gt; &gt; &gt; doesn&#39;t work; g_autofree is scoped, so it&#39;s des=
igned to free at the end<br>
&gt; &gt; &gt; &gt; of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn&=
#39;t know that the<br>
&gt; &gt; &gt; &gt; ion_fiov were allocated that way, so it won&#39;t get a=
utocleaned up.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; In GLib&#39;s documentation, it is clarified (w.r.t. g_autop=
tr but I think<br>
&gt; &gt; &gt; similar logic applies to g_autofree)<br>
&gt; &gt; &gt; that g_steal_pointer() &quot;This can be very useful when co=
mbined with<br>
&gt; &gt; &gt; g_autoptr() to prevent<br>
&gt; &gt; &gt; the return value of a function from being automatically free=
d.&quot;<br>
&gt; &gt; &gt; I think, but not 100% clear of course, that this means that =
the<br>
&gt; &gt; &gt; g_autoptr-annotated memory<br>
&gt; &gt; &gt; does not get freed at the end of the current scope, and=C2=
=A0 its &quot;scope&quot; is<br>
&gt; &gt; &gt; migrated to the calling<br>
&gt; &gt; &gt; function(to be honest I don&#39;t know how would they implem=
ent that but<br>
&gt; &gt; maybe<br>
&gt; &gt; &gt; this is the case).<br>
&gt; &gt; &gt; Otherwise why bother with g_autoptr&#39;ing memory that we d=
on&#39;t want to free<br>
&gt; &gt; &gt; automatically and<br>
&gt; &gt; &gt; would like to return to the calling function?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; The first example in Memory Allocation: GLib Reference Manua=
l (<a href=3D"http://gnome.org" rel=3D"noreferrer" target=3D"_blank">gnome.=
org</a><br>
&gt; &gt; )<br>
&gt; &gt; &gt; &lt;<br>
&gt; &gt; <a href=3D"https://developer.gnome.org/glib/stable/glib-Memory-Al=
location.html#g-steal-pointer" rel=3D"noreferrer" target=3D"_blank">https:/=
/developer.gnome.org/glib/stable/glib-Memory-Allocation.html#g-steal-pointe=
r</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; does<br>
&gt; &gt; &gt; annotate<br>
&gt; &gt; &gt; the memory as g_autoptr and then returns it through g_steal_=
pointer. With<br>
&gt; &gt; &gt; your logic, I think that<br>
&gt; &gt; &gt; this example would be wrong(?)<br>
&gt; &gt;<br>
&gt; &gt; The example is correct but not quite the case you have;=C2=A0 the=
<br>
&gt; &gt; g_steal_pointer stops the g_autoptr freeing it at the end of the =
current<br>
&gt; &gt; scope; but it doesn&#39;t cause it to be free&#39;d later - the c=
aller can&#39;t<br>
&gt; &gt; tell that the function that did the allocation had a g_autofree i=
n it;<br>
&gt; &gt; once you get outside of the function, the pointer is just a norma=
l<br>
&gt; &gt; pointer that needs free or g_free on.<br>
&gt; &gt;<br>
&gt; &gt; I think that this is logical, yes. I think that I understand now.=
 Can you<br>
&gt; please instruct<br>
&gt; me on what to do with the patch? Do you want me to resend the entire p=
atch<br>
&gt; series<br>
&gt; and amend this one?<br>
<br>
Just resend this one as a &#39;[PATCH v3 2/7]&#39;<br>
<br>
Dave<br>
<br>
&gt; <br>
&gt; &gt;<br>
&gt; &gt; &gt; Mr. Hajnoczi already reviewed this patch=C2=A0 Re: [PATCH 2/=
8] virtiofds:<br>
&gt; &gt; &gt; Changed allocations of iovec to GLib&#39;s functi<br>
&gt; &gt; &gt; &lt;<a href=3D"https://lists.gnu.org/archive/html/qemu-devel=
/2021-03/msg08459.html" rel=3D"noreferrer" target=3D"_blank">https://lists.=
gnu.org/archive/html/qemu-devel/2021-03/msg08459.html</a>&gt;<br>
&gt; &gt; &gt; in a previous version and this v2 patch series is supposed t=
o only<br>
&gt; &gt; contain<br>
&gt; &gt; &gt; already-reviewed patches and<br>
&gt; &gt; &gt; remove bad ones<br>
&gt; &gt;<br>
&gt; &gt; But he didn&#39;t spot this particular problem.<br>
&gt; &gt;<br>
&gt; &gt; Dave<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 enomem:<br>
&gt; &gt; &gt; &gt; &gt; @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_re=
q_t req, int<br>
&gt; &gt; result,<br>
&gt; &gt; &gt; &gt; const void *buf, size_t size)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 int fuse_reply_ioctl_iov(fuse_req_t req, int=
 result, const struct<br>
&gt; &gt; iovec<br>
&gt; &gt; &gt; &gt; *iov,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int count)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *padded_iov;<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *padded_iov=
;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 struct fuse_ioctl_out arg;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 int res;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 padded_iov =3D malloc((count + 2) *=
 sizeof(struct iovec));<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 padded_iov =3D g_try_new(struct iov=
ec, count + 2);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (padded_iov =3D=3D NULL) {<=
br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return fuse_repl=
y_err(req, ENOMEM);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt; @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_=
req_t req, int<br>
&gt; &gt; result,<br>
&gt; &gt; &gt; &gt; const struct iovec *iov,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 memcpy(&amp;padded_iov[2], iov=
, count * sizeof(struct iovec));<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 res =3D send_reply_iov(req, 0,=
 padded_iov, count + 2);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 free(padded_iov);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 return res;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; OK<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; diff --git a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; &gt; b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; &gt; &gt; index 3e13997406..07e5d91a9f 100644<br>
&gt; &gt; &gt; &gt; &gt; --- a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; &gt; &gt; +++ b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; &gt; &gt; @@ -347,8 +347,7 @@ int virtio_send_data_iov(struc=
t fuse_session *se,<br>
&gt; &gt; &gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* Build a copy of the th=
e in_sg iov so we can skip bits in it,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* including changing the=
 offsets<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 struct iovec *in_sg_cpy =3D calloc(=
sizeof(struct iovec), in_num);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 assert(in_sg_cpy);<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 g_autofree struct iovec *in_sg_cpy =
=3D g_new0(struct iovec,<br>
&gt; &gt; in_num);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 memcpy(in_sg_cpy, in_sg, sizeo=
f(struct iovec) * in_num);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 /* These get updated as we ski=
p */<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 struct iovec *in_sg_ptr =3D in=
_sg_cpy;<br>
&gt; &gt; &gt; &gt; &gt; @@ -386,7 +385,6 @@ int virtio_send_data_iov(struc=
t fuse_session *se,<br>
&gt; &gt; &gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 re=
t =3D errno;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fu=
se_log(FUSE_LOG_DEBUG, &quot;%s: preadv failed (%m)<br>
&gt; &gt; len=3D%zd\n&quot;,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__func__, len);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in=
_sg_cpy);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 go=
to err;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LO=
G_DEBUG, &quot;%s: preadv ret=3D%d len=3D%zd\n&quot;,<br>
&gt; &gt; &gt; &gt; __func__,<br>
&gt; &gt; &gt; &gt; &gt; @@ -410,13 +408,11 @@ int virtio_send_data_iov(str=
uct fuse_session<br>
&gt; &gt; *se,<br>
&gt; &gt; &gt; &gt; struct fuse_chan *ch,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D len=
) {<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fu=
se_log(FUSE_LOG_DEBUG, &quot;%s: ret!=3Dlen\n&quot;, __func__);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 re=
t =3D EIO;<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(in=
_sg_cpy);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 go=
to err;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_sg_left -=3D =
ret;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len -=3D ret;<br=
>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 } while (in_sg_left);<br>
&gt; &gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 free(in_sg_cpy);<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Yes, this is where the autofree really helps; getting r=
id of a few<br>
&gt; &gt; &gt; &gt; free&#39;s.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Dave<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 /* Need to fix out-&gt;len on =
EOF */<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (len) {<br>
&gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; 2.25.1<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@red=
hat.com" target=3D"_blank">dgilbert@redhat.com</a> / Manchester, UK<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; Mahmoud<br>
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
<br></blockquote><div><br></div><div>I sent a v3 of this patch, and I used =
the --in-reply-to and put the message-id of your latest=C2=A0</div><div>ema=
il but despite this, it was sent as a separate thread, I apologise. That&#3=
9;s the link of the thread=C2=A0</div><div><a href=3D"https://lists.gnu.org=
/archive/html/qemu-devel/2021-04/msg05559.html">[PATCH v3 2/7] virtiofsd: C=
hanged allocations of iovec to GLib&#39;s functio (gnu.org)</a></div><div>a=
nd if you think that it&#39;d better be here, I&#39;ll send it again manual=
ly as a reply to this mailing series.</div><div><br></div><div>Mahmoud</div=
></div></div>
</div></div>

--000000000000ac36fc05c0f84fc6--

