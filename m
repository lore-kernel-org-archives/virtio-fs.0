Return-Path: <hreitz@redhat.com>
Message-ID: <9a36a319-4567-f297-f14a-2025792ae93f@redhat.com>
Date: Tue, 10 Oct 2023 10:18:29 +0200
MIME-Version: 1.0
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-2-hreitz@redhat.com> <20231005170852.GB1342722@fedora>
 <20231005131352-mutt-send-email-mst@kernel.org>
 <00272da3-0a48-5544-6ba8-5dfde00be241@redhat.com>
 <20231006043518-mutt-send-email-mst@kernel.org>
 <a8b9d842-0925-38d0-2f0d-f2560bab251b@redhat.com>
 <20231006051802-mutt-send-email-mst@kernel.org>
 <a4af0357-12ee-fc7f-e249-239da34409b0@redhat.com>
 <20231006055229-mutt-send-email-mst@kernel.org>
 <e35f9f71-8d9d-6250-cbaa-70412b5a1149@nvidia.com>
 <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
 <8f3694c1-48d4-f34b-8f91-3bc217182ffa@redhat.com>
 <e19eb113-89b1-92ed-3375-8bc93c1ff39c@redhat.com>
 <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Yajun Wu <yajunw@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Parav Pandit <parav@nvidia.com>, "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>

On 10.10.23 06:00, Yajun Wu wrote:
>
> On 10/9/2023 5:13 PM, Hanna Czenczek wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 09.10.23 11:07, Hanna Czenczek wrote:
>>> On 09.10.23 10:21, Hanna Czenczek wrote:
>>>> On 07.10.23 04:22, Yajun Wu wrote:
>>> [...]
>>>
>>>>> The main motivation of adding VHOST_USER_SET_STATUS is to let
>>>>> backend DPDK know
>>>>> when DRIVER_OK bit is valid. It's an indication of all VQ
>>>>> configuration has sent,
>>>>> otherwise DPDK has to rely on first queue pair is ready, then
>>>>> receiving/applying
>>>>> VQ configuration one by one.
>>>>>
>>>>> During live migration, configuring VQ one by one is very time
>>>>> consuming.
>>>> One question I have here is why it wasn’t then introduced in the live
>>>> migration code, but in the general VM stop/cont code instead. It does
>>>> seem time-consuming to do this every time the VM is paused and 
>>>> resumed.
>
> Yes, VM stop/cont will call vhost_net_stop/vhost_net_start. Maybe 
> because there's no device level stop/cont vhost message?

No, it is because qemu will reset the status in stop/cont*, which it 
should not do.  Aside from guest-initiated resets, the only thing where 
a reset comes into play is when the back-end is changed, e.g. during 
migration.  In that case, the source back-end will see a disconnect on 
the vhost-user socket and can then do whatever uninitialization it needs 
to do, and the destination front-end will need to be reconfigured by 
qemu anyway, because it’s just a case of the destination qemu initiating 
a fresh connection to a new back-end (except that it will need to 
restore the state from the source).

*Yes, technically, dpdk will ignore that reset, but it still stops the 
device on a different message (when it should just pause processing 
vrings), so the outcome is the same.

>>>>
>>>>> For VIRTIO
>>>>> net vDPA, HW needs to know how many VQs are enabled to set
>>>>> RSS(Receive-Side Scaling).
>>>>>
>>>>> If you don’t want SET_STATUS message, backend can remove protocol
>>>>> feature bit
>>>>> VHOST_USER_PROTOCOL_F_STATUS.
>>>> The problem isn’t back-ends that don’t want the message, the problem
>>>> is that qemu uses the message wrongly, which prevents well-behaving
>>>> back-ends from implementing the message.
>>>>
>>>>> DPDK is ignoring SET_STATUS 0, but using GET_VRING_BASE to do device
>>>>> close/reset.
>>>> So the right thing to do for back-ends is to announce STATUS support
>>>> and then not implement it correctly?
>>>>
>>>> GET_VRING_BASE should not reset the close or reset the device, by the
>>>> way.  It should stop that one vring, not more.  We have a
>>>> RESET_DEVICE command for resetting.
> I believe dpdk uses GET_VRING_BASE long before qemu has RESET_DEVICE? 

I don’t think it matters who came first.  What matters is the 
specification, and that dpdk decided to rely on implementation-specific 
behavior without having all involved parties agree by matters of putting 
that in the specification.  And now dpdk clearly deviates from the 
specification as a result of that action, which can result in problems 
if the front-end doesn’t do what qemu always used to do.  (E.g. the 
front-end might just send GET_VRING_BASE for all vrings when suspending 
the guest, and then only send kicks on resume to re-start the vrings.  
dpdk would most likely be left in a state where the whole device is 
stopped, expecting DRIVER_OK.  Same thing in general for front-ends that 
don’t support F_STATUS.)

> It's a compatible issue. For new backend implements, we can have 
> better solution, right?

The fact that dpdk and qemu deviate from the specification is a problem 
as-is.

>>>>> I'm not involved in discussion about adding SET_STATUS in Vhost
>>>>> protocol. This feature
>>>>> is essential for vDPA(same as vhost-vdpa implements
>>>>> VHOST_VDPA_SET_STATUS).
>>>> So from what I gather from your response is that there is only a
>>>> single use for SET_STATUS, which is the DRIVER_OK bit.  If so,
>>>> documenting that all other bits are to be ignored by both back-end
>>>> and front-end would be fine by me.
>>>>
>>>> I’m not fully serious about that suggestion, but I hear the strong
>>>> implication that nothing but DRIVER_OK was of any concern, and this
>>>> is really important to note when we talk about the status of the
>>>> STATUS feature in vhost today.  It seems to me now that it was not
>>>> intended to be the virtio-level status byte, but just a DRIVER_OK
>>>> signalling path from front-end to back-end.  That makes it a
>>>> vhost-level protocol feature to me.
>>> On second thought, it just is a pure vhost-level protocol feature, and
>>> has nothing to do with the virtio status byte as-is.  The only stated
>>> purpose is for the front-end to send DRIVER_OK after migration, but
>>> migration is transparent to the guest, so the guest would never change
>>> the status byte during migration.  Therefore, if this feature is
>>> essential, we will never be able to have a status byte that is
>>> transparently shared between guest and back-end device, i.e. the
>>> virtio status byte.
>> On third thought, scratch that.  The guest wouldn’t set it, but
>> naturally, after migration, the front-end will need to restore the
>> status byte from the source, so the front-end will always need to set
>> it, even if it were otherwise used controlled only by the guest and the
>> back-end device.  So technically, this doesn’t prevent such a use case.
>> (In practice, it isn’t controlled by the guest right now, but that could
>> be fixed.)
> I only tested the feature with DPDK(the only backend use it today?). 
> Max defined the protocol and added the corresponding code in DPDK 
> before I added QEMU support. If other backend or different device type 
> want to use this, we can have further discussion?

So as far as I understand, the feature is supposed to rely on 
implementation-specific behavior between specifically qemu as a 
front-end and dpdk as a back-end, nothing else.  Honestly, that to me is 
a very good reason to deprecate it.  That would make it clear that any 
implementation that implements it does so because it relies on 
implementation-specific behavior from other implementations.

Option 2 is to fix it.  It is not right to use this broadly defined 
feature with its clear protocol as given in the virtio specification 
just to set and clear a single bit (DRIVER_OK).  The vhost-user 
specification points to that virtio protocol.  We must adhere to the 
protocol.  And note that we must not reset devices just because the VM 
is paused/resumed.  (That is why I wanted to deprecate SET_STATUS, so 
that Stefan’s series would introduce RESET_DEVICE where we need it, and 
we can (for now) ignore the SET_STATUS 0 in vhost_dev_stop().)

Option 3 would be to just be honest in the specification, and limit the 
scope of F_STATUS to say the only bit that matters is DRIVER_OK.  I 
would say this is not really different from deprecating, though it 
wouldn’t affect your case.  However, I understand Alex relies on a full 
status byte.  I’m still interested to know why that is.

Option 4 is of course not to do anything, and leave everything as-is, 
waiting for the next person to stir the hornet’s nest.

>>> Cc-ing Alex on this mail, because to me, this seems like an important
>>> detail when he plans on using the byte in the future. If we need a
>>> virtio status byte, I can’t see how we could use the existing F_STATUS
>>> for it.
>>>
>>> Hanna
>

