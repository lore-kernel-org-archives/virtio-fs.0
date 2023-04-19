Return-Path: <hreitz@redhat.com>
Message-ID: <e4cc0882-c6e0-a830-45d6-e3aab398ab98@redhat.com>
Date: Wed, 19 Apr 2023 12:45:19 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com> <20230412210641.GC2813183@fedora>
 <246691c3-2287-7472-3615-7ec0f074445c@redhat.com>
 <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
 <b0cd4f54-94ed-09a4-cec2-e81f36da4008@redhat.com>
 <CAJaqyWegMfuc8s6bKdxdM4uVixmhy-F3xUUyOCYS1yGDXoiVZA@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJaqyWegMfuc8s6bKdxdM4uVixmhy-F3xUUyOCYS1yGDXoiVZA@mail.gmail.com>
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
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 14.04.23 17:17, Eugenio Perez Martin wrote:
> On Thu, Apr 13, 2023 at 7:55 PM Hanna Czenczek <hreitz@redhat.com> wrote:

[...]

>> Basically, what I’m hearing is that I need to implement a different
>> feature that has no practical impact right now, and also fix bugs around
>> it along the way...
>>
> To fix this properly requires iterative device migration in qemu as
> far as I know, instead of using VMStates [1]. This way the state is
> requested to virtiofsd before the device reset.
>
> What does virtiofsd do when the state is totally sent? Does it keep
> processing requests and generating new state or is only a one shot
> that will suspend the daemon? If it is the second I think it still can
> be done in one shot at the end, always indicating "no more state" at
> save_live_pending and sending all the state at
> save_live_complete_precopy.

This sounds to me as if we should reset all devices during migration, 
and I don’t understand that.  virtiofsd will not immediately process 
requests when the state is sent, because the device is still stopped, 
but when it is re-enabled (e.g. because of a failed migration), it will 
have retained its state and continue processing requests as if nothing 
happened.  A reset would break this and other stateful back-ends, as I 
think Stefan has mentioned somewhere else.

It seems to me as if there are devices that need a reset, and so need 
suspend+resume around it, but I also think there are back-ends that 
don’t, where this would only unnecessarily complicate the back-end 
implementation.

Hanna

