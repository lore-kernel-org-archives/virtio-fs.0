Date: Tue, 17 Aug 2021 20:00:22 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YRwHRmL/jUSqgkIU@work-vm>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<20210817022347.18098-1-jefflexu@linux.alibaba.com>
	<20210817022347.18098-5-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210817022347.18098-5-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [virtiofsd PATCH v4 4/4] virtiofsd: support
 per-file DAX in FUSE_LOOKUP
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: miklos@szeredi.hu, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

* Jeffle Xu (jefflexu@linux.alibaba.com) wrote:
> For passthrough, when the corresponding virtiofs in guest is mounted
> with '-o dax=inode', advertise that the file is capable of per-file
> DAX if the inode in the backend fs is marked with FS_DAX_FL flag.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 43 ++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 5b6228210f..4cbd904248 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -171,6 +171,7 @@ struct lo_data {
>      int allow_direct_io;
>      int announce_submounts;
>      int perfile_dax_cap; /* capability of backend fs */
> +    bool perfile_dax; /* enable per-file DAX or not */
>      bool use_statx;
>      struct lo_inode root;
>      GHashTable *inodes; /* protected by lo->mutex */
> @@ -716,6 +717,10 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
>  
>      if (conn->capable & FUSE_CAP_PERFILE_DAX && lo->perfile_dax_cap ) {
>          conn->want |= FUSE_CAP_PERFILE_DAX;
> +	lo->perfile_dax = 1;
> +    }
> +    else {
> +	lo->perfile_dax = 0;
>      }
>  }
>  
> @@ -983,6 +988,41 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>      return 0;
>  }
>  
> +/*
> + * If the file is marked with FS_DAX_FL or FS_XFLAG_DAX, then DAX should be
> + * enabled for this file.
> + */
> +static bool lo_should_enable_dax(struct lo_data *lo, struct lo_inode *dir,
> +				 const char *name)
> +{
> +    int res, fd;
> +    int ret = false;;
> +    unsigned int attr;
> +    struct fsxattr xattr;
> +
> +    if (!lo->perfile_dax)
> +	return false;
> +
> +    /* Open file without O_PATH, so that ioctl can be called. */
> +    fd = openat(dir->fd, name, O_NOFOLLOW);
> +    if (fd == -1)
> +        return false;

Doesn't that defeat the whole benefit of using O_PATH - i.e. that we
might stumble into a /dev node or something else we're not allowed to
open?

> +    if (lo->perfile_dax_cap == DAX_CAP_FLAGS) {
> +        res = ioctl(fd, FS_IOC_GETFLAGS, &attr);
> +        if (!res && (attr & FS_DAX_FL))
> +	    ret = true;
> +    }
> +    else if (lo->perfile_dax_cap == DAX_CAP_XATTR) {
> +	res = ioctl(fd, FS_IOC_FSGETXATTR, &xattr);
> +	if (!res && (xattr.fsx_xflags & FS_XFLAG_DAX))
> +	    ret = true;
> +    }

This all looks pretty expensive for each lookup.

Dave


> +    close(fd);
> +    return ret;
> +}
> +
>  /*
>   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
>   * called eventually to decrement nlookup again. If inodep is non-NULL, the
> @@ -1038,6 +1078,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          e->attr_flags |= FUSE_ATTR_SUBMOUNT;
>      }
>  
> +    if (lo_should_enable_dax(lo, dir, name))
> +	e->attr_flags |= FUSE_ATTR_DAX;
> +
>      inode = lo_find(lo, &e->attr, mnt_id);
>      if (inode) {
>          close(newfd);
> -- 
> 2.27.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

