Date: Tue, 22 Sep 2020 12:09:46 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200922110946.GB2836@work-vm>
References: <20200918213436.GA3520@redhat.com>
	<20200921201641.GD13362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921201641.GD13362@redhat.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Fri, Sep 18, 2020 at 05:34:36PM -0400, Vivek Goyal wrote:
> > Hi All,
> > 
> > virtiofsd default thread pool size is 64. To me it feels that in most of
> > the cases thread pool size 1 performs better than thread pool size 64.
> > 
> > I ran virtiofs-tests.
> > 
> > https://github.com/rhvgoyal/virtiofs-tests
> 
> I spent more time debugging this. First thing I noticed is that we
> are using "exclusive" glib thread pool.
> 
> https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new
> 
> This seems to run pre-determined number of threads dedicated to that
> thread pool. Little instrumentation of code revealed that every new
> request gets assiged to new thread (despite the fact that previous
> thread finished its job). So internally there might be some kind of
> round robin policy to choose next thread for running the job.
> 
> I decided to switch to "shared" pool instead where it seemed to spin
> up new threads only if there is enough work. Also threads can be shared
> between pools.
> 
> And looks like testing results are way better with "shared" pools. So
> may be we should switch to shared pool by default. (Till somebody shows
> in what cases exclusive pools are better).
> 
> Second thought which came to mind was what's the impact of NUMA. What
> if qemu and virtiofsd process/threads are running on separate NUMA
> node. That should increase memory access latency and increased overhead.
> So I used "numactl --cpubind=0" to bind both qemu and virtiofsd to node
> 0. My machine seems to have two numa nodes. (Each node is having 32
> logical processors). Keeping both qemu and virtiofsd on same node
> improves throughput further.
> 
> So here are the results.
> 
> vtfs-none-epool --> cache=none, exclusive thread pool.
> vtfs-none-spool --> cache=none, shared thread pool.
> vtfs-none-spool-numa --> cache=none, shared thread pool, same numa node

Do you have the numbers for:
   epool
   epool thread-pool-size=1
   spool

?

Dave

> 
> NAME                    WORKLOAD                Bandwidth       IOPS            
> vtfs-none-epool         seqread-psync           36(MiB/s)       9392            
> vtfs-none-spool         seqread-psync           68(MiB/s)       17k             
> vtfs-none-spool-numa    seqread-psync           73(MiB/s)       18k             
> 
> vtfs-none-epool         seqread-psync-multi     210(MiB/s)      52k             
> vtfs-none-spool         seqread-psync-multi     260(MiB/s)      65k             
> vtfs-none-spool-numa    seqread-psync-multi     309(MiB/s)      77k             
> 
> vtfs-none-epool         seqread-libaio          286(MiB/s)      71k             
> vtfs-none-spool         seqread-libaio          328(MiB/s)      82k             
> vtfs-none-spool-numa    seqread-libaio          332(MiB/s)      83k             
> 
> vtfs-none-epool         seqread-libaio-multi    201(MiB/s)      50k             
> vtfs-none-spool         seqread-libaio-multi    254(MiB/s)      63k             
> vtfs-none-spool-numa    seqread-libaio-multi    276(MiB/s)      69k             
> 
> vtfs-none-epool         randread-psync          40(MiB/s)       10k             
> vtfs-none-spool         randread-psync          64(MiB/s)       16k             
> vtfs-none-spool-numa    randread-psync          72(MiB/s)       18k             
> 
> vtfs-none-epool         randread-psync-multi    211(MiB/s)      52k             
> vtfs-none-spool         randread-psync-multi    252(MiB/s)      63k             
> vtfs-none-spool-numa    randread-psync-multi    297(MiB/s)      74k             
> 
> vtfs-none-epool         randread-libaio         313(MiB/s)      78k             
> vtfs-none-spool         randread-libaio         320(MiB/s)      80k             
> vtfs-none-spool-numa    randread-libaio         330(MiB/s)      82k             
> 
> vtfs-none-epool         randread-libaio-multi   257(MiB/s)      64k             
> vtfs-none-spool         randread-libaio-multi   274(MiB/s)      68k             
> vtfs-none-spool-numa    randread-libaio-multi   319(MiB/s)      79k             
> 
> vtfs-none-epool         seqwrite-psync          34(MiB/s)       8926            
> vtfs-none-spool         seqwrite-psync          55(MiB/s)       13k             
> vtfs-none-spool-numa    seqwrite-psync          66(MiB/s)       16k             
> 
> vtfs-none-epool         seqwrite-psync-multi    196(MiB/s)      49k             
> vtfs-none-spool         seqwrite-psync-multi    225(MiB/s)      56k             
> vtfs-none-spool-numa    seqwrite-psync-multi    270(MiB/s)      67k             
> 
> vtfs-none-epool         seqwrite-libaio         257(MiB/s)      64k             
> vtfs-none-spool         seqwrite-libaio         304(MiB/s)      76k             
> vtfs-none-spool-numa    seqwrite-libaio         267(MiB/s)      66k             
> 
> vtfs-none-epool         seqwrite-libaio-multi   312(MiB/s)      78k             
> vtfs-none-spool         seqwrite-libaio-multi   366(MiB/s)      91k             
> vtfs-none-spool-numa    seqwrite-libaio-multi   381(MiB/s)      95k             
> 
> vtfs-none-epool         randwrite-psync         38(MiB/s)       9745            
> vtfs-none-spool         randwrite-psync         55(MiB/s)       13k             
> vtfs-none-spool-numa    randwrite-psync         67(MiB/s)       16k             
> 
> vtfs-none-epool         randwrite-psync-multi   186(MiB/s)      46k             
> vtfs-none-spool         randwrite-psync-multi   240(MiB/s)      60k             
> vtfs-none-spool-numa    randwrite-psync-multi   271(MiB/s)      67k             
> 
> vtfs-none-epool         randwrite-libaio        224(MiB/s)      56k             
> vtfs-none-spool         randwrite-libaio        296(MiB/s)      74k             
> vtfs-none-spool-numa    randwrite-libaio        290(MiB/s)      72k             
> 
> vtfs-none-epool         randwrite-libaio-multi  300(MiB/s)      75k             
> vtfs-none-spool         randwrite-libaio-multi  350(MiB/s)      87k             
> vtfs-none-spool-numa    randwrite-libaio-multi  383(MiB/s)      95k             
> 
> Thanks
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

