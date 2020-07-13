DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=2zr3G2whJ2dYSC9oe3BTN0sDp3h6IsEmVrP5S8XUwHA=;
	b=Bo5KGrvy/Qb+MDrk/9R7pPrs9xyo7BeDDpRrgspaSzNMlp3+5YqUQKsLZs/aNMiIh2
	GJzIhXsfpz+i1PAYAxwRZVwfv5zGOuCkgtgyrYxbX6Xxlm3PKK7ProvTWmWr7Nh5Iri1
	Rua345MWk8R/zxemnIWNMTOSTirUh6lakDccA=
MIME-Version: 1.0
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com>
	<20200618191655.GI2769@work-vm> <20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
	<CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
	<20200625125508.GB149340@redhat.com>
In-Reply-To: <20200625125508.GB149340@redhat.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Mon, 13 Jul 2020 17:54:19 +0900
Message-ID: <CAJFHJrpwvEMa_OkxRg3XHXp+=Wuzwwc8shhCZd3xDsmVVJG7aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Thu, Jun 25, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Jun 25, 2020 at 12:19:39PM +0900, Chirantan Ekbote wrote:
> [..]
> > > Chirantan,
> > >
> > > So you ended up renaming all "trusted", "security" and "system" xattrs?
> > > Only "user" xattrs are complete passthrough?
> > >
> >
> > No, we only rename "security" xattrs (except for selinux).
> >
> > >
> > > IOW, security.selinux will be renamed to user.virtiofs.security.selinux
> > > on host?
> > >
> >
> > We don't relabel security.selinux because it only requires CAP_FOWNER
> > in the process's user namespace and it also does its own MAC-based
> > checks.  Also we have some tools that label files beforehand so it
> > seemed easier to leave them unchanged.
>
> If we rename selinux xattr also, then we can support selinux both in
> guest and host and they both can have their own independent policies.
>

This works as long as you don't need to support setfscreatecon, which
exists to guarantee that an inode is atomically created with the
correct selinux context.  It's kind of possible for files with
O_TMPFILE + fsetxattr + linkat but there is no equivalent for
directories.  You're basically forced to create the directory and then
set the xattr and while it's possible to prevent other threads in the
server from seeing the unfinished directories with a rwlock or similar
there is no protection against power loss.  If the machine loses power
after the directory is created but before the selinux xattr is set
then that directory will have the wrong selinux context and the guest
would need to run restorecon at boot to assign the correct label.

> Otherwise we either have to disable selinux on host (if we want to
> support it in guest) or somehow guest and how policies will have
> to know about each other and be able to work together (which will
> be hard for a generic use case).

Yes, I agree this is hard to do for a generic case but unfortunately
the more I understand how selinux works the less I feel that it works
well with a passthrough style file system.  As you said it either
needs to be turned off on the host or the host and guest need to work
together.

Chirantan

