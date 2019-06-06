Date: Thu, 6 Jun 2019 10:54:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190606095428.GI2788@work-vm>
References: <1559805375-44679-1-git-send-email-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559805375-44679-1-git-send-email-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix lo_do_lookup panic
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Peng Tao (tao.peng@linux.alibaba.com) wrote:
> It needs to check for invalid parent dir.
> 
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>

This is the same as Liu Bo's patch from 23rd May; but there
was some discussion about what to do about open_by_handle_at.
Did we ever get an answer to that?

Dave

> ---
>  contrib/virtiofsd/passthrough_ll.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 8a3adc9..f544387 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -640,6 +640,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  	struct lo_data *lo = lo_data(req);
>  	struct lo_inode *inode, *dir = lo_inode(req, parent);
>  
> +	if (dir == NULL)
> +		return EBADF;
> +
>  	memset(e, 0, sizeof(*e));
>  	e->attr_timeout = lo->timeout;
>  	e->entry_timeout = lo->timeout;
> -- 
> 1.8.3.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

