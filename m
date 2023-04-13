Return-Path: <hreitz@redhat.com>
Message-ID: <5a6d3445-3a0c-18c6-834e-c39de41f4ee2@redhat.com>
Date: Thu, 13 Apr 2023 19:32:32 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-2-hreitz@redhat.com>
 <CAJSP0QVbNrvCYN+4aokEf=-L=D9YRTCKX-9-793NEBi91d6Fqw@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QVbNrvCYN+4aokEf=-L=D9YRTCKX-9-793NEBi91d6Fqw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 13.04.23 13:03, Stefan Hajnoczi wrote:
> On Tue, 11 Apr 2023 at 11:05, Hanna Czenczek <hreitz@redhat.com> wrote:
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
> Is there a reason to put this vhost-user-specific workaround in
> vhost.c instead of vhost-user.c?

My feeling was that this isn’t really vhost-user-specific.  It just so
happens that vhost-user is the only implementation that has a special
feature that disables all vrings, but I can’t see a reason why that
would be vhost-user-specific.

I mean, vhost_dev_set_vring_enable() looks like it can work for any
vhost implementation, but:
- .vhost_set_vring_enable() is indeed only implemented for vhost-user
- vhost_dev_set_vring_enable() won’t do anything if (for a vhost-user
   back-end) the F_PROTOCOL_FEATURES feature hasn’t been negotiated.

So this looked to me like if .vhost_set_vring_enable() were ever
implemented for anything but vhost-user, it’s quite likely that this too
would be gated behind some feature that auto-disables all vrings.

So this, plus the fact that vhost_dev_set_vring_enable() already has
vhost-user-specific code (while being a vhost.c function), I thought
it’d be best to put this into generic vhost.c code, simply because in
the worst case, it’ll be a no-op on other vhost implementations.

But as it is, functionally, of course I can just put it into
vhost_user_set_features().  (It would be a tiny bit more complicated,
because then I’d have to use vhost_user_set_vring_enable(), which
returns an error if F_PROTOCOL_FEATURES isn’t there, which we’d have to
ignore – vhost_dev_set_vring_enable() does that already for me.)

Hanna

