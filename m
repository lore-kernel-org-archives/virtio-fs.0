Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0F2777FC
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786412359; cv=pass; b=pXtZKs6IApsidhwaeAJwHoq3AL8G2b13EV8VRqyAUsyqr9QfQsFfqelGILSn16Zb9/I7ER9bz4eTv3JuGDJ1QFSQyzioLNQH1qyUfd1S5P2VCIMs6U4eTeyOOloAF3NnywGIoF4/VavDEpYkqAaaPYJ74EyV0VvH3ZQCH7sp7AQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786412359; c=relaxed/simple;
	bh=QalwuqvStqnXeEiC+s5hf07RUka0a2XF9C2gpknLJow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y3HqjaRkvPL+8AIPt0nZCOJQ+SntbGUNfE6MtXeqWJJy+aWKBV1mA4hJaNsW/3MY0YmpXIlUKcv/a1II4cFUERF6cY/tvh76DZOg+oVB789aiE7AnW0GizzQYtDgr9aW5UfF7Ky9F83Nzefe2mlrLQquPjnjgy8z1Js9IMQNZRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X06vnY7Q; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X06vnY7Q"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-907ae240ac3so10121876d6.0
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 18:39:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786412356; cv=none;
        d=google.com; s=arc-20260327;
        b=rTjtj9HYWbYfNky4FiEwmeuiUFSGgpJ/9ddZyl216ey+H4P+RbK4usZM4qy+RtlcZX
         yCextWvk/cL8BX6Sup0tW7xd6tMZFJs7mcpLV7A7su91fVjQWYGCT0gCOK8+vupm5Xrt
         T0nro5RSv3qvUgvpMqonoBvYAATZQo9GEi9LmNesNPevh7NVCaUc2mgwXJHtV5qVGIed
         g+TyIlJM4yCQdUdAfkTqQmBYnenq4o1tk7b60yep6r3r57aqJGh4eg5SvxyH3qkf4o1+
         4Z20RuqBDXMeD4Q8oIlocrl3qw8xNsaWWxJHXZylPe2ea3e8ixgK5X1RU+C2B6z4mzBm
         LNPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9NCE/aAr/j2nF8iV3xtU3OsC8CpqBZM5ZBeXyoA4OLA=;
        fh=JUuNXlhBrkwsFfCC148Mmy4nwSVP+NrcwLQs55nw3Pw=;
        b=m2lFyEe1YZ63zO7kREG4M9IyN7OPiKzN50GAuyiMgHYblBhhONg3Ny/hZ4A/iygXkD
         jEm8OY3hn7XfSsIF54gqgLKpIL7EsZuKLtqeIYEhPSqzplcVDA2QbCGJoYvBHPG8wAlb
         zC7tSyKjeXerySu0E7aq6NMockRc4LXCISKMyVfb5D4aguC5Edc/Vtf4ebvQBL8vQxrm
         9++3jPSqUSeaqlXJms3efVeYOAXyTAOY6L/FA6Wvp1csvskCzLYI0tepqj6HtZk9CPUY
         qLWYzdj4+SKjR5XRUIhwRjktH4ZQ9pF2cQfjmiqcDekFSJPFiTt8x78OVilFTol4lBWX
         9cxw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786412356; x=1787017156; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9NCE/aAr/j2nF8iV3xtU3OsC8CpqBZM5ZBeXyoA4OLA=;
        b=X06vnY7QLfW6ZXw/slGIzY1jcbc4zOMZ851pvFB/JhDOXxYG724qjoAfMnunsiTIpi
         zKaUrEJOs2EfR0Qm7wuzngurpGuDNzOPs/BKfVi/UbiltflOfuEqNyDd5C/0LMCsIk1T
         WsidUaDnGBAmTfLQ95mDYVkJf3G/KxVOh8UeNkO9WqdaZdVxF+WemeDppx+ejzH564US
         14AAK1pfIERO/qO+Oz3Qb6/OtSYNP8czoQFfHBw63fzYxDhov+CLFqzo7dJm2gD5eU2E
         dG//14pgOKx16MDONDl+zDD1F44/c14d5+WVDb+7YSFsoN5+ccyxzse10tpiHgh+Wccm
         u0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786412356; x=1787017156;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9NCE/aAr/j2nF8iV3xtU3OsC8CpqBZM5ZBeXyoA4OLA=;
        b=PGR1ZdV5SSwX0mwVzC5yjO7z98TQl2kzvB774HnsDWJ6UUWyulD0YxAvEAN+vWk3S6
         2UAY9fo1NMuZ1sbhsWqsW09lLvjUlhw8Y+lK/CGYoIKQWthlpmbnUT7IyGzd8wJ7Kd89
         3wjGbooe2Ekx1LOUuFQdhpr59s1+d65At1N85o3MY/wdmRH4PmUyp7N19kVqtYhaWnTv
         yoIS91sQMXJiw8jFuibPX1/os68FW6TdRJuAoIc69WE87CAVOSvTQ/U6spPH86zfYDmb
         IikiU0RRwGeDN16z7oi+oxOW7E4kBQZt7VqCvV8AVYs1KjFW3SS9ZYVAuZ5TbjbsKYOE
         R+Jg==
X-Forwarded-Encrypted: i=1; AHgh+RoN7tZ/WlOrDMLX7OTr25pGQdCMc9QbaFaj/U+T6WB+NULiwq1afGsfCYjdMBkIvGOo5+EBLYxPyQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbhMkiTPNmIJGCecFX1CC0c76G02zytObBwq3XBPItXAqsuy7B
	OlyCK3CQC+MH+Z3PWitze61iPvZn0LIMcADUfe5sSjAjOejVBc2fz3OS0xfg21RC2j/KZh4aI1q
	QUn5u4GfPMK0sNoGcSc0pPuwZn7/XbvU=
X-Gm-Gg: AR+sD10ZTt4sMqcAwdi9VBIKmQujGDHG2WalTWUT9/cf5VuqO11XA4wd22rVcMsmgnf
	0zCvw3G8vK2asLeZbUzCTuikRaSngtPh9OMGj/1qYNPbmc26Lq9RUffV9MtsbYLoTkY5mSNTtAl
	xHnBOo6tUk1TFpabkeHSuaQtZPGY0h3sX34oWB0iI3egRNYA5ctFVL8U/Lj9hdZ2fIOaoAShshL
	E7bb6wRpzujZlHr01/KdcYT98+zcKly+KIZVrSsD+XJQIKAuw81DqAn+YWXCFNTc1YCmC1V6MKc
	/Wumjiaw+AmqSISQLTf679IY5JJ0m3jiPIzWvx5UVSn4nIg1drmLN4qnNM+JzyTnapDHyn3CDAV
	JtEO5oLkaNTcuEA==
X-Received: by 2002:ad4:5ce4:0:b0:8f2:860f:4dec with SMTP id
 6a1803df08f44-908a70877b6mr315196116d6.15.1786412356388; Mon, 10 Aug 2026
 18:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com> <20260728194145.GK371693@fedora>
In-Reply-To: <20260728194145.GK371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 18:39:05 -0700
X-Gm-Features: AUfX_mwk7yXwRwfuX1L7sbLLsvBOJi32lYVTZ-YIqGXA6JKERxD-feww-OPuB2Q
Message-ID: <CA+spn3oU7dtEPO_5-hT6x1-n+4HYxO9a8_aes7Jy3afWDDY_Ag@mail.gmail.com>
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
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

On Tue, Jul 28, 2026 at 12:42=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> > +
> > +        if (svq->hdev_kick.initialized =3D=3D false) {
> > +            int r =3D event_notifier_init(&svq->hdev_kick, 0);
>
> Where is event_notifier_cleanup() called?
>

I have added in to the error code paths when calling
vhost_user_set_vring_kick.

I left most cleanup to the end of the patch series, and it was underdevelop=
ed at
the time this went out for RFC, with the intent of getting feedback on
the overall
approach.  In hindsight, it is probably better practice to implement
cleanup at the
same time as the init/start code, per Hanna's comment.

I will pull the svq cleanup code forward to this patch.

> > +            if (r) {
> > +                error_report("Failed to create kick event notifier");
> > +                return r;
> > +            }
> > +        }
> > +
> > +        file->fd =3D event_notifier_get_fd(&svq->hdev_kick);
>
> Modifying the function argument is probably not expected but
> vhost_virtqueue_start() doesn't use it after this call, so there is no
> immediate problem. It would be safer to have a local struct
> vhost_vring_file that can be modified without affecting the caller's
> copy.
>

That makes sense.  Swapped over to a local struct.

...

> > +
> > +        if (svq->hdev_call.initialized =3D=3D false) {
> > +            int r =3D event_notifier_init(&svq->hdev_call, 0);
>
> Where is event_notifier_cleanup() called?
>

Same as when setting the kick.

> > +            if (r) {
> > +                error_report("Failed to create call event notifier");
> > +                return r;
> > +            }
> > +        }
> > +
> > +        file->fd =3D event_notifier_get_fd(&svq->hdev_call);
>
> Same as above.
>

Swapped over to a local struct as above.

Thanks!
Connor
