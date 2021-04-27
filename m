Date: Tue, 27 Apr 2021 11:24:42 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIfmaleNOwhLLD9W@work-vm>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-3-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420154643.58439-3-ma.mandourr@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/7] virtiofds: Changed allocations of
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
> deallocation functions.
> 
> Also, in one instance, used g_new0() instead of a calloc() call plus
> a null-checking assertion.
> 
> iovec structs were created locally and freed as the function
> ends. Hence, I used g_autofree and removed the respective calls to
> free().
> 
> In one instance, a struct fuse_ioctl_iovec pointer is returned from a
> function, namely, fuse_ioctl_iovec_copy. There, I used g_steal_pointer()
> in conjunction with g_autofree, this gives the ownership of the pointer
> to the calling function and still auto-frees the memory when the calling
> function finishes (maintaining the symantics of previous code).
> 
> Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c | 19 +++++++------------
>  tools/virtiofsd/fuse_virtio.c   |  6 +-----
>  2 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index 812cef6ef6..f965299ad9 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -217,9 +217,9 @@ static int send_reply(fuse_req_t req, int error, const void *arg,
>  int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
>  {
>      int res;
> -    struct iovec *padded_iov;
> +    g_autofree struct iovec *padded_iov;
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

OK.

> @@ -565,10 +564,10 @@ int fuse_reply_bmap(fuse_req_t req, uint64_t idx)
>  static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct iovec *iov,
>                                                        size_t count)
>  {
> -    struct fuse_ioctl_iovec *fiov;
> +    g_autofree struct fuse_ioctl_iovec *fiov;
>      size_t i;
>  
> -    fiov = malloc(sizeof(fiov[0]) * count);
> +    fiov = g_try_new(fuse_ioctl_iovec, count);
>      if (!fiov) {
>          return NULL;
>      }
> @@ -578,7 +577,7 @@ static struct fuse_ioctl_iovec *fuse_ioctl_iovec_copy(const struct iovec *iov,
>          fiov[i].len = iov[i].iov_len;
>      }
>  
> -    return fiov;
> +    return g_steal_pointer(&fiov);
>  }

This is OK, but doesn't gain anything - marking it as g_autofree'ing and
always stealing is no benefit.

>  
>  int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
> @@ -629,9 +628,6 @@ int fuse_reply_ioctl_retry(fuse_req_t req, const struct iovec *in_iov,
>  
>      res = send_reply_iov(req, 0, iov, count);
>  out:
> -    free(in_fiov);
> -    free(out_fiov);
> -

I don't think you can do that - I think you're relying here on the
g_autofree from fuse_ioclt_iovec_copy - but my understanding is that
doesn't work; g_autofree is scoped, so it's designed to free at the end
of fuse_ioctl_iovec_copy, fuse_reply_ioctl_retry doesn't know that the
ion_fiov were allocated that way, so it won't get autocleaned up.

>      return res;
>  
>  enomem:
> @@ -663,11 +659,11 @@ int fuse_reply_ioctl(fuse_req_t req, int result, const void *buf, size_t size)
>  int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
>                           int count)
>  {
> -    struct iovec *padded_iov;
> +    g_autofree struct iovec *padded_iov;
>      struct fuse_ioctl_out arg;
>      int res;
>  
> -    padded_iov = malloc((count + 2) * sizeof(struct iovec));
> +    padded_iov = g_try_new(struct iovec, count + 2);
>      if (padded_iov == NULL) {
>          return fuse_reply_err(req, ENOMEM);
>      }
> @@ -680,7 +676,6 @@ int fuse_reply_ioctl_iov(fuse_req_t req, int result, const struct iovec *iov,
>      memcpy(&padded_iov[2], iov, count * sizeof(struct iovec));
>  
>      res = send_reply_iov(req, 0, padded_iov, count + 2);
> -    free(padded_iov);
>  
>      return res;
>  }

OK

> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 3e13997406..07e5d91a9f 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -347,8 +347,7 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>       * Build a copy of the the in_sg iov so we can skip bits in it,
>       * including changing the offsets
>       */
> -    struct iovec *in_sg_cpy = calloc(sizeof(struct iovec), in_num);
> -    assert(in_sg_cpy);
> +    g_autofree struct iovec *in_sg_cpy = g_new0(struct iovec, in_num);
>      memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
>      /* These get updated as we skip */
>      struct iovec *in_sg_ptr = in_sg_cpy;
> @@ -386,7 +385,6 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>              ret = errno;
>              fuse_log(FUSE_LOG_DEBUG, "%s: preadv failed (%m) len=%zd\n",
>                       __func__, len);
> -            free(in_sg_cpy);
>              goto err;
>          }
>          fuse_log(FUSE_LOG_DEBUG, "%s: preadv ret=%d len=%zd\n", __func__,
> @@ -410,13 +408,11 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
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

Yes, this is where the autofree really helps; getting rid of a few
free's.

Dave

>      /* Need to fix out->len on EOF */
>      if (len) {
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

