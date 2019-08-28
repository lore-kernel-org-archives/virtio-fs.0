References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
	<5D633104.6030000@huawei.com>
	<20190827144258.GF6901@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D66279D.5000507@huawei.com>
Date: Wed, 28 Aug 2019 15:05:01 +0800
MIME-Version: 1.0
In-Reply-To: <20190827144258.GF6901@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
 affinity
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/8/27 22:42, Stefan Hajnoczi wrote:
> On Mon, Aug 26, 2019 at 09:08:20AM +0800, piaojun wrote:
>> On 2019/8/21 23:38, Stefan Hajnoczi wrote:
>>> On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
>>>> Set cpu affinity for each queue in multiqueue mode to improve the iops
>>>> performance.
>>>>
>>>> >From my test, the iops is increased by adding multiqueues as below,
>>>> but it has not achieved my expect yet due to some reason. So I'm
>>>> considering if we could drop some locks when operating vq as it is
>>>> binded to one vCPU. I'm very glad to have a discuss with other
>>>> developers.
>>>>
>>>> Further more, I modified virtiofsd to support multiqueue which just for
>>>> testing.
>>>>
>>>> Test Environment:
>>>> Guest configuration:
>>>> 8 vCPU
>>>> 8GB RAM
>>>> Linux 5.1 (vivek-aug-06-2019)
>>>>
>>>> Host configuration:
>>>> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
>>>> 32GB RAM
>>>> Linux 3.10.0
>>>> EXT4 + 4G Ramdisk
>>>>
>>>> ---
>>>> Single-queue:
>>>> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>>>> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
>>>> ...
>>>> fio-2.13
>>>> Starting 8 processes
>>>> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/0 iops] [eta 00m:00s]
>>>> file: (groupid=0, jobs=8): err= 0: pid=5808: Fri Aug  9 20:35:22 2019
>>>>   write: io=9499.9MB, bw=324251KB/s, iops=81062, runt= 30001msec
>>>>
>>>> Multi-queues:
>>>> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
>>>> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
>>>> ...
>>>> fio-2.13
>>>> Starting 8 processes
>>>> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0 iops] [eta 00m:00s]
>>>> file: (groupid=0, jobs=8): err= 0: pid=5704: Fri Aug  9 20:38:47 2019
>>>>   write: io=12967MB, bw=442582KB/s, iops=110645, runt= 30001msec
>>>> ---
>>>
>>> How does the same fio command-line perform on the host when bound to 8
>>> CPUs?
>>
>> fio has great performance on host side, so the bottleneck should be at virtiofsd.
>>
>> ---
>> Run status group 0 (all jobs):
>>   WRITE: bw=12.7GiB/s (13.6GB/s), 12.7GiB/s-12.7GiB/s (13.6GB/s-13.6GB/s), io=381GiB (409GB), run=30001-30001msec
> 
> Using just one file?

Also 8 files.

> 
>>>
>>> What about the virtiofsd changes?  Did you implement host CPU affinity
>>> for the virtqueue processing threads and their workqueues?
>>>
>>> I wonder if numbers are better if you use 8 files instead of 1 file.
>>>
>> I implement host CPU affinity and re-design the testcase with 8 files,
>> the result looks better:
>>
>> ---
>> [global]
>> runtime=30
>> time_based
>> group_reporting
>> direct=1
>> bs=1M
>> size=1G
>> ioengine=libaio
>> rw=write
>> numjobs=8
>> iodepth=128
>> thread=1
>>
>> [file1]
>> filename=/mnt/virtiofs/file1
>> numjobs=1
>> [file2]
>> filename=/mnt/virtiofs/file2
>> numjobs=1
>> [file3]
>> filename=/mnt/virtiofs/file3
>> numjobs=1
>> [file4]
>> filename=/mnt/virtiofs/file4
>> numjobs=1
>> [file5]
>> filename=/mnt/virtiofs/file5
>> numjobs=1
>> [file6]
>> filename=/mnt/virtiofs/file6
>> numjobs=1
>> [file7]
>> filename=/mnt/virtiofs/file7
>> numjobs=1
>> [file8]
>> filename=/mnt/virtiofs/file8
>> numjobs=1
>>
>> Single-Queue:
>> Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/1594MB/0KB /s] [0/1594/0 iops] [eta 00m:00s]
>> file1: (groupid=0, jobs=8): err= 0: pid=6379: Mon Aug 26 16:24:10 2019
>>   write: io=46676MB, bw=1555.6MB/s, iops=1555, runt= 30007msec
> 
> The result improves greatly when using separate files.  I wonder what
> the bottleneck is, maybe serialization in the guest kernel?

I run the fio testcases again, and find out the bottleneck is not the
serialization in guest kernel:

---
8 Files:
Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/1559MB/0KB /s] [0/1558/0 iops] [eta 00m:00s]
file1: (groupid=0, jobs=8): err= 0: pid=6540: Wed Aug 28 22:49:51 2019
  write: io=46367MB, bw=1545.3MB/s, iops=1545, runt= 30006msec

Single File:
Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/1567MB/0KB /s] [0/1566/0 iops] [eta 00m:00s]
file1: (groupid=0, jobs=8): err= 0: pid=6569: Wed Aug 28 22:50:33 2019
  write: io=47315MB, bw=1576.9MB/s, iops=1576, runt= 30006msec

> 
>>
>> Multi-Queues(8):
>> Jobs: 8 (f=8): [W(8)] [100.0% done] [0KB/4064MB/0KB /s] [0/4064/0 iops] [eta 00m:00s]
>> file1: (groupid=0, jobs=8): err= 0: pid=5785: Mon Aug 26 16:26:46 2019
>>   write: io=115421MB, bw=3847.2MB/s, iops=3847, runt= 30002msec
>>
>> I write a draft patch for virtiofsd, but the sandbox make it hard to
>> set affinity for each vq, as _SC_NPROCESSORS_ONLN always equals 1. So I
>> just delete the related code for testing. Maybe we could create a
>> thread pool before setup_sandbox() or some effective way. I'm glad to
>> help finding out the solution.
> 
> Doing the setup before entering the sandbox sounds like a good idea.
> That way the sandbox does not need to whitelist the required syscalls.
> 
> Will you add an option similar to:
> 
>   --request-queues N
>   --request-queue-cpu-affinity N=CPU_A[,CPU_B][-CPU_C]
> 
> ?

I'm writing the multi-queue code for virtiofsd according to your
suggestion, but the final shape may look a bit different.

Thanks,
Jun

