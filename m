Date: Thu, 11 Feb 2021 11:05:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210211160508.GA3259@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-13-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-13-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 12/24] DAX: virtiofsd: Wire up
 passthrough_ll's lo_setupmapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, mst@redhat.com

On Tue, Feb 09, 2021 at 07:02:12PM +0000, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Wire up passthrough_ll's setupmapping to allocate, send to virtio
> and then reply OK.
> 
> Guest might not pass file pointer. In that case using inode info, open
> the file again, mmap() and close fd.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> With fix from:
> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c  | 13 ++++++--
>  tools/virtiofsd/passthrough_ll.c | 52 ++++++++++++++++++++++++++++++--
>  2 files changed, 61 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index 0d3768b7d0..f74583e095 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -1897,8 +1897,17 @@ static void do_setupmapping(fuse_req_t req, fuse_ino_t nodeid,
>      }
>  
>      if (req->se->op.setupmapping) {
> -        req->se->op.setupmapping(req, nodeid, arg->foffset, arg->len,
> -                                 arg->moffset, genflags, &fi);
> +        /*
> +         * TODO: Add a flag to request which tells if arg->fh is
> +         * valid or not.
> +         */
> +        if (fi.fh == (uint64_t)-1) {
> +            req->se->op.setupmapping(req, nodeid, arg->foffset, arg->len,
> +                                     arg->moffset, genflags, NULL);
> +        } else {
> +            req->se->op.setupmapping(req, nodeid, arg->foffset, arg->len,
> +                                     arg->moffset, genflags, &fi);
> +        }
>      } else {
>          fuse_reply_err(req, ENOSYS);
>      }
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 31c43d67a0..0493f00756 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2967,8 +2967,56 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
>                              uint64_t len, uint64_t moffset, uint64_t flags,
>                              struct fuse_file_info *fi)
>  {
> -    /* TODO */
> -    fuse_reply_err(req, ENOSYS);
> +    struct lo_data *lo = lo_data(req);
> +    int ret = 0, fd;
> +    VhostUserFSSlaveMsg msg = { 0 };
> +    uint64_t vhu_flags;
> +    char *buf;
> +    bool writable = flags & O_RDWR;
> +
> +    fuse_log(FUSE_LOG_DEBUG,
> +             "lo_setupmapping(ino=%" PRIu64 ", fi=0x%p,"
> +             " foffset=%" PRIu64 ", len=%" PRIu64 ", moffset=%" PRIu64
> +             ", flags=%" PRIu64 ")\n",
> +             ino, (void *)fi, foffset, len, moffset, flags);
> +
> +    vhu_flags = VHOST_USER_FS_FLAG_MAP_R;
> +    if (writable) {
> +        vhu_flags |= VHOST_USER_FS_FLAG_MAP_W;
> +    }
> +
> +    msg.fd_offset[0] = foffset;
> +    msg.len[0] = len;
> +    msg.c_offset[0] = moffset;
> +    msg.flags[0] = vhu_flags;
> +
> +    if (fi) {
> +        fd = lo_fi_fd(req, fi);
> +    } else {
> +        ret = asprintf(&buf, "%i", lo_fd(req, ino));
> +        if (ret == -1) {
> +            return (void)fuse_reply_err(req, errno);
> +        }
> +
> +        fd = openat(lo->proc_self_fd, buf, flags);
> +        free(buf);

We can probably now use lo_inode_open() instead here now?

Vivek

