DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=106a9+JMppwXyNEse7e2T7leKITfT4y62/qDA5OK7Pg=;
	b=L6q8TkHsJmI12S1coL8P1tTfUJPPxAHJzfzuZbMWNWs4fOYNGehB7h7z2yTj0i1NDT
	9/WGWNwp9zFeSRoYUUPXwBHACgrSA9ma8ohaLyXro7q8uN407cEImjWVJbyj12OwsBRg
	2nJgUrCzFvtOOPYbe5ULUaQI8Jqot42og8zyu8dyrLFGVBSnKnk98KUcSU0ZApaLeT36
	YoPYiIFtVn314fo2GIQG7X9K1Hf5yQxAqBzlfo2s+WlEYA4glkpZSRs+FPJ9+keaucHT
	nto28bhrc1q9yMyJ1Gvjyyd8vc+/ncbnb9OURy3LGisJVR+Fko/i9XzklYzC0sRMQIe0
	17OQ==
MIME-Version: 1.0
References: <1557208720-44561-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1557208720-44561-1-git-send-email-bo.liu@linux.alibaba.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Tue, 7 May 2019 16:06:41 +0800
Message-ID: <CACGKRzX2UwYRYmFiAmoLf0Fo9=6kGN6vjKocVL8qxoOW2eJBDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: do fallocate for setupmapping
 requests with write flag
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

On Tue, May 7, 2019 at 1:58 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> We'll have to make sure filesystem has allocated space for the dax
> mapping, otherwise, guest writes from virtiofs may hang since write
> page fault is not able to be resolved if host fs is full
> (->page_mkwrite() return -ENOSPC).
>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Peng Tao <bergwolf@hyper.sh>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index f14f471..1ddb68f 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1897,12 +1897,28 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
>
>         }
>
> +        if (flags & O_WRONLY) {
> +                /* this may allocate more space than we need. */
> +                ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, foffset, len);
> +                if (ret < 0) {
> +                        ret = errno;
> +                        fprintf(stderr, "%s: fallocate fail (ino=%" PRId64 "fd=%d foffset=0x%" PRIx64 ")\n",
> +                                __func__, ino, fi ? (int)fi->fh : lo_fd(req, ino), foffset);
> +                        goto err;
> +                }
> +
> +                if (lo_debug(req))
> +                        fprintf(stderr, "fallocate (foffset=%" PRIx64 "moffset=%" PRIx64 ")\n",
> +                                foffset, moffset);
> +        }
> +
>          if (fuse_virtio_map(req, &msg, fd)) {
>                  fprintf(stderr, "%s: map over virtio failed (ino=%" PRId64 "fd=%d moffset=0x%" PRIx64 ")\n",
>                          __func__, ino, fi ? (int)fi->fh : lo_fd(req, ino), moffset);
>                  ret = EINVAL;
>          }
>
> +err:
>         if (!fi)
>                 close(fd);
>         fuse_reply_err(req, ret);
> --
> 1.8.3.1
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs



-- 
bergwolf@hyper.sh

