Date: Tue, 14 Jan 2020 12:14:57 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200114121457.GG2812@work-vm>
References: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] vitriofsd/passthrough_ll: Make
 fallocate() work
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com

* Xiao Yang (yangx.jy@cn.fujitsu.com) wrote:
> 1) Use correct CONFIG_FALLOCATE macro to check if fallocate() is supported.(i.e configure
>    script sets CONFIG_FALLOCATE intead of HAVE_FALLOCATE if fallocate() is supported)
> 2) Avoid 'Bad file descriptor' error by passing correct fd to fallocate().
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 42a3e182f9..a19823caaf 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2313,8 +2313,8 @@ static void lo_fallocate(fuse_req_t req, fuse_ino_t ino, int mode, off_t offset,
>      struct lo_data *lo = lo_data(req);
>      (void)ino;
>  
> -#ifdef HAVE_FALLOCATE
> -    err = fallocate(fi->fh, mode, offset, length);
> +#ifdef CONFIG_FALLOCATE
> +    err = fallocate(lo_fi_fd(req, fi), mode, offset, length);

Thanks; I've merged the fh fix into Stefan's 'add fd_map to hide file
descriptors'
patch.

I'll merge the ifdef fix with your next fix and take it as a separate 
patch.

Dave

>      if (err < 0) {
>          err = errno;
>      }
> -- 
> 2.21.0
> 
> 
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

