Date: Mon, 4 Jan 2021 13:45:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210104184527.GC63879@redhat.com>
References: <20210104160013.GG2972@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104160013.GG2972@work-vm>
Subject: Re: [Virtio-fs] 'FORGET' ordering semantics (vs unlink & NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: fuse-devel@lists.sourceforge.net, virtio-fs@redhat.com

On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> Hi,
>   On virtio-fs we're hitting a problem with NFS, where
> unlinking a file in a directory and then rmdir'ing that
> directory fails complaining about the directory not being empty.
> 
> The problem here is that if a file has an open fd, NFS doesn't
> actually delete the file on unlink, it just renames it to
> a hidden file (e.g. .nfs*******).  That open file is there because
> the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> 
> Question:
>   a) In the FUSE protocol, are requests assumed to complete in order;
> i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> before the rmdir is processed?
>      (In virtiofs we've been processing requests, in parallel, and
> have sent forgets down a separate queue to keep them out of the way).
> 
>   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> client to have finished it;  do we need a synchronous forget here?

Even if we introduce a synchronous forget, will that really fix the
issue. For example, this could also happen if file has been unlinked
but it is still open and directory is being removed.

fd = open(foo/bar.txt)
unlink foo/bar.txt
rmdir foo
close(fd).

In this case, final forget should go after fd has been closed. Its
not a forget race. 

I wrote a test case for this and it works on regular file systems.

https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c

I suspect it will fail on nfs because I am assuming that temporary
file will be there till final close(fd) happens. If that's the
case this is a NFS specific issue because its behavior is different
from other file systems.

Vivek

> 
>   c) Has this problem been hit by any other fuse users (with NFS or otherwise)?
> 
> Dave
> 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

