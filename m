DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=ZQgaHCAz+4zHANZcp3Rs7RBfJqdzxQQmeo6/berIQ9U=;
	b=HuagXbpCAiQyDWw6Sas35jYs1AreAg+q+bw0innkNvPZ9FTVYFQis70MSlQY+FrtCv
	l4xJ/tZRqOCKKn63jqe0sh7mAAVyTibFPLIq4EWeM6zRH0vW28MWiHGIEo5OEWB6ZEDZ
	pW0GYMO6VPLMcORxvhj6lhXNx94ku/x58AEYrLla/a6xneiNXMC/qRTxO7G3t6H2iMjj
	E91J2yGrNUnu96G82iBZy/zjd7JrxxzqSn16qterd7h+SQ8o6uiMiHAQzwF14UXDY4Eb
	edvntcGUa98ECEBO8N3M4JhSpckhuCAi6au5FCqMSlz8bXvWytuXSzZvFSmxBZ9a1P6c
	qJTQ==
MIME-Version: 1.0
References: <CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
	<CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
	<CAOQ4uxjpGMYZrq74S=EaSO2nvss4hm1WZ_k+Xxgrj2k9pngJgg@mail.gmail.com>
	<YaZC+R7xpGimBrD1@redhat.com>
In-Reply-To: <YaZC+R7xpGimBrD1@redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Jan 2022 17:37:32 -0600
Message-ID: <CAH2r5mv1x9J0uR4x=D3hApNbaZpoYrQdifSQqdu3nBHrkOaxgg@mail.gmail.com>
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
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, Amir Goldstein <amir73il@gmail.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stef Bon <stefbon@gmail.com>

On Wed, Dec 1, 2021 at 9:06 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Nov 17, 2021 at 08:40:57AM +0200, Amir Goldstein wrote:
> > On Wed, Nov 17, 2021 at 12:12 AM Ioannis Angelakopoulos
> > <iangelak@redhat.com> wrote:
> > >
> > >
> > >
> > > On Tue, Nov 16, 2021 at 12:10 AM Stef Bon <stefbon@gmail.com> wrote:
> > >>
> > >> Hi Ioannis,
> > >>
> > >> I see that you have been working on making fsnotify work on virtiofs.
> > >> Earlier you contacted me since I've written this:
> > >>
> > >> https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE
> > >>

We had a few customer requests recently to fix inotify for network fs
which reminded me of Miklos's earlier patch to fix the VFS layer, but
if changes to extend inotify in userspace were also done it would be
important to tie them in with network/cluster filesystems that expose
change notification over their network API.    Most or all major SMB
servers support change notification today so it is extremely common
over SMB3.1.1 (and earlier dialects as well).    If you have userspace
inotify libraries while we wait for changes to the VFS layer to enable
remote change notification - in the interim you can use an existing
fsspecific ioctl for some filesystems like cifs.ko. See
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/cifs/ioctl.c?id=d26c2ddd33569667e3eeb577c4c1d966ca9192e2

