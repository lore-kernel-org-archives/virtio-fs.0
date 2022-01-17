Date: Mon, 17 Jan 2022 18:08:55 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20220117180855.6353fc05@bahia>
In-Reply-To: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
References: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Thu, 13 Jan 2022 16:32:49 +0100
Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de> wrote:

> With the current implementation, blocking flock can lead to
> deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
> to perform a blocking flock request.
> 
> Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

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

