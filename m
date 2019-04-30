Date: Mon, 29 Apr 2019 18:38:14 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190430013814.lpbupj5yfta4wmfd@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190424184130.GC8962@redhat.com>
	<20190424231258.cbpsgwicldczqck6@US-160370MP2.local>
	<20190425145950.GB17670@redhat.com>
	<20190425181007.ybg4376jowcly7ir@US-160370MP2.local>
	<20190427005838.gqulorwvzscpgumz@US-160370MP2.local>
	<20190429131822.GA31835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429131822.GA31835@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/9] virtio-fs fixes
Reply-To: bo.liu@linux.alibaba.com
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

On Mon, Apr 29, 2019 at 09:18:22AM -0400, Vivek Goyal wrote:
> On Fri, Apr 26, 2019 at 05:58:39PM -0700, Liu Bo wrote:
> > On Thu, Apr 25, 2019 at 11:10:08AM -0700, Liu Bo wrote:
> > > On Thu, Apr 25, 2019 at 10:59:50AM -0400, Vivek Goyal wrote:
> > > > On Wed, Apr 24, 2019 at 04:12:59PM -0700, Liu Bo wrote:
> > > > > Hi Vivek,
> > > > > 
> > > > > On Wed, Apr 24, 2019 at 02:41:30PM -0400, Vivek Goyal wrote:
> > > > > > Hi Liubo,
> > > > > > 
> > > > > > I have made some fixes and took some of yours and pushed latest snapshot
> > > > > > of my internal tree here.
> > > > > > 
> > > > > > https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> > > > > > 
> > > > > > Patches have been rebased to 5.1-rc5 kernel. I am thinking of updating
> > > > > > this branch frequently with latest code.
> > > > > 
> > > > > With this branch, generic/476 still got hang, and yes, it's related to
> > > > > "async page fault related events" just as what you've mentioned on #irc.
> > > > > 
> > > > > I confirmed this with kvm and kvmmmu tracepoints.
> > > > > 
> > > > > The tracepoints[1] showed that
> > > > > [1]: https://paste.ubuntu.com/p/N9ngrthKCf/
> > > > > 
> > > > > ---
> > > > > handle_ept_violation
> > > > >   kvm_mmu_page_fault(error_code=182)
> > > > >     tdp_page_fault
> > > > >       fast_page_fault # spte not present
> > > > >       try_async_pf #queue a async_pf work and return RETRY
> > > > > 
> > > > > vcpu_run
> > > > >  kvm_check_async_pf_completion
> > > > >    kvm_arch_async_page_ready
> > > > >      tdp_page_fault(vcpu, work->gva, 0, true);
> > > > >        fast_page_fault(error_code == 0);
> > > > >        try_async_pf # found hpa
> > > > >        __direct_map()
> > > > > 	  set_spte(error_code == 0) # won't set the write bit
> > > > > 
> > > > > handle_ept_violation
> > > > >   kvm_mmu_page_fault(error_code=1aa)
> > > > >     tdp_page_fault
> > > > >       fast_page_fault # spte present but no write bit
> > > > >       try_async_pf # no hpa again queue a async_pf work and return RETRY
> > > > 
> > > > So why there is no "hpa"?
> > > >
> > > 
> > > TBH, I have no idea, __gfn_to_pfn_memslot() did returned a pfn
> > > successfully after async pf, but during its following EPT_VIOLATION,
> > > __gfn_to_pfn_memslot() returned KVM_PFN_ERR_FAULT and indicated
> > > callers to do another async pf, and over and over again.
> > >
> > 
> > So I think I've figured out it, here is the summary,
> > 
> > virtiofs's dax write implementation sends a fallocate request to extend inode
> > size and allocate space on the underlying fs so that the underlying mmap can
> > fault in pages on demands.
> > 
> > There're two problems here,
> 
> > 
> > 1) virtiofs write(2) only checks if the write range is within inode size,
> >    however, this doesn't work all the time because besides write(2) and
> >    fallocate(2), inode size can also be extended by truncate(2) which doesn't
> >    allocate space on the underlying fs, so when guest VM writes to this address,
> >    it then causes a EPT_VIOLATION which will help fault-in the necessary page
> >    from the underlying %vma, and if it's a write fault, page_mkwrite() will be
> >    called, if the required space is not yet allocated, page_mkwrite() then tries
> >    to allocate the space, which may fail with ENOSPC if the underlying fs has
> >    already been full,
> > 
> > 2) async pf doesn't check whether gup is successful.
> 
> Ok. So filesystem on host is full but truncate still succeeds (as it did
> not reuiqre fs block allocations). But later when a write from guest
> process happens, it results in async pf on host and that fails because
> fs block can't be allocated.
> 
> But this still sounds like an issue with async pf where an error needs
> to be captured and somehow communicated back to guest OS. In this
> case -ENOSPC.

I have a question about how guest responds to this kind of error, so guest vm is
doing dax_copy_from_iter (in case of write), and eventually it's memory copying
a iovector, right?

I'm not sure how guest can exit gracefully from there?  Can copy_in() return a
EFAULT somehow?

My workaround is to ensure there is enough fs space allocated to dax mapping
range when doing SETUPMAPPING, in other words, we can do a plain fallocate upon
the range before sending messages to the vhost-user backend.

thanks,
-liubo

