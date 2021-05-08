From: Connor Kuehl <ckuehl@redhat.com>
References: <20210507221527.699516-1-ckuehl@redhat.com>
Message-ID: <9b9c8779-84b4-5c6d-8dc2-c16f18c68c70@redhat.com>
Date: Sat, 8 May 2021 07:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <20210507221527.699516-1-ckuehl@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable multiple request queues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 5/7/21 5:15 PM, Connor Kuehl wrote:
> Distribute requests across the multiqueue complex automatically based
> on the IRQ affinity.
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
> [..]
> +
> +		for_each_cpu(cpu, mask) {
> +			struct virtio_fs_vq **cpu_vq = per_cpu_ptr(&this_cpu_fsvq, cpu);
> +			*cpu_vq = &fs->vqs[i];
> +		}
> +	}

Hmm, actually, it's just occurred to me that the per-CPU state could be
problematic with multiple virtio-fs mounts.

I'll workshop this some more.

Connor

