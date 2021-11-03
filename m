DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=JAPHh7CvtsrC2l0ncl5a6DyxiwK5Nhrc3UACjkOi0rk=;
	b=NlSd5wSnPLL7oAwF36xuylxrUqR/ulkXL+KhDYqppGFvYlqXbf1BIWlbSAL1xxqXXk
	9ROBxmaNffUXPU1Tubm9iXo6wLXhVFUnzAqt9L7O1ACkqhor0c0RjiKbzVdkpvIiOr+B
	EX42b9KvSgD7KX4W1OpTA3zfY25AMmFauqyTIMzzLd49ltOfvYQAYASfPq5C80qU44Dv
	whqxjCVYydAlXnDxhaaOOZXjfBzyRJEGtSTeF5UAgrMhj2QEFZvRLeTzPJMqMhpyklnk
	AfJFsLvgbHmDnCjbWE0L3/vps2kPBeeusgOgnk+U+6QYZmfCwLTF5HbTN8VMGF7wUlbE
	8IlQ==
MIME-Version: 1.0
References: <CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
	<CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
	<YXhIm3mOvPsueWab@redhat.com>
	<CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
	<20211027132319.GA7873@quack2.suse.cz> <YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
	<CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<YYGg1w/q31SC3PQ8@redhat.com>
In-Reply-To: <YYGg1w/q31SC3PQ8@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Nov 2021 09:31:02 +0200
Message-ID: <CAOQ4uxg_KAg34TgmVRQ5nrfgHddzQepVv_bAUAhqtkDfHB7URw@mail.gmail.com>
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
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

> > >
> >
> > What about group #1 that wants mask A and group #2 that wants mask B
> > events?
> >
> > Do you propose to maintain separate event queues over the protocol?
> > Attach a "recipient list" to each event?
> >
> > I just don't see how this can scale other than:
> > - Local marks and connectors manage the subscriptions on local machine
> > - Protocol updates the server with the combined masks for watched objects
> >
> > I think that the "post-mortem events" issue could be solved by keeping an
> > S_DEAD fuse inode object in limbo just for the mark.
> > When a remote server sends FS_IN_IGNORED or FS_DELETE_SELF for
> > an inode, the fuse client inode can be finally evicted.
>
> There is no guarantee that FS_IN_IGNORED or FS_DELETE_SELF will come
> or when will it come. If another guest has reference on inode it might
> not come for a long time. And this will kind of become a mechanism
> for one guest to keep other's inode cache full of such objects.
>
> If event queue becomes too full, we might drop these events. But I guess
> in that case we will have to generate IN_Q_OVERFLOW and that can somehow
> be used to cleanup such S_DEAD inodes?

That depends on the server implementation.
If the server is watching host fs using fanotify filesystem mark, then
an overflow
event does NOT mean that other new events on inode may be missed only
that old events could have been missed.
Server should know about all the watched inodes, so it can check on overflow
if any of the watched inodes were deleted and notify the client using a reliable
channel.

Given the current server implementation with inotify, IN_Q_OVERFLOW
means server may have lost an IN_IGNORED event and may not get any
more events on inode, so server should check all the watched inodes after
overflow, notify the client of all deleted inodes and try to re-create
the watches
for all inodes with known path or use magic /prod/pid/fd path if that
works (??).

>
> nodeid is managed by server. So I am assuming that FORGET messages will
> not be sent to server for this inode till we have seen FS_IN_IGNORED
> and FS_DELETE_SELF events?
>

Or until the application that requested the watch calls
inotify_rm_watch() or closes
the inotify fd.

IOW, when fs implements remote fsnotify, the local watch keeps the local deleted
inode object in limbo until the local watch is removed.
When the remote fsnotify server informs that the remote watch (or remote inode)
is gone, the local watch is removed as well and then the inotify
application also gets
an FS_IN_IGNORED event.

Lifetime of local inode is complicated and lifetime of this "shared inode"
is much more complicated, so I am not pretending to claim that I have this all
figured out or that it could be reliably done at all.

Thanks,
Amir.

