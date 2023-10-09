Return-Path: <hreitz@redhat.com>
Message-ID: <1a681baf-b78b-f46e-1925-e69bfbcfcaff@redhat.com>
Date: Mon, 9 Oct 2023 10:07:12 +0200
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
 <d9c2d2c4-5ab3-a3f3-8925-155e1c4ff73a@redhat.com> <87il7jg4oe.fsf@linaro.org>
 <2ba3ef6b-4af1-9c65-f542-bfcc8412e99c@redhat.com> <875y3j4gmu.fsf@linaro.org>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <875y3j4gmu.fsf@linaro.org>
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
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Yajun Wu <yajunw@nvidia.com>

On 06.10.23 22:49, Alex Bennée wrote:
> Hanna Czenczek <hreitz@redhat.com> writes:
>
>> On 06.10.23 17:17, Alex Bennée wrote:
>>> Hanna Czenczek <hreitz@redhat.com> writes:
>>>
>>>> On 06.10.23 12:34, Michael S. Tsirkin wrote:
>>>>> On Fri, Oct 06, 2023 at 11:47:55AM +0200, Hanna Czenczek wrote:
>>>>>> On 06.10.23 11:26, Michael S. Tsirkin wrote:
>>>>>>> On Fri, Oct 06, 2023 at 11:15:55AM +0200, Hanna Czenczek wrote:
>>>>>>>> On 06.10.23 10:45, Michael S. Tsirkin wrote:
>>>>>>>>> On Fri, Oct 06, 2023 at 09:48:14AM +0200, Hanna Czenczek wrote:
>>>>>>>>>> On 05.10.23 19:15, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Thu, Oct 05, 2023 at 01:08:52PM -0400, Stefan Hajnoczi wrote:
>>>>>>>>>>>> On Wed, Oct 04, 2023 at 02:58:57PM +0200, Hanna Czenczek wrote:
>>> <snip>
>>>>>> What I’m saying is, 923b8921d21 introduced SET_STATUS calls that broke all
>>>>>> devices that would implement them as per virtio spec, and even today it’s
>>>>>> broken for stateful devices.  The mentioned performance issue is likely
>>>>>> real, but we can’t address it by making up SET_STATUS calls that are wrong.
>>>>>>
>>>>>> I concede that I didn’t think about DRIVER_OK.  Personally, I would do all
>>>>>> final configuration that would happen upon a DRIVER_OK once the first vring
>>>>>> is started (i.e. receives a kick).  That has the added benefit of being
>>>>>> asynchronous because it doesn’t block any vhost-user messages (which are
>>>>>> synchronous, and thus block downtime).
>>>>>>
>>>>>> Hanna
>>>>> For better or worse kick is per ring. It's out of spec to start rings
>>>>> that were not kicked but I guess you could do configuration ...
>>>>> Seems somewhat asymmetrical though.
>>>> I meant to take the first ring being started as the signal to do the
>>>> global configuration, i.e. not do this once per vring, but once
>>>> globally.
>>>>
>>>>> Let's wait until next week, hopefully Yajun Wu will answer.
>>>> I mean, personally I don’t really care about the whole SET_STATUS
>>>> thing.  It’s clear that it’s broken for stateful devices.  The fact
>>>> that it took until 6f8be29ec17d to fix it for just any device that
>>>> would implement it according to spec to me is a strong indication that
>>>> nobody does implement it according to spec, and is currently only used
>>>> to signal to some specific back-end that all rings have been set up
>>>> and should be configured in a single block.
>>> I'm certainly using [GS]ET_STATUS for the proposed F_TRANSPORT
>>> extensions where everything is off-loaded to the vhost-user backend.
>> How do these back-ends work with the fact that qemu uses SET_STATUS
>> incorrectly when not offloading?  Do you plan on fixing that?
> Mainly having a common base implementation which does it right and
> having very lightweight derivations for legacy stubs using it. The
> aim is to eliminate the need for QEMU stubs entirely by fully specifying
> the device from the vhost-user API.

If the current SET_STATUS use is overhauled, too, that would be good.  I 
wonder why you need the status byte, though.

>> (I.e. that we send SET_STATUS 0 when the VM is paused, potentially
>> resetting state that is not recoverable, and that we set DRIVER and
>> DRIVER_OK simultaneously.)
> This is QEMU simulating a SET_STATUS rather than the guest triggering
> it?

Yes, and the fact that we simulate it when the guest will not have 
triggered it, i.e. we reset the device (SET_STATUS 0) when the VM is 
paused.  Effectively, qemu injects virtio commands that the guest has 
never requested, which generally feels like a bad idea, because qemu 
will need to get the device back to its previous state before the guest 
is resumed, which may or may not work.  Specifically, it won’t work for 
devices that have internal state.

Furthermore, we use SET_STATUS to set ACKNOWLEDGE | DRIVER | DRIVER_OK 
simultaneously, which is wrong.  ACKNOWLEDGE | DRIVER may perhaps be set 
simultaneously, but then comes feature negotiation (setting and checking 
FEATURES_OK), and then DRIVER_OK.

Finally, how the status byte is to be used is not noted in the 
vhost-user specification, which instead points to the virtio 
specification.  I think if we keep SET_STATUS, it must be documented how 
it interacts with other vhost-user commands.  For example, how the 
FEATURES_OK protocol described in the virtio specification interacts 
with GET_FEATURES/SET_FEATURES, or whether SET_STATUS 0 and RESET_DEVICE 
are equivalent.  Currently, the only implementation of SET_STATUS I know 
(DPDK) ignores SET_STATUS 0, i.e. doesn’t do a reset.  To me that 
indicates that the spec must be clear on what these status values mean 
with regards to the vhost-user protocol as a whole.

So every software implementation with STATUS support that I know 
implements SET_STATUS wrongly right now, and that’s a problem, because 
it prevents implementations like virtiofsd from doing so correctly.

Hanna

