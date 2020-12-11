Date: Fri, 11 Dec 2020 20:06:23 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201211200623.GH3380@work-vm>
References: <20201210161126.GA125438@redhat.com>
	<CAOssrKcKaosJo1W+sek0AOA3CdyE+ZUWzx8KPsn=Gz3Nor+_iQ@mail.gmail.com>
	<20201211160603.GD3285@redhat.com> <20201211182956.GF3380@work-vm>
	<20201211192517.GF3285@redhat.com>
	<20201211200108.GG3285@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211200108.GG3285@redhat.com>
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
> On Fri, Dec 11, 2020 at 02:25:17PM -0500, Vivek Goyal wrote:
> > On Fri, Dec 11, 2020 at 06:29:56PM +0000, Dr. David Alan Gilbert wrote:
> > 
> > [..]
> > > > > 
> > > > > Could we measure at what point does a large window size actually make
> > > > > performance worse?
> > > > 
> > > > Will do. Will run tests with varying window sizes (small to large)
> > > > and see how does it impact performance for same workload with
> > > > same guest memory.
> > > 
> > > I wonder how realistic it is though;  it makes some sense if you have a
> > > scenario like a fairly small root filesystem - something tractable;  but
> > > if you have a large FS you're not realistically going to be able to set
> > > the cache size to match it - that's why it's a cache!
> > 
> > I think its more about active dataset size and not necessarily total
> > FS size. FS might be big but if application is not accessing all of
> > the in reasonabl small time window, then it does not matter.
> > 
> > What worries me most is that cost of reclaim of a dax range seems
> > too high (or keeps the process blocked for long enogh), that it
> > kills the performance. I will need to revisit the reclaim path
> > and see if I can optimize something.
> 
> I see that while reclaiming a range, we are sending a remvemapping
> command to virtiofsd. We are holding locks so that no new mappings
> can be added to that inode.

Are you doing this when mapping something new in as well?
If you're replacing an existing mapping then there's no downside to just
skipping the remove.

> We had decided that removemapping is not necessary. It helps in
> the sense that if guest is not using a mapping, qemu will unmap
> it too.
> 
> If we stop sending remove mapping, then it might improve reclaim
> performance significantly. With the downside that host will
> have something mapped (despite the fact that guest is not using
> it anymore). And these will be cleaned up only when guest shuts
> down.

There's probably some scope for improving this on the QEMU side as well;
although there's always going to be latency of going through the path
to do the request.

Dave

> 
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

