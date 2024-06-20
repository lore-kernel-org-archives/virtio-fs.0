Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47BE1B5804
	for <virtio-fs@lists.linux.dev>; Thu, 20 Jun 2024 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718908890; cv=none; b=QeGq5BfKIf2AxbKiaMriWIlBNFGVBls7PWileljzWruviWtcNk2sKHjnMdhZ1mFYmQ1TfVUG59+6qgZYGed8C5ljV345eHSBblBtlQ7S0p10zMeVOkET/ko846ikdW6guuL3F5P9iyDEVV79Nlov6aHShvsbwKXxBO7t8NChLUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718908890; c=relaxed/simple;
	bh=d1QdY4SqW/kJpRki+uHa4UwLYvG9/iYsOOzObO2Jy3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0wJHm0246SWFYja1yUS0YgmdtgMBHDRObc69yGZ6cGYD8yaf0PaTaCkL6i/yL0q7Hp+lStOA0hh+/+JQ7q6v/4RmT5KQN1NEiR8Mo1uCitqFUIsx/8iMqanhqv05jXSkQx7rQlKAXoMJcdLT+Gi4sd/gmx3XhJxm0m4aU/T7f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/xUDiIj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/xUDiIj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718908885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wsscq/JKdRzaJAqLqDYQ3/XL81ATahJqaYy9nUl82Zk=;
	b=M/xUDiIjtFsTvZfO3LbiR49Lf1mWO2RNy5M/NEo0E3kgu6DpIjiWdnSs4bCNDtEQGVYzUh
	BJDf2JOGvGYS2W/YbiGrjI13SmgE84+lKkog/LJ0pvqfv8mfzGaLLX+EOqMGUQjBjMtvqU
	66Rf307JGYgAc+QRMSCx4Moi+1277Rc=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-oVtojNpTPm2fpoz8LgaHqw-1; Thu, 20 Jun 2024 14:41:23 -0400
X-MC-Unique: oVtojNpTPm2fpoz8LgaHqw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dfeff1ae480so2041473276.2
        for <virtio-fs@lists.linux.dev>; Thu, 20 Jun 2024 11:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718908882; x=1719513682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsscq/JKdRzaJAqLqDYQ3/XL81ATahJqaYy9nUl82Zk=;
        b=YOqjaWWV6+Fx91BehIvVPkFB9DBnPTwM8uc7QuWZ4now1zpJGp2g34R3AwAoELNt8e
         EPua31ACo+Vi81GttWO7rdiIa9WQvTi7NjH+MLPN1ELAvIGh7iuJsg/3n5cptxdeT3f6
         LvMTFX3y8qJv5ga0r1Knp9lVVRopn9rhJErRQbCrcqYJl1efR771Cdio6fyJNJtb+73h
         +rbv2jLbb6JBBmQG4U+kfP/ZadzRJCnE9D0FxqzJQ6vVWiGZz7N3LY2SmKqHNnXrFXRZ
         bgm9tPC7NXO3tqA8r5gAZesFxFYkQV1ZYBcECI3GhveufxZBpvRTriecEX4RODcJNmIM
         Fnww==
X-Forwarded-Encrypted: i=1; AJvYcCX7d0mIX6wKO8S1RFhSHBYWyzVmXLVZvQH2Mx6OgKyUNzZvfX4mG+hjZfnSqpL+HXNvHa6a2J5nF5gGgiYpY/nRHL/5t0Kf0I+2
X-Gm-Message-State: AOJu0YyCxxuIK1UuneA7KGVCnoaXeDJ3z6DSeUJgulj88nB1tfLgukaO
	qnIEhpvTxD3iKO7wGI+IILf4n2/n69y/w6RHg6vBCKTQ+YjxXBLVoLMRilIJuZGJVLhQ/IiLN9k
	cZWBuYyQu1C8K8wNTy7/wlrXOuwKmMsLDzHn/LtliLf5Lz9iWImg1XwzCFQdQTJoqBZBQho032x
	NaOVaNPhPbEQBbSE9VakzOhhWIGz2HVvo5
X-Received: by 2002:a25:ab88:0:b0:dff:237:4cca with SMTP id 3f1490d57ef6-e02be10be8dmr7442775276.7.1718908882465;
        Thu, 20 Jun 2024 11:41:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4NOc8UdwECRcgagRvhhRg0RC++NMIOkU5qBbwylbH8uEsAnb/uJVQro2hHQwMe9uPT4TyEs73SOY1xDM5AR4=
X-Received: by 2002:a25:ab88:0:b0:dff:237:4cca with SMTP id
 3f1490d57ef6-e02be10be8dmr7442758276.7.1718908882069; Thu, 20 Jun 2024
 11:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240620175612.2381019-1-jonah.palmer@oracle.com>
In-Reply-To: <20240620175612.2381019-1-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 20 Jun 2024 20:40:46 +0200
Message-ID: <CAJaqyWebry2dbn4EzfBeqadhzw25tMUFSOKLL6AsUXEFiH9gsQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
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

On Thu, Jun 20, 2024 at 7:56=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> The goal of these patches is to add support to a variety of virtio and
> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
> indicates that all buffers are used by the device in the same order in
> which they were made available by the driver.
>
> These patches attempt to implement a generalized, non-device-specific
> solution to support this feature.
>
> The core feature behind this solution is a buffer mechanism in the form
> of a VirtQueue's used_elems VirtQueueElement array. This allows devices
> who always use buffers in-order by default to have a minimal overhead
> impact. Devices that may not always use buffers in-order likely will
> experience a performance hit. How large that performance hit is will
> depend on how frequently elements are completed out-of-order.
>
> A VirtQueue whose device uses this feature will use its used_elems
> VirtQueueElement array to hold used VirtQueueElements. The index that
> used elements are placed in used_elems is the same index on the
> used/descriptor ring that would satisfy the in-order requirement. In
> other words, used elements are placed in their in-order locations on
> used_elems and are only written to the used/descriptor ring once the
> elements on used_elems are able to continue their expected order.
>
> To differentiate between a "used" and "unused" element on the used_elems
> array (a "used" element being an element that has returned from
> processing and an "unused" element being an element that has not yet
> been processed), we added a boolean 'in_order_filled' member to the
> VirtQueueElement struct. This flag is set to true when the element comes
> back from processing (virtqueue_ordered_fill) and then set back to false
> once it's been written to the used/descriptor ring
> (virtqueue_ordered_flush).
>
> Testing:
> =3D=3D=3D=3D=3D=3D=3D=3D
> Testing was done using the dpdk-testpmd application on both the host and
> guest using the following configurations. Traffic was generated between
> the host and guest after running 'start tx_first' on both the host and
> guest dpdk-testpmd applications. Results are below after traffic was
> generated for several seconds.
>
> Relevant Qemu args:
> -------------------
> -chardev socket,id=3Dchar1,path=3D/tmp/vhost-user1,server=3Doff
> -chardev socket,id=3Dchar2,path=3D/tmp/vhost-user2,server=3Doff
> -netdev type=3Dvhost-user,id=3Dnet1,chardev=3Dchar1,vhostforce=3Don,queue=
s=3D1
> -netdev type=3Dvhost-user,id=3Dnet2,chardev=3Dchar2,vhostforce=3Don,queue=
s=3D1
> -device virtio-net-pci,in_order=3Dtrue,packed=3Dtrue,netdev=3Dnet1,
>         mac=3D56:48:4f:53:54:00,mq=3Don,vectors=3D4,rx_queue_size=3D256
> -device virtio-net-pci,in_order=3Dtrue,packed=3Dtrue,netdev=3Dnet2,
>         mac=3D56:48:4f:53:54:01,mq=3Don,vectors=3D4,rx_queue_size=3D256
>

Hi Jonah,

These tests are great, but others should also be performed. In
particular, QEMU should run ok with "tap" netdev with vhost=3Doff
instead of vhost-user:

-netdev type=3Dtap,id=3Dnet1,vhost=3Doff
-netdev type=3Dtap,id=3Dnet2,vhost=3Doff

This way, packets are going through the modified code. With this
configuration, QEMU is the one forwarding the packets so testpmd is
not needed in the host. It's still needed in the guest as linux guest
driver does not support in_order. The guest kernel cmdline and testpmd
cmdline should require no changes from the configuration you describe
here.

And then try with in_order=3Dtrue,packed=3Dfalse and
in_order=3Dtrue,packed=3Doff in corresponding virtio-net-pci.

Performance comparison between in_order=3Dtrue and in_order=3Dfalse is
also interesting but we're not batching so I don't think we will get
an extreme improvement.

Does the plan work for you?

Thanks!

> Host dpdk-testpmd command:
> --------------------------
> dpdk-testpmd -l 0,2,3,4,5 --socket-mem=3D1024 -n 4
>     --vdev 'net_vhost0,iface=3D/tmp/vhost-user1'
>     --vdev 'net_vhost1,iface=3D/tmp/vhost-user2' --
>     --portmask=3Df -i --rxq=3D1 --txq=3D1 --nb-cores=3D4 --forward-mode=
=3Dio
>
> Guest dpdk-testpmd command:
> ---------------------------
> dpdk-testpmd -l 0,1 -a 0000:00:02.0 -a 0000:00:03.0 -- --portmask=3D3
>     --rxq=3D1 --txq=3D1 --nb-cores=3D1 --forward-mode=3Dio -i
>
> Results:
> --------
> +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++=
++
> RX-packets: 79067488       RX-dropped: 0             RX-total: 79067488
> TX-packets: 79067552       TX-dropped: 0             TX-total: 79067552
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++
>
> ---
> v3: Drop Tested-by tags until patches are re-tested.
>     Replace 'prev_avail_idx' with 'vq->last_avail_idx - 1' in
>     virtqueue_split_pop.
>     Remove redundant '+vq->vring.num' in 'max_steps' calculation in
>     virtqueue_ordered_fill.
>     Add test results to CV.
>
> v2: Make 'in_order_filled' more descriptive.
>     Change 'j' to more descriptive var name in virtqueue_split_pop.
>     Use more definitive search conditional in virtqueue_ordered_fill.
>     Avoid code duplication in virtqueue_ordered_flush.
>
> v1: Move series from RFC to PATCH for submission.
>
> Jonah Palmer (6):
>   virtio: Add bool to VirtQueueElement
>   virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
>   virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
>   virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
>   vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>   virtio: Add VIRTIO_F_IN_ORDER property definition
>
>  hw/block/vhost-user-blk.c    |   1 +
>  hw/net/vhost_net.c           |   2 +
>  hw/scsi/vhost-scsi.c         |   1 +
>  hw/scsi/vhost-user-scsi.c    |   1 +
>  hw/virtio/vhost-user-fs.c    |   1 +
>  hw/virtio/vhost-user-vsock.c |   1 +
>  hw/virtio/virtio.c           | 123 ++++++++++++++++++++++++++++++++++-
>  include/hw/virtio/virtio.h   |   6 +-
>  net/vhost-vdpa.c             |   1 +
>  9 files changed, 134 insertions(+), 3 deletions(-)
>
> --
> 2.43.0
>

