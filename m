References: <1575536486-24134-1-git-send-email-catherine.hecx@gmail.com>
From: Peng Tao <tao.peng@linux.alibaba.com>
Message-ID: <3d26d626-de27-214b-2093-1dd850b632b6@linux.alibaba.com>
Date: Thu, 5 Dec 2019 17:19:00 +0800
MIME-Version: 1.0
In-Reply-To: <1575536486-24134-1-git-send-email-catherine.hecx@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix double
 fuse_mbuf_iter_advance when do_removemapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Catherine Ho <catherine.hecx@gmail.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com

On 2019/12/5 17:01, Catherine Ho wrote:
> Commit 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support
> multiple entries") forgot to remove one fuse_mbuf_iter_advance in
> do_removemapping.
No, we do need to advance twice. One for fuse_removemapping_in, another 
for an array of fuse_removemapping_one.

> 
> Without this patch, virtiofsd will report:
> [ID: 00000123] do_removemapping: invalid in, expected 1 * 16, has 60 - 60
> [ID: 00000123]    unique: 232, error: -22 (Invalid argument), outsize: 16
> 
What kernel version are you using? It appears that the remove mapping 
request does not container a proper fuse_removemapping_one struct.

> Fixes: 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support multiple entries")
> Cc: Peng Tao <tao.peng@linux.alibaba.com>
> Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> ---
>   contrib/virtiofsd/fuse_lowlevel.c | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index bde66c72c3..752e7d97b9 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -1894,14 +1894,6 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
>   		return;
>   	}
>   
> -	one = fuse_mbuf_iter_advance(iter, sizeof(*one));
> -	if (!one) {
> -		fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
> -			 arg->count, sizeof(*one), iter->size, iter->pos);
> -		fuse_reply_err(req, EINVAL);
> -		return;
> -	}
> -
>   	if (req->se->op.removemapping)
>   		req->se->op.removemapping(req, req->se, nodeid, arg->count, one);
The patch is wrong itself, as `one` is not assigned here.

Cheers,
Tao

-- 
Into something rich and strange.


