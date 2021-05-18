Date: Tue, 18 May 2021 12:59:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKOsI4PH3xdza8gZ@work-vm>
References: <20210511213736.281016-1-vgoyal@redhat.com>
	<20210511213736.281016-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511213736.281016-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/7] virtiofsd: Check for EINTR in preadv()
	and retry
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
> We don't seem to check for EINTR and retry. There are other places
> in code where we check for EINTR. So lets add a check.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_virtio.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 1170f375a5..32914f7e95 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -421,6 +421,9 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>  
>          if (ret == -1) {
>              ret = errno;
> +            if (ret == EINTR) {
> +                continue;
> +            }
>              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m) len=%zd\n",
>                       __func__, len);
>              goto err;
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

