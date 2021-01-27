MIME-Version: 1.0
References: <20210127112131.308451-1-stefanha@redhat.com>
	<CAOssrKfY7zDOH3NNbtyARHMCdJJN1tKQJri8ec=igjBf=K6Dog@mail.gmail.com>
	<20210127141430.GA310142@stefanha-x1.localdomain>
In-Reply-To: <20210127141430.GA310142@stefanha-x1.localdomain>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 27 Jan 2021 15:27:23 +0100
Message-ID: <CAOssrKdmpjMG1fVRJBBG7DKy4Fy46HaBz5gHvWZfOTy6FGF+6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: prevent opening of special
	files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jan 27, 2021 at 3:14 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Wed, Jan 27, 2021 at 02:01:54PM +0100, Miklos Szeredi wrote:

> > The problem here is there can also be a race between the open and the
> > subsequent lo_do_lookup().
> >
> > At this point it's probably enough to verify that fuse_entry_param
> > refers to the same object as the fh (using fstat and comparing st_dev
> > and st_ino).
>
> Can you describe the race in detail? FUSE_CREATE vs FUSE_OPEN?
> FUSE_CREATE vs FUSE_CREATE?

A race between FUSE_CREATE and external modification:

VIRTIOFSD: lo_create() {
VIRTIOFSD:     fd = open(foo, O_CREAT | O_EXCL)
EXTERNAL:  unlink(foo)
EXTERNAL:  open(foo, O_CREAT)
VIRTIOFSD:     lo_do_lookup() {
VIRTIOFSD:         newfd = open(foo, O_PATH | O_NOFOLLOW)

Nothing serious will happen, but there will be a discrepancy between
the open file and the inode that it references.  I.e.  the following
in the client will yield weird results:

open(foo, O_CREAT) -> fd
sprintf(procname, "/proc/self/fd/%i", fd);
open(procname, O_RDONLY) -> fd2
write(fd, buf, bufsize)
read(fd2, buf, bufsize)

This is probably not a security issue, more of a quality of
implementation issue.

Thanks,
Miklos

