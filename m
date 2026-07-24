Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6354302F9
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891733; cv=none; b=tEyFNKqKuZ0TJUDxfhACLBAypgwsZbrzGKAJoxnMnpRQU61Hj1sl/jJ59C3IHBYmXNAd2rMV7Kdtz/SfsxQYPt9XNSOuSfuLgGrxRgVAHv1ltlancyMRioaNzCyiS0cjBSJr2h09u9kur7iQxlAq6IJPIVf/1ewdXsTLckINOm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891733; c=relaxed/simple;
	bh=Iu8AQPVlJ8O+zpjo6h7ezh5gw+xr57dEaSH/+jZOaM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXnxRsdSCQnantqOcDe9BEmh9kjD+7j3+zkEeG9sh0DCNQl2teFp48saiOfXBB0K6EEwbMFC1LzHaBXUL1nloQpxDYYXc74UmCwEXpWXgI0j+WWBjqSkstYf0hiDH3t7zYxznDkL7Rm64kS0mO1XLsZ12n9Pln3uhffpBDcoP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Sn1Q8YCw; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Sn1Q8YCw"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OBEt94044334
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 20:14:56 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KF7jAh58YAT+ugK1sZmUw32vul1k7rZHc0tImkF7xo8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784891696; v=1;
        b=Sn1Q8YCw4hpIZxXLT+yjwsaiN0e4rhJMb+dwa+UL39cbtzVItwSIupjoAd5ad5KC
         8PYf/Qqu7ld74TzqZajkKG57Gtl4XbNyIh0fHrofOFsHceoS0e4fGuxozGQXKPPS
         TZYgJTjO7gYl+YHTOCIW6Jy+JiyYdJdZ/cLvZ5iF211hr39mBB8BDJp6Z/87xO65
         Csq5niRVssBJpgN2fVG0eehtgdVHejEj6O9rEXR1k3HrXeQngULhn+A7/F0/GBoK
         tdrCRJV3x9KLYK7nlZfSTXi1GgVytC/wYN518FEEI2AS8yhmOojKUNFIxTadFNNx
         OPshFJSvvI6AFfpbtzYrmA==
Message-ID: <8f37b789-fd3f-43ef-b15e-ffd44381306b@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 20:14:55 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 07/15] hw/virtio: iova_tree_foreach wrapper
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
 <20260723-vhost-user-isolated-memory-v1-7-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-7-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Add a wrapper to vhost-iova-tree that calls iova_tree_foreach on the
> underlying iova_map.  This provides a means to execute some function on
> each node of the tree.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-iova-tree.c | 15 +++++++++++++++
>   hw/virtio/vhost-iova-tree.h |  3 +++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/hw/virtio/vhost-iova-tree.c b/hw/virtio/vhost-iova-tree.c
> index fa4147b773..d8206379bf 100644
> --- a/hw/virtio/vhost-iova-tree.c
> +++ b/hw/virtio/vhost-iova-tree.c
> @@ -189,3 +189,18 @@ void vhost_iova_tree_remove_gpa(VhostIOVATree *iova_tree, DMAMap map)
>       iova_tree_remove(iova_tree->gpa_iova_map, map);
>       iova_tree_remove(iova_tree->iova_map, map);
>   }
> +
> +
> +/**
> + * Traverse through the iova tree in sorted order
> + *
> + * @tree: The VhostIOVATree
> + * @func: Function called at every node.  A false return value ends traversal

GTraverseFunc stops traversal on true, but this says false ends traversal.

> + * @data: An argument passed to func
> + */
> +void vhost_iova_tree_foreach(VhostIOVATree *tree,
> +                             GTraverseFunc func,
> +                             gpointer data)
> +{
> +    iova_tree_foreach(tree->iova_map, func, data);
> +}
> diff --git a/hw/virtio/vhost-iova-tree.h b/hw/virtio/vhost-iova-tree.h
> index 08f63b61cd..f3b7c48cb9 100644
> --- a/hw/virtio/vhost-iova-tree.h
> +++ b/hw/virtio/vhost-iova-tree.h
> @@ -29,5 +29,8 @@ const DMAMap *vhost_iova_tree_find_gpa(const VhostIOVATree *iova_tree,
>   int vhost_iova_tree_map_alloc_gpa(VhostIOVATree *iova_tree, DMAMap *map,
>                                     hwaddr taddr);
>   void vhost_iova_tree_remove_gpa(VhostIOVATree *iova_tree, DMAMap map);
> +void vhost_iova_tree_foreach(VhostIOVATree *tree, GTraverseFunc func,
> +                               gpointer data);
> +

Here is an extra blank line.

Regards,
Akihiko Odaki

>   
>   #endif
> 

