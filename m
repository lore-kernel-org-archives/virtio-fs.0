Date: Tue, 16 Jul 2019 12:07:38 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190716190737.mukpr5bd4ur3v4hp@US-160370MP2.local>
References: <1562225131-23463-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190715203739.GB22193@redhat.com>
	<20190715213805.crgid6njeq6faavs@US-160370MP2.local>
	<20190716183635.GA16790@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183635.GA16790@redhat.com>
Subject: Re: [Virtio-fs] [PATCH RFC] virtiofs: use fine-grained lock for
 dmap reclaim
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

On Tue, Jul 16, 2019 at 02:36:35PM -0400, Vivek Goyal wrote:
> On Mon, Jul 15, 2019 at 02:38:06PM -0700, Liu Bo wrote:
> > On Mon, Jul 15, 2019 at 04:37:39PM -0400, Vivek Goyal wrote:
> > > On Thu, Jul 04, 2019 at 03:25:31PM +0800, Liu Bo wrote:
> > > > With free fuse dax mapping reducing, read performance is impacted
> > > > significantly because reads need to wait for a free fuse dax mapping.
> > > > 
> > > > Although reads will trigger reclaim work to try to reclaim fuse dax
> > > > mapping, reclaim code can barely make any progress if most of fuse dax
> > > > mappings are used by the file we're reading since inode lock is required
> > > > by reclaim code.
> > > > 
> > > > However, we don't have to take inode lock for reclaiming if dax mapping
> > > > has its own reference count, reference counting is to tell reclaim code to
> > > > skip those in use dax mappings, such that we can avoid the risk of
> > > > accidentally reclaiming a dax mapping that other readers are using.
> > > > 
> > > > On the other hand, holding ->i_dmap_sem during reclaim can be used to
> > > > prevent the follwing reads to get a dax mapping under reclaim.
> > > > 
> > > > Another reason is that reads/writes only use fuse dax mapping within
> > > > dax_iomap_rw(), so we can do such a trick, while mmap/faulting is a
> > > > different story and we have to take ->i_mmap_sem prior to reclaiming a dax
> > > > mapping in order to avoid the race.
> > > > 
> > > > This adds reference count for fuse dax mapping and removes the acquisition
> > > > of inode lock during reclaim.
> > > 
> > > I am not sure that this reference count implementation is safe. For
> > > example, what prevents atomic_dec() from being reordered so that it
> > > could be executed before actually copying to user space is finished.
> > > 
> > > Say cpu1 is reading a dax page and cpu 2 is freeing memory. 
> > > 
> > > cpu1 read				cpu2 free dmap
> > > ---------				-------------
> > > atomic_inc()				atomic_read()			
> > > copy data to user space
> > > atomic_dec
> > > 
> > > Say atomic_dec() gets reordered w.r.t copy_data_to_user_space.
> > > 
> > > cpu1 read				cpu2 free dmap
> > > ---------				-------------
> > > atomic_inc()				atomic_read()			
> > > atomic_dec
> > > copy data to user space
> > > 
> > > Now cpu2 will free up dax range while it is still being read?
> > 
> > Yep, I think this is possible.
> > 
> > For this specific reorder, barriers like smp_mb__{before,after}_atomic could fix
> > it.
> 
> Hi Liu Bo,
> 
> I have modified the patch to use refcount_t. Our use case is little
> different than typical reference counts. I hope that are no bugs there.
> 
> I have also fixed bunch of other issues and enabled inline range reclaim
> for read path. (It became possible with dmap refcount patch).
>
> Pushed my changes here for now. 
> 
> https://github.com/rhvgoyal/linux/commits/virtio-fs-dev-5.1
> 
> Please have a look and test. If everything looks good, I will squash these
> new patches into existing patches.

That's nice, I'll check it out.

Can you please send your patches out to this maillist?

(In fact it's difficult for us to track patches/changes on github,
esp. when they're squashed and we need to rebase our internal virtiofs
base by looking at the code line by line.)

thanks,
-liubo

