Date: Thu, 27 Jan 2022 19:50:09 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YfL3cXaerCHrNRA7@work-vm>
References: <20220124212455.83968-1-vgoyal@redhat.com>
	<20220124212455.83968-7-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220124212455.83968-7-vgoyal@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4 6/9] virtiofsd: Move core file creation
 code in separate function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Move core file creation bits in a separate function. Soon this is going
> to get more complex as file creation need to set security context also.
> And there will be multiple modes of file creation in next patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 36 ++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 64b5b4fbb1..54978b7fae 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1976,6 +1976,30 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>      return 0;
>  }
>  
> +static int do_lo_create(fuse_req_t req, struct lo_inode *parent_inode,
> +                        const char *name, mode_t mode,
> +                        struct fuse_file_info *fi, int* open_fd)
> +{
> +    int err = 0, fd;
> +    struct lo_cred old = {};
> +    struct lo_data *lo = lo_data(req);
> +
> +    err = lo_change_cred(req, &old, lo->change_umask);
> +    if (err) {
> +        return err;
> +    }
> +
> +    /* Try to create a new file but don't open existing files */
> +    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
> +    if (fd == -1) {
> +        err = errno;
> +    } else {
> +        *open_fd = fd;
> +    }
> +    lo_restore_cred(&old, lo->change_umask);
> +    return err;
> +}
> +
>  static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>                        mode_t mode, struct fuse_file_info *fi)
>  {
> @@ -1985,7 +2009,6 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>      struct lo_inode *inode = NULL;
>      struct fuse_entry_param e;
>      int err;
> -    struct lo_cred old = {};
>  
>      fuse_log(FUSE_LOG_DEBUG, "lo_create(parent=%" PRIu64 ", name=%s)"
>               " kill_priv=%d\n", parent, name, fi->kill_priv);
> @@ -2001,18 +2024,9 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>          return;
>      }
>  
> -    err = lo_change_cred(req, &old, lo->change_umask);
> -    if (err) {
> -        goto out;
> -    }
> -
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>  
> -    /* Try to create a new file but don't open existing files */
> -    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
> -    err = fd == -1 ? errno : 0;
> -
> -    lo_restore_cred(&old, lo->change_umask);
> +    err = do_lo_create(req, parent_inode, name, mode, fi, &fd);
>  
>      /* Ignore the error if file exists and O_EXCL was not given */
>      if (err && (err != EEXIST || (fi->flags & O_EXCL))) {
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

