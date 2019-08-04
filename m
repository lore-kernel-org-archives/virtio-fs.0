References: <1564810108-34852-1-git-send-email-bo.liu@linux.alibaba.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <537bd738-c4bf-cc8f-67ef-393fc59d8e46@huawei.com>
Date: Sun, 4 Aug 2019 11:15:41 +0800
MIME-Version: 1.0
In-Reply-To: <1564810108-34852-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] Virtiofsd: fix segfault when quit before
 dev init
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>, virtio-fs@redhat.com

Hi liubo and Eric,

This patch looks good to me, and could you help fixing a null pointer
dereference about se->virtio_dev in virtio_session_mount() together?

virtio_session_mount()
- se->virtio_dev = calloc(sizeof(struct fv_VuDev), 1);
- Add a null check after calloc().

Thanks,
Jun

On 2019/8/3 13:28, Liu Bo wrote:
> From: Eric Ren <renzhen@linux.alibaba.com>
> 
> The daemon may bail out early on errors(e.g. in fuse_session_mount), where
> it ends up a segfault error.
> 
> Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> ---
>  contrib/virtiofsd/fuse_virtio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> index aa94b66..6292e87 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -891,6 +891,10 @@ int virtio_session_mount(struct fuse_session *se)
>  void virtio_session_close(struct fuse_session *se)
>  {
>          close(se->vu_socketfd);
> +
> +        if (!se->virtio_dev)
> +                return;
> +
>          free(se->virtio_dev->qi);
>          free(se->virtio_dev);
>          se->virtio_dev = NULL;
> 

