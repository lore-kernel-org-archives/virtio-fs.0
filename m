Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ECC3B71A4
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 21:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785791618; cv=pass; b=DKcBAvKd6Ui3DhLkabEF6+T7uXVux9N7Un4NXtJfqeE8uh5IMCEmox55A00/pa9Sks5neUkLMRe+VbqC7yGrYw8n6mJ7t1WzjKodfSCtI5B4qaqsfsTvgE2J+3hl33GfJ4WGA4rhqizdQ3veFNtsMnynzvKMQNn4RHPR0ft+420=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785791618; c=relaxed/simple;
	bh=t9+b5UmJWNQfiwJnZ+/wZIR/BDbMwoNsO3yUCClC9Ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=giYFl5b3OEj+jeOseYtEiWqhjoLd0UvO9TBysNr7nvDKlXfhHXuILtqvgRB0TPLd6Bz9Dd9uiu3GdPCIZho9sBcqEzWz4762Z+NWxyV6T92PwzkxBcgiLQxy+lt1cY3QiNSeJBa3jzlI21DNjVMEo1Gvh2yj58jzYLWv/KOk1qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xl6r8oLZ; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xl6r8oLZ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52b3934af3fso37510581cf.1
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 14:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785791615; cv=none;
        d=google.com; s=arc-20260327;
        b=BrEORocESIWBeItCKbo/yc7B2/XjdYDp7SKgEF3WDTC0zlvFsFsQMTxU3u1nezLOi9
         A2IdwdGPL3cYxgHSB8yPlH6+J0z1tQGPW05xU2sNAuW9DdPPZyDhCuo0Cd/urNXp8IBS
         ddC0l6MMDgBBYatVjUZ/Qk4tafQ7oYYUFBe3I7/6rgxmv68zcMpfCbZznrUuBubqjj46
         x+G+V5mUERycNbFXmXPQ+K6AQRxwppqMwqMWoayL3Bf6S1TbaA0AHQPwwf5ptjM9wu+X
         ld2xsDHNJb+tAExLysnfUYvhLPOF1cdbgRA1oPqpgIcIWXd/LOnA0TK5X2Roq/aJSfCf
         xkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hT+cJbgNjyBy4vcwWTIgV40hxtVdgcRtIAyv/2vkSGQ=;
        fh=TeAPpOdlSy+9d6EoRkhmlwG3n6VbdszkMHrV4wh8VCk=;
        b=GFdPzLXVIbfVttVRtxBVclXPu+ndmjxLXiQZCsUysiO8fmpgKx1L+zH9El3fYUwmwA
         Zmp3d/juwOHbITD2drU9tv/ko+kh6twuUPXNdCzNRZevYSA5RxSunWDFJrVQxCizgEQC
         A4Uuv/ZrdLcTPcTriyaeDDT39RyKhdxZPG+gQMayPwxgH3v5XXu6v4C1469tHMbvETGr
         qhzzPHf48t9U4NppYRfILqC1IxGwBT9n1yh1VCkE01CPS5hYBPTq2n14nhOBDwFs0uhZ
         TPJl4TntocdzL6qWIzswSt9TmEgShan2Uq7GJSDXjzyuj6cYE6fW6H6j/z0hbDuOcqqY
         UXiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785791615; x=1786396415; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hT+cJbgNjyBy4vcwWTIgV40hxtVdgcRtIAyv/2vkSGQ=;
        b=Xl6r8oLZjiuQo1BoaMx3pkBmO3WvJNho7MzefyolWwA8WlfcTXJNYNuYiSKiA6oC0Q
         Yc144QV3Qsewt6Wvg88bMU90GszBBRw1MeWh0tTr/8mfN2PxLLVH0WJ84PAJgiR8EE93
         QHGh7FrgvBwDbagQTzRVQWWRjEr6JwQGsJZEIZ4C81/mJCSgWhHF3LhchtIplf6KkwJ4
         E4a52i9VDC6r9vzA3hK8sRtNqTEBDyrh+imMqqJxLBxIk4l6ZAHSTOuGIOLOc3AtTEUo
         Ui0/ZqptS9K3Y62D516vkPJYt23Vu8vnGCAhd9E8q+0XKk/Ih0/qgQD3hh9OwbPRLiWo
         W38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785791615; x=1786396415;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hT+cJbgNjyBy4vcwWTIgV40hxtVdgcRtIAyv/2vkSGQ=;
        b=AvjMjAr1yKzainsRwTSopqH43KkUK1G8rHeV7dV2w3dP6fdbeU5evg7jXvzgD2v/Af
         2KHBfYbxaCVFi0CI/atkT5jx14rvm9tOQa0VbUHOTL925o2CX0snpnmRceXFcKb3vCc2
         +28ZTTed7fyPl3aQRkK7P5MTecrHwiKI4BCNTm0bk21WkDS2Zx4E4fiWC6dsuYB/OIBb
         TOgQzVSacCjHyyh2AIu0YCgliwYT9Hd6GAQNKPMnQjjSKN9M8XXfiFUvzVmkxXcpCC0P
         UPMes2S4FU+eAgJTTtXebaWJ5yFzuU1KPXD5Yv3fgkkbbdxNyYYFFukN+C+U5XAN/kwC
         znxw==
X-Forwarded-Encrypted: i=1; AHgh+RqmyMDadKJlsRlxg9/KIhHu5wbuLrIYadDVmkBzJ4khT4c92vxDLDcCyUOJ+elUNOnKHPl1u53sDuQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3no0OCNTmDyFSocrV7jk7X8A76BOsNffzlGthSx0a0v+pWRpe
	m4CTdTXaMYq5EJHK3rm7CTXJGOkjNfcTPT9SpMBwy/nl5o2TVTjXKOcUPlNSPRIKnlCiqqcJ3ih
	Qlc5MMTPgypv3QceQL0Q/dcptm6AQcI8=
X-Gm-Gg: AR+sD13YG1n+GW4JLTCk++CRgqaX0A0lO7laSJEXfyLRwznGDrBrbX7j7Spi6R0ZURm
	eGZewoIIZXkZnKDc3IjnBRnk4B4vSKcJq5HBJd1RMbEb/H2WfHuoUKBl6qCDCEeqJIuYt46UzSe
	JjYJ9DwRPGtvnwH6QLToPyRYGyfa4IVk5nmIUB+XqGQ+ukRaXrLzuETyyhZRw6e/ve34AAjeyyh
	289JEcGWIsoFlADVjdPoYM5RyfcuroplvEogrVMldrVJBnGrpu+VMCwjxZMi2ZtOpnt9wC9+6w4
	6z/Asfrui1QJXWOGpoQhRQhud1bTTCNnTgXunWM5oQ+o0/ZN2ociXnnZ0U4kagAEDxuu2knloIz
	h
X-Received: by 2002:ac8:5c8f:0:b0:51c:2190:3b47 with SMTP id
 d75a77b69052e-52b5666c7d8mr246614041cf.2.1785791615528; Mon, 03 Aug 2026
 14:13:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com> <f7776822-106c-47d0-ada9-fab75f68c76d@redhat.com>
In-Reply-To: <f7776822-106c-47d0-ada9-fab75f68c76d@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 3 Aug 2026 14:13:24 -0700
X-Gm-Features: AUfX_mxjrOT6EN9f6nOZy_M_lmCwvv6GQNTDcDJCJ16qrlFbkhRfh-vc1CvT5tQ
Message-ID: <CA+spn3rjAu5EcWBwG4NJmwqobdggJmZYVPrvn5Yq58Zyf0NEDA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
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

On Mon, Aug 3, 2026 at 5:36=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
>
> Can you document roughly what the function looks like? Because the type
> (`GTraverseFunc`) is not defined in qemu. I know it has a boolean as a
> return type, and that one argument of it is going to be `gpointer data`,
> but surely it will also take a tree element.
>
> Hanna

I have updated the comment to describe the usage of GTraverseFunc as
below:

/**
* iova_tree_foreach:
*
* @tree: the iova tree to traverse
* @func: the function called at every node. A true return value ends traver=
sal.
*              Arguments:
*                  gpointer key: key of current node
*                  gpointer value: value of current node
*                  gpointer data: data passed in at g_tree_foreach call
*              Return: gboolean
* @data: an argument passed to func
*
* Wrapper to call g_tree_foreach on the underlying g_tree. g_tree_foreach w=
ill
* traverse through every node of the tree, barring an early return. At each
* node, g_tree_foreach calls func with pointers to the node key, node value=
,
* and a pointer to data passed in by the caller.
*
* Return: None
*/
