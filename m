DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=YdEBwNDzEsVoqQnxFXSmxBnr8W/jaRb/EbPmBMyt3ks=;
	b=MSF/6/lAvQQ63AXZEXsIRZR40Y
	7iVprjnetcr53ducJkDIuH3FdRP4Z9d7fDwozHcvLcJhpfVwbDKv7tzAn3SqSeX3CLS/BWJzxRUq2
	YTispDoMc2spwrzJUpwPb/qCIz4W7ZKGo8PiDjqTfWGNIdyeRl8BCIAwTl7nucgbh7/BpyjYXu/lT
	wTOavdVHJbGpTF33nRBfmP0wu4tlaCvvXn4RbAVjpuEvIcxfoNBQOSPo0joc24HenxN4wnsulZmYb
	wHabz4cwr+KVuHzy7CDafOMHdlOOwSEClFPLq1JwUAWBDRg2EAafd3cq0S/7FiIDSiWBoyn82SY3m
	Q738yJ3Q==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 17 Nov 2020 17:39:16 +0100
Message-ID: <5082873.Uf8toegZhN@silver>
In-Reply-To: <C5CAD300-DB1D-4C6A-A2D3-2E6BA9F901DF@intel.com>
References: <20201105194416.GA1384085@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
	<C5CAD300-DB1D-4C6A-A2D3-2E6BA9F901DF@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
To: qemu-devel@nongnu.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Dienstag, 17. November 2020 17:00:09 CET Venegas Munoz, Jose Carlos wrote:
> >   Not sure what the default is for 9p, but comparing
> >   default to default will definitely not be apples to apples since this
> >   mode is nonexistent in 9p.
> 
> 
> In Kata we are looking for the best config for fs compatibility and
> performance. So even if are no apples to apples, we are for the best
> config for both and comparing the best that each of them can do. 
> In the case of Kata for 9pfs(this is the config we have found has better
> performance and fs compatibility  in general) we have:
> ```
> -device virtio-9p-pci # device type
> ,disable-modern=false 
> ,fsdev=extra-9p-kataShared # attr: device id  for fsdev
> ,mount_tag=kataShared  # attr: tag on how will be found de sharedfs 
> ,romfile= 
> -fsdev local  #local: Simply lets QEMU call the individual VFS functions
> (more or less) directly on host.
> ,id=extra-9p-kataShared
> ,path=${SHARED_PATH} # attrs: path to share
> ,security_model=none #    
> #    passthrough: Files are stored using the same credentials as they are
> created on the guest. This requires QEMU to run as # root.
> #    none: Same
> as "passthrough" except the sever won't report failures if it fails to set
> file attributes like ownership # #  (chown). This makes a passthrough like
> security model usable for people who run kvm as non root. ,multidevs=remap
> ```
> 
> The mount options are:
> ```
> trans=virtio 
>     ,version=9p2000.L 
>     ,cache=mmap 
>     ,"nodev" # Security: The nodev mount option specifies that the
> filesystem cannot contain special devices. 
> ,"msize=8192" # msize: Maximum

Too small. You should definitely set 'msize' larger, as small a msize value 
causes 9p requests to be broken down into more and smaller 9p requests:
https://wiki.qemu.org/Documentation/9psetup#msize

Setting msize to a fairly high value might also substantially increase I/O 
performance i.e. on large I/O if guest application honors st_blksize returned 
by calling *stat() [ https://man7.org/linux/man-pages/man2/stat.2.html ]:

       st_blksize
              This field gives the "preferred" block size for efficient
              filesystem I/O.

For instance 'time cat /large/file' would be substantially faster, as it 
automatically adapts the chunk size.

> packet size including any headers. ```
> 
> Aditionally we use this patch
> https://github.com/kata-containers/packaging/blob/stable-1.12/qemu/patches/
> 5.0.x/0001-9p-removing-coroutines-of-9p-to-increase-the-I-O-per.patch

Interesting radical approach. :)

Yeah, the coroutine code in 9pfs is still a huge bottleneck. The problem of 
the existing coroutine code is that it dispatches too often between threads 
(i.e. main I/O thread of 9p server and background I/O threads doing the fs 
driver work) which causes huge latencies.

I started to fix that, yet I only completed the Treaddir request handler so 
far, which however gave a huge performance boost on such Treaddir requests:
https://lists.gnu.org/archive/html/qemu-devel/2020-01/msg05539.html

The plan is to do the same for the other 9p request handlers, and finally 
introducing an 'order=relaxed' option (right now the order is strict only).

That should end up being faster than your current no-coroutine hack later on, 
because you would have the benefits of both worlds: low latency and 
parallelism for the fs driver I/O work.

> In kata for virtiofs I am testing  use:
> ```
> -chardev socket
> ,id=ID-SOCKET
> ,path=.../vhost-fs.sock  # Path to vhost socket
> -device vhost-user-fs-pci #
> ,chardev=ID-SOCKET 
> ,tag=kataShared 
> ,romfile=
> 
>  -object memory-backend-file # force use of memory sharable with virtiofsd.
>  ,id=dimm1
>  ,size=2048M
>  ,mem-path=/dev/shm 
>  ,share=on
> ```
> Virtiofsd:
> ```
> -o cache=auto 
> -o no_posix_lock # enable/disable remote posix lock
> --thread-pool-size=0
> ```
> 
> And virtiofs mount options:
> ```
> source:\"kataShared\" 
> fstype:\"virtiofs\"
> ```
> 
> With this patch, comparing this two configurations, I have seen better
> performance with virtiofs in different hosts.
> -
> Carlos
> 
> -
> 
> ﻿On 12/11/20 3:06, "Miklos Szeredi" <mszeredi@redhat.com> wrote:
> 
>     On Fri, Nov 6, 2020 at 11:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
>     >
>     >
>     > On Fri, Nov 06, 2020 at 08:33:50PM +0000, Venegas Munoz, Jose Carlos
>     > wrote:
>     > > 
>     > > Hi Vivek,
>     > >
>     > >
>     > >
>     > > I have tested with Kata 1.12-apha0, the results seems that are
>     > > better for the use fio config I am tracking.
>     > > > >
>     > >
>     > >
>     > > The fio config does  randrw:
>     > >
>     > >
>     > >
>     > > fio --direct=1 --gtod_reduce=1 --name=test
>     > > --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M
>     > > --readwrite=randrw --rwmixread=75
>     > > > >
>     > >
>     >
>     >
>     >
>     > Hi Carlos,
>     >
>     >
>     >
>     > Thanks for the testing.
>     >
>     >
>     >
>     > So basically two conclusions from your tests.
>     >
>     >
>     >
>     > - for virtiofs, --thread-pool-size=0 is performing better as comapred
>     > 
>     >   to --thread-pool-size=1 as well as --thread-pool-size=64.
>     >   Approximately
>     >   35-40% better.
>     >
>     >
>     >
>     > - virtio-9p is still approximately 30% better than virtiofs
>     > 
>     >   --thread-pool-size=0.
>     >
>     >
>     >
>     > As I had done the analysis that this particular workload (mixed read
>     > and
>     > write) is bad with virtiofs because after every write we are
>     > invalidating
>     > attrs and cache so next read ends up fetching attrs again. I had
>     > posted
>     > patches to gain some of the performance.
>     >
>     >
>     >
>     > https://lore.kernel.org/linux-fsdevel/20200929185015.GG220516@redhat.c
>     > om/
>     >
>     >
>     >
>     > But I got the feedback to look into implementing file leases instead.
> 
> 
>     Hmm, the FUSE_AUTO_INVAL_DATA feature is buggy, how about turning it
>     off for now?   9p doesn't have it, so no point in enabling it for
>     virtiofs by default.
> 
>     Also I think some confusion comes from cache=auto being the default
>     for virtiofs.    Not sure what the default is for 9p, but comparing
>     default to default will definitely not be apples to apples since this
>     mode is nonexistent in 9p.
> 
>     9p:cache=none  <-> virtiofs:cache=none
>     9p:cache=loose <-> virtiofs:cache=always
> 
>     "9p:cache=mmap" and "virtiofs:cache=auto" have no match.
> 
>     Untested patch attached.
> 
>     Thanks,
>     Miklos
> 

Best regards,
Christian Schoenebeck



