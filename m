Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80978F39
	for <virtio-fs@lists.linux.dev>; Sat, 25 Jul 2026 03:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784951449; cv=none; b=tgNTZYxFNhukHehPXyrfZTrcEV/OkJorDZ4tH9+Ws1s3mHf8JyeAxEyLTcMFqYXglP0HfJOGAoo2cjK3AsKU3AS4Hm4U02SyQPjaWzqmIYa9vm8Ym3w8kF0xpK2vBmB9L4YEuE7dc3t8P0Oee0XU6CV4x8IrcnH4U2j14KVvnTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784951449; c=relaxed/simple;
	bh=mROuDwUvy193QLIsKDngQ6rOzkbNoM3B/oSvgu89O5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqlVckp8xxsqjZcJ+asyJOULU6SqG8dwlWWbXiWD0d7h61vYUX1z4fWs7p0AwN3gKlqpoFJp3dX3o6fYxupQQXgHN5l14ikP2KXxng4Ab95FSI8t646PsrbZdrJVgZZtaEdRRFJbRMbX+zVql9MoYtx10wxlAa901iDaCqaVRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Gy8oWwqq; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Gy8oWwqq"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66P3j9JZ074791
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 25 Jul 2026 12:45:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=TTDrMrUz5kVQCujTWwvnoY6dMbXMfEvnn4K/R9id/Dc=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784951109; v=1;
        b=Gy8oWwqqaF3dBoNA44REwP6MPeF3ZynpecZf9Ndq+gzUwRhjACGDXylVS+wvrfnB
         Lh1Rkc1F89pe1i07r8fet13n94icwoftgPVHXq7prODEx7n1swA9uEiMXdarYOfB
         Rtf8ALPf4z6XgwwvL8afv8Zev6ydU8ngcw2Wj0g5lvUfqBbr+Mm8PHdKvHBUhNj/
         3VOlexqDAdhNrYRL/WlpDcGzugZxtiTB2493XD+yy6Veoe676G1/mBC6RuTynJ7T
         LtRlYmubTsSuBY/mTxidKeAB5OWqARgczj7OLK75VBUsxofy5b59gjzuukplU+pU
         O3WSHHC0MGsv8YqPbGinRw==
Message-ID: <a45f108c-f897-40b7-a996-9e55150c09c8@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 25 Jul 2026 12:45:08 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/15] vhost-user: isolated memory
To: ConKite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Haixu Cui <quic_haixcui@quicinc.com>,
        Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
        virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        zhenwei pi <zhenwei.pi@linux.dev>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/07/24 7:29, ConKite wrote:
> This patch series implements a memory isolation mode in vhost-user. The
> purpose of this mode is to provide the option of additional security by
> eliminating direct access of guest memory by vhost-user devices.
> At a high level this works by:
> 
> 1. Adding qdev and qapi properties required to enable isolation mode for
>     various devices.
> 2. Allocating an isolation memory region in an anonymous file and mapping it
>     to host memory.  This isolation region will hold the bounce buffers and
>     vrings necessary to move data.
> 3. Using a vhost-iova-tree to allocate and track the mapping between
>     guest regions and their corresponding bounce buffers in the isolation
>     memory.
> 4. Creating shadow virtqueues to intercept request notifications.  As
>     kick and call events are received by an svq, it copies buffer
>     contents and descriptors between isolation and guest memory before
>     notifying the backend or guest.
> 
> Note: This project is currently in a partially functional state. For
> example, in testing vhost-user-input and a keyboard, keystrokes may
> register correctly or be double counted depending on the combination
> of backend daemon and guest OS used. However, the desire is to make
> this work public at this stage for comment on the overall
> approach.

I guess this intends to achieve something similar to IOMMU and also 
Linux's swiotlb for the VMM (please correct me if I'm wrong):

 > Other edge case scenarios arise for bounce buffers. For example, when
 > IOMMU mappings are set up for a DMA operation to/from a device that is
 > considered “untrusted”, the device should be given access only to the
 > memory containing the data being transferred. But if that memory
 > occupies only part of an IOMMU granule, other parts of the granule may
 > contain unrelated kernel data. Since IOMMU access control is
 > per-granule, the untrusted device can gain access to the unrelated
 > kernel data. This problem is solved by bounce buffering the DMA
 > operation and ensuring that unused portions of the bounce buffers do
 > not contain any unrelated kernel data.

https://docs.kernel.org/next/core-api/swiotlb.html#usage-scenarios

It would be nice if the security property this feature provides is 
explicitly stated, ideally as documentation.

I also hope this could fix vhost-user for TCG:
https://gitlab.com/qemu-project/qemu/-/work_items/2092

Perhaps the memory isolation should be enabled by default for TCG.

Implementation-wise, there are rough edges as you stated. Some of them 
can be fixed by more closely following what vhost-user does for the 
non-isolated case and what vhost-vdpa does with shadow virtqueues.

Regards,
Akihiko Odaki

> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
> ConKite (2):
>        vhost-user: Consolidate chardev property definitions
>        vhost-user: Add memory-isolation qdev property to vhost-user devices
> 
> Connor Kite (13):
>        backends/cryptodev-vhost-user: add memory isolation bool
>        net/vhost-user: add memory isolation
>        vhost-user: add memory_isolation to VhostUserState
>        util/iova-tree: g_tree_foreach wrapper
>        hw/virtio: iova_tree_foreach wrapper
>        hw/virtio/vhost-shadow-virtqueue: used handler
>        hw/virtio/vhost-shadow-virtqueue: specified vring placement
>        hw/virtio/vhost-shadow-virtqueue: range boundary in translation
>        hw/virtio/vhost-user: create isolation region
>        hw/virtio/vhost-user: send isolation regions to device
>        hw/virtio/vhost-user: add shadow virtqueues and eventfd intercepts
>        hw/virtio/vhost-user: handle data movement with shadow vqs
>        hw/virtio/vhost-user: shadow vq cleanup
> 
>   backends/cryptodev-vhost-user.c      |  24 +-
>   backends/vhost-user.c                |   4 +-
>   hw/block/vhost-user-blk.c            |   4 +-
>   hw/display/vhost-user-gpu.c          |   4 +-
>   hw/scsi/vhost-user-scsi.c            |   4 +-
>   hw/virtio/vhost-iova-tree.c          |  15 ++
>   hw/virtio/vhost-iova-tree.h          |   3 +
>   hw/virtio/vhost-shadow-virtqueue.c   |  30 ++-
>   hw/virtio/vhost-shadow-virtqueue.h   |  17 ++
>   hw/virtio/vhost-stub.c               |   3 +-
>   hw/virtio/vhost-user-base.c          |  13 +-
>   hw/virtio/vhost-user-fs.c            |   4 +-
>   hw/virtio/vhost-user-gpio.c          |   4 -
>   hw/virtio/vhost-user-i2c.c           |   5 -
>   hw/virtio/vhost-user-input.c         |   5 -
>   hw/virtio/vhost-user-rng.c           |   5 -
>   hw/virtio/vhost-user-rtc.c           |   4 -
>   hw/virtio/vhost-user-scmi.c          |   4 +-
>   hw/virtio/vhost-user-snd.c           |   1 -
>   hw/virtio/vhost-user-spi.c           |   5 -
>   hw/virtio/vhost-user-test-device.c   |   1 -
>   hw/virtio/vhost-user-vsock.c         |   4 +-
>   hw/virtio/vhost-user.c               | 441 ++++++++++++++++++++++++++++++++++-
>   include/hw/virtio/vhost-user-base.h  |   1 +
>   include/hw/virtio/vhost-user-blk.h   |   1 +
>   include/hw/virtio/vhost-user-fs.h    |   1 +
>   include/hw/virtio/vhost-user-scmi.h  |   1 +
>   include/hw/virtio/vhost-user-vsock.h |   1 +
>   include/hw/virtio/vhost-user.h       |   6 +-
>   include/hw/virtio/virtio-gpu.h       |   1 +
>   include/hw/virtio/virtio-scsi.h      |   1 +
>   include/qemu/iova-tree.h             |  13 ++
>   include/system/vhost-user-backend.h  |   3 +-
>   net/passt.c                          |  16 +-
>   net/vhost-user.c                     |  11 +-
>   qapi/net.json                        |  15 +-
>   qapi/qom.json                        |   6 +-
>   util/iova-tree.c                     |   5 +
>   38 files changed, 622 insertions(+), 64 deletions(-)
> ---
> base-commit: 006a22cb26998998385b104db1ff9466ef2f3153
> change-id: 20260604-vhost-user-isolated-memory-070ed4833ee7
> 
> Best regards,

