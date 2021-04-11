DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; 
	t=1618122116; bh=GXEAeIfGDAFAAVqSMscghhalkmu8Yl/N+Qa7ske4RZE=;
	h=In-Reply-To:References:Date:Message-ID:To:Subject:From:Cc;
	b=tRMHLv7YiAGegdsixDT4rLKi8DvPoLhoQbgfQi+mQFrdeDqtPaGsM+vmq+Qi5fkL7
	Ht0S0UXW40Zev/ElLUk9Xzy2AHB1xtGJJvmGAlp+VXJhyhQ3BlBTT+mTgQCboJo7Gv
	JjuPRcx6aJZyEMqwSbCgF5PT06TspQQLVzropkNQ=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
	<20210409155657.GE1111800@redhat.com>
Message-ID: <14f05a3d-7db6-2c01-7fe0-f83586ff1fd6@yandex-team.ru>
Date: Sun, 11 Apr 2021 09:21:54 +0300
MIME-Version: 1.0
In-Reply-To: <20210409155657.GE1111800@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>


On 09/04/2021 18:56, Vivek Goyal wrote:
> On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
>> Make virtio-fs take into account server capabilities.
>>
>> Just returning requested features assumes they all of then are implemented
>> by server and results in setting unsupported configuration if some of them
>> are absent.
>>
>> Signed-off-by: Anton Kuchin<antonkuchin@yandex-team.ru>
> [CC stefan and qemu-devel.]
>
> Can you give more details of what problem exactly you are facing. Or
> this fix is about avoiding a future problem where device can refuse
> to support a feature qemu is requesting for.

This fixes existing problem that qemu ignores features (un)supported by 
backend and this works fine only if backend features match features of 
qemu. Otherwise qemu incorrectly assumes that backend suports all of 
them and calls vhost_set_features() not taking into account result of 
previous vhost_get_features() call. This breaks protocol and can crash 
server or cause incorrect behavior.

This is why I hope it to be accepted in time for 6.0 release.

> IIUC, this patch is preparing a list of features vhost-user-fs device
> can support. Then it calls vhost_get_features() which makes sure that
> all these features are support by real vhost-user device (hdev->features).
> If not, then corresponding feature is reset and remaining features
> are returned to caller.
When this callback is executed in virtio_bus_device_plugged() list of 
features that vhost-backend supports has been already obtained earlier 
by vhost_user_get_features() in vuf_device_realize() and stored in 
hdev->features. vuf_get_features() should return bitmask of features 
that are common for vhost backend (hdev->features) and frontend 
(vdev->host_features). But instead it just returns host features.
> This feature negotion bit is called in so many places that I am kind of
> lost that who should be doing what. Will leave it to Stefan who
> understands it much better.
>
>
>> ---
>>   hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index ac4fc34b36..6cf983ba0e 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -24,6 +24,14 @@
>>   #include "monitor/monitor.h"
>>   #include "sysemu/sysemu.h"
>>   
>> +static const int user_feature_bits[] = {
>> +    VIRTIO_F_VERSION_1,
>> +    VIRTIO_RING_F_INDIRECT_DESC,
>> +    VIRTIO_RING_F_EVENT_IDX,
>> +    VIRTIO_F_NOTIFY_ON_EMPTY,
>> +    VHOST_INVALID_FEATURE_BIT
>> +};
>> +
>>   static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
>>   {
>>       VHostUserFS *fs = VHOST_USER_FS(vdev);
>> @@ -129,11 +137,12 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
>>   }
>>   
>>   static uint64_t vuf_get_features(VirtIODevice *vdev,
>> -                                      uint64_t requested_features,
>> -                                      Error **errp)
>> +                                 uint64_t features,
> Will it make sense to keep the name requested_features. This kind of
> makes it clear that caller is requesting these features.
>
> I feel there should be few lines of comments also to make it clear
> what this function is actually doing.

This fix was inspired by similar functions in 
hw/scsi/vhost-scsi-common.c, hw/virtio/vhost-user-vsock.c, 
hw/block/vhost-user-blk.c and hw/net/vhost_net.c and I borrowed naming 
from them just to be consistent.

IMO this looks like a good place for refactoring because we have more 
and more vhost-user devices that duplicate that code, but it can be done 
after the bug is fixed.

> Vivek
>
>> +                                 Error **errp)
>>   {
>> -    /* No feature bits used yet */
>> -    return requested_features;
>> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
>> +
>> +    return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
>>   }
>>   
>>   static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>> -- 
>> 2.25.1
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://listman.redhat.com/mailman/listinfo/virtio-fs

