Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uoO9uDx/886y1vTFSIpeVlN2ne2QUUIW9U1nbXSHkw0=;
 b=cxL6+9IsDQSDf/9ri7MEgj5t4C2KxVK57Q0kIbh+qsUM972lV7ku/0wtbrgyzgROf3w1
 5IT+lTWyOUhYos+SpDfSH5j79tsemd/KwJHmz9aV63MfSjW6l3t8UEazYoKO1ApUGd+m
 /3mOlOrpRCcLq7lVLXezbzJg7fGygMno6H4bl7iQDm/a2U0j9VUR+uhF8AgxICg/Ljoe
 FDnGS+KrEfmw1q6DrAWZ4y68+fAUecWRd5xfkyCvPLFfPpAd2UPBqfQEEgFP54USnqz0
 NqB7Ja8hBZmmh7URs2iFI+QYhHNcNWEiGfqXn7AzYBVioePrLtx/GphoUu9ccLHMmRI6 0A==
Message-ID: <69fbc17f-cd78-a849-f7fc-31f8b3945ded@linux.ibm.com>
Date: Tue, 15 Nov 2022 09:18:27 +0100
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
 <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221114121959-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>


Am 14.11.22 um 18:20 schrieb Michael S. Tsirkin:
> On Mon, Nov 14, 2022 at 06:15:30PM +0100, Christian Borntraeger wrote:
>>
>>
>> Am 14.11.22 um 18:10 schrieb Michael S. Tsirkin:
>>> On Mon, Nov 14, 2022 at 05:55:09PM +0100, Christian Borntraeger wrote:
>>>>
>>>>
>>>> Am 14.11.22 um 17:37 schrieb Michael S. Tsirkin:
>>>>> On Mon, Nov 14, 2022 at 05:18:53PM +0100, Christian Borntraeger wrote=
:
>>>>>> Am 08.11.22 um 10:23 schrieb Alex Benn=C3=A9e:
>>>>>>> The previous fix to virtio_device_started revealed a problem in its
>>>>>>> use by both the core and the device code. The core code should be a=
ble
>>>>>>> to handle the device "starting" while the VM isn't running to handl=
e
>>>>>>> the restoration of migration state. To solve this dual use introduc=
e a
>>>>>>> new helper for use by the vhost-user backends who all use it to fee=
d a
>>>>>>> should_start variable.
>>>>>>>
>>>>>>> We can also pick up a change vhost_user_blk_set_status while we are=
 at
>>>>>>> it which follows the same pattern.
>>>>>>>
>>>>>>> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_devic=
e_started)
>>>>>>> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio d=
evice)
>>>>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>>>>>
>>>>>> Hmmm, is this
>>>>>> commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
>>>>>> Author:     Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>>> AuthorDate: Mon Nov 7 12:14:07 2022 +0000
>>>>>> Commit:     Michael S. Tsirkin <mst@redhat.com>
>>>>>> CommitDate: Mon Nov 7 14:08:18 2022 -0500
>>>>>>
>>>>>>        hw/virtio: introduce virtio_device_should_start
>>>>>>
>>>>>> and older version?
>>>>>
>>>>> This is what got merged:
>>>>> https://lore.kernel.org/r/20221107121407.1010913-1-alex.bennee%40lina=
ro.org
>>>>> This patch was sent after I merged the RFC.
>>>>> I think the only difference is the commit log but I might be missing
>>>>> something.
>>>>>
>>>>>> This does not seem to fix the regression that I have reported.
>>>>>
>>>>> This was applied on top of 9f6bcfd99f which IIUC does, right?
>>>>>
>>>>>
>>>>
>>>> QEMU master still fails for me for suspend/resume to disk:
>>>>
>>>> #0  0x000003ff8e3980a6 in __pthread_kill_implementation () at /lib64/l=
ibc.so.6
>>>> #1  0x000003ff8e348580 in raise () at /lib64/libc.so.6
>>>> #2  0x000003ff8e32b5c0 in abort () at /lib64/libc.so.6
>>>> #3  0x000003ff8e3409da in __assert_fail_base () at /lib64/libc.so.6
>>>> #4  0x000003ff8e340a4e in  () at /lib64/libc.so.6
>>>> #5  0x000002aa1ffa8966 in vhost_vsock_common_pre_save (opaque=3D<optim=
ized out>) at ../hw/virtio/vhost-vsock-common.c:203
>>>> #6  0x000002aa1fe5e0ee in vmstate_save_state_v
>>>>       (f=3Df@entry=3D0x2aa21bdc170, vmsd=3D0x2aa204ac5f0 <vmstate_virt=
io_vhost_vsock>, opaque=3D0x2aa21bac9f8, vmdesc=3Dvmdesc@entry=3D0x3fddc08e=
b30, version_id=3Dversion_id@entry=3D0) at ../migration/vmstate.c:329
>>>> #7  0x000002aa1fe5ebf8 in vmstate_save_state (f=3Df@entry=3D0x2aa21bdc=
170, vmsd=3D<optimized out>, opaque=3D<optimized out>, vmdesc_id=3Dvmdesc_i=
d@entry=3D0x3fddc08eb30) at ../migration/vmstate.c:317
>>>> #8  0x000002aa1fe75bd0 in vmstate_save (f=3Df@entry=3D0x2aa21bdc170, s=
e=3Dse@entry=3D0x2aa21bdbe90, vmdesc=3Dvmdesc@entry=3D0x3fddc08eb30) at ../=
migration/savevm.c:908
>>>> #9  0x000002aa1fe79584 in qemu_savevm_state_complete_precopy_non_itera=
ble (f=3Df@entry=3D0x2aa21bdc170, in_postcopy=3Din_postcopy@entry=3Dfalse, =
inactivate_disks=3Dinactivate_disks@entry=3Dtrue)
>>>>       at ../migration/savevm.c:1393
>>>> #10 0x000002aa1fe79a96 in qemu_savevm_state_complete_precopy (f=3D0x2a=
a21bdc170, iterable_only=3Diterable_only@entry=3Dfalse, inactivate_disks=3D=
inactivate_disks@entry=3Dtrue) at ../migration/savevm.c:1459
>>>> #11 0x000002aa1fe6d6ee in migration_completion (s=3D0x2aa218ef600) at =
../migration/migration.c:3314
>>>> #12 migration_iteration_run (s=3D0x2aa218ef600) at ../migration/migrat=
ion.c:3761
>>>> #13 migration_thread (opaque=3Dopaque@entry=3D0x2aa218ef600) at ../mig=
ration/migration.c:3989
>>>> #14 0x000002aa201f0b8c in qemu_thread_start (args=3D<optimized out>) a=
t ../util/qemu-thread-posix.c:505
>>>> #15 0x000003ff8e396248 in start_thread () at /lib64/libc.so.6
>>>> #16 0x000003ff8e41183e in thread_start () at /lib64/libc.so.6
>>>>
>>>> Michael, your previous branch did work if I recall correctly.
>>>
>>> That one was failing under github CI though (for reasons we didn't
>>> really address, such as disconnect during stop causing a recursive
>>> call to stop, but there you are).
>> Even the double revert of everything?
>=20
> I don't remember at this point.
>=20
>> So how do we proceed now?
>=20
> I'm hopeful Alex will come up with a fix.


The initial fix changed to qemu/master does still work for me

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index a973811cbfc6..fb3072838119 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -411,14 +411,14 @@ static inline bool virtio_device_started(VirtIODevice=
 *vdev, uint8_t status)
   */
  static inline bool virtio_device_should_start(VirtIODevice *vdev, uint8_t=
 status)
  {
-    if (vdev->use_started) {
-        return vdev->started;
-    }
-
      if (!vdev->vm_running) {
          return false;
      }
 =20
+    if (vdev->use_started) {
+        return vdev->started;
+    }
+
      return status & VIRTIO_CONFIG_S_DRIVER_OK;
  }
 =20

