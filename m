Return-Path: <yajunw@nvidia.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8Zra/PXAjHgVIJjRuvANURR7Xa9CdizTuESxTAbytI=;
 b=oP/wT+jjPSTz8+WG+6czvAEOcmnSLSc/NTkgrexcr/9pZKjGo9SqKwf6mYkASKTm0DAwwila+hZj0XsklPGIqDaJxASRFA1JIyCA81ctLzsFnCkGYR6Z0ap5/fLIsXrtG4VTvJ7d7O9GKJ+XUGTYgZOuSGjMHPywEJe8xQizDCJocmhuD+tt85qgBw/4+karb0WwZ/Eg699imnGoO/zsXnXxUSbKJaXLWed/xi+TDt1YSZno4UFYF2niqEeDivxEuDfVbjFyJD6dN4qCszOKGPiHryHHJs8rWcEY79rcDE3X+iSRdPLXr/2m0DCP2g72amBNXhWW3wVdSiRntTiXRA==
Message-ID: <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
Date: Tue, 10 Oct 2023 12:00:22 +0800
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
From: Yajun Wu <yajunw@nvidia.com>
In-Reply-To: <e19eb113-89b1-92ed-3375-8bc93c1ff39c@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Parav Pandit <parav@nvidia.com>, "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>


On 10/9/2023 5:13 PM, Hanna Czenczek wrote:
> External email: Use caution opening links or attachments
>
>
> On 09.10.23 11:07, Hanna Czenczek wrote:
>> On 09.10.23 10:21, Hanna Czenczek wrote:
>>> On 07.10.23 04:22, Yajun Wu wrote:
>> [...]
>>
>>>> The main motivation of adding VHOST_USER_SET_STATUS is to let
>>>> backend DPDK know
>>>> when DRIVER_OK bit is valid. It's an indication of all VQ
>>>> configuration has sent,
>>>> otherwise DPDK has to rely on first queue pair is ready, then
>>>> receiving/applying
>>>> VQ configuration one by one.
>>>>
>>>> During live migration, configuring VQ one by one is very time
>>>> consuming.
>>> One question I have here is why it wasn=E2=80=99t then introduced in th=
e live
>>> migration code, but in the general VM stop/cont code instead. It does
>>> seem time-consuming to do this every time the VM is paused and resumed.

Yes, VM stop/cont will call vhost_net_stop/vhost_net_start. Maybe=20
because there's no device level stop/cont vhost message?

>>>
>>>> For VIRTIO
>>>> net vDPA, HW needs to know how many VQs are enabled to set
>>>> RSS(Receive-Side Scaling).
>>>>
>>>> If you don=E2=80=99t want SET_STATUS message, backend can remove proto=
col
>>>> feature bit
>>>> VHOST_USER_PROTOCOL_F_STATUS.
>>> The problem isn=E2=80=99t back-ends that don=E2=80=99t want the message=
, the problem
>>> is that qemu uses the message wrongly, which prevents well-behaving
>>> back-ends from implementing the message.
>>>
>>>> DPDK is ignoring SET_STATUS 0, but using GET_VRING_BASE to do device
>>>> close/reset.
>>> So the right thing to do for back-ends is to announce STATUS support
>>> and then not implement it correctly?
>>>
>>> GET_VRING_BASE should not reset the close or reset the device, by the
>>> way.  It should stop that one vring, not more.  We have a
>>> RESET_DEVICE command for resetting.
I believe dpdk uses GET_VRING_BASE long before qemu has RESET_DEVICE?=20
It's a compatible issue. For new backend implements, we can have better=20
solution, right?
>>>> I'm not involved in discussion about adding SET_STATUS in Vhost
>>>> protocol. This feature
>>>> is essential for vDPA(same as vhost-vdpa implements
>>>> VHOST_VDPA_SET_STATUS).
>>> So from what I gather from your response is that there is only a
>>> single use for SET_STATUS, which is the DRIVER_OK bit.  If so,
>>> documenting that all other bits are to be ignored by both back-end
>>> and front-end would be fine by me.
>>>
>>> I=E2=80=99m not fully serious about that suggestion, but I hear the str=
ong
>>> implication that nothing but DRIVER_OK was of any concern, and this
>>> is really important to note when we talk about the status of the
>>> STATUS feature in vhost today.  It seems to me now that it was not
>>> intended to be the virtio-level status byte, but just a DRIVER_OK
>>> signalling path from front-end to back-end.  That makes it a
>>> vhost-level protocol feature to me.
>> On second thought, it just is a pure vhost-level protocol feature, and
>> has nothing to do with the virtio status byte as-is.  The only stated
>> purpose is for the front-end to send DRIVER_OK after migration, but
>> migration is transparent to the guest, so the guest would never change
>> the status byte during migration.  Therefore, if this feature is
>> essential, we will never be able to have a status byte that is
>> transparently shared between guest and back-end device, i.e. the
>> virtio status byte.
> On third thought, scratch that.  The guest wouldn=E2=80=99t set it, but
> naturally, after migration, the front-end will need to restore the
> status byte from the source, so the front-end will always need to set
> it, even if it were otherwise used controlled only by the guest and the
> back-end device.  So technically, this doesn=E2=80=99t prevent such a use=
 case.
> (In practice, it isn=E2=80=99t controlled by the guest right now, but tha=
t could
> be fixed.)
I only tested the feature with DPDK(the only backend use it today?). Max=20
defined the protocol and added the corresponding code in DPDK before I=20
added QEMU support. If other backend or different device type want to=20
use this, we can have further discussion?
>> Cc-ing Alex on this mail, because to me, this seems like an important
>> detail when he plans on using the byte in the future. If we need a
>> virtio status byte, I can=E2=80=99t see how we could use the existing F_=
STATUS
>> for it.
>>
>> Hanna

