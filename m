Return-Path: <hreitz@redhat.com>
Message-ID: <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
Date: Mon, 9 Oct 2023 10:21:51 +0200
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
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <e35f9f71-8d9d-6250-cbaa-70412b5a1149@nvidia.com>
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, parav@nvidia.com, maxime.coquelin@redhat.com

On 07.10.23 04:22, Yajun Wu wrote:
>
> On 10/6/2023 6:34 PM, Michael S. Tsirkin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Fri, Oct 06, 2023 at 11:47:55AM +0200, Hanna Czenczek wrote:
>>> On 06.10.23 11:26, Michael S. Tsirkin wrote:
>>>> On Fri, Oct 06, 2023 at 11:15:55AM +0200, Hanna Czenczek wrote:
>>>>> On 06.10.23 10:45, Michael S. Tsirkin wrote:
>>>>>> On Fri, Oct 06, 2023 at 09:48:14AM +0200, Hanna Czenczek wrote:
>>>>>>> On 05.10.23 19:15, Michael S. Tsirkin wrote:
>>>>>>>> On Thu, Oct 05, 2023 at 01:08:52PM -0400, Stefan Hajnoczi wrote:
>>>>>>>>> On Wed, Oct 04, 2023 at 02:58:57PM +0200, Hanna Czenczek wrote:
>>>>>>>>>> There is no clearly defined purpose for the virtio status 
>>>>>>>>>> byte in
>>>>>>>>>> vhost-user: For resetting, we already have RESET_DEVICE; and 
>>>>>>>>>> for virtio
>>>>>>>>>> feature negotiation, we have [GS]ET_FEATURES. With the REPLY_ACK
>>>>>>>>>> protocol extension, it is possible for SET_FEATURES to return 
>>>>>>>>>> errors
>>>>>>>>>> (SET_PROTOCOL_FEATURES may be called before SET_FEATURES).
>>>>>>>>>>
>>>>>>>>>> As for implementations, SET_STATUS is not widely 
>>>>>>>>>> implemented.  dpdk does
>>>>>>>>>> implement it, but only uses it to signal feature negotiation 
>>>>>>>>>> failure.
>>>>>>>>>> While it does log reset requests (SET_STATUS 0) as such, it 
>>>>>>>>>> effectively
>>>>>>>>>> ignores them, in contrast to RESET_OWNER (which is 
>>>>>>>>>> deprecated, and today
>>>>>>>>>> means the same thing as RESET_DEVICE).
>>>>>>>>>>
>>>>>>>>>> While qemu superficially has support for [GS]ET_STATUS, it 
>>>>>>>>>> does not
>>>>>>>>>> forward the guest-set status byte, but instead just makes it up
>>>>>>>>>> internally, and actually completely ignores what the back-end 
>>>>>>>>>> returns,
>>>>>>>>>> only using it as the template for a subsequent SET_STATUS to 
>>>>>>>>>> add single
>>>>>>>>>> bits to it.  Notably, after setting FEATURES_OK, it never 
>>>>>>>>>> reads it back
>>>>>>>>>> to see whether the flag is still set, which is the only way 
>>>>>>>>>> in which
>>>>>>>>>> dpdk uses the status byte.
>>>>>>>>>>
>>>>>>>>>> As-is, no front-end or back-end can rely on the other side 
>>>>>>>>>> handling this
>>>>>>>>>> field in a useful manner, and it also provides no practical 
>>>>>>>>>> use over
>>>>>>>>>> other mechanisms the vhost-user protocol has, which are more 
>>>>>>>>>> clearly
>>>>>>>>>> defined.  Deprecate it.
>>>>>>>>>>
>>>>>>>>>> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>>>>>>>>>> ---
>>>>>>>>>>      docs/interop/vhost-user.rst | 28 
>>>>>>>>>> +++++++++++++++++++++-------
>>>>>>>>>>      1 file changed, 21 insertions(+), 7 deletions(-)
>>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>> SET_STATUS is the only way to signal failure to acknowledge 
>>>>>>>> FEATURES_OK.
>>>>>>>> The fact current backends never check errors does not mean they 
>>>>>>>> never
>>>>>>>> will. So no, not applying this.
>>>>>>> Can this not be done with REPLY_ACK?  I.e., with the following 
>>>>>>> message
>>>>>>> order:
>>>>>>>
>>>>>>> 1. GET_FEATURES to find out whether 
>>>>>>> VHOST_USER_F_PROTOCOL_FEATURES is
>>>>>>> present
>>>>>>> 2. GET_PROTOCOL_FEATURES to hopefully get 
>>>>>>> VHOST_USER_PROTOCOL_F_REPLY_ACK
>>>>>>> 3. SET_PROTOCOL_FEATURES to set VHOST_USER_PROTOCOL_F_REPLY_ACK
>>>>>>> 4. SET_FEATURES with need_reply
>>>>>>>
>>>>>>> If not, the problem is that qemu has sent SET_STATUS 0 for a 
>>>>>>> while when the
>>>>>>> vCPUs are stopped, which generally seems to request a device 
>>>>>>> reset.  If we
>>>>>>> don’t state at least that SET_STATUS 0 is to be ignored, 
>>>>>>> back-ends that will
>>>>>>> implement SET_STATUS later may break with at least these qemu 
>>>>>>> versions.  But
>>>>>>> documenting that a particular use of the status byte is to be 
>>>>>>> ignored would
>>>>>>> be really strange.
>>>>>>>
>>>>>>> Hanna
>>>>>> Hmm I guess. Though just following virtio spec seems cleaner to 
>>>>>> me...
>>>>>> vhost-user reconfigures the state fully on start.
>>>>> Not the internal device state, though.  virtiofsd has internal 
>>>>> state, and
>>>>> other devices like vhost-gpu back-ends would probably, too.
>>>>>
>>>>> Stefan has recently sent a series
>>>>> (https://lists.nongnu.org/archive/html/qemu-devel/2023-10/msg00709.html) 
>>>>> to
>>>>> put the reset (RESET_DEVICE) into virtio_reset() (when we really 
>>>>> need a
>>>>> reset).
>>>>>
>>>>> I really don’t like our current approach with the status byte. 
>>>>> Following the
>>>>> virtio specification to me would mean that the guest directly 
>>>>> controls this
>>>>> byte, which it does not.  qemu makes up values as it deems 
>>>>> appropriate, and
>>>>> this includes sending a SET_STATUS 0 when the guest is just 
>>>>> paused, i.e.
>>>>> when the guest really doesn’t want a device reset.
>>>>>
>>>>> That means that qemu does not treat this as a virtio device field 
>>>>> (because
>>>>> that would mean exposing it to the guest driver), but instead 
>>>>> treats it as
>>>>> part of the vhost(-user) protocol.  It doesn’t feel right to me 
>>>>> that we use
>>>>> a virtio-defined feature for communication on the vhost level, 
>>>>> i.e. between
>>>>> front-end and back-end, and not between guest driver and device.  
>>>>> I think
>>>>> all vhost-level protocol features should be fully defined in the 
>>>>> vhost-user
>>>>> specification, which REPLY_ACK is.
>>>> Hmm that makes sense. Maybe we should have done what stefan's patch
>>>> is doing.
>>>>
>>>> Do look at the original commit that introduced it to understand why
>>>> it was added.
>>> I don’t understand why this was added to the stop/cont code, 
>>> though.  If it
>>> is time consuming to make these changes, why are they done every 
>>> time the VM
>>> is paused
>>> and resumed?  It makes sense that this would be done for the initial
>>> configuration (where a reset also wouldn’t hurt), but here it seems 
>>> wrong.
>>>
>>> (To be clear, a reset in the stop/cont code is wrong, because it breaks
>>> stateful devices.)
>>>
>>> Also, note the newer commits 6f8be29ec17 and c3716f260bf.  The reset as
>>> originally introduced was wrong even for non-stateful devices, 
>>> because it
>>> occurred before we fetched the state (vring indices) so we could 
>>> restore it
>>> later.  I don’t know how 923b8921d21 was tested, but if the back-end 
>>> used
>>> for testing implemented SET_STATUS 0 as a reset, it could not have 
>>> survived
>>> either migration or a stop/cont in general, because the vring 
>>> indices would
>>> have been reset to 0.
>>>
>>> What I’m saying is, 923b8921d21 introduced SET_STATUS calls that 
>>> broke all
>>> devices that would implement them as per virtio spec, and even today 
>>> it’s
>>> broken for stateful devices.  The mentioned performance issue is likely
>>> real, but we can’t address it by making up SET_STATUS calls that are 
>>> wrong.
>>>
>>> I concede that I didn’t think about DRIVER_OK.  Personally, I would 
>>> do all
>>> final configuration that would happen upon a DRIVER_OK once the 
>>> first vring
>>> is started (i.e. receives a kick).  That has the added benefit of being
>>> asynchronous because it doesn’t block any vhost-user messages (which 
>>> are
>>> synchronous, and thus block downtime).
>>>
>>> Hanna
>>
>> For better or worse kick is per ring. It's out of spec to start rings
>> that were not kicked but I guess you could do configuration ...
>> Seems somewhat asymmetrical though.
>>
>> Let's wait until next week, hopefully Yajun Wu will answer.
> The main motivation of adding VHOST_USER_SET_STATUS is to let backend 
> DPDK know
> when DRIVER_OK bit is valid. It's an indication of all VQ 
> configuration has sent,
> otherwise DPDK has to rely on first queue pair is ready, then 
> receiving/applying
> VQ configuration one by one.
>
> During live migration, configuring VQ one by one is very time consuming.

One question I have here is why it wasn’t then introduced in the live 
migration code, but in the general VM stop/cont code instead. It does 
seem time-consuming to do this every time the VM is paused and resumed.

> For VIRTIO
> net vDPA, HW needs to know how many VQs are enabled to set 
> RSS(Receive-Side Scaling).
>
> If you don’t want SET_STATUS message, backend can remove protocol 
> feature bit
> VHOST_USER_PROTOCOL_F_STATUS.

The problem isn’t back-ends that don’t want the message, the problem is 
that qemu uses the message wrongly, which prevents well-behaving 
back-ends from implementing the message.

> DPDK is ignoring SET_STATUS 0, but using GET_VRING_BASE to do device 
> close/reset.

So the right thing to do for back-ends is to announce STATUS support and 
then not implement it correctly?

GET_VRING_BASE should not reset the close or reset the device, by the 
way.  It should stop that one vring, not more.  We have a RESET_DEVICE 
command for resetting.

> I'm not involved in discussion about adding SET_STATUS in Vhost 
> protocol. This feature
> is essential for vDPA(same as vhost-vdpa implements 
> VHOST_VDPA_SET_STATUS).

So from what I gather from your response is that there is only a single 
use for SET_STATUS, which is the DRIVER_OK bit.  If so, documenting that 
all other bits are to be ignored by both back-end and front-end would be 
fine by me.

I’m not fully serious about that suggestion, but I hear the strong 
implication that nothing but DRIVER_OK was of any concern, and this is 
really important to note when we talk about the status of the STATUS 
feature in vhost today.  It seems to me now that it was not intended to 
be the virtio-level status byte, but just a DRIVER_OK signalling path 
from front-end to back-end.  That makes it a vhost-level protocol 
feature to me.

Hanna

>
> Thanks,
> Yajun
>>
>>>>> Now, we could hand full control of the status byte to the guest, 
>>>>> and that
>>>>> would make me content.  But I feel like that doesn’t really work, 
>>>>> because
>>>>> qemu needs to intercept the status byte anyway (it needs to know 
>>>>> when there
>>>>> is a reset, probably wants to know when the device is configured, 
>>>>> etc.), so
>>>>> I don’t think having the status byte in vhost-user really gains us 
>>>>> much when
>>>>> qemu could translate status byte changes to/from other vhost-user 
>>>>> commands.
>>>>>
>>>>> Hanna
>>>> well it intercepts it but I think it could pass it on unchanged.
>>>>
>>>>
>>>>>> I guess symmetry was the
>>>>>> point. So I don't see why SET_STATUS 0 has to be ignored.
>>>>>>
>>>>>>
>>>>>> SET_STATUS was introduced by:
>>>>>>
>>>>>> commit 923b8921d210763359e96246a58658ac0db6c645
>>>>>> Author: Yajun Wu <yajunw@nvidia.com>
>>>>>> Date:   Mon Oct 17 14:44:52 2022 +0800
>>>>>>
>>>>>>        vhost-user: Support vhost_dev_start
>>>>>>
>>>>>> CC the author.
>>>>>>
>

