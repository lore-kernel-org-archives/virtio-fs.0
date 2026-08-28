Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F99449ECB
	for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787920209; cv=none; b=lMOH3Bf2+iMNPPYMUWmAjrLNnrtdthIbQk8EHIe0kMnW26sNhgAkZLkiwqAw/Wvezq1Mv4VDQjG2QnFHxXnh31fQOaymB498YdR9YMhDoaMRE5kNz2/jt3rUdMiAzvvIVGK2RFlwDxciPkqJTy9rDTCxCQK83u683R2883131CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787920209; c=relaxed/simple;
	bh=ILllsu5ikiueegunkMCyXMWnmS2nst8Ql7JSrW2gFcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XB3kafCyftFU2fxq+vRr8mCQc9+Gsq+SRQTQ5SdXolLuYDQpk8yukyT2VDVPWv3FX5qzfRV9M4jyRyB4m98CToMZ5pr7l5g+GlMqzNeCRyc+jih7QtGGHbDsiFOxHOfxQy6ZoaPurliWzQm7ZHktcbBHEQiFXVO3BjBwYSByi+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ys0UsL+t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ys0UsL+t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787920192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rS19fT4hEDASyIxwXNgxHR0wu0cgKifpCgEwRP35ln0=;
	b=Ys0UsL+tl7cr1ULF8AFSHJau4X+rpInVDF26gbOTTriRG0zNNp5BjuyaV+BrnMrstKiuLD
	N7B6b+jMMxR4ENohZkgi1wIGJyt02NiFSBOY3wuOBCDDVOOjuGf/oNW8MVyI7/OwSeFCGd
	LFK1opE98K3simrb92HQbIEEAYNWfpo=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-XmuxfFNSPMil0RzoVNWrgA-1; Fri, 28 Aug 2026 08:29:51 -0400
X-MC-Unique: XmuxfFNSPMil0RzoVNWrgA-1
X-Mimecast-MFC-AGG-ID: XmuxfFNSPMil0RzoVNWrgA_1787920191
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8563c2a53dbso12493637b3.2
        for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 05:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787920191; x=1788524991;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rS19fT4hEDASyIxwXNgxHR0wu0cgKifpCgEwRP35ln0=;
        b=L9o0P+k5CiGxd17hUUCLOn/8k5ONU7teg83WtjAPHEWIyxbuTX96Go302VcRK7oPPM
         CwRB4a4UN8bdOhLvtaVyD8jYFkpKp8KwIA/Bd9Oofmlj9w5iETjkapKCsl0QMzAupsQ0
         Fg5aotPhC3ZIeNUS5hUiDzgb186JRmF1iNr0zAQcslyuLPPDJ+8Zb2OVAq1iORBLEmn3
         M/lEl+bt4aRxMhFwb0+jFlhqt5ofx8a7j4BqzVxIAiv1A7SgShlnZx81OkLvMVVJeez4
         XiYg2+LzBMyCs6z/zGJ6T5drxhHnNMjhdy2pffjBeIjliXoK3AJdLJZDlHXcFUgg5pUn
         hELA==
X-Forwarded-Encrypted: i=1; AKwUvBzoOjMhtQroibjM3nTvv7ZRPnBd8SmI2WuJgipwXKFvhH/tuasFXQiMMxcDfKgA/I1jh4Go66ENAUA=@lists.linux.dev
X-Gm-Message-State: AFuF++ngNy/x8Qpcb1rbk1cXFkzlFbANAEnyUdnO446+Vj1sMF4cD4Nv
	6cuQ3LUDScGsulMOsnSgUPB+ivL1dCVYAQMj6yrGF0SXfYnKwnqTTDJKWJm2zvpIytZeyKBBeo4
	us3Dm6AwsSzDSksxsv6Bis4lxmT7y67HugYlAb9sOBitDxbyDMHcDUh8yRVZ9RjTzIMcoWGtGxb
	/rpf/Olh8TrBveuliuBeEvPhDUYhUrav20qjzh
X-Gm-Gg: AYBFou1gAsvpjUBgKVqiXsa16RMDuFQmydkP3U1LhqVry91M9/TM/vJkzkDqDWZgvUl
	5oBKiUp5oqlhukAG1DJ4LZZwoRm7sbgQ9seoR12cYBoapbAItkGKjljESHq7vIdsFNh3/k8mHbv
	E/vhV91qgWOQLO5KZ0P/c6Pq760KE/cTW/WJnGCuVkY6hw/wpdx6548WfokPnVGN+3U76qtBQOp
	a9TUK5yZrQIWoPZM3vS9T3onbrdYFjeXcQjMMMl1L6PaTe2Kro2upoBvgU=
X-Received: by 2002:a05:690c:e1d3:20b0:85a:dd2d:906d with SMTP id 00721157ae682-85d69640f4emr23095577b3.2.1787920190754;
        Fri, 28 Aug 2026 05:29:50 -0700 (PDT)
X-Received: by 2002:a05:690c:e1d3:20b0:85a:dd2d:906d with SMTP id
 00721157ae682-85d69640f4emr23095397b3.2.1787920190308; Fri, 28 Aug 2026
 05:29:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com> <20260817-vhost-user-isolated-memory-v2-8-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-8-948aae960abb@gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 28 Aug 2026 14:29:13 +0200
X-Gm-Features: AcwNN1VHrhFHmM7AUF9p_TslU01gI8yN1qi-kPfIWunAI2DiqE197XuGPz9KRpI
Message-ID: <CAJaqyWfCPYY4rFNZGG2EM6Pdtz66KpO0Rx9U2JmZ8UggzKJEfw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 08/13] hw/virtio/vhost-user: send isolation regions
 to device
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, Alyssa Ross <hi@alyssa.is>, 
	Demi Marie Obenour <demiobenour@gmail.com>, 20260817233147.2867623-1-connorkite@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ni7JfWaPzKDB9EZ7WYx-BxAD9oZADn8yJHeBY_LwQlo_1787920191
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 7:12=E2=80=AFAM Connor Kite <connorkite@gmail.com> =
wrote:
>
> Adds features to fill a vhost_user_set_mem_table message with the
> addresses of isolation memory regions corresponding to bounce buffers
> and vrings.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-user.c | 118 +++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 117 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 7e9233e174..e1e5cba53d 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1140,7 +1140,77 @@ static void cleanup_isolation_regions(struct vhost=
_dev *dev)
>      }
>  }
>
> -__attribute__((unused))
> +typedef struct {
> +    VhostUserMsg *msg;
> +    struct vhost_user *u;
> +    int *fds;
> +    size_t fds_size;
> +    uint64_t vring_iova;
> +    size_t vring_size;
> +    bool vring_node_visited;
> +    size_t *idx;
> +} IOVATreeTraversalArgs;
> +
> +static gboolean vhost_user_fill_msg_reg_from_tree(gpointer key,
> +                                                  gpointer value,
> +                                                  gpointer data)
> +{
> +    IOVATreeTraversalArgs *args =3D data;
> +    struct vhost_user *u;
> +    VhostUserMsg *msg =3D args->msg;
> +    DMAMap *map =3D key;
> +    uint64_t offset;
> +
> +    assert(args && key && value);
> +    if (!args->vring_node_visited) {
> +        args->vring_node_visited =3D true;
> +        return false;
> +    }
> +
> +    u =3D args->u;
> +    assert(*args->idx < args->fds_size);
> +
> +    args->fds[*args->idx] =3D args->u->iso_mem_ctx.fd;
> +
> +    /*
> +     * If the number of regions is fixed, it would be wasteful to use on=
e for
> +     * only the vrings. The first vhost_iova_tree element is always
> +     * reserved for the vrings, so we can simply combine the first and s=
econd
> +     * elements, which are contiguous in IOVA space, when sending region=
s to
> +     * the backend.
> +     */
> +    if (*args->idx =3D=3D 0) {
> +        offset =3D u->iso_mem_ctx.vring_hva_addr - u->iso_mem_ctx.shared=
_mem_addr;
> +        msg->payload.memory.regions[*args->idx].userspace_addr =3D
> +            args->vring_iova;
> +        /*
> +         * The size from the iova tree is inclusive, so 1 is added to it=
.
> +         * args->vring_size is exclusive, so no addition is required.
> +         */
> +        msg->payload.memory.regions[*args->idx].memory_size =3D
> +            args->vring_size + map->size + 1;
> +        msg->payload.memory.regions[*args->idx].guest_phys_addr =3D
> +            args->vring_iova;
> +        msg->payload.memory.regions[*args->idx].mmap_offset =3D offset;
> +    } else {
> +        /* Use 128 bit operation in unlikely case of negative iso_iova_o=
ffset */
> +        offset =3D int128_get64(int128_add(int128_make64(map->iova),
> +                                        u->iso_mem_ctx.iso_iova_offset))=
 -
> +                (uint64_t)u->iso_mem_ctx.shared_mem_addr;
> +
> +        msg->payload.memory.regions[*args->idx].userspace_addr =3D map->=
iova;
> +        msg->payload.memory.regions[*args->idx].memory_size =3D map->siz=
e + 1;
> +        msg->payload.memory.regions[*args->idx].guest_phys_addr =3D map-=
>iova;
> +        msg->payload.memory.regions[*args->idx].mmap_offset =3D offset;
> +    }
> +
> +    assert(offset + msg->payload.memory.regions[*args->idx].memory_size =
<=3D
> +        u->iso_mem_ctx.size);
> +    (*args->idx)++;
> +
> +    return false;
> +}

The iterator is already inconvenient in the gtree, and the plan is to
remove its usage when glib minimum version is updated and support for
better functions are mandatory. Why not add a function to SVQ to write
the nodes into an array and avoid moving the interface up?

> +
>  static int init_isolation_regions(struct vhost_dev *dev,
>                                    VhostUserMsg *msg,
>                                    int *fds, size_t *fd_num)
> @@ -1159,6 +1229,7 @@ static int init_isolation_regions(struct vhost_dev =
*dev,
>      DMAMap *map;
>      DMAMap vring_map;
>      int r;
> +    IOVATreeTraversalArgs trav_args;
>
>      msg->hdr.request =3D VHOST_USER_SET_MEM_TABLE;
>
> @@ -1244,6 +1315,27 @@ static int init_isolation_regions(struct vhost_dev=
 *dev,
>          }
>      }
>
> +    *fd_num =3D 0;
> +    trav_args.idx =3D fd_num;
> +    trav_args.fds =3D fds;
> +    trav_args.msg =3D msg;
> +    trav_args.u =3D u;
> +    trav_args.vring_iova =3D vring_map.iova;
> +    trav_args.vring_size =3D total_vring_size;
> +    trav_args.fds_size =3D nregions;
> +    trav_args.vring_node_visited =3D false;
> +
> +    vhost_iova_tree_foreach(u->iso_mem_ctx.tree,
> +                            vhost_user_fill_msg_reg_from_tree, &trav_arg=
s);
> +
> +    msg->payload.memory.nregions =3D *fd_num;
> +
> +    assert(*fd_num =3D=3D nregions);
> +
> +    msg->hdr.size =3D sizeof(msg->payload.memory.nregions);
> +    msg->hdr.size +=3D sizeof(msg->payload.memory.padding);
> +    msg->hdr.size +=3D *fd_num * sizeof(VhostUserMemoryRegion);
> +
>      return 0;
>  }
>
> @@ -1251,6 +1343,7 @@ static int vhost_user_set_mem_table(struct vhost_de=
v *dev,
>                                      struct vhost_memory *mem)
>  {
>      struct vhost_user *u =3D dev->opaque;
> +    bool memory_isolation =3D u->user->memory_isolation;
>      int fds[VHOST_MEMORY_BASELINE_NREGIONS];
>      size_t fd_num =3D 0;
>      bool do_postcopy =3D u->postcopy_listen && u->postcopy_fd.handler;
> @@ -1262,6 +1355,11 @@ static int vhost_user_set_mem_table(struct vhost_d=
ev *dev,
>      int ret;
>
>      if (do_postcopy) {
> +        /* Postcopy is not supported with memory isolation yet */
> +        if (memory_isolation) {
> +            return -1;
> +        }
> +
>          /*
>           * Postcopy has enough differences that it's best done in it's o=
wn
>           * version
> @@ -1278,6 +1376,24 @@ static int vhost_user_set_mem_table(struct vhost_d=
ev *dev,
>          msg.hdr.flags |=3D VHOST_USER_NEED_REPLY_MASK;
>      }
>
> +    if (memory_isolation) {
> +        ret =3D init_isolation_regions(dev, &msg, fds, &fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        ret =3D vhost_user_write(dev, &msg, fds, fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        if (reply_supported) {
> +            return process_message_reply(dev, &msg);
> +        }
> +
> +        return 0;
> +    }
> +
>      if (config_mem_slots) {
>          ret =3D vhost_user_add_remove_regions(dev, &msg, reply_supported=
, false);
>          if (ret < 0) {
>
> --
> 2.43.0
>

