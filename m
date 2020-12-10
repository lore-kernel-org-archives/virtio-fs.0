Date: Thu, 10 Dec 2020 20:03:03 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201210200303.GN3629@work-vm>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207183021.22752-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofsd: Check file type in lo_flush()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Currently lo_flush() is written in such a way that it expects to receive
> a FLUSH requests on a regular file (and not directories). For example,
> we call lo_fi_fd() which searches lo->fd_map. If we open directories
> using opendir(), we keep don't keep track of these in lo->fd_map instead
> we keep them in lo->dir_map. So we expect lo_flush() to be called on
> regular files only.
> 
> Even linux fuse client calls FLUSH only for regular files and not
> directories. So put a check for filetype and return EBADF if
> lo_flush() is called on a non-regular file.
> 
> Reported-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 8ba79f503a..48a109d3f6 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -1968,7 +1968,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      struct lo_data *lo = lo_data(req);
>  
>      inode = lo_inode(req, ino);
> -    if (!inode) {
> +    if (!inode || !S_ISREG(inode->filetype)) {
>          fuse_reply_err(req, EBADF);

Does that need a lo_inode_put(lo, &inode) in the new case?

Dave

>          return;
>      }
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

