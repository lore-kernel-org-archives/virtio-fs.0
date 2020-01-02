Date: Thu, 2 Jan 2020 18:55:40 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200102185540.GL2927@work-vm>
References: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Pass errno to
 fuse_reply_err()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>, ndevos@redhat.com
Cc: virtio-fs@redhat.com

* Xiao Yang (yangx.jy@cn.fujitsu.com) wrote:
> lo_copy_file_range() passes -errno to fuse_reply_err() and then fuse_reply_err()
> changes it to errno again, so that subsequent fuse_send_reply_iov_nofree() catches
> the wrong errno.(i.e. reports "fuse: bad error value: ...").
> 
> Make fuse_send_reply_iov_nofree() accept the correct -errno by passing errno
> directly in lo_copy_file_range().
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Yes, I think you're right - FUSE does use +ve errno's for some things,
normally the failure of the fuse channel itself; but in this case it
looks like 'errno' is consistent with the other calls; this comes
straight from upstream libfuse commit 2548c4b8, so lets cc in Niels.

I'll take it into virtiofsd for the moment; thanks!

Dave

> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 83dd0084b4..a77bed655e 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2615,7 +2615,7 @@ static void lo_copy_file_range(fuse_req_t req, fuse_ino_t ino_in, off_t off_in,
>  
>      res = copy_file_range(in_fd, &off_in, out_fd, &off_out, len, flags);
>      if (res < 0) {
> -        fuse_reply_err(req, -errno);
> +        fuse_reply_err(req, errno);
>      } else {
>          fuse_reply_write(req, res);
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

