Date: Mon, 9 Aug 2021 12:10:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRFTWVC1vXwjky5v@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-9-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730150134.216126-9-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 08/10] virtiofsd: Add inodes_by_handle
	hash table
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Jul 30, 2021 at 05:01:32PM +0200, Max Reitz wrote:
> Currently, lo_inode.fhandle is always NULL and so always keep an O_PATH
> FD in lo_inode.fd.  Therefore, when the respective inode is unlinked,
> its inode ID will remain in use until we drop our lo_inode (and
> lo_inode_put() thus closes the FD).  Therefore, lo_find() can safely use
> the inode ID as an lo_inode key, because any inode with an inode ID we
> find in lo_data.inodes (on the same filesystem) must be the exact same
> file.
> 
> This will change when we start setting lo_inode.fhandle so we do not
> have to keep an O_PATH FD open.  Then, unlinking such an inode will
> immediately remove it, so its ID can then be reused by newly created
> files, even while the lo_inode object is still there[1].
> 
> So creating a new file can then reuse the old file's inode ID, and
> looking up the new file would lead to us finding the old file's
> lo_inode, which is not ideal.
> 
> Luckily, just as file handles cause this problem, they also solve it:  A
> file handle contains a generation ID, which changes when an inode ID is
> reused, so the new file can be distinguished from the old one.  So all
> we need to do is to add a second map besides lo_data.inodes that maps
> file handles to lo_inodes, namely lo_data.inodes_by_handle.  For
> clarity, lo_data.inodes is renamed to lo_data.inodes_by_ids.
> 
> Unfortunately, we cannot rely on being able to generate file handles
> every time.  Therefore, we still enter every lo_inode object into
> inodes_by_ids, but having an entry in inodes_by_handle is optional.  A
> potential inodes_by_handle entry then has precedence, the inodes_by_ids
> entry is just a fallback.
> 
> Note that we do not generate lo_fhandle objects yet, and so we also do
> not enter anything into the inodes_by_handle map yet.  Also, all lookups
> skip that map.  We might manually create file handles with some code
> that is immediately removed by the next patch again, but that would
> break the assumption in lo_find() that every lo_inode with a non-NULL
> .fhandle must have an entry in inodes_by_handle and vice versa.  So we
> leave actually using the inodes_by_handle map for the next patch.
> 
> [1] If some application in the guest still has the file open, there is
> going to be a corresponding FD mapping in lo_data.fd_map.  In such a
> case, the inode will only go away once every application in the guest
> has closed it.  The problem described only applies to cases where the
> guest does not have the file open, and it is just in the dentry cache,
> basically.
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 81 +++++++++++++++++++++++++-------
>  1 file changed, 65 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 487448d666..f9d8b2f134 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -180,7 +180,8 @@ struct lo_data {
>      int announce_submounts;
>      bool use_statx;
>      struct lo_inode root;
> -    GHashTable *inodes; /* protected by lo->mutex */
> +    GHashTable *inodes_by_ids; /* protected by lo->mutex */
> +    GHashTable *inodes_by_handle; /* protected by lo->mutex */
>      struct lo_map ino_map; /* protected by lo->mutex */
>      struct lo_map dirp_map; /* protected by lo->mutex */
>      struct lo_map fd_map; /* protected by lo->mutex */
> @@ -263,8 +264,9 @@ static struct {
>  /* That we loaded cap-ng in the current thread from the saved */
>  static __thread bool cap_loaded = 0;
>  
> -static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
> -                                uint64_t mnt_id);
> +static struct lo_inode *lo_find(struct lo_data *lo,
> +                                const struct lo_fhandle *fhandle,
> +                                struct stat *st, uint64_t mnt_id);
>  static int xattr_map_client(const struct lo_data *lo, const char *client_name,
>                              char **out_name);
>  
> @@ -1064,18 +1066,40 @@ out_err:
>      fuse_reply_err(req, saverr);
>  }
>  
> -static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
> -                                uint64_t mnt_id)
> +static struct lo_inode *lo_find(struct lo_data *lo,
> +                                const struct lo_fhandle *fhandle,
> +                                struct stat *st, uint64_t mnt_id)
>  {
> -    struct lo_inode *p;
> -    struct lo_key key = {
> +    struct lo_inode *p = NULL;
> +    struct lo_key ids_key = {
>          .ino = st->st_ino,
>          .dev = st->st_dev,
>          .mnt_id = mnt_id,
>      };
>  
>      pthread_mutex_lock(&lo->mutex);
> -    p = g_hash_table_lookup(lo->inodes, &key);
> +    if (fhandle) {
> +        p = g_hash_table_lookup(lo->inodes_by_handle, fhandle);
> +    }
> +    if (!p) {
> +        p = g_hash_table_lookup(lo->inodes_by_ids, &ids_key);

So even if fhandle is not NULL, we will still lookup the inode
object in lo->inodes_by_ids? I thought fallback was only required
if we could not generate file handle to begin with and in that case
fhandle will be NULL?

IOW, should this code instead look like.

if (fhandle) {
    lookup_in_lo_inodes_by_handle
} else {
    lookup_in_lo_inodes_by_ids;
    if_found_verify_valid_o_path_fd;
}


> +        /*
> +         * When we had to fall back to looking up an inode by its
> +         * inode ID, ensure that we hit an entry that has a valid file
> +         * descriptor.  Having an FD open means that the inode cannot
> +         * really be deleted until the FD is closed, so that the inode
> +         * ID remains valid until we evict our lo_inode.
> +         * With no FD open (and just a file handle), the inode can be
> +         * deleted while we still have our lo_inode, and so the inode
> +         * ID may be reused by a completely different new inode.  We
> +         * then must look up the lo_inode by file handle, because this
> +         * handle contains a generation ID to differentiate between
> +         * the old and the new inode.
> +         */
> +        if (p && p->fd == -1) {
> +            p = NULL;
> +        }
> +    }
>      if (p) {
>          assert(p->nlookup > 0);
>          p->nlookup++;


[..]
>  static void fuse_lo_data_cleanup(struct lo_data *lo)
>  {
> -    if (lo->inodes) {
> -        g_hash_table_destroy(lo->inodes);
> +    if (lo->inodes_by_ids) {
> +        g_hash_table_destroy(lo->inodes_by_ids);
> +    }
> +    if (lo->inodes_by_ids) {
            ^^^^^
Should this be lo->inodes_by_handle instead?

> +        g_hash_table_destroy(lo->inodes_by_handle);

Thanks
Vivek

