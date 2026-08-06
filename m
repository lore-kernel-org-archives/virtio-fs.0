Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504023812E9
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 04:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785990524; cv=pass; b=p7yv1c6Umx4Mbn2tGX2a2UlF5j5asJjL2n4TQVSD4GvLVzvDo3IZWu+YkFdC4Byl9wMkYHf8lTXvWpI0GGkHV/wctGWgCR6246Q2ZIY+yyWr1KGiWoWgfX7qQ1zVi2q1tXH0HB/5zlLwlziEKUq7sOtPn5/C5cGgPZoo13YS5Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785990524; c=relaxed/simple;
	bh=K/o9mrHR8QZ+3FxE98tvwR9KIWXjlSPJsckoKrYZV+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5tSgm84PGMHu0DvwiMdZs5nbn//tEYFzJzEUAhSbZrGc72v5aFcfnoQNBr5Kyw9ZH5aV3qp9jXBJ8rGvylGQOOUKnD3GySgz/FomSYTwW/XyLoecIQYh7cf4qTpAq1DyaRHvjijq+MXXFoG2XMiGqFo9ObBscjrjbGDR9IeKVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HC36WWXN; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HC36WWXN"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52cd38ddcdfso10468861cf.3
        for <virtio-fs@lists.linux.dev>; Wed, 05 Aug 2026 21:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785990522; cv=none;
        d=google.com; s=arc-20260327;
        b=qtJaaJsrsJmS/xztLAPeNULwWGSv0jlBe+2pyLxhy37vXyfcXu0XLwlWG2qMtYcn6p
         guBB87g6mG05VglJVYZik3YLDDfIvCp0wTqzQA87w6j+/g/nJ8lZiw8tsI0fFGmsTxNH
         0Lr8dkyFXtRDki22F+e61DSeswFe9ciE/VBDFsS8MHtvKxbHpIJixDm6pkZscdTGwQMN
         VEqY0zGtCtyUrsnRniVz0zcUyidbjqfKf+H6/S1g5dkEXv0vv/iM3Ypsjo2qufrY5+iU
         XQ/xAZxAfg1QdmAxFlcLQOtJ7tDxBXYuBrP9kYXryQE+znprLt+Ut8O5xTH0IR2OHfVc
         O5dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7HTjUuWuz1hkJDPG/7b0LR7ioyQYvKyyRtXzOalkgX0=;
        fh=FFAcyuvV9YaBRPsqQCEGGKKQ5rH4eHnOT5c1f7nrno8=;
        b=s/me+SexhL+j3HcOfHKlgeLUl11uk1pGgA6FkdOjil5SF2zkyaBhWXJV2F04kCN+/z
         arplVzUfimJ1JrRlagYF3HURRirZHKLb3KCI0+bTlFcY7jT8LNPWpGqry/wcPIHt8Fyt
         TFMclt3U4KzVq78uw02Tmzm4U/t8mH9ls73cYLw167OK/UijkNz4mGETCFZSQb1lqy7I
         xGtEs0ujk71tfMX5ht0N7qpebgU4btRy5d7q2JuyX70F3us5bcsJRG38Q9+yxkUg3JBi
         CIH+Ui0MnZt7pghG9/JdU4D3clW/1azPYR20+1lZdOsadzVyI0BIGCVPmVI6fxjwtnyM
         RhnA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785990522; x=1786595322; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7HTjUuWuz1hkJDPG/7b0LR7ioyQYvKyyRtXzOalkgX0=;
        b=HC36WWXNi7TP/Ujg9ho1HegCdsCFy/Zw/AjKt8W2U4QtiQI6aOUF0BZ3L1lOvBoXpD
         qtWCRPW2aAeWtXIrb94Hcz+UTB/B9o991w1H6Vip7p+pofiAdh2U8TN983CfU9LGQuE1
         D4782UzKsnc0Wo7n2J4JDKlTXCqvZNGi8/Sf8V9Co3q8bnyoB567IG6ABMFGr6ZJqnpr
         7JHRJIHb8PMN9PLf4fyIYeQsG3sMiraALUq3MMi2wlIg531mS7jV0UeVkglHErKfxfP6
         4SpspDTZNjqqhbH/nyqhpX21mPR3Qx1DZIwMTafPMkA2g5D95HCg2W79MTOb5IZvqFO1
         m+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785990522; x=1786595322;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7HTjUuWuz1hkJDPG/7b0LR7ioyQYvKyyRtXzOalkgX0=;
        b=Opu6rVVVDGX+m1S36TQp0xn/EIo5pfTeUeuSTdZUCXZ5DU2sRgDozBm0S9WWo2oBgh
         6d1X48zEgLe/SJ6MTdF4p9PUg0dgVC2ZP0EgbTQzzjnv8GYnz7HDt/EWasSj01v5eQw7
         D/wTu40ClE5bxtjPEYYAAY4KWd0qgo+FG9GUcLDgPxlWs1RIn6VQxxjU62YBNHfd10/a
         mKB0pZkBh+rPUzxriRMXnRWhJvaVjdAXuai4Wgq3kloNIRogNIuXVOr2zJHs/oOEJg61
         rLxJPh+h247F6tZq0gexJzgQ6X67cAAUrqbD6OjXi9A6CzVkKk4g4HSoFSXTXKkO1m/k
         DjFw==
X-Forwarded-Encrypted: i=1; AHgh+RqzMXV56cjHT+LcyDV9ptPKgvApbHwVyC9yGjnTl/FyuUAwhTbx+NmGSBAWUIi/IB6NtexhEhs/894=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAUZwkKhP0tNMIp9eZ6TU7ZbKCWg/bfYvdwZjVEimnw8FJlXRe
	0I6r5H5665M8FJEqHPQuYjn5PDlmeWFOTllxRPDK6wA2WO90qz+x0L3p2LXUdUFFJ6vjRrZ47rN
	rSy7vAmoFyYEY0diM0BxPE2P7bHrH3vQ=
X-Gm-Gg: AR+sD13d3+r3nWhnGSAo2zNwX2fjORdYnFYzfVa9nvjff+46hKOJi8oPvm6cW5vAK+1
	Dpk8HVI7KsbAN15DjtAmcZYifayGn/XKshLByX8EK9ePKjfBkutb5d5jjn9Iu1dM3iXeAWJPA2+
	LrtiJa8m9bfVTbjfG0On77iG3zPa5qAImjgGn+V4/zdQUbgwfre2FhZRK5nra7cDy0pxynicRFd
	5WS6sUIiuErK/DvxhXaw/ql+sc64p2mWlc13Zk/bfBDFnTo8w4RqTPmDRkpVdFzFWQJDuyCc0+R
	Ilpw3YxO7T7LA4YeV5P+Gn5cgh/Do0Kqj3sNGSGeWoiHVKZFPw152CcKOG0oHaJAbMtqfxV4ZBi
	VyA==
X-Received: by 2002:ac8:5808:0:b0:517:71d2:37d2 with SMTP id
 d75a77b69052e-52ce5e00f67mr121953401cf.0.1785990522167; Wed, 05 Aug 2026
 21:28:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com>
 <eb1d8424-206a-47f5-9ad5-a833a56bb3f3@redhat.com> <CA+spn3pLkHn_Wk+-xa-k2PKXdDSa-S9c1Dd94t=Kj5tajPyzSA@mail.gmail.com>
 <95fe9d1a-dab1-477f-948f-4a42a1e3f09e@redhat.com>
In-Reply-To: <95fe9d1a-dab1-477f-948f-4a42a1e3f09e@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 5 Aug 2026 21:28:30 -0700
X-Gm-Features: AUfX_myeq4cgveTvA9QN9nMYHZdXFkIN8zO2K-kwrIi3nII0KCENKjPycV7-1m4
Message-ID: <CA+spn3r=75BCypgw-D=MB7RA7EcET5QfvCtY10f+Azw+xMCUxQ@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15] vhost-user: Add memory-isolation qdev property
 to vhost-user devices
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

On Tue, Aug 4, 2026 at 3:46=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 03.08.26 22:32, Connor Kite wrote:
> > On Mon, Aug 3, 2026 at 5:21=E2=80=AFAM Hanna Czenczek <hreitz@redhat.co=
m> wrote:
> >> Should `vhost_user_vga_inst_initfn()` set up an alias for
> >> "memory-isolation", like it does for "chardev" now?
> >>
> > I am not 100% sure but I can test to see.  If an alias is needed, I sus=
pect
> > that would also apply to vhost-user-gpu-pci, right?
>
> Right, that makes sense. (If your testing confirms that it=E2=80=99s need=
ed.)
>
> Hanna
>

Testing with both vhost-user-gpu-pcu and vhost-user-vga, the
memory_isolation property is getting
properly set in vhost_user without adding an alias.  In both cases,
dev->vdev refers to
a VhostUserGpu, which has the memory_isolation qdev property set as in
other vhost-user front-ends.

Unlike most vhost-user front-ends, vhost-user-gpu does not define a
"chardev" qdev property.  Maybe that
is why the "chardev" property needs to be aliased?  However, I don't
understand why "chardev" is not a qdev
property as vhost-user-gpu already makes use of many of them.

Best,
Connor
