Return-Path: <hreitz@redhat.com>
Message-ID: <b0cd4f54-94ed-09a4-cec2-e81f36da4008@redhat.com>
Date: Thu, 13 Apr 2023 19:55:00 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com> <20230412210641.GC2813183@fedora>
 <246691c3-2287-7472-3615-7ec0f074445c@redhat.com>
 <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>

On 13.04.23 13:38, Stefan Hajnoczi wrote:
> On Thu, 13 Apr 2023 at 05:24, Hanna Czenczek <hreitz@redhat.com> wrote:
>> On 12.04.23 23:06, Stefan Hajnoczi wrote:
>>> On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
>>>> So-called "internal" virtio-fs migration refers to transporting the
>>>> back-end's (virtiofsd's) state through qemu's migration stream.  To do
>>>> this, we need to be able to transfer virtiofsd's internal state to and
>>>> from virtiofsd.
>>>>
>>>> Because virtiofsd's internal state will not be too large, we believe it
>>>> is best to transfer it as a single binary blob after the streaming
>>>> phase.  Because this method should be useful to other vhost-user
>>>> implementations, too, it is introduced as a general-purpose addition to
>>>> the protocol, not limited to vhost-user-fs.
>>>>
>>>> These are the additions to the protocol:
>>>> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
>>>>     This feature signals support for transferring state, and is added so
>>>>     that migration can fail early when the back-end has no support.
>>>>
>>>> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a pipe
>>>>     over which to transfer the state.  The front-end sends an FD to the
>>>>     back-end into/from which it can write/read its state, and the back-end
>>>>     can decide to either use it, or reply with a different FD for the
>>>>     front-end to override the front-end's choice.
>>>>     The front-end creates a simple pipe to transfer the state, but maybe
>>>>     the back-end already has an FD into/from which it has to write/read
>>>>     its state, in which case it will want to override the simple pipe.
>>>>     Conversely, maybe in the future we find a way to have the front-end
>>>>     get an immediate FD for the migration stream (in some cases), in which
>>>>     case we will want to send this to the back-end instead of creating a
>>>>     pipe.
>>>>     Hence the negotiation: If one side has a better idea than a plain
>>>>     pipe, we will want to use that.
>>>>
>>>> - CHECK_DEVICE_STATE: After the state has been transferred through the
>>>>     pipe (the end indicated by EOF), the front-end invokes this function
>>>>     to verify success.  There is no in-band way (through the pipe) to
>>>>     indicate failure, so we need to check explicitly.
>>>>
>>>> Once the transfer pipe has been established via SET_DEVICE_STATE_FD
>>>> (which includes establishing the direction of transfer and migration
>>>> phase), the sending side writes its data into the pipe, and the reading
>>>> side reads it until it sees an EOF.  Then, the front-end will check for
>>>> success via CHECK_DEVICE_STATE, which on the destination side includes
>>>> checking for integrity (i.e. errors during deserialization).
>>>>
>>>> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>>> ---
>>>>    include/hw/virtio/vhost-backend.h |  24 +++++
>>>>    include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>>>>    hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++++++
>>>>    hw/virtio/vhost.c                 |  37 ++++++++
>>>>    4 files changed, 287 insertions(+)
>>>>
>>>> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
>>>> index ec3fbae58d..5935b32fe3 100644
>>>> --- a/include/hw/virtio/vhost-backend.h
>>>> +++ b/include/hw/virtio/vhost-backend.h
>>>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>>>>        VHOST_SET_CONFIG_TYPE_MIGRATION = 1,
>>>>    } VhostSetConfigType;
>>>>
>>>> +typedef enum VhostDeviceStateDirection {
>>>> +    /* Transfer state from back-end (device) to front-end */
>>>> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE = 0,
>>>> +    /* Transfer state from front-end to back-end (device) */
>>>> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD = 1,
>>>> +} VhostDeviceStateDirection;
>>>> +
>>>> +typedef enum VhostDeviceStatePhase {
>>>> +    /* The device (and all its vrings) is stopped */
>>>> +    VHOST_TRANSFER_STATE_PHASE_STOPPED = 0,
>>>> +} VhostDeviceStatePhase;
>>> vDPA has:
>>>
>>>     /* Suspend a device so it does not process virtqueue requests anymore
>>>      *
>>>      * After the return of ioctl the device must preserve all the necessary state
>>>      * (the virtqueue vring base plus the possible device specific states) that is
>>>      * required for restoring in the future. The device must not change its
>>>      * configuration after that point.
>>>      */
>>>     #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
>>>
>>>     /* Resume a device so it can resume processing virtqueue requests
>>>      *
>>>      * After the return of this ioctl the device will have restored all the
>>>      * necessary states and it is fully operational to continue processing the
>>>      * virtqueue descriptors.
>>>      */
>>>     #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
>>>
>>> I wonder if it makes sense to import these into vhost-user so that the
>>> difference between kernel vhost and vhost-user is minimized. It's okay
>>> if one of them is ahead of the other, but it would be nice to avoid
>>> overlapping/duplicated functionality.
>>>
>>> (And I hope vDPA will import the device state vhost-user messages
>>> introduced in this series.)
>> I don’t understand your suggestion.  (Like, I very simply don’t
>> understand :))
>>
>> These are vhost messages, right?  What purpose do you have in mind for
>> them in vhost-user for internal migration?  They’re different from the
>> state transfer messages, because they don’t transfer state to/from the
>> front-end.  Also, the state transfer stuff is supposed to be distinct
>> from starting/stopping the device; right now, it just requires the
>> device to be stopped beforehand (or started only afterwards).  And in
>> the future, new VhostDeviceStatePhase values may allow the messages to
>> be used on devices that aren’t stopped.
>>
>> So they seem to serve very different purposes.  I can imagine using the
>> VDPA_{SUSPEND,RESUME} messages for external migration (what Anton is
>> working on), but they don’t really help with internal migration
>> implemented here.  If I were to add them, they’d just be sent in
>> addition to the new messages added in this patch here, i.e. SUSPEND on
>> the source before SET_DEVICE_STATE_FD, and RESUME on the destination
>> after CHECK_DEVICE_STATE (we could use RESUME in place of
>> CHECK_DEVICE_STATE on the destination, but we can’t do that on the
>> source, so we still need CHECK_DEVICE_STATE).
> Yes, they are complementary to the device state fd message. I want to
> make sure pre-conditions about the device's state (running vs stopped)
> already take into account the vDPA SUSPEND/RESUME model.
>
> vDPA will need device state save/load in the future. For virtiofs
> devices, for example. This is why I think we should plan for vDPA and
> vhost-user to share the same interface.

While the paragraph below is more important, I don’t feel like this
would be important right now.  It’s clear that SUSPEND must come before
transferring any state, and that RESUME must come after transferring
state.  I don’t think we need to clarify this now, it’d be obvious when
implementing SUSPEND/RESUME.

> Also, I think the code path you're relying on (vhost_dev_stop()) on
> doesn't work for backends that implement VHOST_USER_PROTOCOL_F_STATUS
> because stopping the backend resets the device and throws away its
> state. SUSPEND/RESUME solve this. This looks like a more general
> problem since vhost_dev_stop() is called any time the VM is paused.
> Maybe it needs to use SUSPEND/RESUME whenever possible.

That’s a problem.  Quite a problem, to be honest, because this sounds
rather complicated with honestly absolutely no practical benefit right
now.

Would you require SUSPEND/RESUME for state transfer even if the back-end
does not implement GET/SET_STATUS?  Because then this would also lead to
more complexity in virtiofsd.

Basically, what I’m hearing is that I need to implement a different
feature that has no practical impact right now, and also fix bugs around
it along the way...

(Not that I have any better suggestion.)

Hanna

