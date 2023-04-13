Return-Path: <hreitz@redhat.com>
Message-ID: <af50a052-0f3e-a03c-598d-dff841720dd6@redhat.com>
Date: Thu, 13 Apr 2023 11:25:22 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <CAJaqyWf8twfendAqcuPopeeZv84JcevPdDm=rKaKiRFvft+30A@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJaqyWf8twfendAqcuPopeeZv84JcevPdDm=rKaKiRFvft+30A@mail.gmail.com>
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
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 13.04.23 10:50, Eugenio Perez Martin wrote:
> On Tue, Apr 11, 2023 at 5:33 PM Hanna Czenczek <hreitz@redhat.com> wrote:
>> So-called "internal" virtio-fs migration refers to transporting the
>> back-end's (virtiofsd's) state through qemu's migration stream.  To do
>> this, we need to be able to transfer virtiofsd's internal state to and
>> from virtiofsd.
>>
>> Because virtiofsd's internal state will not be too large, we believe it
>> is best to transfer it as a single binary blob after the streaming
>> phase.  Because this method should be useful to other vhost-user
>> implementations, too, it is introduced as a general-purpose addition to
>> the protocol, not limited to vhost-user-fs.
>>
>> These are the additions to the protocol:
>> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
>>    This feature signals support for transferring state, and is added so
>>    that migration can fail early when the back-end has no support.
>>
>> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a pipe
>>    over which to transfer the state.  The front-end sends an FD to the
>>    back-end into/from which it can write/read its state, and the back-end
>>    can decide to either use it, or reply with a different FD for the
>>    front-end to override the front-end's choice.
>>    The front-end creates a simple pipe to transfer the state, but maybe
>>    the back-end already has an FD into/from which it has to write/read
>>    its state, in which case it will want to override the simple pipe.
>>    Conversely, maybe in the future we find a way to have the front-end
>>    get an immediate FD for the migration stream (in some cases), in which
>>    case we will want to send this to the back-end instead of creating a
>>    pipe.
>>    Hence the negotiation: If one side has a better idea than a plain
>>    pipe, we will want to use that.
>>
>> - CHECK_DEVICE_STATE: After the state has been transferred through the
>>    pipe (the end indicated by EOF), the front-end invokes this function
>>    to verify success.  There is no in-band way (through the pipe) to
>>    indicate failure, so we need to check explicitly.
>>
>> Once the transfer pipe has been established via SET_DEVICE_STATE_FD
>> (which includes establishing the direction of transfer and migration
>> phase), the sending side writes its data into the pipe, and the reading
>> side reads it until it sees an EOF.  Then, the front-end will check for
>> success via CHECK_DEVICE_STATE, which on the destination side includes
>> checking for integrity (i.e. errors during deserialization).
>>
>> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>> ---
>>   include/hw/virtio/vhost-backend.h |  24 +++++
>>   include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>>   hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++++++
>>   hw/virtio/vhost.c                 |  37 ++++++++
>>   4 files changed, 287 insertions(+)

[...]

>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>> index 2fe02ed5d4..29449e0fe2 100644
>> --- a/include/hw/virtio/vhost.h
>> +++ b/include/hw/virtio/vhost.h
>> @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,

[...]

>> +/**
>> + * vhost_set_device_state_fd(): After transferring state from/to the
> Nitpick: This function doc is for vhost_check_device_state not
> vhost_set_device_state_fd.
>
> Thanks!

Oops, right, thanks!

Hanna

>> + * back-end via vhost_set_device_state_fd(), i.e. once the sending end
>> + * has closed the pipe, inquire the back-end to report any potential
>> + * errors that have occurred on its side.  This allows to sense errors
>> + * like:
>> + * - During outgoing migration, when the source side had already started
>> + *   to produce its state, something went wrong and it failed to finish
>> + * - During incoming migration, when the received state is somehow
>> + *   invalid and cannot be processed by the back-end
>> + *
>> + * @dev: The vhost device
>> + * @errp: Potential error description
>> + *
>> + * Returns 0 when the back-end reports successful state transfer and
>> + * processing, and -errno when an error occurred somewhere.
>> + */
>> +int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
>> +

