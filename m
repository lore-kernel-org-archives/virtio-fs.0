Date: Fri, 26 Apr 2019 17:58:39 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190427005838.gqulorwvzscpgumz@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190424184130.GC8962@redhat.com>
	<20190424231258.cbpsgwicldczqck6@US-160370MP2.local>
	<20190425145950.GB17670@redhat.com>
	<20190425181007.ybg4376jowcly7ir@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425181007.ybg4376jowcly7ir@US-160370MP2.local>
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

On Thu, Apr 25, 2019 at 11:10:08AM -0700, Liu Bo wrote:
> On Thu, Apr 25, 2019 at 10:59:50AM -0400, Vivek Goyal wrote:
> > On Wed, Apr 24, 2019 at 04:12:59PM -0700, Liu Bo wrote:
> > > Hi Vivek,
> > > 
> > > On Wed, Apr 24, 2019 at 02:41:30PM -0400, Vivek Goyal wrote:
> > > > Hi Liubo,
> > > > 
> > > > I have made some fixes and took some of yours and pushed latest snapshot
> > > > of my internal tree here.
> > > > 
> > > > https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> > > > 
> > > > Patches have been rebased to 5.1-rc5 kernel. I am thinking of updating
> > > > this branch frequently with latest code.
> > > 
> > > With this branch, generic/476 still got hang, and yes, it's related to
> > > "async page fault related events" just as what you've mentioned on #irc.
> > > 
> > > I confirmed this with kvm and kvmmmu tracepoints.
> > > 
> > > The tracepoints[1] showed that
> > > [1]: https://paste.ubuntu.com/p/N9ngrthKCf/
> > > 
> > > ---
> > > handle_ept_violation
> > >   kvm_mmu_page_fault(error_code=182)
> > >     tdp_page_fault
> > >       fast_page_fault # spte not present
> > >       try_async_pf #queue a async_pf work and return RETRY
> > > 
> > > vcpu_run
> > >  kvm_check_async_pf_completion
> > >    kvm_arch_async_page_ready
> > >      tdp_page_fault(vcpu, work->gva, 0, true);
> > >        fast_page_fault(error_code == 0);
> > >        try_async_pf # found hpa
> > >        __direct_map()
> > > 	  set_spte(error_code == 0) # won't set the write bit
> > > 
> > > handle_ept_violation
> > >   kvm_mmu_page_fault(error_code=1aa)
> > >     tdp_page_fault
> > >       fast_page_fault # spte present but no write bit
> > >       try_async_pf # no hpa again queue a async_pf work and return RETRY
> > 
> > So why there is no "hpa"?
> >
> 
> TBH, I have no idea, __gfn_to_pfn_memslot() did returned a pfn
> successfully after async pf, but during its following EPT_VIOLATION,
> __gfn_to_pfn_memslot() returned KVM_PFN_ERR_FAULT and indicated
> callers to do another async pf, and over and over again.
>

So I think I've figured out it, here is the summary,

virtiofs's dax write implementation sends a fallocate request to extend inode
size and allocate space on the underlying fs so that the underlying mmap can
fault in pages on demands.

There're two problems here,

1) virtiofs write(2) only checks if the write range is within inode size,
   however, this doesn't work all the time because besides write(2) and
   fallocate(2), inode size can also be extended by truncate(2) which doesn't
   allocate space on the underlying fs, so when guest VM writes to this address,
   it then causes a EPT_VIOLATION which will help fault-in the necessary page
   from the underlying %vma, and if it's a write fault, page_mkwrite() will be
   called, if the required space is not yet allocated, page_mkwrite() then tries
   to allocate the space, which may fail with ENOSPC if the underlying fs has
   already been full,

2) async pf doesn't check whether gup is successful.

-------
the call stack analysis:

(vcpu thread)
handle_ept_violation
|->kvm_mmu_page_fault(error_code=182)
   |->tdp_page_fault
      |->try_async_pf  # the 1st page fault (write fault)
         |->__gfn_to_pfn_memslot
           |->get_user_page
              ->faultin_page
                ->handle_mm_fault
                  ->ext4_filemap_fault
                    ->ext4_page_mkwrite # return -ENOSPC, the write fault fails
        
	     |->kvm_arch_setup_async_pf # schedule a async_pf work on kworker
		    ->INIT_WORK(&work->work, async_pf_execute);

(kworker thread)
async_pf_execute
  ->get_user_pages_remote # the 2nd page fault (write fault)


(vcpu thread)
vcpu_run
|->kvm_check_async_pf_completion
   |->kvm_arch_async_page_ready
      |->tdp_page_fault
	     |->try_async_pf # the 3rd page fault (read fault, successful)
	     |->__direct_map
	        |->set_spte # install spte into ept
-------

So Vivek is right about async_pf not checking gup's failure, but in the meantime
we need to deal with 'truncate'.

thanks,
-liubo

> > I was running a different test. I mmaped a file in guest, then truncated
> > file to size 0 on host and then guest tried to read/write the mmaped
> > region.
> > 
> > This will trigger async page fault on host. But given file size is zero,
> > that page fault will not succeed.
> >
> 
> I see, I checked the file I used on host, I could use FIEMAP to read
> all its extent and it wasn't truncated.
> 
> > Current async pf logic has no notion of failure. It assumes it will always
> > succeed. It does not even check the return code of
> > get_user_pages_remote(), which can return error.
> > 
> > So there are few things to be done.
> > 
> > - Modify async pf logic so that it can it capture and report error.
> > - If guest user space mmaped() file in question, then send SIGBUS to
> >   process.
> > - If guest kernel is trying to access memory which async pf can't
> >   resolve, then create an escape path and return error to user
> >   space. (something like memcpy_mcsafe() I think).
> >
> 
> I need to think more about this, in my case, guest is just doing a
> plain write(2) or writev(2), it shouldn't get into hang like that in
> any case.
> 
> Thanks for sharing the code, will take a look.
> 
> thanks,
> -liubo
> > I was playing with this and made some progress. But that work is not
> > complete. I thought of dealing with this problem later. If you are
> > curious, I have pushed my unfinished code here.
> > 
> > Kernel:
> > https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-async-pf
> > 
> > Qemu:
> > https://github.com/rhvgoyal/qemu/commits/virtio-fs-async-pf
> > 
> > Thanks
> > Vivek
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

