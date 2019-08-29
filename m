Date: Thu, 29 Aug 2019 10:36:35 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190829173635.exnopmkotuh5snpa@US-160370MP2.local>
References: <20190829104133.17418-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104133.17418-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add man page
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Aug 29, 2019 at 11:41:33AM +0100, Stefan Hajnoczi wrote:

Looks good to me, thanks for working this out.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
-liubo
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  Makefile                         |  7 +++
>  contrib/virtiofsd/virtiofsd.texi | 85 ++++++++++++++++++++++++++++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 contrib/virtiofsd/virtiofsd.texi
> 
> diff --git a/Makefile b/Makefile
> index a3dfdd6fa8..cc18025753 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -334,6 +334,9 @@ DOCS+=docs/qemu-cpu-models.7
>  ifdef CONFIG_VIRTFS
>  DOCS+=fsdev/virtfs-proxy-helper.1
>  endif
> +ifdef CONFIG_LINUX
> +DOCS+=contrib/virtiofsd/virtiofsd.1
> +endif
>  ifdef CONFIG_TRACE_SYSTEMTAP
>  DOCS+=scripts/qemu-trace-stap.1
>  endif
> @@ -834,6 +837,9 @@ ifdef CONFIG_VIRTFS
>  	$(INSTALL_DIR) "$(DESTDIR)$(mandir)/man1"
>  	$(INSTALL_DATA) fsdev/virtfs-proxy-helper.1 "$(DESTDIR)$(mandir)/man1"
>  endif
> +ifdef CONFIG_LINUX
> +	$(INSTALL_DATA) contrib/virtiofsd.1 "$(DESTDIR)$(mandir)/man1"
> +endif
>  
>  install-datadir:
>  	$(INSTALL_DIR) "$(DESTDIR)$(qemu_datadir)"
> @@ -1018,6 +1024,7 @@ qemu.1: qemu-doc.texi qemu-options.texi qemu-monitor.texi qemu-monitor-info.texi
>  qemu.1: qemu-option-trace.texi
>  qemu-img.1: qemu-img.texi qemu-option-trace.texi qemu-img-cmds.texi
>  fsdev/virtfs-proxy-helper.1: fsdev/virtfs-proxy-helper.texi
> +contrib/virtiofsd/virtiofsd.1: contrib/virtiofsd/virtiofsd.texi
>  qemu-nbd.8: qemu-nbd.texi qemu-option-trace.texi
>  qemu-ga.8: qemu-ga.texi
>  docs/qemu-block-drivers.7: docs/qemu-block-drivers.texi
> diff --git a/contrib/virtiofsd/virtiofsd.texi b/contrib/virtiofsd/virtiofsd.texi
> new file mode 100644
> index 0000000000..eec7fbf4e6
> --- /dev/null
> +++ b/contrib/virtiofsd/virtiofsd.texi
> @@ -0,0 +1,85 @@
> +@example
> +@c man begin SYNOPSIS
> +@command{virtiofsd} [OPTION] @option{--socket-path=}@var{path}|@option{--fd=}@var{fdnum} @option{-o source=}@var{path}
> +@c man end
> +@end example
> +
> +@c man begin DESCRIPTION
> +
> +Share a host directory tree with a guest through a virtio-fs device.  This
> +program is a vhost-user backend that implements the virtio-fs device.  Each
> +virtio-fs device instance requires its own virtiofsd process.
> +
> +This program is designed to work with QEMU's @code{--device vhost-user-fs-pci}
> +but should work with any virtual machine monitor (VMM) that supports
> +vhost-user.  See the EXAMPLES section below.
> +
> +This program must be run as the root user.  Upon startup the program will
> +switch into a new file system namespace with the shared directory tree as its
> +root.  This prevents "file system escapes" due to symlinks and other file
> +system objects that might lead to files outside the shared directory.  The
> +program also sandboxes itself using seccomp(2) to prevent ptrace(2) and other
> +vectors that could allow an attacker to compromise the system after gaining
> +control of the virtiofsd process.
> +
> +@c man end
> +
> +@c man begin OPTIONS
> +@table @option
> +@item -h, --help
> +Print help.
> +@item -V, --version
> +Print version.
> +@item -d, -o debug
> +Enable debug output.
> +@item --syslog
> +Print log messages to syslog instead of stderr.
> +@item -o log_level=@var{level}
> +Print only log messages matching @var{level} or more severe.  @var{level} is
> +one of @code{err}, @code{warn}, @code{info}, or @code{debug}.  The default is
> +@var{info}.
> +@item -o source=@var{path}
> +Share host directory tree located at @var{path}.  This option is required.
> +@item --socket-path=@var{path}, -o vhost_user_socket=@var{path}
> +Listen on vhost-user UNIX domain socket at @var{path}.
> +@item --fd=@var{fdnum}
> +Accept connections from vhost-user UNIX domain socket file descriptor @var{fdnum}.  The file descriptor must already be listening for connections.
> +@item --thread-pool-size=@var{num}
> +Restrict the number of worker threads per request queue to @var{num}.  The default is 64.
> +@item --cache=@code{none}|@code{auto}|@code{always}
> +Select the desired trade-off between coherency and performance.  @code{none}
> +forbids the FUSE client from caching to achieve best coherency at the cost of
> +performance.  @code{auto} acts similar to NFS with a 1 second metadata cache
> +timeout.  @code{always} sets a long cache lifetime at the expense of coherency.
> +@item --writeback
> +Enable writeback cache, allowing the FUSE client to buffer and merge write requests.
> +@end table
> +@c man end
> +
> +@c man begin EXAMPLES
> +Export @code{/var/lib/fs/vm001/} on vhost-user UNIX domain socket @code{/var/run/vm001-vhost-fs.sock}:
> +
> +@example
> +host# virtiofsd --socket-path=/var/run/vm001-vhost-fs.sock -o source=/var/lib/fs/vm001
> +host# qemu-system-x86_64 \
> +    -chardev socket,id=char0,path=/var/run/vm001-vhost-fs.sock \
> +    -device vhost-user-fs-pci,chardev=char0,tag=myfs \
> +    -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
> +    -numa node,memdev=mem \
> +    ...
> +guest# mount -t virtio_fs \
> +    -o default_permissions,allow_other,user_id=0,group_id=0,rootmode=040000,dax \
> +    myfs /mnt
> +@end example
> +@c man end
> +
> +@ignore
> +@setfilename virtiofsd
> +@settitle QEMU virtio-fs shared file system daemon
> +
> +@c man begin AUTHOR
> +Copyright (C) 2019 Red Hat, Inc.
> +This is free software; see the source for copying conditions.  There is NO
> +warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> +@c man end
> +@end ignore
> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

