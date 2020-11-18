Date: Wed, 18 Nov 2020 14:51:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201118195153.GB111728@redhat.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 12, 2020 at 10:06:37AM +0100, Miklos Szeredi wrote:
> On Fri, Nov 6, 2020 at 11:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Nov 06, 2020 at 08:33:50PM +0000, Venegas Munoz, Jose Carlos wrote:
> > > Hi Vivek,
> > >
> > > I have tested with Kata 1.12-apha0, the results seems that are better for the use fio config I am tracking.
> > >
> > > The fio config does  randrw:
> > >
> > > fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75
> > >
> >
> > Hi Carlos,
> >
> > Thanks for the testing.
> >
> > So basically two conclusions from your tests.
> >
> > - for virtiofs, --thread-pool-size=0 is performing better as comapred
> >   to --thread-pool-size=1 as well as --thread-pool-size=64. Approximately
> >   35-40% better.
> >
> > - virtio-9p is still approximately 30% better than virtiofs
> >   --thread-pool-size=0.
> >
> > As I had done the analysis that this particular workload (mixed read and
> > write) is bad with virtiofs because after every write we are invalidating
> > attrs and cache so next read ends up fetching attrs again. I had posted
> > patches to gain some of the performance.
> >
> > https://lore.kernel.org/linux-fsdevel/20200929185015.GG220516@redhat.com/
> >
> > But I got the feedback to look into implementing file leases instead.
> 
> Hmm, the FUSE_AUTO_INVAL_DATA feature is buggy, how about turning it
> off for now?   9p doesn't have it, so no point in enabling it for
> virtiofs by default.

If we disable FUSE_AUTO_INVAL_DATA, then client page cache will not
be invalidated even after 1 sec, right? (for cache=auto).

Given now we also want to target sharing directory tree among multiple
clients, keeping FUSE_AUTO_INVAL_DATA enabled should help.

> 
> Also I think some confusion comes from cache=auto being the default
> for virtiofs.    Not sure what the default is for 9p, but comparing
> default to default will definitely not be apples to apples since this
> mode is nonexistent in 9p.
> 
> 9p:cache=none  <-> virtiofs:cache=none
> 9p:cache=loose <-> virtiofs:cache=always
> 
> "9p:cache=mmap" and "virtiofs:cache=auto" have no match.

Agreed from performance comparison point of view.

I will prefer cache=auto default (over cache=none) for virtiofsd. During
some kernel compilation tests over virtiofs, cache=none was painfully
slow as compared to cache=auto.

Thanks
Vivek

