Date: Tue, 25 Jun 2019 19:42:43 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190625184243.GO3226@work-vm>
References: <1561413227-114711-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561413227-114711-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] Virtiofsd: fix memory leak on fuse queueinfo
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> For fuse's queueinfo, both queueinfo array and queueinfos are allocated in
> fv_queue_set_started() but not cleaned up when the daemon process quits.
> 
> This fixes the leak in proper places.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/fuse_virtio.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> index bec4105..aa94b66 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -763,6 +763,8 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>                  }
>                  close(ourqi->kill_fd);
>                  ourqi->kick_fd = -1;
> +                free(vud->qi[qidx]);
> +                vud->qi[qidx] = NULL;
>          }
>  }
>  
> @@ -889,6 +891,7 @@ int virtio_session_mount(struct fuse_session *se)
>  void virtio_session_close(struct fuse_session *se)
>  {
>          close(se->vu_socketfd);
> +        free(se->virtio_dev->qi);
>          free(se->virtio_dev);
>          se->virtio_dev = NULL;
>  }
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

