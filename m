Date: Thu, 15 Aug 2019 08:45:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190815124524.GB4878@redhat.com>
References: <1565634725-89726-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190814195338.GC7475@redhat.com>
	<20190814205113.oy7ioyejl5ddktn7@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814205113.oy7ioyejl5ddktn7@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtio-fs: try hard to do inline reclaim
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 14, 2019 at 01:51:14PM -0700, Liu Bo wrote:

[..]
> > Also, as of now inline reclaims are enabled only for writes. (no reads, no
> > mmap). So this should not help with the randread improvements you posted
> > in second patch.
> >
> 
> I explained it in another email under the thread.

Going forward, can you please generate patches and test results on top of
latest virtio-fs code I am putting on github/gitlab. If you test it on
your internal kernels where you are carrying your own patches, these
results don't help.

> 
> > Does this work without deadlocks with cache_size=2M.
> 
> Well, with or without these 2 changes, on cache_size=2M kernel build end up with
> waiting for dmap "forever", at least lockdep didn't report deadlocks.

Have you tried the latest kernel and does that hang too? Or it is the
hang with your kernel?

https://github.com/rhvgoyal/linux/commits/vivek-5.3-aug-14-2019

With above kernel I tested with dmap=1 and it works for me. I ran
"blogbench -d /mnt/virtio-fs/test-dir/" and that works.

In last few weeks I have worked on sorting out various issues with
hangs/deadlocks with dmap=1. 

Thanks
Vivek

