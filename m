Return-Path: <hreitz@redhat.com>
Message-ID: <71e47e3e-880d-38d8-c1b0-3287c60365e4@redhat.com>
Date: Fri, 5 May 2023 11:51:14 +0200
MIME-Version: 1.0
From: Hanna Czenczek <hreitz@redhat.com>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
In-Reply-To: <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>

(By the way, thanks for the explanations :))

On 05.05.23 11:03, Hanna Czenczek wrote:
> On 04.05.23 23:14, Stefan Hajnoczi wrote:

[...]

>> I think it's better to change QEMU's vhost code
>> to leave stateful devices suspended (but not reset) across
>> vhost_dev_stop() -> vhost_dev_start(), maybe by introducing
>> vhost_dev_suspend() and vhost_dev_resume(). Have you thought about
>> this aspect?
>
> Yes and no; I mean, I haven’t in detail, but I thought this is what’s 
> meant by suspending instead of resetting when the VM is stopped.

So, now looking at vhost_dev_stop(), one problem I can see is that 
depending on the back-end, different operations it does will do 
different things.

It tries to stop the whole device via vhost_ops->vhost_dev_start(), 
which for vDPA will suspend the device, but for vhost-user will reset it 
(if F_STATUS is there).

It disables all vrings, which doesn’t mean stopping, but may be 
necessary, too.  (I haven’t yet really understood the use of disabled 
vrings, I heard that virtio-net would have a need for it.)

It then also stops all vrings, though, so that’s OK.  And because this 
will always do GET_VRING_BASE, this is actually always the same 
regardless of transport.

Finally (for this purpose), it resets the device status via 
vhost_ops->vhost_reset_status().  This is only implemented on vDPA, and 
this is what resets the device there.


So vhost-user resets the device in .vhost_dev_start, but vDPA only does 
so in .vhost_reset_status.  It would seem better to me if vhost-user 
would also reset the device only in .vhost_reset_status, not in 
.vhost_dev_start.  .vhost_dev_start seems precisely like the place to 
run SUSPEND/RESUME.

Another question I have (but this is basically what I wrote in my last 
email) is why we even call .vhost_reset_status here.  If the device 
and/or all of the vrings are already stopped, why do we need to reset 
it?  Naïvely, I had assumed we only really need to reset the device if 
the guest changes, so that a new guest driver sees a freshly initialized 
device.

Hanna

