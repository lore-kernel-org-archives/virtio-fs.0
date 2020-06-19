Date: Fri, 19 Jun 2020 13:11:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200619171121.GE3154@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com> <20200619082746.GA2690@work-vm>
	<20200619160923.GD3154@redhat.com> <20200619161648.GJ2690@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619161648.GJ2690@work-vm>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Jun 19, 2020 at 05:16:48PM +0100, Dr. David Alan Gilbert wrote:

[..]
> > > > >   b) If something nasty was to write junk into the trusted attributes,
> > > > >     what would happen?
> > > > 
> > > > This directory is owned by guest. So it should be able to write
> > > > anything it wants, as long as process in guest has CAP_SYS_ADMIN, right?
> > > 
> > > Well, we shouldn't be able to break/crash/escape into the host; how
> > > much does overlayfs validate trusted.* it uses?
> > 
> > I thought qemu and kvm are the one who should ensure we should not be
> > able to break out of sandbox. Kernel implementation could be as 
> > buggy as it wanted to be. We are working with this security model
> > that kernel is completely untrusted.
> 
> But with virtiofs we allow the guest to do a lot of filesystem
> operations on the host.  It's the virtiofsd that has to ensure that
> these are safe and contained within the fs it's exposed; the qemu/kvm
> can't protect us from that.

Fair enough. I should have added virtiofsd to list. Its an attack
vector and is of concern.

> 
> That's why we sandbox the virtiofsd like we do - if we allow a
> priviliged guest to perform calls to an unconstrained virtiofsd it would
> be able to escape.  That's what I want to check.

Sure. So does giving CAP_SYS_ADMIN to virtiofsd allow daemon to escape
the jail. If it does we need to implement what crossvm folks did,
remapping of trusted xattr. That will also allow us to run inside
user namespace and still be able to support trusted xattr emulation
for guest.

Vivek

