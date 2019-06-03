Date: Mon, 3 Jun 2019 15:24:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190603192422.GC18585@redhat.com>
References: <20190603024651.47305-1-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603024651.47305-1-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH-v2] virtiofs: FUSE_REMOVEMAPPING remove
 multiple entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com


[..]
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5042e227e8a8..b588a028f099 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -850,10 +850,17 @@ struct fuse_setupmapping_out {
>  struct fuse_removemapping_in {
>          /* An already open handle */
>          uint64_t	fh;

So this range reclaim is per inode. I am wondering if there is any
merit in making this message even more generic. That is, message
will allow you to send ranges from different files/fh. That is
make fh parameter part of fuse_removemapping_one instead.

In theory this can be helpful when we are trying to free memory. Instead
of freeing one range, we could free multiple ranges in one go. That too
these could belong to different files. 

What I am not sure is whether we can come up with deadlock free way 
of locking all the inodes or not.

One option can be that move fh parameter in fuse_removemapping_one and
keep that flexibility of specifying ranges belonging to different files.

Even if we don't end up using it, it might not hurt much.

Thanks
Vivek

> +	/* number of fuse_removemapping_one follows */
> +	uint32_t	count;
> +};
> +
> +struct fuse_removemapping_one {
>  	/* Offset into the dax window start the unmapping */
>  	uint64_t        moffset;
>          /* Length of mapping required */
>          uint64_t	len;
>  };

> +#define FUSE_REMOVEMAPPING_MAX_ENTRY	\
> +		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
>  
>  #endif /* _LINUX_FUSE_H */
> -- 
> 2.17.1
> 

