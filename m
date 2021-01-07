DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=4YjG80XP4e3Tc9wbxU7a/YxKshWUmIFpHnbosNpGcxc=;
	b=DnDmdSMLG459cZFt9yE9ZB1UlO33Er1asL9Bj+HBDEbw1sZ9d5L4jIB57upeTZ+SUO
	WCyEv39PLA2omOIS+vGzExmmaBuItDY4oeDm2mwB/DzU3WSjl4C99wpv/CyC5huuUv9C
	oCS8EFNDYTunzK/TKtKAWF6prZJQYqce1Rws8=
MIME-Version: 1.0
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
	<CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
	<20210106165759.GA9679@redhat.com>
In-Reply-To: <20210106165759.GA9679@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 7 Jan 2021 09:44:45 +0100
Message-ID: <CAJfpegtO+X9rk5pTTRmDv9LWGK4fbvUuwNJvRP_o77B5Y5D3mA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Amir Goldstein <amir73il@gmail.com>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 6, 2021 at 5:58 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Jan 06, 2021 at 02:40:45PM +0100, Miklos Szeredi wrote:

> > @@ -901,6 +906,18 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >
> >      inode = lo_find(lo, &e->attr, mnt_id);
> >      if (inode) {
> > +        char buf1[PATH_MAX + 1], buf2[PATH_MAX + 1], procname[64];
> > +        ssize_t siz1, siz2;
> > +
> > +        sprintf(procname, "%i", inode->fd);
> > +        siz1 = readlinkat(lo->proc_self_fd, procname, buf1, sizeof(buf1));
> > +        sprintf(procname, "%i", newfd);
> > +        siz2 = readlinkat(lo->proc_self_fd, procname, buf2, sizeof(buf2));
> > +
> > +        /* disable close on unlink if alias is detected */
> > +        if (siz1 != siz2 || memcmp(buf1, buf2, siz1))
> > +            g_atomic_int_inc(&inode->opencount);
> > +
>
> Hi Miklos,
>
> So if I have a hard links to a file in a separate directories, then this
> path can hit. (Say dir1/file.txt and dir2/file-link.txt). IIUC, we will
> disable automatic inode->fd closing on these hardlinked files. That
> means this solution will not solve problem at hand for hard linked files.
> Am I missing something.

You are correct, this is a limited solution.  The one above is a
corner case, and probably not worth worrying about too much.  However
it  can be fixed by having separate O_PATH fd's open for each alias
(or at least for each alias that resides in a distinct directory).

NB: doing a synchronous FORGET on unlink does not solve this case
either, since the inode will not receive a FORGET until the last alias
is dropped.

> >          close(newfd);
> >      } else {
> >          inode = calloc(1, sizeof(struct lo_inode));
> > @@ -917,6 +934,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >           */
> >          g_atomic_int_set(&inode->refcount, 2);
> >
> > +        g_atomic_int_set(&inode->opencount, 0);
> >          inode->nlookup = 1;
> >          inode->fd = newfd;
> >          inode->key.ino = e->attr.st_ino;
> > @@ -1295,6 +1313,10 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
> >      res = unlinkat(lo_fd(req, parent), name, 0);
> >
> >      fuse_reply_err(req, res == -1 ? errno : 0);
> > +    if (!g_atomic_int_get(&inode->opencount)) {
> > +        close(inode->fd);
> > +        inode->fd = -1;
> > +    }
>
> Can this be racy w.r.t lo_lookup(). IOW, say dir1/file.txt is being
> unlinked and we closed inode->fd. And before we could execute
> unref_inode_lolocked(), another parallel lookup of dir2/file-link.txt
> happens if it gets lo->muxtex lock first, it can still find this
> inode and bump up reference count. And that means lo_unlink() will
> not free inode (but close inode->fd) and now we will use an inode
> with closed O_PATH fd which lead to other failures later.

Yes, that's a bug.   Also needs serialization against all access to inode->fd.

Thanks,
Miklos

