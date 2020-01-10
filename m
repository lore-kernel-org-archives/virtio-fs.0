Date: Fri, 10 Jan 2020 17:54:43 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200110175443.GN3901@work-vm>
References: <20191218200833.10368-1-msys.mizuma@gmail.com>
	<20191218200833.10368-3-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218200833.10368-3-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofsd: add some options to the man
 page
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

* Masayoshi Mizuma (msys.mizuma@gmail.com) wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> Add following options to the man page:
> - flock|no_flock
> - norace
> - posix_lock|no_posix_lock
> - readdirplus|no_readdirplus
> - timeout
> - writeback|no_writeback
> - xattr|no_xattr
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Thanks, I've squashed this one and the next one down into the
 'add man page' commit.

Dave

> ---
>  tools/virtiofsd/virtiofsd.texi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/tools/virtiofsd/virtiofsd.texi b/tools/virtiofsd/virtiofsd.texi
> index eec7fbf4e6..76eb219676 100644
> --- a/tools/virtiofsd/virtiofsd.texi
> +++ b/tools/virtiofsd/virtiofsd.texi
> @@ -34,12 +34,34 @@ Print version.
>  Enable debug output.
>  @item --syslog
>  Print log messages to syslog instead of stderr.
> +@item -o flock|no_flock
> +enable/disable flock.
> +The default is @var{no_flock}.
>  @item -o log_level=@var{level}
>  Print only log messages matching @var{level} or more severe.  @var{level} is
>  one of @code{err}, @code{warn}, @code{info}, or @code{debug}.  The default is
>  @var{info}.
> +@item -o norace
> +Disable racy fallback.
> +The default is false.
> +@item -o posix_lock|no_posix_lock
> +Enable/Disable remote posix lock.
> +The default is @var{posix_lock}.
> +@item -o readdirplus|no_readdirplus
> +Enable/Disable readdirplus.
> +The default is @var{readdirplus}
>  @item -o source=@var{path}
>  Share host directory tree located at @var{path}.  This option is required.
> +@item -o timeout=<number>
> +I/O timeout (second).
> +The default depends on cache= option.
> +@item -o writeback|no_writeback
> +Enable/Disable writeback cache. The cache alows the FUSE client
> +to buffer and merge write requests.
> +The default is @var{no_writeback}.
> +@item -o xattr|no_xattr
> +Enable/Disable Extended attributes (xattr) of the files and directories.
> +The default is @var{no_xattr}.
>  @item --socket-path=@var{path}, -o vhost_user_socket=@var{path}
>  Listen on vhost-user UNIX domain socket at @var{path}.
>  @item --fd=@var{fdnum}
> -- 
> 2.18.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

