Date: Mon, 18 Oct 2021 08:52:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YW1uK9J9GzNUbC6S@redhat.com>
References: <20211014122554.34599-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014122554.34599-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Error on bad socket group name
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, xiagao@redhat.com

On Thu, Oct 14, 2021 at 01:25:54PM +0100, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Make the '--socket-group=' option fail if the group name is unknown:
> 
> ./tools/virtiofsd/virtiofsd .... --socket-group=zaphod
> vhost socket: unable to find group 'zaphod'
> 
> Reported-by: Xiaoling Gao <xiagao@redhat.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Hi Dave,

This looks good to me. Just a minor nit for code cleanup. It could
be done in a separate patch or sometime later as well.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

> ---
>  tools/virtiofsd/fuse_virtio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 8f4fd165b9..39eebffb62 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -999,6 +999,13 @@ static int fv_create_listen_socket(struct fuse_session *se)
>                           "vhost socket failed to set group to %s (%d): %m\n",
>                           se->vu_socket_group, g->gr_gid);
>              }
> +        } else {
> +            fuse_log(FUSE_LOG_ERR,
> +                     "vhost socket: unable to find group '%s'\n",
> +                     se->vu_socket_group);
> +            close(listen_sock);
> +            umask(old_umask);
		^^^
> +            return -1;
>          }
>      }
>      umask(old_umask);

This umask() call could be moved little early right after bind() call and
that way we don't have to take care of calling umask(old_umask) in error
path if group name could not be found.

Vivek
> -- 
> 2.31.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

