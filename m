Date: Wed, 5 Jun 2019 11:16:23 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190605181622.fqc6nhnchosw7jxd@US-160370MP2.local>
References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531185709.10267-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] Use helper function to get forget
 requests	from fuse
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, tao.peng@linux.alibaba.com

On Fri, May 31, 2019 at 02:57:07PM -0400, Vivek Goyal wrote:
> stacked file systems like virtio-fs do not have to play directly with
> forget list data structures. There is a helper function use that instead.
> 
> Rename dequeue_forget() to fuse_dequeue_forget() and export it so that
> stacked filesystems can use it.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
-liubo
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/dev.c       | 9 +++++----
>  fs/fuse/fuse_i.h    | 3 +++
>  fs/fuse/virtio_fs.c | 7 +------
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ee9dd38bc0f0..39da7ec19fa2 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1203,7 +1203,7 @@ __releases(fiq->waitq.lock)
>  	return err ? err : reqsize;
>  }
>  
> -static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
> +struct fuse_forget_link *fuse_dequeue_forget(struct fuse_iqueue *fiq,
>  					       unsigned max,
>  					       unsigned *countp)
>  {
> @@ -1224,6 +1224,7 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
>  
>  	return head;
>  }
> +EXPORT_SYMBOL(fuse_dequeue_forget);
>  
>  static int fuse_read_single_forget(struct fuse_iqueue *fiq,
>  				   struct fuse_copy_state *cs,
> @@ -1231,7 +1232,7 @@ static int fuse_read_single_forget(struct fuse_iqueue *fiq,
>  __releases(fiq->waitq.lock)
>  {
>  	int err;
> -	struct fuse_forget_link *forget = dequeue_forget(fiq, 1, NULL);
> +	struct fuse_forget_link *forget = fuse_dequeue_forget(fiq, 1, NULL);
>  	struct fuse_forget_in arg = {
>  		.nlookup = forget->forget_one.nlookup,
>  	};
> @@ -1279,7 +1280,7 @@ __releases(fiq->waitq.lock)
>  	}
>  
>  	max_forgets = (nbytes - ih.len) / sizeof(struct fuse_forget_one);
> -	head = dequeue_forget(fiq, max_forgets, &count);
> +	head = fuse_dequeue_forget(fiq, max_forgets, &count);
>  	spin_unlock(&fiq->waitq.lock);
>  
>  	arg.count = count;
> @@ -2249,7 +2250,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
>  			clear_bit(FR_PENDING, &req->flags);
>  		list_splice_tail_init(&fiq->pending, &to_end);
>  		while (forget_pending(fiq))
> -			kfree(dequeue_forget(fiq, 1, NULL));
> +			kfree(fuse_dequeue_forget(fiq, 1, NULL));
>  		wake_up_all_locked(&fiq->waitq);
>  		spin_unlock(&fiq->waitq.lock);
>  		kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 7ac7f9a0b81b..ad8272c98c82 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -972,6 +972,9 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
>  
>  struct fuse_forget_link *fuse_alloc_forget(void);
>  
> +struct fuse_forget_link *fuse_dequeue_forget(struct fuse_iqueue *fiq,
> +					     unsigned max, unsigned *countp);
> +
>  /* Used by READDIRPLUS */
>  void fuse_force_forget(struct file *file, u64 nodeid);
>  
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 18fc0dca0abc..cbda7ebd5bf9 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -697,12 +697,7 @@ __releases(fiq->waitq.lock)
>  	u64 unique;
>  	int ret;
>  
> -	BUG_ON(!fiq->forget_list_head.next);
> -	link = fiq->forget_list_head.next;
> -	BUG_ON(link->next);
> -	fiq->forget_list_head.next = NULL;
> -	fiq->forget_list_tail = &fiq->forget_list_head;
> -
> +	link = fuse_dequeue_forget(fiq, 1, NULL);
>  	unique = fuse_get_unique(fiq);
>  
>  	fs = fiq->priv;
> -- 
> 2.20.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

