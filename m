Date: Tue, 11 May 2021 11:16:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210511151626.GC238488@horse>
References: <20210510155539.998747-1-groug@kaod.org>
	<20210510155539.998747-4-groug@kaod.org>
	<CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
	<20210511125409.GA234533@horse> <20210511144923.GA238488@horse>
	<CAOssrKeSBnDTa3SF0y49ZuoFMJPr1iq6KqzPCkXYmNsRxXP7vQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOssrKeSBnDTa3SF0y49ZuoFMJPr1iq6KqzPCkXYmNsRxXP7vQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Paolo Bonzini <pbonzini@redhat.com>

On Tue, May 11, 2021 at 05:08:42PM +0200, Miklos Szeredi wrote:
> On Tue, May 11, 2021 at 4:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Tue, May 11, 2021 at 08:54:09AM -0400, Vivek Goyal wrote:
> > > On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> > > > On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> > > > >
> > > > > Honor the expected behavior of syncfs() to synchronously flush all data
> > > > > and metadata on linux systems. Simply loop on all known submounts and
> > > > > call syncfs() on them.
> > > >
> > > > Why not pass the submount's root to the server, so it can do just one
> > > > targeted syncfs?
> > > >
> > > > E.g. somehting like this in fuse_sync_fs():
> > > >
> > > > args.nodeid = get_node_id(sb->s_root->d_inode);
> > >
> > > Hi Miklos,
> > >
> > > I think current proposal was due to lack of full understanding on my part.
> > > I was assuming we have one super block in client and that's not the case
> > > looks like. For every submount, we will have another superblock known
> > > to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
> > > for each of those super blocks. And that means file server does not
> > > have to keep track of submounts explicitly and it will either receive
> > > a single targeted SYNCFS (for the case of syncfs(fd)) or receive
> > > multile SYNCFS calls (one for each submount when sync() is called).
> >
> > Tried sync() with submounts enabled and we are seeing a SYNCFS call
> > only for top level super block and not for submounts.
> >
> > Greg noticed that it probably is due to the fact that iterate_super()
> > skips super blocks which don't have SB_BORN flag set.
> >
> > Only vfs_get_tree() seems to set SB_BORN and for our submounts we
> > are not calling vfs_get_tree(), hence SB_BORN is not set. NFS seems
> > to call vfs_get_tree() and hence SB_BORN must be set for submounts.
> >
> > Maybe we need to modify virtio_fs_get_tree() so that it can deal with
> > mount as well as submounts and then fuse_dentry_automount() should
> > probably call vfs_get_tree() and that should set SB_BORN and hopefully
> > sync() will work with it. Greg is planning to give it a try.
> >
> > Does it sound reasonable.
> 
> Just setting SB_BORN sounds much simpler.  What's the disadvantage?

I was little hesitant to set it directly because no other filesystem
seems to be doing it. Hence I assumed that VFS expects filesystems to
not set SB_BORN.

But I do agree that setting SB_BORN in automount code is much simpler
solution.

Thanks
Vivek

