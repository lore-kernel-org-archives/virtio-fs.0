DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=omPGHcZQOamvxruFWJbitibaFxtFGC3+SEZUecILkcU=;
	b=JRRgF2gWZl43etxwl1b8rEI6btrcMR3sK2fTidwaWvnPbgpHDPxyPSi30GoGNoacF/
	swnNC5X7ZCBk6dDUJ+ZWfYHUbPZLD6twOoRqiBjVX0KnQot/BPVzBcfNmwVHfZVjkl8D
	NwjUe9gJ/2nZNPVRW1G2WfThaWcNKwkWltg/NCAGXR9Nc3Vb0BH3MhVakQCEBYylClyD
	Sl0ciRhdutKxTwc6tksCj3yKaf9lbFvyxQIKb5JKP2vcQVTfZblGbvWZ25XGNhR0oh+j
	nKa7LOKQdf6kcDxwDDRoA4C01yoymNtuzxj1Itd+qR2/S1EBlBZac8WHw4hjD7QMEppg
	eksQ==
MIME-Version: 1.0
References: <CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
	<20211027132319.GA7873@quack2.suse.cz> <YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
	<CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<20211103100900.GB20482@quack2.suse.cz>
	<CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
In-Reply-To: <YYU/7269JX2neLjz@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Nov 2021 08:28:13 +0200
Message-ID: <CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
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

> > OK, so do I understand both you and Amir correctly that you think that
> > always relying on the FUSE server for generating the events and just piping
> > them to the client is not long-term viable design for FUSE? Mostly because
> > caching of modifications on the client is essentially inevitable and hence
> > generating events from the server would be unreliable (delayed too much)?

This is one aspect, but we do not have to tie remote notifications to
the cache coherency problem that is more complicated.

OTOH, if virtiofs take the route of "remote groups", why not take it one step
further and implement "remote event queue".
Then, it does not need to push event notifications from the server
into fsnotify at all.
Instead, FUSE client can communicate with the server using ioctl or a new
command to implement new_group() that returns a special FUSE file and
use FUSE POLL/READ to check/read the server's event queue.

There is already a precedent of this model with CIFS_IOC_NOTIFY
and SMB2_CHANGE_NOTIFY - SMB protocol, samba server and Windows server
support watching a directory or a subtree. I think it is a "oneshot" watch, so
there is no polling nor queue involved.

>
> So initial implementation could be about, application either get local
> events or remote events (based on filesystem). Down the line more
> complicated modes can emerge where some combination of local and remote
> events could be generated and applications could specify it. That
> probably will be extension of fanotiy/inotify API.
>

There is one more problem with this approach.
We cannot silently change the behavior of existing FUSE filesystems.
What if a system has antivirus configured to scan access to virtiofs mounts?
Do you consider it reasonable that on system upgrade, the capability of
adding local watches would go away?

I understand the desire to have existing inotify applications work out of
the box to get remote notifications, but I have doubts if this goal is even
worth pursuing. Considering that the existing known use case described in this
thread is already using polling to identify changes to config files on the host,
it could just as well be using a new API to get the job done.

If we had to plan an interface without considering existing applications,
I think it would look something like:

#define FAN_MARK_INODE                                 0x00000000
#define FAN_MARK_MOUNT                               0x00000010
#define FAN_MARK_FILESYSTEM                      0x00000100
#define FAN_MARK_REMOTE_INODE                0x00001000
#define FAN_MARK_REMOTE_FILESYSTEM     0x00001100

Then, the application can choose to add a remote mark with a certain
event mask and a local mark with a different event mask without any ambiguity.
The remote events could be tagged with a flag (turn reserved member of
fanotify_event_metadata into flags).

We have made a lot of effort to make fanotify a super set of inotify
functionality removing old UAPI mistakes and baggage along the way,
so I'd really hate to see us going down the path of ambiguous UAPI
again.

IMO, the work that Ioannis has already done to support remote
notifications with virtiofsd is perfectly valid as a private functionality
of virtiofs, just like cifs CIFS_IOC_NOTIFY.

If we want to go further and implement a "remote notification subsystem"
then I think we should take other fs (e.g.cifs) into consideration and think
about functionality beyond the plain remote watch and create an UAPI
that can be used to extend the functionality further.

Thanks,
Amir.

