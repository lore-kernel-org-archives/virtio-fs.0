Return-Path: <hreitz@redhat.com>
Message-ID: <7a959ff0-8b7c-2a9e-8023-8e541bf427d8@redhat.com>
Date: Tue, 9 May 2023 10:59:07 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <71e47e3e-880d-38d8-c1b0-3287c60365e4@redhat.com>
 <CAJaqyWe13QxuC9BNBULJ1xu1saWE9Y3ET8eEef-7qtyL5R73SQ@mail.gmail.com>
 <f04ed41d-39b6-a4e8-dfa5-c3e4936302ca@redhat.com>
 <d25a7982-cfca-6c6b-5dff-1a197fa0d262@redhat.com>
 <CAJaqyWcf-U4tB3FxPWBKHh02ZNk7nEfLiZ=cnns8AdHSasv6CA@mail.gmail.com>
 <CAJaqyWc19cpOx7pFqC3e4fy=NNWVtDKNziLJfTo3p9sT-SvLRw@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJaqyWc19cpOx7pFqC3e4fy=NNWVtDKNziLJfTo3p9sT-SvLRw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 08.05.23 21:31, Eugenio Perez Martin wrote:
> On Mon, May 8, 2023 at 7:51 PM Eugenio Perez Martin <eperezma@redhat.com> wrote:
>> On Mon, May 8, 2023 at 7:00 PM Hanna Czenczek <hreitz@redhat.com> wrote:
>>> On 05.05.23 16:37, Hanna Czenczek wrote:
>>>> On 05.05.23 16:26, Eugenio Perez Martin wrote:
>>>>> On Fri, May 5, 2023 at 11:51 AM Hanna Czenczek <hreitz@redhat.com>
>>>>> wrote:
>>>>>> (By the way, thanks for the explanations :))
>>>>>>
>>>>>> On 05.05.23 11:03, Hanna Czenczek wrote:
>>>>>>> On 04.05.23 23:14, Stefan Hajnoczi wrote:
>>>>>> [...]
>>>>>>
>>>>>>>> I think it's better to change QEMU's vhost code
>>>>>>>> to leave stateful devices suspended (but not reset) across
>>>>>>>> vhost_dev_stop() -> vhost_dev_start(), maybe by introducing
>>>>>>>> vhost_dev_suspend() and vhost_dev_resume(). Have you thought about
>>>>>>>> this aspect?
>>>>>>> Yes and no; I mean, I haven’t in detail, but I thought this is what’s
>>>>>>> meant by suspending instead of resetting when the VM is stopped.
>>>>>> So, now looking at vhost_dev_stop(), one problem I can see is that
>>>>>> depending on the back-end, different operations it does will do
>>>>>> different things.
>>>>>>
>>>>>> It tries to stop the whole device via vhost_ops->vhost_dev_start(),
>>>>>> which for vDPA will suspend the device, but for vhost-user will
>>>>>> reset it
>>>>>> (if F_STATUS is there).
>>>>>>
>>>>>> It disables all vrings, which doesn’t mean stopping, but may be
>>>>>> necessary, too.  (I haven’t yet really understood the use of disabled
>>>>>> vrings, I heard that virtio-net would have a need for it.)
>>>>>>
>>>>>> It then also stops all vrings, though, so that’s OK.  And because this
>>>>>> will always do GET_VRING_BASE, this is actually always the same
>>>>>> regardless of transport.
>>>>>>
>>>>>> Finally (for this purpose), it resets the device status via
>>>>>> vhost_ops->vhost_reset_status().  This is only implemented on vDPA, and
>>>>>> this is what resets the device there.
>>>>>>
>>>>>>
>>>>>> So vhost-user resets the device in .vhost_dev_start, but vDPA only does
>>>>>> so in .vhost_reset_status.  It would seem better to me if vhost-user
>>>>>> would also reset the device only in .vhost_reset_status, not in
>>>>>> .vhost_dev_start.  .vhost_dev_start seems precisely like the place to
>>>>>> run SUSPEND/RESUME.
>>>>>>
>>>>> I think the same. I just saw It's been proposed at [1].
>>>>>
>>>>>> Another question I have (but this is basically what I wrote in my last
>>>>>> email) is why we even call .vhost_reset_status here.  If the device
>>>>>> and/or all of the vrings are already stopped, why do we need to reset
>>>>>> it?  Naïvely, I had assumed we only really need to reset the device if
>>>>>> the guest changes, so that a new guest driver sees a freshly
>>>>>> initialized
>>>>>> device.
>>>>>>
>>>>> I don't know why we didn't need to call it :). I'm assuming the
>>>>> previous vhost-user net did fine resetting vq indexes, using
>>>>> VHOST_USER_SET_VRING_BASE. But I don't know about more complex
>>>>> devices.
>>>>>
>>>>> The guest can reset the device, or write 0 to the PCI config status,
>>>>> at any time. How does virtiofs handle it, being stateful?
>>>> Honestly a good question because virtiofsd implements neither
>>>> SET_STATUS nor RESET_DEVICE.  I’ll have to investigate that.
>>>>
>>>> I think when the guest resets the device, SET_VRING_BASE always comes
>>>> along some way or another, so that’s how the vrings are reset.  Maybe
>>>> the internal state is reset only following more high-level FUSE
>>>> commands like INIT.
>>> So a meeting and one session of looking-into-the-code later:
>>>
>>> We reset every virt queue on GET_VRING_BASE, which is wrong, but happens
>>> to serve the purpose.  (German is currently on that.)
>>>
>>> In our meeting, German said the reset would occur when the memory
>>> regions are changed, but I can’t see that in the code.
>> That would imply that the status is reset when the guest's memory is
>> added or removed?

No, but that whenever the memory in which there is a vring is changed, 
or whenever a vring’s address is changed, that vring is reset.

>>> I think it only
>>> happens implicitly through the SET_VRING_BASE call, which resets the
>>> internal avail/used pointers.
>>>
>>> [This doesn’t seem different from libvhost-user, though, which
>>> implements neither SET_STATUS nor RESET_DEVICE, and which pretends to
>>> reset the device on RESET_OWNER, but really doesn’t (its
>>> vu_reset_device_exec() function just disables all vrings, doesn’t reset
>>> or even stop them).]
>>>
>>> Consequently, the internal state is never reset.  It would be cleared on
>>> a FUSE Destroy message, but if you just force-reset the system, the
>>> state remains into the next reboot.  Not even FUSE Init clears it, which
>>> seems weird.  It happens to work because it’s still the same filesystem,
>>> so the existing state fits, but it kind of seems dangerous to keep e.g.
>>> files open.  I don’t think it’s really exploitable because everything
>>> still goes through the guest kernel, but, well.  We should clear the
>>> state on Init, and probably also implement SET_STATUS and clear the
>>> state there.
>>>
>> I see. That's in the line of assuming GET_VRING_BASE is the last
>> message received from qemu.
>>
> Actually, does it prevent device recovery after a failure in
> migration? Is the same state set for the device?

In theory no, because GET_VRING_BASE will return the current index, so 
it’ll be restored by SET_VRING_BASE even if the vring is reset in between.

In practice yes, because the current implementation has GET_VRING_BASE 
reset the vring before fetching the index, so the returned index is 
always 0, and it can’t be restored.  But this also prevents device 
recovery in successful migration.  German has sent a pull request for 
that: https://github.com/rust-vmm/vhost/pull/154

Hanna

