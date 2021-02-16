Date: Tue, 16 Feb 2021 17:55:26 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YCwHDvMDDYMy+4de@work-vm>
References: <20210210182744.27324-1-vgoyal@redhat.com>
	<20210210182744.27324-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210182744.27324-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/1] virtiofsd: Do not use a thread pool by
 default
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Currently we created a thread pool (With 64 max threads per pool) for
> each virtqueue. We hoped that this will provide us with better scalability
> and performance.
> 
> But in practice, we are getting better numbers in most of the cases
> when we don't create a thread pool at all and a single thread per
> virtqueue receives the request and processes it.
> 
> Hence, I am proposing that we switch to no thread pool by default
> (equivalent of --thread-pool-size=0). This will provide out of
> box better performance to most of the users. In fact other users
> have confirmed that not using a thread pool gives them better
> numbers. So why not use this as default. It can be changed when
> somebody can fix the issues with thread pool performance.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

OK, lets try it - I still worry it really means we're missing something
silly about them, you'd really think eventually the threads should help.



Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_lowlevel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index e94b71110b..fbdf62ee9b 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -18,7 +18,7 @@
>  
>  #include <sys/file.h>
>  
> -#define THREAD_POOL_SIZE 64
> +#define THREAD_POOL_SIZE 0
>  
>  #define OFFSET_MAX 0x7fffffffffffffffLL
>  
> -- 
> 2.25.4
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

