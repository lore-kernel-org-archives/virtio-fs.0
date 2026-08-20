Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E072E92BA
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 23:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269348; cv=pass; b=mFCLr4djkLyGpMNxhrxjs7q9I54+u8IyR8I56ZKgq7Y7rWPhx/MS+4z4DPPhIr49R6VqZsMupFhkHvPb/6Jhf6bN5VYd2ynFxMDs5PGU7f9rnFuVm3KqD4cd86mwZDzETsmalsdXRNRfVcbHvOJ/u8nfVez1fWCn5HmWatKCnZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269348; c=relaxed/simple;
	bh=7XBG2R+Dq9sf4eANinqSlckCqWaI4nHBXaQ3Ck0xG34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XC2pb0ixO7OM+Oazr7mnFoXxNIVLBWuGckArgR84zX0QNL5U7fiB9EnhB0rezSWQbLvm710CCaaWo+woGrZtzlpGhx+T1Xj+8mayWEmEJ7tezfZ6NWy0WaZLm8NP1Zs/iBChL78rlvLlYJnmaDy6a81xiqq5OBfxCpyYZc5KVxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TPXkOBip; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TPXkOBip"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-930f618435cso24731385a.3
        for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 16:42:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787269346; cv=none;
        d=google.com; s=arc-20260327;
        b=Gh1G+y0lqVEOH/AXtQ6dA2Q6Xohbg7WbFoVdp4a6wae53Dp1LDeLcwR1gZir3IUn0A
         XDjWzxuostJP7n6hqIUfXgU+ox7bhVI2pUFZ/PCNdryN0uHIh71jch+eOdUQ1ejDGZfX
         U3vaRhjub2xgStIlbbFMycCH5B8JyHVJr8fRqPMtXIe1TWxRbT6oHBHiQopx2XqMxugc
         CjvM1PJl5HG2t6ug+qm7ytvbLtcWlnxPRF2DXt21A/6olg8J+vuaImG+DUdH0YgdAkHZ
         /L++CcCLy1D9iYsrsGWsZ/3Fp8JcSBlFINVD9js5mQy7VJ/CEywu1uZRy9Su22BKAl8g
         7FqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hF8HEpAhh9KuOZv/WIlDvc/Bwcys5cjfJE8nSa9pxU4=;
        fh=DdBNbF1ZPE+JPABlLrydhXe1TONWdefxIoGBFik6Pog=;
        b=GTuhmJVh5rG82voY/uOHp4UMMzIVBFWZ6ow5e696R/jHTLVEzx5qxXcVvqW7sGU9o9
         4ZHgCqba6nJym/F5hNQBMlw4jRnwBXdwTXV+OLskZVxNWcVjhmuqQKNYanDsxVnSLacd
         yveQnLKh/bkBH+UhXNn0t22BzESCSuOqxZ7U3Y+3ChzwaV2azMqjrwYcmxEqxf2abh9V
         OpglZIlAnPaPbWcvH64EsM9rhT97HyQNfPYzhTE7BoOYWSTrjMwq2I71zCkWwCNuFZa1
         hC5GbrPYrJ8RzW8tCUvJrbqXXTxG4uLioO1QXFBBXy9pcSnqSD8ZCv2TCfNwdNO/uQ3A
         utHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787269346; x=1787874146; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hF8HEpAhh9KuOZv/WIlDvc/Bwcys5cjfJE8nSa9pxU4=;
        b=TPXkOBipP+NlCgvirH/zEqUJft0tOZ59Yio+YtfvbHQXtsnOG8MGebKyoDa+UlNOF+
         KdNcRdj02ls5dEGszP8JXXtChet0s+ke5CDfMAgAGMc55iyAlzagGelEAtcwbrn6Ay/r
         EEENHNJcpFc1mN+F2QYJBW85lYaTdBaGadcVlVZfRhjPDn+qpiXZQ4fN2v4vXNFqBjaK
         zTys4amXVWNV79DKgFb9JJyWtOkEcj+fHN1Rib7Sln1bLROo05qzErDUTv1+1O3xwZ74
         RGU5aIPNWGoM5VXU1RpoFfvxEZpixNUve6+ecIkafqZvBCXr20ZoATNTM1jbd4ZwId3Y
         PG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787269346; x=1787874146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hF8HEpAhh9KuOZv/WIlDvc/Bwcys5cjfJE8nSa9pxU4=;
        b=GWuhyL+BdDx2mtpOocOsgaI1nooRmik2tvIkFM0EY6hkcmsdUuxQ77eUNLt4NfqcYu
         0yszbM/Mgs71GCyB7rAVimNUUOOa3E7DOBkKnux/OvKkVIlIEXkTiV+QDVwrXCdnm5ib
         OfqX040E/vti2ROB1eHwzgYBcb4J0mWa8obz87eMcceOVvVGzp3TQlYMxwpOtVb5zx8Y
         8NdjepjO5YvyRnuotmuqSXSM7KjNid7SAl539hNOgeuXEf7r4hgxQKdZyRHsnCqzHUS+
         pPRMsdheeclkX8dh/sNkfKdpk/vw17S3ziAqUgf+n5FKEvR8qTYWVlNSMYhpPWF49wEV
         lGzA==
X-Forwarded-Encrypted: i=1; AHgh+Rpi11urNv6wvRQEWVXfaFRCgexqPvv4vuu90KyaiEv1wNDRDbrKZvk/l2YC3SQhGvmfWMnCXYKZ/gQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0UkRnuAa9rFGBwYaImG8q7skKpvMK/+bGoLgXP6a/AVtvqCKQ
	9sbdBEGNVqyglaSk09mIJDh7H0BrRIiJ9Vwczs7cmyyy512v2Oag8h+hy7mMztXvnX2rXMNTIh0
	0Kvep2Ue92GDTd+AdsqYBEp65Q1RlXgk=
X-Gm-Gg: AR+sD13L22CCfMvWoFPFNscwZr1xaqi/SdmedI2tfFDximLxVSGLR2G0jdSWD9MJN2h
	yXiHbFaRkBmXo2UL1foHqndM7EZL727o8X3WHJijerWNoonVoMboAAMRKiTZP26UxAs/GDD5LwO
	aKemeCWBYtiSp9lF6Jp9b6usZ9+LF3Tu4/w/gyfBXn1Eu6e9uc/VxnQQ7VMARgSGg+SxJHkCR7e
	N+JIQ0uXmT3IdWEDv7Dx1CCKN0GKUgZ4/qmJcm/5t+8IFx2KTKEoNVNo3xrh17Npc14HlQywiiY
	SK5PtWjfxxVMTXaeX0FVF8dqfziE/25lQXXvg/myYyq0QB6RYtewJK8dCZ5TzK7+Y42EXZvyeQI
	jhGI=
X-Received: by 2002:a05:620a:a80a:b0:936:cddf:3df1 with SMTP id
 af79cd13be357-937395bf953mr174780185a.44.1787269346054; Thu, 20 Aug 2026
 16:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com>
 <b6f79ec9-7842-47ff-b210-855036712547@rsg.ci.i.u-tokyo.ac.jp>
 <CA+spn3rouMQ=yG1m2fS=vm40c-zWWMZPK+yk0K_ip5iXzLZWow@mail.gmail.com> <5d8e3d91-de60-4747-88d1-e135e3c6e7c1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <5d8e3d91-de60-4747-88d1-e135e3c6e7c1@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 20 Aug 2026 16:42:14 -0700
X-Gm-Features: AcwNN1U2GZyCGCclv-n-yhFlH9oRms5bYiv7MVJbaEJR9547b1OyH-XBjKMUqlo
Message-ID: <CA+spn3o18uuZqfyGE+R2QGZ6KRoTJ9hmK7HyEQ6cg4wxN9QPsw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 04/13] hw/virtio/vhost-shadow-virtqueue: used callback
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

On Wed, Aug 19, 2026 at 10:15=E2=80=AFPM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
>
> Skipping event_notifier_set() only suppresses this guest interrupt, and
> disabling SVQ notifications only suppresses backend call notifications;
> it does not stop backend ring processing. The error should be propagated
> with virtio_error().
>
> I looked into the virtqueue_fill() and virtqueue_flush() calls in the
> existing error path. The virtqueue_fill() call detaches the element and
> publishes it to the guest. Detaching the element is necessary and should
> be done in the new error path too. On the other hand, publishing the
> failed element is wrong and should not be done.
>
> virtqueue_flush(vq, i) is still required to publish and account for the
> preceding successfully filled elements.
>
> Regards,
> Akihiko Odaki

Thank you for the explanation!  I was not aware of virtio_error.  This
error path will now follow the following order:

    if (r < 0) {
        virtio_error(svq->vdev, "Vhost shadow virtqueue error while
handling used element.\n");
        virtqueue_detach_element(vq, elem, 0);
        g_free(elem);
        virtqueue_flush(vq, i);
        return;
    }

One thing still seems a little strange here about how vq->inuse is
modified by these operations.  The count provided to virtqueue_flush
in the svq code is the number of elements that have been added.
However, depending on which type of flush occurs, the value of
vq->inuse is decreased by either this count (virtqueue_split_flush) or
the number of descriptors in the flushed elements
(virtqueue_packed_flush, virtqueue_ordered_flush).  Also, the
virtqueue_detach_element always decrements vq->inuse by the number of
descriptors.

I'm possibly just misunderstanding something, but this seems like
vq->inuse could potentially end up in an incorrect state.  Maybe that
doesn't matter in this case once virtio_error gets called...
