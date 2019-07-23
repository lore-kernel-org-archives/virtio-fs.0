Date: Tue, 23 Jul 2019 09:31:50 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190723083150.GC2719@work-vm>
References: <5D36C4EB.4010805@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D36C4EB.4010805@huawei.com>
Subject: Re: [Virtio-fs] mount failed in virtio_fs dev 5.1
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

* piaojun (piaojun@huawei.com) wrote:
> Hi,
> 
> I got a problem when mounting virtiofs in kernel5.1 as below:
> 
> fuse: loading out-of-tree module taints kernel.
> fuse: module verification failed: signature and/or required key missing - tainting kernel
> fuse init (API version 7.29)
> virtio_fs virtio1: Cache len: 0x80000000 @ 0x180000000
> virtio1 initialised, 524288 pages in 12ms
> virtio_fs_find_instance: fs->tag myfs, tag /dev/null
> virtio-fs: tag </dev/null> not found
> Mounting FUSE Control File System...
> [/bin/bash]: [mount -t virtio_fs /dev/null /mnt/virtiofs/ -o tag=myfs] return code=[32], execute failed by [root(uid=0)] from [pts/0 (9.4.90.78)]
> 
> And my kernel code is:
> https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> 
> I wonder if the mount command has been changed?

There was a change that went in last night, I believe the new format is:

mount -t virtio_fs myfs /mnt/virtiofs/

with the tagname going into the device position.

Does that work?

Dave


> Thanks,
> Jun
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

