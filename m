Date: Fri, 7 Jun 2019 16:21:47 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190607152147.GI2631@work-vm>
References: <1559875098-9347-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559875098-9347-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: enable PARALLEL_DIROPS during
	INIT
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

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> lookup is a RO operations, PARALLEL_DIROPS can be enabled.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

I'm not too sure what this is doing; and why doesn't upstream libfuse
have this?

Dave

> ---
>  contrib/virtiofsd/fuse_lowlevel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index c460c4c..93ce788 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -2089,6 +2089,8 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>  
>  	if (se->conn.want & FUSE_CAP_ASYNC_READ)
>  		outarg.flags |= FUSE_ASYNC_READ;
> +        if (se->conn.want & FUSE_CAP_PARALLEL_DIROPS)
> +                outarg.flags |= FUSE_PARALLEL_DIROPS;
>  	if (se->conn.want & FUSE_CAP_POSIX_LOCKS)
>  		outarg.flags |= FUSE_POSIX_LOCKS;
>  	if (se->conn.want & FUSE_CAP_ATOMIC_O_TRUNC)
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

