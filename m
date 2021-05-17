Date: Mon, 17 May 2021 09:03:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210517130347.GB546943@horse.lan>
References: <20210215095410.85607-1-stefanha@redhat.com>
	<YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
	<20210512223637.GA6241@rsjd01523.et2sqa>
	<YJ0tSmwRulBHGrIG@stefanha-x1.localdomain>
	<20210513174956.GA105474@rsjd01523.et2sqa>
MIME-Version: 1.0
In-Reply-To: <20210513174956.GA105474@rsjd01523.et2sqa>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [virtio-dev] [PATCH v2 0/2] virtio-fs: add
 notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, virtio-dev@lists.oasis-open.org

On Fri, May 14, 2021 at 01:50:06AM +0800, Liu Bo wrote:
> On Thu, May 13, 2021 at 02:44:42PM +0100, Stefan Hajnoczi wrote:
> > On Thu, May 13, 2021 at 06:36:37AM +0800, Liu Bo wrote:
> > > Hi Stefan,
> > > 
> > > On Tue, May 11, 2021 at 09:22:24AM +0100, Stefan Hajnoczi wrote:
> > > > On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> > > > > v2:
> > > > >  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
> > > > > 
> > > > > This patch series adds the notification queue to the VIRTIO specification.
> > > > > This new virtqueue carries device->driver FUSE notify messages.  They are
> > > > > currently unused but will be necessary for file locking, which can block for an
> > > > > unbounded amount of time and therefore needs a asynchronous completion event
> > > > > instead of a request/response buffer that consumes space in the request
> > > > > virtqueue until the operation completes.
> > > > > 
> > > > > Patch 1 corrects an oversight I noticed: the file system device was not added
> > > > > to the Conformance chapter.
> > > > > 
> > > > > Stefan Hajnoczi (2):
> > > > >   virtio-fs: add file system device to Conformance chapter
> > > > >   virtio-fs: add notification queue
> > > > > 
> > > > >  conformance.tex | 23 ++++++++++++++++
> > > > >  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-------
> > > > >  2 files changed, 84 insertions(+), 10 deletions(-)
> > > > 
> > > > Reminder to anyone who needs the virtio-fs notification queue: please
> > > > review this series.
> > > >
> > > 
> > > Besides using notification queue to provide posix lock support, I've
> > > also managed to invalidate dentry/inode's cache with notification
> > > queue, it worked well.
> > 
> > Thank you!
> > 
> > Are you using dentry/inode cache invalidation to reduce the number of
> > file descriptors that virtiofsd needs to hold open, or are you using it
> > because the file system is shared by multiple systems and you want to
> > stronger cache coherency?
> >
> 
> The former one is one of the problems I've come across, but I worked
> around it by set_rlimit'ing a large enough number of fds.
> 
> My scenario is that
> 
> a) a bind mount point was shared as a sub-directory of virtiofs's shared directory,
> 
> b) and I needed to umount the bind mount point on the host side but I
> was not able to because virtiofsd enables cache=always,
> 
> So basically it was used as a preciser "drop_cache".
> 
> Besides that, I'm going to do some experiements with notification
> queue to give a warm up for fuse's metadata in order to have less
> metadata requests.  Although this may be done with ebpf as well, the
> idea with notification queue seems more straightforward.

Interesting idea. Pre-filling caches. This probably is more useful only
with cache=always. Cache=auto will invalidate metadata anyway after 1
second. Also it requires one to know which metadata workload is likely
to exercise otherwise you will consume more memory.

Thanks
Vivek

