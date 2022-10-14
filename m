Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j0inD2W7mpQlMGHysOuaabyIle0Zfex/rprt99z5/yU=;
 b=eP2RY4t0JmwmMKSidBG3rR8AY0CM716KlZ+FlGOqXhHG9OR6NhGp5TpyhkDADOOl/4fs
 25aSthqerVdcX0YksOH0/4cWrgX8/v5nmvxyO+dtDlnPxtJyE2YnRqjK8vwNYuHbDWQO
 H+tXtC8uJP0yIzC1/WJVulocBD21ceSNsfh6gBfjxc1IjAd6y4R5mgE0o22EGIp2f40s
 ZIgvrKVFz8kkPggePoJ3U5EpghY6/Bat+zjaXOsvHGH74cjK9O5k6F3xCvHoowTXQv7N
 pnPG3GmKXdcGf2Gz4Iwl3x0AKF+pCJpbaRAHdX0+1QMdsZLCuqDmZeG4hRFL0dhJmeIl pg==
Message-ID: <f82d0672-00e0-fb6f-fcce-1c9dd605b95d@linux.ibm.com>
Date: Fri, 14 Oct 2022 13:58:50 +0200
MIME-Version: 1.0
References: <20221010172813.204597-1-mst@redhat.com>
 <20221010172813.204597-8-mst@redhat.com>
 <3a002a6a-9135-ad45-3fed-7dd270450d0b@linux.ibm.com>
 <1c400131-59f6-f14f-e7e0-3871cc0d1815@linux.ibm.com>
 <87czauoe6y.fsf@linaro.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <87czauoe6y.fsf@linaro.org>
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



Am 14.10.22 um 13:07 schrieb Alex Benn=C3=A9e:
>=20
> Christian Borntraeger <borntraeger@linux.ibm.com> writes:
>=20
>> Am 14.10.22 um 09:30 schrieb Christian Borntraeger:
>>> Am 10.10.22 um 19:29 schrieb Michael S. Tsirkin:
>>>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>
>>>> All the boilerplate virtio code does the same thing (or should at
>>>> least) of checking to see if the VM is running before attempting to
>>>> start VirtIO. Push the logic up to the common function to avoid
>>>> getting a copy and paste wrong.
>>>>
>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>> Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
>>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> This results in a regression for our s390x CI when doing
>>> save/restore of guests with vsock:
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #1=C2=A0 0x000003ff9a248580 raise (libc.so.6 + 0x4858=
0)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #2=C2=A0 0x000003ff9a22b5c0 abort (libc.so.6 + 0x2b5c=
0)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #3=C2=A0 0x000003ff9a2409da __assert_fail_base (libc.=
so.6 + 0x409da)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #4=C2=A0 0x000003ff9a240a4e __assert_fail (libc.so.6 =
+ 0x40a4e)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #5=C2=A0 0x000002aa2d69a066 vhost_vsock_common_pre_sa=
ve (qemu-system-s390x + 0x39a066)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #6=C2=A0 0x000002aa2d55570e vmstate_save_state_v (qem=
u-system-s390x + 0x25570e)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #7=C2=A0 0x000002aa2d556218 vmstate_save_state (qemu-=
system-s390x + 0x256218)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #8=C2=A0 0x000002aa2d570ba4
>>> qemu_savevm_state_complete_precopy_non_iterable (qemu-system-s390x +
>>> 0x270ba4)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #9=C2=A0 0x000002aa2d5710b6 qemu_savevm_state_complet=
e_precopy (qemu-system-s390x + 0x2710b6)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #10 0x000002aa2d564d0e migration_completion (qemu-sys=
tem-s390x + 0x264d0e)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #11 0x000002aa2d8db25c qemu_thread_start (qemu-system=
-s390x + 0x5db25c)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #12 0x000003ff9a296248 start_thread (libc.so.6 + 0x96=
248)
>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 #13 0x000003ff9a31183e thread_start (libc.so.6 + 0x11=
183e)
>>>
>>
>>
>> Something like
>> diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
>> index 7dc3c7393122..b4d056ae6f01 100644
>> --- a/hw/virtio/vhost-vsock.c
>> +++ b/hw/virtio/vhost-vsock.c
>> @@ -73,6 +73,10 @@ static void vhost_vsock_set_status(VirtIODevice *vdev=
, uint8_t status)
>>       bool should_start =3D virtio_device_started(vdev, status);
>>       int ret;
>>   +    if (!vdev->vm_running) {
>> +        should_start =3D false;
>> +    }
>> +
>>       if (vhost_dev_is_started(&vvc->vhost_dev) =3D=3D should_start) {
>>           return;
>>       }
>>
>> helps.
>>
>> The problem seems to be that virtio_device_started does ignore
>> vm_running when use_start is set.
>=20
> Wouldn't it make more sense to re-order the check there, something like:
>=20
>    static inline bool virtio_device_started(VirtIODevice *vdev, uint8_t s=
tatus)
>    {
>        if (!vdev->vm_running) {
>            return false;
>        }
>=20
>        if (vdev->use_started) {
>            return vdev->started;
>        }
>=20
>        return status & VIRTIO_CONFIG_S_DRIVER_OK;
>    }

That does work as well. (and it restores the original ordering so that make=
s sense).

>=20
> Is the problem that vdev->started gets filled during the migration but
> because the VM isn't running yet we can never actually run?

I dont know.

