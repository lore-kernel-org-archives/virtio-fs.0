Date: Thu, 10 Dec 2020 19:50:35 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201210195035.GD12670@work-vm>
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-2-vgoyal@redhat.com>
	<20201207195539.GB3107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207195539.GB3107@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Set up posix_lock hash table
 for root inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> We setup per inode hash table ->posix_lock to support remote posix locks.
> But we forgot to initialize this table for root inode.
> 
> Laszlo managed to trigger an issue where he sent a FUSE_FLUSH request for
> root inode and lo_flush() found inode with inode->posix_lock NULL and
> accessing this table crashed virtiofsd.
> 
> May be we can get rid of initializing this hash table for directory
> objects completely. But that optimization is for another day.
> 
> Reported-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2020-12-07 14:46:22.198359486 -0500
> +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2020-12-07 14:48:07.873737472 -0500
> @@ -3372,6 +3372,9 @@ static void setup_root(struct lo_data *l
>      root->key.mnt_id = mnt_id;
>      root->nlookup = 2;
>      g_atomic_int_set(&root->refcount, 2);
> +    pthread_mutex_init(&root->plock_mutex, NULL);
> +    root->posix_locks = g_hash_table_new_full(
> +        g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
>  }
>  
>  static guint lo_key_hash(gconstpointer key)
> @@ -3394,6 +3397,10 @@ static void fuse_lo_data_cleanup(struct
>      if (lo->inodes) {
>          g_hash_table_destroy(lo->inodes);
>      }
> +
> +    if (lo->root.posix_locks) {
> +        g_hash_table_destroy(lo->root.posix_locks);
> +    }
>      lo_map_destroy(&lo->fd_map);
>      lo_map_destroy(&lo->dirp_map);
>      lo_map_destroy(&lo->ino_map);
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

