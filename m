Date: Tue, 21 Apr 2020 15:31:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200421193153.GD28740@redhat.com>
References: <20200421184107.GC28740@redhat.com>
	<CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] overlayfs: Pass O_TRUNC flag to underlying
	filesystem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Apr 21, 2020 at 08:59:24PM +0200, Miklos Szeredi wrote:
> On Tue, Apr 21, 2020 at 8:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > As of now during open(), we don't pass bunch of flags to underlying
> > filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
> > calls ->setattr() with zero size and underlying filesystem sets file size
> > to 0.
> >
> > But when overlayfs is running on top of virtiofs, it has an optimization
> > where it does not send setattr request to server if dectects that
> > truncation is part of open(O_TRUNC). It assumes that server already zeroed
> > file size as part of open(O_TRUNC).
> >
> > fuse_do_setattr() {
> >         if (attr->ia_valid & ATTR_OPEN) {
> >                 /*
> >                  * No need to send request to userspace, since actual
> >                  * truncation has already been done by OPEN.  But still
> >                  * need to truncate page cache.
> >                  */
> >         }
> > }
> >
> > IOW, fuse expects O_TRUNC to be passed to it as part of open flags.
> >
> > But currently overlayfs does not pass O_TRUNC to underlying filesystem
> > hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
> > following does not zero the file size of a file is either upper only
> > or has already been copied up.
> >
> > fd = open(foo.txt, O_TRUNC | O_WRONLY);
> >
> > Fix it by passing O_TRUNC to underlying filesystem.
> 
> 
> Or clear ATTR_OPEN in ovl_setattr()
> 
> Need to think about side effects of passing O_TRUNC down to underlying
> fs.   Clearing ATTR_OPEN seems obviously safe, so as a quick fix I'd
> rather go with that for now.

Ok, I will send another patch which clears ATTR_OPEN in ovl_setattr().

Thanks
Vivek

