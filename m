Date: Mon, 17 May 2021 08:48:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210517124829.GA546943@horse.lan>
References: <20210215095410.85607-1-stefanha@redhat.com>
	<YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
	<20210512223637.GA6241@rsjd01523.et2sqa>
	<YJ0tSmwRulBHGrIG@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <YJ0tSmwRulBHGrIG@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, virtio-dev@lists.oasis-open.org

On Thu, May 13, 2021 at 02:44:42PM +0100, Stefan Hajnoczi wrote:
> On Thu, May 13, 2021 at 06:36:37AM +0800, Liu Bo wrote:
> > Hi Stefan,
> > 
> > On Tue, May 11, 2021 at 09:22:24AM +0100, Stefan Hajnoczi wrote:
> > > On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> > > > v2:
> > > >  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
> > > > 
> > > > This patch series adds the notification queue to the VIRTIO specification.
> > > > This new virtqueue carries device->driver FUSE notify messages.  They are
> > > > currently unused but will be necessary for file locking, which can block for an
> > > > unbounded amount of time and therefore needs a asynchronous completion event
> > > > instead of a request/response buffer that consumes space in the request
> > > > virtqueue until the operation completes.
> > > > 
> > > > Patch 1 corrects an oversight I noticed: the file system device was not added
> > > > to the Conformance chapter.
> > > > 
> > > > Stefan Hajnoczi (2):
> > > >   virtio-fs: add file system device to Conformance chapter
> > > >   virtio-fs: add notification queue
> > > > 
> > > >  conformance.tex | 23 ++++++++++++++++
> > > >  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-------
> > > >  2 files changed, 84 insertions(+), 10 deletions(-)
> > > 
> > > Reminder to anyone who needs the virtio-fs notification queue: please
> > > review this series.
> > >
> > 
> > Besides using notification queue to provide posix lock support, I've
> > also managed to invalidate dentry/inode's cache with notification
> > queue, it worked well.
> 
> Thank you!
> 
> Are you using dentry/inode cache invalidation to reduce the number of
> file descriptors that virtiofsd needs to hold open,

Using notifications to invalidate client's dentry/inode cache sounds
interesting. Will like to see an actual implementation though. Various
races w.r.t opening the same file for which server is trying to invalidate
the dentry/inode might be little tricky.

Thanks
Vivek

