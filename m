Date: Thu, 22 Aug 2019 19:54:40 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190822185440.GN3277@work-vm>
References: <20190820183746.GF4233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820183746.GF4233@redhat.com>
Subject: Re: [Virtio-fs] [PATCH V2] virtiofsd: Reset O_DIRECT flag during
	file open
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
> If an application wants to do direct IO and opens a file with O_DIRECT
> in guest, that does not necessarily mean that we need to bypass page
> cache on host as well. So reset this flag on host.
> 
> If somebody needs to bypass page cache on host as well (and it is safe to
> do so), we can add a knob in daemon later to control this behavior.
> 
> I check virtio-9p and they do reset O_DIRECT flag.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Merged; thanks


> ---
>  contrib/virtiofsd/passthrough_ll.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: qemu/contrib/virtiofsd/passthrough_ll.c
> ===================================================================
> --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-08-20 09:33:07.900975145 -0400
> +++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-08-20 14:31:39.725781357 -0400
> @@ -1752,6 +1752,13 @@ static void lo_create(fuse_req_t req, fu
>  	if (err)
>  		goto out;
>  
> +	/*
> +	 * O_DIRECT in guest should not necessarily mean bypassing page
> +	 * cache on host as well. If somebody needs that behavior, it
> +	 * probably should be a configuration knob in daemon.
> +	 */
> +	fi->flags &= ~O_DIRECT;
> +
>  	fd = openat(parent_inode->fd, name,
>  		    (fi->flags | O_CREAT) & ~O_NOFOLLOW, mode);
>  	err = fd == -1 ? errno : 0;
> @@ -1967,6 +1974,13 @@ static void lo_open(fuse_req_t req, fuse
>  	if (lo->writeback && (fi->flags & O_APPEND))
>  		fi->flags &= ~O_APPEND;
>  
> +	/*
> +	 * O_DIRECT in guest should not necessarily mean bypassing page
> +	 * cache on host as well. If somebody needs that behavior, it
> +	 * probably should be a configuration knob in daemon.
> +	 */
> +	fi->flags &= ~O_DIRECT;
> +
>  	sprintf(buf, "%i", lo_fd(req, ino));
>  	fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
>  	if (fd == -1)
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

