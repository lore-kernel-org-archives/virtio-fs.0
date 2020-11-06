From: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Date: Fri, 6 Nov 2020 20:33:50 +0000
Message-ID: <D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
In-Reply-To: <20201105195253.GB1384085@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAAF2BC282F5464EB90CB54D6A06759B@intel.com>
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
To: Vivek Goyal <vgoyal@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>
Cc: "Shinde, Archana M" <archana.m.shinde@intel.com>

Hi Vivek,

I have tested with Kata 1.12-apha0, the results seems that are better for the use fio config I am tracking. 

The fio config does  randrw:

fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75

- I can see better results with this patch
- 9pfs is still better in the case of Kata because of the use of:
https://github.com/kata-containers/packaging/blob/stable-1.12/qemu/patches/5.0.x/0001-9p-removing-coroutines-of-9p-to-increase-the-I-O-per.patch

Results:
./fio-results-run_virtiofs_tread_pool_0
   READ: bw=42.8MiB/s (44.8MB/s), 42.8MiB/s-42.8MiB/s (44.8MB/s-44.8MB/s), io=150MiB (157MB), run=3507-3507msec
  WRITE: bw=14.3MiB/s (14.9MB/s), 14.3MiB/s-14.3MiB/s (14.9MB/s-14.9MB/s), io=49.0MiB (52.4MB), run=3507-3507msec
./fio-results-run_9pfs
   READ: bw=55.1MiB/s (57.8MB/s), 55.1MiB/s-55.1MiB/s (57.8MB/s-57.8MB/s), io=150MiB (157MB), run=2722-2722msec
  WRITE: bw=18.4MiB/s (19.3MB/s), 18.4MiB/s-18.4MiB/s (19.3MB/s-19.3MB/s), io=49.0MiB (52.4MB), run=2722-2722msec
./fio-results-run_virtiofs_tread_pool_1
   READ: bw=34.5MiB/s (36.1MB/s), 34.5MiB/s-34.5MiB/s (36.1MB/s-36.1MB/s), io=150MiB (157MB), run=4354-4354msec
  WRITE: bw=11.5MiB/s (12.0MB/s), 11.5MiB/s-11.5MiB/s (12.0MB/s-12.0MB/s), io=49.0MiB (52.4MB), run=4354-4354msec
./fio-results-run_virtiofs_tread_pool_64
   READ: bw=32.3MiB/s (33.8MB/s), 32.3MiB/s-32.3MiB/s (33.8MB/s-33.8MB/s), io=150MiB (157MB), run=4648-4648msec
  WRITE: bw=10.8MiB/s (11.3MB/s), 10.8MiB/s-10.8MiB/s (11.3MB/s-11.3MB/s), io=49.0MiB (52.4MB), run=4648-4648msec

Next: 
- run https://github.com/rhvgoyal/virtiofs-tests for  tread_pool_0, tread_pool_64, and 9pfs
- Test https://lore.kernel.org/linux-fsdevel/20201009181512.65496-1-vgoyal@redhat.com/

All the testing  for kata is based in:
https://github.com/jcvenegas/mrunner/blob/master/scripts/bash_workloads/build-qemu-and-run-fio-test.sh

I ran this using an azure VM.

Cheers,
Carlos


﻿On 05/11/20 13:53, "Vivek Goyal" <vgoyal@redhat.com> wrote:

    On Thu, Nov 05, 2020 at 02:44:16PM -0500, Vivek Goyal wrote:
    > Right now we create a thread pool and main thread hands over the request
    > to thread in thread pool to process. Number of threads in thread pool
    > can be managed by option --thread-pool-size.
    > 
    > There is a chance that in case of some workloads, we might get better
    > performance if we don't handover the request to a different thread
    > and process in the context of thread receiving the request.
    > 
    > To implement that, redefine the meaning of --thread-pool-size=0 to
    > mean that don't use a thread pool. Instead process the request in
    > the context of thread receiving request from the queue.
    > 
    > I can't think how --thread-pool-size=0 is useful and hence using
    > that. If it is already useful somehow, I could look at defining
    > a new option say "--no-thread-pool".
    > 
    > I think this patch will be used more as a debug help to do comparison
    > when it is more effecient to do not hand over the requests to a
    > thread pool.

    I ran virtiofs-tests to comapre --thread-pool-size=0 and
    --thread-pool-size=64. And results seem to be all over the place. In
    some cases thread pool seems to perform batter and in other cases
    no-thread-pool seems to perform better.

    But in general it looks like that except for the case of libaio workload,
    no-thread-pool is helping.

    Thanks
    Vivek

    NAME                    WORKLOAD                Bandwidth       IOPS            
    thread-pool             seqread-psync           682.4mb         170.6k          
    no-thread-pool          seqread-psync           679.3mb         169.8k          

    thread-pool             seqread-psync-multi     2415.9mb        603.9k          
    no-thread-pool          seqread-psync-multi     2528.5mb        632.1k          

    thread-pool             seqread-mmap            591.7mb         147.9k          
    no-thread-pool          seqread-mmap            595.6mb         148.9k          

    thread-pool             seqread-mmap-multi      2195.3mb        548.8k          
    no-thread-pool          seqread-mmap-multi      2286.1mb        571.5k          

    thread-pool             seqread-libaio          329.1mb         82.2k           
    no-thread-pool          seqread-libaio          271.5mb         67.8k           

    thread-pool             seqread-libaio-multi    1387.1mb        346.7k          
    no-thread-pool          seqread-libaio-multi    1508.2mb        377.0k          

    thread-pool             randread-psync          59.0mb          14.7k           
    no-thread-pool          randread-psync          78.5mb          19.6k           

    thread-pool             randread-psync-multi    226.4mb         56.6k           
    no-thread-pool          randread-psync-multi    289.2mb         72.3k           

    thread-pool             randread-mmap           48.4mb          12.1k           
    no-thread-pool          randread-mmap           57.4mb          14.3k           

    thread-pool             randread-mmap-multi     183.5mb         45.8k           
    no-thread-pool          randread-mmap-multi     240.5mb         60.1k           

    thread-pool             randread-libaio         329.4mb         82.3k           
    no-thread-pool          randread-libaio         261.8mb         65.4k           

    thread-pool             randread-libaio-multi   252.1mb         63.0k           
    no-thread-pool          randread-libaio-multi   278.3mb         69.5k           

    thread-pool             seqwrite-psync          54.9mb          13.7k           
    no-thread-pool          seqwrite-psync          77.8mb          19.4k           

    thread-pool             seqwrite-psync-multi    219.9mb         54.9k           
    no-thread-pool          seqwrite-psync-multi    314.8mb         78.7k           

    thread-pool             seqwrite-mmap           191.7mb         47.9k           
    no-thread-pool          seqwrite-mmap           201.4mb         50.3k           

    thread-pool             seqwrite-mmap-multi     346.6mb         86.6k           
    no-thread-pool          seqwrite-mmap-multi     387.6mb         96.9k           

    thread-pool             seqwrite-libaio         306.4mb         76.6k           
    no-thread-pool          seqwrite-libaio         248.2mb         62.0k           

    thread-pool             seqwrite-libaio-multi   328.5mb         82.1k           
    no-thread-pool          seqwrite-libaio-multi   305.6mb         76.4k           

    thread-pool             randwrite-psync         55.6mb          13.9k           
    no-thread-pool          randwrite-psync         81.2mb          20.3k           

    thread-pool             randwrite-psync-multi   227.0mb         56.7k           
    no-thread-pool          randwrite-psync-multi   311.6mb         77.8k           

    thread-pool             randwrite-mmap          35.3mb          9038            
    no-thread-pool          randwrite-mmap          58.1mb          14.5k           

    thread-pool             randwrite-mmap-multi    140.8mb         35.2k           
    no-thread-pool          randwrite-mmap-multi    210.5mb         52.6k           

    thread-pool             randwrite-libaio        307.1mb         76.7k           
    no-thread-pool          randwrite-libaio        279.4mb         69.8k           

    thread-pool             randwrite-libaio-multi  361.3mb         90.3k           
    no-thread-pool          randwrite-libaio-multi  302.6mb         75.6k           

    thread-pool             randrw-psync            34.1mb/11.4mb   8754/2929       
    no-thread-pool          randrw-psync            38.7mb/12.9mb   9919/3321       

    thread-pool             randrw-psync-multi      126.2mb/42.3mb  31.5k/10.5k     
    no-thread-pool          randrw-psync-multi      172.2mb/57.7mb  43.0k/14.4k     

    thread-pool             randrw-mmap             24.1mb/8270kb   6194/2067       
    no-thread-pool          randrw-mmap             42.0mb/14.0mb   10.5k/3606      

    thread-pool             randrw-mmap-multi       127.9mb/42.8mb  31.9k/10.7k     
    no-thread-pool          randrw-mmap-multi       179.4mb/60.0mb  44.8k/15.0k     

    thread-pool             randrw-libaio           64.0mb/21.4mb   16.0k/5485      
    no-thread-pool          randrw-libaio           79.6mb/26.6mb   19.9k/6831      

    thread-pool             randrw-libaio-multi     174.2mb/58.3mb  43.5k/14.5k     
    no-thread-pool          randrw-libaio-multi     201.6mb/67.5mb  50.4k/16.8k     



