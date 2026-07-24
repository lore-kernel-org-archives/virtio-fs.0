Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2D227FB1F
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 12:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896315; cv=none; b=r1AI2QdyCFGNO8rnDEKEYkjBG/cdLK9U/rniISmSIjjtOZ9SoZpiOupP0ItQNtOJ6PryCKbYvzn4OmcO/zFrSU786z0mB0c/uEqHRg2j0mHq1Nh5DifDSz44CCkec288jh/UXAfhMHcozvN6ODhf/biXa7G5QjkeVPVvf88YKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896315; c=relaxed/simple;
	bh=A5RGVVsvZ3sJtOY0+F9BD8+4sOrLzWA/+FSNVirnk2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKgW+1LF84Djy0QF0To9rqSmq/j03ZCCSBKnD5NFBZkjJUinFBmTtrAKYk9k5wSLy5V9HENGK00T1Zt5/jU7NWpA3+t2rkmbRR7P1l/IwCIdp74qmJPaEFVYlH6ULANKgXfhrCXwWSTJeXVt//MArQOxpWvGSpeJnpKU60Xxib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=J+pSdIuZ; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="J+pSdIuZ"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OCVJE2072314
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 21:31:20 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=eH7TayLpe7he7hVkx6BzQNlGA6oPajPQamzf56Qx8eE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784896280; v=1;
        b=J+pSdIuZj6p2hWpzEih21O3uxsaQXryDZtLE8vLs1jjHt6RzT9Wm7jo6O0Bj8EiU
         hMGzSDV+/mXOC2ra1Kds42u1GdJVkWfEZIo55BwaMWMKsoqs6+r2G48rMqO/lH9z
         8hvUDLDDHC+x8hr1HeusVk6o2bp5l1jojFyfXfNQe3yWmQ7HW7iG9F3rFAcNW74G
         erw9+q+G3VT8nzNwRqHiOMf8MLdoeDQLvminSW0KJ/v7ASBq62Xno6gKWUlbj0gs
         oanzBjjXzkkycX6o0n3t+VQdcoQEEcI/p58uvH8alxU4PDlNRvp+IkCikxDVIyMR
         iZzAimaHis2VPzAT9J514Q==
Message-ID: <2af0a465-2f27-4e0f-b1dd-16bb8d3c5538@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 21:31:19 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range
 boundary in translation
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
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
 <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> iova-tree expects inclusive range sizing when maps are allocated or searched.
> Currently, svqs use exclusive sizing when searching their
> vhost-iova-tree for a match to the region to be translated.  This could
> lead to errors if the region to be translated is at the edge of an iova
> region.
> 
> Fix this by reducing `needle.size` by 1 in
> vhost_svq_translate_addr to bring then it line with DMAMap and iova-tree
> convention.

I think this patch is better to be extracted from this series since this 
series is complex and this patch is worth being landed earlier. You can 
chain this series to the patch with the Based-on: described in:
docs/devel/submitting-a-patch.rst

Regards,
Akihiko Odaki

> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index 9e3c359f50..20e5c7d2f1 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -104,14 +104,14 @@ static bool vhost_svq_translate_addr(const VhostShadowVirtqueue *svq,
>               /* Search the GPA->IOVA tree */
>               needle = (DMAMap) {
>                   .translated_addr = gpas[i],
> -                .size = iovec[i].iov_len,
> +                .size = iovec[i].iov_len - 1,  /* Inclusive */
>               };
>               map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>           } else {
>               /* Search the IOVA->HVA tree */
>               needle = (DMAMap) {
>                   .translated_addr = (hwaddr)(uintptr_t)iovec[i].iov_base,
> -                .size = iovec[i].iov_len,
> +                .size = iovec[i].iov_len - 1, /* Inclusive */
>               };
>               map = vhost_iova_tree_find_iova(svq->iova_tree, &needle);
>           }
> 

