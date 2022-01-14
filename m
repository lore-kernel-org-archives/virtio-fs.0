Date: Fri, 14 Jan 2022 13:20:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YeG+4Uqeoj4hUpa4@redhat.com>
References: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: Do not support blocking flock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Jan 13, 2022 at 04:32:49PM +0100, Sebastian Hasler wrote:
> With the current implementation, blocking flock can lead to
> deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
> to perform a blocking flock request.
> 
> Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Thanks Sebastian. Good fix. I can easily reproduce the deadlock.

shell1> flock foo.txt -c "sleep 10"
shell2> flock foo.txt -c echo

First commands take flock on foo.txt. Second command blocks on lock. And
only virtiofsd thread serving the virt messages blocks on flock(). Now
first command never exits. I think it will try to free lock once sleep
is over and that will deadlock. virtiofsd thread is blocked and it will
never wake up because lock release operation will never make progress.

This will be little painful for people as they will start seeing
errors. But I guess erroring out early is better than a potential
deadlock later.

Vivek

> ---
>  tools/virtiofsd/passthrough_ll.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 64b5b4fbb1..faa62278c5 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2442,6 +2442,15 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>      int res;
>      (void)ino;
>  
> +    if (!(op & LOCK_NB)) {
> +        /*
> +         * Blocking flock can deadlock as there is only one thread
> +         * serving the queue.
> +         */
> +        fuse_reply_err(req, EOPNOTSUPP);
> +        return;
> +    }
> +
>      res = flock(lo_fi_fd(req, fi), op);
>  
>      fuse_reply_err(req, res == -1 ? errno : 0);
> -- 
> 2.33.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

