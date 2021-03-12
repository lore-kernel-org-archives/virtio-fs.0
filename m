Date: Fri, 12 Mar 2021 16:49:51 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210312164951.3d5b5ab9@bahia.lan>
In-Reply-To: <d2b63edf-8326-a645-659e-67ad04a6db0b@redhat.com>
References: <20210312141003.819108-1-groug@kaod.org>
	<20210312141003.819108-2-groug@kaod.org>
	<d2b63edf-8326-a645-659e-67ad04a6db0b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Don't allow empty paths in
 lookup_name()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, 12 Mar 2021 09:13:36 -0600
Connor Kuehl <ckuehl@redhat.com> wrote:

> On 3/12/21 8:10 AM, Greg Kurz wrote:
> > When passed an empty filename, lookup_name() returns the inode of
> > the parent directory, unless the parent is the root in which case
> > the st_dev doesn't match and lo_find() returns NULL. This is
> > because lookup_name() passes AT_EMPTY_PATH down to fstatat() or
> > statx().
> > 
> > This behavior doesn't quite make sense because users of lookup_name()
> > then pass the name to unlinkat(), renameat() or renameat2(), all of
> > which will always fail on empty names.
> > 
> > Drop AT_EMPTY_PATH from the flags in lookup_name() so that it has
> > the consistent behavior of "returning an existing child inode or
> > NULL" for all directories.
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   tools/virtiofsd/passthrough_ll.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index fc7e1b1e8e2b..27a6c636dcaf 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -1308,8 +1308,7 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
> >           return NULL;
> >       }
> >   
> > -    res = do_statx(lo, dir->fd, name, &attr,
> > -                   AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);
> > +    res = do_statx(lo, dir->fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
> >       lo_inode_put(lo, &dir);
> >       if (res == -1) {
> >           return NULL;
> > 
> 
> Should the statx() in lo_do_lookup() have this flag removed as well? I 

This is different.

    newfd = openat(dir->fd, name, O_PATH | O_NOFOLLOW);
    if (newfd == -1) {
        goto out_err;
    }

    res = do_statx(lo, newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
                   &mnt_id);
    if (res == -1) {
        goto out_err;
    }

No client originated name is passed to do_statx() in this case. On the
contrary, AT_EMPTY_PATH is provided on purpose since the third argument
is "". The goal here is to get the attributes of the entry newfd points
to.

Same stands for other occurences of AT_EMPTY_PATH with fstatat() in
lo_getattr() and lo_link(), fchownat() in lo_setattr() or do_statx()
again in setup_root().

> don't think its callers will pass in an empty name because:
> 
>    - One of your later patches prevents lo_mknod_symlink() from doing so
>    - lo_create() will fail an earlier call against the host file system 
> (open)
>    - lo_do_readdir() shouldn't be reading empty names because that 
> implies someone was able to pull off making an entry with an empty name
> 
> However, I don't know if there will one day be future callers to 
> lo_do_lookup() that will depend on that flag.
> 
> If the answer to the above is no, then:
> 

It is :)

> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> 

Thanks !

