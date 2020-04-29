Date: Wed, 29 Apr 2020 17:32:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200429163218.GM2834@work-vm>
References: <20200429124733.22488-1-mszeredi@redhat.com>
	<20200429152659.GA134868@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429152659.GA134868@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: jail lo->proc_self_fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 29, 2020 at 02:47:33PM +0200, Miklos Szeredi wrote:
> > While it's not possible to escape the proc filesystem through
> > lo->proc_self_fd, it is possible to escape to the root of the proc
> > filesystem itself through "../..".
> > 
> > Use a temporary mount for opening lo->proc_self_fd, that has it's root at
> > /proc/self/fd/, preventing access to the ancestor directories.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> Good idea!
> 
> It's important to note that the proc file system is already mounted
> within a new pid namespace.  Therefore the only process visible is our
> own process and we don't need to worry about /proc/$PID.  However, there
> are a bunch of other files in /proc.  Some of them are protected by
> capability checks like /proc/kcore and virtiofsd is unable to access
> them, but it's hard to guarantee that they are all off limits.  Better
> safe than sorry!
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks; I've picked this up.

Dave

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

