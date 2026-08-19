Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDAB3E009B
	for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 07:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125079; cv=none; b=MX28YJYMPYxE7o+M8V+u8OOr/SILl7bVY0srmG7CjqAaJLK6Yv/zym2Czrm9fkGwyXhgMIrGJz3f+teSMUq2SuB9xXFydwBHv99iJkfRkDiKKpkC2QnhHEtHYMvz4kPLXq8MuPlB5SMsC9C8v4RaC28t+LNrXq+U2whTA/hEOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125079; c=relaxed/simple;
	bh=IRzIswu57hbTHiVqbujfkkVs2zZfmKTR13LrOjdBhDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQGfcPeBlJiwsbpY+T7iYFwWG+fY75/tkch+BRDIz5SCoSDpFJT9FiXLuS7CUyTYPUgjiHHR7amONs4YPquIzSWYiNRO/d1iUaUaXA+3QMEEsuQxGAi2YEEtdI2VRdBiHZWcgZGaBlmZh7Rysm5o30VAMUiuHmAL854LX5EFO6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=T3B5R5Zq; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="T3B5R5Zq"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67J7bQaT038534
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 19 Aug 2026 16:37:26 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=40/SmnpS+414qCoeOzC/7o/OH5OFlR/RHKU1VqwYRf4=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787125047; v=1;
        b=T3B5R5ZqQUJ1TEvEA0ze3E+13+8Ad5xvt9C6mORoWPsFow36N/DBLDT44kfNuqjv
         bsSWDJMYhBUrEiPsr4iTEOPmvNtdx07VhxwrZBehtk0GwbMi9mb/HNFnSFvZQLV5
         3XCmu+rAD1kD320MdIjSDa8Q6NI1WC2WwesFlaxmZ7w8mcQ9CxMWuArDdQOh0rbv
         qwq4pY3A9p5KIzO2bs+dnymwH7zuCnhM53XTEjGp3dg0tTNqpkFcSEUwkdBuIa9F
         DcbHKTXHhQYS5kZ6InbdmsnYC/wQ3+zRKN9cQQ94Xhdu/EFnvr3cTMMGfKZihO6s
         9yy1gtNKKSq4F6YDl8ckvQ==
Message-ID: <15427c56-a585-48ff-b024-e48a2fdea697@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 19 Aug 2026 16:37:26 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
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
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>,
        20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/08/18 14:12, Connor Kite wrote:
> Add a memory-isolation property to NetdevPassOptions and
> NetDevVhostUserOptions in net.json.  This property will
> be used for vhost-user devices to disable access to guest
> memory from vhost-user backends.

The cover letter says multiqueue is not supported but the code just 
continues with multiqueue and breaks.

Regards,
Akihiko Odaki

> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   net/passt.c      |  5 +++++
>   net/vhost-user.c |  3 +++
>   qapi/net.json    | 16 ++++++++++++----
>   3 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/net/passt.c b/net/passt.c
> index 35ec6ad6de..7bcd47ad32 100644
> --- a/net/passt.c
> +++ b/net/passt.c
> @@ -741,6 +741,11 @@ int net_init_passt(const Netdev *netdev, const char *name,
>       if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
>           bool memory_isolation = false;
>   
> +        if (netdev->u.passt.has_memory_isolation &&
> +            netdev->u.passt.memory_isolation) {
> +            memory_isolation = true;
> +        }
> +
>           if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
>               qemu_del_net_client(nc);
>               return -1;
> diff --git a/net/vhost-user.c b/net/vhost-user.c
> index b6ee9ed297..bd33decadf 100644
> --- a/net/vhost-user.c
> +++ b/net/vhost-user.c
> @@ -477,6 +477,9 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
>           return -1;
>       }
>   
> +    memory_isolation = vhost_user_opts->has_memory_isolation ?
> +                       vhost_user_opts->memory_isolation : false;
> +
>       return net_vhost_user_init(peer, "vhost_user", name, chr, queues,
>                                  memory_isolation);
>   }
> diff --git a/qapi/net.json b/qapi/net.json
> index 1a6382825c..add7cb5408 100644
> --- a/qapi/net.json
> +++ b/qapi/net.json
> @@ -213,6 +213,9 @@
>   #
>   # @param: parameter to pass to passt command
>   #
> +# @memory-isolation: isolate guest memory from vhost-user back-end
> +#     (default: false) (Since 11.2)
> +#
>   # Since: 10.1
>   ##
>   { 'struct': 'NetdevPasstOptions',
> @@ -250,7 +253,8 @@
>       '*ipv6':               'bool',
>       '*tcp-ports':          ['PasstPortForward'],
>       '*udp-ports':          ['PasstPortForward'],
> -    '*param':              ['PasstParameter'] },
> +    '*param':              ['PasstParameter'],
> +    '*memory-isolation':   'bool'},
>       'if': 'CONFIG_PASST' }
>   
>   ##
> @@ -685,13 +689,17 @@
>   # @queues: number of queues to be created for multiqueue vhost-user
>   #     (default: 1) (Since 2.5)
>   #
> +# @memory-isolation: isolate guest memory from vhost-user back-end
> +#     (default: false) (Since 11.2)
> +#
>   # Since: 2.1
>   ##
>   { 'struct': 'NetdevVhostUserOptions',
>     'data': {
> -    'chardev':        'str',
> -    '*vhostforce':    'bool',
> -    '*queues':        'int' } }
> +    'chardev':              'str',
> +    '*vhostforce':          'bool',
> +    '*queues':              'int',
> +    '*memory-isolation':    'bool' } }
>   
>   ##
>   # @NetdevVhostVDPAOptions:
> 

