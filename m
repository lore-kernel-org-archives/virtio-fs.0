Date: Thu, 6 May 2021 16:56:07 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJQRl32bpCMUXsxd@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 01/26] virtiofs: Fixup printf args
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

* Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Fixup some fuse_log printf args for 32bit compatibility.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

queued this 1/26 only

> ---
>  tools/virtiofsd/passthrough_ll.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 1553d2ef45..110f85a701 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2011,10 +2011,10 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>  
>      fuse_log(FUSE_LOG_DEBUG,
>               "lo_getlk(ino=%" PRIu64 ", flags=%d)"
> -             " owner=0x%lx, l_type=%d l_start=0x%lx"
> -             " l_len=0x%lx\n",
> -             ino, fi->flags, fi->lock_owner, lock->l_type, lock->l_start,
> -             lock->l_len);
> +             " owner=0x%" PRIx64 ", l_type=%d l_start=0x%" PRIx64
> +             " l_len=0x%" PRIx64 "\n",
> +             ino, fi->flags, fi->lock_owner, lock->l_type,
> +             (uint64_t)lock->l_start, (uint64_t)lock->l_len);
>  
>      if (!lo->posix_lock) {
>          fuse_reply_err(req, ENOSYS);
> @@ -2061,10 +2061,10 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>  
>      fuse_log(FUSE_LOG_DEBUG,
>               "lo_setlk(ino=%" PRIu64 ", flags=%d)"
> -             " cmd=%d pid=%d owner=0x%lx sleep=%d l_whence=%d"
> -             " l_start=0x%lx l_len=0x%lx\n",
> +             " cmd=%d pid=%d owner=0x%" PRIx64 " sleep=%d l_whence=%d"
> +             " l_start=0x%" PRIx64 " l_len=0x%" PRIx64 "\n",
>               ino, fi->flags, lock->l_type, lock->l_pid, fi->lock_owner, sleep,
> -             lock->l_whence, lock->l_start, lock->l_len);
> +             lock->l_whence, (uint64_t)lock->l_start, (uint64_t)lock->l_len);
>  
>      if (!lo->posix_lock) {
>          fuse_reply_err(req, ENOSYS);
> @@ -3097,9 +3097,10 @@ static void lo_copy_file_range(fuse_req_t req, fuse_ino_t ino_in, off_t off_in,
>  
>      fuse_log(FUSE_LOG_DEBUG,
>               "lo_copy_file_range(ino=%" PRIu64 "/fd=%d, "
> -             "off=%lu, ino=%" PRIu64 "/fd=%d, "
> -             "off=%lu, size=%zd, flags=0x%x)\n",
> -             ino_in, in_fd, off_in, ino_out, out_fd, off_out, len, flags);
> +             "off=%ju, ino=%" PRIu64 "/fd=%d, "
> +             "off=%ju, size=%zd, flags=0x%x)\n",
> +             ino_in, in_fd, (intmax_t)off_in,
> +             ino_out, out_fd, (intmax_t)off_out, len, flags);
>  
>      res = copy_file_range(in_fd, &off_in, out_fd, &off_out, len, flags);
>      if (res < 0) {
> -- 
> 2.31.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

