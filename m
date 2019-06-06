Date: Thu, 6 Jun 2019 14:06:46 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190606210645.2o7o53rscennhksl@US-160370MP2.local>
References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531185709.10267-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtio-fs: Waiting for pending
	forget	requests to finish
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

On Fri, May 31, 2019 at 02:57:09PM -0400, Vivek Goyal wrote:
> Keep a track of pending forget requests and wait for these to finish
> during ->kill_sb()
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 737e92cdc5ed..abdb58285805 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -32,6 +32,7 @@ struct virtio_fs_vq {
>  	struct delayed_work dispatch_work;
>  	struct fuse_dev *fud;
>  	bool connected;
> +	long in_flight;
>  	char name[24];
>  } ____cacheline_aligned_in_smp;
>  
> @@ -183,8 +184,10 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
>  
>  		virtqueue_disable_cb(vq);
>  
> -		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
> +		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
>  			kfree(req);
> +			fsvq->in_flight--;
> +		}
>  	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
>  	spin_unlock(&fsvq->lock);
>  }
> @@ -244,6 +247,7 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
>  			return;
>  		}
>  
> +		fsvq->in_flight++;
>  		notify = virtqueue_kick_prepare(vq);
>  		spin_unlock(&fsvq->lock);
>  
> @@ -753,6 +757,7 @@ __releases(fiq->waitq.lock)
>  		goto out;
>  	}
>  
> +	fsvq->in_flight++;
>  	notify = virtqueue_kick_prepare(vq);
>  
>  	spin_unlock(&fsvq->lock);
> @@ -982,6 +987,36 @@ __releases(fiq->waitq.lock)
>  	}
>  }
>  
> +static void virtio_fs_flush_hiprio_queue(struct virtio_fs_vq *fsvq)
> +{
> +	struct virtio_fs_forget *forget;
> +
> +	WARN_ON(fsvq->in_flight < 0);
> +
> +	/* Go through pending forget reuests and free them */
> +	spin_lock(&fsvq->lock);
> +	while(1) {
> +		forget = list_first_entry_or_null(&fsvq->queued_reqs,
> +					struct virtio_fs_forget, list);
> +		if (!forget)
> +			break;
> +		kfree(forget);
> +	}
> +
> +	spin_unlock(&fsvq->lock);
> +
> +	/* Wait for in flight requests to finish.*/
> +	while (1) {
> +		spin_lock(&fsvq->lock);
> +		if (!fsvq->in_flight) {
> +			spin_unlock(&fsvq->lock);
> +			break;
> +		}
> +		spin_unlock(&fsvq->lock);
> +		usleep_range(1000, 2000);

Looks like #include <linux/delay.h> is also needed in order to pass
building.

thanks,
-liubo

> +	}
> +}
> +
>  const static struct fuse_iqueue_ops virtio_fs_fiq_ops = {
>  	.wake_forget_and_unlock		= virtio_fs_wake_forget_and_unlock,
>  	.wake_interrupt_and_unlock	= virtio_fs_wake_interrupt_and_unlock,
> @@ -1086,6 +1121,7 @@ static void virtio_kill_sb(struct super_block *sb)
>  	spin_lock(&fsvq->lock);
>  	fsvq->connected = false;
>  	spin_unlock(&fsvq->lock);
> +	virtio_fs_flush_hiprio_queue(fsvq);
>  
>  	fuse_kill_sb_anon(sb);
>  	virtio_fs_free_devs(vfs);
> -- 
> 2.20.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

