Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721254071DC
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894191; cv=none; b=V78as4G4B77tLma9Jln8gCLFXEpI7Af6SmghfB1jgHqHn/xYkb5+0sF0E4pzdjFMC8lDuq3qSOOM3v2Wv5aiT1d/Uhkg3iv/DP+yBnh2Kgcx0S9cn9HmmN2K3ohIzBw3UWv4JJJVX/oyC1h4nCsTMln4Y0WZCdHKNDSDXVoRFCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894191; c=relaxed/simple;
	bh=jcK3Fm8zOCEyou7W4xEOQIFpv4RS/3UbRBtdPyk1oxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXJhDzz6Ld+V07+FnmmxM8hr33CdYaMvc+0YAIqZnkX1ad9q385HGq1tNlg+JpZ4pA0W405P2Nv480RDKTS4jaHW3pmP90gx91DDKz2nDC+4CIJ0xcyeH8sISR5r77jwgdKejfUKommJ/tBPhS7v6SxRS8uQsra3/43RPUKjbmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=tL9we7yE; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="tL9we7yE"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OB9mrC042883
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 20:09:48 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=PI5DDhmLisvuYrAqVZ9uZGR2X7hbfbmXyxZVMt6F7r0=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784891389; v=1;
        b=tL9we7yEOTnSAuPQUie5Qexpy6Nb93O7udJdhHq2Rql7Bahqq4F5ZGGt0I9QSod4
         4Pz0gQaAAjmgo0u3as53Yz9PNd9ctRymfeRj+cXJ7QKXgWiZM+hPKPuWLOXk2Bsx
         LajR+umfDQdJp+c5SRhXLFFElZbd/yIDNeTA2a5u3heCmyNU52ju/a48HgC3Wy0z
         ccv7aBmwhJplMy6Y6S61Werb+29YxeRxmOjfZfWFRWCgoIw3H7L5YS0CcZdp6WPZ
         GWo3dYwrnD0n+jiX4LRWkzgZxI9M/3kqmOi3ucJYX9fQNJQShLgpwgzmLrsT5GBh
         iEOCJ267be1rhrIQASFntQ==
Message-ID: <d197fc64-057e-42b3-9387-bee6c15e9e2d@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 20:09:48 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/15] vhost-user: add memory_isolation to
 VhostUserState
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
 <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Add a memory_isolation bool to the VhostUserState struct. This
> bool is set within vhost_user_init(), which takes a
> memory_isolation bool as an argument.
> 
> Refactor all call locations of vhost_user_init to include the new
> argument.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   backends/cryptodev-vhost-user.c     |  2 +-
>   backends/vhost-user.c               |  4 ++--
>   hw/block/vhost-user-blk.c           |  3 ++-
>   hw/display/vhost-user-gpu.c         |  3 ++-
>   hw/scsi/vhost-user-scsi.c           |  3 ++-
>   hw/virtio/vhost-stub.c              |  3 ++-
>   hw/virtio/vhost-user-base.c         |  3 ++-
>   hw/virtio/vhost-user-fs.c           |  3 ++-
>   hw/virtio/vhost-user-scmi.c         |  3 ++-
>   hw/virtio/vhost-user-vsock.c        |  3 ++-
>   hw/virtio/vhost-user.c              |  5 ++++-
>   include/hw/virtio/vhost-user.h      |  6 +++++-
>   include/system/vhost-user-backend.h |  3 ++-
>   net/passt.c                         | 13 ++++++++-----
>   net/vhost-user.c                    |  9 +++++----
>   15 files changed, 43 insertions(+), 23 deletions(-)
> 
> diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
> index e0547c5d40..328d7fbdfe 100644
> --- a/backends/cryptodev-vhost-user.c
> +++ b/backends/cryptodev-vhost-user.c
> @@ -214,7 +214,7 @@ static void cryptodev_vhost_user_init(
>           }
>       }
>   
> -    if (!vhost_user_init(&s->vhost_user, &s->chr, errp)) {
> +    if (!vhost_user_init(&s->vhost_user, &s->chr, s->memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/backends/vhost-user.c b/backends/vhost-user.c
> index 380d825023..470eba1775 100644
> --- a/backends/vhost-user.c
> +++ b/backends/vhost-user.c
> @@ -22,13 +22,13 @@
>   
>   int
>   vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
> -                            unsigned nvqs, Error **errp)
> +                            unsigned nvqs, bool memory_isolation, Error **errp)
>   {
>       int ret;
>   
>       assert(!b->vdev && vdev);
>   
> -    if (!vhost_user_init(&b->vhost_user, &b->chr, errp)) {
> +    if (!vhost_user_init(&b->vhost_user, &b->chr, memory_isolation, errp)) {
>           return -1;
>       }
>   
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 9830dc6c35..5c1a19eb50 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -505,7 +505,8 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> -    if (!vhost_user_init(&s->vhost_user, &s->chardev, errp)) {
> +    if (!vhost_user_init(&s->vhost_user, &s->chardev,
> +                         s->memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
> index 6d0ede672a..b44c989f58 100644
> --- a/hw/display/vhost-user-gpu.c
> +++ b/hw/display/vhost-user-gpu.c
> @@ -625,7 +625,8 @@ vhost_user_gpu_device_realize(DeviceState *qdev, Error **errp)
>       VirtIODevice *vdev = VIRTIO_DEVICE(g);
>   
>       vhost_dev_set_config_notifier(&g->vhost->dev, &config_ops);
> -    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, errp) < 0) {
> +    if (vhost_user_backend_dev_init(g->vhost, vdev, 2, g->memory_isolation,
> +                                    errp) < 0) {
>           return;
>       }
>   
> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> index c1a0393220..5a19182f2b 100644
> --- a/hw/scsi/vhost-user-scsi.c
> +++ b/hw/scsi/vhost-user-scsi.c
> @@ -276,7 +276,8 @@ static void vhost_user_scsi_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> -    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev, errp)) {
> +    if (!vhost_user_init(&s->vhost_user, &vs->conf.chardev,
> +                         vs->conf.memory_isolation, errp)) {
>           goto free_virtio;
>       }
>   
> diff --git a/hw/virtio/vhost-stub.c b/hw/virtio/vhost-stub.c
> index 7321dc9210..d1e1075a31 100644
> --- a/hw/virtio/vhost-stub.c
> +++ b/hw/virtio/vhost-stub.c
> @@ -12,7 +12,8 @@ unsigned int vhost_get_free_memslots(void)
>       return UINT_MAX;
>   }
>   
> -bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp)
> +bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
> +                     bool memory_isolation, Error **errp)
>   {
>       return false;
>   }
> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> index d2a74a2860..11864a3f08 100644
> --- a/hw/virtio/vhost-user-base.c
> +++ b/hw/virtio/vhost-user-base.c
> @@ -317,7 +317,8 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
>           vub->vhost_user.supports_config = true;
>       }
>   
> -    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> +    if (!vhost_user_init(&vub->vhost_user, &vub->chardev,
> +                         vub->memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 3d980d814b..07ff2a35e0 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -238,7 +238,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> -    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev, errp)) {
> +    if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev,
> +                         fs->conf.memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index d514d89392..2c1dbb723e 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -244,7 +244,8 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
>   
>       vdev->host_features |= (1ULL << VIRTIO_SCMI_F_P2A_CHANNELS);
>   
> -    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev, errp)) {
> +    if (!vhost_user_init(&scmi->vhost_user, &scmi->chardev,
> +                         scmi->memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
> index 89aa789e22..33ab3b69e6 100644
> --- a/hw/virtio/vhost-user-vsock.c
> +++ b/hw/virtio/vhost-user-vsock.c
> @@ -106,7 +106,8 @@ static void vuv_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> -    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev, errp)) {
> +    if (!vhost_user_init(&vsock->vhost_user, &vsock->conf.chardev,
> +                         vsock->conf.memory_isolation, errp)) {
>           return;
>       }
>   
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 517cc4ca71..f296b63fb9 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -3118,13 +3118,16 @@ static void vhost_user_state_destroy(gpointer data)
>       vhost_user_host_notifier_remove(n, NULL, true);
>   }
>   
> -bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp)
> +bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
> +                     bool memory_isolation,
> +                     Error **errp)
>   {
>       if (user->chr) {
>           error_setg(errp, "Cannot initialize vhost-user state");
>           return false;
>       }
>       user->chr = chr;
> +    user->memory_isolation = memory_isolation;
>       user->memory_slots = 0;
>       user->notifiers = g_ptr_array_new_full(VIRTIO_QUEUE_MAX / 4,
>                                              &vhost_user_state_destroy);
> diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
> index 06c360af18..72b5787efe 100644
> --- a/include/hw/virtio/vhost-user.h
> +++ b/include/hw/virtio/vhost-user.h
> @@ -66,6 +66,7 @@ typedef struct VhostUserHostNotifier {
>    * @chr: the character backend for the socket
>    * @notifiers: GPtrArray of @VhostUserHostnotifier
>    * @memory_slots:
> + * @memory_isolation: determines whether data is shared or copied
>    */
>   typedef struct VhostUserState {
>       CharFrontend *chr;
> @@ -73,12 +74,14 @@ typedef struct VhostUserState {
>       int memory_slots;
>       bool supports_config;
>       bool supports_inflight_migration;
> +    bool memory_isolation;
>   } VhostUserState;
>   
>   /**
>    * vhost_user_init() - initialise shared vhost_user state
>    * @user: allocated area for storing shared state
>    * @chr: the chardev for the vhost socket
> + * @memory_isolation: disables device access to guest memory
>    * @errp: error handle
>    *
>    * User can either directly g_new() space for the state or embed
> @@ -87,7 +90,8 @@ typedef struct VhostUserState {
>    *
>    * Return: true on success, false on error while setting errp.
>    */
> -bool vhost_user_init(VhostUserState *user, CharFrontend *chr, Error **errp);
> +bool vhost_user_init(VhostUserState *user, CharFrontend *chr,
> +                     bool memory_isolation, Error **errp);

The signature of the stub for !defined(CONFIG_VHOST_USER) is not 
updated, breaking builds.

Regards,
Akihiko Odaki

>   
>   /**
>    * vhost_user_cleanup() - cleanup state
> diff --git a/include/system/vhost-user-backend.h b/include/system/vhost-user-backend.h
> index 3184c8e799..c23f689182 100644
> --- a/include/system/vhost-user-backend.h
> +++ b/include/system/vhost-user-backend.h
> @@ -41,7 +41,8 @@ struct VhostUserBackend {
>   };
>   
>   int vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
> -                                unsigned nvqs, Error **errp);
> +                                unsigned nvqs, bool memory_isolation,
> +                                Error **errp);
>   void vhost_user_backend_start(VhostUserBackend *b);
>   int vhost_user_backend_stop(VhostUserBackend *b);
>   
> diff --git a/net/passt.c b/net/passt.c
> index ce80186883..a3021f37ef 100644
> --- a/net/passt.c
> +++ b/net/passt.c
> @@ -433,7 +433,9 @@ static void passt_vhost_user_event(void *opaque, QEMUChrEvent event)
>       }
>   }
>   
> -static int net_passt_vhost_user_init(NetPasstState *s, Error **errp)
> +static int net_passt_vhost_user_init(NetPasstState *s,
> +                                     bool memory_isolation,
> +                                     Error **errp)
>   {
>       Chardev *chr;
>       int sv[2];
> @@ -457,7 +459,8 @@ static int net_passt_vhost_user_init(NetPasstState *s, Error **errp)
>   
>       s->vhost_user = g_new0(struct VhostUserState, 1);
>       if (!qemu_chr_fe_init(&s->vhost_chr, chr, errp) ||
> -        !vhost_user_init(s->vhost_user, &s->vhost_chr, errp)) {
> +        !vhost_user_init(s->vhost_user, &s->vhost_chr, memory_isolation,
> +                         errp)) {
>           goto err;
>       }
>   
> @@ -735,14 +738,14 @@ int net_init_passt(const Netdev *netdev, const char *name,
>       s->pidfile = pidfile;
>   
>       if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
> -        bool memory_isolation G_GNUC_UNUSED = false;
> +        bool memory_isolation = false;
>   
>           if (netdev->u.passt.has_memory_isolation &&
> -           netdev->u.passt.memory_isolation) {
> +            netdev->u.passt.memory_isolation) {
>               memory_isolation = true;
>           }
>   
> -        if (net_passt_vhost_user_init(s, errp) == -1) {
> +        if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
>               qemu_del_net_client(nc);
>               return -1;
>           }
> diff --git a/net/vhost-user.c b/net/vhost-user.c
> index 8fa303f901..722ab20228 100644
> --- a/net/vhost-user.c
> +++ b/net/vhost-user.c
> @@ -370,7 +370,7 @@ static void net_vhost_user_event(void *opaque, QEMUChrEvent event)
>   
>   static int net_vhost_user_init(NetClientState *peer, const char *device,
>                                  const char *name, Chardev *chr,
> -                               int queues)
> +                               int queues, bool memory_isolation)
>   {
>       Error *err = NULL;
>       NetClientState *nc, *nc0 = NULL;
> @@ -390,7 +390,7 @@ static int net_vhost_user_init(NetClientState *peer, const char *device,
>               nc0 = nc;
>               s = DO_UPCAST(NetVhostUserState, nc, nc);
>               if (!qemu_chr_fe_init(&s->chr, chr, &err) ||
> -                !vhost_user_init(user, &s->chr, &err)) {
> +                !vhost_user_init(user, &s->chr, memory_isolation, &err)) {
>                   error_report_err(err);
>                   goto err;
>               }
> @@ -459,7 +459,7 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
>       int queues;
>       const NetdevVhostUserOptions *vhost_user_opts;
>       Chardev *chr;
> -    bool memory_isolation G_GNUC_UNUSED;
> +    bool memory_isolation;
>   
>       assert(netdev->type == NET_CLIENT_DRIVER_VHOST_USER);
>       vhost_user_opts = &netdev->u.vhost_user;
> @@ -480,5 +480,6 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
>       memory_isolation = vhost_user_opts->has_memory_isolation ?
>                          vhost_user_opts->memory_isolation : false;
>   
> -    return net_vhost_user_init(peer, "vhost_user", name, chr, queues);
> +    return net_vhost_user_init(peer, "vhost_user", name, chr, queues,
> +                               memory_isolation);
>   }
> 

