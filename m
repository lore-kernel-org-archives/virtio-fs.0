Date: Mon, 13 Jul 2020 09:39:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200713133935.GA271133@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
	<CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
	<20200625125508.GB149340@redhat.com>
	<CAJFHJrpwvEMa_OkxRg3XHXp+=Wuzwwc8shhCZd3xDsmVVJG7aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrpwvEMa_OkxRg3XHXp+=Wuzwwc8shhCZd3xDsmVVJG7aw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Mon, Jul 13, 2020 at 05:54:19PM +0900, Chirantan Ekbote wrote:
> On Thu, Jun 25, 2020 at 9:55 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Jun 25, 2020 at 12:19:39PM +0900, Chirantan Ekbote wrote:
> > [..]
> > > > Chirantan,
> > > >
> > > > So you ended up renaming all "trusted", "security" and "system" xattrs?
> > > > Only "user" xattrs are complete passthrough?
> > > >
> > >
> > > No, we only rename "security" xattrs (except for selinux).
> > >
> > > >
> > > > IOW, security.selinux will be renamed to user.virtiofs.security.selinux
> > > > on host?
> > > >
> > >
> > > We don't relabel security.selinux because it only requires CAP_FOWNER
> > > in the process's user namespace and it also does its own MAC-based
> > > checks.  Also we have some tools that label files beforehand so it
> > > seemed easier to leave them unchanged.
> >
> > If we rename selinux xattr also, then we can support selinux both in
> > guest and host and they both can have their own independent policies.
> >
> 
> This works as long as you don't need to support setfscreatecon, which
> exists to guarantee that an inode is atomically created with the
> correct selinux context.  It's kind of possible for files with
> O_TMPFILE + fsetxattr + linkat but there is no equivalent for
> directories.  You're basically forced to create the directory and then
> set the xattr and while it's possible to prevent other threads in the
> server from seeing the unfinished directories with a rwlock or similar
> there is no protection against power loss.  If the machine loses power
> after the directory is created but before the selinux xattr is set
> then that directory will have the wrong selinux context and the guest
> would need to run restorecon at boot to assign the correct label.

Overlayfs has this notion of work directory where they create directory
(and file if O_TMPFILE is not supported), and then rename it to correct
place. I am wondering if we could do something similar. If server is
given a work directory where.

A. Create new directory
B. set selinux lables
C. rename directory

That way if machine crashes after step A or step B, that directory
never becomes visible to guest and no relabeling is required.

Thanks
Vivek

