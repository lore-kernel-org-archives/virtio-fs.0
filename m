Date: Mon, 29 Jul 2019 12:15:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190729111502.GE2756@work-vm>
References: <20190726155837.29155-1-vgoyal@redhat.com>
	<20190726155837.29155-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726155837.29155-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: No need to promote O_WRONLY
	to O_RDWR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

* Vivek Goyal (vgoyal@redhat.com) wrote:
> I am not sure why do we still need this logic. mmap() needs file to be
> opened for O_RDONLY atleast. And we open file either as O_RDONLY or
> O_RDWR in lo_setupmapping() depending on if read-only or read-write
> mapping is required.
> 
> So it should not matter how fd is opended during lo_create() or lo_open()
> because we are not going to use that fd anyway for mmap().
> 
> So for now drop this logic. I ran pjdfstests and blogbench and both
> ran successfully.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

So this is just removing your two commits:
988e23c0fb06be2636b4 virtiofsd: Promote O_WRONLY to O_RDWR in lo_create()
7ebaa054e7aba33e1239 virtiofsd: Open O_WRONLY files as O_RDWR

which I've done; and applied your other patch.

Dave


> ---
>  contrib/virtiofsd/passthrough_ll.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index c09c46a7e5..502ce50178 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1513,12 +1513,6 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>  	if (err)
>  		goto out;
>  
> -	/* Promote O_WRONLY to O_RDWR. Otherwise later mmap(PROT_WRITE) fails */
> -	if ((fi->flags & O_ACCMODE) == O_WRONLY) {
> -		fi->flags &= ~O_ACCMODE;
> -		fi->flags |= O_RDWR;
> -	}
> -
>  	fd = openat(lo_fd(req, parent), name,
>  		    (fi->flags | O_CREAT) & ~O_NOFOLLOW, mode);
>  	err = fd == -1 ? errno : 0;
> @@ -1710,12 +1704,6 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  		fuse_debug("lo_open(ino=%" PRIu64 ", flags=%d)\n",
>  			   ino, fi->flags);
>  
> -	/* Promote O_WRONLY to O_RDWR. Otherwise later mmap(PROT_WRITE) fails */
> -	if ((fi->flags & O_ACCMODE) == O_WRONLY) {
> -		fi->flags &= ~O_ACCMODE;
> -		fi->flags |= O_RDWR;
> -	}
> -
>  	/* With writeback cache, kernel may send read requests even
>  	   when userspace opened write-only */
>  	if (lo->writeback && (fi->flags & O_ACCMODE) == O_WRONLY) {
> -- 
> 2.17.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

