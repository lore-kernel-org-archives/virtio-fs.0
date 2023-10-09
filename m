Return-Path: <hreitz@redhat.com>
Message-ID: <8f3694c1-48d4-f34b-8f91-3bc217182ffa@redhat.com>
Date: Mon, 9 Oct 2023 11:07:50 +0200
MIME-Version: 1.0
From: Hanna Czenczek <hreitz@redhat.com>
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
In-Reply-To: <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, parav@nvidia.com, maxime.coquelin@redhat.com, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>

On 09.10.23 10:21, Hanna Czenczek wrote:
> On 07.10.23 04:22, Yajun Wu wrote:

[...]

>> The main motivation of adding VHOST_USER_SET_STATUS is to let backend 
>> DPDK know
>> when DRIVER_OK bit is valid. It's an indication of all VQ 
>> configuration has sent,
>> otherwise DPDK has to rely on first queue pair is ready, then 
>> receiving/applying
>> VQ configuration one by one.
>>
>> During live migration, configuring VQ one by one is very time consuming.
>
> One question I have here is why it wasn’t then introduced in the live 
> migration code, but in the general VM stop/cont code instead. It does 
> seem time-consuming to do this every time the VM is paused and resumed.
>
>> For VIRTIO
>> net vDPA, HW needs to know how many VQs are enabled to set 
>> RSS(Receive-Side Scaling).
>>
>> If you don’t want SET_STATUS message, backend can remove protocol 
>> feature bit
>> VHOST_USER_PROTOCOL_F_STATUS.
>
> The problem isn’t back-ends that don’t want the message, the problem 
> is that qemu uses the message wrongly, which prevents well-behaving 
> back-ends from implementing the message.
>
>> DPDK is ignoring SET_STATUS 0, but using GET_VRING_BASE to do device 
>> close/reset.
>
> So the right thing to do for back-ends is to announce STATUS support 
> and then not implement it correctly?
>
> GET_VRING_BASE should not reset the close or reset the device, by the 
> way.  It should stop that one vring, not more.  We have a RESET_DEVICE 
> command for resetting.
>
>> I'm not involved in discussion about adding SET_STATUS in Vhost 
>> protocol. This feature
>> is essential for vDPA(same as vhost-vdpa implements 
>> VHOST_VDPA_SET_STATUS).
>
> So from what I gather from your response is that there is only a 
> single use for SET_STATUS, which is the DRIVER_OK bit.  If so, 
> documenting that all other bits are to be ignored by both back-end and 
> front-end would be fine by me.
>
> I’m not fully serious about that suggestion, but I hear the strong 
> implication that nothing but DRIVER_OK was of any concern, and this is 
> really important to note when we talk about the status of the STATUS 
> feature in vhost today.  It seems to me now that it was not intended 
> to be the virtio-level status byte, but just a DRIVER_OK signalling 
> path from front-end to back-end.  That makes it a vhost-level protocol 
> feature to me.

On second thought, it just is a pure vhost-level protocol feature, and 
has nothing to do with the virtio status byte as-is.  The only stated 
purpose is for the front-end to send DRIVER_OK after migration, but 
migration is transparent to the guest, so the guest would never change 
the status byte during migration.  Therefore, if this feature is 
essential, we will never be able to have a status byte that is 
transparently shared between guest and back-end device, i.e. the virtio 
status byte.

Cc-ing Alex on this mail, because to me, this seems like an important 
detail when he plans on using the byte in the future.  If we need a 
virtio status byte, I can’t see how we could use the existing F_STATUS 
for it.

Hanna

