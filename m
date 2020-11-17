From: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Date: Tue, 17 Nov 2020 16:00:09 +0000
Message-ID: <C5CAD300-DB1D-4C6A-A2D3-2E6BA9F901DF@intel.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
In-Reply-To: <CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <F189AD52D767C74C8E66B8902563DADD@intel.com>
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Miklos Szeredi <miklos@szeredi.hu>

>   Not sure what the default is for 9p, but comparing
>   default to default will definitely not be apples to apples since this
>   mode is nonexistent in 9p.

In Kata we are looking for the best config for fs compatibility and performance. So even if are no apples to apples,
we are for the best config for both and comparing the best that each of them can do.

In the case of Kata for 9pfs(this is the config we have found has better performance and fs compatibility  in general) we have:
```
-device virtio-9p-pci # device type
,disable-modern=false 
,fsdev=extra-9p-kataShared # attr: device id  for fsdev
,mount_tag=kataShared  # attr: tag on how will be found de sharedfs 
,romfile= 
-fsdev local  #local: Simply lets QEMU call the individual VFS functions (more or less) directly on host.
,id=extra-9p-kataShared 
,path=${SHARED_PATH} # attrs: path to share
,security_model=none #    
#    passthrough: Files are stored using the same credentials as they are created on the guest. This requires QEMU to run as # root.
#    none: Same as "passthrough" except the sever won't report failures if it fails to set file attributes like ownership # 
#  (chown). This makes a passthrough like security model usable for people who run kvm as non root.
,multidevs=remap
```

The mount options are:
```
trans=virtio 
    ,version=9p2000.L 
    ,cache=mmap 
    ,"nodev" # Security: The nodev mount option specifies that the filesystem cannot contain special devices. 
    ,"msize=8192" # msize: Maximum packet size including any headers.
```

Aditionally we use this patch https://github.com/kata-containers/packaging/blob/stable-1.12/qemu/patches/5.0.x/0001-9p-removing-coroutines-of-9p-to-increase-the-I-O-per.patch

In kata for virtiofs I am testing  use:
```
-chardev socket
,id=ID-SOCKET
,path=.../vhost-fs.sock  # Path to vhost socket
-device vhost-user-fs-pci #
,chardev=ID-SOCKET 
,tag=kataShared 
,romfile=

 -object memory-backend-file # force use of memory sharable with virtiofsd. 
 ,id=dimm1
 ,size=2048M
 ,mem-path=/dev/shm 
 ,share=on
```
Virtiofsd:
```
-o cache=auto 
-o no_posix_lock # enable/disable remote posix lock
--thread-pool-size=0
```

And virtiofs mount options:
```
source:\"kataShared\" 
fstype:\"virtiofs\"
```

With this patch, comparing this two configurations, I have seen better performance with virtiofs in different hosts.

-
Carlos

-

﻿On 12/11/20 3:06, "Miklos Szeredi" <mszeredi@redhat.com> wrote:

    On Fri, Nov 6, 2020 at 11:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
    >
    > On Fri, Nov 06, 2020 at 08:33:50PM +0000, Venegas Munoz, Jose Carlos wrote:
    > > Hi Vivek,
    > >
    > > I have tested with Kata 1.12-apha0, the results seems that are better for the use fio config I am tracking.
    > >
    > > The fio config does  randrw:
    > >
    > > fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75
    > >
    >
    > Hi Carlos,
    >
    > Thanks for the testing.
    >
    > So basically two conclusions from your tests.
    >
    > - for virtiofs, --thread-pool-size=0 is performing better as comapred
    >   to --thread-pool-size=1 as well as --thread-pool-size=64. Approximately
    >   35-40% better.
    >
    > - virtio-9p is still approximately 30% better than virtiofs
    >   --thread-pool-size=0.
    >
    > As I had done the analysis that this particular workload (mixed read and
    > write) is bad with virtiofs because after every write we are invalidating
    > attrs and cache so next read ends up fetching attrs again. I had posted
    > patches to gain some of the performance.
    >
    > https://lore.kernel.org/linux-fsdevel/20200929185015.GG220516@redhat.com/
    >
    > But I got the feedback to look into implementing file leases instead.

    Hmm, the FUSE_AUTO_INVAL_DATA feature is buggy, how about turning it
    off for now?   9p doesn't have it, so no point in enabling it for
    virtiofs by default.

    Also I think some confusion comes from cache=auto being the default
    for virtiofs.    Not sure what the default is for 9p, but comparing
    default to default will definitely not be apples to apples since this
    mode is nonexistent in 9p.

    9p:cache=none  <-> virtiofs:cache=none
    9p:cache=loose <-> virtiofs:cache=always

    "9p:cache=mmap" and "virtiofs:cache=auto" have no match.

    Untested patch attached.

    Thanks,
    Miklos


