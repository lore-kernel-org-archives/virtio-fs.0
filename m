DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=xkaKgbKgVPnQKltfqLoOIxWcevexdnojEsAfvaa10Ls=;
	b=OtCzJhsuFME0KIP4zTSLIg6MnMuWGnQZ7ILlT+B29UPpW63Ii71TIkDuih1V1hYxIF
	g1nJyCpbaFsp9EjFT22PR4Yc3fAt66PFRfZIB0wW2GrYomND2mXy8env4qn8rwDdYBXa
	P0IDPHyd0hfECnvybLPtWGHyxiL/f2D3uFTuM9ppBThsv1vb4QX8U4P3RdO2D8hkbA4Y
	Fb9RJzXchcVsZI1KgQjbzT++D3/n2wTJ9YqT4CDQ6V4UHqI1LASkBjXX7nCZXtCyDPKT
	D3AiX76ztAGPaTjxO0bZu0PGZGQEUWIVZs8bpoNd867FVXl0HfFaVxD0WMYpOI2E9uM2
	HXcw==
MIME-Version: 1.0
References: <YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
	<CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
	<CAOQ4uxjpGMYZrq74S=EaSO2nvss4hm1WZ_k+Xxgrj2k9pngJgg@mail.gmail.com>
	<YaZC+R7xpGimBrD1@redhat.com>
	<CAO17o21uh3fJHd0gMu-SmZei5et6HJo91DiLk_YyfUqrtHy2pQ@mail.gmail.com>
	<CAOQ4uxjfCs=+Of69U6moOJ9T6_zDb1wcrLXWu4DROVme1cNnfQ@mail.gmail.com>
	<YbobZMGEl6sl+gcX@redhat.com>
In-Reply-To: <YbobZMGEl6sl+gcX@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 15 Dec 2021 19:29:29 +0200
Message-ID: <CAOQ4uxj9XZNhHB3y9LuGcUJYp-i4f-LXQa2tzX8AkZpRERH+8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stef Bon <stefbon@gmail.com>

> >
> > The mistake in your premise at 1) is to state that "fuse does not
> > support persistent file handles"
> > without looking into what that statement means.
> > What it really means is that user cannot always open_by_handle_at()
> > from a previously
> > obtained file handle, which has obvious impact on exporting fuse to NFS (*).
>
> Hi Amir,
>
> What good is file handle if one can't use it for open_by_handle_at(). I
> mean, are there other use cases?

commit 44d705b0:
"...There are several ways that an application can use this information:

    1. When watching a single directory, the name is always relative to
    the watched directory, so application need to fstatat(2) the name
    relative to the watched directory.

    2. When watching a set of directories, the application could keep a map
    of dirfd for all watched directories and hash the map by fid obtained
    with name_to_handle_at(2).  When getting a name event, the fid in the
    event info could be used to lookup the base dirfd in the map and then
    call fstatat(2) with that dirfd.

    3. When watching a filesystem (FAN_MARK_FILESYSTEM) or a large set of
    directories, the application could use open_by_handle_at(2) with the fid
    in event info to obtain dirfd for the directory where event happened and
    call fstatat(2) with this dirfd.

    The last option scales better for a large number of watched directories.
    The first two options may be available in the future also for non
    privileged fanotify watchers, because open_by_handle_at(2) requires
    the CAP_DAC_READ_SEARCH capability.
"

fsnotifywait [1] has an example of use case #2.
Essentially, when watching inodes, the fanotify file identifier is not very much
different from the inotify "watch descriptor" - it identifies the watched object
and the watched object is pinned to cache as long as the inode mark is set
so file handle would not change also in fuse.

[1] https://github.com/inotify-tools/inotify-tools/pull/134

>
> IIUC, file handle for the same object can change if inode had been flushed
> out of guest cache and brought back in later. So if application say
> generated file handle for an object and saved it and later put a watch
> on that object, by that time file handle of the object might have changed
> (as seen by fuse). So one can't even use to match it with previous saved
> file handle.
>

The argument is not applicable for inode watches.
Filesystem and mount watches are not going to be supported with virtiofs
or any filesystem that does not support persistent file handles.

> So I can't use file handle for open_by_handle_at(). I can't use it to
> match it with previously saved file handle. So what can I use it for?
>
> IOW, I could not imagine supporting fanotify file handles without
> fixing the file handles properly in fuse. And it needs fixing in
> virtiofs as well as we can't trust random file handles from guest
> for regular files.
>

Partly correct statements, but when looking at the details, they are
not relevant to the case of fanotify inode watch.

Note that at the moment, fuse does not even support local fanotify
watch with file handles because of fanotify_test_fsid() - fuse does
not set f_fsid (not s_uuid), so it's not really about supporting fanotify
on fuse now.
It's about the vfs APIs for remote fsnotify that should not be inotify
specific.

Thanks,
Amir.

