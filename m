Date: Tue, 3 Sep 2019 18:35:11 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190903173511.GW2744@work-vm>
References: <20190827142340.23811-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827142340.23811-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix "filed" -> "failed" typo in
 error message
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
> Reported-by: Jun Piao <piaojun@huawei.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks, squashed into 'virtiofsd: passthrough_ll: add fallback for racy
ops'

Dave

> ---
> Based-on: <20190823092401.11883-1-stefanha@redhat.com>
>           ("[PATCH 0/2] virtiofsd: use "fuse_log.h" APIs instead of <err.h>")
> 
>  contrib/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index f348b0be9d..ff0c446187 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -673,7 +673,7 @@ retry:
>  	}
>  	if (stat.st_dev != inode->key.dev || stat.st_ino != inode->key.ino) {
>  		if (!retries)
> -			fuse_warning("lo_parent_and_name: filed to match last\n");
> +			fuse_warning("lo_parent_and_name: failed to match last\n");
>  		goto fail_unref;
>  	}
>  	*parent = p;
> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

