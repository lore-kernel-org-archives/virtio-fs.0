Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7941018CC13
	for <virtio-fs@lists.linux.dev>; Fri,  7 Aug 2026 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786132178; cv=pass; b=nSaWYtxS+xvUF0jIv8FITayRKMqsPvk1VbSaI5JTKtoMvP9Daz27FrF4JHPSQjyAFGLsDVX4m1C2FTcW6uB7SQOL3hlbbLzX9uTyMgJiGviG4OTQaK8VsLywxxPpZZiAmDC69RH0bw9u/D2y8n1vkTFfNRJQ9N3W/fIgaJrOv3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786132178; c=relaxed/simple;
	bh=PFvuLViXnQjefz8qoCLYpFXqvEfuyroUW0qVCBH/P88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FfZlfhEhJs9yfRPnpmVY7PpE6kWx1ZcQXDV9Sgvj/XZjqBfBYrG2j94piMfZOZo3M6gNiDUxRjO9m0vFf6Sl9H/NpMEsAihROZb2AqFrynk1aFOwgBFVCm7JUVSiv8TEW7UNajxU+aoP65NQpfLRuL5XUGnj+9d3Cj4TiaH2tPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1abBWi7; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1abBWi7"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c0ecfaee7so24204121cf.0
        for <virtio-fs@lists.linux.dev>; Fri, 07 Aug 2026 12:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786132175; cv=none;
        d=google.com; s=arc-20260327;
        b=NtmHVXSMzh8r41+0ONzwL0eW11hTK2oI57GUYHPf/2GkOYKr0yxWCJpx+ksRMPQeBV
         JDbNcdYPxkllRKEou9oK/9SjhdPecGUqvUVQapHsrMlgpP9teaiAsrDnMWEIHtXwhdq7
         9BTY7eig6Dp4ZdRQKJWNplY3D8K8jtVaCCxUp6AzpJVvDQGT9TbEE5iVywdP0FWlJRyH
         BGvOJ3r5/4RESr8Ht8dxkzEqGfQrQVMlieDEh3nep16Wv/BedbyPlEBs8kjIjAHZYkUF
         +ubo/WZZ37Qn0Cb1F3ItYZXR5rQn8qOhvBTwgIf+eszmsUKvEcntSZFpLzyMcfgtd5lI
         xZYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qPlPrCC1wjDsIRLQ7uPOI/YmPR1YtWDgu2qpSGiMWkk=;
        fh=qEanROWfTRWGMB0kE0WdqGIXUf3//tF5zsSd18l4Vzw=;
        b=si7d/pYxKxe9a47c8tvI/NR2GOcEAFn/qhDDXopgrOnLFjFVJXUNXB6T/WI9fPFo8w
         wLmOqQMca0NrSK5bFmKFJ/pn6SnVWL70MbJcfP9yxSt9h7U9s6SNy17AEzXAuiJB6GSJ
         xM0Uyxsx+/BUA7d8KVfw99rg6x1jzog1lRsgn2SOHblrowOAbhhMDHZ0Xd76vZLHTLDY
         z9CW+byp/KTaJ4iIYYDq26p0UpwLr9P65RcE9LZRdhbcbEMAUf2kXaRzjbrLo3Azqttu
         3bh3npJUKI0d41Wsfu8/RJzmq/1IaBPO1vSiwGu6SGz/sIgb1t6gOQn47rYpMRhTgokE
         v8Yg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786132175; x=1786736975; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qPlPrCC1wjDsIRLQ7uPOI/YmPR1YtWDgu2qpSGiMWkk=;
        b=F1abBWi7Z8cy0Sbu+Bl1O1HIqLji9nJUk3Sf33A6qU26fnouFNXgGduW9QYIWwV/kh
         QeZZdIDvGQGpFxdLN15Lbic/e1zaHbrJmskhYpREUzd7dTIZ/VI+yOk2RzSmwT4YvBHm
         2DmLDwdFuenPjLd5A/0z7mqchYhyt8RdMIDQKh6130JMRa4vAYtQn2C0JRrgv0sxB8LM
         Ny4B5Q6iurltjKz8fQP0X9Q0cCl4Rpj/X771DDXuy74q0ohl6mqpsHr33raBnbLy3IDT
         EuIfnGuFbTvdBHumrCBXzqy/ejsUNcO1vVg7lF2SbsgHZUiaK4FjAq86YbNl0h0OlUqE
         cwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786132175; x=1786736975;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPlPrCC1wjDsIRLQ7uPOI/YmPR1YtWDgu2qpSGiMWkk=;
        b=Wpkc7ovkVZv9GlvtrIufUMlL9N4yO0GpE9dWQm5bBf9yXBlz37MFltnxOcHQvT34mr
         PYusxt+r06dgrFRAjUpS32ughCmdawWWJ/oSp2Brku8ZJA873ZgjwubkH+HqyqwYXz6R
         VcnVxbD/Cy6L5IGY78XZA2aUlwZeUWgN4S1ByPZthRWXjY1+i6CXwT9O3HcPwhV8oRxH
         iiFlo0XHVdfEKOeffTcHFThV/0srahJjxX3XyJ6/2GdDmTXH1ZlyG13vVyGH65APOpJR
         NgKwo5UkiMaY9mdVA4reoLMA/QK1DuORVY8c6OqDfdG15BvH2JaFv/RH1C1FGocX4cDH
         WOzg==
X-Forwarded-Encrypted: i=1; AHgh+RrvUSwF9N1ldrDhdH2Gnb1YkXSpC1wHDGRyjl+Ri/rIvvZ0vE1+IQ4kcMiQhmHvxHCiOqppzjF2N38=@lists.linux.dev
X-Gm-Message-State: AOJu0YyI3TyfrjlAnGNrHOlt8/Fn//71NuwqhmvMf/2+knE9yjBAkSrY
	KUiILC3TOanvH6yyt2RPAXkIBp0rsME2xN8kTJgZhjtRVe1wVa9xRi229KAKpk+XSu40gIwHKvc
	WXSBuw1bAFHbpwNCdAMzBe3QLdBvSGsM=
X-Gm-Gg: AR+sD13PPRHyJgW9M1ou5Iuro0OyHOF3nBA1IkpLap8yMozlj/fHNoSVnpVJr4czb8O
	4fSotCxCwIUvhaMcTk5xj3VFcFJEcA5HwStd+T3frRsr0/nBrb21nQA0QhqfguN/5WT2kA2exBd
	WVFC2tZ/1HZMeXu2xx4H7KYMmuG9iRkpz10RmS6BW1oN3U9lSf1Ubech5bcGn05aCBgqpLdsZTT
	YH7cbq2y61M+g1xHX4vPxHzFm9PhJtJxunkRNqZB71YqH1jUkqXG1w8f+LqQVHVK0EbKaz8CKgv
	m+ALCDUUjfLwWl1wcwAUlqSp+UlFfexoFWTGuW8bEhROcOJKieiVBQGRJPVHp9EvETOVuJB+ZD2
	HY54=
X-Received: by 2002:a05:622a:5a1a:b0:51c:10e8:ac7 with SMTP id
 d75a77b69052e-52ce61a0400mr300087051cf.37.1786132174439; Fri, 07 Aug 2026
 12:49:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com> <20260728152308.GG371693@fedora>
In-Reply-To: <20260728152308.GG371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Fri, 7 Aug 2026 12:49:22 -0700
X-Gm-Features: AUfX_myXIEW3N1umee2ouDa9Cd7EMwKxvm6eLMFkeRcSylIW_CGpv9yHarg5uLU
Message-ID: <CA+spn3q=EZR1bx3tw-hnk=Hhqk1fNXmpqUoQwMv9km_hhcr3_Q@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
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

On Tue, Jul 28, 2026 at 8:23=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> Why is base_addr a hwaddr? This is QEMU memory, not guest RAM. I
> expected this to be void *.
>

It doesn't need to be hwaddr.  I will change it to void *

> A size needs to be at least documented here to reduce the chance of
> memory bugs. Even better would be an interface like
> vhost_svq_vring_total_size() so the caller can fetch the number of bytes
> before allocating the memory.

I haved added in a vhost_svq_vring_total_size function to address this now.

Best,
Connor
