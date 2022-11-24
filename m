Return-Path: <sgarzare@redhat.com>
Date: Thu, 24 Nov 2022 08:54:52 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
Message-ID: <20221124075452.y2slphvuwbjsst36@sgarzare-redhat>
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <4A976F8D-AB6F-4BAD-AD5A-ABF69B8A040C@nutanix.com>
 <20221124014951-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20221124014951-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH for-7.2] vhost: enable vrings in
 vhost_dev_start() for vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Jason Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>

On Thu, Nov 24, 2022 at 01:50:19AM -0500, Michael S. Tsirkin wrote:
>On Thu, Nov 24, 2022 at 12:19:25AM +0000, Raphael Norwitz wrote:
>>
>> > On Nov 23, 2022, at 8:16 AM, Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > Commit 02b61f38d3 ("hw/virtio: incorporate backend features in features")
>> > properly negotiates VHOST_USER_F_PROTOCOL_FEATURES with the vhost-user
>> > backend, but we forgot to enable vrings as specified in
>> > docs/interop/vhost-user.rst:
>> >
>> >    If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
>> >    ring starts directly in the enabled state.
>> >
>> >    If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
>> >    initialized in a disabled state and is enabled by
>> >    ``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
>> >
>> > Some vhost-user front-ends already did this by calling
>> > vhost_ops.vhost_set_vring_enable() directly:
>> > - backends/cryptodev-vhost.c
>> > - hw/net/virtio-net.c
>> > - hw/virtio/vhost-user-gpio.c
>>
>> To simplify why not rather change these devices to use the new 
>> semantics?

Maybe the only one I wouldn't be scared of is vhost-user-gpio, but for 
example vhost-net would require a lot of changes, maybe better after the 
release.

For example, we could do like vhost-vdpa and call SET_VRING_ENABLE in 
the VhostOps.vhost_dev_start callback of vhost-user.c, but I think it's 
too risky to do that now.

>
>Granted this is already scary enough for this release.

Yeah, I tried to touch as little as possible but I'm scared too, I just 
haven't found a better solution for now :-(

>
>> >
>> > But most didn't do that, so we would leave the vrings disabled and some
>> > backends would not work. We observed this issue with the rust version of
>> > virtiofsd [1], which uses the event loop [2] provided by the
>> > vhost-user-backend crate where requests are not processed if vring is
>> > not enabled.
>> >
>> > Let's fix this issue by enabling the vrings in vhost_dev_start() for
>> > vhost-user front-ends that don't already do this directly. Same thing
>> > also in vhost_dev_stop() where we disable vrings.
>> >
>> > [1] https://gitlab.com/virtio-fs/virtiofsd
>> > [2] https://github.com/rust-vmm/vhost/blob/240fc2966/crates/vhost-user-backend/src/event_loop.rs#L217
>> > Fixes: 02b61f38d3 ("hw/virtio: incorporate backend features in features")
>> > Reported-by: German Maglione <gmaglione@redhat.com>
>> > Tested-by: German Maglione <gmaglione@redhat.com>
>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> Looks good for vhost-user-blk/vhost-user-scsi.
>>
>> Acked-by: Raphael Norwitz <raphael.norwitz@nutanix.com>

Thanks for the review!
Stefano

