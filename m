Date: Fri, 18 Sep 2020 17:34:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200918213436.GA3520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

Hi All,

virtiofsd default thread pool size is 64. To me it feels that in most of
the cases thread pool size 1 performs better than thread pool size 64.

I ran virtiofs-tests.

https://github.com/rhvgoyal/virtiofs-tests

And here are the comparision results. To me it seems that by default
we should switch to 1 thread (Till we can figure out how to make
multi thread performance better even when single process is doing
I/O in client).

I am especially more interested in getting performance better for
single process in client. If that suffers, then it is pretty bad.

Especially look at randread, randwrite, seqwrite performance. seqread
seems pretty good anyway.

If I don't run who test suite and just ran randread-psync job,
my throughput jumps from around 40MB/s to 60MB/s. That's a huge
jump I would say.

Thoughts?

Thanks
Vivek


NAME                    WORKLOAD                Bandwidth       IOPS            
cache-auto              seqread-psync           690(MiB/s)      172k            
cache-auto-1-thread     seqread-psync           729(MiB/s)      182k            

cache-auto              seqread-psync-multi     2578(MiB/s)     644k            
cache-auto-1-thread     seqread-psync-multi     2597(MiB/s)     649k            

cache-auto              seqread-mmap            660(MiB/s)      165k            
cache-auto-1-thread     seqread-mmap            672(MiB/s)      168k            

cache-auto              seqread-mmap-multi      2499(MiB/s)     624k            
cache-auto-1-thread     seqread-mmap-multi      2618(MiB/s)     654k            

cache-auto              seqread-libaio          286(MiB/s)      71k             
cache-auto-1-thread     seqread-libaio          260(MiB/s)      65k             

cache-auto              seqread-libaio-multi    1508(MiB/s)     377k            
cache-auto-1-thread     seqread-libaio-multi    986(MiB/s)      246k            

cache-auto              randread-psync          35(MiB/s)       9191            
cache-auto-1-thread     randread-psync          55(MiB/s)       13k             

cache-auto              randread-psync-multi    179(MiB/s)      44k             
cache-auto-1-thread     randread-psync-multi    209(MiB/s)      52k             

cache-auto              randread-mmap           32(MiB/s)       8273            
cache-auto-1-thread     randread-mmap           50(MiB/s)       12k             

cache-auto              randread-mmap-multi     161(MiB/s)      40k             
cache-auto-1-thread     randread-mmap-multi     185(MiB/s)      46k             

cache-auto              randread-libaio         268(MiB/s)      67k             
cache-auto-1-thread     randread-libaio         254(MiB/s)      63k             

cache-auto              randread-libaio-multi   256(MiB/s)      64k             
cache-auto-1-thread     randread-libaio-multi   155(MiB/s)      38k             

cache-auto              seqwrite-psync          23(MiB/s)       6026            
cache-auto-1-thread     seqwrite-psync          30(MiB/s)       7925            

cache-auto              seqwrite-psync-multi    100(MiB/s)      25k             
cache-auto-1-thread     seqwrite-psync-multi    154(MiB/s)      38k             

cache-auto              seqwrite-mmap           343(MiB/s)      85k             
cache-auto-1-thread     seqwrite-mmap           355(MiB/s)      88k             

cache-auto              seqwrite-mmap-multi     408(MiB/s)      102k            
cache-auto-1-thread     seqwrite-mmap-multi     438(MiB/s)      109k            

cache-auto              seqwrite-libaio         41(MiB/s)       10k             
cache-auto-1-thread     seqwrite-libaio         65(MiB/s)       16k             

cache-auto              seqwrite-libaio-multi   137(MiB/s)      34k             
cache-auto-1-thread     seqwrite-libaio-multi   214(MiB/s)      53k             

cache-auto              randwrite-psync         22(MiB/s)       5801            
cache-auto-1-thread     randwrite-psync         30(MiB/s)       7927            

cache-auto              randwrite-psync-multi   100(MiB/s)      25k             
cache-auto-1-thread     randwrite-psync-multi   151(MiB/s)      37k             

cache-auto              randwrite-mmap          31(MiB/s)       7984            
cache-auto-1-thread     randwrite-mmap          55(MiB/s)       13k             

cache-auto              randwrite-mmap-multi    124(MiB/s)      31k             
cache-auto-1-thread     randwrite-mmap-multi    213(MiB/s)      53k             

cache-auto              randwrite-libaio        40(MiB/s)       10k             
cache-auto-1-thread     randwrite-libaio        64(MiB/s)       16k             

cache-auto              randwrite-libaio-multi  139(MiB/s)      34k             
cache-auto-1-thread     randwrite-libaio-multi  212(MiB/s)      53k             






