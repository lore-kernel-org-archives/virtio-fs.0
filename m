References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4BD8D8.5080402@huawei.com>
Date: Thu, 8 Aug 2019 16:10:00 +0800
MIME-Version: 1.0
In-Reply-To: <20190807180355.GA22758@stefanha-x1.localdomain>
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

>From my test, your patch set of multithreading improves iops greatly as
below:

Guest configuration:
8 vCPU
8GB RAM
Linux 5.1 (vivek-aug-06-2019)

Host configuration:
Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
32GB RAM
Linux 3.10.0
EXT4 + LVM + local HDD

---
Before:
# fio -direct=1 -time_based -iodepth=64 -rw=randread -ioengine=libaio -bs=4k -size=1G -numjob=1 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
Jobs: 1 (f=1): [r(1)] [100.0% done] [1177KB/0KB/0KB /s] [294/0/0 iops] [eta 00m:00s]
file: (groupid=0, jobs=1): err= 0: pid=6037: Thu Aug  8 23:18:59 2019
  read : io=35148KB, bw=1169.9KB/s, iops=292, runt= 30045msec

After:
Jobs: 1 (f=1): [r(1)] [100.0% done] [6246KB/0KB/0KB /s] [1561/0/0 iops] [eta 00m:00s]
file: (groupid=0, jobs=1): err= 0: pid=5850: Thu Aug  8 23:21:22 2019
  read : io=191216KB, bw=6370.7KB/s, iops=1592, runt= 30015msec
---

But there is no iops improvment when I change from HDD to ramdisk. I
guess this is because ramdisk has no iodepth.

Thanks,
Jun

On 2019/8/8 2:03, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2019 at 05:54:05PM +0100, Stefan Hajnoczi wrote:
>> Performance
>> -----------
>> Please try these patches out and share your results.
> 
> Here are the performance numbers:
> 
>   Threadpool | iodepth | iodepth
>      size    |    1    |   64
>   -----------+---------+--------
>   None       |   4451  |  4876
>   1          |   4360  |  4858
>   64         |   4359  | 33,266
> 
> A graph is available here:
> https://vmsplice.net/~stefan/virtiofsd-threadpool-performance.png
> 
> Summary:
> 
>  * iodepth=64 performance is increased by 6.8 times.
>  * iodepth=1 performance degrades by 2%.
>  * DAX is bottlenecked by QEMU's single-threaded
>    VHOST_USER_SLAVE_FS_MAP/UNMAP handler.
> 
> Threadpool size "none" is virtiofsd commit 813a824b707 ("virtiofsd: use
> fuse_lowlevel_is_virtio() in fuse_session_destroy()") without any of the
> multithreading preparation patches.  I benchmarked this to check whether
> the patches introduce a regression for iodepth=1.  They do, but it's
> only around 2%.
> 
> I also ran with DAX but found there was not much difference between
> iodepth=1 and iodepth=64.  This might be because the host mmap(2)
> syscall becomes the bottleneck and a serialization point.  QEMU only
> processes one VHOST_USER_SLAVE_FS_MAP/UNMAP at a time.  If we want to
> accelerate DAX it may be necessary to parallelize mmap, assuming the
> host kernel can do them in parallel on a single file.  This performance
> optimization is future work and not directly related to this patch
> series.
> 
> The following fio job was run with cache=none and no DAX:
> 
>   [global]
>   runtime=60
>   ramp_time=30
>   filename=/var/tmp/fio.dat
>   direct=1
>   rw=randread
>   bs=4k
>   size=4G
>   ioengine=libaio
>   iodepth=1
> 
>   [read]
> 
> Guest configuration:
> 1 vCPU
> 4 GB RAM
> Linux 5.1 (vivek-aug-06-2019)
> 
> Host configuration:
> Intel(R) Core(TM) i7-5600U CPU @ 2.60GHz (2 cores x 2 threads)
> 8 GB RAM
> Linux 5.1.20-300.fc30.x86_64
> XFS + dm-thin + dm-crypt
> Toshiba THNSFJ256GDNU (256 GB SATA SSD)
> 
> Stefan
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 

