DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=antUMEgQu5AN/kNJmEOtbmAwcQ7siqDvZ8GUdsP/QaE=;
	b=oRohn4uzfqM7ljesaWe15EzZ29DQbBVWYe/kd/L9PcExIDhgg6IApC+3B6TQCDFj86
	sYzKiyN4YHLYSTOLzdc2048h0vsCuN6KYMmddq7+u78U8vgbjAbNvPbuZzlUbwkd5JHZ
	P+h5EVCgq831tpCY/JkjBH5INoaoNYL9W3g2gcGFbk80C5fkwIHkV1VGa1P2oy+4sdf1
	u4dgL+rhc8DSigypuKf7b6xIsrwoN5z5oxLDHKchrgWyOqrtJKwxhXkF9KOsCyDUaMGP
	G+AhAqecpQ08MxDmmiZorZuIFXrCCDbfQ0K2bcWRi7h+WFsInpycIiEBcOfuS5gsdTGx
	FD4A==
MIME-Version: 1.0
References: <20211027132319.GA7873@quack2.suse.cz>
	<YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
	<CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<20211103100900.GB20482@quack2.suse.cz>
	<CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
From: Stef Bon <stefbon@gmail.com>
Date: Tue, 16 Nov 2021 06:09:41 +0100
Message-ID: <CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

Hi Ioannis,

I see that you have been working on making fsnotify work on virtiofs.
Earlier you contacted me since I've written this:

https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE

and send you my patches on 23 june.
I want to mention first that I would have appreciated it if you would
have reacted to me after I've sent you my patches. I did not get any
reaction from you. Maybe these patches (which differ from what you
propose now, but there is also a lot in common) have been an
inspiration for you.

Second, what I've written about is that with network filesystems (eg a
backend shared with other systems) fsnotify support in FUSE has some
drawbacks.
In a network environment, where a network fs is part of making people
collaborate, it's very useful to have information on who did what on
which host, and also when. Simply a message "a file has been created
in the folder you watch" is not enough. For example, if you are part
of a team, and assigned to your team is a directory on a server where
you can work on some shared documents. Now in this example there is a
planning, and some documents have to be written. In that case you want
to be informed that someone in your team has started a document (by
creating it) by the system.

This "extended" information will never get through fsnotify.

Other info useful to you as team member:

-  you have become member of another team: sbon@anotherteam.example.org
-  diskspace and/or quota shortage reported by networksystem
-  new teammember, teammember left
-  your "rights" or role in the network/team have been changed (for
example from reader to reader and writer to some documents)

What I want to say is that in a network where lots of people work
together in teams/projects, (and I want Linux to play a role there, as
desktop/workstation) communication is very important, and all these
messages should be supported by the system. My idea is the support of
watching fs events with FUSE filesystems should go through userspace,
and not via the kernel (cause fs events are part of your setup in the
network, together with all other tools to make people collaborate like
chat/call/text, and because mentioned above extended info about the
who on what host etc is not supported by fsnotify).
There should be a fs event watcher which takes care of all watches on
behalf of applications during a session, similar to gamin and FAM once
did (not used anymore?).
When receiving a request from one of the applications this fsevent
watcher will use inotify and/or fanotify for local fs's only. With a
FUSE fs, it should contact (via a socket) this fs that a watch has
been set on an inode with a certain mask.
If the FUSE fs does not support this, fallback on normal inotify/fanotify.
This way extended info is possible.

Is this extended information also useful for virtiofs?

Stef Bon

