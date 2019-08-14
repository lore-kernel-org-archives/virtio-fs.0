Date: Wed, 14 Aug 2019 10:13:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190814091329.GB2920@work-vm>
References: <20190813192944.26009-1-vgoyal@redhat.com>
	<20190813192944.26009-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813192944.26009-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofsd: Use macros for write_flag
	parsing
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

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Use macros instead of hard coded bit positions.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

OK, this is part of upstream 1b7d2b8


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/fuse_lowlevel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index 8d3f141d23..417f99e8dc 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -1161,7 +1161,7 @@ static void do_write(fuse_req_t req, fuse_ino_t nodeid,
>  
>  	memset(&fi, 0, sizeof(fi));
>  	fi.fh = arg->fh;
> -	fi.writepage = (arg->write_flags & 1) != 0;
> +	fi.writepage = (arg->write_flags & FUSE_WRITE_CACHE) != 0;
>  
>  	if (!compat) {
>  		fi.lock_owner = arg->lock_owner;
> @@ -1208,7 +1208,7 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
>  	}
>  
>  	fi.fh = arg->fh;
> -	fi.writepage = arg->write_flags & 1;
> +	fi.writepage = !!(arg->write_flags & FUSE_WRITE_CACHE);
>  
>          if (ibufv->count == 1) {
>  		assert(!(tmpbufv.buf[0].flags & FUSE_BUF_IS_FD));
> -- 
> 2.17.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

