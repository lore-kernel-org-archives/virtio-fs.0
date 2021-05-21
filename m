DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=yA7Lkm/nXDMCfmn4EBtAJW5GRrIK88MdQhqjgo97iYc=;
	b=C18mRKWikKVx1cic8io2JbRa79yx/52/8m0xFuj1FZsu7EuOsgMlp9RDIqjkJ+sDKC
	1POBz/VL0Z4NxyJd14bYcBLpZn4v8THFtAPLJ+E2T4udz4+QjiUwEUyd9zjffvf160LC
	cDP3k4gS2MBFFOQBoNEmuTWqlLYwdQrXg1XDE=
MIME-Version: 1.0
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-2-groug@kaod.org>
	<YKa8SZ8s6QeKZ4XP@zeniv-ca.linux.org.uk>
In-Reply-To: <YKa8SZ8s6QeKZ4XP@zeniv-ca.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 May 2021 09:54:19 +0200
Message-ID: <CAJfpegvFUasy_8djyvo-fpyboOLGwRV9k_CL-e1nqxcXHkvzOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 1/5] fuse: Fix leak in
	fuse_dentry_automount() error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

On Thu, 20 May 2021 at 21:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, May 20, 2021 at 05:46:50PM +0200, Greg Kurz wrote:
> > Some rollback was forgotten during the addition of crossmounts.
>
> Have you actually tested that?  Because I strongly suspect that
> by that point the ownership of fc and fm is with sb and those
> should be taken care of by deactivate_locked_super().

Not quite.  Patch looks correct because destruction of fm is done in
fuse_put_super(), which only gets called if the sb initialization gets
as far as setting up sb->s_root, which only happens after the
successful fuse_fill_super_submount() call in this case.

Doing the destruction from the various ->kill_sb() instances instead
of from ->put_super() would also fix this, but I'm not quite sure that
that would be any cleaner.

Thanks,
Miklos

