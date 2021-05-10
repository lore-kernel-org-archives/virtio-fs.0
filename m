Date: Mon, 10 May 2021 11:25:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210510152506.GC150402@horse>
References: <20210507221527.699516-1-ckuehl@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210507221527.699516-1-ckuehl@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable multiple request queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Fri, May 07, 2021 at 03:15:27PM -0700, Connor Kuehl wrote:
> Distribute requests across the multiqueue complex automatically based
> on the IRQ affinity.

Hi Connor,

Thanks for the patch. I will look into it and also test it.

How did you test it? Did you modify vitiofsd to support multiqueue. Did
you also run some performance numbers. Does it provide better/worse
performance as compared to single queue.

Thanks
Vivek

> 
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index bcb8a02e2d8b..dcdc8b7b1ad5 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -30,6 +30,10 @@
>  static DEFINE_MUTEX(virtio_fs_mutex);
>  static LIST_HEAD(virtio_fs_instances);
>  
> +struct virtio_fs_vq;
> +
> +DEFINE_PER_CPU(struct virtio_fs_vq *, this_cpu_fsvq);
> +
>  enum {
>  	VQ_HIPRIO,
>  	VQ_REQUEST
> @@ -673,6 +677,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  	struct virtqueue **vqs;
>  	vq_callback_t **callbacks;
>  	const char **names;
> +	struct irq_affinity desc = { .pre_vectors = 1, .nr_sets = 1, };
>  	unsigned int i;
>  	int ret = 0;
>  
> @@ -681,6 +686,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  	if (fs->num_request_queues == 0)
>  		return -EINVAL;
>  
> +	fs->num_request_queues = min_t(unsigned int, nr_cpu_ids,
> +				       fs->num_request_queues);
> +
>  	fs->nvqs = VQ_REQUEST + fs->num_request_queues;
>  	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
>  	if (!fs->vqs)
> @@ -710,12 +718,24 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  		names[i] = fs->vqs[i].name;
>  	}
>  
> -	ret = virtio_find_vqs(vdev, fs->nvqs, vqs, callbacks, names, NULL);
> +	ret = virtio_find_vqs(vdev, fs->nvqs, vqs, callbacks, names, &desc);
>  	if (ret < 0)
>  		goto out;
>  
> -	for (i = 0; i < fs->nvqs; i++)
> +	for (i = 0; i < fs->nvqs; i++) {
> +		const struct cpumask *mask;
> +		unsigned int cpu;
> +
>  		fs->vqs[i].vq = vqs[i];
> +		if (i == VQ_HIPRIO)
> +			continue;
> +
> +		mask = vdev->config->get_vq_affinity(vdev, i);
> +		for_each_cpu(cpu, mask) {
> +			struct virtio_fs_vq **cpu_vq = per_cpu_ptr(&this_cpu_fsvq, cpu);
> +			*cpu_vq = &fs->vqs[i];
> +		}
> +	}
>  
>  	virtio_fs_start_all_queues(fs);
>  out:
> @@ -877,8 +897,6 @@ static int virtio_fs_probe(struct virtio_device *vdev)
>  	if (ret < 0)
>  		goto out;
>  
> -	/* TODO vq affinity */
> -
>  	ret = virtio_fs_setup_dax(vdev, fs);
>  	if (ret < 0)
>  		goto out_vqs;
> @@ -1225,7 +1243,6 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->lock)
>  {
> -	unsigned int queue_id = VQ_REQUEST; /* TODO multiqueue */
>  	struct virtio_fs *fs;
>  	struct fuse_req *req;
>  	struct virtio_fs_vq *fsvq;
> @@ -1245,7 +1262,8 @@ __releases(fiq->lock)
>  		 req->in.h.nodeid, req->in.h.len,
>  		 fuse_len_args(req->args->out_numargs, req->args->out_args));
>  
> -	fsvq = &fs->vqs[queue_id];
> +	fsvq = this_cpu_read(this_cpu_fsvq);
> +
>  	ret = virtio_fs_enqueue_req(fsvq, req, false);
>  	if (ret < 0) {
>  		if (ret == -ENOMEM || ret == -ENOSPC) {
> -- 
> 2.30.2
> 

