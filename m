Date: Thu, 1 Aug 2019 17:36:34 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190801163634.GQ2773@work-vm>
References: <20190801163206.7906-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801163206.7906-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix req use-after-free in
	lo_flush()
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

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Isn't it funny that a commit trying to fix use-after-free introduced its
> own use-after-free?
> 
> fuse_reply_err() frees the request so we cannot call lo_data(req)
> afterwards.
> 
> Fixes: a5081fc6fc3603671383616127b3a5e169cf64ed
>        ("virtiofsd: introduce inode refcount to prevent use-after-free")
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Squashed into the top.

Dave

> ---
>  contrib/virtiofsd/passthrough_ll.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index ee8627446a..a81c01d0d1 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1969,9 +1969,8 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  	pthread_mutex_unlock(&inode->plock_mutex);
>  
>  	res = close(dup(lo_fi_fd(req, fi)));
> -	fuse_reply_err(req, res == -1 ? errno : 0);
> -
>  	lo_inode_put(lo_data(req), &inode);
> +	fuse_reply_err(req, res == -1 ? errno : 0);
>  }
>  
>  static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

