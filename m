Date: Wed, 24 Apr 2019 16:12:59 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190424231258.cbpsgwicldczqck6@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190424184130.GC8962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424184130.GC8962@redhat.com>
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

Hi Vivek,

On Wed, Apr 24, 2019 at 02:41:30PM -0400, Vivek Goyal wrote:
> Hi Liubo,
> 
> I have made some fixes and took some of yours and pushed latest snapshot
> of my internal tree here.
> 
> https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> 
> Patches have been rebased to 5.1-rc5 kernel. I am thinking of updating
> this branch frequently with latest code.

With this branch, generic/476 still got hang, and yes, it's related to
"async page fault related events" just as what you've mentioned on #irc.

I confirmed this with kvm and kvmmmu tracepoints.

The tracepoints[1] showed that
[1]: https://paste.ubuntu.com/p/N9ngrthKCf/

---
handle_ept_violation
  kvm_mmu_page_fault(error_code=182)
    tdp_page_fault
      fast_page_fault # spte not present
      try_async_pf #queue a async_pf work and return RETRY

vcpu_run
 kvm_check_async_pf_completion
   kvm_arch_async_page_ready
     tdp_page_fault(vcpu, work->gva, 0, true);
       fast_page_fault(error_code == 0);
       try_async_pf # found hpa
       __direct_map()
	  set_spte(error_code == 0) # won't set the write bit

handle_ept_violation
  kvm_mmu_page_fault(error_code=1aa)
    tdp_page_fault
      fast_page_fault # spte present but no write bit
      try_async_pf # no hpa again queue a async_pf work and return RETRY
---


The host kernel in use is 4.9 latest stable, but I've also tried the
5.0 kernel but no luck, I've spent quite a while on this and I was
wondering if this was a kvm issue?  How did you solve it?

Please suggest.

thanks,
-liubo

> 
> Vivek
> 
> On Wed, Apr 17, 2019 at 02:03:13AM +0800, Liu Bo wrote:
> 
> > Hi,
> > 
> > This set contains a few fixes collected by running xfstests.
> > 
> > thanks,
> > liubo
> > 
> > Liu Bo (6):
> >   virtio-fs: fix multiple tag support
> >   virtio-fs: clean up dax mapping before aborting connection
> >   fuse: export fuse_drop_waiting()
> >   virtio-fs: let dax style override directIO style when dax+cache=none
> >   fuse: return early if punch_hole fails
> >   virtio-fs: honor RLIMIT_FSIZE in fuse_file_fallocate
> > 
> > Xiaoguang Wang (3):
> >   virtio-fs: fix use-after-free against virtio_fs_vq's fuse_dev info
> >   fuse: do not write whole page while page straddles i_size
> >   fuse: fix deadlock in __fuse_file_fallocate()
> > 
> >  fs/fuse/dev.c       |  3 ++-
> >  fs/fuse/file.c      | 31 +++++++++++++++++++++++--------
> >  fs/fuse/fuse_i.h    |  3 +++
> >  fs/fuse/inode.c     |  9 +++++++++
> >  fs/fuse/virtio_fs.c | 13 +++++++++++--
> >  5 files changed, 48 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

