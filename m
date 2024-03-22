Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3651C6AD
	for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 09:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711100754; cv=none; b=hGjYL2HyLhCGjPLvrzIflZZlu0MNwdH2bZ42sgY9JoqfGXd7/N3ix9eg7REIPMQMvb8NBCs/irz7N2nAgEeGQpx6ntnSncP3GA5JQS/tMbU/GBN583BReHBB8tTWBREPv/BTTGfXJzS2a5OCyDoC5VvMEqQgbVmRv25W4sBR+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711100754; c=relaxed/simple;
	bh=JdpST8N/c/MkEC6zF0yVNPLDQittalC6DzV3A10hF7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OVbExUjGHO2cdau5m8I6AQtCWcM/Dol6xpGBpA8O/DZw5EKz+pr16EaHC4JJlan0vp5xpFjsR/lg978oqUDkShqPO4i6+f0FBTAN+smrknvgSrjRtcn6zH/zjiySq/06dd/LRsKHl+8DeAg98Nqo2Gf4TB4p3AMss/yOkm+FOM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gg7QRCbs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gg7QRCbs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711100751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqv0Ih3p6mM1Wn/JDdbC+a4FAYEJ7eUWQ2B+dNDwiWU=;
	b=gg7QRCbsrrCeskytMQoUKd08nNOl7qgpJ2gc6xuH8cb55Fn9BEiD9N2uKpgNjCEc6glZ5i
	3q6Oa0q9kF7M1yU8+8qmLVuinKZ73kuxMhg/jAbNPLyhao9WoFHpRs3tmWW6CM5hDxA+nr
	uob/NvwLNq1a0QRopnAuTzwjA+5z5oY=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-bGZ80VPgPeqI_krTzZj9kg-1; Fri, 22 Mar 2024 05:45:49 -0400
X-MC-Unique: bGZ80VPgPeqI_krTzZj9kg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso3063404276.3
        for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 02:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711100749; x=1711705549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqv0Ih3p6mM1Wn/JDdbC+a4FAYEJ7eUWQ2B+dNDwiWU=;
        b=pL1zjD6QpIRW9VswjXcVqrOSDWV9xVeI2MeuuZopnaIenv0vaHQJMgjrmExEttH6YX
         myNWNf0cgYm17BdNhEDT2GRftFFvA00gIpIPDT9f9rkfE/EIwlnyAh0xBCkUN0jH+yT6
         jUiQ//2/nfNeWWZISdSlEZ6UtfpNb9m8YGNPNHWxk/EhEwIMjNX0D8ZBd0bPIktCcQif
         zux2vXEZ7NZL7FsPhd0YcoXX7FbugYnPbvMjEAaYY2puEGF3u0VRMQfLAbuhBXsyp2Bu
         5S6CSqmW8Q4GwXySpnp1Ps6gBVOdkvnzKNDxA/nW14z4o/MJIdbVxO5fUtC59lGXr6rE
         fIyw==
X-Forwarded-Encrypted: i=1; AJvYcCUMYHADEP4PJmeVxbb4PsKGD1PcS8bQKRJKTrTR1ZisurLcOnwlfzkoMTqmoXGcyd/tzrTkG9mqE3sZt6OuAFvPv5CJzQ9MqYLn
X-Gm-Message-State: AOJu0Yyzinn2uyvNz6N6DW+4+GeHVPG80XAgs83Zz01g+oClYas0Pq1f
	T3gWnoqpzVAxPfpHUbV7IpzmSoVH40GIz88sLEOURX50PXncUKKOSy7nd1f2Y4gyO+jL713xO//
	MakqWHwVhZGFeKB3160mzicbyN4kgxMu40WcfTw4GBLZzHbQpbUqKE0U9hz655e6Bn9WnBWJ1Ce
	vHLHC/nR8PhVELSczGB5fbK2tox50Ejngb
X-Received: by 2002:a25:8704:0:b0:dcc:4b44:3377 with SMTP id a4-20020a258704000000b00dcc4b443377mr1451953ybl.25.1711100749028;
        Fri, 22 Mar 2024 02:45:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVVzkEt+R26j4vuk4WtWuOqtCU20DjLTZdkkjE8KzC8PqZnPKfSPNU6cjSA1ojoPIfQ6jHULLIrliyiMQJq1A=
X-Received: by 2002:a25:8704:0:b0:dcc:4b44:3377 with SMTP id
 a4-20020a258704000000b00dcc4b443377mr1451942ybl.25.1711100748789; Fri, 22 Mar
 2024 02:45:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com> <20240321155717.1392787-2-jonah.palmer@oracle.com>
In-Reply-To: <20240321155717.1392787-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Mar 2024 10:45:12 +0100
Message-ID: <CAJaqyWdg5tg1XR43bHkMRnqvkTZVvrqXMKM__YD6t-xGBOXdYg@mail.gmail.com>
Subject: Re: [RFC 1/8] virtio: Define InOrderVQElement
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Define the InOrderVQElement structure for the VIRTIO_F_IN_ORDER
> transport feature implementation.
>
> The InOrderVQElement structure is used to encapsulate out-of-order
> VirtQueueElement data that was processed by the host. This data
> includes:
>  - The processed VirtQueueElement (elem)
>  - Length of data (len)
>  - VirtQueueElement array index (idx)
>  - Number of processed VirtQueueElements (count)
>
> InOrderVQElements will be stored in a buffering mechanism until an
> order can be achieved.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  include/hw/virtio/virtio.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index b3c74a1bca..c8aa435a5e 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -77,6 +77,13 @@ typedef struct VirtQueueElement
>      struct iovec *out_sg;
>  } VirtQueueElement;
>
> +typedef struct InOrderVQElement {
> +    const VirtQueueElement *elem;

Some subsystems allocate space for extra elements after
VirtQueueElement, like VirtIOBlockReq. You can request virtqueue_pop
to allocate this extra space by its second argument. Would it work for
this?

> +    unsigned int len;
> +    unsigned int idx;
> +    unsigned int count;

Now I don't get why these fields cannot be obtained from elem->(len,
index, ndescs) ?

> +} InOrderVQElement;
> +
>  #define VIRTIO_QUEUE_MAX 1024
>
>  #define VIRTIO_NO_VECTOR 0xffff
> --
> 2.39.3
>

