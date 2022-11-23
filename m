Return-Path: <sgarzare@redhat.com>
Date: Wed, 23 Nov 2022 15:24:07 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
Message-ID: <20221123142407.f6m4mo5exgjhgiix@sgarzare-redhat>
References: <20221121101101.29400-1-sgarzare@redhat.com>
 <CACGkMEtZ9C0uhnDZ7iPJSHvPcbwGCLrzj742zzc9xAVWD7EMVA@mail.gmail.com>
 <CAJaqyWfAA7p9MB4DZ-qtshr28HG3o4uXcxyg+BPC6C+eeojnbA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWfAA7p9MB4DZ-qtshr28HG3o4uXcxyg+BPC6C+eeojnbA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] vhost: mask VIRTIO_F_RING_RESET for vhost
 and vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Hanna Reitz <hreitz@redhat.com>, kangjie.xu@linux.alibaba.com

On Tue, Nov 22, 2022 at 07:01:38PM +0100, Eugenio Perez Martin wrote:
>On Tue, Nov 22, 2022 at 4:13 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Mon, Nov 21, 2022 at 6:11 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > Commit 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
>> > enabled VIRTIO_F_RING_RESET by default for all virtio devices.
>> >
>> > This feature is not currently emulated by QEMU, so for vhost and
>> > vhost-user devices we need to make sure it is supported by the offloaded
>> > device emulation (in-kernel or in another process).
>> > To do this we need to add VIRTIO_F_RING_RESET to the features bitmap
>> > passed to vhost_get_features(). This way it will be masked if the device
>> > does not support it.
>> >
>> > This issue was initially discovered with vhost-vsock and vhost-user-vsock,
>> > and then also tested with vhost-user-rng which confirmed the same issue.
>> > They fail when sending features through VHOST_SET_FEATURES ioctl or
>> > VHOST_USER_SET_FEATURES message, since VIRTIO_F_RING_RESET is negotiated
>> > by the guest (Linux >= v6.0), but not supported by the device.
>> >
>> > Fixes: 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
>> > Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1318
>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> > ---
>> >
>> > To prevent this problem in the future, perhaps we should provide a function
>> > (e.g. vhost_device_get_features) where we go to mask all non-device-specific
>> > features (e.g VIRTIO_F_*, VIRTIO_RING_F_*) that are not emulated by QEMU but
>> > we expect them to be emulated by the vhost or vhost-user devices.
>>
>> Adding Eugenio, this might not be true if we want to use shadow
>> virtqueue for emulating some features?
>>
>
>I think we should be able to introduce that in the (hypothetical)
>vhost_device_get_features if SVQ starts emulating a ring feature,
>isn't it?

Yep, I think so. The idea is to have a single place where to do it.

> I think a first version not aware of SVQ is fine anyway, and
>to introduce it later should be easy.

Thanks for the feedbacks, I'll keep you CCed.

Thanks,
Stefano

