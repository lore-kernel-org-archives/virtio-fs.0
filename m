DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=poedFMv8Upe9WfpLaSv4Xs3tmMZabQcRbF6/V6jSqoA=;
	b=bYhAObIgpPX3Hf94JujMLWyfhMrwja0et8OoAyFbDwVRVdd3NhUbYG/R8+qx+t3rTD
	9XYn4JeGq5uTmn+vrti9Nb4w+LzbmWXjLlGCdKKDz3a33qhT/8nv/pVPFFtoO+igPeQq
	+J6CmHJh5+6zcKG3gygLNJCUtKh/7rsBh2bbbd2xFhs0ddQoR1bebtiF3SWiJJG7UAgy
	rljAKJA/Y8gC+cLlfb5+f63B/pooKfJFVLky/LI1AbCIlQ21ZnsD5dj0XT3RyWPAJs0O
	dmRFkvb3EXUbmIzQfELoPoXXHvzYokR4OpiFlHXQnvBCx/O+ywPPJO7WvyF74IQgJ/p4
	68Fg==
MIME-Version: 1.0
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
In-Reply-To: <20210104185655.GN2972@work-vm>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Jan 2021 06:29:11 +0200
Message-ID: <CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Mon, Jan 4, 2021 at 8:57 PM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> > > Hi,
> > >   On virtio-fs we're hitting a problem with NFS, where
> > > unlinking a file in a directory and then rmdir'ing that
> > > directory fails complaining about the directory not being empty.
> > >
> > > The problem here is that if a file has an open fd, NFS doesn't
> > > actually delete the file on unlink, it just renames it to
> > > a hidden file (e.g. .nfs*******).  That open file is there because
> > > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> > >
> > > Question:
> > >   a) In the FUSE protocol, are requests assumed to complete in order;
> > > i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> > > before the rmdir is processed?
> > >      (In virtiofs we've been processing requests, in parallel, and
> > > have sent forgets down a separate queue to keep them out of the way).
> > >
> > >   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> > > client to have finished it;  do we need a synchronous forget here?
> >
> > Even if we introduce a synchronous forget, will that really fix the
> > issue. For example, this could also happen if file has been unlinked
> > but it is still open and directory is being removed.
> >
> > fd = open(foo/bar.txt)
> > unlink foo/bar.txt
> > rmdir foo
> > close(fd).
> >
> > In this case, final forget should go after fd has been closed. Its
> > not a forget race.
> >
> > I wrote a test case for this and it works on regular file systems.
> >
> > https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c
> >
> > I suspect it will fail on nfs because I am assuming that temporary
> > file will be there till final close(fd) happens. If that's the
> > case this is a NFS specific issue because its behavior is different
> > from other file systems.
>
> That's true; but that's NFS just being NFS; in our case we're keeping
> an fd open even though the guest has been smart enough not to; so we're
> causing the NFS oddity when it wouldn't normally happen.
>

Are you sure that you really need this oddity?

My sense from looking virtiofsd is that the open O_PATH fd
in InodeData for non-directories are an overkill and even the need
for open fd for all directories is questionable.

If you store a FileHandle (name_to_handle_at(2)) instead of an open fd
for non-directories, you won't be keeping a reference on the underlying inode
so no unlink issue.

open_by_handle_at(2) is very cheap for non-directory when underlying inode
is cached and as cheap as it can get even when inode is not in cache, so no
performance penalty is expected.

Essentially, all the open fd gives you in pinning the underlying inode to cache
and I am not sure at all this is what you want to achieve.

Note that if virtifs wants to provide "proper" NFS support, where NFS
file handles
survive host reboot, you will need FUSE support for LOOKUP_HANDLE [1] and
then you don't even have to keep InodeData around until FORGET, but IMO
there is no reason to wait for LOOKUP_HANDLE before making the change above.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CAJfpegvNZ6Z7uhuTdQ6quBaTOYNkAP8W_4yUY4L2JRAEKxEwOQ@mail.gmail.com/

