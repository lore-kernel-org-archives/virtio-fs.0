Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B6282F0C
	for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400230; cv=pass; b=WydFLmx8hahRcpRkeafTMqCg2GFGc5G+JWbHEHl6wHmOLVEVHhMYOafx7r/N1KB7vguZj+V4M/E6WrkDnANioynma9Gn2YaUr5oFkjYGV+JvxGdiH1kacvxnqhxex9C3ZVhaRGV3LUes5lnUThI7Z1DMHzxMQC6kCAJJMrwmb1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400230; c=relaxed/simple;
	bh=HEc69WuM5zU+pk2plWgGySNfipa+oR1wkJv7XYYwsAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fBK7KOAbI3HD/4vTZ9d+iqMVK9ZUoviBD7aR8/sKKR5AELT0i6RMSP/NdfHWKIPeWe5EjNZB2S4Vv4rnZx+dACCvsixMC7vZycwpmjI3Y9aY1W0l7B7nSu0bTtwqJhFGNwZ+RiAm9X/EDYXKSLBtbAVMMos4FeJlQGHNVYQk41g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sypr09QF; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sypr09QF"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c05dcdf49so23704221cf.0
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 15:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786400228; cv=none;
        d=google.com; s=arc-20260327;
        b=li592JhUTJ2YAafbiB6OGMXP3RdCeCUY8XRrmFv0Wu8Sa/GRbWlm5g+gsC2s5KQzdz
         m4oCiZ7VmlAg8jfPn0bC7+jL6+7PSQHSE7/CMdhvCYOVcCMD0VLIZ75rG2X4czkhZ4rz
         Vm/NDbIohk682mRB7ldlfBThxFgwZv4eezR9JXETsl03qVI5J0lCw341s1DSkpN8aPg/
         6hH7TlTQBGtvlasw4wWAt97KOvXIbW4Acg8Pk9Fhk83sE4TdWmV04wNqEwKSlftZfpKR
         Hgx0oIG69J7qwUhl9JOGJG7FQQB2IRW/kTRToY7Xg20dho0Z+tVPws6qemzTeotKCrp1
         rQSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f6D6gbor0YNO+WmjnO+LpeTVG1lSL/c2F8d3w+GaXw4=;
        fh=u1mZvtN5jSv3iBsvii+vErvZuV6nw4nyy4O3dM9k9MA=;
        b=XSV+zLOTboH5Fl9TcDVRW2GaMRc/IfxVB8ACR7Fvma5cNMa33LcKOOfdLubwCaevO1
         2zy7TMy2w/lsGhaXEKXnp7BHS/2PBnbn1Tdetzk05DYNndxB9KKfdoIiZm2Adozb42MR
         RiaajFwebRk9RqFIa4n43Yof80wjdKJn3Jwp4DBvtuYo/q0FrcJWAGMKzaw886ChUizA
         tfXIL7ytJIZWr3UQqJjVcCnZNOzZujOJuM1/BvuUJyRBmCs3kBVvOZNpZaBTNQaZWvoQ
         yT0sOArO335NY1iT2G0+Qp1U10E9ZpVgOQwWNDMeFOqGky17rP/NP4JviHtqb4f6nguq
         a/FQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786400228; x=1787005028; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f6D6gbor0YNO+WmjnO+LpeTVG1lSL/c2F8d3w+GaXw4=;
        b=Sypr09QFuNjgLw6EhWk/y5fIzh157Ls70K/iLvdV0U/t3ChyWnszqhgs5JhM56i3eU
         a1Na/A58KDe4Wg6Do6Zejnf/CqAZgO2nPYG45xREZy2gqrzMyzn5pM4/E239Putiqkrb
         UkMbRAVx5C0N1sKKqGf+EiniBseG3o34Dk7WNEp592oHR2GoADsCTMYGk934jdIOlS8I
         HP/UC1I7eZiUXMepAuv5O6ePgZrhqImL2yVYWieFoFKVNPIATw9VJhuzEq8prHCGMTH4
         R7URZVDN22dsx78eLjVDM+8wvVARSZJIERXgif/gni6V1g2iTAeJ3fWVvP2qCQtvgSza
         +UxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400228; x=1787005028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6D6gbor0YNO+WmjnO+LpeTVG1lSL/c2F8d3w+GaXw4=;
        b=Ljb8rz8GN3a1SPUDHIPYlaWtHzx+2ZAPk2+v+4sNmB4mQEwipv7fbG4p6InYgl71Hm
         pZGDJvRq8Jz88U+kyagf9OC0wO0aI/uPGfFPcu++Qc+To4XmtPEqBc9R/jayZz8Y/clF
         1NVOseHtGSEs20Sp13yyiJboO7aIylVA7aT7VgAo0fB6P1P4z4yrosQFqZHZmcSU8k9K
         anQbAvWEfEB6bBxXrwMlNPDK9hnQ4RjXjbr5H3UsuPhzFAj+KymAV++BZLWvh8b7g+yJ
         cqKpsITt/1lRnK0hx2btYJH3XTynWq1aXhpwFrFqt0Ll/zEblqGT8vUVLfVJIHQU+yWx
         xp9w==
X-Forwarded-Encrypted: i=1; AHgh+RptM9WunhyypcI/xoPeBtmmZAI3S53CPaQLKiRvFrKr/BGyxqyJc2L2xuZdNw+8Yav0Y4a8UBYXbF0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yycd+3C0kaYAyItIqXfdngESnOC4FFN2nUPlNz/P2/4w9b+wE7J
	ZQxjTcHBrE4rj3RWeAwef2aaQu3VePRNtUGFhaNqFpM7jQjh9h5ZNR37vEI9YrBbsuE7tBVF1of
	YJra9i6RPEFaGfNl9eHd4PrfjN+a+wqc=
X-Gm-Gg: AR+sD12dK5e+MldYcTq3ouZ5fpiBUiHC7dxkXnw7ETqCrzM66P7W0ipnZq8NihW16jx
	RuSTRcG3UYmhH9Vs5u1pN06rsMfJy9O1ydsIYK+dj9NcsWSPgZytvv8vSOtaHgFe+Y1n6EG6d0R
	YgCcPF3p5ffUbjWNNa1dc/lWqDL/NjHcsSPAn3HBrj/NWPB4SWAYZDHrzYnkzgqIhsPXVQjwCxE
	rO/CX4d3kDTBND9ufLV024VVffO2bKMCqI5asAlnRMUNurJonpU0HAwVQMwM5+yxnORNHCz17Ej
	qbb77QUMOIT9avRuOUVe0fAgITVeeTUIMfLVvvtKebE2rzJZNJVtnE9Moh5cSWVOjIGgugP16TC
	PQB0=
X-Received: by 2002:ac8:5cc4:0:b0:51c:239:42da with SMTP id
 d75a77b69052e-52d4bba4276mr65739571cf.15.1786400228320; Mon, 10 Aug 2026
 15:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com> <9478d870-641b-4f3c-a5da-9026a0ec137d@redhat.com>
In-Reply-To: <9478d870-641b-4f3c-a5da-9026a0ec137d@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 15:16:56 -0700
X-Gm-Features: AUfX_myccA-zhgRVZD7-2mOnxFmk9MjBYGEJGwyeZxrB-0TE5jnA0X_Yc_F-r78
Message-ID: <CA+spn3qP5n3=-MZQ4Y4BxYF3=LLbUicLVC0kDM9yGoZ-2pNakQ@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to device
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 6:46=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
>
> This function name doesn=E2=80=99t really say what the function does, and=
 more
> describes its type.
>

I will change it to vhost_user_fill_msg_reg_from_tree since it is now doing
the filling directly rather than calling another function to do so.

> > +{
> > +    struct iova_tree_traversal_args *args =3D data;
> > +    struct vhost_memory_region msg_region;
> > +    VhostUserMemoryRegion region_buffer;
> > +    DMAMap *map =3D key;
> > +    args->fds[*args->fd_num] =3D args->u->iso_memory.iso_fd;
>
> Generally: I find it quite hard to read code where general statements
> come after a list of declarations without an empty line, especially if
> there is an empty line later. Visually, this last line to me looks like
> another variable declaration.
>

Got it!  The declarations and statements are now getting separated for clar=
ity.

> > +
> > +    msg_region.guest_phys_addr =3D map->iova;
> > +    msg_region.memory_size =3D map->size + 1;
> > +    msg_region.userspace_addr =3D map->iova;
> > +    vhost_user_fill_msg_region_iso(&region_buffer, args->u, &msg_regio=
n);
> > +    args->msg->payload.memory.regions[*args->fd_num] =3D region_buffer=
;
>
> Why does `vhost_user_fill_msg_region_iso()` exist when this is the only
> caller, and we could just fill `regions[i]` here directly?
>
> > +    (*args->fd_num)++;
>

vhost_user_fill_msg_region_iso existed before the iova_tree was integrated =
in
the code base.  I agree that the traversal function can absorb it for
added clarity.

> As noted by Akihiko, there needs to be some bounds checking. At least
> against `VHOST_MEMORY_BASELINE_NREGIONS`, but even better against the
> array size of `args->msg->payload.memory.regions` and the caller should
> pass the size of `fds[]` via `args`.
>
> (And I=E2=80=99m also with Stefan, something with `index` would be better=
. Maybe
> `region_idx`.)
>

With the current state of the refactor, the size of fds should be the same =
as
dev->mem->nregions, so I will pass that value in via args and do the check.

The fd_num field is now called idx.

> > +
> > +    return false;
> > +}
> > +
> >   static int init_isolation_regions(struct vhost_dev *dev,
> >                                     VhostUserMsg *msg,
> >                                     int *fds, size_t *fd_num)
> > @@ -1234,6 +1275,24 @@ static int init_isolation_regions(struct vhost_d=
ev *dev,
> >                                         map->translated_addr);
> >       }
> >
> > +    struct iova_tree_traversal_args args =3D {
> > +        .fd_num =3D fd_num,
> > +        .fds =3D fds,
> > +        .msg =3D msg,
> > +        .u =3D u
> > +    };
>
> Personal preference: I would like `*fd_num =3D 0` somewhere here, or
> `assert(*fd_num =3D=3D 0)` before the iteration. Yes, the caller initiali=
zes
> it to zero, but it is just not obvious here, and it seems necessary for
> correct semantics.
>
> (And the open question whether `fd_num` should be renamed here, too, or
> can keep that name. Not sure.)
>

I will set *fd_num =3D 0 here.   I can see how it makes it easier to see
what is going on.

It may make sense to keep it named fd_num here.  Whereas its main use in th=
e
traversal function is as an index, here and in vhost_user_set_mem_table it =
is
primarily providing a count of the number of elements in
msg->payload.memory.regions
that have been filled.

> > +
> > +    vhost_iova_tree_foreach(u->iso_iova_tree,
> > +                            vhost_user_iova_tree_traverse_funct, &args=
);
> > +
> > +    msg->payload.memory.nregions =3D *fd_num;
> > +
> > +    assert(*fd_num !=3D 0);
>
> Am I wrong or should `*fd_num =3D=3D nregions`? Is it possible that
> `*fd_num` is less because regions end up joined? Can you add a comment
> on when they would differ?
>
> Hanna

I updated this to check against nregions.  In the current revision, I
do not think
this assertion would be reached if there was an issue with allocating eleme=
nts
on the iova-tree or filling out the message payloads, but the final sanity =
check
doesn't hurt.

Best,
Connor
