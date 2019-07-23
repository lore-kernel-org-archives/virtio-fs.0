References: <5D36C4EB.4010805@huawei.com> <20190723083150.GC2719@work-vm>
	<5D36C93A.5060908@huawei.com> <20190723090150.GD2719@work-vm>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D36CE46.2090307@huawei.com>
Date: Tue, 23 Jul 2019 17:07:18 +0800
MIME-Version: 1.0
In-Reply-To: <20190723090150.GD2719@work-vm>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] mount failed in virtio_fs dev 5.1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

Hi Dave,

It works when adding "-o rootmode=040000,user_id=0,group_id=0,dax".

Thanks,
Jun

On 2019/7/23 17:01, Dr. David Alan Gilbert wrote:
> * piaojun (piaojun@huawei.com) wrote:
>> Hi Dave,
>>
>> Thanks for your quick reply, and still mount failed. But I can not get
>> some useful message from dmesg.
>>
>> # mount -t virtio_fs myfs /mnt/virtiofs/
>> mount: wrong fs type, bad option, bad superblock on myfs,
>> missing codepage or helper program, or other error
>>
>> In some cases useful info is found in syslog - try
>> dmesg | tail or so.
> 
> This is working for me - but with the latest -dev qemu/virtiofsd as
> well; please make sure both are up to date:
> 
> I used:
> 
> mount -t virtio_fs myfs /sysroot -o rootmode=040000,user_id=0,group_id=0,dax
> 
> Dave
> 
>> On 2019/7/23 16:31, Dr. David Alan Gilbert wrote:
>>> * piaojun (piaojun@huawei.com) wrote:
>>>> Hi,
>>>>
>>>> I got a problem when mounting virtiofs in kernel5.1 as below:
>>>>
>>>> fuse: loading out-of-tree module taints kernel.
>>>> fuse: module verification failed: signature and/or required key missing - tainting kernel
>>>> fuse init (API version 7.29)
>>>> virtio_fs virtio1: Cache len: 0x80000000 @ 0x180000000
>>>> virtio1 initialised, 524288 pages in 12ms
>>>> virtio_fs_find_instance: fs->tag myfs, tag /dev/null
>>>> virtio-fs: tag </dev/null> not found
>>>> Mounting FUSE Control File System...
>>>> [/bin/bash]: [mount -t virtio_fs /dev/null /mnt/virtiofs/ -o tag=myfs] return code=[32], execute failed by [root(uid=0)] from [pts/0 (9.4.90.78)]
>>>>
>>>> And my kernel code is:
>>>> https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
>>>>
>>>> I wonder if the mount command has been changed?
>>>
>>> There was a change that went in last night, I believe the new format is:
>>>
>>> mount -t virtio_fs myfs /mnt/virtiofs/
>>>
>>> with the tagname going into the device position.
>>>
>>> Does that work?
>>>
>>> Dave
>>>
>>>
>>>> Thanks,
>>>> Jun
>>>>
>>>> _______________________________________________
>>>> Virtio-fs mailing list
>>>> Virtio-fs@redhat.com
>>>> https://www.redhat.com/mailman/listinfo/virtio-fs
>>> --
>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>> .
>>>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> .
> 

