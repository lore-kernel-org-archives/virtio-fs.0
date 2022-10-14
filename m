Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ge8mhqYtumSiwf3fU01FXx7uQDnA7mQ0nkcWc0Prfiw=;
 b=tapB4aDQEZBTr+7LApb41dXh2BD0M7Rb4sfAHzV/vmKyXuuq9vV+9BOWPhg+xFMQygbM
 a6cDIzNdIAVstnQKZr4l7jOjVx4dHjM/+AAJ5WZJZVuFrmFMwlKvA8wZeEkhpT2qPa9J
 o6i5LFedC+IaQPpjXP7hmfWY2ZfrtTZ0vb3MqvsU/Gz/hRDVf/d67P3JRLUggExVeScA
 vToYx4GeNs0Bhvt3aSt7n+/MOjUHYbUrXk5R/E5HKv5ZgHCaeLoyU+zsEAJUCH8n5KGx
 6+twWec0vr3qWV8Ly9Nim+QzP0PTW1TZdFUQROqWGDmcaKpvMV4odYVM5hwAe6hdhlMQ zw==
Message-ID: <df661f39-b5da-65c9-ec13-27a218717060@linux.ibm.com>
Date: Fri, 14 Oct 2022 10:44:48 +0200
MIME-Version: 1.0
References: <20221010172813.204597-1-mst@redhat.com>
 <20221010172813.204597-8-mst@redhat.com>
 <3a002a6a-9135-ad45-3fed-7dd270450d0b@linux.ibm.com>
 <87pmeuol2i.fsf@linaro.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <87pmeuol2i.fsf@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
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
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com


Am 14.10.22 um 10:37 schrieb Alex Benn=C3=A9e:
>=20
> Christian Borntraeger <borntraeger@linux.ibm.com> writes:
>=20
>> Am 10.10.22 um 19:29 schrieb Michael S. Tsirkin:
>>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> All the boilerplate virtio code does the same thing (or should at
>>> least) of checking to see if the VM is running before attempting to
>>> start VirtIO. Push the logic up to the common function to avoid
>>> getting a copy and paste wrong.
>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> This results in a regression for our s390x CI when doing save/restore of=
 guests with vsock:
>>
>>
>>                  #1  0x000003ff9a248580 raise (libc.so.6 + 0x48580)
>>                  #2  0x000003ff9a22b5c0 abort (libc.so.6 + 0x2b5c0)
>>                  #3  0x000003ff9a2409da __assert_fail_base (libc.so.6 + =
0x409da)
>>                  #4  0x000003ff9a240a4e __assert_fail (libc.so.6 + 0x40a=
4e)
>>                  #5  0x000002aa2d69a066 vhost_vsock_common_pre_save (qem=
u-system-s390x + 0x39a066)
>>                  #6  0x000002aa2d55570e vmstate_save_state_v (qemu-syste=
m-s390x + 0x25570e)
>>                  #7  0x000002aa2d556218 vmstate_save_state (qemu-system-=
s390x + 0x256218)
>>                  #8 0x000002aa2d570ba4
>> qemu_savevm_state_complete_precopy_non_iterable (qemu-system-s390x +
>> 0x270ba4)
>>                  #9  0x000002aa2d5710b6 qemu_savevm_state_complete_preco=
py (qemu-system-s390x + 0x2710b6)
>>                  #10 0x000002aa2d564d0e migration_completion (qemu-syste=
m-s390x + 0x264d0e)
>>                  #11 0x000002aa2d8db25c qemu_thread_start (qemu-system-s=
390x + 0x5db25c)
>>                  #12 0x000003ff9a296248 start_thread (libc.so.6 + 0x9624=
8)
>>                  #13 0x000003ff9a31183e thread_start (libc.so.6 + 0x1118=
3e)
>=20
> Which test does this break?

migrate to file and restore.

>=20
> Looking at the change the only thing I can think of is there is a subtle
> change in the order of checks because if the device is set as
> use_started we return the result regardless of vm or config state:
>=20
>      if (vdev->use_started) {
>          return vdev->started;
>      }
>=20
> Could some printfs confirm that?

Right. The problem is we now ignore the vm state and thus run into the asse=
rtion in vhost_vsock_common_pre_save.
Removing the asserting then results in virtio errors, which really indicate=
s that the device must not be started.

