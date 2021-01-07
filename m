Date: Thu, 7 Jan 2021 20:10:31 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210107201031.GI2918@work-vm>
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
	<CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
	<20210106165759.GA9679@redhat.com>
	<CAJfpegtO+X9rk5pTTRmDv9LWGK4fbvUuwNJvRP_o77B5Y5D3mA@mail.gmail.com>
	<CAOQ4uxjTerAAxvjpDmDMQO363ju01MsEhbgBmHHSQb92hoL1_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjTerAAxvjpDmDMQO363ju01MsEhbgBmHHSQb92hoL1_g@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>, slp@redhat.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

* Amir Goldstein (amir73il@gmail.com) wrote:
> On Thu, Jan 7, 2021 at 10:44 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Jan 6, 2021 at 5:58 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Jan 06, 2021 at 02:40:45PM +0100, Miklos Szeredi wrote:
> >
> > > > @@ -901,6 +906,18 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > > >
> > > >      inode = lo_find(lo, &e->attr, mnt_id);
> > > >      if (inode) {
> > > > +        char buf1[PATH_MAX + 1], buf2[PATH_MAX + 1], procname[64];
> > > > +        ssize_t siz1, siz2;
> > > > +
> > > > +        sprintf(procname, "%i", inode->fd);
> > > > +        siz1 = readlinkat(lo->proc_self_fd, procname, buf1, sizeof(buf1));
> > > > +        sprintf(procname, "%i", newfd);
> > > > +        siz2 = readlinkat(lo->proc_self_fd, procname, buf2, sizeof(buf2));
> > > > +
> > > > +        /* disable close on unlink if alias is detected */
> > > > +        if (siz1 != siz2 || memcmp(buf1, buf2, siz1))
> > > > +            g_atomic_int_inc(&inode->opencount);
> > > > +
> > >
> > > Hi Miklos,
> > >
> > > So if I have a hard links to a file in a separate directories, then this
> > > path can hit. (Say dir1/file.txt and dir2/file-link.txt). IIUC, we will
> > > disable automatic inode->fd closing on these hardlinked files. That
> > > means this solution will not solve problem at hand for hard linked files.
> > > Am I missing something.
> >
> > You are correct, this is a limited solution.  The one above is a
> > corner case, and probably not worth worrying about too much.  However
> > it  can be fixed by having separate O_PATH fd's open for each alias
> > (or at least for each alias that resides in a distinct directory).
> >
> > NB: doing a synchronous FORGET on unlink does not solve this case
> > either, since the inode will not receive a FORGET until the last alias
> > is dropped.
> >
> > > >          close(newfd);
> > > >      } else {
> > > >          inode = calloc(1, sizeof(struct lo_inode));
> > > > @@ -917,6 +934,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> > > >           */
> > > >          g_atomic_int_set(&inode->refcount, 2);
> > > >
> > > > +        g_atomic_int_set(&inode->opencount, 0);
> > > >          inode->nlookup = 1;
> > > >          inode->fd = newfd;
> > > >          inode->key.ino = e->attr.st_ino;
> > > > @@ -1295,6 +1313,10 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
> > > >      res = unlinkat(lo_fd(req, parent), name, 0);
> > > >
> > > >      fuse_reply_err(req, res == -1 ? errno : 0);
> > > > +    if (!g_atomic_int_get(&inode->opencount)) {
> > > > +        close(inode->fd);
> > > > +        inode->fd = -1;
> > > > +    }
> > >
> > > Can this be racy w.r.t lo_lookup(). IOW, say dir1/file.txt is being
> > > unlinked and we closed inode->fd. And before we could execute
> > > unref_inode_lolocked(), another parallel lookup of dir2/file-link.txt
> > > happens if it gets lo->muxtex lock first, it can still find this
> > > inode and bump up reference count. And that means lo_unlink() will
> > > not free inode (but close inode->fd) and now we will use an inode
> > > with closed O_PATH fd which lead to other failures later.
> >
> > Yes, that's a bug.   Also needs serialization against all access to inode->fd.
> >
> 
> Miklos,
> 
> I would like to point out that this discussion is relevant to any low level
> fuse filesystem, but especially those that are proxying a real filesystem.
> 
> I have raised this question before in the FUSE_PASSTHROUGH threads.
> There is a lot of code duplication among various low-level fuse projects and
> as we get to NFS export support and complex issues like this one, is it
> getting unlikely that all projects will handle this correctly.
> 
> Do you think there is room for some more generic code in libfuse and if
> so how? Following an example implementation (assuming it gets fixed)
> and hand picking fixes to projects cannot scale for long.
> 
> The challenge is that most of the generic code would be in lookup and
> maintaining the internal inode cache, but each filesystem may need
> different representations of the Inode object.
> 
> I was thinking of something along the lines of an OO library that
> implements the generic lookup/inode cache for a base FuseInode class
> that implementers can inherit from.
> 
> This doesn't need to be in the libfuse project at all.
> Seeing the virtiofsd already has a Rust implementation that is BSD
> licensed, maybe that can be used as a starting point?
> 
> David,
> 
> How hard do you think it would be to re-factor virtiofsd-rs to
> an implementation that inherits from a base passthroughfsd-rs?
> 
> BTW, is virtiofsd-rs the offical virtiofsd or an experimental one?
> Which tree does Miklos' patch apply to?

The C version is the current main one, but the Rust version is catching
up fast and I hope it will displace the C one sometime this year.
Sergio owns the Rust version, cc'd (slp@ )

> Anyone has other thoughts about how to reduce fragmentation in
> implementations?
> 
> Thanks,
> Amir.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

