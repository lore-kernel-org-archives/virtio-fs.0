Date: Fri, 25 Sep 2020 13:41:39 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200925124139.GJ2873@work-vm>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924221023.GB132653@redhat.com>
Subject: Re: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs:
 Multi threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Thu, Sep 24, 2020 at 09:33:01PM +0000, Venegas Munoz, Jose Carlos wrote:
> > Hi Folks,
> > 
> > Sorry for the delay about how to reproduce `fio` data.
> > 
> > I have some code to automate testing for multiple kata configs and collect info like:
> > - Kata-env, kata configuration.toml, qemu command, virtiofsd command.
> > 
> > See: 
> > https://github.com/jcvenegas/mrunner/
> > 
> > 
> > Last time we agreed to narrow the cases and configs to compare virtiofs and 9pfs
> > 
> > The configs where the following:
> > 
> > - qemu + virtiofs(cache=auto, dax=0) a.ka. `kata-qemu-virtiofs` WITOUT xattr
> > - qemu + 9pfs a.k.a `kata-qemu`
> > 
> > Please take a look to the html and raw results I attach in this mail.
> 
> Hi Carlos,
> 
> So you are running following test.
> 
> fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75 --output=/output/fio.txt
> 
> And following are your results.
> 
> 9p
> --
> READ: bw=211MiB/s (222MB/s), 211MiB/s-211MiB/s (222MB/s-222MB/s), io=3070MiB (3219MB), run=14532-14532msec
> 
> WRITE: bw=70.6MiB/s (74.0MB/s), 70.6MiB/s-70.6MiB/s (74.0MB/s-74.0MB/s), io=1026MiB (1076MB), run=14532-14532msec
> 
> virtiofs
> --------
> Run status group 0 (all jobs):
>    READ: bw=159MiB/s (167MB/s), 159MiB/s-159MiB/s (167MB/s-167MB/s), io=3070MiB (3219MB), run=19321-19321msec
>   WRITE: bw=53.1MiB/s (55.7MB/s), 53.1MiB/s-53.1MiB/s (55.7MB/s-55.7MB/s), io=1026MiB (1076MB), run=19321-19321msec
> 
> So looks like you are getting better performance with 9p in this case.

That's interesting, because I've just tried similar again with my
ramdisk setup:

fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75 --output=aname.txt


virtiofs default options
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=64
fio-3.21
Starting 1 process
test: Laying out IO file (1 file / 4096MiB)

test: (groupid=0, jobs=1): err= 0: pid=773: Fri Sep 25 12:28:32 2020
  read: IOPS=18.3k, BW=71.3MiB/s (74.8MB/s)(3070MiB/43042msec)
   bw (  KiB/s): min=70752, max=77280, per=100.00%, avg=73075.71, stdev=1603.47, samples=85
   iops        : min=17688, max=19320, avg=18268.92, stdev=400.86, samples=85
  write: IOPS=6102, BW=23.8MiB/s (24.0MB/s)(1026MiB/43042msec); 0 zone resets
   bw (  KiB/s): min=23128, max=25696, per=100.00%, avg=24420.40, stdev=583.08, samples=85
   iops        : min= 5782, max= 6424, avg=6105.09, stdev=145.76, samples=85
  cpu          : usr=0.10%, sys=30.09%, ctx=1245312, majf=0, minf=6
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=785920,262656,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=71.3MiB/s (74.8MB/s), 71.3MiB/s-71.3MiB/s (74.8MB/s-74.8MB/s), io=3070MiB (3219MB), run=43042-43042msec
  WRITE: bw=23.8MiB/s (24.0MB/s), 23.8MiB/s-23.8MiB/s (24.0MB/s-24.0MB/s), io=1026MiB (1076MB), run=43042-43042msec

virtiofs cache=none
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=64
fio-3.21
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=740: Fri Sep 25 12:30:57 2020
  read: IOPS=22.9k, BW=89.6MiB/s (93.0MB/s)(3070MiB/34256msec)
   bw (  KiB/s): min=89048, max=94240, per=100.00%, avg=91871.06, stdev=967.87, samples=68
   iops        : min=22262, max=23560, avg=22967.76, stdev=241.97, samples=68
  write: IOPS=7667, BW=29.0MiB/s (31.4MB/s)(1026MiB/34256msec); 0 zone resets
   bw (  KiB/s): min=29264, max=32248, per=100.00%, avg=30700.82, stdev=541.97, samples=68
   iops        : min= 7316, max= 8062, avg=7675.21, stdev=135.49, samples=68
  cpu          : usr=1.03%, sys=27.64%, ctx=1048635, majf=0, minf=5
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=785920,262656,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=89.6MiB/s (93.0MB/s), 89.6MiB/s-89.6MiB/s (93.0MB/s-93.0MB/s), io=3070MiB (3219MB), run=34256-34256msec
  WRITE: bw=29.0MiB/s (31.4MB/s), 29.0MiB/s-29.0MiB/s (31.4MB/s-31.4MB/s), io=1026MiB (1076MB), run=34256-34256msec

virtiofs cache=none thread-pool-size=1
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=64
fio-3.21
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=738: Fri Sep 25 12:33:17 2020
  read: IOPS=23.7k, BW=92.4MiB/s (96.9MB/s)(3070MiB/33215msec)
   bw (  KiB/s): min=89808, max=111952, per=100.00%, avg=94762.30, stdev=4507.43, samples=66
   iops        : min=22452, max=27988, avg=23690.58, stdev=1126.86, samples=66
  write: IOPS=7907, BW=30.9MiB/s (32.4MB/s)(1026MiB/33215msec); 0 zone resets
   bw (  KiB/s): min=29424, max=37112, per=100.00%, avg=31668.73, stdev=1558.69, samples=66
   iops        : min= 7356, max= 9278, avg=7917.18, stdev=389.67, samples=66
  cpu          : usr=0.43%, sys=29.07%, ctx=1048627, majf=0, minf=7
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=785920,262656,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=92.4MiB/s (96.9MB/s), 92.4MiB/s-92.4MiB/s (96.9MB/s-96.9MB/s), io=3070MiB (3219MB), run=33215-33215msec
  WRITE: bw=30.9MiB/s (32.4MB/s), 30.9MiB/s-30.9MiB/s (32.4MB/s-32.4MB/s), io=1026MiB (1076MB), run=33215-33215msec

9p ( mount -t 9p -o trans=virtio kernel /mnt -oversion=9p2000.L,cache=mmap,msize=1048576 )
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=64
fio-3.21
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=736: Fri Sep 25 12:36:00 2020
  read: IOPS=16.2k, BW=63.5MiB/s (66.6MB/s)(3070MiB/48366msec)
   bw (  KiB/s): min=63426, max=82776, per=100.00%, avg=65054.28, stdev=2014.88, samples=96
   iops        : min=15856, max=20694, avg=16263.34, stdev=503.74, samples=96
  write: IOPS=5430, BW=21.2MiB/s (22.2MB/s)(1026MiB/48366msec); 0 zone resets
   bw (  KiB/s): min=20916, max=27632, per=100.00%, avg=21740.64, stdev=735.73, samples=96
   iops        : min= 5229, max= 6908, avg=5434.99, stdev=183.95, samples=96
  cpu          : usr=1.60%, sys=14.28%, ctx=1049348, majf=0, minf=7
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=785920,262656,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=63.5MiB/s (66.6MB/s), 63.5MiB/s-63.5MiB/s (66.6MB/s-66.6MB/s), io=3070MiB (3219MB), run=48366-48366msec
  WRITE: bw=21.2MiB/s (22.2MB/s), 21.2MiB/s-21.2MiB/s (22.2MB/s-22.2MB/s), io=1026MiB (1076MB), run=48366-48366msec

So I'm sitll beating 9p; the thread-pool-size=1 seems to be great for
read performance here.

Dave

> Can you apply "shared pool" patch to qemu for virtiofsd and re-run this
> test and see if you see any better results.
> 
> In my testing, with cache=none, virtiofs performed better than 9p in 
> all the fio jobs I was running. For the case of cache=auto  for virtiofs
> (with xattr enabled), 9p performed better in certain write workloads. I
> have identified root cause of that problem and working on
> HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> with cache=auto and xattr enabled.
> 
> I will post my 9p and virtiofs comparison numbers next week. In the
> mean time will be great if you could apply following qemu patch, rebuild
> qemu and re-run above test.
> 
> https://www.redhat.com/archives/virtio-fs/2020-September/msg00081.html
> 
> Also what's the status of file cache on host in both the cases. Are
> you booting host fresh for these tests so that cache is cold on host
> or cache is warm?
> 
> Thanks
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

