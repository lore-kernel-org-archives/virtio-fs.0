Date: Fri, 14 Jun 2019 19:58:25 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190614185825.GM2785@work-vm>
References: <1560534980-37259-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560534980-37259-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix typo in error message in
	fv_queue_thread
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
> It's misleading that pf[0].revents is printed when there is something
> wrong with pf[1].revents.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Ah well spotted; that's a copy-paste problem on my half.

For this, I've just fixed up the original patch.

Dave

> ---
>  contrib/virtiofsd/fuse_virtio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> index ed6ba57..bec4105 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -472,7 +472,7 @@ static void *fv_queue_thread(void *opaque)
>                 }
>                 if (pf[1].revents & (POLLERR | POLLHUP | POLLNVAL)) {
>                         fprintf(stderr, "%s: Unexpected poll revents %x Queue %d killfd\n",
> -                                __func__, pf[0].revents, qi->qidx);
> +                                __func__, pf[1].revents, qi->qidx);
>                         break;
>                 }
>                 if (pf[1].revents) {
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

