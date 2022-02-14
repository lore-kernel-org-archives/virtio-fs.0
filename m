Date: Mon, 14 Feb 2022 16:43:14 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20220214164314.0898c036@bahia>
In-Reply-To: <20220214135820.43897-3-groug@kaod.org>
References: <20220214135820.43897-1-groug@kaod.org>
	<20220214135820.43897-3-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v5 2/3] virtiofsd: Track submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On Mon, 14 Feb 2022 14:58:19 +0100
Greg Kurz <groug@kaod.org> wrote:

> If
> Support for FUSE_SYNCFS requires the server to track submounts
> 
> that may exist under the shared directory. lo_do_lookup() already knows
> how to detect them : it is a directory with a different device ID or
> mount ID than its parent. Use the same logic and record the information
> under the lo_inode structure.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---

Oops I obviously did something wrong with the changelog. It should read:

---
If the server doesn't announce submounts to the client, it needs to
track them internally to properly support FUSE_SYNCFS. lo_do_lookup()
already knows how to detect them : it is a directory with a different
device ID or mount ID than its parent. Use the same logic and record
the information under the lo_inode structure.
---

I can send an updated version if needed.

>  tools/virtiofsd/passthrough_ll.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 2bf5d40df531..e94c4e6f8635 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -118,6 +118,7 @@ struct lo_inode {
>      GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
>  
>      mode_t filetype;
> +    bool is_submount;
>  };
>  
>  struct lo_cred {
> @@ -1017,6 +1018,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>      struct lo_data *lo = lo_data(req);
>      struct lo_inode *inode = NULL;
>      struct lo_inode *dir = lo_inode(req, parent);
> +    bool is_submount;
>  
>      if (inodep) {
>          *inodep = NULL; /* in case there is an error */
> @@ -1051,8 +1053,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          goto out_err;
>      }
>  
> -    if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
> -        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
> +    is_submount = S_ISDIR(e->attr.st_mode) &&
> +        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id);
> +
> +    if (is_submount && lo->announce_submounts) {
>          e->attr_flags |= FUSE_ATTR_SUBMOUNT;
>      }
>  
> @@ -1079,6 +1083,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          inode->key.ino = e->attr.st_ino;
>          inode->key.dev = e->attr.st_dev;
>          inode->key.mnt_id = mnt_id;
> +        inode->is_submount = is_submount;
>          if (lo->posix_lock) {
>              pthread_mutex_init(&inode->plock_mutex, NULL);
>              inode->posix_locks = g_hash_table_new_full(
> @@ -1100,8 +1105,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>      lo_inode_put(lo, &dir);
>  
> -    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
> -             name, (unsigned long long)e->ino);
> +    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n",
> +             (unsigned long long) parent, name, (unsigned long long) e->ino,
> +             is_submount ? " (submount)" : "");
>  
>      return 0;
>  

