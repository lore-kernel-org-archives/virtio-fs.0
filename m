DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=4/2fNVDpxxWF/iTBtgbVqnrhn7JsKH269EvQqIiJKuQ=;
	b=to7HgVt8fctmsfQKuMMihCjDiSmcuNtnq0GfeGjR4e3JFb3M5/l2r+effD9DSnM1SU
	6+pB8fh8OyJVrFgyxfTZeH9b+sPsJdLBVayHmgy1bskNiSX6td3H/VEkp5bQ7SLZBxWk
	3sZXzTQilrOWFDX2N3MqrlzHrc92b1KpLH29wN/CQy2mGvxO5rACb9XrqR1/kcPnXHTD
	+5hIzU95/GXJOgpaz3VHtmIcjlZgFcNUQ/9D79TPQ/jTrNeNDEEv6I0smkwjS0/mHLSC
	PsmF1JlS7tj/fiAQvPAE5K7pcbbU/bbQpjGAP3J7GSXQ4hvqvPLAWEQIGa4DSOdFeCHu
	3lcA==
MIME-Version: 1.0
References: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
	<1557208691-43817-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1557208691-43817-2-git-send-email-bo.liu@linux.alibaba.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Tue, 7 May 2019 16:06:15 +0800
Message-ID: <CACGKRzX4fEbf_zX1-OeD83swYKxWzqRoU4DebkYkmc1qDk4Swg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 1/2] virtio-fs: send setupmapping with write
 flag only if IOMAP_WRITE
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
> This is to let virtiofs daemon to do inline fallocate to preallocate
> space for this mapping.
>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Peng Tao <bergwolf@hyper.sh>

> ---
>  fs/fuse/file.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 488e932f..6f403c8 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -251,8 +251,8 @@ static void free_dax_mapping(struct fuse_conn *fc,
>
>  /* offset passed in should be aligned to FUSE_DAX_MEM_RANGE_SZ */
>  static int fuse_setup_one_mapping(struct inode *inode,
> -                               struct file *file, loff_t offset,
> -                               struct fuse_dax_mapping *dmap)
> +                                 struct file *file, loff_t offset, unsigned flags,
> +                                 struct fuse_dax_mapping *dmap)
>  {
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_inode *fi = get_fuse_inode(inode);
> @@ -276,14 +276,21 @@ static int fuse_setup_one_mapping(struct inode *inode,
>                 inarg.fh = -1;
>         inarg.moffset = dmap->window_offset;
>         inarg.len = FUSE_DAX_MEM_RANGE_SZ;
> +
> +       /*
> +       * with IOMAP_WRITE, virtiofs daemon will make sure space is
> +       * allocated for the range.
> +       */
>         if (file) {
> -               inarg.flags |= (file->f_mode & FMODE_WRITE) ?
> -                               FUSE_SETUPMAPPING_FLAG_WRITE : 0;
> +               if (file->f_mode & FMODE_WRITE &&
> +                   flags & IOMAP_WRITE)
> +                       inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
>                 inarg.flags |= (file->f_mode & FMODE_READ) ?
>                                 FUSE_SETUPMAPPING_FLAG_READ : 0;
>         } else {
>                 inarg.flags |= FUSE_SETUPMAPPING_FLAG_READ;
> -               inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
> +               if (flags & IOMAP_WRITE)
> +                       inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
>         }
>         args.in.h.opcode = FUSE_SETUPMAPPING;
>         args.in.h.nodeid = fi->nodeid;
> @@ -1847,8 +1854,8 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
>
>                 /* Setup one mapping */
>                 ret = fuse_setup_one_mapping(inode, NULL,
> -                               ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> -                               alloc_dmap);
> +                                       ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
> +                                            flags, alloc_dmap);
>                 if (ret < 0) {
>                         printk("fuse_setup_one_mapping() failed. err=%d"
>                                 " pos=0x%llx\n", ret, pos);
> --
> 1.8.3.1
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs



-- 
bergwolf@hyper.sh

