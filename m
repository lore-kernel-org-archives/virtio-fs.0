Date: Fri, 3 Jan 2020 10:41:39 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200103104139.GB3804@work-vm>
References: <20191224033151.2459-1-eguan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224033151.2459-1-eguan@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix eventfd_write failure message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Eryu Guan (eguan@linux.alibaba.com) wrote:
> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 2ae38758567e..775f32bdaae2 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -843,7 +843,7 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>  
>          /* Kill the thread */
>          if (eventfd_write(ourqi->kill_fd, 1)) {
> -            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
> +            fuse_log(FUSE_LOG_ERR, "Eventfd_write for queue: %m\n");
>          }
>          ret = pthread_join(ourqi->thread, NULL);
>          if (ret) {
> -- 
> 2.14.4.44.g2045bb6


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Thanks, merged into 'virtiofsd: Kill threads when queues are stopped'

> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

