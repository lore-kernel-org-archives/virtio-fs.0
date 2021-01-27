Date: Wed, 27 Jan 2021 11:20:23 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210127112023.0e97f909@bahia.lan>
In-Reply-To: <CAOssrKdh3kqKN4uGE=s5eiymd2MXKsRXUegqRH-TFhqYOK7WOA@mail.gmail.com>
References: <20210126103502.260758-1-stefanha@redhat.com>
	<20210126181604.1a4c69c6@bahia.lan>
	<CAOssrKdh3kqKN4uGE=s5eiymd2MXKsRXUegqRH-TFhqYOK7WOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>, P J P <ppandit@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, 27 Jan 2021 10:25:28 +0100
Miklos Szeredi <mszeredi@redhat.com> wrote:

> On Tue, Jan 26, 2021 at 6:18 PM Greg Kurz <groug@kaod.org> wrote:
> >
> > On Tue, 26 Jan 2021 10:35:02 +0000
> > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> 
> > The patch looks pretty good to me. It just seems to be missing a change in
> > lo_create():
> >
> >     fd = openat(parent_inode->fd, name, (fi->flags | O_CREAT) & ~O_NOFOLLOW,
> >                 mode);
> >
> > A malicious guest could have created anything called ${name} in this directory
> > before calling FUSE_CREATE and we'll open it blindly, or I'm missing something ?
> 
> Right, this seems like an omission.
> 
> Also the "& ~O_NOFOLLOW" looks like a copy-paste bug, since unlike
> lo_open(), lo_create() is not opening a proc symlink.
> 
> So that should be replaced with "| O_NOFOLLOW"
> 


Yes, I've realized that later on. We should definitely enforce O_NOFOLLOW
to avoid symlink escapes.

Then comes the case of special files... A well-known case is the FIFO that
causes openat() to block as described in my response. FWIW, we addressed
this one in 9P by adding O_NONBLOCK and fixing the flags to the client
expectation with fcntl(F_SETFL). But this is just a protection against
being blocked. Blindly opening a special file can lead to any kind of
troubles you can think of... so it really looks that the only sane way
to be safe from such an attack is to forbid openat() of special files at
the filesystem level.

> Thanks,
> Miklos
> 

