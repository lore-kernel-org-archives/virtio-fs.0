MIME-Version: 1.0
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
In-Reply-To: <CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 17 Oct 2019 15:01:08 +0200
Message-ID: <CAOssrKc7j5jvg9gSJdzOZOW8NWipWU+MKbonZ6Mv-1+TpENMxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Oct 17, 2019 at 1:23 PM Miklos Szeredi <mszeredi@redhat.com> wrote:

> I see why this is being done, and it's not easy to fix properly
> without the ..at() versions of these syscalls.  One idea is to fork()
> + fchdir(lo->proc_self_fd) + ..xattr().  Another related idea is to do
> a unshare(CLONE_FS) after each thread's startup (will pthread library

Apparently Samba does this, so it should be safe.

Thanks,
Miklos

