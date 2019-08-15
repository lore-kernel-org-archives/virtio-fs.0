Date: Thu, 15 Aug 2019 08:39:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190815123949.GA4878@redhat.com>
References: <1565634725-89726-1-git-send-email-bo.liu@linux.alibaba.com>
	<1565634725-89726-2-git-send-email-bo.liu@linux.alibaba.com>
	<20190814195718.GD7475@redhat.com>
	<20190814203012.v4azojizk224iv3y@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814203012.v4azojizk224iv3y@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtio-fs: do not removemapping if dmap
 will be used immediately
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

On Wed, Aug 14, 2019 at 01:30:12PM -0700, Liu Bo wrote:
> On Wed, Aug 14, 2019 at 03:57:18PM -0400, Vivek Goyal wrote:
> > On Tue, Aug 13, 2019 at 02:32:05AM +0800, Liu Bo wrote:
> > > According to how we implement REMOVEMAPPING in daemon, it's unnecessary to
> > > involve a REMOVEMAPPING to reuse a dmap when doing inline reclaim because
> > > dmaps got from inline reclaim get reused for another mapping without being
> > > added back to 'free' dmap pool.
> > > 
> > > This skips REMOVEMAPPING for inline reclaim only and we don't do
> > > REMOVEMAPPING unless someone has raced in to add a dmap to the range.
> > 
> > Given inline reclaims are enabled only for writes, how does this benefit
> > a random read workload.
> >
> 
> Oh, I thought your branch has done it, anyway I've made read take inline
> reclaim as well locally before these two patches, and all tests I have
> didn't complain yet.

I reverted that patch as I found an issue. I just can't remember what
was the issue. Will try to reapply the patch and see if I can see the
problem again.

> 
> I'm testing a kernel build with dmap=1, can you please elaborate more
> on why these might end up deadlock?

Can't remember right now. Generally I have faced many deadlock issues
with dmap=1. So it is a good idea to test with it. We want to make sure
that even with one dax range, we can continue to make forward progress.

Thanks
Vivek

