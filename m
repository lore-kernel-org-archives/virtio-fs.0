References: <20190801165409.20121-1-stefanha@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4799E5.6020006@huawei.com>
Date: Mon, 5 Aug 2019 10:52:21 +0800
MIME-Version: 1.0
In-Reply-To: <20190801165409.20121-1-stefanha@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org

Hi Stefan,

>From my test, 9p has better bandwidth than virtio as below:

---
9p Test:
# mount -t 9p -o trans=virtio,version=9p2000.L,rw,nodev,msize=1000000000,access=client 9pshare /mnt/9pshare

# fio -direct=1 -time_based -iodepth=1 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=1 -runtime=30 -group_reporting -name=file -filename=/mnt/9pshare/file
file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=1
fio-2.13
Starting 1 process
file: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/1091MB/0KB /s] [0/1091/0 iops] [eta 00m:00s]
file: (groupid=0, jobs=1): err= 0: pid=6187: Mon Aug  5 17:55:44 2019
  write: io=35279MB, bw=1175.1MB/s, iops=1175, runt= 30001msec
    slat (usec): min=589, max=4211, avg=844.04, stdev=124.04
    clat (usec): min=1, max=24, avg= 2.53, stdev= 1.16
     lat (usec): min=591, max=4214, avg=846.57, stdev=124.14
    clat percentiles (usec):
     |  1.00th=[    2],  5.00th=[    2], 10.00th=[    2], 20.00th=[    2],
     | 30.00th=[    2], 40.00th=[    2], 50.00th=[    2], 60.00th=[    3],
     | 70.00th=[    3], 80.00th=[    3], 90.00th=[    3], 95.00th=[    3],
     | 99.00th=[    4], 99.50th=[   13], 99.90th=[   18], 99.95th=[   20],
     | 99.99th=[   22]
    lat (usec) : 2=0.04%, 4=98.27%, 10=1.15%, 20=0.48%, 50=0.06%
  cpu          : usr=23.83%, sys=5.24%, ctx=105843, majf=0, minf=9
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=35279/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
---

---
virtiofs Test:
# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/mnt/virtiofs/ -o cache=none

# mount -t virtio_fs myfs /mnt/virtiofs -o rootmode=040000,user_id=0,group_id=0

# fio -direct=1 -time_based -iodepth=1 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=1 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=1
fio-2.13
Starting 1 process
file: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/895.1MB/0KB /s] [0/895/0 iops] [eta 00m:00s]
file: (groupid=0, jobs=1): err= 0: pid=6046: Mon Aug  5 17:54:58 2019
  write: io=23491MB, bw=801799KB/s, iops=783, runt= 30001msec
    slat (usec): min=93, max=390, avg=233.40, stdev=64.22
    clat (usec): min=849, max=4083, avg=1039.32, stdev=178.98
     lat (usec): min=971, max=4346, avg=1272.72, stdev=200.34
    clat percentiles (usec):
     |  1.00th=[  972],  5.00th=[  980], 10.00th=[  988], 20.00th=[  988],
     | 30.00th=[  996], 40.00th=[ 1004], 50.00th=[ 1012], 60.00th=[ 1012],
     | 70.00th=[ 1020], 80.00th=[ 1032], 90.00th=[ 1032], 95.00th=[ 1384],
     | 99.00th=[ 1560], 99.50th=[ 1768], 99.90th=[ 3664], 99.95th=[ 4016],
     | 99.99th=[ 4048]
    lat (usec) : 1000=37.21%
    lat (msec) : 2=62.39%, 4=0.34%, 10=0.06%
  cpu          : usr=15.39%, sys=4.03%, ctx=23496, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=23491/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
---

And the backend filesystem is ext4 + ramdisk, and 9p has deeper queue
depth than virtiofs catched by iostat. Then I check the code, and found
9p uses pwritev, but virtiofs uses pwrite. I wonder if virtiofs could
also use iovec to improve its performance.

I'd like to help contributing the patch in the future.

Thanks,
Jun

On 2019/8/2 0:54, Stefan Hajnoczi wrote:
> This patch series introduces the virtiofsd --thread-pool-size=NUM and sets the
> default value to 64.  Each virtqueue has its own thread pool for processing
> requests.  Blocking requests no longer pause virtqueue processing and I/O
> performance should be greatly improved when the queue depth is greater than 1.
> 
> Linux boot and pjdfstest have been tested with these patches and the default
> thread pool size of 64.
> 
> I have now concluded the thread-safety code audit.  Please let me know if you
> have concerns about things I missed.
> 
> Performance
> -----------
> Please try these patches out and share your results.
> 
> Scalability
> -----------
> There are several synchronization primitives that are taken by the virtqueue
> processing thread or the thread pool worker.  Unfortunately this is necessary
> to protect shared state.  It means that thread pool workers contend on or at
> least access thread synchronization primitives.  If anyone has suggestions for
> improving this situation, please discuss.
> 
> 1. vu_dispatch_rwlock - libvhost-user from races between the vhost-user
>    protocol thread and the virtqueue processing and thread pool worker threads.
> 
> 2. vq_lock - protects the virtqueue from races between the virtqueue processing
>    thread and thread pool workers.
> 
> 3. init_rwlock - protects FUSE_INIT/FUSE_DESTROY from races with other
>    requests.
> 
> 4. se->lock - protects se->list and the FUSE_INTERRUPT shared state.
> 
> Ideally we could avoid hitting all of these locks on each request.  That would
> make the code scale better.
> 
> Future work
> -----------
> This series does not complete the multithreading effort yet.  Two items are
> still missing:
> 1. Multiqueue support
> 2. CPU affinity for virtqueue processing threads and thread pools
> 
> Stefan Hajnoczi (4):
>   virtiofsd: process requests in a thread pool
>   virtiofsd: prevent FUSE_INIT/FUSE_DESTROY races
>   virtiofsd: fix lo_destroy() resource leaks
>   virtiofsd: add --thread-pool-size=NUM option
> 
>  contrib/virtiofsd/fuse_i.h         |   2 +
>  contrib/virtiofsd/fuse_lowlevel.c  |  25 +-
>  contrib/virtiofsd/fuse_virtio.c    | 491 ++++++++++++++++-------------
>  contrib/virtiofsd/passthrough_ll.c |  43 ++-
>  contrib/virtiofsd/seccomp.c        |   1 +
>  5 files changed, 318 insertions(+), 244 deletions(-)
> 

