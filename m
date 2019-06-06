Date: Thu, 6 Jun 2019 10:30:21 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190606093020.GF2788@work-vm>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
	<1559695356-75503-4-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559695356-75503-4-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 3/5] virtiofsd: fix memory leak on lo.inodes
 hashmap
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
> lo.inodes hashmap was not unref/destroy 'd on quiting, which was caught by valgrind.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index f348b16..e7e19dc 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2324,6 +2324,8 @@ err_out2:
>  err_out1:
>  	fuse_opt_free_args(&args);
>  
> +        if (lo.inodes)
> +                g_hash_table_destroy(lo.inodes);
>  	lo_map_destroy(&lo.fd_map);
>  	lo_map_destroy(&lo.dirp_map);
>  	lo_map_destroy(&lo.ino_map);

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

