Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wnrvqDFto/GHfNdryfB/KwhOPELJCrUbc1JvPxSGaSw=;
 b=IJtQ2ZRgHMNePC5IRo0Qu91gdMaZ6rBNUA07czS8IA6ja9n10Fbd38xxaAgnSdnUFPtc
 OOGMVVYqx/rcN++7vS3s921nYqpH3jmfvjgQRwWbISZNyJal5ZwU5n9O8cJtcW51nv2f
 YNigS22OIfNNFJHS1WUk5zQpMSmkKlKWrgsWSqKTu6X8Ond8tvYMih7Rbwgz8jegtShK
 8y+9CJhuPM6i6EIN4knmDw+xAPSLNEFYPZdW6CxvEXhowpnTO/ZrTLqpZrswCyBtJ7BT
 oRLYsPTQolXJ0l5/33quVBlAq4rQNFg2n+YM2qUD5caY8sGmOfndYnixySGxPlRwcmuL ow==
Message-ID: <1bfc2fee-5972-676e-563e-e245814e54c3@linux.ibm.com>
Date: Tue, 15 Nov 2022 17:46:58 +0100
From: Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <2277569a-c218-30d1-4d88-9b77d3604513@linux.ibm.com>
 <20221114113518-mutt-send-email-mst@kernel.org>
 <aaae3f2a-c5bb-8e62-09d4-4f6f43efe37b@linux.ibm.com>
 <20221114115549-mutt-send-email-mst@kernel.org>
 <2bd5f801-a203-2598-3e6e-ed8f5dad5159@linux.ibm.com>
 <20221114121959-mutt-send-email-mst@kernel.org> <87tu309tlk.fsf@linaro.org>
 <26b4e8d8-784d-d1ce-67a3-b61896701bf7@linux.ibm.com>
 <87leoc9p98.fsf@linaro.org>
 <471b71ad-1892-8ab4-a94b-c0ec3d34e6b1@linux.ibm.com>
In-Reply-To: <471b71ad-1892-8ab4-a94b-c0ec3d34e6b1@linux.ibm.com>
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
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>



Am 15.11.22 um 17:40 schrieb Christian Borntraeger:
>=20
>=20
> Am 15.11.22 um 17:05 schrieb Alex Benn=C3=A9e:
>>
>> Christian Borntraeger <borntraeger@linux.ibm.com> writes:
>>
>>> Am 15.11.22 um 15:31 schrieb Alex Benn=C3=A9e:
>>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>>>
>>>>> On Mon, Nov 14, 2022 at 06:15:30PM +0100, Christian Borntraeger wrote=
:
>>>>>>
>>>>>>
>>>>>> Am 14.11.22 um 18:10 schrieb Michael S. Tsirkin:
>>>>>>> On Mon, Nov 14, 2022 at 05:55:09PM +0100, Christian Borntraeger wro=
te:
>>>>>>>>
>>>>>>>>
>>>>>>>> Am 14.11.22 um 17:37 schrieb Michael S. Tsirkin:
>>>>>>>>> On Mon, Nov 14, 2022 at 05:18:53PM +0100, Christian Borntraeger w=
rote:
>>>>>>>>>> Am 08.11.22 um 10:23 schrieb Alex Benn=C3=A9e:
>>>>>>>>>>> The previous fix to virtio_device_started revealed a problem in=
 its
>>>>>>>>>>> use by both the core and the device code. The core code should =
be able
>>>>>>>>>>> to handle the device "starting" while the VM isn't running to h=
andle
>>>>>>>>>>> the restoration of migration state. To solve this dual use intr=
oduce a
>>>>>>>>>>> new helper for use by the vhost-user backends who all use it to=
 feed a
>>>>>>>>>>> should_start variable.
>>>>>>>>>>>
>>>>>>>>>>> We can also pick up a change vhost_user_blk_set_status while we=
 are at
>>>>>>>>>>> it which follows the same pattern.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_d=
evice_started)
>>>>>>>>>>> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gp=
io device)
>>>>>>>>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>>>>>>>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>>>>>>>>>
>>>>>>>>>> Hmmm, is this
>>>>>>>>>> commit 259d69c00b67c02a67f3bdbeeea71c2c0af76c35
>>>>>>>>>> Author:=C2=A0=C2=A0=C2=A0=C2=A0 Alex Benn=C3=A9e <alex.bennee@li=
naro.org>
>>>>>>>>>> AuthorDate: Mon Nov 7 12:14:07 2022 +0000
>>>>>>>>>> Commit:=C2=A0=C2=A0=C2=A0=C2=A0 Michael S. Tsirkin <mst@redhat.c=
om>
>>>>>>>>>> CommitDate: Mon Nov 7 14:08:18 2022 -0500
>>>>>>>>>>
>>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw/virtio: introduce =
virtio_device_should_start
>>>>>>>>>>
>>>>>>>>>> and older version?
>>>>>>>>>
>>>>>>>>> This is what got merged:
>>>>>>>>> https://lore.kernel.org/r/20221107121407.1010913-1-alex.bennee%40=
linaro.org
>>>>>>>>> This patch was sent after I merged the RFC.
>>>>>>>>> I think the only difference is the commit log but I might be miss=
ing
>>>>>>>>> something.
>>>>>>>>>
>>>>>>>>>> This does not seem to fix the regression that I have reported.
>>>>>>>>>
>>>>>>>>> This was applied on top of 9f6bcfd99f which IIUC does, right?
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> QEMU master still fails for me for suspend/resume to disk:
>>>>>>>>
>>>>>>>> #0=C2=A0 0x000003ff8e3980a6 in __pthread_kill_implementation () at=
 /lib64/libc.so.6
>>>>>>>> #1=C2=A0 0x000003ff8e348580 in raise () at /lib64/libc.so.6
>>>>>>>> #2=C2=A0 0x000003ff8e32b5c0 in abort () at /lib64/libc.so.6
>>>>>>>> #3=C2=A0 0x000003ff8e3409da in __assert_fail_base () at /lib64/lib=
c.so.6
>>>>>>>> #4=C2=A0 0x000003ff8e340a4e in=C2=A0 () at /lib64/libc.so.6
>>>>>>>> #5 0x000002aa1ffa8966 in vhost_vsock_common_pre_save
>>>>>>>> (opaque=3D<optimized out>) at
>>>>>>>> ../hw/virtio/vhost-vsock-common.c:203
>>>>>>>> #6=C2=A0 0x000002aa1fe5e0ee in vmstate_save_state_v
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (f=3Df@entry=3D0x2aa21bdc170,=
 vmsd=3D0x2aa204ac5f0
>>>>>>>> <vmstate_virtio_vhost_vsock>, opaque=3D0x2aa21bac9f8,
>>>>>>>> vmdesc=3Dvmdesc@entry=3D0x3fddc08eb30,
>>>>>>>> version_id=3Dversion_id@entry=3D0) at ../migration/vmstate.c:329
>>>>>>>> #7 0x000002aa1fe5ebf8 in vmstate_save_state
>>>>>>>> (f=3Df@entry=3D0x2aa21bdc170, vmsd=3D<optimized out>,
>>>>>>>> opaque=3D<optimized out>, vmdesc_id=3Dvmdesc_id@entry=3D0x3fddc08e=
b30)
>>>>>>>> at ../migration/vmstate.c:317
>>>>>>>> #8 0x000002aa1fe75bd0 in vmstate_save (f=3Df@entry=3D0x2aa21bdc170=
,
>>>>>>>> se=3Dse@entry=3D0x2aa21bdbe90, vmdesc=3Dvmdesc@entry=3D0x3fddc08eb=
30) at
>>>>>>>> ../migration/savevm.c:908
>>>>>>>> #9 0x000002aa1fe79584 in
>>>>>>>> qemu_savevm_state_complete_precopy_non_iterable
>>>>>>>> (f=3Df@entry=3D0x2aa21bdc170, in_postcopy=3Din_postcopy@entry=3Dfa=
lse,
>>>>>>>> inactivate_disks=3Dinactivate_disks@entry=3Dtrue)
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 at ../migration/savevm.c:1393
>>>>>>>> #10 0x000002aa1fe79a96 in qemu_savevm_state_complete_precopy
>>>>>>>> (f=3D0x2aa21bdc170, iterable_only=3Diterable_only@entry=3Dfalse,
>>>>>>>> inactivate_disks=3Dinactivate_disks@entry=3Dtrue) at
>>>>>>>> ../migration/savevm.c:1459
>>>>>>>> #11 0x000002aa1fe6d6ee in migration_completion (s=3D0x2aa218ef600)=
 at ../migration/migration.c:3314
>>>>>>>> #12 migration_iteration_run (s=3D0x2aa218ef600) at ../migration/mi=
gration.c:3761
>>>>>>>> #13 migration_thread (opaque=3Dopaque@entry=3D0x2aa218ef600) at ..=
/migration/migration.c:3989
>>>>>>>> #14 0x000002aa201f0b8c in qemu_thread_start (args=3D<optimized out=
>) at ../util/qemu-thread-posix.c:505
>>>>>>>> #15 0x000003ff8e396248 in start_thread () at /lib64/libc.so.6
>>>>>>>> #16 0x000003ff8e41183e in thread_start () at /lib64/libc.so.6
>>>>>>>>
>>>>>>>> Michael, your previous branch did work if I recall correctly.
>>>>>>>
>>>>>>> That one was failing under github CI though (for reasons we didn't
>>>>>>> really address, such as disconnect during stop causing a recursive
>>>>>>> call to stop, but there you are).
>>>>>> Even the double revert of everything?
>>>>>
>>>>> I don't remember at this point.
>>>>>
>>>>>> So how do we proceed now?
>>>>>
>>>>> I'm hopeful Alex will come up with a fix.
>>>> I need to replicate the failing test for that. Which test is
>>>> failing?
>>>
>>>
>>> Pretty much the same as before. guest with vsock, managedsave and
>>> restore.
>>
>> If this isn't in our test suite I'm going to need exact steps.
>=20
> Just get any libvirt guest, add
>  =C2=A0=C2=A0=C2=A0 <vsock model=3D'virtio'>
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <cid auto=3D'yes'/>
>  =C2=A0=C2=A0=C2=A0 </vsock>
>=20
> to your libvirt xml. Start the guest (with the new xml).
> Run virsh managedsave - qemu crashes. On x86 and s390.


the libvirt log:

/home/cborntra/REPOS/qemu/build/x86_64-softmmu/qemu-system-x86_64 \
-name guest=3Df36,debug-threads=3Don \
-S \
-object '{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/var=
/lib/libvirt/qemu/domain-1-f36/master-key.aes"}' \
-machine pc-i440fx-7.2,usb=3Doff,dump-guest-core=3Doff,memory-backend=3Dpc.=
ram \
-accel kvm \
-cpu Cooperlake,ss=3Don,pdcm=3Don,hypervisor=3Don,tsc-adjust=3Don,avx512ifm=
a=3Don,sha-ni=3Don,avx512vbmi=3Don,umip=3Don,avx512vbmi2=3Don,gfni=3Don,vae=
s=3Don,vpclmulqdq=3Don,avx512bitalg=3Don,avx512-vpopcntdq=3Don,rdpid=3Don,m=
ovdiri=3Don,movdir64b=3Don,fsrm=3Don,md-clear=3Don,xsaves=3Don,ibpb=3Don,ib=
rs=3Don,amd-stibp=3Don,amd-ssbd=3Don,hle=3Doff,rtm=3Doff,avx512-bf16=3Doff,=
taa-no=3Doff \
-m 2048 \
-object '{"qom-type":"memory-backend-ram","id":"pc.ram","size":2147483648}'=
 \
-overcommit mem-lock=3Doff \
-smp 2,sockets=3D2,cores=3D1,threads=3D1 \
-uuid 712590b2-fbd8-4a2f-a8e9-be33cb9ee0da \
-display none \
-no-user-config \
-nodefaults \
-chardev socket,id=3Dcharmonitor,fd=3D39,server=3Don,wait=3Doff \
-mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol \
-rtc base=3Dutc,driftfix=3Dslew \
-global kvm-pit.lost_tick_policy=3Ddelay \
-no-hpet \
-no-shutdown \
-global PIIX4_PM.disable_s3=3D1 \
-global PIIX4_PM.disable_s4=3D1 \
-boot strict=3Don \
-device ich9-usb-ehci1,id=3Dusb,bus=3Dpci.0,addr=3D0x3.0x7 \
-device ich9-usb-uhci1,masterbus=3Dusb.0,firstport=3D0,bus=3Dpci.0,multifun=
ction=3Don,addr=3D0x3 \
-device ich9-usb-uhci2,masterbus=3Dusb.0,firstport=3D2,bus=3Dpci.0,addr=3D0=
x3.0x1 \
-device ich9-usb-uhci3,masterbus=3Dusb.0,firstport=3D4,bus=3Dpci.0,addr=3D0=
x3.0x2 \
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/images/f36.qcow2",=
"node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-1-format","read-only":false,"driver":"qcow=
2","file":"libvirt-1-storage","backing":null}' \
-device ide-hd,bus=3Dide.0,unit=3D0,drive=3Dlibvirt-1-format,id=3Dide0-0-0,=
bootindex=3D1 \
-netdev user,id=3Dhostnet0 \
-device e1000,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:20:ba:4a,bus=3Dpci=
.0,addr=3D0x2 \
-chardev pty,id=3Dcharserial0 \
-device isa-serial,chardev=3Dcharserial0,id=3Dserial0 \
-audiodev '{"id":"audio1","driver":"none"}' \
-device virtio-balloon-pci,id=3Dballoon0,bus=3Dpci.0,addr=3D0x4 \
-sandbox on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcec=
ontrol=3Ddeny \
-device vhost-vsock-pci,id=3Dvsock0,guest-cid=3D3,vhostfd=3D35,bus=3Dpci.0,=
addr=3D0x5 \
-msg timestamp=3Don
char device redirected to /dev/pts/1 (label charserial0)
qemu-system-x86_64: ../hw/virtio/vhost-vsock-common.c:203: vhost_vsock_comm=
on_pre_save: Assertion `!vhost_dev_is_started(&vvc->vhost_dev)' failed.
2022-11-15 16:38:46.096+0000: shutting down, reason=3Dcrashed

