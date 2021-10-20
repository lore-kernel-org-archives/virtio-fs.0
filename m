Date: Wed, 20 Oct 2021 13:55:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXBYIU7lC5Hi6pog@redhat.com>
References: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
	<20211011030938.109206-7-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011030938.109206-7-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [virtiofsd PATCH v6 6/6] virtiofsd: implement
 persistent inode attribute based dax policy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Mon, Oct 11, 2021 at 11:09:38AM +0800, Jeffle Xu wrote:
> The per-file DAX feature in ext4/xfs uses the persistent inode
> attribute, i.e. FS_DAX_FL/FS_XFLAG_DAX, to indicate if DAX shall be
> enable for this file or not when filesystem is mounted in per-file DAX
> mode.
> 
> To keep compatible with this feature in ext4/xfs, virtiofs also supports
> enabling DAX depending on the persistent inode attribute, which may be
> set/cleared by users inside guest or admin on host.
> 
> This policy is used when '-o dax=attr' option is specified for
> virtiofsd.

I guess keep this patch higher up in the patch series as we want to make
sure this behavior works first. And then implement server specific policy.
Just a minor nit. 

Once you post new patch series with kernel changes, I will spend some time
testing these patches.

Vivek
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index a5a5061906..6f75cd6d92 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1000,7 +1000,7 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>      return 0;
>  }
>  
> -static bool lo_should_enable_dax(struct lo_data *lo,
> +static bool lo_should_enable_dax(struct lo_data *lo, struct lo_inode *inode,
>                                   struct fuse_entry_param *e)
>  {
>      if (lo->dax == DAX_NONE || !S_ISREG(e->attr.st_mode)) {
> @@ -1011,6 +1011,24 @@ static bool lo_should_enable_dax(struct lo_data *lo,
>          return e->attr.st_size > FUSE_PERFILE_DAX_POINT;
>      }
>  
> +    if (lo->dax & DAX_ATTR) {
> +        int res, fd;
> +        int ret = false;;
> +        unsigned int attr;
> +
> +        fd = lo_inode_open(lo, inode, O_RDONLY);
> +        if (fd == -1) {
> +            return false;
> +        }
> +
> +        res = ioctl(fd, FS_IOC_GETFLAGS, &attr);
> +        if (!res && (attr & FS_DAX_FL))
> +            ret = true;
> +
> +        close(fd);
> +        return ret;
> +    }
> +
>      return false;
>  }
>  
> @@ -1104,7 +1122,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      }
>      e->ino = inode->fuse_ino;
>  
> -    if (lo_should_enable_dax(lo, e)) {
> +    if (lo_should_enable_dax(lo, inode, e)) {
>          e->attr_flags |= FUSE_ATTR_DAX;
>      }
>  
> -- 
> 2.27.0
> 

