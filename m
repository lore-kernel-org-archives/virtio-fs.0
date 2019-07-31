Date: Wed, 31 Jul 2019 10:53:15 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190731175314.mxawter6mj5fyvto@US-160370MP2.local>
References: <1562884542-72462-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190730153041.GA3109@redhat.com>
	<20190730222938.ipnojus4euucg4yj@US-160370MP2.local>
	<20190731123938.GA4405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731123938.GA4405@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] Virtiofs: fix null pointer deference in
 directIO
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

On Wed, Jul 31, 2019 at 08:39:38AM -0400, Vivek Goyal wrote:
> On Tue, Jul 30, 2019 at 03:29:39PM -0700, Liu Bo wrote:
> > On Tue, Jul 30, 2019 at 11:30:41AM -0400, Vivek Goyal wrote:
> > > Hi Liu Bo,
> > > 
> > > I have committed your patch for now here.
> > > 
> > > https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> > > 
> > > I also added a patch to wait for page reference count to drop to 1 before
> > > range is reclaimed. It slows down mmap() workload very significantly
> > > though.
> > >
> > 
> > Yes, the impact on mmap is expected because of the 'unmap' in layout checking,
> > it'd be helpful to check layout on the dmap range instead of the whole inode.
> > 
> > However, there is a race bug in the current code between mmap workloads and dmap
> > reclaim, since the reclaim does not unmap the dmap range at all, such that the
> > dmap range might still stay in some process's page table, if such a dmap is
> > reclaimed, the situation would be worse.  So with unmapping the whole inode in
> > layout checking, at least it is correct in term of that race.
> 
> Can you elaborate more on this. I am not sure I am able to see the race
> you are talking about. Assume we implemented logic to unmap only pages
> which are in dmap (and not whole inode).
>

Sorry for confusing you, what I was trying to say is that the above
problem exists without doing unmapping pages (no matter within the
whole inode or only the dmap range), IOW, before commit "fuse: Free
dax mapping range only if page refcount is 1", the race bug exists.

thanks,
-liubo

> dmap is something internal to virtio-fs. If we unmap all pages which are
> in a dmap, then dmap is free to be reclaimed. We are holding fi->i_mmap_sem,
> and that should make sure that unmapped pages don't get mapped again (page
> fault code will block on fi->i_mmap_sem).
> 
> Thanks
> Vivek

