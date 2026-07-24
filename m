Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989D149C6F
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906587; cv=none; b=Z7LDRKcRBmIfVn3yrzGmXEwnrAZTYnuuAPy1qw4cZHHP+wDQqz4AwDOy24ga90LXcU5lSIXH+xMaGIEv+8Wmj/EjKj8IWSR8fXdHHF6YeEvE4bJxWUJ4ExTJlGtXgNaKbFf4WDI1v0e1qfa0OqnENZ0EJFI1j1qqtb4uK563M8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906587; c=relaxed/simple;
	bh=E5qVWikILRxEWwVnOV0gQuFXHrvcbfrePb8DNfGizxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VCXSXJ0gBzD9/kN2x/2xrWi1lU3/G34kmRy2yepUqr4Al8tAlkurK+Wm5jqVufD72aUJg5Isl5XlmbQYNLGRhqIIFePRVmVYXlA9e00M6Sp+zqLuSsH7hT4Ktj5pfWm1sguvlnH0BlxjMjOjgBbWHHJqWKyQhnmmpKMcSAl12qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=EJAFR0+a; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="EJAFR0+a"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OFMNiB025117
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 25 Jul 2026 00:22:24 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=JE6nwoBnuIB4oWlTX9bpmIpvGlRAzyit7mewtK4+Yec=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784906544; v=1;
        b=EJAFR0+aq9Ea/nijyPcpfRPwe004E2nIzesoXnWABFNG5k6Dq8zJcwN5w5V5ST08
         SygPzj44ygxomvCfUlc6aoE9XfIOIi2IjG00ozU1eW/tIUzFN0Shxc+PdNKkleed
         rB4RdTwPxQoweM5U36yfZ5NY4bCoFoHzyJT6mKrjkNx3FmTGxD4+KRHrtjHaN2DZ
         mGD6k+wqnXOjX/4kNbNjM89oJDC47rCubuf1s8IVQ8p7kPXIR4ZOVXyErWSJAp+m
         dt8Wc9QhRo1bA81YwujAs2VxBEuAEggRP0EW6RUS9HOWyLK5lG0bGKxPSMxEkOb0
         2LSELc8rrGM0G8A+6X27vg==
Message-ID: <1257210f-15f9-47ab-b5e9-05a3ee4ef8ba@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 25 Jul 2026 00:22:23 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 15/15] hw/virtio/vhost-user: shadow vq cleanup
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
 <20260723-vhost-user-isolated-memory-v1-15-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-15-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Implements functionality to cleanup svqs on cleanup of isolation
> regions.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index e65f877f9a..bb4de78b95 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1140,6 +1140,15 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static void vhost_user_svq_cleanup(struct vhost_user *u)
> +{
> +    for (int i = 0; i < u->shadow_vqs->len; i++) {
> +        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
> +    }
> +
> +    g_ptr_array_free(u->shadow_vqs, true);
> +}
> +
>   /* TODO: Is there any notifier cleanup required here?*/
>   static void cleanup_isolation_regions(struct vhost_dev *dev)
>   {
> @@ -1147,6 +1156,7 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
>       if (u->iso_memory.base_addr) {
>           vhost_iova_tree_delete(u->iso_iova_tree);
>           u->iso_iova_tree = NULL;
> +        vhost_user_svq_cleanup(u);

Memory-table refresh frees live SVQs permanently. 
init_isolation_regions() uses cleanup for refreshes, but cleanup frees 
shadow_vqs; they are created only once during backend initialization.

Regards,
Akihiko Odaki

>           memset(&u->iso_memory, 0, sizeof(IsolationRegion));
>           qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memory.size,
>                            u->iso_memory.iso_fd);
> 

