Date: Thu, 11 Jul 2019 09:49:58 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190711084958.GC3971@work-vm>
References: <1562225131-23463-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190708204301.GB15498@redhat.com>
	<20190710184128.k6qg7d2p3za5a7e7@US-160370MP2.local>
	<20190710203714.GA25146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710203714.GA25146@redhat.com>
Subject: Re: [Virtio-fs] [PATCH RFC] virtiofs: use fine-grained lock for
 dmap reclaim
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Wed, Jul 10, 2019 at 11:41:29AM -0700, Liu Bo wrote:
> > On Mon, Jul 08, 2019 at 04:43:01PM -0400, Vivek Goyal wrote:
> > > On Thu, Jul 04, 2019 at 03:25:31PM +0800, Liu Bo wrote:
> > > > With free fuse dax mapping reducing, read performance is impacted
> > > > significantly because reads need to wait for a free fuse dax mapping.
> > > > 
> > > > Although reads will trigger reclaim work to try to reclaim fuse dax
> > > > mapping, reclaim code can barely make any progress if most of fuse dax
> > > > mappings are used by the file we're reading since inode lock is required
> > > > by reclaim code.
> > > > 
> > > > However, we don't have to take inode lock for reclaiming if dax mapping
> > > > has its own reference count, reference counting is to tell reclaim code to
> > > > skip those in use dax mappings, such that we can avoid the risk of
> > > > accidentally reclaiming a dax mapping that other readers are using.
> > > > 
> > > > On the other hand, holding ->i_dmap_sem during reclaim can be used to
> > > > prevent the follwing reads to get a dax mapping under reclaim.
> > > > 
> > > > Another reason is that reads/writes only use fuse dax mapping within
> > > > dax_iomap_rw(), so we can do such a trick, while mmap/faulting is a
> > > > different story and we have to take ->i_mmap_sem prior to reclaiming a dax
> > > > mapping in order to avoid the race.
> > > 
> > > Hi Liu Bo,
> > > 
> > > Not sure why we can get rid of inode lock but not ->i_mmap_sem. Holding
> > > this lock only prevents further page fault. But existing mapped pages
> > > will continue to be accessed by process.
> > >
> > 
> > The idea is that for reads/writes, it always goes thru fuse_iomap_{begin,end}
> > during the whole IO process, while for mmap, once fault-in finishes, it can
> > read/write to the area without fuse_iomap_{begin,end}.
> > 
> > > And in theory we could drop inode lock and be safe only with ->dmap_sem
> > > lock, can't we do something similar for ->i_mmap_sem lock.
> > > 
> > > Also little worried about races w.r.t truncation and i_size update. Dax
> > > code assumes that i_size is stable  and filesystem is holding enough
> > > locks to ensure that.
> > >
> > 
> > typically i_mmap_sem is held by truncate to avoid the race with dax code.
> > 
> > but the race between truncate and isize changes seems to be unrelated to this
> > patch, as the patch only does updates how the background reclaim worker
> > manipulates locks.
> > 
> > I went thru fuse_setattr(), we don't remove dax mapping ranges in truncate, either.
> > 
> > > What kind of testing you have done to make sure this is safe. Try
> > > running blogbench. Possibly mix of read/write/mmap workload along
> > > with heavy truncation/punch hole operation in parallel as well.
> > >
> > 
> > Not yet, but surely I'm planning to run a whole round of regression test against
> > it.
> 
> I ran bunch of fio jobs and compared the results with vanilla kernel and
> with your patch. Looks like randwrite jobs are showing some regression. 

But...

> Here are my scripts.
> 
> https://github.com/rhvgoyal/virtiofs-tests
> 
> I rand tests with cache=always, cache size=2G, dax enabled.
> 
> 
> NAME                    I/O Operation           BW(Read/Write)
> virtiofs-vanilla        seqread                 164(MiB/s)
> virtiofs-liubo-patch    seqread                 163(MiB/s)
> 
> virtiofs-vanilla        seqread-mmap-single     200(MiB/s)
> virtiofs-liubo-patch    seqread-mmap-single     220(MiB/s)
> 
> virtiofs-vanilla        seqread-mmap-multi      736(MiB/s)
> virtiofs-liubo-patch    seqread-mmap-multi      771(MiB/s)
> 
> virtiofs-vanilla        randread                1406(KiB/s)
> virtiofs-liubo-patch    randread                15(MiB/s)

That's a hell of an improvement for randread; perhaps the write
regression is worth it?

Dave

> virtiofs-vanilla        randread-mmap-single    13(MiB/s)
> virtiofs-liubo-patch    randread-mmap-single    11(MiB/s)
> 
> virtiofs-vanilla        randread-mmap-multi     8934(KiB/s)
> virtiofs-liubo-patch    randread-mmap-multi     9264(KiB/s)
> 
> virtiofs-vanilla        seqwrite                120(MiB/s)
> virtiofs-liubo-patch    seqwrite                110(MiB/s)
> 
> virtiofs-vanilla        seqwrite-mmap-single    242(MiB/s)
> virtiofs-liubo-patch    seqwrite-mmap-single    250(MiB/s)
> 
> virtiofs-vanilla        seqwrite-mmap-multi     595(MiB/s)
> virtiofs-liubo-patch    seqwrite-mmap-multi     646(MiB/s)
> 
> virtiofs-vanilla        randwrite               20(MiB/s)
> virtiofs-liubo-patch    randwrite               15(MiB/s)
> 
> virtiofs-vanilla        randwrite-mmap-single   12(MiB/s)
> virtiofs-liubo-patch    randwrite-mmap-single   10(MiB/s)
> 
> virtiofs-vanilla        randwrite-mmap-multi    11(MiB/s)
> virtiofs-liubo-patch    randwrite-mmap-multi    8246(KiB/s)
> 
> Vivek
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

