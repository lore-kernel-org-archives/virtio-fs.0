Date: Wed, 22 Jan 2020 18:41:25 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200122184125.GR3263@work-vm>
References: <20200120025330.32140-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120025330.32140-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: passthrough_ll: Use
 cache_readdir for directory open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, mszeredi@redhat.com
Cc: virtio-fs@redhat.com

* Misono Tomohiro (misono.tomohiro@jp.fujitsu.com) wrote:
> Since keep_cache(FOPEN_KEEP_CACHE) has no effect for directory as
> described in fuse_common.h, use cache_readdir(FOPNE_CACHE_DIR) for
> diretory open when cache=always mode.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

cc'ing Miklos.

> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 5519682daa..088fef08f1 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1674,7 +1674,7 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>  
>      fi->fh = fh;
>      if (lo->cache == CACHE_ALWAYS) {
> -        fi->keep_cache = 1;
> +        fi->cache_readdir = 1;
>      }
>      fuse_reply_open(req, fi);
>      return;
> -- 
> 2.21.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

