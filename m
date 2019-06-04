References: <20190531185709.10267-1-vgoyal@redhat.com>
	<20190531185709.10267-4-vgoyal@redhat.com>
From: Peng Tao <tao.peng@linux.alibaba.com>
Message-ID: <fe5f90d3-0986-5cbb-0f1e-11f3384476ad@linux.alibaba.com>
Date: Tue, 4 Jun 2019 12:06:40 +0800
MIME-Version: 1.0
In-Reply-To: <20190531185709.10267-4-vgoyal@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 3/3] virtio-fs: Waiting for pending forget
 requests to finish
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com



On 2019/6/1 02:57, Vivek Goyal wrote:
> Keep a track of pending forget requests and wait for these to finish
> during ->kill_sb()
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>   fs/fuse/virtio_fs.c | 38 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 737e92cdc5ed..abdb58285805 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -32,6 +32,7 @@ struct virtio_fs_vq {
>   	struct delayed_work dispatch_work;
>   	struct fuse_dev *fud;
>   	bool connected;
> +	long in_flight;
>   	char name[24];
>   } ____cacheline_aligned_in_smp;
>   
> @@ -183,8 +184,10 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
>   
>   		virtqueue_disable_cb(vq);
>   
> -		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
> +		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
>   			kfree(req);
> +			fsvq->in_flight--;
> +		}
>   	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
>   	spin_unlock(&fsvq->lock);
>   }
> @@ -244,6 +247,7 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
>   			return;
>   		}
>   
> +		fsvq->in_flight++;
>   		notify = virtqueue_kick_prepare(vq);
>   		spin_unlock(&fsvq->lock);
>   
> @@ -753,6 +757,7 @@ __releases(fiq->waitq.lock)
>   		goto out;
>   	}
>   
> +	fsvq->in_flight++;
>   	notify = virtqueue_kick_prepare(vq);
>   
>   	spin_unlock(&fsvq->lock);
> @@ -982,6 +987,36 @@ __releases(fiq->waitq.lock)
>   	}
>   }
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
missing list_del()?

Cheers,
Tao

