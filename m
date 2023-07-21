Return-Path: <hreitz@redhat.com>
Message-ID: <f07af821-a667-f2c5-3cec-a2f3e2b31ee2@redhat.com>
Date: Fri, 21 Jul 2023 10:07:01 +0200
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-3-hreitz@redhat.com>
 <d5fc7e82-3bd5-deeb-b506-5a8d10bd7112@linux.dev>
 <14677814-9707-6a08-7b07-4532fad5f7a1@redhat.com>
 <d3d992ff-3d3d-1282-cdbc-f7ec1ad175cb@linux.dev>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <d3d992ff-3d3d-1282-cdbc-f7ec1ad175cb@linux.dev>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hao Xu <hao.xu@linux.dev>, qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>

On 20.07.23 17:05, Hao Xu wrote:
>
> On 7/20/23 21:20, Hanna Czenczek wrote:
>> On 20.07.23 14:13, Hao Xu wrote:
>>>
>>> On 7/12/23 19:17, Hanna Czenczek wrote:
>>>> Add the interface for transferring the back-end's state during 
>>>> migration
>>>> as defined previously in vhost-user.rst.
>>>>
>>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>>> ---
>>>>   include/hw/virtio/vhost-backend.h |  24 +++++
>>>>   include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>>>>   hw/virtio/vhost-user.c            | 147 
>>>> ++++++++++++++++++++++++++++++
>>>>   hw/virtio/vhost.c                 |  37 ++++++++
>>>>   4 files changed, 287 insertions(+)
>>>>
>>>> diff --git a/include/hw/virtio/vhost-backend.h 
>>>> b/include/hw/virtio/vhost-backend.h
>>>> index 31a251a9f5..e59d0b53f8 100644
>>>> --- a/include/hw/virtio/vhost-backend.h
>>>> +++ b/include/hw/virtio/vhost-backend.h
>>>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>>>>       VHOST_SET_CONFIG_TYPE_MIGRATION = 1,
>>>>   } VhostSetConfigType;
>>>>   +typedef enum VhostDeviceStateDirection {
>>>> +    /* Transfer state from back-end (device) to front-end */
>>>> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE = 0,
>>>> +    /* Transfer state from front-end to back-end (device) */
>>>> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD = 1,
>>>> +} VhostDeviceStateDirection;
>>>> +
>>>> +typedef enum VhostDeviceStatePhase {
>>>> +    /* The device (and all its vrings) is stopped */
>>>> +    VHOST_TRANSFER_STATE_PHASE_STOPPED = 0,
>>>> +} VhostDeviceStatePhase;
>>>> +
>>>>   struct vhost_inflight;
>>>>   struct vhost_dev;
>>>>   struct vhost_log;
>>>> @@ -133,6 +145,15 @@ typedef int (*vhost_set_config_call_op)(struct 
>>>> vhost_dev *dev,
>>>>     typedef void (*vhost_reset_status_op)(struct vhost_dev *dev);
>>>>   +typedef bool (*vhost_supports_migratory_state_op)(struct 
>>>> vhost_dev *dev);
>>>> +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
>>>> + VhostDeviceStateDirection direction,
>>>> + VhostDeviceStatePhase phase,
>>>> +                                            int fd,
>>>> +                                            int *reply_fd,
>>>> +                                            Error **errp);
>>>> +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev, 
>>>> Error **errp);
>>>> +
>>>>   typedef struct VhostOps {
>>>>       VhostBackendType backend_type;
>>>>       vhost_backend_init vhost_backend_init;
>>>> @@ -181,6 +202,9 @@ typedef struct VhostOps {
>>>>       vhost_force_iommu_op vhost_force_iommu;
>>>>       vhost_set_config_call_op vhost_set_config_call;
>>>>       vhost_reset_status_op vhost_reset_status;
>>>> +    vhost_supports_migratory_state_op vhost_supports_migratory_state;
>>>> +    vhost_set_device_state_fd_op vhost_set_device_state_fd;
>>>> +    vhost_check_device_state_op vhost_check_device_state;
>>>>   } VhostOps;
>>>>     int vhost_backend_update_device_iotlb(struct vhost_dev *dev,
>>>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>>>> index 69bf59d630..d8877496e5 100644
>>>> --- a/include/hw/virtio/vhost.h
>>>> +++ b/include/hw/virtio/vhost.h
>>>> @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
>>>>   int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t 
>>>> queue_size,
>>>>                              struct vhost_inflight *inflight);
>>>>   bool vhost_dev_has_iommu(struct vhost_dev *dev);
>>>> +
>>>> +/**
>>>> + * vhost_supports_migratory_state(): Checks whether the back-end
>>>> + * supports transferring internal state for the purpose of migration.
>>>> + * Support for this feature is required for 
>>>> vhost_set_device_state_fd()
>>>> + * and vhost_check_device_state().
>>>> + *
>>>> + * @dev: The vhost device
>>>> + *
>>>> + * Returns true if the device supports these commands, and false 
>>>> if it
>>>> + * does not.
>>>> + */
>>>> +bool vhost_supports_migratory_state(struct vhost_dev *dev);
>>>> +
>>>> +/**
>>>> + * vhost_set_device_state_fd(): Begin transfer of internal state 
>>>> from/to
>>>> + * the back-end for the purpose of migration.  Data is to be 
>>>> transferred
>>>> + * over a pipe according to @direction and @phase.  The sending 
>>>> end must
>>>> + * only write to the pipe, and the receiving end must only read 
>>>> from it.
>>>> + * Once the sending end is done, it closes its FD.  The receiving end
>>>> + * must take this as the end-of-transfer signal and close its FD, 
>>>> too.
>>>> + *
>>>> + * @fd is the back-end's end of the pipe: The write FD for SAVE, 
>>>> and the
>>>> + * read FD for LOAD.  This function transfers ownership of @fd to the
>>>> + * back-end, i.e. closes it in the front-end.
>>>> + *
>>>> + * The back-end may optionally reply with an FD of its own, if this
>>>> + * improves efficiency on its end.  In this case, the returned FD is
>>>
>>>
>>> Hi Hanna,
>>>
>>> In what case/situation, the back-end will have a more efficient fd?
>>
>> Hi Hao,
>>
>> There is no example yet.
>>
>>> Here my understanding of this "FD of its own" is as same type as
>>>
>>> the given fd(e.g. both pipe files), why the fd from back-end makes
>>>
>>> difference? Do I miss anything here?
>>
>> Maybe it makes more sense in the context of how we came up with the 
>> idea: Specifically, Stefan and me were asking which end should 
>> provide the FD.  In the context of vhost-user, it makes sense to have 
>> it be the front-end, because it controls vhost-user communication, 
>> but that’s just the natural protocol choice, not necessarily the most 
>> efficient one.
>>
>> It is imaginable that the front-end (e.g. qemu) could create a file 
>> descriptor whose data is directly spliced (automatically) into the 
>> migration stream, and then hand this FD to the back-end. In practice, 
>> this doesn’t work for qemu (at this point), because it doesn’t use 
>> simple read/write into the migration stream, but has an abstraction 
>> layer for that.  It might be possible to make this work in some 
>> cases, depending on what is used as a transport, but (1) not 
>> generally, and (2) not now.  But this would be efficient.
>
>
> I'm thinking one thing, we now already have a channel(a unix domain 
> socket) between front-end and back-end, why not delivering the state 
> file (as an fd) to/from back-end directly rathen than negotiating
>
> a new pipe as data channel.(since we already assume they can share fd 
> of pipe, why not fd of normal file?)

I don’t quite understand.  We do deliver the FD to the back-end through 
this new command to the back-end, rather directly.  The back-end can 
disagree and send another FD back, but it doesn’t have to.  It can just 
simply always take the FD that it’s been given.

The FD also doesn’t need to be a pipe, it can be any FD that the 
back-end can read the state from (see my discussion with Stefan on patch 
1).  In the practical implementation, it’s difficult for qemu to provide 
anything that is not a pipe, because the migration state can be sent 
over many channels, and the respective FD (if any) is not exposed on the 
high level (for devices).

>
>>
>> The model we’d implement in qemu with this series is comparatively 
>> not efficient, because it manually copies data from the FD (which by 
>> default is a pipe) into the migration stream.
>>
>> But it is possible that the front-end can provide a zero-copy FD into 
>> the migration stream, and for that reason we want to allow the 
>> front-end to provide the transfer FD.
>>
>> In contrast, the back-end might have a more efficient implementation 
>> on its side, too, though.  It is difficult to imagine, but it may be 
>> possible that it has an FD already where the data needs to written 
>> to/read from, e.g. because it’s connected to a physical device that 
>> wants to get/send its state this way.  Admittedly, we have absolutely 
>> no concrete example for such a back-end at this point, but it’s hard 
>> to rule out that it is possible that there will be back-ends that 
>> could make use of zero-copy if only they are allowed to dictate the 
>> transfer FD.
>>
>> So because we in qemu can’t (at least not generally) provide an 
>> efficient (zero-copy) implementation, we don’t want to rule out that 
>> the back-end might be able to, so we also want to allow it to provide 
>> the transfer FD.
>>
>> In the end, we decided that we don’t want to preclude either side of 
>> providing the FD.  If one side knows it can do better than a plain 
>> pipe with copying on both ends, it should provide the FD. That 
>> doesn’t complicate the implementation much.
>>
>> (So, notably, we measure “improves efficiency” based on “is it better 
>> than a plain pipe with copying on both ends”.  A pipe with copying is 
>> the default implementation, but as Stefan has pointed out in his 
>> review, it doesn’t need to be a pipe.  More efficient FDs, like the 
>> back-end can provide in its reply, would actually likely not be pipes.)
>
>
> Yea, but the vhost-user protocol in this patchset defines these FDs as 
> data transfer channel not the data itself, how about the latter?

I don’t quite understand this either.  Perhaps you’re suggesting that we 
should just transfer the data over the vhost-user socket. There are two 
reasons why I don’t think we should do that: First, the vhost-user 
socket is currently only used for a small amount of data.  For example, 
the Rust vhost crate will reject any message longer than 4096 bytes.  So 
if I were to use it for more data, I feel like I’d be abusing it.  
Second, if/when we add other transfer phases (i.e. while the VM is still 
running, to transfer larger amounts of state), it will be important that 
the vhost-user socket is open for messages from the front-end at any 
time.  So then, at the latest, would we need a separate data channel.  I 
don’t feel like there is harm in making the interface have this separate 
channel now already.

Or maybe you suggest that the separate FD is OK, but it shouldn’t be 
defined to be a data transfer channel, but just data, i.e. not 
necessarily a pipe.  I think that’s basically the discussion I had with 
Stefan on patch 1: That the important thing is just that the receiving 
end can read data out of the FD until EOF, and the writing end can write 
data and close the FD to signal the end of data. Whether they actually 
do that is not important, only that anything they do will let the other 
end do that.

Hanna

