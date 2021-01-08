Date: Fri, 8 Jan 2021 10:55:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210108155506.GD46319@redhat.com>
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 06, 2021 at 11:16:28AM +0200, Amir Goldstein wrote:
> On Wed, Jan 6, 2021 at 10:02 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Jan 6, 2021 at 5:29 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Jan 4, 2021 at 8:57 PM Dr. David Alan Gilbert
> > > <dgilbert@redhat.com> wrote:
> > > >
> > > > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > > > On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> > > > > > Hi,
> > > > > >   On virtio-fs we're hitting a problem with NFS, where
> > > > > > unlinking a file in a directory and then rmdir'ing that
> > > > > > directory fails complaining about the directory not being empty.
> > > > > >
> > > > > > The problem here is that if a file has an open fd, NFS doesn't
> > > > > > actually delete the file on unlink, it just renames it to
> > > > > > a hidden file (e.g. .nfs*******).  That open file is there because
> > > > > > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> > > > > >
> > > > > > Question:
> > > > > >   a) In the FUSE protocol, are requests assumed to complete in order;
> > > > > > i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> > > > > > before the rmdir is processed?
> > > > > >      (In virtiofs we've been processing requests, in parallel, and
> > > > > > have sent forgets down a separate queue to keep them out of the way).
> > > > > >
> > > > > >   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> > > > > > client to have finished it;  do we need a synchronous forget here?
> > > > >
> > > > > Even if we introduce a synchronous forget, will that really fix the
> > > > > issue. For example, this could also happen if file has been unlinked
> > > > > but it is still open and directory is being removed.
> > > > >
> > > > > fd = open(foo/bar.txt)
> > > > > unlink foo/bar.txt
> > > > > rmdir foo
> > > > > close(fd).
> > > > >
> > > > > In this case, final forget should go after fd has been closed. Its
> > > > > not a forget race.
> > > > >
> > > > > I wrote a test case for this and it works on regular file systems.
> > > > >
> > > > > https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c
> > > > >
> > > > > I suspect it will fail on nfs because I am assuming that temporary
> > > > > file will be there till final close(fd) happens. If that's the
> > > > > case this is a NFS specific issue because its behavior is different
> > > > > from other file systems.
> > > >
> > > > That's true; but that's NFS just being NFS; in our case we're keeping
> > > > an fd open even though the guest has been smart enough not to; so we're
> > > > causing the NFS oddity when it wouldn't normally happen.
> > > >
> > >
> > > Are you sure that you really need this oddity?
> > >
> > > My sense from looking virtiofsd is that the open O_PATH fd
> > > in InodeData for non-directories are an overkill and even the need
> > > for open fd for all directories is questionable.
> > >
> > > If you store a FileHandle (name_to_handle_at(2)) instead of an open fd
> > > for non-directories, you won't be keeping a reference on the underlying inode
> > > so no unlink issue.
> > >
> > > open_by_handle_at(2) is very cheap for non-directory when underlying inode
> > > is cached and as cheap as it can get even when inode is not in cache, so no
> > > performance penalty is expected.
> >
> > You are perfectly right that using file handles would solve a number
> > of issues, one being too many open file descriptors.
> >
> > The issue with open_by_handle_at(2) is that it needs
> > CAP_DAC_READ_SEARCH in the initial user namespace. That currently
> > makes it impossible to use in containers and such.
> 
> Is that a problem for virtiofsd? does it also run inside a container??

Yes, there have been cases where virtiofsd is running inside container.
For the same reason stefan introduced patches to not setup all the
namespace by the daemon. It will be setup by the container manager.
And container manager wants to give minimum privilige to virtiofsd
container (same capabilities as any other standard container) by
default.

Vivek

> 
> Please note that NFS doesn't do "silly rename" for directories,
> so mitigation is mostly needed for non-dir.
> 
> An alternative method if daemon is not capable, is to store parent dirfd
> in addition to filehandle and implement open_child_by_handle_at(int
> parent_fd, ...):
> - readdir(parend_fd)
> - search a match for d_ino
> - name_to_handle_at() and verify match to stored filehandle
> 
> This is essentially what open_by_handle_at(2) does under the covers
> with a "connectable" non-dir filehandle after having resolved the
> parent file handle part. And "connectable" file handles are used by nfsd
> to enforce "subtree_check" to make sure that file wasn't moved outside
> obtainable path after initial lookup.
> 
> >
> > Not sure if there has been proposals for making open_by_handle_at(2)
> > usable in user namespaces.
> 
> I don't remember seeing any.
> 
> > The difficulty is in verifying that an
> > open file would have been obtainable by path lookup by the given user.
> 
> I think it can be allowed for user with CAP_DAC_READ_SEARCH in
> userns for FS_USERNS_MOUNT mounted in that userns.
> 
> Thanks,
> Amir.
> 

