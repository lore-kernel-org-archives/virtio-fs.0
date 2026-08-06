Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF493B47D0
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028720; cv=pass; b=Op1pPRlmVptHPuwsxCEPycN/zHetpgwFs25rI+XaWMmAsKHzeVnuJ6wRhJ7l5rtfJQt1lD0nfCLqN9o7HWcOYYqvYFymxK5nj9tPJ/2NKoBod8Cvm7AWo+oFCO68uD/M29/i8j2o7I8y4zDWhxgGpYZw5vgUDF1SUTPE8dNi4Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028720; c=relaxed/simple;
	bh=vSdmkupM7kh+D9rzvV29GEp1dEYqX49EcB1M9g+PAXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dmaoxndCab9SkUtEm1/VviKzJ5qAg7MdAjnfQjtXKadvMNToOOCYJ2Sm7gt+uIeOcqlfqISIwQsBCAnZRy3uOilc2fIet3hz9GZU8RH72l2zz+H0595EJbECZkeBpHr0QUCvbnI3TfN2SjulAa5vhCHTJVYM8TpyWdps9hRlnCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lj/dHuf5; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lj/dHuf5"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52cd38ddcdfso13851011cf.3
        for <virtio-fs@lists.linux.dev>; Thu, 06 Aug 2026 08:05:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786028718; cv=none;
        d=google.com; s=arc-20260327;
        b=CRTH10ZzyXPd5qfu1f6suvSX452khlIZDiwdZO9vOxAXA94M0TitFaGQGV+fouV8PM
         SjexZmBaqTrKGT4qG+EFcBj6S2FVYIEcDPM96rpB63xoNVtE8ex6g1l8oTSUNGZNrl35
         s0u2BLinfST37ZxLasLB8UthUw9eZwGZJLSs6wasRSEcMSNk786nqINqDkAOPELkeBQe
         mwQDT+h/Pn3hnbQtpG80eBLDfZk1SwMp7KM/JqCAcvmdjKIb+3nE+JxoZ9txpXv31HKv
         ZJuIOAZEDWHPpxizgys+AGpusirYaHRmqUpK4KlQWHDUT2UdIHy8AChZ51Km5ROChmV2
         t7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UoVEjTPysIjqpFcBarX63DcWmY2mFtjbnvx9aK51J8k=;
        fh=A9hfvIn1NcANMln3y4X01UE3kx78HWPNc0WUX/HJhNo=;
        b=Cgw0s6GQlayxQsNw9oqKfBuGC194ckr6D2aIWQ8n8yuuQwxy54z+Zcmq5IQZDHPXWM
         /Pg0wDybTaGGWnvyKHNwjSF6wLVpmShHvqBY5dnHC5d34K1HQG25UnH4X5kLwl8VXYPh
         kr+xd4pR22jjZFBuHblOu6jXsJ2zn0+5HFf8tkLjVL41CHgMC5JiRQaT1J6KAWnuOmBH
         u4dns8qQKqKMW6q/am5InzBsEcEwokpeOhb+d/AhfY/FyqTkcn18yDCFeJQSSbXKL8kF
         WgzG9RtcQ3rtWcDc5EDW4Ex4XdFkLs25cp3QYPLCFXDQEF7rDonjBXHwuZ0fW1sS+1xk
         QBpQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786028718; x=1786633518; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UoVEjTPysIjqpFcBarX63DcWmY2mFtjbnvx9aK51J8k=;
        b=lj/dHuf5KKbIhirf9Q6QgAKd0F62k+EcHmQPTMjUh0JXk/tyycC+ch9xWERACGqUqI
         ZoKcelTyzBML6VuLMSpnH3kw8WFyBNiJQBHIOnX6BSS37O+UXoArHO9C8bLAqGGbqugl
         ioGaMYSZF3X8AjUW3/kMkBtdxmlwVFH8rL/8vJ2DcPN7Yh5npFjVNtROEIiiT6CRFpYh
         smlwvakndrXfoOup+Qq1tY6yYCJ3FXfMoHYllInHMqcdeyElccvtfNPMpMJQGvD18+QU
         XcGKm5QbZlWEIH/5gB9HLtuvZ/O9yMmpTJND0ffG3+brMs0KlxjteAFWwohhkMXuJi+V
         6aLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786028718; x=1786633518;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UoVEjTPysIjqpFcBarX63DcWmY2mFtjbnvx9aK51J8k=;
        b=IqelUYNHoq0IrSPc6DbIpWMQGJKrp9eMzLESBDkaUfJOycs1ZPHM0kYqBsRCo3CUCC
         1NEqIckhG1B85pmlokq+lT+7GLCg5B4BmOzcbsit/IVzKXTnMthNMqW4FlMbP3BQgfxy
         uS3kUJjURnrlLuxMWJTMqWbzqUcjhQJu7MaKws0yrUwphgRaTKBwRpuT7Ifh/jPCq6YJ
         sKu4KmHdd8O/0XM0Nk1+VtTPEX+gjYojO2UbunCJK8A+edzPloyCXZbueMPHPsiYuHLS
         iY8WlbFYw4BZxkErqd+aTGJZ4C2qjcygWrkxOZwrbf4fH1xRK6GQb0L/qLS7u/I9qQ2O
         w9Og==
X-Forwarded-Encrypted: i=1; AHgh+RoIT2WLkxw+c4sWEwTBDVqLIyyUv/E2L12GWQ2yhcB0il58RynkpX+BohrpD5oclLzqTRQVxw7fHB4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxB2ezViqYnpgguq7aK4TlPB/6fjnqiidNkBD6bGkUAQzO4SQTw
	CxQUulkLZUzr7vsGvS5FgolgrVGoJOCzYuhXUi92+s619gGPNJI92BFeZXZXAcmQdbF3FSHDdxc
	ddWpuzRHbC9MPJitljiNZimkKvesr5lo=
X-Gm-Gg: AR+sD11Ak/eFmHPt/5sG2VbR3fAsm6hki1Lm/iBR77KoiA0UfcwZE97QkN5hNPYb90X
	FGZ4P8uVHAS8ctGLsfiy9X1OILXswbbIhK38STJmUy+h9F9H+r+qmQJWR7YlBXQzJlP2+z0zfSx
	QJ0YnxlKYlZPo22mJqlomk7FHUJuZmColsMzeldSh4p/CEUYTXVI/q2FZ7G2L+A6wPJAWgiy9vs
	lE23UP0d+E4BUkM9m9Fh0bLO82wztodTn08rsZ0lO3EH6x+3DNDr0uYEMWhdBJ4y2KxG3B+7h5y
	Ld0WoGJKa2EFd7lcWGIFnnExP5QNw0YwS/fkUULQ1KhC/9OV9Itfo5Y8rw2/QJvdppuu4x0hR2q
	VshA=
X-Received: by 2002:a05:622a:593:b0:51c:21d1:3852 with SMTP id
 d75a77b69052e-52ce5f63740mr155904611cf.5.1786028717763; Thu, 06 Aug 2026
 08:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
 <39200a6f-8241-4033-ba7a-5c9bbbdc8ff1@redhat.com> <CA+spn3p-Fc_uLO1bwSXC39kmQ-iR-OpB-a6cjMTphb-_Ant-_w@mail.gmail.com>
 <738737aa-64ed-479b-bba7-1b0326ef30c0@redhat.com>
In-Reply-To: <738737aa-64ed-479b-bba7-1b0326ef30c0@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 6 Aug 2026 08:05:05 -0700
X-Gm-Features: AUfX_mxzm5WICpzx40ztF5MASwM8FjGxd7FeJy4vhW-Atxrx6PYaQrlSWL3F2nQ
Message-ID: <CA+spn3rLetrq8w349DAcbVDQu7A3UNshfZK9ADzJm530r_EJJg@mail.gmail.com>
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
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

On Thu, Aug 6, 2026 at 3:28=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 06.08.26 04:50, Connor Kite wrote:
> > On Fri, Jul 24, 2026 at 4:29=E2=80=AFAM Akihiko Odaki
> > <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
> >>
> >> The error of the handler that may have left elem stale is ignored here=
.
> >>
> >> Regards,
> >> Akihiko Odaki
> > I have now added in a check that returns on error without setting the g=
uest
> > notifier.  So essentially the call is ignored.  Maybe this could be exp=
anded
> > on to handle errors more gracefully depending on the error code.
> >
> > On Tue, Jul 28, 2026 at 8:06=E2=80=AFAM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> >>> +/**
> >>> + * Callback to handle a used buffer
> >>> + *
> >>> + * @svq: Shadow virtqueue
> >>> + * @elem: Element placed in the queue by the device
> >>> + * @vq_callback_opaque: Used to pass arguments to callback
> >>> + *
> >>> + * Returns 0 if the vq is running as expected
> >> The doc comment should mention what non-0 look like. Are errors report=
ed
> >> as a negative errno?
> >>
> > Yes, a negative errno is expected on failure.  I have added clarificati=
on to the
> > comment.
> >
> > On Mon, Aug 3, 2026 at 5:42=E2=80=AFAM Hanna Czenczek <hreitz@redhat.co=
m> wrote:
> >> On 24.07.26 00:30, Connor Kite wrote:
> >>> Adds a handler callback to shadow virtqueues in order to enable
> >>> non-default processing of used vring elements from the device.
> >>>
> >>> Signed-off-by: Connor Kite <connorkite@gmail.com>
> >>> ---
> >>>    hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
> >>>    hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
> >>>    2 files changed, 18 insertions(+)
> >> The avail handler replaces `vhost_svq_add_element()`. I find it a bit
> >> unintuitive that this handler does not replace `virtqueue_fill()`, i.e=
.
> >> that it is not a =E2=80=9Cmirror=E2=80=9D of the avail handler; that t=
he avail handler
> >> actually handles avail elements, whereas the used handler is =E2=80=9C=
just=E2=80=9D a
> >> callback on each used element. Was that intentional? (If so, I think t=
he
> >> comment should be explicit about this choice.)
> >>
> >> Hanna
> >>
> > I implemented it as a more narrowly-focused callback since virtqueue_fi=
ll
> > needs to be called regardless.  If I instead called virtqueue_fill
> > from the handler,
> > I would need to pass in the elem index and length via svq->ops_opaque,
> > which is a bit awkward as vhost_user defines ops_opaque when registerin=
g
> > the callback.  That's certainly not impossible to do, but this way felt=
 cleaner.
> > For now, I will add a comment explaining that the callback should not b=
e used
> > to add elements to the underlying vq's used ring.
>
> Then I personally wouldn=E2=80=99t call it a =E2=80=9Chandler=E2=80=9D if=
 it does not handle the
> element like the avail handler does. Maybe =E2=80=9Ccallback=E2=80=9D.
>
> Hanna
>

I see how that's more descriptive.  Updating the name.
