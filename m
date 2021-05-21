DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=b2Yr50BYJU/SZ0Vl8VXunqJwvs9CbxD4iLGD7Ur9faE=;
	b=oYxq7lybSyekzx5UKNcYJQmHIzn5CtgBTPN8lrpzcb5zWZ0SnQeuIYxp56u/5DPupU
	EuaXc/H+qQETT5Z8crVwhjTbt20vCWbLWNTW/tTMiUfxPI1fiHYaoJzXvdzJ5fOxlP8m
	8RWhkrwEIlfB+TcgNGR+6cj9wV6l2OiKJBKos=
MIME-Version: 1.0
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-2-groug@kaod.org>
	<YKa8SZ8s6QeKZ4XP@zeniv-ca.linux.org.uk>
	<CAJfpegvFUasy_8djyvo-fpyboOLGwRV9k_CL-e1nqxcXHkvzOg@mail.gmail.com>
	<20210521101523.4f276dac@bahia.lan>
In-Reply-To: <20210521101523.4f276dac@bahia.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 May 2021 10:23:47 +0200
Message-ID: <CAJfpegt8JS-9LsRhmw9W2VMNG+tc+gGNsSwy1ULLoSFeYpHueA@mail.gmail.com>
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
To: Greg Kurz <groug@kaod.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, 21 May 2021 at 10:15, Greg Kurz <groug@kaod.org> wrote:
>
> On Fri, 21 May 2021 09:54:19 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > On Thu, 20 May 2021 at 21:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > On Thu, May 20, 2021 at 05:46:50PM +0200, Greg Kurz wrote:
> > > > Some rollback was forgotten during the addition of crossmounts.
> > >
> > > Have you actually tested that?  Because I strongly suspect that
> > > by that point the ownership of fc and fm is with sb and those
> > > should be taken care of by deactivate_locked_super().
> >
> > Not quite.  Patch looks correct because destruction of fm is done in
> > fuse_put_super(), which only gets called if the sb initialization gets
> > as far as setting up sb->s_root, which only happens after the
> > successful fuse_fill_super_submount() call in this case.
> >
> > Doing the destruction from the various ->kill_sb() instances instead
> > of from ->put_super() would also fix this, but I'm not quite sure that
> > that would be any cleaner.
> >
>
> As saying in the answer I've just posted, a failure in
> fuse_fill_super_submount() causes an actual crash because
> fuse_mount_remove() logically assumes fm to already be in
> fc->mounts, which isn't the case at this point.
>
> In the root mount case, this is handled by taking back
> the ownership on fm, i.e. do the rollback *and* clear
> sb->s_fs_info. It seems that the same should be done
> for submounts.

Agreed.  Thanks for verifying.

Miklos

