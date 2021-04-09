Date: Fri, 9 Apr 2021 08:57:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210409125741.GA1111800@redhat.com>
References: <20210408175150.GA1053917@redhat.com>
	<CAJfpegvKDpa7g_LH=pBpEhwshoH94V8iRPL3Z+yxORnZDmNZvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvKDpa7g_LH=pBpEhwshoH94V8iRPL3Z+yxORnZDmNZvw@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC] Using hard links instead of lo_inode->fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>

On Fri, Apr 09, 2021 at 11:03:47AM +0200, Miklos Szeredi wrote:
> On Thu, Apr 8, 2021 at 7:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi All,
> >
> > Max has been trying to solve the problem of not having to keep an O_PATH
> > fd open for every file (until inode goes away). Lot of inodes can get
> > cached in guest inode cache and soon we can hit number of max fd limit.
> >
> > Today Christophe de Dinechin mentioned that can we maintain hardlinks
> > for these files and open these hardlinks instead whenever we need
> > lo_inode->fd.
> >
> > So say there is a notion of "workdir" which is passed to virtiofs where
> > virtiofsd can create hardlinks. Once inode comes into existence, we
> > create this link in workdir/<file-link>. Once last reference to inode
> > is dropped, workdir/<file-link> is removed.
> >
> > Now any operation which needs the lo_inode->fd, can do operation on
> > workdir/<file-link>.
> >
> > How does this proposal sound. What are the issues where. Some of the
> > which came to surface during discussion with david gilbert are.
> >
> > 1. links can't be created for directories. So this will only help with
> >   regular files.
> >
> > 2. There might be a performance penalty. We don't know yet.
> >
> > 3. More overhead of managing workdir by the user/tools.
> >
> >
> > Anything else? Is this a viable idea even if we can implement only
> > for regular files.
> 
> - nlink offset (this could be corrected)

Oh yes, extra nlink count will be there which will have to be corrected
in getattr().

> - needless ctime time update (hard to correct)

This can pose bigger problems. Sepecially if some operation does not
result in ctime update and it gets updated as a side affect of operating
on this link. In that case a user or a test might complain and that's
sort of hard to fix.  All this ctime/mtime/atime logic is already
pretty complicated to handle.

Thanks
Vivek

> 
> I guess this could be a fallback in case the filehandle stuff isn't
> working (e.g. because of an old host kernel).
> 
> Thanks.
> Miklos
> 

