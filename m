Date: Thu, 25 Jun 2020 08:55:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200625125508.GB149340@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
	<CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
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

On Thu, Jun 25, 2020 at 12:19:39PM +0900, Chirantan Ekbote wrote:
[..]
> > Chirantan,
> >
> > So you ended up renaming all "trusted", "security" and "system" xattrs?
> > Only "user" xattrs are complete passthrough?
> >
> 
> No, we only rename "security" xattrs (except for selinux).
> 
> >
> > IOW, security.selinux will be renamed to user.virtiofs.security.selinux
> > on host?
> >
> 
> We don't relabel security.selinux because it only requires CAP_FOWNER
> in the process's user namespace and it also does its own MAC-based
> checks.  Also we have some tools that label files beforehand so it
> seemed easier to leave them unchanged.

If we rename selinux xattr also, then we can support selinux both in
guest and host and they both can have their own independent policies.

Otherwise we either have to disable selinux on host (if we want to
support it in guest) or somehow guest and how policies will have
to know about each other and be able to work together (which will
be hard for a generic use case).

Vivek

