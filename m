Date: Wed, 6 Jan 2021 11:57:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210106165759.GA9679@redhat.com>
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
	<CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
	& NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Amir Goldstein <amir73il@gmail.com>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 06, 2021 at 02:40:45PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 6, 2021 at 10:16 AM Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > Please note that NFS doesn't do "silly rename" for directories,
> > so mitigation is mostly needed for non-dir.
> 
> Okay.
> 
> > An alternative method if daemon is not capable, is to store parent dirfd
> > in addition to filehandle and implement open_child_by_handle_at(int
> > parent_fd, ...):
> > - readdir(parend_fd)
> > - search a match for d_ino
> > - name_to_handle_at() and verify match to stored filehandle
> >
> > This is essentially what open_by_handle_at(2) does under the covers
> > with a "connectable" non-dir filehandle after having resolved the
> > parent file handle part. And "connectable" file handles are used by nfsd
> > to enforce "subtree_check" to make sure that file wasn't moved outside
> > obtainable path after initial lookup.
> 
> Yes, sort of makes sense, but will have corner cases for hard links in
> different directories, open files after unlink, etc..
> 
> Also back to the original problem: what we really want is to close the
> O_PATH descriptor on unlink().  This should be possible, regardless of
> any FORGET, assuming
> 
> 1) no open files exist that reference the inode
> 2) no aliases have been looked up (i.e. just one cached dentry)
> 
> The attached untested patch tries to do this.
> 
> Thanks,
> Miklos

> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index ec1008bceba8..d9c03e87e57d 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -107,6 +107,11 @@ struct lo_inode {
>       */
>      gint refcount;
>  
> +    /*
> +     * Number of open instances
> +     */
> +    gint opencount;
> +
>      struct lo_key key;
>  
>      /*
> @@ -901,6 +906,18 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>      inode = lo_find(lo, &e->attr, mnt_id);
>      if (inode) {
> +        char buf1[PATH_MAX + 1], buf2[PATH_MAX + 1], procname[64];
> +        ssize_t siz1, siz2;
> +
> +        sprintf(procname, "%i", inode->fd);
> +        siz1 = readlinkat(lo->proc_self_fd, procname, buf1, sizeof(buf1));
> +        sprintf(procname, "%i", newfd);
> +        siz2 = readlinkat(lo->proc_self_fd, procname, buf2, sizeof(buf2));
> +
> +        /* disable close on unlink if alias is detected */
> +        if (siz1 != siz2 || memcmp(buf1, buf2, siz1))
> +            g_atomic_int_inc(&inode->opencount);
> +

Hi Miklos,

So if I have a hard links to a file in a separate directories, then this
path can hit. (Say dir1/file.txt and dir2/file-link.txt). IIUC, we will
disable automatic inode->fd closing on these hardlinked files. That
means this solution will not solve problem at hand for hard linked files.
Am I missing something.

>          close(newfd);
>      } else {
>          inode = calloc(1, sizeof(struct lo_inode));
> @@ -917,6 +934,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>           */
>          g_atomic_int_set(&inode->refcount, 2);
>  
> +        g_atomic_int_set(&inode->opencount, 0);
>          inode->nlookup = 1;
>          inode->fd = newfd;
>          inode->key.ino = e->attr.st_ino;
> @@ -1295,6 +1313,10 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
>      res = unlinkat(lo_fd(req, parent), name, 0);
>  
>      fuse_reply_err(req, res == -1 ? errno : 0);
> +    if (!g_atomic_int_get(&inode->opencount)) {
> +        close(inode->fd);
> +        inode->fd = -1;
> +    }

Can this be racy w.r.t lo_lookup(). IOW, say dir1/file.txt is being
unlinked and we closed inode->fd. And before we could execute
unref_inode_lolocked(), another parallel lookup of dir2/file-link.txt
happens if it gets lo->muxtex lock first, it can still find this
inode and bump up reference count. And that means lo_unlink() will
not free inode (but close inode->fd) and now we will use an inode
with closed O_PATH fd which lead to other failures later.

Thanks
Vivek

>      unref_inode_lolocked(lo, inode, 1);
>      lo_inode_put(lo, &inode);
>  }
> @@ -1904,25 +1926,30 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      ssize_t fh;
>      char buf[64];
>      struct lo_data *lo = lo_data(req);
> +    struct lo_inode *inode = lo_inode(req, ino);
> +    int err = EBADF;
> +
> +    if (!inode)
> +        goto out_err;
>  
>      fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d)\n", ino,
>               fi->flags);
>  
>      update_open_flags(lo->writeback, lo->allow_direct_io, fi);
>  
> -    sprintf(buf, "%i", lo_fd(req, ino));
> +    sprintf(buf, "%i", inode->fd);
>      fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
> -    if (fd == -1) {
> -        return (void)fuse_reply_err(req, errno);
> -    }
> +    err = errno;
> +    if (fd == -1)
> +        goto out_err;
>  
>      pthread_mutex_lock(&lo->mutex);
>      fh = lo_add_fd_mapping(req, fd);
>      pthread_mutex_unlock(&lo->mutex);
>      if (fh == -1) {
>          close(fd);
> -        fuse_reply_err(req, ENOMEM);
> -        return;
> +        err = ENOMEM;
> +        goto out_err;
>      }
>  
>      fi->fh = fh;
> @@ -1931,18 +1958,26 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>      } else if (lo->cache == CACHE_ALWAYS) {
>          fi->keep_cache = 1;
>      }
> +    g_atomic_int_inc(&inode->opencount);
> +    lo_inode_put(lo, &inode);
>      fuse_reply_open(req, fi);
> +    return;
> +
> +out_err:
> +    lo_inode_put(lo, &inode);
> +    fuse_reply_err(req, err);
>  }
>  
>  static void lo_release(fuse_req_t req, fuse_ino_t ino,
>                         struct fuse_file_info *fi)
>  {
>      struct lo_data *lo = lo_data(req);
> +    struct lo_inode *inode = lo_inode(req, ino);
>      struct lo_map_elem *elem;
>      int fd = -1;
>  
> -    (void)ino;
> -
> +    if (inode)
> +        g_atomic_int_dec_and_test(&inode->opencount);
>      pthread_mutex_lock(&lo->mutex);
>      elem = lo_map_get(&lo->fd_map, fi->fh);
>      if (elem) {
> @@ -1951,6 +1986,7 @@ static void lo_release(fuse_req_t req, fuse_ino_t ino,
>          lo_map_remove(&lo->fd_map, fi->fh);
>      }
>      pthread_mutex_unlock(&lo->mutex);
> +    lo_inode_put(lo, &inode);
>  
>      close(fd);
>      fuse_reply_err(req, 0);

