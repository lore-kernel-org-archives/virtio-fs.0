Return-Path: <hreitz@redhat.com>
Message-ID: <05e9946d-f2be-f594-fea2-d1d03686b644@redhat.com>
Date: Fri, 5 May 2023 14:51:55 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <CAJaqyWdhBq=0f-Qhbdg3AduS8zkPV5p6-uEEn24p1hRKcA3pOQ@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJaqyWdhBq=0f-Qhbdg3AduS8zkPV5p6-uEEn24p1hRKcA3pOQ@mail.gmail.com>
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

On 05.05.23 11:53, Eugenio Perez Martin wrote:
> On Fri, May 5, 2023 at 11:03 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>> On 04.05.23 23:14, Stefan Hajnoczi wrote:
>>> On Thu, 4 May 2023 at 13:39, Hanna Czenczek <hreitz@redhat.com> wrote:

[...]

>>> All state is lost and the Device Initialization process
>>> must be followed to make the device operational again.
>>>
>>> Existing vhost-user backends don't implement SET_STATUS 0 (it's new).
>>>
>>> It's messy and not your fault. I think QEMU should solve this by
>>> treating stateful devices differently from non-stateful devices. That
>>> way existing vhost-user backends continue to work and new stateful
>>> devices can also be supported.
>> It’s my understanding that SET_STATUS 0/RESET_DEVICE is problematic for
>> stateful devices.  In a previous email, you wrote that these should
>> implement SUSPEND+RESUME so qemu can use those instead.  But those are
>> separate things, so I assume we just use SET_STATUS 0 when stopping the
>> VM because this happens to also stop processing vrings as a side effect?
>>
>> I.e. I understand “treating stateful devices differently” to mean that
>> qemu should use SUSPEND+RESUME instead of SET_STATUS 0 when the back-end
>> supports it, and stateful back-ends should support it.
>>
> Honestly I cannot think of any use case where the vhost-user backend
> did not ignore set_status(0) and had to retrieve vq states. So maybe
> we can totally remove that call from qemu?

I don’t know so I can’t really say; but I don’t quite understand why 
qemu would reset a device at any point but perhaps VM reset (and even 
then I’d expect the post-reset guest to just reset the device on boot by 
itself, too).

[...]

>>>> Naturally, what I want to know most of all is whether you believe I can
>>>> get away without SUSPEND/RESUME for now.  To me, it seems like honestly
>>>> not really, only when turning two blind eyes, because otherwise we can’t
>>>> ensure that virtiofsd isn’t still processing pending virt queue requests
>>>> when the state transfer is begun, even when the guest CPUs are already
>>>> stopped.  Of course, virtiofsd could stop queue processing right there
>>>> and then, but…  That feels like a hack that in the grand scheme of
>>>> things just isn’t necessary when we could “just” introduce
>>>> SUSPEND/RESUME into vhost-user for exactly this.
>>>>
>>>> Beyond the SUSPEND/RESUME question, I understand everything can stay
>>>> as-is for now, as the design doesn’t seem to conflict too badly with
>>>> possible future extensions for other migration phases or more finely
>>>> grained migration phase control between front-end and back-end.
>>>>
>>>> Did I at least roughly get the gist?
>>> One part we haven't discussed much: I'm not sure how much trouble
>>> you'll face due to the fact that QEMU assumes vhost devices can be
>>> reset across vhost_dev_stop() -> vhost_dev_start(). I don't think we
>>> should keep a copy of the state in-memory just so it can be restored
>>> in vhost_dev_start().
>> All I can report is that virtiofsd continues to work fine after a
>> cancelled/failed migration.
>>
> Isn't the device reset after a failed migration? At least net devices
> are reset before sending VMState. If it cannot be applied at the
> destination, the device is already reset...

It doesn’t look like the Rust crate virtiofsd uses for vhost-user 
supports either F_STATUS or F_RESET_DEVICE, so I think this just doesn’t 
affect virtiofsd.

Hanna

