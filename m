Date: Thu, 2 Jan 2020 12:50:35 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20200102045035.GC41863@e18g06458.et15sqa>
References: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com

On Thu, Jan 02, 2020 at 11:53:12AM +0800, Xiao Yang wrote:
> lo_copy_file_range() passes -errno to fuse_reply_err() and then fuse_reply_err()
> changes it to errno again, so that subsequent fuse_send_reply_iov_nofree() catches
> the wrong errno.(i.e. reports "fuse: bad error value: ...").
> 
> Make fuse_send_reply_iov_nofree() accept the correct -errno by passing errno
> directly in lo_copy_file_range().
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@linux.alibaba.com>

I also went through the other fuse_reply_err() calls and they all pass
positive error number to the second arg.

Thanks,
Eryu

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


