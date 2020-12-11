Date: Fri, 11 Dec 2020 18:29:56 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201211182956.GF3380@work-vm>
References: <20201210161126.GA125438@redhat.com>
	<CAOssrKcKaosJo1W+sek0AOA3CdyE+ZUWzx8KPsn=Gz3Nor+_iQ@mail.gmail.com>
	<20201211160603.GD3285@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211160603.GD3285@redhat.com>
Subject: Re: [Virtio-fs] Some performance numbers for virtiofs,
	DAX and virtio-9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Thu, Dec 10, 2020 at 08:29:21PM +0100, Miklos Szeredi wrote:
> > On Thu, Dec 10, 2020 at 5:11 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > Conclusion
> > > -----------
> > > - virtiofs DAX seems to help a lot in many workloads.
> > >
> > >   Note, DAX performance well only if data fits in cache window. My total
> > >   data is 16G and cache window size is 16G as well. If data is larger
> > >   than DAX cache window, then performance of dax suffers a lot. Overhead
> > >   of reclaiming old mapping and setting up a new one is very high.
> > 
> > Which begs the question: what is the optimal window size?
> 
> Yep. I will need to run some more tests with data size being constant
> and varying DAX window size.
> 
> For now, I would say optimal window size is same as data size. But
> knowing data size might be hard in advance. So a rough guideline
> could be that it could be same as amount of RAM given to guest.
> 
> > 
> > What is the cost per GB of window to the host and guest?
> 
> Inside guest, I think two primary structures are allocated. There
> will be "struct page" allocated per 4K page. Size of struct page
> seems to be 64. And then there will be "struct fuse_dax_mapping"
> allocated per 2MB. Size of "struct fuse_dax_mapping" is 112.
> 
> This means per 2MB of DAX window, memory needed in guest is.
> 
> memory per 2MB of DAX window = 112 + 64 * 512 = 32880 bytes.
> memory per 1GB of DAX window = 32880 * 512 = 16834560 (16MB approx)
> 
> I think "struct page" allocation is biggest memory allocation
> and that's roughly 1.56% (64/4096) of DAX window size. And that also
> results in 16MB memory allocation per GB of dax window.
> 
> So if a guest has 4G RAM and 4G dax window, then 64MB will be
> consumed in dax window struct pages. I will say no too bad.
> 
> I am looking at qemu code and its not obvious to me what memory
> allocation will be needed 1GB of guest. Looks like it just 
> stores the cache window location and size and when mapping
> request comes, it simply adds offset to cache window start. So
> it might not be allocating memory per page of dax window.
> 
> mmap(cache_host + sm->c_offset[i], sm->len[i]....
> 
> David, you most likely have a better idea about this.

No, I don't think we do any more; it might make sense of us to store a
per-mapping structure though at some point.
I'm assuming the host kernel is going to get some overhead as well.

> > 
> > Could we measure at what point does a large window size actually make
> > performance worse?
> 
> Will do. Will run tests with varying window sizes (small to large)
> and see how does it impact performance for same workload with
> same guest memory.

I wonder how realistic it is though;  it makes some sense if you have a
scenario like a fairly small root filesystem - something tractable;  but
if you have a large FS you're not realistically going to be able to set
the cache size to match it - that's why it's a cache!

Dave

> > 
> > >
> > > NAME                    WORKLOAD                Bandwidth       IOPS
> > > 9p-none                 seqread-psync           98.6mb          24.6k
> > > 9p-mmap                 seqread-psync           97.5mb          24.3k
> > > 9p-loose                seqread-psync           91.6mb          22.9k
> > > vtfs-none               seqread-psync           98.4mb          24.6k
> > > vtfs-none-dax           seqread-psync           660.3mb         165.0k
> > > vtfs-auto               seqread-psync           650.0mb         162.5k
> > > vtfs-auto-dax           seqread-psync           703.1mb         175.7k
> > > vtfs-always             seqread-psync           671.3mb         167.8k
> > > vtfs-always-dax         seqread-psync           687.2mb         171.8k
> > >
> > > 9p-none                 seqread-psync-multi     397.6mb         99.4k
> > > 9p-mmap                 seqread-psync-multi     382.7mb         95.6k
> > > 9p-loose                seqread-psync-multi     350.5mb         87.6k
> > > vtfs-none               seqread-psync-multi     360.0mb         90.0k
> > > vtfs-none-dax           seqread-psync-multi     2281.1mb        570.2k
> > > vtfs-auto               seqread-psync-multi     2530.7mb        632.6k
> > > vtfs-auto-dax           seqread-psync-multi     2423.9mb        605.9k
> > > vtfs-always             seqread-psync-multi     2535.7mb        633.9k
> > > vtfs-always-dax         seqread-psync-multi     2406.1mb        601.5k
> > 
> > Seems like in all the -multi tests 9p-none performs consistently
> > better than vtfs-none.   Could that be due to the single queue?
> 
> Not sure. In the past I had run -multi tests with shared thread pool
> (cache=auto) and single thread seemed to perform better. I can
> try shared pool and run -multi tests again and see if that helps.
> 
> Thanks
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

