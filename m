MIME-Version: 1.0
References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
	<CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
	<879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
In-Reply-To: <879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 7 May 2020 13:24:23 +0200
Message-ID: <CAOssrKd99kBf9ccc4xk_ZktO+Sc_+WvP0=wvVOXV7+Jgp8sTZA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 3/5] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <xanclic@xanclic.moe>

On Thu, May 7, 2020 at 1:16 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 07.05.20 11:56, Miklos Szeredi wrote:
> > On Wed, May 6, 2020 at 5:37 PM Max Reitz <mreitz@redhat.com> wrote:
> >>
> >> From: Max Reitz <xanclic@xanclic.moe>
>
> Oops.
>
> >> We want to allow submounts for the same fuse_conn, but with different
> >> superblocks so that each of the submounts has its own device ID.  To do
> >> so, we need to split all mount-specific information off of fuse_conn
> >> into a new fuse_mount structure, so that multiple mounts can share a
> >> single fuse_conn.
> >
> > I have the following high level comments:
> >
> > Control filesystem: each fuse_mount gets a new entry, but they are all
> > aliases.   I think we should just stick with just one entry for the
> > connection (and perhaps a symlink for each additional mount, but this
> > is of secondary importance).
>
> I have to admit that I didn’t spend much thought on any of this, but
> just went with what worked.  Since one of the functions in control.c
> require the super block, I went with fuse_mount.
>
> I suppose for fuse_ctl_add_conn() (for @name), we can simply use the
> first fuse_mount’s device ID.

Yes.

>
> > BDI:  we need to call set_bdi_congested/clear_bdi_congested for *all*
> > mounts of a connection.
>
> OK, then one entry per fuse_conn will work.
>
> But do we need to do the same in fuse_request_end() and
> fuse_request_queue_background()?

Definitely.  Otherwise one bdi could have its congestion state set,
and the other one cleared.  Not good.

Even better:  share the bdi between submounts.  This would make a lot
more sense and remove the need for loops.

>
> >                          Might make sense to look into getting rid of
> > bdi congestion handling completely, but this is not something I have a
> > good insight into right now.
> >
> > Notification: please create a fuse_ilookup() that takes fc and returns
> > (sb, inode) pair and call this instead ilookup5().   This way the loop
> > is moved to the place where it's actually necessary.
>
> Hm, sounds a bit cumbersome for the fuse_notify_* functions that don’t
> directly call ilookup5().  But they always have a callee that does, so I
> suppose I’ll just have to move that up to the caller.  That should work
> then.

I'd rather say: move the fc down to the callee.  The kill_sb mutex can
remain in fuse_conn, so callers shouldn't need an sb.

Thanks,
Miklos


