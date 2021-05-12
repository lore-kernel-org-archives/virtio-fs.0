Date: Thu, 13 May 2021 06:36:37 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20210512223637.GA6241@rsjd01523.et2sqa>
References: <20210215095410.85607-1-stefanha@redhat.com>
	<YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <YJo+wCSffIZAx9aM@stefanha-x1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [virtio-dev] [PATCH v2 0/2] virtio-fs:
	add	notification queue
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, virtio-dev@lists.oasis-open.org, vgoyal@redhat.com

Hi Stefan,

On Tue, May 11, 2021 at 09:22:24AM +0100, Stefan Hajnoczi wrote:
> On Mon, Feb 15, 2021 at 09:54:08AM +0000, Stefan Hajnoczi wrote:
> > v2:
> >  * Document empty virtqueue behavior for FUSE_NOTIFY_LOCK messages
> > 
> > This patch series adds the notification queue to the VIRTIO specification.
> > This new virtqueue carries device->driver FUSE notify messages.  They are
> > currently unused but will be necessary for file locking, which can block for an
> > unbounded amount of time and therefore needs a asynchronous completion event
> > instead of a request/response buffer that consumes space in the request
> > virtqueue until the operation completes.
> > 
> > Patch 1 corrects an oversight I noticed: the file system device was not added
> > to the Conformance chapter.
> > 
> > Stefan Hajnoczi (2):
> >   virtio-fs: add file system device to Conformance chapter
> >   virtio-fs: add notification queue
> > 
> >  conformance.tex | 23 ++++++++++++++++
> >  virtio-fs.tex   | 71 ++++++++++++++++++++++++++++++++++++++++++-------
> >  2 files changed, 84 insertions(+), 10 deletions(-)
> 
> Reminder to anyone who needs the virtio-fs notification queue: please
> review this series.
>

Besides using notification queue to provide posix lock support, I've
also managed to invalidate dentry/inode's cache with notification
queue, it worked well.

I've read the patches and it looks good to me, so

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

(Somehow I couldn't find the original patches in my mailbox, but I've
read both at
https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg07062.html
https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg07222.html
)

thanks,
liubo

> Stefan



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

