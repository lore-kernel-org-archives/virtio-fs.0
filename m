Date: Wed, 3 Feb 2021 15:20:14 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210203152014.443a8b29@bahia.lan>
In-Reply-To: <20210203113719.83633-3-stefanha@redhat.com>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 2/3] virtiofsd: optionally return inode
 pointer from lo_do_lookup()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

On Wed,  3 Feb 2021 11:37:18 +0000
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> lo_do_lookup() finds an existing inode or allocates a new one. It
> increments nlookup so that the inode stays alive until the client
> releases it.
> 
> Existing callers don't need the struct lo_inode so the function doesn't
> return it. Extend the function to optionally return the inode. The next
> commit will need it.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index e63cbd3fb7..c87a1f3d72 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -831,11 +831,13 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>  }
>  
>  /*
> - * Increments nlookup and caller must release refcount using
> - * lo_inode_put(&parent).
> + * Increments nlookup on the inode on success. unref_inode_lolocked() must be
> + * called eventually to decrement nlookup again. If inodep is non-NULL, the
> + * inode pointer is stored and the caller must call lo_inode_put().
>   */
>  static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> -                        struct fuse_entry_param *e)
> +                        struct fuse_entry_param *e,
> +                        struct lo_inode **inodep)
>  {
>      int newfd;
>      int res;
> @@ -845,6 +847,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      struct lo_inode *inode = NULL;
>      struct lo_inode *dir = lo_inode(req, parent);
>  
> +    if (inodep) {
> +        *inodep = NULL;
> +    }
> +

Is this side-effect needed ? If lo_do_lookup() returns an error, it
rather seems that the caller shouldn't expect anything to be written
here, i.e. the content of *inodep still belongs to the caller and
whatever value it previously put in there (as patch 3/3 does) should
be preserved IMHO.

Apart from that LGTM.

>      /*
>       * name_to_handle_at() and open_by_handle_at() can reach here with fuse
>       * mount point in guest, but we don't have its inode info in the
> @@ -913,7 +919,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          pthread_mutex_unlock(&lo->mutex);
>      }
>      e->ino = inode->fuse_ino;
> -    lo_inode_put(lo, &inode);
> +
> +    /* Transfer ownership of inode pointer to caller or drop it */
> +    if (inodep) {
> +        *inodep = inode;
> +    } else {
> +        lo_inode_put(lo, &inode);
> +    }
> +
>      lo_inode_put(lo, &dir);
>  
>      fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
> @@ -948,7 +961,7 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
>          return;
>      }
>  
> -    err = lo_do_lookup(req, parent, name, &e);
> +    err = lo_do_lookup(req, parent, name, &e, NULL);
>      if (err) {
>          fuse_reply_err(req, err);
>      } else {
> @@ -1056,7 +1069,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
>          goto out;
>      }
>  
> -    saverr = lo_do_lookup(req, parent, name, &e);
> +    saverr = lo_do_lookup(req, parent, name, &e, NULL);
>      if (saverr) {
>          goto out;
>      }
> @@ -1534,7 +1547,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
>  
>          if (plus) {
>              if (!is_dot_or_dotdot(name)) {
> -                err = lo_do_lookup(req, ino, name, &e);
> +                err = lo_do_lookup(req, ino, name, &e, NULL);
>                  if (err) {
>                      goto error;
>                  }
> @@ -1732,7 +1745,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>          }
>  
>          fi->fh = fh;
> -        err = lo_do_lookup(req, parent, name, &e);
> +        err = lo_do_lookup(req, parent, name, &e, NULL);
>      }
>      if (lo->cache == CACHE_NONE) {
>          fi->direct_io = 1;

