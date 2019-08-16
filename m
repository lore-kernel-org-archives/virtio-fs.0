References: <5D4D0D06.1090602@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5645BD.7010705@huawei.com>
Date: Fri, 16 Aug 2019 13:57:17 +0800
MIME-Version: 1.0
In-Reply-To: <5D4D0D06.1090602@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
	affinity
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Ping, any comments on this patch?

On 2019/8/9 14:04, piaojun wrote:
> Set cpu affinity for each queue in multiqueue mode to improve the iops
> performance.
> 
>>From my test, the iops is increased by adding multiqueues as below,
> but it has not achieved my expect yet due to some reason. So I'm
> considering if we could drop some locks when operating vq as it is
> binded to one vCPU. I'm very glad to have a discuss with other
> developers.
> 
> Further more, I modified virtiofsd to support multiqueue which just for
> testing.
> 
> Test Environment:
> Guest configuration:
> 8 vCPU
> 8GB RAM
> Linux 5.1 (vivek-aug-06-2019)
> 
> Host configuration:
> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
> 32GB RAM
> Linux 3.10.0
> EXT4 + 4G Ramdisk
> 
> ---
> Single-queue:
> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
> ...
> fio-2.13
> Starting 8 processes
> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=8): err= 0: pid=5808: Fri Aug  9 20:35:22 2019
>   write: io=9499.9MB, bw=324251KB/s, iops=81062, runt= 30001msec
> 
> Multi-queues:
> # fio -direct=1 -time_based -iodepth=128 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjob=8 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
> ...
> fio-2.13
> Starting 8 processes
> Jobs: 8 (f=8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=8): err= 0: pid=5704: Fri Aug  9 20:38:47 2019
>   write: io=12967MB, bw=442582KB/s, iops=110645, runt= 30001msec
> ---
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/fuse/virtio_fs.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index a04c320..7ba36fc 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -12,6 +12,7 @@
>  #include <linux/virtio.h>
>  #include <linux/virtio_fs.h>
>  #include <linux/delay.h>
> +#include <linux/cpu.h>
>  #include "fuse_i.h"
> 
>  /* List of virtio-fs device instances and a lock for the list */
> @@ -61,6 +62,9 @@ struct virtio_fs {
>  	void *window_kaddr;
>  	phys_addr_t window_phys_addr;
>  	size_t window_len;
> +
> +	/* Does the affinity hint is set for virtqueues? */
> +	bool affinity_hint_set;
>  };
> 
>  struct virtio_fs_forget {
> @@ -378,6 +382,44 @@ static void virtio_fs_vq_done(struct virtqueue *vq)
>  	schedule_work(&fsvq->done_work);
>  }
> 
> +static void virtio_fs_clean_affinity(struct virtio_fs *fs)
> +{
> +	int i;
> +
> +	if (fs->affinity_hint_set) {
> +		for (i = 0; i < fs->num_queues; i++)
> +			virtqueue_set_affinity(fs->vqs[i].vq, NULL);
> +
> +		fs->affinity_hint_set = false;
> +	}
> +}
> +
> +static void virtio_fs_set_affinity(struct virtio_fs *fs)
> +{
> +	int i = 0, cpu;
> +
> +	/*
> +	 * In single queue mode, we don't set the cpu affinity.
> +	 */
> +	if (fs->num_queues == 1) {
> +		virtio_fs_clean_affinity(fs);
> +		fs->affinity_hint_set = false;
> +		return;
> +	}
> +
> +	/*
> +	 * In multiqueue mode, we let the queue to be private to one cpu
> +	 * by setting the affinity hint to eliminate the contention.
> +	 */
> +	for_each_online_cpu(cpu) {
> +		virtqueue_set_affinity(fs->vqs[i].vq, cpumask_of(cpu));
> +		if (++i >= fs->num_queues)
> +			break;
> +	}
> +
> +	fs->affinity_hint_set = true;
> +}
> +
>  /* Initialize virtqueues */
>  static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  			       struct virtio_fs *fs)
> @@ -440,6 +482,11 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  		fs->vqs[i].vq = vqs[i];
>  		fs->vqs[i].connected = true;
>  	}
> +
> +	/* set affinity for vqs */
> +	get_online_cpus();
> +	virtio_fs_set_affinity(fs);
> +	put_online_cpus();
>  out:
>  	kfree(names);
>  	kfree(callbacks);
> @@ -451,6 +498,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  static void virtio_fs_cleanup_vqs(struct virtio_device *vdev,
>  				  struct virtio_fs *fs)
>  {
> +	virtio_fs_clean_affinity(fs);
>  	vdev->config->del_vqs(vdev);
>  }
> 
> @@ -954,10 +1002,22 @@ static int virtio_fs_enqueue_req(struct virtqueue *vq, struct fuse_req *req)
>  	return ret;
>  }
> 
> +static unsigned virtio_fs_pick_vq_mq(struct virtio_fs *fs)
> +{
> +	unsigned queue_id;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	queue_id = (smp_processor_id() % fs->num_queues) + VQ_REQUEST;
> +	local_irq_restore(flags);
> +
> +	return queue_id;
> +}
> +
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->waitq.lock)
>  {
> -	unsigned queue_id = VQ_REQUEST; /* TODO multiqueue */
> +	unsigned queue_id = VQ_REQUEST;
>  	struct virtio_fs *fs;
>  	struct fuse_conn *fc;
>  	struct fuse_req *req;
> @@ -972,6 +1032,8 @@ static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  	spin_unlock(&fiq->waitq.lock);
> 
>  	fs = fiq->priv;
> +	if (fs->num_queues > 1)
> +		queue_id = virtio_fs_pick_vq_mq(fs);
>  	fc = fs->vqs[queue_id].fud->fc;
> 
>  	dev_dbg(&fs->vqs[queue_id].vq->vdev->dev,
> @@ -1066,9 +1128,11 @@ static int virtio_fs_fill_super(struct super_block *sb, char *opts,
> 
>  	err = -ENOMEM;
>  	/* Allocate fuse_dev for hiprio and notification queues */
> -	for (i = 0; i < VQ_REQUEST; i++) {
> +	for (i = 0; i < VQ_REQUEST + fs->num_queues; i++) {
>  		struct virtio_fs_vq *fsvq = &fs->vqs[i];
> 
> +		if (i == VQ_REQUEST)
> +			continue;  /* will be allocated in fuse_fill_super_common */
>  		fsvq->fud = fuse_dev_alloc();
>  		if (!fsvq->fud)
>  			goto err_free_fuse_devs;
> 

