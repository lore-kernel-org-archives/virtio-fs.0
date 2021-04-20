Date: Tue, 20 Apr 2021 15:03:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210420190334.GE1529659@redhat.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
	<20210420154643.58439-2-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420154643.58439-2-ma.mandourr@gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/7] virtiofsd: Changed allocations of
 fuse_req to GLib functions
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

On Tue, Apr 20, 2021 at 05:46:36PM +0200, Mahmoud Mandour wrote:
> Replaced the allocation and deallocation of fuse_req structs
> using calloc()/free() call pairs to a GLib's g_try_new0()
> and g_free().

Hi,

What's the context of these patches. I see all of them are switching
to glib functions. Why to do that? What's the advantage.

Vivek

> 
> Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index 58e32fc963..812cef6ef6 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -106,7 +106,7 @@ static void list_add_req(struct fuse_req *req, struct fuse_req *next)
>  static void destroy_req(fuse_req_t req)
>  {
>      pthread_mutex_destroy(&req->lock);
> -    free(req);
> +    g_free(req);
>  }
>  
>  void fuse_free_req(fuse_req_t req)
> @@ -130,7 +130,7 @@ static struct fuse_req *fuse_ll_alloc_req(struct fuse_session *se)
>  {
>      struct fuse_req *req;
>  
> -    req = (struct fuse_req *)calloc(1, sizeof(struct fuse_req));
> +    req = g_try_new0(struct fuse_req, 1);
>      if (req == NULL) {
>          fuse_log(FUSE_LOG_ERR, "fuse: failed to allocate request\n");
>      } else {
> @@ -1684,7 +1684,7 @@ static struct fuse_req *check_interrupt(struct fuse_session *se,
>          if (curr->u.i.unique == req->unique) {
>              req->interrupted = 1;
>              list_del_req(curr);
> -            free(curr);
> +            g_free(curr);
>              return NULL;
>          }
>      }
> -- 
> 2.25.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

