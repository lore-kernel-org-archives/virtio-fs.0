Date: Tue, 11 May 2021 08:54:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210511125409.GA234533@horse>
References: <20210510155539.998747-1-groug@kaod.org>
	<20210510155539.998747-4-groug@kaod.org>
	<CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
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

On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> >
> > Honor the expected behavior of syncfs() to synchronously flush all data
> > and metadata on linux systems. Simply loop on all known submounts and
> > call syncfs() on them.
> 
> Why not pass the submount's root to the server, so it can do just one
> targeted syncfs?
> 
> E.g. somehting like this in fuse_sync_fs():
> 
> args.nodeid = get_node_id(sb->s_root->d_inode);

Hi Miklos,

I think current proposal was due to lack of full understanding on my part.
I was assuming we have one super block in client and that's not the case
looks like. For every submount, we will have another superblock known
to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
for each of those super blocks. And that means file server does not
have to keep track of submounts explicitly and it will either receive
a single targeted SYNCFS (for the case of syncfs(fd)) or receive
multile SYNCFS calls (one for each submount when sync() is called).

If that's the case, it makes sense to send nodeid of the root dentry
of superblock and file server can just call syncfs(inode->fd).

Thanks
Vivek

