Date: Tue, 8 Dec 2020 11:56:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201208165610.GA20722@redhat.com>
References: <20201208073936.8629-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208073936.8629-1-lersek@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: update FUSE_FORGET comment on
 "lo_inode.nlookup"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Tue, Dec 08, 2020 at 08:39:36AM +0100, Laszlo Ersek wrote:
> Miklos confirms it's *only* the FUSE_FORGET request that the client can
> use for decrementing "lo_inode.nlookup".
> 
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Fixes: 1222f015558fc34cea02aa3a5a92de608c82cec8
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>

Looks correct. unref_inode() calls in lo_rmdir() lo_rename() are dropping
->nlookup they have taken internally during the function execution.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 06543b20dcbb..d3be680e92c3 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -113,7 +113,7 @@ struct lo_inode {
>       * This counter keeps the inode alive during the FUSE session.
>       * Incremented when the FUSE inode number is sent in a reply
>       * (FUSE_LOOKUP, FUSE_READDIRPLUS, etc).  Decremented when an inode is
> -     * released by requests like FUSE_FORGET, FUSE_RMDIR, FUSE_RENAME, etc.
> +     * released by a FUSE_FORGET request.
>       *
>       * Note that this value is untrusted because the client can manipulate
>       * it arbitrarily using FUSE_FORGET requests.
> -- 
> 2.19.1.3.g30247aa5d201
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

