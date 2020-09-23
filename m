DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=GzRR1ysSaWjNtFgJbYEfyQF+CN5vyeaGU7wBKheufCw=;
	b=IDtdgFcde2WgPp7Rh52MRzckZFR+GJrTzypcbDtbBe0s0qtEdH/NzA8dXdYwnVVY21
	kuQjVOmXj04mNbX7MHg6Nq7wF8HlkDKhwP6FRKMei5av2s86LWkb3F/plfi2L2NxT3uM
	qv2Jui8zHr11viqyRYzt5FZEQEB1uR16sFxsQ=
MIME-Version: 1.0
References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
	<e87d7603-100b-173a-07c6-3ef4c2400e94@redhat.com>
In-Reply-To: <e87d7603-100b-173a-07c6-3ef4c2400e94@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Sep 2020 19:15:46 +0200
Message-ID: <CAJfpegt-BOG7Xz4Xyy4OEnK+2EPGQ61e4qk7WBKUVjQN4yAiSw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 0/9] fuse: Mirror virtio-fs
	submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

On Wed, Sep 23, 2020 at 5:45 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 18.09.20 17:25, Miklos Szeredi wrote:
> > Pushed an updated version to fuse.git#submounts.
> >
> > Also attached incremental patch (against rebase of
> > virtiofs-submounts-v2 on fuse.git#for-next).
> >
> > Changes:
> >
> >  1) rebased on top of DAX patches
> >  2) fixed CUSE
> >  3) added locking for fc->mounts list
> >  4) dissociate lifetime of fc from lifetime of root mount
> >  5) do not hash mountpoint inodes
> >  6) add FUSE_SUBMOUNTS init flag (replaces FUSE_ATTR_FLAGS but
> > slightly different usage)
> >  7) various cleanups
> >
> > Note, the effect of 5 can only be observed if the same directory is
> > bind mounted into multiple places:
> >
> > HOST:
> > cd /mnt
> > mkdir 1 2
> > mount --bind /dev/shm 1
> > mount --bind /dev/shm 2
> >
> > GUEST:
> > mount -t virtiofs mnt /mnt
> > cd /mnt/1
> > ls ../2
> > /bin/pwd
> >
> > If the mountpoint is hashed, then the "ls ../2" will basically result
> > in /mnt/1 inode being moved to /mnt/2, which is not what we want.  I
> > don't think there's any negative side effect of the mountpoint being
> > unhashed, but this is a bit subtle.
> >
> >
> > On the server side, keying on just st_ino/st_dev is a really crude way
> > of mapping out mounts.  Take this example:
> >
> > HOST:
> > cd /mnt
> > mkdir 1
> > mount --bind /dev/shm 1
> > cd 1
> > mkdir 2
> > mount --bind /mnt 2
> > ls /mnt/1/2/1
> >
> > GUEST:
> > mount -t virtiofs mnt /mnt
> > ls /mnt/1/2/1
> > 2
> > ls /mnt/1/2/1/2/1/2/1/
> > 2
> >
> > So what we really need is keying on mount ID as well.
> >
> > Attaching an incremental patch to do that.  Needs v5.8 kernel on host
> > to actually make a difference, but commit fa2fcf4f1df1 ("statx: add
> > mount ID") is trivial to backport to any kernel that has statx.
> >
> > Please review and test.  If there are no major issues, this should be
> > good to go for v5.10.
>
> As for the virtiofsd patch, I wonder about:
>
> > #if 0 && defined(HAVE_STATX) && STATX_MNT_ID
>
> Shouldn’t the 0 not be there?  And should STATX_MNT_ID be wrapped in
> defined()?

Right, that was left there from testing.

> Furthermore I wonder why you have removed the parent_dev logic.  With
> your patch, FUSE_ATTR_SUBMOUNT can be announced only by those functions
> that invoke lo_do_lookup().  Is it OK to do so only there, and not every
> time a fuse_attr is returned (be it as part of fuse_entry_out, as by
> lo_link(), or directly by lo_getattr())?

No, object creation never results in a mounted object.  If the newly
created object is mounted on at a later time, the revalidate logic
will take care of that.

> (Also, the virtiofsd series will need a bit of an update with
> FUSE_SUBMOUNTS replacing FUSE_ATTR_FLAGS.)
>

Yes,

Thanks,
Miklos


