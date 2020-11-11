Date: Wed, 11 Nov 2020 19:52:41 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201111195241.GO3232@work-vm>
References: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
	<48887813-1c95-048c-6d10-48e3dd2bac71@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48887813-1c95-048c-6d10-48e3dd2bac71@huawei.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofsd: check whether lo_map_reserve
 returns NULL in, main func
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Haotian Li <lihaotian9@huawei.com>
Cc: virtio-fs@redhat.com, linfeilong@huawei.com, qemu-devel@nongnu.org

* Haotian Li (lihaotian9@huawei.com) wrote:
> In main func, func lo_map_reserve is called without NULL check.
> If reallocing new_elems fails in func lo_map_grow, the func
> lo_map_reserve may return NULL. We should check whether
> lo_map_reserve returns NULL before using it.
> 
> Signed-off-by: Haotian Li <lihaotian9@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

(I think the fuse_log will always fall through the default_log_func
becuase it's very early)

> ---
>  tools/virtiofsd/passthrough_ll.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index ec1008bceb..3e9bbc7a04 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3433,6 +3433,7 @@ int main(int argc, char *argv[])
>          .proc_self_fd = -1,
>      };
>      struct lo_map_elem *root_elem;
> +    struct lo_map_elem *reserve_elem;
>      int ret = -1;
> 
>      /* Don't mask creation mode, kernel already did that */
> @@ -3452,8 +3453,17 @@ int main(int argc, char *argv[])
>       * [1] Root inode
>       */
>      lo_map_init(&lo.ino_map);
> -    lo_map_reserve(&lo.ino_map, 0)->in_use = false;
> +    reserve_elem = lo_map_reserve(&lo.ino_map, 0);
> +    if (!reserve_elem) {
> +        fuse_log(FUSE_LOG_ERR, "failed to alloc reserve_elem.\n");
> +        goto err_out1;
> +    }
> +    reserve_elem->in_use = false;
>      root_elem = lo_map_reserve(&lo.ino_map, lo.root.fuse_ino);
> +    if (!root_elem) {
> +        fuse_log(FUSE_LOG_ERR, "failed to alloc root_elem.\n");
> +        goto err_out1;
> +    }
>      root_elem->inode = &lo.root;
> 
>      lo_map_init(&lo.dirp_map);
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

