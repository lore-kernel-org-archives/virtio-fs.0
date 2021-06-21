Date: Mon, 21 Jun 2021 14:59:05 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YNCpOaNHRA9jEOpM@zeniv-ca.linux.org.uk>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210621062657.3641879-2-hch@lst.de>
	<YNCmTSTcubslmj7k@zeniv-ca.linux.org.uk>
	<20210621145309.GA4995@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210621145309.GA4995@lst.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 1/2] init: split get_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Mon, Jun 21, 2021 at 04:53:09PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 21, 2021 at 02:46:37PM +0000, Al Viro wrote:
> > TBH, I would rather take that one into fs/filesystems.c.  Rationale:
> > get_filesystem_list(), for all its resemblance to /proc/filesystems
> > contents, is used only by init/*.c and it's not a big deal to make
> > it
> 
> Yeah, unwinding this mess actually is a good idea.  I didn't really
> look outside of do_mounts.c, but once doing that it becomes completely
> obvious.
> 
> > int __init get_filesystem_list(char *buf, bool is_dev)
> 
> As-is we don't even really need the is_dev argument, as the only
> callers wants block device file systems anyway.

*nod*

> In fact it would
> much rather have a cursor based iteration so that we can skip the
> allocation, but that is probaby overengineering the problem.

Very much so.

Sigh...  I really wish we had more uniform syntax, though -
e.g.  root=nfs(<options>) or root=xfs(sdb11,noatime), etc.
Oh, well...

