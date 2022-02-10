Date: Thu, 10 Feb 2022 17:17:57 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YgVIxdu3/oyp3cU8@redhat.com>
References: <20220209165040.56062-1-dgilbert@redhat.com>
	<YgTTbAWj1CGlmv/R@redhat.com> <YgVHr2zgTrPHVhez@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgVHr2zgTrPHVhez@work-vm>
Subject: Re: [Virtio-fs] [PATCH] Deprecate C virtiofsd
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

On Thu, Feb 10, 2022 at 05:13:19PM +0000, Dr. David Alan Gilbert wrote:
> * Daniel P. Berrangé (berrange@redhat.com) wrote:
> > On Wed, Feb 09, 2022 at 04:50:40PM +0000, Dr. David Alan Gilbert (git) wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > 
> > > There's a nice new Rust implementation out there; recommend people
> > > do new work on that.
> > > 
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  docs/about/deprecated.rst | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> > > index 47a594a3b6..3a0e15f8f5 100644
> > > --- a/docs/about/deprecated.rst
> > > +++ b/docs/about/deprecated.rst
> > > @@ -454,3 +454,17 @@ nanoMIPS ISA
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
> > > +There is a new Rust implementation of ``virtiofs`` at
> > > +``https://gitlab.com/virtio-fs/virtiofsd``;
> > > +since this is now marked stable, new development should be done on that
> > > +rather than the existing C version in the QEMU tree.
> > > +The C version will still accept fixes and patches that
> > > +are already in development for the moment.
> > 
> > Just to be clear, 'deprecation' is usually expected to turn into
> > 'deletion' a minimum of 2 releases later.  We are targetting the
> > C virtiofsd to be deleted, right ?  The last sentance here gives
> > vibes that we're expecting it to stick around despite deprecation.
> 
> I am targeting it to be deleted, but I'm expecting to give it a bit
> more time than 2 releases; how do I do that?

You can forget to remove it after 2 releases, which is what
happens with many deprecations :-)  '2' is really just the
minimum bar in practice.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

