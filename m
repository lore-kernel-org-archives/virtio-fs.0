Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA2F43AB0
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 18:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785781604; cv=pass; b=ENN/8zOMe4s3y1fdKLQe9hsvz7W+LI5L9RoT1iMyY7FUSqSjqojQcJbVctQ/j30i0RBzQOBYFRv1BNw6I1Zdlca+i4YJ6xq4v7LxnBzhRhUb561DFYmP9HfabOeK+cB6OJ2H3WLs5j4OlNPZDRACIpyssUxlvQaVyQgt6IzQffw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785781604; c=relaxed/simple;
	bh=Xxdaz53LHhg8uTBJsKG9buYcTEEGlM4bzfaRSwkPp/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ksTTjjhy0TMI4bHFOTBCNRanqfXcbBV1NPb71HkFra/RV1HU/ljXlMGn29giOuNfQtfxkKx03Afv2LGvSFn2kLqlyvnQD5nTAkzBPDxxC7jj1RC/c9jAvKqEYEHva6QJZJkvmUujXsWAYa+kodC5kzRi5cf4xrDRseGEQO3BQ0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aM1IMe6k; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aM1IMe6k"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93108a3c326so12471585a.1
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 11:26:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785781602; cv=none;
        d=google.com; s=arc-20260327;
        b=Rrxi28TBSjPtpsA+W66dqdfDjXBJBso4BRbH56wZrw82YacBJBeeYWzE5EUsVxpeJL
         jANDulmyn9hmDiBLzGvGbeFgd/mijgKO+EAhGRkpLTQ9EYmQHtEpGVim+oQ5G1VmHCvo
         43V8aIvRkR8nDrUbEH4JvTFR6VOnR81zZyzmyKKZVSd5qR+w5k/QiA/GDtkmcQT6BlTd
         Gca1natddd859Jlmg/O+0NAR9OID74CNfpZMuUna6gBeqPIJVFL/z5DhJWg06isLAQa0
         H84UgsfIG8I5THkSXtHxXeLjBHC/pfslfHQ6OTgvgdCcsw8dbNtrfCeQBDFti3DlXJv6
         88aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cU2cx1htDUJjTg39cgrGf62olsMzxqfpRXt77GHEV1A=;
        fh=MRn1TyCtcmR4TZK40YA0UlfJ2dcsx818B/I39NQE7ls=;
        b=l0XcNiWcrcd0g1TaLs9jQeraVig1Ksk73j/D+jMDOaY1NvD8lWBRJiSecjV7+gmiqw
         hb0G1e9pZoYGTcAumJ9yOnfjtdeZpMAEm9T3A49LjDzNJ9QYaGGYxfYwJUAqooT0u+2i
         pTJ4ceVTAneX+3zCt569TiQaOzavBDhAPjg/bywW1yPenaZquQRKr7RoVKCObP0Awt1D
         YVvw9rlriQygK047lbcLH9uff9I2O3TkvGJXXJx8IwnlGioKANMg62OMvJEMhAoKjxeI
         f3Q2GdHpSylusUBIPSEVFmHo6BsaYUVpEL9vzAG+njMX2r9JS/45osM9AOaNkQtrva6E
         KM4g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785781602; x=1786386402; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cU2cx1htDUJjTg39cgrGf62olsMzxqfpRXt77GHEV1A=;
        b=aM1IMe6kKZYUnxwJyJBAHEy8vw/hNtGnHiv+s7aLx54dHrcly8kyz46ZRca+YFjgYd
         FRxxBDEIytnEyDjS/OnZnsI6ueMRnoVkzDtHtSOh0lPnfw0EtA+uHzbPGJryG4dQT5Sd
         o2Bn9aEvZUhe6aISIP7GsUPgQDXD2u8jiOo/uRcXq+6rAQdJX9370FUc4vTahlsdQb17
         x7SHkevs6UFiXKbocRmCnfl9FWku3rhFQzrv8W+P5VnY+rjN43FOdgDzEI0M5aw75Bdx
         1+MuqZ6OCbYgrfyi1MNurJ5+qcKRejh527HDKPWWx47Rg61j4sxlNNDqq5Tn1Rm54Q8V
         /qYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785781602; x=1786386402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cU2cx1htDUJjTg39cgrGf62olsMzxqfpRXt77GHEV1A=;
        b=ZAOi9ljthhEzSNROvc8h8KUWvH+h2uieGdRHBUUjIRzE0FbSW0N823E2vCZ+9CyW1J
         q0iou1qq42YFxLjmRmRIA9y9IeN+wrPFFpkU39ckd72w89daiVRXNZMie6GKPyjkF6Mb
         /ysodfJCYVs+89o5LkfPuaaUQxjtFVUBxtYfsNqP+bDBNND/Dq+qH1DrRDElLtaq2NwH
         2ny/rKBgZZzle7mNqwao5y4kq1tibiCF9/8U6hsmVROON16aoA6RV8ZXEjONIbH1fWF+
         jgdZSyPN/BQi6RN9mocXnLbB6PgZXD1K6m3dBH3f1y75vfsw2m8TZUKkTc5p6SY0BTg1
         xrLg==
X-Forwarded-Encrypted: i=1; AHgh+RqRZOyPE9jGyxyQ3PJiGZSZzlTGqPXQH57U2cYjUiLNgWtJwWPxFBY95+NJ2MSu2DoC15LO8k7OB0E=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywcz86Vp1DLbR3uNVBj/uVY7Ha11HjqZfFIcZysKvp+02bnsC56
	tQrgaiIo+6lVOv6ZTM47uMZ57WCCpXON4tXo6bOAm6e6lXO+duTmG5q/XN3eRDM/SvLVHIBXiQp
	hOhTVWB3QHj4mqUKZqjH+jhmohmm11J4=
X-Gm-Gg: AR+sD12oerJHTnMaP39XeOm87vOu4rcw2CMeGpg2r0XxOiYKzlwjU0l+QjhmpvoJ573
	jIyJbwpR17WLSqTAKwGr14/R3MpoErDcJCTjIy4ZxATz96QjiHVj8VMhCAOOzLajutZuACLmujH
	CYcB2EDia25gnytjBEkkGgPDyAmHL13OzcLr4kXbMbHO0YwwrA1Bjk10Ash2K6NGDcx5g+6esG6
	UJPllhyHops1acCmHeDpQognKbhli/vkf3EE6E8NTOJvE3/IE5pEjSEB4+ByOOzZzk/LzLYOXep
	zJZy0pQjlkDiyzzgmLvWsb14A5pY0hosqm89UvflFWGIO4ZmKS6LghX4iRO/XQtysuLq6wZ4lqp
	e
X-Received: by 2002:a05:622a:5a13:b0:517:146d:2cb5 with SMTP id
 d75a77b69052e-52cd35f7718mr14076591cf.20.1785781601773; Mon, 03 Aug 2026
 11:26:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com> <20260728175931.GI371693@fedora>
In-Reply-To: <20260728175931.GI371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 3 Aug 2026 11:26:29 -0700
X-Gm-Features: AUfX_mw627TW1QIKX7ZVVWRqH-pVbRrnDnqjVkySiArQktWAgdvKFLa79MaLLGU
Message-ID: <CA+spn3qkZ-2=4q2nn_6-wp85U4Xv3oaDAmCHEP_yB=N4aZSceg@mail.gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
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

On Tue, Jul 28, 2026 at 10:59=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
> >
> > +typedef struct IsolationRegion {
> > +    uint64_t base_addr;
> > +    uint64_t vring_base_addr;
> > +    uint64_t size;
> > +    int iso_fd;
> > +} IsolationRegion;
>
> The purpose of the base_addr and vring_base_addr fields is not obvious.
> I suggest adjusting the types, names, and adding comments to make the
> purpose clearer:
>
>   typedef struct {
>       void *mem;           /* mapped shared memory */
>       size_t size;
>       uint64_t vring_iova;
>       int fd;              /* shared memory fd */
>   } IsolationRegion;
>

Agreed on adding clarification.  Is there a reason to change from uint64_t
to void * for referencing the shared memory region address?  Most uses of
that variable expect uint64_t currently.  Here's what I am currently thinki=
ng:

typedef struct IsolationRegion {
    uint64_t shared_mem_addr; /* mapped shared memory */
    uint64_t vring_iova_addr; /* beginning of vring region in shared memory=
 */
    size_t size;
    int fd; /* shared memory iova */
} IsolationRegion;

...
> > +
> > +    /* Isolated memory data*/
> > +    struct IsolationRegion iso_memory;
>
> struct is not necessary since there is a typedef:
>
>   IsolationRegion iso_memory;
>

Agreed!  This will be fixed.

> > +    VhostIOVATree *iso_iova_tree;
>
> The IOVA tree seems to be closely used with IsolationRegion. Maybe this
> field should move into IsolationRegion?
>

Agreed.  Since the IOVA tree is basically tracking mappings to the
isolation regions, these can comfortably be grouped together.

...
>
> nregions is uint32_t, so i should also be uint32_t to avoid
> signed/unsigned comparisons.
>

Agreed.  Will fix this.

...

>
> Please avoid duplicating the memory layout calculations. When packed
> vring support is added to vhost-shadow-virtqueue.c this will become more
> complex and it should be done in a single place. vhost-shadow-virtque.c
> should expose an API for the size calculation.
>

I think I originally did this because the svqs weren't initialized yet
at this stage.
However, I can cut down on the duplication with a new function in
vhost-shadow-virtqueue that makes a dummy svq with the correct num value
and calls the existing functions to get device and driver area sizes.
...

> Please make the name unique (e.g. using dev->vdev->name).
>

I will do this by prepending "iso_mem_" to dev->vdev->name.

...

>
> Is it possible to use 0 as the IOVA base address so that QEMU's
> addresses aren't leaked to the vhost-user back-end? It's good security
> practice not to reveal memory addresses to the outside world because
> that information can be used to defeat address space randomization or
> infer memory addresses of other data structures.
>

That should be possible.

> > +
> > +    assert(&u->iso_memory.iso_fd >=3D 0);
>
> The dereference operator should not be used here, it's the iso_fd value
> that is being tested.
>

Got it.  This will be fixed.

> > +    DMAMap *map;
> > +    DMAMap vring_map =3D {
> > +        .perm =3D IOMMU_RW,
> > +        .size =3D total_vring_size - 1,
> > +        /*vrings are allocated on tree first, so will be assigned base=
 addr*/
> > +        .translated_addr =3D u->iso_memory.base_addr
>
> Why is this field assigned here, I think this field is used as the
> output of vhost_iova_tree_map_alloc() rather than an input (e.g. see
> vhost_vdpa_svq_map_rings())?
>

Yes, I suppose this doesn't need to be assigned here.  As it currently stan=
ds,
that value is just getting assigned back to itself in
vhost_iova_tree_map_alloc().  I'll fix this for the values in
`buffer_regions`, too
