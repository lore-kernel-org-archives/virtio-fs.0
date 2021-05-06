Date: Thu, 6 May 2021 10:39:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJO5RsRYQzTbFH09@work-vm>
References: <YIf2d8HuyPqwqt9C@work-vm>
	<20210427181333.148176-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427181333.148176-1-ma.mandourr@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 2/7] virtiofsd: Changed allocations of
 iovec to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Mahmoud Mandour <ma.mandourr@gmail.com>
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, qemu-devel@nongnu.org

* Mahmoud Mandour (ma.mandourr@gmail.com) wrote:
> Replaced the calls to malloc()/calloc() and their respective
> calls to free() of iovec structs with GLib's allocation and
> deallocation functions and used g_autofree when appropriate.
> 
> Replaced the allocation of in_sg_cpy to g_new() instead of a call
> to calloc() and a null-checking assertion. Not g_new0()
> because the buffer is immediately overwritten using memcpy.
> 
> Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>

Thanks,


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
> v2 -> v3:
>     * Removed a wrongful combination of g_autofree and g_steel_pointer().
>     * Removed some goto paths that IMHO were not so useful any more.
>     * In v2, I allocated in_sg_cpy through g_new0(). This patch, I use
>       g_new() because the buffer is memcpy'd into right away so no need
>       to zero-initialize.
>     * Moved the declaration of in_sg_cpy to the top of the function
>       to match QEMU's style guidelines. 
> 
>  tools/virtiofsd/fuse_lowlevel.c | 31 ++++++++++++-------------------
>  tools/virtiofsd/fuse_virtio.c   |  8 +++-----
>  2 files changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index c8bea246ab..7fe2cef1eb 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error, const void *arg,
>  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
>  {
>      int res;
> -    struct iovec *padded_iov;
> +    g_autofree struct iovec *padded_iov = NULL;
>  
> -    padded_iov = malloc((count + 1) * sizeof(struct iovec));
> +    padded_iov = g_try_new(struct iovec, count + 1);
>      if (padded_iov == NULL) {
>          return fuse_reply_err(req, ENOMEM);
>      }
> @@ -228,7 +228,6 @@ int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
>      count++;
>  
>      res = send_reply_iov(req, 0, padded_iov, count);
> -    free(padded_iov);
>  
>      return res;
>  }
> @@ -568,7 +567,7 @@ static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct iovec *iov,
>      struct fuse_ioctl_iovec *fiov;
>      size_t i;
>  
> -    fiov = malloc(sizeof(fiov[0]) * count);
> +    fiov = g_try_new(struct fuse_ioctl_iovec, count);
>      if (!fiov) {
>          return NULL;
>      }
> @@ -586,8 +585,8 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
>                             size_t out_count)
>  {
>      struct fuse_ioctl_out arg;
> -    struct fuse_ioctl_iovec *in_fiov = NULL;
> -    struct fuse_ioctl_iovec *out_fiov = NULL;
> +    g_autofree struct fuse_ioctl_iovec *in_fiov = NULL;
> +    g_autofree struct fuse_ioctl_iovec *out_fiov = NULL;
>      struct iovec iov[4];
>      size_t count = 1;
>      int res;
> @@ -603,13 +602,14 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
>      /* Can't handle non-compat 64bit ioctls on 32bit */
>      if (sizeof(void *) == 4 && req->ioctl_64bit) {
>          res = fuse_reply_err(req, EINVAL);
> -        goto out;
> +        return res;
>      }
>  
>      if (in_count) {
>          in_fiov = fuse_ioctl_iovec_copy(in_iov, in_count);
>          if (!in_fiov) {
> -            goto enomem;
> +            res = fuse_reply_err(req, ENOMEM);
> +            return res;

That could have just been return fuse_reply_err(req, ENOMEM);
but that's minor.

Dave

>          }
>  
>          iov[count].iov_base = (void *)in_fiov;
> @@ -619,7 +619,8 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
>      if (out_count) {
>          out_fiov = fuse_ioctl_iovec_copy(out_iov, out_count);
>          if (!out_fiov) {
> -            goto enomem;
> +            res = fuse_reply_err(req, ENOMEM);
> +            return res;
>          }
>  
>          iov[count].iov_base = (void *)out_fiov;
> @@ -628,15 +629,8 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
>      }
>  
>      res = send_reply_iov(req, 0, iov, count);
> -out:
> -    free(in_fiov);
> -    free(out_fiov);
>  
>      return res;
> -
> -enomem:
> -    res = fuse_reply_err(req, ENOMEM);
> -    goto out;
>  }
>  
>  int fuse_reply_ioctl(fuse_req_t req, int result, const void *buf, size_t size)
> @@ -663,11 +657,11 @@ int fuse_reply_ioctl(fuse_req_t req, int result, const void *buf, size_t size)
>  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
>                           int count)
>  {
> -    struct iovec *padded_iov;
> +    g_autofree struct iovec *padded_iov = NULL;
>      struct fuse_ioctl_out arg;
>      int res;
>  
> -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> +    padded_iov = g_try_new(struct iovec, count + 2);
>      if (padded_iov == NULL) {
>          return fuse_reply_err(req, ENOMEM);
>      }
> @@ -680,7 +674,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
>      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
>  
>      res = send_reply_iov(req, 0, padded_iov, count + 2);
> -    free(padded_iov);
>  
>      return res;
>  }
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 9e437618fb..9b00687cb0 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -295,6 +295,8 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>      VuVirtqElement *elem = &req->elem;
>      int ret = 0;
>  
> +    g_autofree struct iovec *in_sg_cpy = NULL;
> +
>      assert(count >= 1);
>      assert(iov[0].iov_len >= sizeof(struct fuse_out_header));
>  
> @@ -347,8 +349,7 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>       * Build a copy of the the in_sg iov so we can skip bits in it,
>       * including changing the offsets
>       */
> -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec), in_num);
> -    assert(in_sg_cpy);
> +    in_sg_cpy = g_new(struct iovec, in_num);
>      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
>      /* These get updated as we skip */
>      struct iovec *in_sg_ptr = in_sg_cpy;
> @@ -386,7 +387,6 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>              ret = errno;
>              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m) len=%zd\n",
>                       __func__, len);
> -            free(in_sg_cpy);
>              goto err;
>          }
>          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n", __func__,
> @@ -410,13 +410,11 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>          if (ret != len) {
>              fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
>              ret = EIO;
> -            free(in_sg_cpy);
>              goto err;
>          }
>          in_sg_left -= ret;
>          len -= ret;
>      } while (in_sg_left);
> -    free(in_sg_cpy);
>  
>      /* Need to fix out->len on EOF */
>      if (len) {
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

