Date: Wed, 29 Apr 2020 11:00:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200429150038.GF231284@redhat.com>
References: <20200429124733.22488-1-mszeredi@redhat.com>
	<20200429143600.GE231284@redhat.com>
	<CAOssrKcOgP7eLo+uQdv==HssuqU3qpBKibvYAXypU88QXvypKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKcOgP7eLo+uQdv==HssuqU3qpBKibvYAXypU88QXvypKw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: jail lo->proc_self_fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Apr 29, 2020 at 04:47:19PM +0200, Miklos Szeredi wrote:
> On Wed, Apr 29, 2020 at 4:36 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Apr 29, 2020 at 02:47:33PM +0200, Miklos Szeredi wrote:
> > > While it's not possible to escape the proc filesystem through
> > > lo->proc_self_fd, it is possible to escape to the root of the proc
> > > filesystem itself through "../..".
> >
> > Hi Miklos,
> >
> > So this attack will work with some form of *at(lo->proc_self_fd, "../..")
> > call?
> 
> Right.
> 
> >
> > >
> > > Use a temporary mount for opening lo->proc_self_fd, that has it's root at
> > > /proc/self/fd/, preventing access to the ancestor directories.
> >
> > Does this mean that now similar attack can happen using "../.." on tmpdir
> > fd instead and be able to look at peers of tmpdir. Or it is blocked
> > due to mount point or something else.
> 
> No, because tmpdir is detached, the root of that tree will be the
> directory pointed to by the fd.  ".." will just lead to the same
> directory.

Aha.. got it. Thanks.

One more question. We seem to be using PID namespaces. Can't we mount
fresh instance of proc so that we don't see other processes apart from
virtiofd. May be we are already doing it. I have not checked it yet. If
yes, that should mitigate this concern?

Also noticed private proc patches upstream which should allow mounting
private instance of proc even without the need of separate PID namespace.

Thanks
Vivek

