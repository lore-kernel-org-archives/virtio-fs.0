Date: Thu, 17 Oct 2019 11:25:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191017152522.GB12588@redhat.com>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Oct 17, 2019 at 01:23:57PM +0200, Miklos Szeredi wrote:
> On Thu, Oct 17, 2019 at 12:05 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Wed, Oct 16, 2019 at 07:37:52PM +0900, Misono Tomohiro wrote:
> > > Hello,
> > >
> > > I test xattr operation on virtiofs using xfstest generic/062
> > > (with -o xattr option and XFS backend) and see some problems.
> > >
> > > These patches fixes the two of the problems.
> > >
> > > The remaining problems are:
> > >  1. we cannot xattr to block device created by mknod
> > >     which does not have actual device (since open in virtiofsd fails)
> > >  2. we cannot xattr to symbolic link
> > >
> > > I don't think 1 is a big problem but can we fix 2?
> >
> > Sorry, I don't know the answer.  Maybe it would be necessary to add a
> > new O_SYMLINK open flag to open(2) so that fgetxattr()/fsetxattr()
> > operations can be performed.  A kernel change like that would take some
> > time to get accepted upstream and shipped by distros, but it might be
> > the only way since the current syscall interface doesn't seem to offer a
> > way to do this.
> 
> The real problem is that open() on a non-regular, non-directory file
> may have side effects (unless O_PATH is used).  These patches try to
> paper over that, but the fact is: opening special files from a file
> server is forbidden.
> 
> I see why this is being done, and it's not easy to fix properly
> without the ..at() versions of these syscalls.  One idea is to fork()
> + fchdir(lo->proc_self_fd) + ..xattr().  Another related idea is to do
> a unshare(CLONE_FS) after each thread's startup (will pthread library
> balk?  I don't know) so that it's safe to do fchdir(lo->proc_self_fd)
> + ...xattr() + fchdir(lo->root_fd).

Hi Miklos,

Trying to understand your proposal. So if we want to do an ..xattr()
operation on a special file (and we don't have _at() variants), how
will fchdir() help. Are you suggesting fchdir() to parent and then
do something special.

Can you please elaborate your proposal a bit more. I think I have
missed the core idea completely.

I understand that you want to do unshare(CLONE_FS) to make sure one thrad's
fchdir() does not impact other thread. But did not understand that how
fchdir() alone is enough to do getxattr()/setxattr() on special file.

Thanks
Vivek

