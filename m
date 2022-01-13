Date: Thu, 13 Jan 2022 10:59:15 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20220113105915.0f46dbb6@bahia>
In-Reply-To: <20220111181043.435915-1-sebastian.hasler@stuvus.uni-stuttgart.de>
References: <20220111181043.435915-1-sebastian.hasler@stuvus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Do not support blocking flock
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

On Tue, 11 Jan 2022 19:10:43 +0100
Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de> wrote:

> With the current implementation, blocking flock can lead to
> deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
> to perform a blocking flock request.
> 
> Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
> ---
>  tools/virtiofsd/passthrough_ll.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 64b5b4fbb1..f3cc307f6d 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2442,6 +2442,12 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
>      int res;
>      (void)ino;
>  
> +    if (!(op & LOCK_NB)) {
> +        /* Blocking flock is not supported */

This paraphrases the code. It would be more informative to provide
an explanation, something like /* Blocking flock can deadlock */ .

No big deal.

Reviewed-by: Greg Kurz <groug@kaod.org>

> +        fuse_reply_err(req, EOPNOTSUPP);
> +        return;
> +    }
> +
>      res = flock(lo_fi_fd(req, fi), op);
>  
>      fuse_reply_err(req, res == -1 ? errno : 0);

