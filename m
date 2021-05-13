References: <20210511213736.281016-1-vgoyal@redhat.com>
	<20210511213736.281016-8-vgoyal@redhat.com>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <5ad6f5e9-0a12-54ce-163a-532f916cc8e8@redhat.com>
Date: Thu, 13 May 2021 15:50:13 -0500
MIME-Version: 1.0
In-Reply-To: <20210511213736.281016-8-vgoyal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 7/7] virtiofsd: Set req->reply_sent right
 after sending reply
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com

On 5/11/21 4:37 PM, Vivek Goyal wrote:
> There is no reason to set it in label "err". We should be able to set
> it right after sending reply. It is easier to read.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index aa53808ef9..b1767dd5b9 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -446,12 +446,9 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>      vu_queue_notify(dev, q);
>      pthread_mutex_unlock(&qi->vq_lock);
>      vu_dispatch_unlock(qi->virtio_dev);
> +    req->reply_sent = true;
>  
>  err:

Just a really minor comment: after all these changes, I would venture
that "out" is a more appropriate label name than "err" at this point.

> -    if (ret == 0) {
> -        req->reply_sent = true;
> -    }
> -
>      return ret;
>  }
>  
> 

