Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B65235C01
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 11:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894029; cv=none; b=hu5IFSZKEb5tjSbEzq97yXi6/PJJ/pl3cBMkbsxOoTwEs0tWrccF7GLS/8wVvSyk7onEaMa2Hpg3uKIrmfaPwFQQsjw5UnHZ1ZZPWIVN46gSkU8DAoxaJf02WRd2+ebkx7/GutcIOpfqBH/9/FMVf+Wmj41G4iU/34/6LuJtLGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894029; c=relaxed/simple;
	bh=3QpZXVBSMvw/iMqAn8vlqGIWaH+LvZVBcOK36Cmioo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THLce91qYp/0l5ORmt64Q47Gp5EMl6pfF2pC+kXX5+yzri5gnFeb6NSc9EgCPDix5cnn1q831Tsko3jPLXiNucEjI1kHWtT+pCfrtUjh/2+WRc4SNqm1KOZcBHMKZvSD+rpJh5SUiqj5Bs6vNT9jTCUZxm6p+iKwx9BWZi0gFwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=dEhz3hss; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="dEhz3hss"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OB3U4s040555
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 20:03:31 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=qLU2KSqJIucGWy6R1BKszd6fG4GJ6pt7ZxP2jfqFayY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784891011; v=1;
        b=dEhz3hssIYAoGsGHV5gdq3+vll/8xBOK/dJbtCzHwAcGRaBjRk+5is+YKp029Eh9
         kv1V8dqBL/2Z0jPCSuFppiVU/OfeS89MMNV1lkZP2J9RwFvyFFUDlpr7vNlt5LOd
         vXCXs7ZaZJkYlviIzoM7c4W/y408ea0jwdAZcpEsBuzfFwXX3lgYH8dWO4Wx3gWy
         xPvkcZ+zQXmQVOIIT6iDi7Tx11XsogOHh85HPb+88jLqkirUaqRjqq9FwnxbxGUF
         YFu4Mu2yNBe8zCmR4X9ABiqlPXTs7Je408i/A4/FAiXB6ChcQYG3y9oTlYGlaUja
         FuJdd6B1N4HqwIwwoFZcrw==
Message-ID: <756d0ddf-fb40-4562-877f-c607ddeb4f5f@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 20:03:30 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 03/15] backends/cryptodev-vhost-user: add memory
 isolation bool
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
 <20260723-vhost-user-isolated-memory-v1-3-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-3-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Add a memory_isolation property to CryptoDevBackendVhostUser and
> add add it as an optional member of CryptodevVhostUserProperties
> in qapi.
> 
> This is needed to be able to specify memory isolation for
> cryptodev-vhost-user objects, and the bool will eventually be
> passed to vhost_user_init() in a future patch.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   backends/cryptodev-vhost-user.c | 22 ++++++++++++++++++++++
>   qapi/qom.json                   |  6 +++++-
>   2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
> index cc478d9902..e0547c5d40 100644
> --- a/backends/cryptodev-vhost-user.c
> +++ b/backends/cryptodev-vhost-user.c
> @@ -49,6 +49,7 @@ struct CryptoDevBackendVhostUser {
>       CharFrontend chr;
>       char *chr_name;
>       bool opened;
> +    bool memory_isolation;
>       CryptoDevBackendVhost *vhost_crypto[MAX_CRYPTO_QUEUE_NUM];
>   };
>   
> @@ -392,6 +393,23 @@ static void cryptodev_vhost_user_finalize(Object *obj)
>       g_free(s->chr_name);
>   }
>   
> +static void cryptodev_vhost_user_set_mem_isolation(Object *obj, bool value,
> +                                                   Error **errp)
> +{
> +    CryptoDevBackendVhostUser *s =
> +                      CRYPTODEV_BACKEND_VHOST_USER(obj);
> +
> +    s->memory_isolation = value;

This setter should forbid setting once initialization finishes as done 
in cryptodev_vhost_user_set_chardev() since the value is copied into 
VhostUserState during initialization and setting this afterwards is 
ineffective.

Regards,
Akihiko Odaki

> +}
> +
> +static bool cryptodev_vhost_user_get_mem_isolation(Object *obj, Error **errp)
> +{
> +    CryptoDevBackendVhostUser *s =
> +                      CRYPTODEV_BACKEND_VHOST_USER(obj);
> +
> +    return s->memory_isolation;
> +}
> +
>   static void
>   cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
>   {
> @@ -407,6 +425,10 @@ cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
>                                     cryptodev_vhost_user_get_chardev,
>                                     cryptodev_vhost_user_set_chardev);
>   
> +    object_class_property_add_bool(oc, "memory-isolation",
> +                                   cryptodev_vhost_user_get_mem_isolation,
> +                                   cryptodev_vhost_user_set_mem_isolation);
> +
>   }
>   
>   static const TypeInfo cryptodev_vhost_user_info = {
> diff --git a/qapi/qom.json b/qapi/qom.json
> index c55776af7d..d7ca1b4203 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -350,11 +350,15 @@
>   # @chardev: the name of a Unix domain socket character device that
>   #     connects to the vhost-user server
>   #
> +# @memory-isolation: disables access from cryptodev to guest memory.
> +#     (default: false)
> +#
>   # Since: 2.12
>   ##
>   { 'struct': 'CryptodevVhostUserProperties',
>     'base': 'CryptodevBackendProperties',
> -  'data': { 'chardev': 'str' },
> +  'data': { 'chardev': 'str',
> +            '*memory-isolation': 'bool' },
>     'if': 'CONFIG_VHOST_CRYPTO' }
>   
>   ##
> 

