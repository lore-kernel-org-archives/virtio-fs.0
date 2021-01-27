Date: Wed, 27 Jan 2021 16:09:20 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210127160920.062e47f0@bahia.lan>
In-Reply-To: <CAOssrKeN9iYT-Z46FVtzdKnWcTLfMqK77b1faf78m3XTXnEVGw@mail.gmail.com>
References: <20210126103502.260758-1-stefanha@redhat.com>
	<20210126181604.1a4c69c6@bahia.lan>
	<CAOssrKdh3kqKN4uGE=s5eiymd2MXKsRXUegqRH-TFhqYOK7WOA@mail.gmail.com>
	<20210127112023.0e97f909@bahia.lan>
	<CAOssrKfezsvcECQ=mO_4T2B09e+2S4LA3=_U6TQyiTtPbE=OYg@mail.gmail.com>
	<20210127144909.22dd778e@bahia.lan>
	<CAOssrKeN9iYT-Z46FVtzdKnWcTLfMqK77b1faf78m3XTXnEVGw@mail.gmail.com>
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

On Wed, 27 Jan 2021 15:09:50 +0100
Miklos Szeredi <mszeredi@redhat.com> wrote:

> On Wed, Jan 27, 2021 at 2:49 PM Greg Kurz <groug@kaod.org> wrote:
> >
> > On Wed, 27 Jan 2021 11:34:52 +0100
> > Miklos Szeredi <mszeredi@redhat.com> wrote:
> 
> > > Another solution specifically for O_CREAT without O_EXCL would be to
> > > turn it into an exclusive create.
> >
> > Would this added O_EXCL then appear on the client side, e.g. to
> > guest userspace doing fcntl(F_GETFL) ?
> 
> No.  Guest kernel keeps track of open flags.
> 

That was my impression as well as I didn't find a FUSE_GETFL request.
Thanks for confirming that !

> > > If that fails with EEXIST then try
> > > the normal open path (open with O_PATH, fstat, open proc symlink).  If
> >
> > open(O_PATH | O_NOFOLLOW) + fstatat(AT_EMPTY_PATH|AT_SYMLINK_NOFOLLOW)
> > would indeed allow to filter out anything that isn't a directory and
> > to safely open the proc symlink.
> >
> > > that fails with ENOENT, then retry the whole thing a certain number of
> >
> > Indeed someone could have unlinked the file in the meantime, in which
> > case the open(O_PATH | O_NOFOLLOW) would fail, but if it succeeds then
> > we cannot hit ENOENT anymore AFAICT.
> 
> Right.
> 
> > > times.  If it still fails then somebody is definitely messing with us
> > > and we can fail the request with EIO.
> > >
> >
> > Not sure what the retry+timeout is trying to mitigate here... why not
> > returning EIO right away ?
> 
> The semantics of O_CREATE are that it can fail neither because the
> file exists nor because it doesn't.  This doesn't matter if the
> exported tree is not modified outside of a single guest, because of
> locking provided by the guest kernel.
> 

Wrong. O_CREAT can legitimately fail with ENOENT if one element
of the pathname doesn't exist. And even if pathname only has
one element, you can still have O_CREAT to fail the same way
if the path of the parent directory is removed.

cat>enoent.c<<EOF
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	mkdir("foo", 0777);
	chdir("foo");
	rmdir("../foo");
	open("bar", O_CREAT);
}
EOF
make enoent
strace ./enoent

[...]

mkdir("foo", 0777)                      = 0
chdir("foo")                            = 0
rmdir("../foo")                         = 0
openat(AT_FDCWD, "bar", O_RDONLY|O_CREAT, 0117130) = -1 ENOENT (No such file or directory)

> However if we want to support shared access to a tree then O_CREAT
> semantics should work even in the face of races due to external
> modification of the tree.  I.e. following race:
> 

Yeah, handling shared access is where the fun starts :)

> virtiofsd: open(foo, O_CREAT | O_EXCL) -> EEXIST
> other task: unlink(foo)
> virtiofsd: open(foo, O_PATH | O_NOFOLLOW) -> ENOENT
> 
> To properly support the above the O_CREAT | O_EXCL open would need to
> be retried.
> 

But in this case, it seems fine to return ENOENT since
the guest userspace cannot really assume it never happens.

> Thanks,
> Miklos
> 

