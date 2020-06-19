Date: Fri, 19 Jun 2020 18:16:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200619171631.GK2690@work-vm>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com> <20200619082746.GA2690@work-vm>
	<20200619160923.GD3154@redhat.com> <20200619161648.GJ2690@work-vm>
	<20200619171121.GE3154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619171121.GE3154@redhat.com>
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Fri, Jun 19, 2020 at 05:16:48PM +0100, Dr. David Alan Gilbert wrote:
> 
> [..]
> > > > > >   b) If something nasty was to write junk into the trusted attributes,
> > > > > >     what would happen?
> > > > > 
> > > > > This directory is owned by guest. So it should be able to write
> > > > > anything it wants, as long as process in guest has CAP_SYS_ADMIN, right?
> > > > 
> > > > Well, we shouldn't be able to break/crash/escape into the host; how
> > > > much does overlayfs validate trusted.* it uses?
> > > 
> > > I thought qemu and kvm are the one who should ensure we should not be
> > > able to break out of sandbox. Kernel implementation could be as 
> > > buggy as it wanted to be. We are working with this security model
> > > that kernel is completely untrusted.
> > 
> > But with virtiofs we allow the guest to do a lot of filesystem
> > operations on the host.  It's the virtiofsd that has to ensure that
> > these are safe and contained within the fs it's exposed; the qemu/kvm
> > can't protect us from that.
> 
> Fair enough. I should have added virtiofsd to list. Its an attack
> vector and is of concern.
> 
> > 
> > That's why we sandbox the virtiofsd like we do - if we allow a
> > priviliged guest to perform calls to an unconstrained virtiofsd it would
> > be able to escape.  That's what I want to check.
> 
> Sure. So does giving CAP_SYS_ADMIN to virtiofsd allow daemon to escape
> the jail.

So that's *my* question - what bad things can someone do by setting
attributes (trusted/system/security) - it's fine if they break they
screwup the security inside the container, because they'd need to be
CAP_SYS_ADMIN inside the container to do it - as long as they can't
break the host.  So what happens if someone starts doing bad things to
trusted.* attributes on an overlayfs - no other fs uses them as far as I
know.

> If it does we need to implement what crossvm folks did,
> remapping of trusted xattr. That will also allow us to run inside
> user namespace and still be able to support trusted xattr emulation
> for guest.

I think we need to do that anyway, it's just going to take a while to
figure out.

Dave

> 
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

