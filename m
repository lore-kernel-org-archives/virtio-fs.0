Date: Wed, 7 Oct 2020 11:42:11 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201007104211.GA22258@work-vm>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827153657.111098-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/6] virtiofsd: Silence gcc warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com

* Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Gcc worries fd might be used unset, in reality it's always set if
> fi is set, and only used if fi is set so it's safe.  Initialise it to -1
> just to keep gcc happy for now.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Queued (just this patch)

> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 63d1d00565..083d17a960 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -617,7 +617,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>      struct lo_inode *inode;
>      int ifd;
>      int res;
> -    int fd;
> +    int fd = -1;
>  
>      inode = lo_inode(req, ino);
>      if (!inode) {
> -- 
> 2.26.2
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

