Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47271A304A
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 01:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785720541; cv=pass; b=RHgdEUFsYbr9TYzz0fi/nVfB2qwHe4cklOMXdS0Zs65Rw8cpQm+P7qoSe58pKNvX3SmnXPqEOLEXJsrOjy+gXvJNV8RBdKjImBDo9fn2JZf3FgqJK7bcwr0XoQ2+dAjhWLcmr3X20mZ39H34osZoKAYcIcdzpA2gAXuUQ1YpDOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785720541; c=relaxed/simple;
	bh=qw7im8TIInnU4PFrmRNdmHWEJQSsh5Y6QuIszeMabSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AHdZSMCfUDaU4at61IHw5C8wSB3X8IOd4Kcfo+KmxjGiGxHMBUnyJKnJZY1KhCjkBkoAvPb9v1Gwt4PjUp2hPkLJYlzehYFVSJGgILZ/XZsLCfyXKW9lhlfL6sF3HJnmShNga09KL7iUpjRmpOX9Ny+4zdETXCqZXLIV0U9Msm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XmUW/kKW; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmUW/kKW"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51a868b6962so28307281cf.2
        for <virtio-fs@lists.linux.dev>; Sun, 02 Aug 2026 18:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785720539; cv=none;
        d=google.com; s=arc-20260327;
        b=YX/P47juDnOe0OomVLxwRN05WY3J31584SoXq1FkZ8oH7YJfm7tYfGbpJB9b+q7/R9
         qJ7R2ktBKXEMPO+Mi5/Nh9LCbLivf8uvxU5Y3h7fbIRQCyVfI5Wl24GJMA53kKZKBgaK
         1i7ZEgwWsgyXL9J/SQmUAX4l+MClEyrvRLmrw58qDMkCIszcK0LpTvO5DfCcMk5/DESP
         xfIB0c0RMXLR+XBdpmg18+0ivxS/8iXOBIhi3O31FlIPoEPcPmkd+DS3CailWw9wpVwp
         HLrBAh/AlDNJaKZEGSqqLSUxqSIYc+JJDgLHSe04+ESzOsY+4mwMP7Y6gXy2aG5lhrVw
         QSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BBn0j7iI1Nqb2OtfHct3QoHfOlWs1RAEEWBSgQBWdPQ=;
        fh=VUNLjCKEevccAzz44cIN3rdnN/vTIX9GHkccIXsvbsc=;
        b=cNGuSrdKRRPWmRbIRPzVh37UIUNnQSC9M51Fi4LZaxmvGoLfyTvGgy5TohTaSCv4V8
         Nllphnwq38Q7AlbTk9gDIJNpLhJiwU3MbFr8G3ds73hvKikxOvqcg9bskC9Kt3pGvO52
         amRuNx2YUGUfBRBjXRoAbmJf7h7aPKR4VurE68Ef5/qXMp5iVueRIzoYmx72AnYFXnvr
         mhVMTGVHJ3vYwAoHR3IrDl8tllCqAaLK7vlOWUnNuJzAOvgU0W7wBqM27LcboMyXoh00
         oelBWm8C27yXA3TWS9FP1jeTQrRMiVyJyTaq4rAPD7lHt3+05211aS7LEZD0DFw7DeBQ
         bqRQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785720539; x=1786325339; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BBn0j7iI1Nqb2OtfHct3QoHfOlWs1RAEEWBSgQBWdPQ=;
        b=XmUW/kKWqTomB3SQDT+qXX8H41PPDyr4eCiDA+5i3eqmKbC49eHxj4pdTgCgOeNK/n
         5ExPsEy0/5yryNWP3qxQQca/Yxp061mfbapv34ESke64dgHmzTpgvj/ATEDZj5PMr+sW
         kuPwwPadRlaYCMtbm3wXjxsgnSshXEUkY4oSLUOqAbkHIzSy2qbh1o8PmLADUgd7mHMu
         7PcVWmQj2H1pJFP5k6eydBGznhmbf0+QnesrIVl/wKofkZ2tztP/3kDbKrscOOCd2Qrl
         Mf4CPHm1yyv2J/wErPaqYYok9tBo+ZJvy1roe2AMKC/MvxqFE1Z+B2F9AJbf4EPjjLzX
         tOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785720539; x=1786325339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BBn0j7iI1Nqb2OtfHct3QoHfOlWs1RAEEWBSgQBWdPQ=;
        b=jqOTfcLOHCxw6wx2CAl5FY4YIekYthY7cC5gmtKcy8s5cyoiTOWaVlv6BTDWBx7lQ9
         V8PZpfLlmuoBvkpby9vsynLyJ+kFuH01l+l66BU1ftIIkiFQn6WI1dJow+fKMt7ay75o
         LFW+BZDP+GSS7Akgm7+dYiQq+Xxy0DNOJQPcJqOAhqaLfqXBXK9+2eJsDgyOmjlsrYp0
         XIXfUq8eRD7vQ1uz/1HLPYRO4V3KoezwEco69TdjQ4vwu9Fy3fVQia5ybRIKP6LUm9rB
         /BnajKpPUyv/a6oEsO2sKiDEhLHY9hQoMjAFtCpXo2LWztSeb9km0ox9Z5mnbQLFys7Z
         chng==
X-Forwarded-Encrypted: i=1; AHgh+RofNw/6tPBy0oOBnIL9AHVe/xkffSKRreckMGxqUCS3nEuciu9fXyJlpWqB5mlcK4wI+ROc2rMzcrU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWBys4WGVThrTXojWrxRpzGP5VpfhjcWUBF80WAwEECdW5y2fP
	tpahbpBoVg/Doeq+6qTR7MTy371flbaU3xou3UAd/pZgojsVXFZGDngS4nf3t/kpbFsNygzyBPP
	FzRbZo6g5z8ju568bVSnNPj+ontHKulU=
X-Gm-Gg: AR+sD12WhgfwPEtkRDb7zxhKgQ3I2qnFAqV/7jbXHKpPCqStYJt7rJf6R7EFqKTFurC
	P2w890pathWpXLy1BB4EhaxxwL1ieA47KtLhaGs1C4vOr0Uf2WLYvfOz8vLaU5YLNJ3HFqIbk/E
	6sc8KYTUDMczND/hJo+wwQqjQ3F2JDwKiEnnGuqscb5Ww2iMqnoC+fh75FfRxh05buCRMLx/DDn
	5kIMvLDIGL8xIhCpnAjqgQt0qxge/88/pOUvQn8se0fha/zmCUcxowqevDIGPB0Kw/WuUQwXWIt
	Oe1Pej3h2/zofqBWCoywOzOrB3fOjedYlhSMqT3f+6jgsI1ZhWvZfQs9Klt8NJyO3FA0xeJcxel
	9xSL+xm3D2sw=
X-Received: by 2002:a05:622a:34a:b0:50d:3e1e:7998 with SMTP id
 d75a77b69052e-52b567b2834mr159101381cf.37.1785720538621; Sun, 02 Aug 2026
 18:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com> <9f5869df-0484-456e-8060-b3a9f74a388b@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <9f5869df-0484-456e-8060-b3a9f74a388b@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Sun, 2 Aug 2026 18:28:47 -0700
X-Gm-Features: AUfX_mzZDcm4a9vrCa4Ld9wCsHu6UqJwZERC-Vg76qBXAzrql4EJBxcYlE9h9LA
Message-ID: <CA+spn3oGVk0YNKNcFpiCWqg_EPNjeM9W2UwGwepRND27GP8ydg@mail.gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
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

On Fri, Jul 24, 2026 at 5:53=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
...
>
> u->iso_memory is zeroed before they are read here.
>
...
>
> This should be new_entry as per: docs/devel/style.rst
>
...
>
> The check of u->iso_memory.base_addr is redundant;
> cleanup_isolation_regions() performs that check.
>
> cleanup_isolation_regions() also calls vhost_iova_tree_delete(), so the
> duplicate call of the function leads to use-after-free and double-free.
>

Thanks!  Will fix these.

>
> I wonder if it is fine to dismiss return values of
> vhost_iova_tree_map_alloc() and vhost_iova_tree_map_alloc_gpa().
>

It probably makes sense to add a check here and return with the value on er=
ror

On Fri, Jul 24, 2026 at 5:53=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> On 2026/07/24 7:30, Connor Kite wrote:
> > If memory isolation mode is active for the vhost-user device adds
> > features to:
> > - Gather the size required for bounce buffers and vrings in shared
> >    isolation region
> > - Allocate the required space in an anonymous file
> > - Create a vhost-iova-tree with space to map entire isolation region
> > - Map guest memory regions and shared vrings into the tree
> > - Release these resources upon backend cleanup
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >   hw/virtio/vhost-user.c | 129 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >   1 file changed, 129 insertions(+)
> >
> > diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> > index f296b63fb9..710cf966f8 100644
> > --- a/hw/virtio/vhost-user.c
> > +++ b/hw/virtio/vhost-user.c
> > @@ -18,6 +18,7 @@
> >   #include "hw/virtio/vhost-backend.h"
> >   #include "hw/virtio/virtio.h"
> >   #include "hw/virtio/virtio-net.h"
> > +#include "hw/virtio/vhost-iova-tree.h"
> >   #include "chardev/char-fe.h"
> >   #include "io/channel-socket.h"
> >   #include "system/kvm.h"
> > @@ -25,6 +26,7 @@
> >   #include "qemu/main-loop.h"
> >   #include "qemu/uuid.h"
> >   #include "qemu/sockets.h"
> > +#include "qemu/memfd.h"
> >   #include "system/runstate.h"
> >   #include "system/cryptodev.h"
> >   #include "migration/postcopy-ram.h"
> > @@ -320,6 +322,13 @@ static VhostUserMsg m __attribute__ ((unused));
> >   /* The version of the protocol we support */
> >   #define VHOST_USER_VERSION    (0x1)
> >
> > +typedef struct IsolationRegion {
> > +    uint64_t base_addr;
> > +    uint64_t vring_base_addr;
> > +    uint64_t size;
> > +    int iso_fd;
> > +} IsolationRegion;
> > +
> >   struct vhost_user {
> >       struct vhost_dev *dev;
> >       /* Shared between vhost devs of the same virtio device */
> > @@ -353,6 +362,10 @@ struct vhost_user {
> >        * by the backend (see @features).
> >        */
> >       uint64_t protocol_features;
> > +
> > +    /* Isolated memory data*/
> > +    struct IsolationRegion iso_memory;
> > +    VhostIOVATree *iso_iova_tree;
> >   };
> >
> >   struct scrub_regions {
> > @@ -1109,6 +1122,121 @@ static int vhost_user_set_mem_table_postcopy(st=
ruct vhost_dev *dev,
> >       return 0;
> >   }
> >
> > +/* TODO: Is there any notifier cleanup required here?*/
> > +static void cleanup_isolation_regions(struct vhost_dev *dev)
> > +{
> > +    struct vhost_user *u =3D dev->opaque;
> > +    if (u->iso_memory.base_addr) {
> > +        vhost_iova_tree_delete(u->iso_iova_tree);
> > +        u->iso_iova_tree =3D NULL;
> > +        memset(&u->iso_memory, 0, sizeof(IsolationRegion));
> > +        qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_mem=
ory.size,
> > +                         u->iso_memory.iso_fd);
>
> u->iso_memory is zeroed before they are read here.
>
> > +        u->iso_memory.base_addr =3D 0;
> > +    }
> > +}
> > +
> > +__attribute__((unused))
> > +static int init_isolation_regions(struct vhost_dev *dev,
> > +                                  VhostUserMsg *msg,
> > +                                  int *fds, size_t *fd_num)
> > +{
> > +    Error *err =3D NULL;
> > +    struct vhost_user *u =3D dev->opaque;
> > +    uint32_t nregions =3D dev->mem->nregions;
> > +    uint64_t buffer_reg_size =3D 0;
> > +    DMAMap newEntry =3D {
>
> This should be new_entry as per: docs/devel/style.rst
>
> > +        .perm =3D IOMMU_RW
> > +    };
> > +    g_autoptr(GArray) buffer_regions =3D
> > +        g_array_new(FALSE, TRUE, sizeof(DMAMap));
> > +
> > +    msg->hdr.request =3D VHOST_USER_SET_MEM_TABLE;
> > +
> > +    /* In case of reset, clear old regions*/
> > +    if (u->iso_memory.base_addr !=3D 0) {
> > +        cleanup_isolation_regions(dev);
> > +        vhost_iova_tree_delete(u->iso_iova_tree);
> > +    }
>
> The check of u->iso_memory.base_addr is redundant;
> cleanup_isolation_regions() performs that check.
>
> cleanup_isolation_regions() also calls vhost_iova_tree_delete(), so the
> duplicate call of the function leads to use-after-free and double-free.
>
> > +
> > +    /* Gather information for bounce buffers to be mapped */
> > +    for (int i =3D 0; i < nregions; i++) {
> > +        struct vhost_memory_region *dev_region =3D &dev->mem->regions[=
i];
> > +        hwaddr size =3D ROUND_UP(dev_region->memory_size,
> > +                      qemu_real_host_page_size());
> > +        newEntry.translated_addr =3D dev_region->guest_phys_addr;
> > +        newEntry.size =3D size - 1;
> > +        buffer_reg_size +=3D size;
> > +        g_array_append_val(buffer_regions, newEntry);
> > +    }
> > +
> > +    int num;
> > +    size_t desc_size;
> > +    size_t avail_size;
> > +    size_t driver_area_size;
> > +    size_t device_area_size;
> > +    size_t total_vring_size =3D 0;
> > +    size_t total_mmap_size;
> > +
> > +    /* Get space required for all vrings */
> > +    for (int j =3D 0; j < dev->nvqs; j++) {
> > +        num =3D virtio_queue_get_num(dev->vdev, dev->vq_index + j);
> > +        desc_size =3D sizeof(vring_desc_t) * num;
> > +        avail_size =3D offsetof(vring_avail_t, ring[num]) +
> > +                        sizeof(uint16_t);
> > +        driver_area_size =3D ROUND_UP(desc_size + avail_size,
> > +                            qemu_real_host_page_size());
> > +        device_area_size =3D ROUND_UP(offsetof(vring_used_t, ring[num]=
) +
> > +                                    sizeof(uint16_t),
> > +                                    qemu_real_host_page_size());
> > +        total_vring_size +=3D driver_area_size + device_area_size;
> > +    }
> > +
> > +    total_mmap_size =3D buffer_reg_size + total_vring_size;
> > +
> > +    /* Allocate and map an anonymous file to hold the isolation region=
 */
> > +    u->iso_memory.base_addr =3D (uint64_t) qemu_memfd_alloc("iso_r",
> > +                              total_mmap_size,
> > +                              F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEA=
L,
> > +                              &u->iso_memory.iso_fd, &err);
> > +    u->iso_memory.size =3D total_mmap_size;
> > +
> > +    if (err) {
> > +        error_report_err(err);
> > +        cleanup_isolation_regions(dev);
> > +        return -1;
> > +    }
> > +
> > +    uint64_t last_addr =3D int128_get64(int128_add(u->iso_memory.base_=
addr,
> > +                                                 total_mmap_size - 1))=
;
> > +
> > +    /*
> > +     * Instantiates iova tree sized to map bounce buffers and vrings t=
o the
> > +     * isolation region in host va.
> > +     */
> > +    u->iso_iova_tree =3D vhost_iova_tree_new(u->iso_memory.base_addr, =
last_addr);
> > +
> > +    assert(&u->iso_memory.iso_fd >=3D 0);
> > +    DMAMap *map;
> > +    DMAMap vring_map =3D {
> > +        .perm =3D IOMMU_RW,
> > +        .size =3D total_vring_size - 1,
> > +        /*vrings are allocated on tree first, so will be assigned base=
 addr*/
> > +        .translated_addr =3D u->iso_memory.base_addr
> > +    };
> > +
> > +    vhost_iova_tree_map_alloc(u->iso_iova_tree, &vring_map,
> > +                              vring_map.translated_addr);
> > +    u->iso_memory.vring_base_addr =3D vring_map.iova;
> > +    for (int i =3D 0; i < buffer_regions->len; i++) {
> > +        map =3D &g_array_index(buffer_regions, DMAMap, i);
> > +        vhost_iova_tree_map_alloc_gpa(u->iso_iova_tree, map,
> > +                                      map->translated_addr);
>
> I wonder if it is fine to dismiss return values of
> vhost_iova_tree_map_alloc() and vhost_iova_tree_map_alloc_gpa().
>
> Regards,
> Akihiko Odaki
>
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> >   static int vhost_user_set_mem_table(struct vhost_dev *dev,
> >                                       struct vhost_memory *mem)
> >   {
> > @@ -2681,6 +2809,7 @@ static int vhost_user_backend_cleanup(struct vhos=
t_dev *dev)
> >       g_free(u->region_rb_offset);
> >       u->region_rb_offset =3D NULL;
> >       u->region_rb_len =3D 0;
> > +    cleanup_isolation_regions(dev);
> >       g_free(u);
> >       dev->opaque =3D 0;
> >
> >
>
