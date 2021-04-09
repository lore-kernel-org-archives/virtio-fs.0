DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=XJPwfSKzi57Dw3dJ8A4injg9NAk3xkk4/1KbT0wClks=;
	b=Z/zAs+g+HS181dm7vLrcjpYq81yaSlpCyX50cVMDjRhLx2bgHkyKAoHKxghYn97WH2
	c/as8BQ4IPdslXmgKPzQ4mBKbtVFK4e7u2vQ88qd8Ti9Hs+HYreyYWrNX22fnsaroo9a
	vlfy/q0BC0kJqkH5ie1de9qSJgiF/ojpaAuxU=
MIME-Version: 1.0
References: <20210408175150.GA1053917@redhat.com>
In-Reply-To: <20210408175150.GA1053917@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 9 Apr 2021 11:03:47 +0200
Message-ID: <CAJfpegvKDpa7g_LH=pBpEhwshoH94V8iRPL3Z+yxORnZDmNZvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC] Using hard links instead of lo_inode->fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>

On Thu, Apr 8, 2021 at 7:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi All,
>
> Max has been trying to solve the problem of not having to keep an O_PATH
> fd open for every file (until inode goes away). Lot of inodes can get
> cached in guest inode cache and soon we can hit number of max fd limit.
>
> Today Christophe de Dinechin mentioned that can we maintain hardlinks
> for these files and open these hardlinks instead whenever we need
> lo_inode->fd.
>
> So say there is a notion of "workdir" which is passed to virtiofs where
> virtiofsd can create hardlinks. Once inode comes into existence, we
> create this link in workdir/<file-link>. Once last reference to inode
> is dropped, workdir/<file-link> is removed.
>
> Now any operation which needs the lo_inode->fd, can do operation on
> workdir/<file-link>.
>
> How does this proposal sound. What are the issues where. Some of the
> which came to surface during discussion with david gilbert are.
>
> 1. links can't be created for directories. So this will only help with
>   regular files.
>
> 2. There might be a performance penalty. We don't know yet.
>
> 3. More overhead of managing workdir by the user/tools.
>
>
> Anything else? Is this a viable idea even if we can implement only
> for regular files.

- nlink offset (this could be corrected)
- needless ctime time update (hard to correct)

I guess this could be a fallback in case the filehandle stuff isn't
working (e.g. because of an old host kernel).

Thanks.
Miklos

