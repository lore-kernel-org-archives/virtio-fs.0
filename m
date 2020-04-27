Date: Mon, 27 Apr 2020 13:58:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200427175814.GC146096@redhat.com>
References: <20200424062540.23679-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424062540.23679-1-chirantan@chromium.org>
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: virtiofs: Fix nullptr dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>

On Fri, Apr 24, 2020 at 03:25:39PM +0900, Chirantan Ekbote wrote:
> virtiofs device implementations are allowed to provide more than one
> request queue.  In this case `fsvq->fud` would not be initialized,
> leading to a nullptr dereference later during driver initialization.
> 
> Make sure that `fsvq->fud` is initialized for all request queues even if
> the driver doesn't use them.
> 
> Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> ---
>  fs/fuse/virtio_fs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index bade747689033..d3c38222a7e4e 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -1066,10 +1066,13 @@ static int virtio_fs_fill_super(struct super_block *sb)
>  	}
>  
>  	err = -ENOMEM;
> -	/* Allocate fuse_dev for hiprio and notification queues */
> -	for (i = 0; i < VQ_REQUEST; i++) {
> +	/* Allocate fuse_dev for all queues except the first request queue. */
> +	for (i = 0; i < fs->nvqs; i++) {
>  		struct virtio_fs_vq *fsvq = &fs->vqs[i];
>  
> +		if (i == VQ_REQUEST)
> +			continue;
> +

These special conditions of initializing fuse device for one queue
fusing fill_super_common() and rest of the queues outside of it, are
bothering me. I am proposing a separate patch where all fuse device
initialization/cleanup is done by the caller. It makes code look
cleaner and easier to understand.

Vivek

>  		fsvq->fud = fuse_dev_alloc();
>  		if (!fsvq->fud)
>  			goto err_free_fuse_devs;
> -- 
> 2.26.2.303.gf8c07b1a785-goog
> 

