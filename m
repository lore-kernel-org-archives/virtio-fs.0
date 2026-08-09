Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C571AA1D5
	for <virtio-fs@lists.linux.dev>; Sun,  9 Aug 2026 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786237968; cv=pass; b=GMsGjjAuWUa/8gARFKIg34IJvAUhtssVdNdBNH2bTvqRlsjTwP0ymS9qBwtVi4mlJB+4zWIO6tSk8axUaJosNO4GuJpzi42wWH0PD6M82VRvDzJ6eQi+lX3z7yWPLWjgK0GYz5aTkgTxX7IBVLOK6miNlZF219qYHjLoRuN12SM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786237968; c=relaxed/simple;
	bh=v14EQvWv4Qosl8WQCer5k3JvuzIb7+/qt7upv0yA6hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NU+4qdbOEzCqlnMgaJhme4Y7wTg94wfbP5FE0mUnR6hnkM8k9VSo0V/358l/dLfTl40lce9kxnTqgeFKFMNOsdR9dYPZsfqg4asJeigQKj2DoUNQ0VUuxAhrsENhAHMupLbefKiwb2IJvS33hO7vAf10bxtQbB5L3ue5+PlxCxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=InCzTD7K; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="InCzTD7K"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-902e4af2d9dso23925756d6.0
        for <virtio-fs@lists.linux.dev>; Sat, 08 Aug 2026 18:12:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786237966; cv=none;
        d=google.com; s=arc-20260327;
        b=DmzSXB+C3jGmZWMXehcFAyQ9oa5OJAeB+Iv2q1D/IWlMwOmospiBU1gRT1h7TuzJee
         AA1tw0iTSXsihB5z9St7vGEkLG+Gjxe6YRJRIXeXt/HgzvcLrKT4yTOWystbpXki4ZmM
         4wtSXqpSL9+23OgXPflyQbc/03AlokQ9aypzdkoGvxg8JMeclqYXIIZLsUzziaUqgKie
         knX2XG0dYCNWJVzt3n8NCZds0CxgXHXWCa4Rv54b79PP2x66Zs1gArQ8A266HzpFxaH0
         Et9SxMYACTjo9tk0i6DpLKxTqmmvOBz3k9H32oOR/BKeUOETaqvs4jkZPzUVNNI9K3s5
         qxzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oeosGuK36+CiGElvgIGQyKSZr37C83sK8Cdq9TcGXmE=;
        fh=cWZIkwqu5Q5rLmMDC2O/lEdYzEs0uOncU57cwKHzPrY=;
        b=qSKkP02jJo+zWk9rOjKI0Yc5j7Wd9/f3BuI6PnIPB5dOT+sobFxBHxSLRZY/yal1Zl
         QpV3bdlLqp1yqXKIAKkYbOzIehGryORH32q4QaKrUnvDh2ULXh8htUQu9pM1PY8kTAwO
         3zr/M/RDeb7HrEwQrdMHQLmCzBheGn3CaWc0z/LExSYzmVm3wXwc7+j3K0XNT09jz241
         v0Y0UzDABd1895nIPBGXO1bBCkLV01E4ik8P9nH8IoKQrA6ty7S9gdJ4feAcXt2lZYZ8
         jxCX7JvD5sB8eU9kVXPwdauiGoJZO0IcP5PBpQsp//kypqly91fd9H3Vg+0Cndpb2wKo
         MSFA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786237966; x=1786842766; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oeosGuK36+CiGElvgIGQyKSZr37C83sK8Cdq9TcGXmE=;
        b=InCzTD7Kp2P1sT4MtcUfXicva6BLiRbdyD95tkVnA4TTIxz6ToIAvuglSubz8M+0JA
         PmuTw+HQz+0WuzS9C0LoQXbIBjNEV3QtsAg6zO+G8ju7sACcwvC2n1QD9NVP/PGWZiEf
         Vmqz1thIsdjcbLLSKdbR+ztcnikBuyhgMeap/GJb3UEBGESnV/8zxUvtbejpJmCGWtbx
         n8orB1XjapB2tGYai71CmOghZmD3K9KC7gw37cSUGyFK6vnm1y8eT+2tk1IILv4QSwBW
         8xfD1w1lKGdq4poikrlNXv2djqk3LlWTrR6+3R6ca90a/pV/542Io5bvZEbFtBogH5D5
         k7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786237966; x=1786842766;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oeosGuK36+CiGElvgIGQyKSZr37C83sK8Cdq9TcGXmE=;
        b=BRhU4UmBLPH9ftM4cnf2nKF164VHm2rYJWGRcsRBgp3OxOuNKL4/ddffQZ2cy8f1gI
         7cSpkaz0yQQ8hvxDvVSJ0TVHO2bSMusXSw01ncOhx7KYg02JG6Ri892/GgRmOhb1oK94
         1rOG7vuIq99x17i9Dg9GKifR+OWOSLOhxCmfZujl+DysHbYOsfnWRDnPB0e4iZpip65j
         d7sA77PSHEAVgOdKiwjgTSu8dtWQxv3JlgxOEcUj1U/sqCvSIs7WapGFz8joR7p9bEX6
         54tc2hBk9ECipupb5EV6ypDS5JSI7Db90oAsIic36gbKHWWqR7rkOJRIslS8jWFbvvPZ
         3Rcw==
X-Forwarded-Encrypted: i=1; AHgh+Rrw2FYaw9eQraUOp3i9oXOApdLSDZc3jeizVwnEqJk0kKLOSpX9cPGVhsdH03WFbAvN1pojXHE4JBk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO4hjhefCZXTcW+FJQZcfGh29FSmkaWJVfPP6W2C188jwniGGo
	S5un3By+hnvmnArzLd6yeI6MYlaOVV+4rOYYHeszIlV0jCyW9B9asyX0jwDf9XkHghmFuuatOU9
	byL/25QzaDntIp63gkOwTY4By23m/oYc=
X-Gm-Gg: AR+sD13/88QlHrAG6Uf4+L9w/6tooSvijkwCAD7XKoxDl4RPF0xdKZUNOQuZCj70yJx
	sOY/RELCm3xqf4J86hvTxRV/xBMgsSdh6GK8q9GLcE4zWlBoUL9Z+nShAnBKksQtkM0ioO7giCX
	9S9ethD6pI9zTz7Nf2QEA/Y8bzoydXtICPepObdLVoDMXJbCuqcx+T+0AVy9VzKaGn64uR7NTD5
	RKa9TFLMV7Dq0wVozD+DI4RxPQOvSOzKSM6YTEjYrBYxikQFLDFR7JQILRC8yrSBOX2FZU9KAuU
	dh6QP3ADkjcUwSOaAyz4s9432vX8fb6JqanbAi9ai2Z8d0+zycvVbHnqmV0X9Xqy9ykn5Ta79V1
	IOIfsELtXQ7jiAA==
X-Received: by 2002:a05:6214:cc2:b0:8ee:756a:bc32 with SMTP id
 6a1803df08f44-90a368a626emr96602356d6.15.1786237965759; Sat, 08 Aug 2026
 18:12:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
 <20260728175931.GI371693@fedora> <CA+spn3qkZ-2=4q2nn_6-wp85U4Xv3oaDAmCHEP_yB=N4aZSceg@mail.gmail.com>
 <20260804181659.GB488200@fedora>
In-Reply-To: <20260804181659.GB488200@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Sat, 8 Aug 2026 18:12:34 -0700
X-Gm-Features: AUfX_myvKgdgkcyJlFGjsDxh9x8pv4UyzdubzO67GxszwLXORfVMql0EMYJiR1o
Message-ID: <CA+spn3rkBeV87Umb81cJyf6oMg7E=Z3SmOHvrqgm-nQC6yrvJA@mail.gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Milan Zamazal <mzamazal@redhat.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 11:17=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Mon, Aug 03, 2026 at 11:26:29AM -0700, Connor Kite wrote:
> > On Tue, Jul 28, 2026 at 10:59=E2=80=AFAM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> > > >
> > > > +typedef struct IsolationRegion {
> > > > +    uint64_t base_addr;
> > > > +    uint64_t vring_base_addr;
> > > > +    uint64_t size;
> > > > +    int iso_fd;
> > > > +} IsolationRegion;
> > >
> > > The purpose of the base_addr and vring_base_addr fields is not obviou=
s.
> > > I suggest adjusting the types, names, and adding comments to make the
> > > purpose clearer:
> > >
> > >   typedef struct {
> > >       void *mem;           /* mapped shared memory */
> > >       size_t size;
> > >       uint64_t vring_iova;
> > >       int fd;              /* shared memory fd */
> > >   } IsolationRegion;
> > >
> >
> > Agreed on adding clarification.  Is there a reason to change from uint6=
4_t
> > to void * for referencing the shared memory region address?  Most uses =
of
> > that variable expect uint64_t currently.  Here's what I am currently th=
inking:
>
> The shared memory region address is a C pointer where the shared memory
> is mmapped and the type for an arbitrary C pointer is void *. The casts
> needed around qemu_memfd_alloc() and qemu_memfd_free() suggest that
> uint64_t is not the natural type for this.
>
> Keeping this as a C pointer helps differentiate the address from an
> IOVA, making the code clearer.
>
> Also, with the comments about base_addr below addressed, the
> hwaddr/uint64_t uses will be reduced.

Got it!  I will change here and plan to default to void * when representing=
 host
addresses going forward.
