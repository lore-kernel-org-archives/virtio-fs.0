Date: Fri, 20 Mar 2020 20:16:15 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200320201615.GI3464@work-vm>
References: <1584729254-123546-1-git-send-email-bo.liu@linux.alibaba.com>
	<1584729254-123546-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584729254-123546-2-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/2] virtiofsd: fix mmap write under
 nondax mode
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
> When a file size is not aligned to PAGE_SIZE, a mmap write on it may
> encounter -EIO (can be observed from virtiofsd's log) due to the difference
> between the buf size and the size recorded in struct fuse_write_in.  The
> difference comes from the fact that for mmap, writeback IO is used and
> guest kernel sets fuse_write_in's size to inode size if EOF, while the buf
> len still remains PAGE_SIZE aligned.
> 
> This handles the above special mmap case by truncating the last buf'size.

Thanks,

> Fixes: Commit 469f9d2f ("virtiofsd: Plumb fuse_bufvec through do_write_buf")
> Reported-by: Yiqun Leng <yqleng@linux.alibaba.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index ca2056f..4f8bfb6 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -1221,6 +1221,23 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
>           * and the data in the rest, we need to skip that first element
>           */
>          ibufv->buf[0].size = 0;
> +
> +        /*
> +         * In case of mmap, fuse_buf_size(pbufv) may need to truncate if
> +         * arg->size has been cropped by inode size inside guest.  The
> +         * diff can only be (0, PAGE_SIZE) because inode size must be
> +         * overlapped with the last buf.
> +         */
> +        if (arg->write_flags & FUSE_WRITE_CACHE) {

Does this need to only do it in the WRITE_CACHE case - or should we just
always truncate the write to arg->size?
Or is this just simpler?

> +                size_t total = fuse_buf_size(pbufv);
> +                int last = ibufv->count - 1;
> +
> +                if (total > arg->size) {
> +                        size_t diff = total - arg->size;
> +                        if (diff < ibufv->buf[last].size)
> +                                ibufv->buf[last].size -= diff;

I think that needs to modify pbufv->buf[last].size not ibufv
because the two are only the same in some cases (although it's possible
in this case the guest we try at the moment always falls in this side).

We should also do something in the else case - probably fail?

> +                }
> +        }
>      }
>  
>      if (fuse_buf_size(pbufv) != arg->size) {

If we now know that pbufv is now always shrung to size,
then we only now need to check for the case where pbufv is too small.

Dave

> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

