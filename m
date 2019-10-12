DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=+FrUC66hBMWPncut2Shl80U8fQ0hJ+GFsb37ZtZ2jlk=;
	b=P5dSwqRHVOVUbA546m2ofsVN6fSI2g0WmfIfGEkQNMBQuur/5Iky9CPcvjtH72FjHH
	6tgNQOLRJuj6jwfIJb2F1iDHzCIi2TJlF+hBVDknp6bKpWAtw7/IohK5zzRCOld7vM4S
	sQpYrO7OLRAfpzecYK4lL/GYg6TJUE2Es5OsjHwxi+Q8DD/aR73iQBNCoC/IKWUxuqqA
	mDI9r2FhdP4hp4MuDwizSNqOWSmkvYavH9vn6X0wd5tP/LU+AAQF8k5EU4CT9fd0yGbR
	ZcmQ05IN/2RrWSeaU7YuDU54afvwWW5rO3WlZLnRiJQmw4AZbdXUq+p91Vvvx5LdjtY6
	MD9w==
Date: Fri, 11 Oct 2019 21:50:41 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20191012015040.rqb6buo5snmxmq74@gabell>
References: <20191011181826.GA13861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011181826.GA13861@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtio_fs: Change module name to virtiofs.ko
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>

Hi Vivek,

On Fri, Oct 11, 2019 at 02:18:26PM -0400, Vivek Goyal wrote:
> We have been calling it virtio_fs and even file name is virtio_fs.c. Module
> name is virtio_fs.ko but when registering file system user is supposed to
> specify filesystem type as "virtiofs".
> 
> Masayoshi Mizuma reported that he specified filesytem type as "virtio_fs" and
> got this warning on console.
> 
>   ------------[ cut here ]------------
>   request_module fs-virtio_fs succeeded, but still no fs?
>   WARNING: CPU: 1 PID: 1234 at fs/filesystems.c:274 get_fs_type+0x12c/0x138
>   Modules linked in: ... virtio_fs fuse virtio_net net_failover ...
>   CPU: 1 PID: 1234 Comm: mount Not tainted 5.4.0-rc1 #1
> 
> So looks like kernel could find the module virtio_fs.ko but could not find
> filesystem type after that.
> 
> It probably is better to rename module name to virtiofs.ko so that above
> warning goes away in case user ends up specifying wrong fs name.

The warning is gone after applied this patch, thanks!
Please feel free to add:

    Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

- Masa

> 
> Reported-by: Masayoshi Mizuma <msys.mizuma@gmail.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/Makefile |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: rhvgoyal-linux/fs/fuse/Makefile
> ===================================================================
> --- rhvgoyal-linux.orig/fs/fuse/Makefile	2019-10-11 13:53:43.905757435 -0400
> +++ rhvgoyal-linux/fs/fuse/Makefile	2019-10-11 13:54:24.147757435 -0400
> @@ -5,6 +5,7 @@
>  
>  obj-$(CONFIG_FUSE_FS) += fuse.o
>  obj-$(CONFIG_CUSE) += cuse.o
> -obj-$(CONFIG_VIRTIO_FS) += virtio_fs.o
> +obj-$(CONFIG_VIRTIO_FS) += virtiofs.o
>  
>  fuse-objs := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o
> +virtiofs-y += virtio_fs.o

