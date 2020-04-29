MIME-Version: 1.0
References: <20200429124733.22488-1-mszeredi@redhat.com>
	<20200429143600.GE231284@redhat.com>
In-Reply-To: <20200429143600.GE231284@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 29 Apr 2020 16:47:19 +0200
Message-ID: <CAOssrKcOgP7eLo+uQdv==HssuqU3qpBKibvYAXypU88QXvypKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: jail lo->proc_self_fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Apr 29, 2020 at 4:36 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Apr 29, 2020 at 02:47:33PM +0200, Miklos Szeredi wrote:
> > While it's not possible to escape the proc filesystem through
> > lo->proc_self_fd, it is possible to escape to the root of the proc
> > filesystem itself through "../..".
>
> Hi Miklos,
>
> So this attack will work with some form of *at(lo->proc_self_fd, "../..")
> call?

Right.

>
> >
> > Use a temporary mount for opening lo->proc_self_fd, that has it's root at
> > /proc/self/fd/, preventing access to the ancestor directories.
>
> Does this mean that now similar attack can happen using "../.." on tmpdir
> fd instead and be able to look at peers of tmpdir. Or it is blocked
> due to mount point or something else.

No, because tmpdir is detached, the root of that tree will be the
directory pointed to by the fd.  ".." will just lead to the same
directory.

Thanks,
Miklos


