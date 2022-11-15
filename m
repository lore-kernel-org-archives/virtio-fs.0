Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TOYvz3EB7sMd3H7EZhr6b6EdS8yX7w7WSEaVSIoJZ2Y=;
 b=VF3qGhgt01AbIfQEJyDPaGXgucSM7ZyxBklzbdLRIkfOZOteuOr3R5UvFKV53I0E5Xbf
 VkbuQyMgtYmkEZDUpl4VXvhpLdvDI5dHpeUZQKzE9JVGszuZrlt6e4usXgoixgA4Ohjh
 6HkqvbN59TSVUl5v8VSVUhsqeNvx2DaX5zY7POqZM+lNNLHhqu9Q4+Xh7xzxaSPoYUdI
 bSRoO/TibTovkJjykT+BHb3on4lioLibk4/D3tR4wm/wRt2Te2oWyZbNBqC7s/9TqWHv
 n2h4ZOWcSV4nNhCnm9Gv3HXx1fTEiY1Z7PhwNHy5jLO7e8g6zNVtUH6OR8x33bnBOzP2 wQ==
Message-ID: <26b4e8d8-784d-d1ce-67a3-b61896701bf7@linux.ibm.com>
Date: Tue, 15 Nov 2022 16:09:41 +0100
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
 <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org> <87tu309tlk.fsf@linaro.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <87tu309tlk.fsf@linaro.org>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
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
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>



Am 15.11.22 um 15:31 schrieb Alex Benn=C3=A9e:
>=20
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>=20
>> On Mon, Nov 14, 2022 at 06:15:30PM +0100, Christian Borntraeger wrote:
>>>
>>>
>>> Am 14.11.22 um 18:10 schrieb Michael S. Tsirkin:
>>>> On Mon, Nov 14, 2022 at 05:55:09PM +0100, Christian Borntraeger wrote:
>>>>>
>>>>>
>>>>> Am 14.11.22 um 17:37 schrieb Michael S. Tsirkin:
>>>>>> On Mon, Nov 14, 2022 at 05:18:53PM +0100, Christian Borntraeger wrot=
e:
>>>>>>> Am 08.11.22 um 10:23 schrieb Alex Benn=C3=A9e:
>>>>>>>> The previous fix to virtio_device_started revealed a problem in it=
s
>>>>>>>> use by both the core and the device code. The core code should be =
able
>>>>>>>> to handle the device "starting" while the VM isn't running to hand=
le
>>>>>>>> the restoration of migration state. To solve this dual use introdu=
ce a
>>>>>>>> new helper for use by the vhost-user backends who all use it to fe=
ed a
>>>>>>>> should_start variable.
>>>>>>>>
>>>>>>>> We can also pick up a change vhost_user_blk_set_status while we ar=
e at
>>>>>>>> it which follows the same pattern.
>>>>>>>>
>>>>>>>> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_devi=
ce_started)
>>>>>>>> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio =
device)
>>>>>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>>>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>>>>>>
>>>>>>> Hmmm, is this
>>>>>>> commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
>>>>>>> Author:     Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>>>> AuthorDate: Mon Nov 7 12:14:07 2022 +0000
>>>>>>> Commit:     Michael S. Tsirkin <mst@redhat.com>
>>>>>>> CommitDate: Mon Nov 7 14:08:18 2022 -0500
>>>>>>>
>>>>>>>        hw/virtio: introduce virtio_device_should_start
>>>>>>>
>>>>>>> and older version?
>>>>>>
>>>>>> This is what got merged:
>>>>>> https://lore.kernel.org/r/20221107121407.1010913-1-alex.bennee%40lin=
aro.org
>>>>>> This patch was sent after I merged the RFC.
>>>>>> I think the only difference is the commit log but I might be missing
>>>>>> something.
>>>>>>
>>>>>>> This does not seem to fix the regression that I have reported.
>>>>>>
>>>>>> This was applied on top of 9f6bcfd99f which IIUC does, right?
>>>>>>
>>>>>>
>>>>>
>>>>> QEMU master still fails for me for suspend/resume to disk:
>>>>>
>>>>> #0  0x000003ff8e3980a6 in __pthread_kill_implementation () at /lib64/=
libc.so.6
>>>>> #1  0x000003ff8e348580 in raise () at /lib64/libc.so.6
>>>>> #2  0x000003ff8e32b5c0 in abort () at /lib64/libc.so.6
>>>>> #3  0x000003ff8e3409da in __assert_fail_base () at /lib64/libc.so.6
>>>>> #4  0x000003ff8e340a4e in  () at /lib64/libc.so.6
>>>>> #5 0x000002aa1ffa8966 in vhost_vsock_common_pre_save
>>>>> (opaque=3D<optimized out>) at
>>>>> ../hw/virtio/vhost-vsock-common.c:203
>>>>> #6  0x000002aa1fe5e0ee in vmstate_save_state_v
>>>>>       (f=3Df@entry=3D0x2aa21bdc170, vmsd=3D0x2aa204ac5f0
>>>>> <vmstate_virtio_vhost_vsock>, opaque=3D0x2aa21bac9f8,
>>>>> vmdesc=3Dvmdesc@entry=3D0x3fddc08eb30,
>>>>> version_id=3Dversion_id@entry=3D0) at ../migration/vmstate.c:329
>>>>> #7 0x000002aa1fe5ebf8 in vmstate_save_state
>>>>> (f=3Df@entry=3D0x2aa21bdc170, vmsd=3D<optimized out>,
>>>>> opaque=3D<optimized out>, vmdesc_id=3Dvmdesc_id@entry=3D0x3fddc08eb30=
)
>>>>> at ../migration/vmstate.c:317
>>>>> #8 0x000002aa1fe75bd0 in vmstate_save (f=3Df@entry=3D0x2aa21bdc170,
>>>>> se=3Dse@entry=3D0x2aa21bdbe90, vmdesc=3Dvmdesc@entry=3D0x3fddc08eb30)=
 at
>>>>> ../migration/savevm.c:908
>>>>> #9 0x000002aa1fe79584 in
>>>>> qemu_savevm_state_complete_precopy_non_iterable
>>>>> (f=3Df@entry=3D0x2aa21bdc170, in_postcopy=3Din_postcopy@entry=3Dfalse=
,
>>>>> inactivate_disks=3Dinactivate_disks@entry=3Dtrue)
>>>>>       at ../migration/savevm.c:1393
>>>>> #10 0x000002aa1fe79a96 in qemu_savevm_state_complete_precopy
>>>>> (f=3D0x2aa21bdc170, iterable_only=3Diterable_only@entry=3Dfalse,
>>>>> inactivate_disks=3Dinactivate_disks@entry=3Dtrue) at
>>>>> ../migration/savevm.c:1459
>>>>> #11 0x000002aa1fe6d6ee in migration_completion (s=3D0x2aa218ef600) at=
 ../migration/migration.c:3314
>>>>> #12 migration_iteration_run (s=3D0x2aa218ef600) at ../migration/migra=
tion.c:3761
>>>>> #13 migration_thread (opaque=3Dopaque@entry=3D0x2aa218ef600) at ../mi=
gration/migration.c:3989
>>>>> #14 0x000002aa201f0b8c in qemu_thread_start (args=3D<optimized out>) =
at ../util/qemu-thread-posix.c:505
>>>>> #15 0x000003ff8e396248 in start_thread () at /lib64/libc.so.6
>>>>> #16 0x000003ff8e41183e in thread_start () at /lib64/libc.so.6
>>>>>
>>>>> Michael, your previous branch did work if I recall correctly.
>>>>
>>>> That one was failing under github CI though (for reasons we didn't
>>>> really address, such as disconnect during stop causing a recursive
>>>> call to stop, but there you are).
>>> Even the double revert of everything?
>>
>> I don't remember at this point.
>>
>>> So how do we proceed now?
>>
>> I'm hopeful Alex will come up with a fix.
>=20
> I need to replicate the failing test for that. Which test is failing?


Pretty much the same as before. guest with vsock, managedsave and restore.

