DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=sS6sU2hxsohQJyr9pgbWzwKvPMtWUFghCSGzUfHxezQ=;
	b=EeOvMuh4Qh5tzED33iXPIEwpp8u5EGP0KAtSScRccMJ9r33G+t7Ot6UGSvjFjWokp4
	2L2q7R5uIv98YDdPGeZ7LvwhyTkgQE/z+vQTZYFw7skXf0xeDSlkNkbZvfHwMBbB5Hj5
	qL5QaO5FmmnSuf0CvuKBRj214p9Sq1YNwoEN4=
MIME-Version: 1.0
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Jan 2021 09:01:53 +0100
Message-ID: <CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jan 6, 2021 at 5:29 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jan 4, 2021 at 8:57 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> > > > Hi,
> > > >   On virtio-fs we're hitting a problem with NFS, where
> > > > unlinking a file in a directory and then rmdir'ing that
> > > > directory fails complaining about the directory not being empty.
> > > >
> > > > The problem here is that if a file has an open fd, NFS doesn't
> > > > actually delete the file on unlink, it just renames it to
> > > > a hidden file (e.g. .nfs*******).  That open file is there because
> > > > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> > > >
> > > > Question:
> > > >   a) In the FUSE protocol, are requests assumed to complete in order;
> > > > i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> > > > before the rmdir is processed?
> > > >      (In virtiofs we've been processing requests, in parallel, and
> > > > have sent forgets down a separate queue to keep them out of the way).
> > > >
> > > >   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> > > > client to have finished it;  do we need a synchronous forget here?
> > >
> > > Even if we introduce a synchronous forget, will that really fix the
> > > issue. For example, this could also happen if file has been unlinked
> > > but it is still open and directory is being removed.
> > >
> > > fd = open(foo/bar.txt)
> > > unlink foo/bar.txt
> > > rmdir foo
> > > close(fd).
> > >
> > > In this case, final forget should go after fd has been closed. Its
> > > not a forget race.
> > >
> > > I wrote a test case for this and it works on regular file systems.
> > >
> > > https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c
> > >
> > > I suspect it will fail on nfs because I am assuming that temporary
> > > file will be there till final close(fd) happens. If that's the
> > > case this is a NFS specific issue because its behavior is different
> > > from other file systems.
> >
> > That's true; but that's NFS just being NFS; in our case we're keeping
> > an fd open even though the guest has been smart enough not to; so we're
> > causing the NFS oddity when it wouldn't normally happen.
> >
>
> Are you sure that you really need this oddity?
>
> My sense from looking virtiofsd is that the open O_PATH fd
> in InodeData for non-directories are an overkill and even the need
> for open fd for all directories is questionable.
>
> If you store a FileHandle (name_to_handle_at(2)) instead of an open fd
> for non-directories, you won't be keeping a reference on the underlying inode
> so no unlink issue.
>
> open_by_handle_at(2) is very cheap for non-directory when underlying inode
> is cached and as cheap as it can get even when inode is not in cache, so no
> performance penalty is expected.

You are perfectly right that using file handles would solve a number
of issues, one being too many open file descriptors.

The issue with open_by_handle_at(2) is that it needs
CAP_DAC_READ_SEARCH in the initial user namespace. That currently
makes it impossible to use in containers and such.

Not sure if there has been proposals for making open_by_handle_at(2)
usable in user namespaces.  The difficulty is in verifying that an
open file would have been obtainable by path lookup by the given user.

Thanks,
Miklos

