DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=vysOZ84N4xhaVF/+iiQESao5k1Y7S6h5dGJxcoMMDOI=;
	b=NtRwR84M4D0tSqdUcfJvEfm0AfU65ybnuQOn/cgYn09J17lnNzJ4K4H4WsATaBLFNK
	1mQBMYE+1B9DXOMFf0wAL/xFE87y0CcjrDQKNiruUG4Sxy9YBcBKl41otAT966Q/NaAV
	silof7LbUWGn7xGeRyVFhjd4KQ9+rT6wn0iAfDdegUbvdWSpzXHkLR7Crk3XQ59MxmbG
	J386uxmDsQD7vIpkAqTG+Dga7PPnK5ZiAuB7vDHnThzRH59HAwQJk984w89+pWNbMzSX
	23bVCXs+3+YSuyyvrgmfn7k78gJR23SNlKpxoCP1P3230jRJ32BH/uAC4zwhhJuXSL2V
	CBVA==
MIME-Version: 1.0
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
	<CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
	<YXhIm3mOvPsueWab@redhat.com>
	<CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
	<20211027132319.GA7873@quack2.suse.cz> <YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
In-Reply-To: <20211102110931.GD12774@quack2.suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 Nov 2021 14:54:01 +0200
Message-ID: <CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Steve French <sfrench@samba.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Nov 2, 2021 at 1:09 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 27-10-21 16:29:40, Vivek Goyal wrote:
> > On Wed, Oct 27, 2021 at 03:23:19PM +0200, Jan Kara wrote:
> > > On Wed 27-10-21 08:59:15, Amir Goldstein wrote:
> > > > On Tue, Oct 26, 2021 at 10:14 PM Ioannis Angelakopoulos
> > > > <iangelak@redhat.com> wrote:
> > > > > On Tue, Oct 26, 2021 at 2:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > The problem here is that the OPEN event might still be travelling towards the guest in the
> > > > > virtqueues and arrives after the guest has already deleted its local inode.
> > > > > While the remote event (OPEN) received by the guest is valid, its fsnotify
> > > > > subsystem will drop it since the local inode is not there.
> > > > >
> > > >
> > > > I have a feeling that we are mixing issues related to shared server
> > > > and remote fsnotify.
> > >
> > > I don't think Ioannis was speaking about shared server case here. I think
> > > he says that in a simple FUSE remote notification setup we can loose OPEN
> > > events (or basically any other) if the inode for which the event happens
> > > gets deleted sufficiently early after the event being generated. That seems
> > > indeed somewhat unexpected and could be confusing if it happens e.g. for
> > > some directory operations.
> >
> > Hi Jan,
> >
> > Agreed. That's what Ioannis is trying to say. That some of the remote events
> > can be lost if fuse/guest local inode is unlinked. I think problem exists
> > both for shared and non-shared directory case.
> >
> > With local filesystems we have a control that we can first queue up
> > the event in buffer before we remove local watches. With events travelling
> > from a remote server, there is no such control/synchronization. It can
> > very well happen that events got delayed in the communication path
> > somewhere and local watches went away and now there is no way to
> > deliver those events to the application.
>
> So after thinking for some time about this I have the following question
> about the architecture of this solution: Why do you actually have local
> fsnotify watches at all? They seem to cause quite some trouble... I mean
> cannot we have fsnotify marks only on FUSE server and generate all events
> there? When e.g. file is created from the client, client tells the server
> about creation, the server performs the creation which generates the
> fsnotify event, that is received by the server and forwared back to the
> client which just queues it into notification group's queue for userspace
> to read it.
>
> Now with this architecture there's no problem with duplicate events for
> local & server notification marks, similarly there's no problem with lost
> events after inode deletion because events received by the client are
> directly queued into notification queue without any checking whether inode
> is still alive etc. Would this work or am I missing something?
>

What about group #1 that wants mask A and group #2 that wants mask B
events?

Do you propose to maintain separate event queues over the protocol?
Attach a "recipient list" to each event?

I just don't see how this can scale other than:
- Local marks and connectors manage the subscriptions on local machine
- Protocol updates the server with the combined masks for watched objects

I think that the "post-mortem events" issue could be solved by keeping an
S_DEAD fuse inode object in limbo just for the mark.
When a remote server sends FS_IN_IGNORED or FS_DELETE_SELF for
an inode, the fuse client inode can be finally evicted.
I haven't tried to see how hard that would be to implement.

Thanks,
Amir.

