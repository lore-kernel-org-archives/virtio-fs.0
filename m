Date: Thu, 4 Feb 2021 12:15:38 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210204121538.GH3039@work-vm>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<20201215162119.27360-10-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215162119.27360-10-zhangjiachen.jaycee@bytedance.com>
Subject: Re: [Virtio-fs] [RFC PATCH 9/9] virtiofsd: (work around) Comment
 qsort in inflight I/O tracking
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, qemu-devel@nongnu.org, "Michael S . Tsirkin" <mst@redhat.com>

* Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> This is a work around. The qsort function will malloc memory instead of use
> stack memory when the resubmit_num is larger than 64 (total size larger than
> 1024 Bytes). This will cause seccomp kill virtiofsd, so we comment qsort.
> This work around will not affect the correctness of inflight I/O tracking.
> 
> Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>

That's an odd hack!   Just follow the audit log to see what seccomp was
upset by and add the right syscall.

Dave

> ---
>  contrib/libvhost-user/libvhost-user.c | 18 ------------------
>  1 file changed, 18 deletions(-)
> 
> diff --git a/contrib/libvhost-user/libvhost-user.c b/contrib/libvhost-user/libvhost-user.c
> index 8c97013e59..c226d5d915 100644
> --- a/contrib/libvhost-user/libvhost-user.c
> +++ b/contrib/libvhost-user/libvhost-user.c
> @@ -1167,20 +1167,6 @@ vu_check_queue_msg_file(VuDev *dev, VhostUserMsg *vmsg)
>      return true;
>  }
>  
> -static int
> -inflight_desc_compare(const void *a, const void *b)
> -{
> -    VuVirtqInflightDesc *desc0 = (VuVirtqInflightDesc *)a,
> -                        *desc1 = (VuVirtqInflightDesc *)b;
> -
> -    if (desc1->counter > desc0->counter &&
> -        (desc1->counter - desc0->counter) < VIRTQUEUE_MAX_SIZE * 2) {
> -        return 1;
> -    }
> -
> -    return -1;
> -}
> -
>  static int
>  vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
>  {
> @@ -1236,10 +1222,6 @@ vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
>              }
>          }
>  
> -        if (vq->resubmit_num > 1) {
> -            qsort(vq->resubmit_list, vq->resubmit_num,
> -                  sizeof(VuVirtqInflightDesc), inflight_desc_compare);
> -        }
>          vq->counter = vq->resubmit_list[0].counter + 1;
>      }
>  
> -- 
> 2.20.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

