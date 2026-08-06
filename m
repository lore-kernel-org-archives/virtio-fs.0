Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE3282F21
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786031868; cv=none; b=EsgBoqN9dZztHxQltxUnAgZIsvWRPUnGqMJHWo7NGXulExJIFfaCpsv7+T5mDLaCJclxpN577KAALH6l0B9HEUdo31JJmq8xXJo2vWlOFHF0yD+lp8RW0q47zMojqg25MyUt/fwa9nAYp2Cvy3F18dz7KXcJd/9rtVd6gPB1SWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786031868; c=relaxed/simple;
	bh=e46D4BwkVxgDTRASZnQfMaTyVkbE4vNxUOhNUd+aY34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEpulC2NhfWq9AATI3UIfxtg9Rrjqd/TpsPeb4YZkGvdLGb4bGiQFA9wTr5xprKuo5xUcR2A+H+ENP5t0LTcUqnXmPWOhENYBqQsUToj2pzRP6/RxiJaU8aCoKmzh3aczog2guG2oxByr69MlOfuVJRvyAAOOH6dkITstJtn1q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=DhXJvv9+; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="DhXJvv9+"
Received: from [192.168.10.145] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 676FusjA003499
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 7 Aug 2026 00:56:54 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=jKtWHgb9iw0wJzY2NL5PuVmLGrV+j2bXleDjb2S8IiE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1786031815; v=1;
        b=DhXJvv9+/WKLV9yGm5mF7kmSAF0piMqTk+mti/UD0EtjIuIVqJgDTIlVYkCRO+1v
         UppWYa71TpyB5zKL4r54ESaXg6ObbQM60kbr2RfAU4ZpD9ey0wg+m3RMQFXBaibJ
         C2yqKdStL+W5UzgAax9ilw1mokGs0bMb2LBP1gBeY0pE+DKGZiwCKEtxm65jvRp5
         KrxkKL/DPDUla6YL/Aq5XN3xCMh4RY+k5T7O5LsCeqaL7+aRP6C6A2bH/oDEAjlk
         g6V/qHBvHImTudQWdXQHeZdXV4fihhh4HetF7SWwt4q9CEhNUgFI77N1niirxykR
         wHm841BieO42k+CdaQ+acw==
Message-ID: <64e6116e-5729-490d-b945-b11310dec709@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 7 Aug 2026 00:56:54 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
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
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
 <f9125d0a-3258-46f4-93f6-0761a4acdc66@rsg.ci.i.u-tokyo.ac.jp>
 <CA+spn3pLJvQCyfUvK4WvjvfJnGYBKr-i302HvBeVm9Y3t6sR8Q@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <CA+spn3pLJvQCyfUvK4WvjvfJnGYBKr-i302HvBeVm9Y3t6sR8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/08/07 0:29, Connor Kite wrote:
> On Fri, Jul 24, 2026 at 5:19 AM Akihiko Odaki
> <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
> ...
>>
>> Nit: please remove the whitespace between (void *) and svq->base_addr.
>>
> 
> Removing the whitespace!
> 
>>> +        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
>>> +        svq->vring.used = (void *)((char *)svq->base_addr +
>>> +                          vhost_svq_driver_area_size(svq));
>>> +    }
>>
>> Unmapping svq here can lead to use-after-unmapping because the ring is
>> not stopped yet. do_vhost_dev_stop() calls do_vhost_virtqueue_stop()
>> only after calling hdev->vhost_ops->vhost_dev_start(hdev, false).
>>
> 
> I am afraid I don't quite understand, as this patch does not introduce
> any unmapping.
> Was this comment meant for a different patch?

Yes, sorry, this comment was meant for "[PATCH RFC 14/15] 
hw/virtio/vhost-user: handle data movement with shadow vqs".

vhost_user_dev_start(dev, false) calls vhost_user_svqs_stop(), which 
calls vhost_svq_stop() and unmaps the shadow vring. However, 
do_vhost_dev_stop() calls do_vhost_virtqueue_stop() only after the 
callback returns. The backend vring therefore remains active until 
VHOST_USER_GET_VRING_BASE, so it may still access the unmapped memory.

Regards,
Akihiko Odaki
