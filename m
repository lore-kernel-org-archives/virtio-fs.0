Date: Thu, 27 Jan 2022 17:53:20 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YfLcEJzqRdBG3SOO@work-vm>
References: <20220124212455.83968-1-vgoyal@redhat.com>
	<20220124212455.83968-5-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220124212455.83968-5-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 4/9] virtiofsd: Extend size of
 fuse_conn_info->capable and ->want fields
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> ->capable keeps track of what capabilities kernel supports and ->wants keep
> track of what capabilities filesytem wants.
> 
> Right now these fields are 32bit in size. But now fuse has run out of
> bits and capabilities can now have bit number which are higher than 31.
> 
> That means 32 bit fields are not suffcient anymore. Increase size to 64
> bit so that we can add newer capabilities and still be able to use existing
> code to check and set the capabilities.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_common.h   | 4 ++--
>  tools/virtiofsd/fuse_lowlevel.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
> index 0c2665b977..6f8a988202 100644
> --- a/tools/virtiofsd/fuse_common.h
> +++ b/tools/virtiofsd/fuse_common.h
> @@ -439,7 +439,7 @@ struct fuse_conn_info {
>      /**
>       * Capability flags that the kernel supports (read-only)
>       */
> -    unsigned capable;
> +    uint64_t capable;
>  
>      /**
>       * Capability flags that the filesystem wants to enable.
> @@ -447,7 +447,7 @@ struct fuse_conn_info {
>       * libfuse attempts to initialize this field with
>       * reasonable default values before calling the init() handler.
>       */
> -    unsigned want;
> +    uint64_t want;
>  
>      /**
>       * Maximum number of pending "background" requests. A
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index c3af5ede08..f3f5e70be6 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -2063,7 +2063,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>      if (se->conn.want & (~se->conn.capable)) {
>          fuse_log(FUSE_LOG_ERR,
>                   "fuse: error: filesystem requested capabilities "
> -                 "0x%x that are not supported by kernel, aborting.\n",
> +                 "0x%lx that are not supported by kernel, aborting.\n",

I think this will be OK in practice (need to check 32 bit); but weren't
you using llx in the last patch?



Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Dave

>                   se->conn.want & (~se->conn.capable));
>          fuse_reply_err(req, EPROTO);
>          se->error = -EPROTO;
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

