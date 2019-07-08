Date: Mon, 8 Jul 2019 19:42:39 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190708184239.GP2746@work-vm>
References: <20190703203234.GB5499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703203234.GB5499@redhat.com>
Subject: Re: [Virtio-fs] [PATCH][virtio-fs-dev] virtiofsd: Fix
 fuse_reply_create() to determine correct length of buffer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Hi Dave,
> 
> Following patch needs to be applied on virtio-fs-dev branch to make it
> work with latest kernel. Otherwise file creation reply returns error.
> 
> Thanks
> Vivek
> 
> Put conditional express in brackets. Otherwise expression being evaluated
> becomes (entrysize + sizeof(struct fuse_open_out) + shared) instead and
> which obviously results in wrong size calculation.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Ouch, that's a nasty one to find; thanks!

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/fuse_lowlevel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: qemu/contrib/virtiofsd/fuse_lowlevel.c
> ===================================================================
> --- qemu.orig/contrib/virtiofsd/fuse_lowlevel.c	2019-07-01 13:22:55.489623969 -0400
> +++ qemu/contrib/virtiofsd/fuse_lowlevel.c	2019-07-01 13:23:56.338143585 -0400
> @@ -413,7 +413,7 @@ int fuse_reply_create(fuse_req_t req, co
>  	ever->version_index = e->version_offset;
>  	return send_reply_ok(req, buf,
>  			     entrysize + sizeof(struct fuse_open_out) +
> -                             shared ? sizeof(struct fuse_entryver_out) : 0);
> +                             (shared ? sizeof(struct fuse_entryver_out) : 0));
>  }
>  
>  int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

