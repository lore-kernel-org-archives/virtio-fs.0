Date: Tue, 11 May 2021 17:08:26 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210511170826.73b0b663@bahia.lan>
In-Reply-To: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
References: <20210510155539.998747-1-groug@kaod.org>
	<20210510155539.998747-4-groug@kaod.org>
	<CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Cc: kvm@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Cornelia Huck <cohuck@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, "Michael
	S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, 11 May 2021 14:31:14 +0200
Miklos Szeredi <mszeredi@redhat.com> wrote:

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
> 
> Thanks,
> Miklos
> 

As Vivek already pointed out, there was some misunderstanding on
how submounts were supposed to work. Things got clearer since then :)

So, basically, we have two cases:

1) virtiofsd announces submounts : the d_automount implementation
   creates a new super block and mounts the submount

2) virtiofsd doesn't announce submounts: the client only knows
   about the top-level super block

You suggestion is for case 1) while this series was made with
case 2) in mind, hence the tracking of the super blocks in
the server.

Vivek and I discussed and agreed to address 2) later and
to just focus on 1) for now.

Your suggestion doesn't work with the current code base
because ->sync_fs() is never called on our submounts'
super blocks. This is because they don't have SB_BORN
set, which looks incorrect. A call to vfs_get_tree() would
fix it, but some code refactoring is needed in
fuse_dentry_automount() and virtio_fs_get_tree() for that.

Cheers,

--
Greg

