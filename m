Date: Tue, 11 May 2021 12:06:55 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210511120655.379c99fb@bahia.lan>
In-Reply-To: <20210510191839.GB193692@horse>
References: <20210510155539.998747-1-groug@kaod.org>
	<20210510155539.998747-3-groug@kaod.org>
	<20210510191839.GB193692@horse>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [for-6.1 v3 2/3] virtiofsd: Track mounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Szeredi <miklos@szeredi.hu>, Miklos, Paolo Bonzini <pbonzini@redhat.com>

On Mon, 10 May 2021 15:18:39 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, May 10, 2021 at 05:55:38PM +0200, Greg Kurz wrote:
> > The upcoming implementation of ->sync_fs() needs to know about all
> > submounts in order to call syncfs() on all of them.
> > 
> > Track every inode that comes up with a new mount id in a GHashTable.
> > If the mount id isn't available, e.g. no statx() on the host, fallback
> > on the device id for the key. This is done during lookup because we
> > only care for the submounts that the client knows about. The inode
> > is removed from the hash table when ultimately unreferenced. This
> > can happen on a per-mount basis when the client posts a FUSE_FORGET
> > request or for all submounts at once with FUSE_DESTROY.
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 42 +++++++++++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 1553d2ef454f..dc940a1d048b 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -117,6 +117,7 @@ struct lo_inode {
> >      GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
> >  
> >      mode_t filetype;
> > +    bool is_mnt;
> >  };
> >  
> >  struct lo_cred {
> > @@ -163,6 +164,7 @@ struct lo_data {
> >      bool use_statx;
> >      struct lo_inode root;
> >      GHashTable *inodes; /* protected by lo->mutex */
> > +    GHashTable *mnt_inodes; /* protected by lo->mutex */
> >      struct lo_map ino_map; /* protected by lo->mutex */
> >      struct lo_map dirp_map; /* protected by lo->mutex */
> >      struct lo_map fd_map; /* protected by lo->mutex */
> > @@ -968,6 +970,31 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
> >      return 0;
> >  }
> >  
> > +static uint64_t mnt_inode_key(struct lo_inode *inode)
> > +{
> > +    /* Prefer mnt_id, fallback on dev */
> > +    return inode->key.mnt_id ? inode->key.mnt_id : inode->key.dev;
> > +}
> > +
> > +static void add_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
> > +{
> > +    uint64_t mnt_key = mnt_inode_key(inode);
> > +
> > +    if (!g_hash_table_contains(lo->mnt_inodes, &mnt_key)) {
> > +        inode->is_mnt = true;
> > +        g_hash_table_insert(lo->mnt_inodes, &mnt_key, inode);
> > +    }
> > +}
> > +
> > +static void remove_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
> > +{
> > +    uint64_t mnt_key = mnt_inode_key(inode);
> > +
> > +    if (inode->is_mnt) {
> > +        g_hash_table_remove(lo->mnt_inodes, &mnt_key);
> > +    }
> 
> What if same filesystem is mounted at two different mount points. Say at
> foo/ and bar/. Now when we lookup foo, we will add that inode to 

e.g.

mount --bind /var/tmp ${virtiofs_path}/foo
mount --bind /var/tmp ${virtiofs_path}/bar

?

> hash table. But when we lookup bar, we will not add it. Now say foo
> is unmounted, and inode is going away, then we will remove super block
> of fs from hash table (while it is still mounted at bar/ ?). Do I
> understand it right?

If the host provides mount ids in statx(), each of these has a different
mnt_id and is thus considered as a distinct super block.

On a host with an older kernel, the fallback on dev_t would cause them
to be considered the same indeed. But in this case, foo and bar are
already confounded in the inode list, i.e. we can't have one removed
and the other one still around AFAICT.

If virtiofsd still has an inode for foo, it cannot be unmounted in the
host. The client needs to forget the inode first, in which case it
seems we don't care anymore for foo's super block.

> 
> If yes, we probably will need another refcounted object to keep track
> of all the instances of the same fs?
> 

I wanted to do that at first but it seemed unnecessary in the end,
because I couldn't come up with a scenario where we could evict
a super block while some inode under it is still referenced by the
client.

Anyway, I need to respin the patch because I misused the glib
hash table API, i.e. use g_int64_*() functions on unallocated
keys while I should use g_direct_*() to do this optimization.
This has the effect of never removing super blocks and ending
with stale inode pointers in the hash. This is what caused
the EBADF error with syncfs() you reported on irc.

> Thanks
> Vivek
> 

Cheers,

--
Greg

> 
> > +}
> > +
> 
> >  /*
> >   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
> >   * called eventually to decrement nlookup again. If inodep is non-NULL, the
> > @@ -1054,10 +1081,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >          pthread_mutex_lock(&lo->mutex);
> >          inode->fuse_ino = lo_add_inode_mapping(req, inode);
> >          g_hash_table_insert(lo->inodes, &inode->key, inode);
> > +        add_mnt_inode(lo, inode);
> >          pthread_mutex_unlock(&lo->mutex);
> >      }
> >      e->ino = inode->fuse_ino;
> >  
> > +    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n", (unsigned long long)parent,
> > +             name, (unsigned long long)e->ino, inode->is_mnt ? " (mount)" : "");
> > +
> >      /* Transfer ownership of inode pointer to caller or drop it */
> >      if (inodep) {
> >          *inodep = inode;
> > @@ -1067,9 +1098,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  
> >      lo_inode_put(lo, &dir);
> >  
> > -    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
> > -             name, (unsigned long long)e->ino);
> > -
> >      return 0;
> >  
> >  out_err:
> > @@ -1479,6 +1507,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
> >              g_hash_table_destroy(inode->posix_locks);
> >              pthread_mutex_destroy(&inode->plock_mutex);
> >          }
> > +        remove_mnt_inode(lo, inode);
> >          /* Drop our refcount from lo_do_lookup() */
> >          lo_inode_put(lo, &inode);
> >      }
> > @@ -3129,6 +3158,7 @@ static void lo_destroy(void *userdata)
> >      struct lo_data *lo = (struct lo_data *)userdata;
> >  
> >      pthread_mutex_lock(&lo->mutex);
> > +    g_hash_table_remove_all(lo->mnt_inodes);
> >      while (true) {
> >          GHashTableIter iter;
> >          gpointer key, value;
> > @@ -3659,6 +3689,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
> >          root->posix_locks = g_hash_table_new_full(
> >              g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
> >      }
> > +    add_mnt_inode(lo, root);
> >  }
> >  
> >  static guint lo_key_hash(gconstpointer key)
> > @@ -3678,6 +3709,10 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
> >  
> >  static void fuse_lo_data_cleanup(struct lo_data *lo)
> >  {
> > +    if (lo->mnt_inodes) {
> > +        g_hash_table_destroy(lo->mnt_inodes);
> > +    }
> > +
> >      if (lo->inodes) {
> >          g_hash_table_destroy(lo->inodes);
> >      }
> > @@ -3739,6 +3774,7 @@ int main(int argc, char *argv[])
> >      lo.root.fd = -1;
> >      lo.root.fuse_ino = FUSE_ROOT_ID;
> >      lo.cache = CACHE_AUTO;
> > +    lo.mnt_inodes = g_hash_table_new(g_int64_hash, g_int64_equal);
> >  
> >      /*
> >       * Set up the ino map like this:
> > -- 
> > 2.26.3
> > 
> 

