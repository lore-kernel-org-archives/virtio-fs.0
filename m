Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6BB3B1ED1
	for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 20:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000031; cv=pass; b=gL94u6+HSF7REZOacw/XojSjxCSlZdl/PES//wCaGmIJqb68YACVAECqZ1DHaxu6t6Irqw+6jhdOKd2yDqnsA3GxehUKhkv8tR05PFUIMYVo5BL5JOUq+Eiwe51JuYStogtOxDJxrguWKVzvkysez5jPBURtjgG411Z2//WTFQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000031; c=relaxed/simple;
	bh=VqnDe22I5ewnOPZrvcePapq1uWvw2SNR1Huaih0OYI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zhwr0Z4i9CYmaMp/Xm36Y1VfQGit5B3ABsY00ZBUNeTdatAYR4Ov+nQ8MTsLEBliN2GPvl1HmnedzszJxU91oI5Qwwya1TPTCRuCAmjn5+1UnxP44NkOapAV+4hpVvA/oaajTwQqwJUcTODpoKlA8sV13/kfCWNKOdN2P1vqatM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i63l4KRu; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i63l4KRu"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c1372f84dso27597551cf.2
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 13:53:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787000029; cv=none;
        d=google.com; s=arc-20260327;
        b=SgX2sBJ5BHFDLYxo0jAldtRBsU9k38m2o82zaT2o8kt7cRaIqUxGyZ7hK1FKZApplY
         EwR2KsPhTwz+QNpbS5u0ARRwzyC8ETziQwb762axNKLd0g5zhjQMtwFzszpl68wJW1vS
         WJJgDTGsmASgXzQZcHst8K2tJilguw1e5mpxTqeIZlzKDmW7+ntJ1vYhGJriwyFrLBt/
         K4mwdg2qQeUve5764tEI3vulwNkkqLtpY7JPMdx+ba+v/z3jD577WnJ9QqJCSOAPy5iY
         zH9srmb1g0ronDnrYmu3tcTHZn9qNyWW57h3Rs45KyD9J8wlts3M8L8lgpsI9o7JkBvx
         Zunw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0n5MfU7yibKqE+ZJhzMTB35Y7Us/BO0Y6mv7YhPXB+E=;
        fh=JMZUw/DiKfpuAADev5/ikqLfbt6IFlMxdhurnXNsgO0=;
        b=WBR82Xl23a0m3Xs3E3qHrmdBgrg0/WxJWhFQksA4ZoU1ApV+Tn5NmLm9od3XmYAOXB
         PgZyRpWkswJ3nmie03XaHkOTue1ZqofxYjS73jbJb9PQmEp81VCvpS8+A3csZ/CabU8j
         7JMgeX7yApF0BxW3Qhi4RNrHN6SQENYT9Io7kSRpw7Yb5uUJrud37DgNk5tkFWbA1PqS
         pJUcihNpnIfq7D5bj5o4Ddzt/+eQJke+zctzs0o95JfvcZ/FXBs3i0Y/aXhikHBodo8Q
         DESOpdUXMQjBQlD7SbspFCqb2mFN+rmzjXpeKTmSME8vyEwcpoYiiyVqCq9lt0rAUCb9
         8DRg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787000029; x=1787604829; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0n5MfU7yibKqE+ZJhzMTB35Y7Us/BO0Y6mv7YhPXB+E=;
        b=i63l4KRuIVn6DoImgPc0aD2vGNA1Bdixq1cqpDKzl4H49dIctHoHvl1FkjHnDbHwOk
         ee01z18/+GJdNnKvynZRDGRdWn1g5St5HS+oaXQ1LA7b9IaUyFJPXpubaGxyHZbDhtrw
         UcgRACXOHPxAh8Kmg8k0Ac3BOvyO/T27zK7KzL4g86yaSCBXqZaW554Uf6rHoIlCr1Pu
         VQd3YouANoyw9T7Sbk17zITiY4QWokZtRPvFGwrZRQdiCE9Ly4zeH6WCLE2Lxck4i6IJ
         Yu8bnP5jboy8rBKdzXNv5kommwlPAFOQW2YR9F2idiIXm8GGgtXVpiZWERNGGAKecB4N
         99Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787000029; x=1787604829;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0n5MfU7yibKqE+ZJhzMTB35Y7Us/BO0Y6mv7YhPXB+E=;
        b=Quv5bKsTkndzqygSyH7CiVqTyS5YnpYyUd5qSw0h6vtu7Orqp4XP1AiYRK7fLlpSGZ
         G55QQ8NYMuALN1GtZViDwqAlFwVSyW3lHus8MI41jjqFzOhlmIY/YLNkFjENqYpDepKI
         rtlQvv37rYB5NSE/bBgmBlrdMflvUPUKtUxiKcfJJi6zFaPwEkYm7SdwoEaMFIRMNv14
         V11v4vTUOnE4zmq16NC73Dj3Jw7Y4eZFT/PY1S4WniorXOBWyhWeJNiMILz0IaJWJbzd
         oxlblhsyhaDbm4aHtW9vg0YKxsLtisnZaqXf9LHi/LcbYwtvb0QRse7dljYHOWfLw7if
         bRXg==
X-Forwarded-Encrypted: i=1; AHgh+Ro0V/We3edG7TrUkGHALbFe644DWX+iA+3g9Ct4JTXvUVVlqkzf4eyjFIiZKWaMoK9cwoa8LPcQRIM=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywb/pqRvlXXKPwKKKmGbE+PKCzGbpZCka7RObkqUv/KG+79/o2r
	uSs9UgMMFtnOC2zjWzOzUE5d8uTBlE1L4pqMUDwQvFk9dYZnmVA58IcTy6wYB42n6frwfCv+9pg
	SOZLSEEaNFoJBbeJ86gvulkqiEubF1dk=
X-Gm-Gg: AR+sD13MDOUs+1Ycxjr6KXelbI5trNYS08O/gQmerRuOYXE0fhRamNVFiAActVCV9P3
	lbAfsNmG+ajqVN43klTlZxP/8QoWJCRmYEZkYsw450DCmaY/B0m97vHX+jmEB9rAmCZ8CFo0e8F
	HHREGmEH7sCwvqPCoFhSO2WYx4IYMV0Wsy5ZPa/PZpF8JnrZTXpspkgg8RYJM2fu319C4Qw/DLn
	qFWXq4Nn35XsLd5J4x5Mrl/5BIcR9DIRHvrxGtxHcs877S29zQZ2esQUc5KajNatdrJJaSGQFUj
	mHxXW15MNK61JCvHOVMvkm3CEm0KNlrW2f9q7fnlu6tH6Zb/FMboY9UR4l0ZkDQkA2/xmeObi0f
	CHw==
X-Received: by 2002:a05:622a:1104:b0:517:c65c:488b with SMTP id
 d75a77b69052e-52d8523888emr294661901cf.0.1787000029201; Mon, 17 Aug 2026
 13:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-15-6b97c439eb28@gmail.com> <1257210f-15f9-47ab-b5e9-05a3ee4ef8ba@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <1257210f-15f9-47ab-b5e9-05a3ee4ef8ba@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 13:53:37 -0700
X-Gm-Features: AcwNN1XcQxywyKXeKRa9EllVjvEsHt5XOsrfdWWYvqBRCJgOAfFKiLdxZi5NtD8
Message-ID: <CA+spn3osjNAokBGi-hERm4z-Gwz22ORQC1Ag65okv-HSrZ9JVQ@mail.gmail.com>
Subject: Re: [PATCH RFC 15/15] hw/virtio/vhost-user: shadow vq cleanup
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
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

On Fri, Jul 24, 2026 at 8:22=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> On 2026/07/24 7:30, Connor Kite wrote:
> > Implements functionality to cleanup svqs on cleanup of isolation
> > regions.
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >   hw/virtio/vhost-user.c | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> >
> > diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> > index e65f877f9a..bb4de78b95 100644
> > --- a/hw/virtio/vhost-user.c
> > +++ b/hw/virtio/vhost-user.c
> > @@ -1140,6 +1140,15 @@ static int vhost_user_set_mem_table_postcopy(str=
uct vhost_dev *dev,
> >       return 0;
> >   }
> >
> > +static void vhost_user_svq_cleanup(struct vhost_user *u)
> > +{
> > +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> > +        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
> > +    }
> > +
> > +    g_ptr_array_free(u->shadow_vqs, true);
> > +}
> > +
> >   /* TODO: Is there any notifier cleanup required here?*/
> >   static void cleanup_isolation_regions(struct vhost_dev *dev)
> >   {
> > @@ -1147,6 +1156,7 @@ static void cleanup_isolation_regions(struct vhos=
t_dev *dev)
> >       if (u->iso_memory.base_addr) {
> >           vhost_iova_tree_delete(u->iso_iova_tree);
> >           u->iso_iova_tree =3D NULL;
> > +        vhost_user_svq_cleanup(u);
>
> Memory-table refresh frees live SVQs permanently.
> init_isolation_regions() uses cleanup for refreshes, but cleanup frees
> shadow_vqs; they are created only once during backend initialization.
>
> Regards,
> Akihiko Odaki

Got it!  This should now be resolved so that the svq array only gets
freed on final cleanup, rather than on reset.
