Date: Mon, 18 May 2020 11:45:26 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200518104526.GC2786@work-vm>
References: <VI1PR03MB438360F20BFF32EC2AE5ACCEA6BF0@VI1PR03MB4383.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR03MB438360F20BFF32EC2AE5ACCEA6BF0@VI1PR03MB4383.eurprd03.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] Fix file descriptor passed for setupmapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fotis Xenakis <foxen@windowslive.com>
Cc: virtio-fs@redhat.com

* Fotis Xenakis (foxen@windowslive.com) wrote:
> Currently, during FUSE_SETUPMAPPING, virtiofsd passes the wrong file
> descriptor for the file to mmap() to QEMU (specifically, it passes the
> file handle as requested from the guest).
> 
> This fixes it, using lo_fi_fd() to map the file handle to the right file
> descriptor on the host.
> 
> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>

Thanks!  I've merged this into:
  'DAX: virtiofsd: Make setupmapping work only with inode'

This was a fixup/merging problem - the fd indirection/hiding was done
after the setupmapping; but then the fd indirection got merged first and
the setupmapping put back on top.

Dave

> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index e09d557d74..44bb24eb5e 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2709,7 +2709,7 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
>      msg.flags[0] = vhu_flags;
>  
>      if (fi) {
> -        fd = fi->fh;
> +        fd = lo_fi_fd(req, fi);
>      } else {
>          res = asprintf(&buf, "%i", lo_fd(req, ino));
>          if (res == -1) {
> -- 
> 2.26.2
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

