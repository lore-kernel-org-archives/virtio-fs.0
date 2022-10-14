Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=VWDnWtBs+9ZgC5TTdDxLxwi0yw71TmWvtpz30R9yoNc=;
 b=ftn0rqBSymuxDxeV2qbNJF7peQNPd21kWxAq9SjM8dwj7UsgKYzQByRVsvhwjxg4qG
 odOO3TU5PALW+RS1A5ubRIBCIfdEw/1h7lu7ApjuSm6RQlMj1+qpnHq06+0fBQoLvem7
 c0kqHqr1PnctbvhQUPI9amFkMZfd0A48f3EP+nyQI5NQ4B5kS+P9qN+VK4npOBqx1olB
 vX3bDmUhkq/QelgAncm9LpVtegkfcFP3tBBJxweEmc+E3GX6rBFzsCsQQINjtpp9GdNC
 WL1OCv8f6q4JAgOxzN7eLeGTJPmTdZzGkyvuc8+XGv6hijDqbazfOLVJFvyISc+T1xfE
 8xoQ==
References: <20221010172813.204597-1-mst@redhat.com>
 <20221010172813.204597-8-mst@redhat.com>
 <3a002a6a-9135-ad45-3fed-7dd270450d0b@linux.ibm.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Oct 2022 09:37:00 +0100
In-reply-to: <3a002a6a-9135-ad45-3fed-7dd270450d0b@linux.ibm.com>
Message-ID: <87pmeuol2i.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Regression save/restore of vsock: (was [PULL 07/55]
 hw/virtio: move vm_running check to virtio_device_started)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com


Christian Borntraeger <borntraeger@linux.ibm.com> writes:

> Am 10.10.22 um 19:29 schrieb Michael S. Tsirkin:
>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> All the boilerplate virtio code does the same thing (or should at
>> least) of checking to see if the VM is running before attempting to
>> start VirtIO. Push the logic up to the common function to avoid
>> getting a copy and paste wrong.
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> This results in a regression for our s390x CI when doing save/restore of =
guests with vsock:
>
>
>                 #1  0x000003ff9a248580 raise (libc.so.6 + 0x48580)
>                 #2  0x000003ff9a22b5c0 abort (libc.so.6 + 0x2b5c0)
>                 #3  0x000003ff9a2409da __assert_fail_base (libc.so.6 + 0x=
409da)
>                 #4  0x000003ff9a240a4e __assert_fail (libc.so.6 + 0x40a4e=
)
>                 #5  0x000002aa2d69a066 vhost_vsock_common_pre_save (qemu-=
system-s390x + 0x39a066)
>                 #6  0x000002aa2d55570e vmstate_save_state_v (qemu-system-=
s390x + 0x25570e)
>                 #7  0x000002aa2d556218 vmstate_save_state (qemu-system-s3=
90x + 0x256218)
>                 #8 0x000002aa2d570ba4
> qemu_savevm_state_complete_precopy_non_iterable (qemu-system-s390x +
> 0x270ba4)
>                 #9  0x000002aa2d5710b6 qemu_savevm_state_complete_precopy=
 (qemu-system-s390x + 0x2710b6)
>                 #10 0x000002aa2d564d0e migration_completion (qemu-system-=
s390x + 0x264d0e)
>                 #11 0x000002aa2d8db25c qemu_thread_start (qemu-system-s39=
0x + 0x5db25c)
>                 #12 0x000003ff9a296248 start_thread (libc.so.6 + 0x96248)
>                 #13 0x000003ff9a31183e thread_start (libc.so.6 + 0x11183e=
)

Which test does this break?

Looking at the change the only thing I can think of is there is a subtle
change in the order of checks because if the device is set as
use_started we return the result regardless of vm or config state:

    if (vdev->use_started) {
        return vdev->started;
    }

Could some printfs confirm that?

--=20
Alex Benn=C3=A9e

