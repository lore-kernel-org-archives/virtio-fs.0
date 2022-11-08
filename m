Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RQQVfxGXslFxaIYTIhDazAibkGiGo8meDy3HCi/DvrE=;
 b=bYBSjC43GcWawHK5hAk+w8hGlFQDosmIdhpOVCMQ/WJFZbF21ZwkN7HvEk5tUfqgbv
 XUUWkih7pdikHcUvrXtLWxLuFxTevwZTGLNlq086U6jBoS60nr0p8V2cj9uNzqCwykPs
 x+HpbRwnz3nO3Rt5zCTYskCkna67paqMIfGbbU7mPpo4xgCBdXjQwNg9hzUyAfhX+syu
 JALor57jM2MvtvJ2UmsXKy8A6DkHNtNzbGxDM8Szi+3qDVl+RUw1H/NioaE0qqXQaFDQ
 BAmuSRdO93fjfFjbyh7YoffE8/h1kmkKfPcKQhz/R6GkTYithi15j3ow9S2jwapW7/uG
 DgaQ==
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <20221108043249-mutt-send-email-mst@kernel.org>
 <8735atg2vh.fsf@linaro.org>
 <20221108052544-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 08 Nov 2022 11:21:26 +0000
In-reply-to: <20221108052544-mutt-send-email-mst@kernel.org>
Message-ID: <87y1slelmw.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Nov 08, 2022 at 10:23:15AM +0000, Alex Benn=C3=A9e wrote:
>>=20
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>=20
>> > On Tue, Nov 08, 2022 at 09:23:04AM +0000, Alex Benn=C3=A9e wrote:
>> >> The previous fix to virtio_device_started revealed a problem in its
>> >> use by both the core and the device code. The core code should be abl=
e
>> >> to handle the device "starting" while the VM isn't running to handle
>> >> the restoration of migration state. To solve this dual use introduce =
a
>> >> new helper for use by the vhost-user backends who all use it to feed =
a
>> >> should_start variable.
>> >>=20
>> >> We can also pick up a change vhost_user_blk_set_status while we are a=
t
>> >> it which follows the same pattern.
>> >>=20
>> >> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_device_=
started)
>> >> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio dev=
ice)
>> >> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> >> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> >
>> > why is this in this patchset?
>>=20
>> As per my cover letter:
>>=20
>>   Most of these patches have been posted before as single patch RFCs. A
>>   couple are already scheduled through other trees so will drop out in
>>   due course
>>=20
>> but I keep them in my tree until they are merged so I can continue to
>> soak test them (and have a stable base for my other WIP trees).
>
> That's fine just pls don't double-post them on list, certainly
> not as part of a patchset.

Why not? Is this breaking some tooling?

--=20
Alex Benn=C3=A9e

