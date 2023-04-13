Return-Path: <maxime.coquelin@redhat.com>
Message-ID: <74a20bbf-860e-ed5b-03fa-6f25ce865652@redhat.com>
Date: Thu, 13 Apr 2023 09:17:16 +0200
MIME-Version: 1.0
Content-Language: en-US
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-2-hreitz@redhat.com> <20230412205138.GA2813183@fedora>
From: Maxime Coquelin <maxime.coquelin@redhat.com>
In-Reply-To: <20230412205138.GA2813183@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/4] vhost: Re-enable vrings after setting
 features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Roman Kagan <rvkagan@yandex-team.ru>, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>



On 4/12/23 22:51, Stefan Hajnoczi wrote:
> On Tue, Apr 11, 2023 at 05:05:12PM +0200, Hanna Czenczek wrote:
>> If the back-end supports the VHOST_USER_F_PROTOCOL_FEATURES feature,
>> setting the vhost features will set this feature, too.  Doing so
>> disables all vrings, which may not be intended.
>>
>> For example, enabling or disabling logging during migration requires
>> setting those features (to set or unset VHOST_F_LOG_ALL), which will
>> automatically disable all vrings.  In either case, the VM is running
>> (disabling logging is done after a failed or cancelled migration, and
>> only once the VM is running again, see comment in
>> memory_global_dirty_log_stop()), so the vrings should really be enabled.
>> As a result, the back-end seems to hang.
>>
>> To fix this, we must remember whether the vrings are supposed to be
>> enabled, and, if so, re-enable them after a SET_FEATURES call that set
>> VHOST_USER_F_PROTOCOL_FEATURES.
>>
>> It seems less than ideal that there is a short period in which the VM is
>> running but the vrings will be stopped (between SET_FEATURES and
>> SET_VRING_ENABLE).  To fix this, we would need to change the protocol,
>> e.g. by introducing a new flag or vhost-user protocol feature to disable
>> disabling vrings whenever VHOST_USER_F_PROTOCOL_FEATURES is set, or add
>> new functions for setting/clearing singular feature bits (so that
>> F_LOG_ALL can be set/cleared without touching F_PROTOCOL_FEATURES).
>>
>> Even with such a potential addition to the protocol, we still need this
>> fix here, because we cannot expect that back-ends will implement this
>> addition.
>>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>> ---
>>   include/hw/virtio/vhost.h | 10 ++++++++++
>>   hw/virtio/vhost.c         | 13 +++++++++++++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>> index a52f273347..2fe02ed5d4 100644
>> --- a/include/hw/virtio/vhost.h
>> +++ b/include/hw/virtio/vhost.h
>> @@ -90,6 +90,16 @@ struct vhost_dev {
>>       int vq_index_end;
>>       /* if non-zero, minimum required value for max_queues */
>>       int num_queues;
>> +
>> +    /*
>> +     * Whether the virtqueues are supposed to be enabled (via
>> +     * SET_VRING_ENABLE).  Setting the features (e.g. for
>> +     * enabling/disabling logging) will disable all virtqueues if
>> +     * VHOST_USER_F_PROTOCOL_FEATURES is set, so then we need to
>> +     * re-enable them if this field is set.
>> +     */
>> +    bool enable_vqs;
>> +
>>       /**
>>        * vhost feature handling requires matching the feature set
>>        * offered by a backend which may be a subset of the total
>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>> index a266396576..cbff589efa 100644
>> --- a/hw/virtio/vhost.c
>> +++ b/hw/virtio/vhost.c
>> @@ -50,6 +50,8 @@ static unsigned int used_memslots;
>>   static QLIST_HEAD(, vhost_dev) vhost_devices =
>>       QLIST_HEAD_INITIALIZER(vhost_devices);
>>   
>> +static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int enable);
>> +
>>   bool vhost_has_free_slot(void)
>>   {
>>       unsigned int slots_limit = ~0U;
>> @@ -899,6 +901,15 @@ static int vhost_dev_set_features(struct vhost_dev *dev,
>>           }
>>       }
>>   
>> +    if (dev->enable_vqs) {
>> +        /*
>> +         * Setting VHOST_USER_F_PROTOCOL_FEATURES would have disabled all
>> +         * virtqueues, even if that was not intended; re-enable them if
>> +         * necessary.
>> +         */
>> +        vhost_dev_set_vring_enable(dev, true);
>> +    }
>> +
>>   out:
>>       return r;
>>   }
>> @@ -1896,6 +1907,8 @@ int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
>>   
>>   static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int enable)
>>   {
>> +    hdev->enable_vqs = enable;
>> +
>>       if (!hdev->vhost_ops->vhost_set_vring_enable) {
>>           return 0;
>>       }
> 
> The vhost-user spec doesn't say that VHOST_F_LOG_ALL needs to be toggled
> at runtime and I don't think VHOST_USER_SET_PROTOCOL_FEATURES is
> intended to be used like that. This issue shows why doing so is a bad
> idea.
> 
> VHOST_F_LOG_ALL does not need to be toggled to control logging. Logging
> is controlled at runtime by the presence of the dirty log
> (VHOST_USER_SET_LOG_BASE) and the per-vring logging flag
> (VHOST_VRING_F_LOG).
> 
> I suggest permanently enabling VHOST_F_LOG_ALL upon connection when the
> the backend supports it. No spec changes are required.
> 
> libvhost-user looks like it will work. I didn't look at DPDK/SPDK, but
> checking that it works there is important too.
> 
> I have CCed people who may be interested in this issue. This is the
> first time I've looked at vhost-user logging, so this idea may not work.

In the case of DPDK, we rely on VHOST_F_LOG_ALL to be set to know
whether we should do dirty pages logging or not [0], so setting this
feature at init time will cause performance degradation. The check on
whether the log base address has been set is done afterwards.

Regards,
Maxime

> Stefan

[0]: https://git.dpdk.org/dpdk/tree/lib/vhost/vhost.h#n594
