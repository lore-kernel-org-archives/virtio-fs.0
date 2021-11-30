Date: Tue, 30 Nov 2021 10:36:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YaZFDS2u5PBoUvkl@redhat.com>
References: <CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<20211103100900.GB20482@quack2.suse.cz>
	<CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com>
	<20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stef Bon <stefbon@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Nov 16, 2021 at 06:09:41AM +0100, Stef Bon wrote:
> Hi Ioannis,
> 
> I see that you have been working on making fsnotify work on virtiofs.
> Earlier you contacted me since I've written this:
> 
> https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE
> 
> and send you my patches on 23 june.
> I want to mention first that I would have appreciated it if you would
> have reacted to me after I've sent you my patches. I did not get any
> reaction from you. Maybe these patches (which differ from what you
> propose now, but there is also a lot in common) have been an
> inspiration for you.

Hi Stef,

Sorry about not giving you the credit you deserved. We definitely made
a mistake here. We will be more careful in future and not repeat such
things.

> 
> Second, what I've written about is that with network filesystems (eg a
> backend shared with other systems) fsnotify support in FUSE has some
> drawbacks.
> In a network environment, where a network fs is part of making people
> collaborate, it's very useful to have information on who did what on
> which host, and also when. Simply a message "a file has been created
> in the folder you watch" is not enough. For example, if you are part
> of a team, and assigned to your team is a directory on a server where
> you can work on some shared documents. Now in this example there is a
> planning, and some documents have to be written. In that case you want
> to be informed that someone in your team has started a document (by
> creating it) by the system.
> 
> This "extended" information will never get through fsnotify.

Wondering fsnotify can be extended to carry this info when available.

> 
> Other info useful to you as team member:
> 
> -  you have become member of another team: sbon@anotherteam.example.org
> -  diskspace and/or quota shortage reported by networksystem
> -  new teammember, teammember left
> -  your "rights" or role in the network/team have been changed (for
> example from reader to reader and writer to some documents)

All these sound useful. Some of them like change of team/group or
change of rights/role seem outside the scope of filesystem notificaitons
as such.  Some sort of notifications for diskspace/quota could be
applicable to local filesystems too.

> 
> What I want to say is that in a network where lots of people work
> together in teams/projects, (and I want Linux to play a role there, as
> desktop/workstation) communication is very important, and all these
> messages should be supported by the system. My idea is the support of
> watching fs events with FUSE filesystems should go through userspace,
> and not via the kernel (cause fs events are part of your setup in the
> network, together with all other tools to make people collaborate like
> chat/call/text, and because mentioned above extended info about the
> who on what host etc is not supported by fsnotify).

> There should be a fs event watcher which takes care of all watches on
> behalf of applications during a session, similar to gamin and FAM once
> did (not used anymore?).

So how does the API look like for this OOB channel? Have you published
it somewhere.

Thanks
Vivek

> When receiving a request from one of the applications this fsevent
> watcher will use inotify and/or fanotify for local fs's only. With a
> FUSE fs, it should contact (via a socket) this fs that a watch has
> been set on an inode with a certain mask.
> If the FUSE fs does not support this, fallback on normal inotify/fanotify.
> This way extended info is possible.
> 
> Is this extended information also useful for virtiofs?
> 
> Stef Bon
> 

