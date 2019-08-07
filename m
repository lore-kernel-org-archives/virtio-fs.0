Date: Wed, 7 Aug 2019 16:57:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190807205715.GE18557@redhat.com>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807180355.GA22758@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Aug 07, 2019 at 07:03:55PM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2019 at 05:54:05PM +0100, Stefan Hajnoczi wrote:
> > Performance
> > -----------
> > Please try these patches out and share your results.
> 
> Here are the performance numbers:
> 
>   Threadpool | iodepth | iodepth
>      size    |    1    |   64
>   -----------+---------+--------
>   None       |   4451  |  4876
>   1          |   4360  |  4858
>   64         |   4359  | 33,266
> 
> A graph is available here:
> https://vmsplice.net/~stefan/virtiofsd-threadpool-performance.png
> 
> Summary:
> 
>  * iodepth=64 performance is increased by 6.8 times.
>  * iodepth=1 performance degrades by 2%.
>  * DAX is bottlenecked by QEMU's single-threaded
>    VHOST_USER_SLAVE_FS_MAP/UNMAP handler.
> 
> Threadpool size "none" is virtiofsd commit 813a824b707 ("virtiofsd: use
> fuse_lowlevel_is_virtio() in fuse_session_destroy()") without any of the
> multithreading preparation patches.  I benchmarked this to check whether
> the patches introduce a regression for iodepth=1.  They do, but it's
> only around 2%.
> 
> I also ran with DAX but found there was not much difference between
> iodepth=1 and iodepth=64.  This might be because the host mmap(2)
> syscall becomes the bottleneck and a serialization point.  QEMU only
> processes one VHOST_USER_SLAVE_FS_MAP/UNMAP at a time.  If we want to
> accelerate DAX it may be necessary to parallelize mmap, assuming the
> host kernel can do them in parallel on a single file.  This performance
> optimization is future work and not directly related to this patch
> series.

Good to see nice improvement with higher queue depth.

Kernel also serializes MAP/UNMAP on one inode. So you will need to run
multiple jobs operating on different inodes to see parallel MAP/UNMAP
(atleast from kernel's point of view).

Thanks
Vivek

