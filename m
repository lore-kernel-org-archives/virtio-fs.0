Date: Mon, 14 Feb 2022 09:27:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Ygpmxqs6rN8/5aJh@redhat.com>
References: <20220210174714.19843-1-dgilbert@redhat.com>
	<20220210204404.GA22879@redhat.com> <Ygo9O7oWsImstSJu@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygo9O7oWsImstSJu@work-vm>
Subject: Re: [Virtio-fs] [PATCH v2] Deprecate C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: berrange@redhat.com, "Richard W.M. Jones" <rjones@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Feb 14, 2022 at 11:30:03AM +0000, Dr. David Alan Gilbert wrote:
> * Richard W.M. Jones (rjones@redhat.com) wrote:
> > On Thu, Feb 10, 2022 at 05:47:14PM +0000, Dr. David Alan Gilbert (git) wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > 
> > > There's a nice new Rust implementation out there; recommend people
> > > do new work on that.
> > > 
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  docs/about/deprecated.rst | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> > > index 47a594a3b6..3c73d22729 100644
> > > --- a/docs/about/deprecated.rst
> > > +++ b/docs/about/deprecated.rst
> > > @@ -454,3 +454,20 @@ nanoMIPS ISA
> > >  
> > >  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolchain.
> > >  As it is hard to generate binaries for it, declare it deprecated.
> > > +
> > > +Tools
> > > +-----
> > > +
> > > +virtiofsd
> > > +'''''''''
> > > +
> > > +There is a new Rust implementation of ``virtiofsd`` at
> > > +``https://gitlab.com/virtio-fs/virtiofsd``;
> > > +since this is now marked stable, new development should be done on that
> > > +rather than the existing C version in the QEMU tree.
> > > +The C version will still accept fixes and patches that
> > > +are already in development for the moment, but will eventually
> > > +be deleted from this tree.
> > > +New deployments should use the Rust version, and existing systems
> > > +should consider moving to it.  The command line and feature set
> > > +is very close and moving should be simple.
> > 
> > I'm not qualified to say if the Rust impl is complete enough
> > to replace the C version, so I won't add a reviewed tag.
> 
> We believe it is a complete replacement at this point, with compatible
> command line.

I think its not a complete replacement yet. For example, POSIX_ACLs are
not supported yet. German is looking into making it work.

There might be other small things here and there, but nothing major, I
think.

Vivek
> 
> Dave
> 
> > However I want to say that from the point of view of downstream
> > packagers of qemu -- especially Fedora -- it would be helpful if we
> > could direct both upstream development effort and downstream packaging
> > into just the one virtiofsd.  So I agree in principle with this.
> > 
> > Rich.
> > 
> > -- 
> > Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
> > Read my programming and virtualization blog: http://rwmj.wordpress.com
> > virt-p2v converts physical machines to virtual machines.  Boot with a
> > live CD or over the network (PXE) and turn machines into KVM guests.
> > http://libguestfs.org/virt-v2v
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 

