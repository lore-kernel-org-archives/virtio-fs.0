Return-Path: <sgarzare@redhat.com>
Date: Fri, 25 Nov 2022 09:12:43 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
Message-ID: <20221125081243.a3q7ep32o6g4r2vd@sgarzare-redhat>
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <Y3+5rfnNmR7R/h6/@fedora>
MIME-Version: 1.0
In-Reply-To: <Y3+5rfnNmR7R/h6/@fedora>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH for-7.2] vhost: enable vrings in
 vhost_dev_start() for vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, virtio-fs@redhat.com, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

On Thu, Nov 24, 2022 at 01:36:29PM -0500, Stefan Hajnoczi wrote:
>On Wed, Nov 23, 2022 at 02:16:30PM +0100, Stefano Garzarella wrote:
>> Commit 02b61f38d3 ("hw/virtio: incorporate backend features in features")
>> properly negotiates VHOST_USER_F_PROTOCOL_FEATURES with the vhost-user
>> backend, but we forgot to enable vrings as specified in
>> docs/interop/vhost-user.rst:
>>
>>     If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
>>     ring starts directly in the enabled state.
>>
>>     If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
>>     initialized in a disabled state and is enabled by
>>     ``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
>>
>> Some vhost-user front-ends already did this by calling
>> vhost_ops.vhost_set_vring_enable() directly:
>> - backends/cryptodev-vhost.c
>> - hw/net/virtio-net.c
>> - hw/virtio/vhost-user-gpio.c
>>
>> But most didn't do that, so we would leave the vrings disabled and some
>> backends would not work. We observed this issue with the rust version of
>> virtiofsd [1], which uses the event loop [2] provided by the
>> vhost-user-backend crate where requests are not processed if vring is
>> not enabled.
>>
>> Let's fix this issue by enabling the vrings in vhost_dev_start() for
>> vhost-user front-ends that don't already do this directly. Same thing
>> also in vhost_dev_stop() where we disable vrings.
>>
>> [1] https://gitlab.com/virtio-fs/virtiofsd
>> [2] https://github.com/rust-vmm/vhost/blob/240fc2966/crates/vhost-user-backend/src/event_loop.rs#L217
>>
>> Fixes: 02b61f38d3 ("hw/virtio: incorporate backend features in features")
>> Reported-by: German Maglione <gmaglione@redhat.com>
>> Tested-by: German Maglione <gmaglione@redhat.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  include/hw/virtio/vhost.h      |  6 +++--
>>  backends/cryptodev-vhost.c     |  4 ++--
>>  backends/vhost-user.c          |  4 ++--
>>  hw/block/vhost-user-blk.c      |  4 ++--
>>  hw/net/vhost_net.c             |  8 +++----
>>  hw/scsi/vhost-scsi-common.c    |  4 ++--
>>  hw/virtio/vhost-user-fs.c      |  4 ++--
>>  hw/virtio/vhost-user-gpio.c    |  4 ++--
>>  hw/virtio/vhost-user-i2c.c     |  4 ++--
>>  hw/virtio/vhost-user-rng.c     |  4 ++--
>>  hw/virtio/vhost-vsock-common.c |  4 ++--
>>  hw/virtio/vhost.c              | 44 ++++++++++++++++++++++++++++++----
>>  hw/virtio/trace-events         |  4 ++--
>>  13 files changed, 67 insertions(+), 31 deletions(-)
>>
>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>> index 353252ac3e..67a6807fac 100644
>> --- a/include/hw/virtio/vhost.h
>> +++ b/include/hw/virtio/vhost.h
>> @@ -184,24 +184,26 @@ static inline bool vhost_dev_is_started(struct vhost_dev *hdev)
>>   * vhost_dev_start() - start the vhost device
>>   * @hdev: common vhost_dev structure
>>   * @vdev: the VirtIODevice structure
>> + * @vrings: true to have vrings enabled in this call
>>   *
>>   * Starts the vhost device. From this point VirtIO feature negotiation
>>   * can start and the device can start processing VirtIO transactions.
>>   *
>>   * Return: 0 on success, < 0 on error.
>>   */
>> -int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev);
>> +int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
>>
>>  /**
>>   * vhost_dev_stop() - stop the vhost device
>>   * @hdev: common vhost_dev structure
>>   * @vdev: the VirtIODevice structure
>> + * @vrings: true to have vrings disabled in this call
>>   *
>>   * Stop the vhost device. After the device is stopped the notifiers
>>   * can be disabled (@vhost_dev_disable_notifiers) and the device can
>>   * be torn down (@vhost_dev_cleanup).
>>   */
>> -void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev);
>> +void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
>>
>>  /**
>>   * DOC: vhost device configuration handling
>> diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
>> index bc13e466b4..572f87b3be 100644
>> --- a/backends/cryptodev-vhost.c
>> +++ b/backends/cryptodev-vhost.c
>> @@ -94,7 +94,7 @@ cryptodev_vhost_start_one(CryptoDevBackendVhost *crypto,
>>          goto fail_notifiers;
>>      }
>>
>> -    r = vhost_dev_start(&crypto->dev, dev);
>> +    r = vhost_dev_start(&crypto->dev, dev, false);
>>      if (r < 0) {
>>          goto fail_start;
>>      }
>> @@ -111,7 +111,7 @@ static void
>>  cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
>>                                   VirtIODevice *dev)
>>  {
>> -    vhost_dev_stop(&crypto->dev, dev);
>> +    vhost_dev_stop(&crypto->dev, dev, false);
>>      vhost_dev_disable_notifiers(&crypto->dev, dev);
>>  }
>>
>> diff --git a/backends/vhost-user.c b/backends/vhost-user.c
>> index 5dedb2d987..7bfcaef976 100644
>> --- a/backends/vhost-user.c
>> +++ b/backends/vhost-user.c
>> @@ -85,7 +85,7 @@ vhost_user_backend_start(VhostUserBackend *b)
>>      }
>>
>>      b->dev.acked_features = b->vdev->guest_features;
>> -    ret = vhost_dev_start(&b->dev, b->vdev);
>> +    ret = vhost_dev_start(&b->dev, b->vdev, true);
>>      if (ret < 0) {
>>          error_report("Error start vhost dev");
>>          goto err_guest_notifiers;
>> @@ -120,7 +120,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&b->dev, b->vdev);
>> +    vhost_dev_stop(&b->dev, b->vdev, true);
>>
>>      if (k->set_guest_notifiers) {
>>          ret = k->set_guest_notifiers(qbus->parent,
>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>> index 0d5190accf..1177064631 100644
>> --- a/hw/block/vhost-user-blk.c
>> +++ b/hw/block/vhost-user-blk.c
>> @@ -178,7 +178,7 @@ static int vhost_user_blk_start(VirtIODevice *vdev, Error **errp)
>>      }
>>
>>      s->dev.vq_index_end = s->dev.nvqs;
>> -    ret = vhost_dev_start(&s->dev, vdev);
>> +    ret = vhost_dev_start(&s->dev, vdev, true);
>>      if (ret < 0) {
>>          error_setg_errno(errp, -ret, "Error starting vhost");
>>          goto err_guest_notifiers;
>> @@ -213,7 +213,7 @@ static void vhost_user_blk_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&s->dev, vdev);
>> +    vhost_dev_stop(&s->dev, vdev, true);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
>> index 26e4930676..043058ff43 100644
>> --- a/hw/net/vhost_net.c
>> +++ b/hw/net/vhost_net.c
>> @@ -259,7 +259,7 @@ static int vhost_net_start_one(struct vhost_net *net,
>>          goto fail_notifiers;
>>      }
>>
>> -    r = vhost_dev_start(&net->dev, dev);
>> +    r = vhost_dev_start(&net->dev, dev, false);
>>      if (r < 0) {
>>          goto fail_start;
>>      }
>> @@ -308,7 +308,7 @@ fail:
>>      if (net->nc->info->poll) {
>>          net->nc->info->poll(net->nc, true);
>>      }
>> -    vhost_dev_stop(&net->dev, dev);
>> +    vhost_dev_stop(&net->dev, dev, false);
>>  fail_start:
>>      vhost_dev_disable_notifiers(&net->dev, dev);
>>  fail_notifiers:
>> @@ -329,7 +329,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
>>      if (net->nc->info->poll) {
>>          net->nc->info->poll(net->nc, true);
>>      }
>> -    vhost_dev_stop(&net->dev, dev);
>> +    vhost_dev_stop(&net->dev, dev, false);
>>      if (net->nc->info->stop) {
>>          net->nc->info->stop(net->nc);
>>      }
>> @@ -606,7 +606,7 @@ err_start:
>>          assert(r >= 0);
>>      }
>>
>> -    vhost_dev_stop(&net->dev, vdev);
>> +    vhost_dev_stop(&net->dev, vdev, false);
>>
>>      return r;
>>  }
>> diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
>> index 767f827e55..18ea5dcfa1 100644
>> --- a/hw/scsi/vhost-scsi-common.c
>> +++ b/hw/scsi/vhost-scsi-common.c
>> @@ -68,7 +68,7 @@ int vhost_scsi_common_start(VHostSCSICommon *vsc)
>>          goto err_guest_notifiers;
>>      }
>>
>> -    ret = vhost_dev_start(&vsc->dev, vdev);
>> +    ret = vhost_dev_start(&vsc->dev, vdev, true);
>>      if (ret < 0) {
>>          error_report("Error start vhost dev");
>>          goto err_guest_notifiers;
>> @@ -101,7 +101,7 @@ void vhost_scsi_common_stop(VHostSCSICommon *vsc)
>>      VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
>>      int ret = 0;
>>
>> -    vhost_dev_stop(&vsc->dev, vdev);
>> +    vhost_dev_stop(&vsc->dev, vdev, true);
>>
>>      if (k->set_guest_notifiers) {
>>          ret = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index dc4014cdef..d97b179e6f 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -76,7 +76,7 @@ static void vuf_start(VirtIODevice *vdev)
>>      }
>>
>>      fs->vhost_dev.acked_features = vdev->guest_features;
>> -    ret = vhost_dev_start(&fs->vhost_dev, vdev);
>> +    ret = vhost_dev_start(&fs->vhost_dev, vdev, true);
>>      if (ret < 0) {
>>          error_report("Error starting vhost: %d", -ret);
>>          goto err_guest_notifiers;
>> @@ -110,7 +110,7 @@ static void vuf_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&fs->vhost_dev, vdev);
>> +    vhost_dev_stop(&fs->vhost_dev, vdev, true);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
>> index 5851cb3bc9..0b40ebd15a 100644
>> --- a/hw/virtio/vhost-user-gpio.c
>> +++ b/hw/virtio/vhost-user-gpio.c
>> @@ -81,7 +81,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>>       */
>>      vhost_ack_features(&gpio->vhost_dev, feature_bits, vdev->guest_features);
>>
>> -    ret = vhost_dev_start(&gpio->vhost_dev, vdev);
>> +    ret = vhost_dev_start(&gpio->vhost_dev, vdev, false);
>>      if (ret < 0) {
>>          error_report("Error starting vhost-user-gpio: %d", ret);
>>          goto err_guest_notifiers;
>> @@ -139,7 +139,7 @@ static void vu_gpio_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(vhost_dev, vdev);
>> +    vhost_dev_stop(vhost_dev, vdev, false);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
>> index 1c9f3d20dc..dc5c828ba6 100644
>> --- a/hw/virtio/vhost-user-i2c.c
>> +++ b/hw/virtio/vhost-user-i2c.c
>> @@ -46,7 +46,7 @@ static void vu_i2c_start(VirtIODevice *vdev)
>>
>>      i2c->vhost_dev.acked_features = vdev->guest_features;
>>
>> -    ret = vhost_dev_start(&i2c->vhost_dev, vdev);
>> +    ret = vhost_dev_start(&i2c->vhost_dev, vdev, true);
>>      if (ret < 0) {
>>          error_report("Error starting vhost-user-i2c: %d", -ret);
>>          goto err_guest_notifiers;
>> @@ -80,7 +80,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&i2c->vhost_dev, vdev);
>> +    vhost_dev_stop(&i2c->vhost_dev, vdev, true);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
>> index f9084cde58..201a39e220 100644
>> --- a/hw/virtio/vhost-user-rng.c
>> +++ b/hw/virtio/vhost-user-rng.c
>> @@ -47,7 +47,7 @@ static void vu_rng_start(VirtIODevice *vdev)
>>      }
>>
>>      rng->vhost_dev.acked_features = vdev->guest_features;
>> -    ret = vhost_dev_start(&rng->vhost_dev, vdev);
>> +    ret = vhost_dev_start(&rng->vhost_dev, vdev, true);
>>      if (ret < 0) {
>>          error_report("Error starting vhost-user-rng: %d", -ret);
>>          goto err_guest_notifiers;
>> @@ -81,7 +81,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&rng->vhost_dev, vdev);
>> +    vhost_dev_stop(&rng->vhost_dev, vdev, true);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, rng->vhost_dev.nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
>> index a67a275de2..d21c72b401 100644
>> --- a/hw/virtio/vhost-vsock-common.c
>> +++ b/hw/virtio/vhost-vsock-common.c
>> @@ -70,7 +70,7 @@ int vhost_vsock_common_start(VirtIODevice *vdev)
>>      }
>>
>>      vvc->vhost_dev.acked_features = vdev->guest_features;
>> -    ret = vhost_dev_start(&vvc->vhost_dev, vdev);
>> +    ret = vhost_dev_start(&vvc->vhost_dev, vdev, true);
>>      if (ret < 0) {
>>          error_report("Error starting vhost: %d", -ret);
>>          goto err_guest_notifiers;
>> @@ -105,7 +105,7 @@ void vhost_vsock_common_stop(VirtIODevice *vdev)
>>          return;
>>      }
>>
>> -    vhost_dev_stop(&vvc->vhost_dev, vdev);
>> +    vhost_dev_stop(&vvc->vhost_dev, vdev, true);
>>
>>      ret = k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false);
>>      if (ret < 0) {
>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>> index d1c4c20b8c..7fb008bc9e 100644
>> --- a/hw/virtio/vhost.c
>> +++ b/hw/virtio/vhost.c
>> @@ -1777,15 +1777,36 @@ int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
>>      return 0;
>>  }
>>
>> +static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int enable)
>
>There is a similarly-named vhost_set_vring_enable(NetClientState *nc,
>int enable) function which is actually part of vhost_net. Please rename
>it to vhost_net_set_vring_enable(). 

Should I rename it in this patch?

> It should probably call
>vhost_dev_set_vring_enable().

Ehm, the idea of this patch was to touch as little as possible to avoid 
new regressions.

Also, the semantics of vhost_dev_set_vring_enable() was meant to keep 
vhost_dev_start()/vhost_dev_stop() simple, not to be exposed to 
frontends. (maybe I should have written it, sorry about that).

However I agree that we should clean up vhost-net and also the other 
frontends as Raphael also suggested, but honestly I'm scared to do that 
now in this patch...

What I would have wanted to do, would be similar to what we do for 
vhost-vdpa: call SET_VRING_ENABLE in the vhost_ops->vhost_dev_start() 
callback of vhost-user.c.
Removing all the call to vhost_ops->vhost_set_vring_enable() in the 
frontends, but I think it's too risky to do that now.

>
>> +{
>> +    if (!hdev->vhost_ops->vhost_set_vring_enable) {
>> +        return 0;
>> +    }
>> +
>> +    /*
>> +     * For vhost-user devices, if VHOST_USER_F_PROTOCOL_FEATURES has not
>> +     * been negotiated, the rings start directly in the enabled state, and
>> +     * .vhost_set_vring_enable callback will fail since
>> +     * VHOST_USER_SET_VRING_ENABLE is not supported.
>> +     */
>> +    if (hdev->vhost_ops->backend_type == VHOST_BACKEND_TYPE_USER &&
>> +        !virtio_has_feature(hdev->backend_features,
>> +                            VHOST_USER_F_PROTOCOL_FEATURES)) {
>> +        return 0;
>> +    }
>
>These semantics are the opposite of vhost_user_set_vring_enable():
>
>  if (!virtio_has_feature(dev->features, VHOST_USER_F_PROTOCOL_FEATURES)) {
>      return -EINVAL;
>  }
>
>Please make vhost_user_set_vring_enable() and
>vhost_dev_set_vring_enable() consistent. Code gets really confusing when
>layers have different semantics for the same operation.

It's the opposite precisely because we shouldn't let 
vhost_dev_start()/vhost_dev_stop() fail if 
vhost_ops->vhost_set_vring_enable() can't be called because it would 
fail.

If I do it this way, then I have to put the check inside 
vhost_dev_start()/vhost_dev_stop(), and at this point I remove the 
function that would be useless (just a wrapper of 
hdev->vhost_ops->vhost_set_vring_enable).
Actually this was the first implementation I did, then I added the 
function just to have vhost_dev_start()/vhost_dev_stop() cleaner and to 
avoid duplicating the check.

>
>> +
>> +    return hdev->vhost_ops->vhost_set_vring_enable(hdev, enable);
>> +}
>
>The return value is hard to understand. An error return is only returned
>by vhost-user devices with VHOST_USER_F_PROTOCOL_FEATURES. There are
>other cases that seem like they should return an error but return
>success instead. For example, when called with enable=false on a
>non-VHOST_USER_F_PROTOCOL_FEATURES device (e.g. vhost-kernel or legacy
>vhost-user) we return success even though the vring wasn't disabled.

As I explained above, the idea was not to expose this function outside, 
but to use it only in vhost_dev_start()/vhost_dev_stop(). So the return 
value is 0 both when it has successes and when there is no need/way to 
enable/disable the vrings.

Perhaps since it is confusing, I will remove the function and put the 
code directly into vhost_dev_start()/vhost_dev_stop().

What do you think?

Thanks,
Stefano

