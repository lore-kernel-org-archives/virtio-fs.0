Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308453B5E19
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030184; cv=pass; b=FMum2+eRg2P8JearkSZPxxp/wiEc9xKmGQ8XiqN7+oRMo4O25/puRzTyOJempNtitu+6kaveuMurN1x9OxsZ3PLbHK81yd1aNnCJYW2PJPBE1GSLoB5sGb71LjFB8VKYXYqOihDVDjXpZuPBs50yLtKdM2x9d8INQ63N/4CAqbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030184; c=relaxed/simple;
	bh=RJl3b6fOcTv7Zf015Q5ykYSl78RUQ9W5fOvq/ZdKJ84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8T+PClyrQrSQaRvWbDXG3SkJCrfPLHlk5z9OtwaFZWmvursNzcRFx05F+LnCD2zMamy1MBcr1pJWaEilpl38w8UILLLOSoBLpn4701cXwfJoxVnexdglx6t7JkTj7IRFzigjq+hnwLCBbC6mmTudGtTH86ZLSNR1XRoQmIG4aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReGKPID1; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReGKPID1"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c2a818fc4so15458341cf.2
        for <virtio-fs@lists.linux.dev>; Thu, 06 Aug 2026 08:29:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786030182; cv=none;
        d=google.com; s=arc-20260327;
        b=ERZavAaJGJ/iR/SkCGEiJ2PTWy6YmNchCTKI6jmEjJURToU+lN1aTIKPQgQE5swLKJ
         sakc3e3uXBV4MY620027Vsi+lgziHgPUc2AFaf53ESdcyJGlMlr7j5G69rwFJpZRPBdz
         ujjb8fxXOxJ1lUIFTiNX/U8au1FSfhkZbK9BGhZzRcpX+RUvHycVREx0zJvl9p0oYWd7
         t4ovk+QxTdEuUPt8bdB0Qobo+llEJ50lcj931wVNFrhXDWt5WIUI9XLaiHpFGhIhq1jj
         /x31DbxVyVDYS1450poyoEKLFFDFXIAdGWVdJpfi1rjLsxvZhs4328P8Sdks8M+dHVOZ
         7tzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fbhM6ni7JY8Y2h7SdY5C0ULZ5EeFXPs3jMUf+pr9MXk=;
        fh=0yJlXCCMfG4QIP/QA58xQmW/TGSoYHW0Mi6Do5yKkEM=;
        b=TSLJSGvf628cD0oc6zV3zLL90JTgfAEOCEsKWODXHN2eYEoT0ql/BFea+PZ/LC8ea/
         ZnTZW1vyTty9Y2pJXMW3NDReqg7QI7ANeXeXKUphp3sFSn3gqzZI5k0aMvL41FQuWeT0
         P7Y1Ar6aCZ2b0Nk0CbHzXaZtgUJ6CvwJV8tw5bGHN3+VhayFYiUG4024b4kN5MXi2N/A
         II6VLA9vcQk2yYmI98S5WacAHVUaeTVrimLekuJZNssWftB+vlSSWKd29LGc+jnhhkqS
         X+J/ro37qVGKODwbbHU8HVBEfk60m1vtAURY2u7Rskq8fQ4NpbvUrlXqYmtDn7LKhacE
         zHXQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786030182; x=1786634982; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fbhM6ni7JY8Y2h7SdY5C0ULZ5EeFXPs3jMUf+pr9MXk=;
        b=ReGKPID1AW36nVrvANvkad0z+mOBrg9AaCYK48bVnduqDe38jvBjn10rn6gqdx2OBt
         eI6+aKlG8CNDoe0qJCCksz+O4d2i8B98ze1Hr22AeO9jYf3DvHhDH2Do0DEW+wxVxo8O
         C9Mtwafdvw3U1CniTY5R+DxYVJ8kbQAc+Np6Xq32KSXm/xw8xSVzXEZmdtaJCPDnf6Kh
         t7yNJs+ZfRpXpf/tRVnslLgeIojad/w9X+zYwB6HpA6xeX4Z3sCMbEjOoGljVNJOg1Go
         3v00fbe2d10FXfsN6WbdBj+aI1wxvcJ2TPya7arWYgOx/UsvbOL3HyXF2rGLmWB3+QrF
         zWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786030182; x=1786634982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fbhM6ni7JY8Y2h7SdY5C0ULZ5EeFXPs3jMUf+pr9MXk=;
        b=JJZ03trGlHY9j+8a/4yIgzEfm/yp2K9q+PzG8gxsF9K2rR6DCiHdcthnqAXVSWJJpA
         Jiu4tLeZUQJhytfVFyJY7mHYVDBLwNtboMsEEOBvae39Aa4wb8puFqpUvyL61D4vdo4X
         R+j9CKTs4WFbVzM676sgliE/ygJq954NWw2TNhyI5aACAYNTGX66QNjPy9sKk88Y2uS+
         /l3IOSfs8RF4RFy+3SAINptVYd6exHGSRqeRrCf9uvCUVzqcI2GAwEFIIto9DoRa+SYZ
         mAfJYSbshnVt1v4YMZ7CYnX/vPG9sPy3sQZpBL0NjrpwjeX3kLtMtvZ41VgrUUycEjUd
         OgoQ==
X-Forwarded-Encrypted: i=1; AHgh+RqyQiE5HxLJDE8bL5eSpoxf/sWEnJvK/hJc/gv67laasDsQN6QBf+pIpmzT6beWRqBg72eEPzdzisA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZov7/83HIU3nd7bI0ndQDoJj9uYmgkcw7Trl5uWlOwPCud6D/
	q4xbM/m0aMaY8gT248UDaajzNg8W8dV/F/kF1Gfd0wYIxh+chMVhY1mvijAcuTE2bANl39d77CD
	NuUI6e6lnskbwj1Wg8NS0hA0fQbnkaHA=
X-Gm-Gg: AR+sD12OLVEYXFTkAfVmsUeixiDEqJS683GkeQQN8tTEp14FH8FmWXPmcruvgoeNgfi
	UMQMCB4Roms415LX0A7c4ClQYRGJviAcvOzpGO7hvTwcc4+UrXKkbeT8MqgqzqegpNGk2dZO+6f
	VDZ2kPeiJMXv5YKN3ATfiI4mi1OujGgIv47GNhVTVyT55EMgFHjf3Z0/P/wMeKN+wMl+QToQE0u
	7IJdvTwWgvyyq2TKHDlQN1+Ryp7Dcskow5b6N5ahvQFnPLl4WXZ5SGu9nnhx/qqVKHQ6desTnKe
	c/7qc36c5AqClX/n3fbR9nukAtyhdQbEk19xr8eb8xFcYu8YVFs/jDbF9uqtIkDbe0bKXocXkWM
	jPvg=
X-Received: by 2002:a05:622a:428c:b0:51f:636c:8eae with SMTP id
 d75a77b69052e-52ce5ff21c5mr174083461cf.14.1786030181907; Thu, 06 Aug 2026
 08:29:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com> <f9125d0a-3258-46f4-93f6-0761a4acdc66@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <f9125d0a-3258-46f4-93f6-0761a4acdc66@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 6 Aug 2026 08:29:30 -0700
X-Gm-Features: AUfX_mw1fmyon2HTcHvHhQjAK7H8kXEhTUaSklvV3gLZ5vUvN2JB54elHNtQ0Co
Message-ID: <CA+spn3pLJvQCyfUvK4WvjvfJnGYBKr-i302HvBeVm9Y3t6sR8Q@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
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

On Fri, Jul 24, 2026 at 5:19=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
...
>
> Nit: please remove the whitespace between (void *) and svq->base_addr.
>

Removing the whitespace!

> > +        svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_s=
ize);
> > +        svq->vring.used =3D (void *)((char *)svq->base_addr +
> > +                          vhost_svq_driver_area_size(svq));
> > +    }
>
> Unmapping svq here can lead to use-after-unmapping because the ring is
> not stopped yet. do_vhost_dev_stop() calls do_vhost_virtqueue_stop()
> only after calling hdev->vhost_ops->vhost_dev_start(hdev, false).
>

I am afraid I don't quite understand, as this patch does not introduce
any unmapping.
Was this comment meant for a different patch?

...

> > +
> > +    /* Location assigned to vrings if not in default anon memory map*/
>
> Nit: here please add a whitespace before */
>

The whitespace is now added in.

Thanks!

Connor
