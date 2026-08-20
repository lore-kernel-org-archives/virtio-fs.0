Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693731F8AC5
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 20:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787258341; cv=pass; b=Xkkivq3/dCGa37c0Uf2PWBahiKgjbo5ANwseZrq85MSeLFlb4DUU3mJNsrlDgwbVO1QGy5/bToiem9QTukjQxe0DjphZf5slC/Ucfy9TjjElUw3mMzZYUWkDO9lmJD4skndIEiDHhk3VtF2ypxTOu3InF229caN5yZtEJJR6Kys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787258341; c=relaxed/simple;
	bh=EYg5ibmafC9j0DD3SfwCLFl89icFlj69cyjZlB2N3BU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iyTJZJnUtqOzs9ZXsZ+xu6ib8nL0hDUbuZQYYN8GlWMyq5LMJC89uTNsi/qUzoMUdUaFx/wddmLnNsVKzhV97GgrAuSC62q6E+jFE5wqrYYY7cocX7QLvO6tgK835Q1ICPcaVHth6Uxf4kXyjL2rk2IUVT+1gpAAlyNBLLcaDA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CrzH6yc7; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CrzH6yc7"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-529a1ee0e62so1765701cf.2
        for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 13:38:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787258338; cv=none;
        d=google.com; s=arc-20260327;
        b=R5xJcnF4bvMx8sk9c+FgegU665l1OdbdpVHD7HkgjNo68kF43jSx2d7/prQVnrSOCn
         70BG1Jsq9pZY1wrMM/l7hJnOqXrW1TrpJNlLpcBCmNoeIy/3EFNXY60dVx9W7aBOOJN+
         a3sSRrJGczyJ0W1/tcla3P4z3710AqsldJA7VSS8AidMcaWk26DLq7vd70ak0hInXHfv
         0mZ/tMZUQC+Jfdt164idmWFV8a+Q8Wi61AvqzCOu1Uif7y9gzACjRsevUOwo01FKQMN+
         26rndNGkxFbSPc4ghLkz7/zqNaYrmXC4DV9LP4Oi11TRfbQQ20eU7VVil4qztrUi5T/c
         xgUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yw/70XDHxmOe5vI6aQ6n4t71n8LG9vKd/gcLCxbLG5Y=;
        fh=bivFDi3jojVuXDRh8s9R17cIALcukquxFNgc+fWTVVk=;
        b=EFgsKDVwhf1yh9+yYyp1IEzwaagNVMi1tGQzEhw+HiMyUWUw2JUcVueijlMY72vHR5
         BgFEWhjsz+k64OmvGjHZYm+ABn14zXmnqHQ8DqfWGHSs3+qaahkadGziefnDjlnMjmcT
         J0hpKYXxsfPT33h8iyESuumL8MIb3pNSzpzSfLoOznNAs2eaBOlZAEa66c11qmsY4snI
         AO7kunKZrYxXcY7Ou02yBVP2t669/lmAdBShR9YK0VOVVWvh6kQkEKaevgah557OlMpa
         8Du//jCTL4IVMVhP6Eu+3QbmRXth4+xPwcCwTrzUcAxmZQT/D9bHJVV5xD8E0RPxyhVO
         h3dw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787258338; x=1787863138; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yw/70XDHxmOe5vI6aQ6n4t71n8LG9vKd/gcLCxbLG5Y=;
        b=CrzH6yc7dTMR7dtstMgUKNzsNbtXY1Vw3tMBQdFhE9R6Vm8sVbyZVGd9ni/bbLj7At
         iG/mbgGQPpbYw80S4V+ejEpddVTI8coiaF4QciDCAa3Wfz+IprT2Pvg4wnqIWcAcZqif
         Wc9GPD5S9QolKZ2565zuy2U3g8nmptHcpdA2uh3oVvki2qT4aiNqfI28lNdZq2Zc+tnl
         CFifqbT0av5yfVy9DQMS2vzmSO1JxKOuuKT4DIUmI6NvprshwQYGfrHIX8JDAattRyHp
         YNSybBCG/LORzlZASsHK8FYRFJlKhGtXHLn+kdBK9gaO7CA/fU9EQLri73chjAAssQKC
         GNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787258338; x=1787863138;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yw/70XDHxmOe5vI6aQ6n4t71n8LG9vKd/gcLCxbLG5Y=;
        b=p4BQQi95QSbfaAmZPcGvFWxRiMP5Jg9Ka6w+3HB2lEyyWosnci1vPr5KdkNgeck9LN
         20ger+vEz2XDY3EbGkjO3dF4xz8p55ML/KRvjTS7vaEgM9KiwMhQm5JKTDREINbifCLF
         YFPBgY16RMvsvbRkjZVEmn21mAyFVnd5IjXkFzHWMZ6IGAY9nSudvdXijEL8+85Pj0p7
         AxLHxAoV9jN85aTBaqbkiaVJhnBh/xD83XzKU1929opaf2rT/lb6tc17xS+1RMQ91TGX
         7Sky5Vdw6BLj2ziggz9sSK6NRHz2sbeCsptsgDJqJwrh9eP+l1+OyloQeqYMnfx7+Yi3
         A7Gw==
X-Forwarded-Encrypted: i=1; AHgh+RqkA+/mYGV0PWkh+ISqtIbucevGpCtbC5PvnUs4pQX3kZJWilke2y02/amCHgnwij3rzlzcJntY8nY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfLwR4BX7Dno0itEny5g/G4Y0SYnVezgqADcQMjlX8GNgWRIbi
	KofdW10Pq5tAPf9FgMoyerkFjQzWZiK7ijOKTz3BNEhqmWG52kKFyD5nWWyImtNzqjszwnUXA78
	WD3xNdQXZg4CreTnDro7+72/z9RUnRXI=
X-Gm-Gg: AR+sD130L0HkoMLO29aa7KPzHrrRwpKyiBu/VEZfDDZi7kEFFt9uMNaUQ/1cWkxlZ7V
	suMZ0tyeubmW67PsVI9GZsVZsJFd3afsYm3bQAyJj9KGc3EoABCwSH9Lz4z8J6NvO4DsBX6hlOH
	gkYWmqDMw/b/YSKmY+5vwWHTO8X5+yD2YTMCQuCZOe8mHIfjiPDPlXQkgI8eSZOTkqJpwFBHxOV
	4xgSowftnnjcwWgc8C+nTbwUpv1u0UMYDPtNZhKs5Owe3y+YNYtfpzjSw6Y8PCukJwT48cKGwiB
	Fl8TnKKRiuh9Ur5uZf953lB5TQea8HpPKQbgK9y37WgVJ8y/GX6oStDejs1IKIJRSSDH3YTnXjt
	2SMA=
X-Received: by 2002:a05:622a:1b28:b0:51b:ecca:f2e0 with SMTP id
 d75a77b69052e-52df56f7dfamr12524441cf.5.1787258338304; Thu, 20 Aug 2026
 13:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-9-948aae960abb@gmail.com> <7b4d2e3d-4593-492c-887a-db560d590ac6@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <7b4d2e3d-4593-492c-887a-db560d590ac6@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 20 Aug 2026 13:38:47 -0700
X-Gm-Features: AcwNN1VXrXAFLHLrkZHM8t6w7717j2YQmN1Mi7V8JgTbf-cGaUWANLEc02NuWF8
Message-ID: <CA+spn3qzO_d5n9AOLyhRRu1Tz-ANyh5OfQJgCJP4Dn1+wDptug@mail.gmail.com>
Subject: Re: [PATCH RFC v2 09/13] hw/virtio/vhost-user: add shadow virtqueues
 and eventfd intercepts
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 5:35=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
>
> A whitespace problem remains here.
>

Got it!  This is fixed now

> >   } IsolationModeCtx;
> >
> >   struct vhost_user {
> > @@ -1128,15 +1130,38 @@ static int vhost_user_set_mem_table_postcopy(st=
ruct vhost_dev *dev,
> >       return 0;
> >   }
> >
> > -static void cleanup_isolation_regions(struct vhost_dev *dev)
> > +static void vhost_user_svq_cleanup(struct vhost_user *u, bool reset)
> > +{
> > +    VhostShadowVirtqueue *svq;
> > +    for (int i =3D 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> > +        svq =3D g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
> > +        vhost_svq_stop(svq);
> > +        event_notifier_cleanup(&svq->hdev_call);
> > +        event_notifier_cleanup(&svq->hdev_kick);
> > +    }
> > +
> > +    if (!reset) {
> > +        g_ptr_array_free(u->iso_mem_ctx.shadow_vqs, true);
> > +    }
> > +}
> > +
> > +static void cleanup_isolation_regions(struct vhost_dev *dev, bool rese=
t)
> >   {
> >       struct vhost_user *u =3D dev->opaque;
> >       if (u->iso_mem_ctx.shared_mem_addr) {
>
> If vhost_dev_init() fails after vhost_user_init_svq(), shadow_vqs is
> present but shared_mem_addr is not because init_isolation_regions() is
> not called yet. shadow_vqs will be leaked then.
>

Good catch!  The call to vhost_user_svq_cleanup will be moved out of
the conditional statement so it always runs during cleanup.  I also
realized that it is possible for an error to occur after the call to
qemu_memfd_alloc but before the iova tree is allocated, so I am adding
a check before calling vhost_iova_tree_delete.

> > +        vhost_user_svq_cleanup(u, reset);
> >           vhost_iova_tree_delete(u->iso_mem_ctx.tree);
> >           qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
> >                           u->iso_mem_ctx.size,
> >                           u->iso_mem_ctx.fd);
> > +
> > +        GPtrArray *temp =3D u->iso_mem_ctx.shadow_vqs;
>
> This is a mixed declaration prohibited in docs/devel/style.rst

Got it!  I will fix this.

>
> >           memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
> > +
> > +        if (!reset) {
>
> This condition is inverted. When reset is true, vhost_user_svq_cleanup()
> retains the array so the pointer to it should be kept.
>

You are right!  This is now fixed

...

> >   static int vhost_user_set_vring_kick(struct vhost_dev *dev,
> >                                        struct vhost_vring_file *file)
> >   {
> > -    int ret =3D vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, f=
ile);
> > +    struct vhost_user *u =3D dev->opaque;
> > +    int svq_idx =3D file->index - dev->vq_index;
> > +    VhostShadowVirtqueue *svq =3D NULL;
> > +    struct vhost_vring_file vr_file =3D *file;
> > +    int ret;
> > +
> > +    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
> > +
> > +    if (u->user->memory_isolation) {
> > +        svq =3D g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
> > +        vhost_svq_set_svq_kick_fd(svq, file->fd);
>
> The svq->svq_kick EventNotifier is left set in the error paths.
>

I did not want to close the svq_kick notifier, since it shares its fd
with the host notifier in the underlying vq, and closing that from
here might be unexpected.  However, a safer alternative is probably to
call vhost_svq_set_svq_kck_fd with -1 to simply unbind the notifier,
which I suspect is what you are actually recommending here.

> Regards,
> Akihiko Odaki
>
...

> > @@ -1769,7 +1835,35 @@ static int vhost_user_set_vring_kick(struct vhos=
t_dev *dev,
> >   static int vhost_user_set_vring_call(struct vhost_dev *dev,
> >                                        struct vhost_vring_file *file)
> >   {
> > -    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
> > +    struct vhost_user *u =3D dev->opaque;
> > +    int svq_idx =3D file->index - dev->vq_index;
> > +    VhostShadowVirtqueue *svq =3D NULL;
> > +    struct vhost_vring_file vr_file =3D *file;
> > +    int ret;
> > +
> > +    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
> > +
> > +    if (u->user->memory_isolation) {
> > +        svq =3D g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
> > +        vhost_svq_set_svq_call_fd(svq, file->fd);
> > +
> > +        if (file->fd !=3D -1) {
> > +            if (!svq->hdev_call.initialized) {
> > +                ret =3D event_notifier_init(&svq->hdev_call, 0);
> > +                if (ret < 0) {
> > +                    event_notifier_cleanup(&svq->hdev_call);
> > +                    error_report("Failed to create call event notifier=
");
> > +                    return ret;
> > +                }
> > +            }
> > +
> > +            vr_file.fd =3D event_notifier_get_fd(&svq->hdev_call);
> > +        } else {
> > +            event_notifier_cleanup(&svq->hdev_call);
> > +        }
> > +    }
> > +
> > +    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, &vr_fi=
le);
>
> Clean up svq->hdev_call when this fails.
>

Did you mean cleanup svq->svq_call, similar to your feedback on
svq->svq_kick?  I believe svq->hdev_call already gets cleaned up on
failure.  I'll go ahead and add a call to vhost_svq_set_svq_call_fd
with fd=3D-1 here as well.

Thank you!
Connor
