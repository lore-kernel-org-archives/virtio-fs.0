Date: Thu, 23 May 2019 11:22:54 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20190523032254.GB15291@e18g06458.et15sqa>
References: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: handle NULL dir in lo_do_lookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Thu, May 23, 2019 at 10:06:34AM +0800, Liu Bo wrote:
> Reported by fstests/generic/467.
> 
> open_by_handle_at() called from fuse inside guest can carry fuse mount
> point to daemon but lo_do_lookup() doesn't know its inode info because
> it's out of fuse's scope, thus lo_inode(req, parent) ends up with
> returning a NULL dir and breaks virtiofsd immediately.
> 
> Note that it'd break applications that uses open_by_handle_at.
> 
> It seems to me that nothing could be done to support open_by_handle_at in
> this case.

Then perhaps we should consider disabling exportfs support in virtio-fs
case? I noticed that currently fuse set

	sb->s_export_op = &fuse_export_operations

unconditionally, maybe we could implement a feature mask in fuse and let
filesystem implementation registers what features it supports, e.g.
exportfs in this case.

Or we could try adding real exportfs support to virtiofs? Though I'm not
sure if it's possible or worth it at the moment.

> 
> This simply tells fuse a ENOENT error so that open_by_handle_at() in guest
> can get a ESTALE.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

The patch itself looks fine to me.

Reviewed-by: Eryu Guan <eguan@linux.alibaba.com>

Thanks,
Eryu

> ---
>  contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 9b7e515..b58708f 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -640,6 +640,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  	struct lo_data *lo = lo_data(req);
>  	struct lo_inode *inode, *dir = lo_inode(req, parent);
>  
> +        /*
> +         * name_to_handle_at() and open_by_handle_at() can reach here with fuse
> +         * mount point in guest, but we don't have its inode info in the
> +         * ino_map.
> +         */
> +        if (!dir)
> +                return ENOENT;
> +
>  	memset(e, 0, sizeof(*e));
>  	e->attr_timeout = lo->timeout;
>  	e->entry_timeout = lo->timeout;
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

