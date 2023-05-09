Return-Path: <hreitz@redhat.com>
Message-ID: <a2e87bab-41c3-0402-927e-54d0a0e67d43@redhat.com>
Date: Tue, 9 May 2023 10:53:35 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <CAJaqyWdhBq=0f-Qhbdg3AduS8zkPV5p6-uEEn24p1hRKcA3pOQ@mail.gmail.com>
 <05e9946d-f2be-f594-fea2-d1d03686b644@redhat.com>
 <20230508211002.GC926999@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230508211002.GC926999@fedora>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 08.05.23 23:10, Stefan Hajnoczi wrote:
> On Fri, May 05, 2023 at 02:51:55PM +0200, Hanna Czenczek wrote:
>> On 05.05.23 11:53, Eugenio Perez Martin wrote:
>>> On Fri, May 5, 2023 at 11:03 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>>>> On 04.05.23 23:14, Stefan Hajnoczi wrote:
>>>>> On Thu, 4 May 2023 at 13:39, Hanna Czenczek <hreitz@redhat.com> wrote:
>> [...]
>>
>>>>> All state is lost and the Device Initialization process
>>>>> must be followed to make the device operational again.
>>>>>
>>>>> Existing vhost-user backends don't implement SET_STATUS 0 (it's new).
>>>>>
>>>>> It's messy and not your fault. I think QEMU should solve this by
>>>>> treating stateful devices differently from non-stateful devices. That
>>>>> way existing vhost-user backends continue to work and new stateful
>>>>> devices can also be supported.
>>>> It’s my understanding that SET_STATUS 0/RESET_DEVICE is problematic for
>>>> stateful devices.  In a previous email, you wrote that these should
>>>> implement SUSPEND+RESUME so qemu can use those instead.  But those are
>>>> separate things, so I assume we just use SET_STATUS 0 when stopping the
>>>> VM because this happens to also stop processing vrings as a side effect?
>>>>
>>>> I.e. I understand “treating stateful devices differently” to mean that
>>>> qemu should use SUSPEND+RESUME instead of SET_STATUS 0 when the back-end
>>>> supports it, and stateful back-ends should support it.
>>>>
>>> Honestly I cannot think of any use case where the vhost-user backend
>>> did not ignore set_status(0) and had to retrieve vq states. So maybe
>>> we can totally remove that call from qemu?
>> I don’t know so I can’t really say; but I don’t quite understand why qemu
>> would reset a device at any point but perhaps VM reset (and even then I’d
>> expect the post-reset guest to just reset the device on boot by itself,
>> too).
> DPDK stores the Device Status field value and uses it later:
> https://github.com/DPDK/dpdk/blob/main/lib/vhost/vhost_user.c#L2791
>
> While DPDK performs no immediate action upon SET_STATUS 0, omitting the
> message will change the behavior of other DPDK code like
> virtio_is_ready().
>
> Changing the semantics of the vhost-user protocol in a way that's not
> backwards compatible is something we should avoid unless there is no
> other way.

Well, I have two opinions on this:

First, that in DPDK sounds wrong.  vhost_dev_stop() is called mostly by 
devices that call it when set_status is called on them.  But they don’t 
call it if status == 0, they call it if virtio_device_should_start() 
returns false, which is the case when the VM is stopped.  So basically 
we set a status value on the back-end device that is not the status 
value that is set in qemu. If DPDK makes actual use of this status value 
that differs from that of the front-end in qemu, that sounds like it 
probably actually wrong.

Second, it’s entirely possible and probably probable that DPDK doesn’t 
make “actual use of this status value”; the only use it probably has is 
to determine whether the device is supposed to be stopped, which is 
exactly what qemu has tried to confer by setting it to 0.  So it’s 
basically two implementations that have agreed on abusing a value to 
emulate behavior that isn’t otherwise implement (SUSPEND), and that 
works because all devices are stateless.  Then, I agree, we can’t change 
this until it gets SUSPEND support.

> The fundamental problem is that QEMU's vhost code is designed to reset
> vhost devices because it assumes they are stateless. If an F_SUSPEND
> protocol feature bit is added, then it becomes possible to detect new
> backends and suspend/resume them rather than reset them.
>
> That's the solution that I favor because it's backwards compatible and
> the same model can be applied to stateful vDPA devices in the future.

So basically the idea is the following: vhost_dev_stop() should just 
suspend the device, not reset it.  For devices that don’t support 
SUSPEND, we still need to do something, and just calling GET_VRING_BASE 
on all vrings is deemed inadequate, so they are reset (SET_STATUS 0) as 
a work-around, assuming that stateful devices that care (i.e. implement 
SET_STATUS) will also implement SUSPEND to not have this “legacy reset” 
happen to them.

Sounds good to me.  (If I understood that right. :))

Hanna

