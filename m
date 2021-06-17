Date: Thu, 17 Jun 2021 15:29:12 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YMtcOMVdVJAjCg8I@work-vm>
References: <20210617141518.304659-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617141518.304659-1-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't allow file creation with
	FUSE_OPEN
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

* Greg Kurz (groug@kaod.org) wrote:
> A well behaved FUSE client uses FUSE_CREATE to create files. It isn't
> supposed to pass O_CREAT along a FUSE_OPEN request, as documented in
> the "fuse_lowlevel.h" header :
> 
>     /**
>      * Open a file
>      *
>      * Open flags are available in fi->flags. The following rules
>      * apply.
>      *
>      *  - Creation (O_CREAT, O_EXCL, O_NOCTTY) flags will be
>      *    filtered out / handled by the kernel.
> 
> But if it does anyway, virtiofsd crashes with:
> 
> *** invalid openat64 call: O_CREAT or O_TMPFILE without mode ***: terminated
> 
> This is because virtiofsd ends up passing this flag to openat() without
> passing a mode_t 4th argument which is mandatory with O_CREAT, and glibc
> aborts.
> 
> The offending path is:
> 
> lo_open()
>     lo_do_open()
>         lo_inode_open()
> 
> Other callers of lo_inode_open() only pass O_RDWR and lo_create()
> passes a valid fd to lo_do_open() which thus doesn't even call
> lo_inode_open() in this case.
> 
> Specifying O_CREAT with FUSE_OPEN is a protocol violation. Check this
> in lo_open() and return an error to the client : EINVAL since this is
> already what glibc returns with other illegal flag combinations.
> 
> The FUSE filesystem doesn't currently support O_TMPFILE, but the very
> same would happen if O_TMPFILE was passed in a FUSE_OPEN request. Check
> that as well.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

That seems reasonable, so

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

should you also send a corresponding patch for libfuse's example code
we're based on?

Dave

> ---
>  tools/virtiofsd/passthrough_ll.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 49c21fd85570..14f62133131c 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2145,6 +2145,12 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>          return;
>      }
>  
> +    /* File creation is handled by lo_create() */
> +    if (fi->flags & (O_CREAT | O_TMPFILE)) {
> +        fuse_reply_err(req, EINVAL);
> +        return;
> +    }
> +
>      err = lo_do_open(lo, inode, -1, fi);
>      lo_inode_put(lo, &inode);
>      if (err) {
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

