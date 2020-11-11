Date: Wed, 11 Nov 2020 19:55:00 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201111195500.GP3232@work-vm>
References: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
	<f1e48ca8-d6de-d901-63c8-4f4024bda518@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1e48ca8-d6de-d901-63c8-4f4024bda518@huawei.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofsd: check whether strdup
 lo.source return NULL in main func
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
> In main func, strdup lo.source may fail. So check whether strdup
> lo.source return NULL before using it.
> 
> Signed-off-by: Haotian Li <lihaotian9@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 3e9bbc7a04..0c11134fb5 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3525,6 +3525,10 @@ int main(int argc, char *argv[])
>          }
>      } else {
>          lo.source = strdup("/");
> +        if (!lo.source) {
> +            fuse_log(FUSE_LOG_ERR, "failed to strdup source\n");
> +            goto err_out1;
> +        }
>      }
> 

(It's interesting we use exit's in some places, goto's in others)

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>      if (lo.xattrmap) {
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

