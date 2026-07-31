Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552BE2367D3
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488331; cv=pass; b=lPlFOKkGMBqtnbXQKUYmwBldmdUuKqfE0fivLUOfgSkG1ssJSl9lsE5fJh/T3fVCD1FC6uwbvFWFiH1JrKeu4BWrpFm0WoDUe4WxJQcYXgp1OwF79pcHpUUe6S4lXDoZZzSKq9o3xRLzvGHhH04PPUzJJBfpgOvZGcGjWzv8vQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488331; c=relaxed/simple;
	bh=72eKBA0P6vSBtAScSr+34vwqBF++/QInBQAbn70sHT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tF3nmERN7VmgOWSPG6fPxAu0hCt9wC9bhSExrvioafJYS3zj5YNIyU/x38E0bH+1nL0qVVjRW15jnLzXOCy0gmTq7pABUYsexzxSFS1I/hR/rQum2pF9pCjDY9q/imzB9wSzrpeZ+B46kQJ1cB4ase2MGYAPzCIMBROpDbpdV+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ukaVqoE9; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ukaVqoE9"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66807ba2f0fso1010479d50.3
        for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 01:58:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785488329; cv=none;
        d=google.com; s=arc-20260327;
        b=L9RJn2D6f5vlAWX0e9vXjMAyQA6phdRWS/mvYsfDh7JhyqZnq8A1LbUvV+4N4Gd53i
         tR9SdUkpxlzTamnjSzEmBs1tGyioydNtesD2esDiCAydsm0Aonv3A+/Wnr54svlsudWW
         xeGFL+gFohetAC9e2hACsju46c9upe3xppwfV+JDfJ7eltGdaSCGi/83qzjvfRAUFF0a
         WZb6bPQQ1kTEPZmIV7caHERSAcLNLmi7IfoHC5DPuDP0LSBgSqoGlNs0hji542XHpxMC
         2MsVMW4xiYLRJvpz1MHgh9RxO0WjeJkgEx1FJbC5KOqu4U0B+Ra1kCkMiopSt6rwSVr7
         zSyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cjzJ3LqOhhqUQuv3Ul2oRa8Rsc/LKEczqA8n96bIPVM=;
        fh=hVWsXe94H/4jpFqb1z8MrKaEeMBUL+8Su8oUsndINJg=;
        b=qTdIRW2LW2em58Sptipg1XUo2m0h2G6ShBuDV6j1rPkPLWEt+nf/uf53O0XeyRJG99
         6L+gKHJFEbU147XSk4GUx6gr4BpJ41/syoRV38a8ySI7+yFtK/7LK/DDK/2wZdAQMD6v
         gyR5QejmhtuhNWrNoFIdGbkot2yo9MgQhJfDBpM/HaiMeuZXcYffquFjner91Y2UDzCQ
         ZwgH2K+LqhmmIadlUIprRryLebt5fd0PHUSUTwQDQmAI0GJh2qiAkdtOfzLIFJSmZ8ZV
         hxIdU63FeceVLOy1uZbsQajfwhkYE7ECAXTzjBplVAeXJMmX0xYRvq7MmpkhkTQkHmTp
         TEGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1785488329; x=1786093129; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjzJ3LqOhhqUQuv3Ul2oRa8Rsc/LKEczqA8n96bIPVM=;
        b=ukaVqoE9iohtK9dHUwS6gPlYhRV425j0yCsoT6MI+sOtiAM94AmLDbQ1colXUpMGps
         ZoYNYJU0Jn1OBOX0qJD17jh5lcR5kLE41bdIx356g78UsBIOGmj9diTlQfVNjQA/suP+
         gzmvT3z1cJEgx6kFnT1Jha2LOo0f+v5oGyEqlQT6X7sQF6l0XX7iuHq+2dwBjA4anpWE
         kNI40gQtdT/ve8MQ9B9Iq6bruMHWkWH82W00LUtQB/BtDXIxfM/+tAzQok+bWFLJGUef
         xJhEuQpjkUrBnR/MP4zgzWK2T+nab72U5QE6LWWhEqJeugY9yZZv5qQXOzKIRKQyjV0D
         Vu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785488329; x=1786093129;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cjzJ3LqOhhqUQuv3Ul2oRa8Rsc/LKEczqA8n96bIPVM=;
        b=qVTopz5VfE1LCWegMnGiP38ZYi42V+3+VQJBXu/eP/ittaOqwH/IE7u8pKEjWWkjqO
         Y9sx4OsLaPVf4swX2c5ckh/0QzWmP/tHse28exzXHfeFlD5tiuTVG4eXN6WAtFHIhzhv
         9T3q5LXojS2LAVVZ7a9o0evdnD8tNylh7ceFlGBSX8o7U1qy8MXHfFXpUWXTCR3ZzSDC
         Rvp97cAMHBR7g+s45Zk/Mf9utbKD2JD545vrwMgZG/rTYX/QcuSeb/yc4h7++Nmlw2wa
         +WCwvaS6/NBo6/phQahgQmYFG9DyK7wAjkztJVFwqnLWVgqEUswJI9mulfmXrnQM+Rdz
         ozLA==
X-Forwarded-Encrypted: i=1; AHgh+RqYUD+2wPvQJnMEai7tMnvzgekHEz4KRhMxqoX9pjwj9W2BuNOK+6+oXeMphXxqpYRjVYKmqjKnz3k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGfhe+K+eiX0DXNIlwdE6IQexAKyB24eGrkn6WcN5MpTFSdQrb
	7BeB77m7shWDDCkWsvS1uECANq2QNU1JsQheoQvBQetT/vq99KTnsyMAYj1ZipEybNCKF+LhbDN
	hmEWByBI0hE4YUd9gwneO7vU2NruC2nmY6WyHrDXQJw==
X-Gm-Gg: AR+sD11qrPh7Hc1ZGkELYKtzRrcahPq5CY2BgEwktYAKxC/NdSEg52BBpiGGDbbGL07
	bWYTfv3mE+G+/D30/CFXoUQwImE35MwFV4NNU07Yvp2Rb1hUvabfhxHkO10Bz1iI7eBEywR6q8D
	MIBdkqsE2gRinNMcD5uS1SUskicOYgSWy7JOxh4974uRsdNouJ4kQ6pljXS+E1HHPPbscPzaAVo
	jf2sJYWtTpRVW/Q+Lr4ee/hRu4pr//syfN/pss37ZnGsdRxKO3/dghoHDkIok+N0yx2VoSDwpwW
	v+ppP1HybnyzAgILlDXDI6jByl8tAWMnnEZx0U8b/yFg7caeVVw9zRlpsj4r9i0bfPXbgKyg6hK
	TTQv02PZsXDQ7DywN2vCStUlZP7UQ
X-Received: by 2002:a53:b45d:0:b0:668:2e46:41b5 with SMTP id
 956f58d0204a3-669454aac14mr548397d50.47.1785488329163; Fri, 31 Jul 2026
 01:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730205846.19479-1-stefanha@redhat.com> <20260730205846.19479-3-stefanha@redhat.com>
In-Reply-To: <20260730205846.19479-3-stefanha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 31 Jul 2026 09:58:36 +0100
X-Gm-Features: AUfX_mxlzeSqCJD9cOWoq3g9Vs2ibL5edy5Gf9kCAY7YrqrYTBrtlQ6XwJUMXPM
Message-ID: <CAFEAcA9Opun4GED3TGoJB-tDKFy=70raJxRK9gSSe7booz-vaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio: use Error for queue size validation in virtio_add_queue()
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	virtio-fs@lists.linux.dev, Hanna Reitz <hreitz@redhat.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Christian Schoenebeck <qemu_oss@crudebyte.com>, Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Alexander Graf <graf@amazon.com>, 
	Laurent Vivier <lvivier@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-block@nongnu.org, 
	Greg Kurz <groug@kaod.org>, Raphael Norwitz <rnorwitz@nvidia.com>, Eric Auger <eric.auger@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kuan-Wei Chiu <visitorckw@gmail.com>, Amit Shah <amit@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jul 2026 at 21:59, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> Coverity is unhappy with the code path where the x-override-queue-size
> property value is passed to g_new0() since it is a signed int rather
> than an unsigned int:
>
>       *** CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
>       /builds/qemu-project/qemu/hw/virtio/virtio.c: 2595             in virtio_add_queue()
>       2589         }
>       2590
>       2591         vdev->vq[i].vring.num = queue_size;
>       2592         vdev->vq[i].vring.num_default = queue_size;
>       2593         vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>       2594         vdev->vq[i].handle_output = handle_output;
>       >>>     CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
>       >>>     "__n" is passed to a parameter that cannot be negative.
>       2595         vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
>
> Introduce an Error **errp argument to virtio_add_queue() and set it when
> the queue_size argument or the x-override-queue-size property value are
> invalid.
>
> At the moment none of the callers propagate the Error object. Instead
> they are all modified to pass &error_abort so that the error message is
> printed and the program terminates (it also terminated before). Further
> work, especially in new device emulation code, could actually propagate
> the Error object but is left for the future.



> diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
> index bf64d1231a8..4045414cd2f 100644
> --- a/hw/scsi/virtio-scsi.c
> +++ b/hw/scsi/virtio-scsi.c
> @@ -1317,10 +1317,13 @@ void virtio_scsi_common_realize(DeviceState *dev,
>      s->sense_size = VIRTIO_SCSI_SENSE_DEFAULT_SIZE;
>      s->cdb_size = VIRTIO_SCSI_CDB_DEFAULT_SIZE;
>
> -    s->ctrl_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, ctrl);
> -    s->event_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, evt);
> +    s->ctrl_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, ctrl,
> +                                  &error_abort);
> +    s->event_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, evt,
> +                                   &error_abort);

The virtqueue_size here is user-settable via the device property,
and the realize function only checks that it is at least 2, not
for any upper bound. So this one at least ought ideally to be
propagating the error up. Still, this is no worse than the
previous situation, where we abort() inside virtio_add_queue().

thanks
-- PMM
