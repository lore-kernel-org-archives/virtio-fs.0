Date: Tue, 20 Oct 2020 13:20:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201020172032.GD380917@redhat.com>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-4-dgilbert@redhat.com>
	<20200911211358.GA191320@redhat.com>
	<20200918173838.GQ2816@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918173838.GQ2816@work-vm>
Subject: Re: [Virtio-fs] [PATCH v2 3/6] tools/virtiofsd: xattr name
 mappings: Add option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Sep 18, 2020 at 06:38:38PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Thu, Aug 27, 2020 at 04:36:54PM +0100, Dr. David Alan Gilbert (git) wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > 
> > > Add an option to define mappings of xattr names so that
> > > the client and server filesystems see different views.
> > > This can be used to have different SELinux mappings as
> > > seen by the guest, to run the virtiofsd with less privileges
> > > (e.g. in a case where it can't set trusted/system/security
> > > xattrs but you want the guest to be able to), or to isolate
> > > multiple users of the same name; e.g. trusted attributes
> > > used by stacking overlayfs.
> > > 
> > > A mapping engine is used wit 3 simple rules; the rules can
> > > be combined to allow most useful mapping scenarios.
> > > The ruleset is defined by -o xattrmap='rules...'.
> > > 
> > > This patch doesn't use the rule maps yet.
> > > 
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  docs/tools/virtiofsd.rst         |  55 ++++++++++++
> > >  tools/virtiofsd/passthrough_ll.c | 148 +++++++++++++++++++++++++++++++
> > >  2 files changed, 203 insertions(+)
> > > 
> > > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > > index 824e713491..2efa16d3c5 100644
> > > --- a/docs/tools/virtiofsd.rst
> > > +++ b/docs/tools/virtiofsd.rst
> > > @@ -107,6 +107,60 @@ Options
> > >    performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
> > >    timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
> > >  
> > > +xattr-mapping
> > > +-------------
> > > +
> > > +By default the name of xattr's used by the client are passed through to the server
> > > +file system.  This can be a problem where either those xattr names are used
> > > +by something on the server (e.g. selinux client/server confusion) or if the
> > > +virtiofsd is running in a container with restricted priviliges where it cannot
> > > +access some attributes.
> > > +
> > > +A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
> > > +string consists of a series of rules.
> > > +
> > > +The first matching rule terminates the mapping.
> > > +
> > > +Each rule consists of a number of fields separated with a separator that is the
> > > +first non-white space character in the rule.  This separator must then be used
> > > +for the whole rule.
> > > +White space may be added before and after each rule.
> > > +Using ':' as the separator a rule is of the form:
> > > +
> > > +``:scope:type:key:prepend:``
> > 
> > Hi David,
> > 
> > This seems very genric and which makes it harder to understand and
> > harder to write rules. I am wondering do we really need this degree
> > of flexibility. Is it worth, dropping some of the requirements
> > and simplify the syntax.
> 
> I'm wondering perhaps if we could solve this by adding sugared simple
> versions but leaving the flexible syntax for those who need it.

I guess fair enough. This syntax is so generic (hence complex), that
its not my first choice. But if others feel the need of such a 
generic mechanism, I am not going to get in the way.

> 
> > - I am wonderig why do we need to allow choice of separator.
> 
> I didnd't have that at first, but it was simple to add and solves
> the problem of if you have the separator in the string you want to
> substitute.

> 
> > - Wondering why do we need to allow separate rules for client/server.
> >   Once we start remapping something, is it not good enough that
> >   mapping be bidirectonal.
> > 
> > - Not sure why separate notion of "bad". To me once we decide to
> >   remap something, should automatically block unprefixed version.
> 
> I wanted to be able to block things rather than remap; for example
> just to block 'trusted.'
> 
> > IOW, what functionality we will lose if we just say
> > 
> > -o remap_xattr="trusted.".
> > 
> > This implies following.
> > 
> > A. If client is sending any xattr prefixed with "trusted.", prefix it
> > with "user.virtiofs".
> > 
> > B. Server filters out anything starting with "trusted."
> > 
> > C. If server sees "user.virtiofs.trusted." it strips "user.virtiofs".
> 

[ I had missed reading this email. Looking at it now. ]

> Don't forget you also have to stop the client explicitly sending
> 'user.virtiofs.trusted'; that would let an unpriv client process
> overwrite the prefixed name.

Fair enough. Yes, we will have to block this as part of "remap_xattr"
semantics.

> 
> > For remapping security.selinux, user could specify.
> > 
> > -o remap_xattr="security.selinux."
> > 
> > For nested configuration. virtiofsd at L1 will specify.
> > 
> > -o remap_xattr="security.selinux.".
> > 
> > And virtiofsd at L0 can specify.
> > 
> > -o remap_xattr="user.virtiofs.security.selinux."
> 
> I think you're saying that means it needs to know if it's L0 or L1
> which is a shame; ideally you'd be able to have something that
> transparently worked at either.

I will be nice to avoid knowing level information because it is
ugly. But how to avoid it? Either don't use virtiofs in stacking
configurations. But if we have to, how to avoid it?

> 
> In your scheme how do I do both the 'trusted.' and 'security.selinux.'
> stuff?

We can allow specifying multiple "remap_xattr" or allow multiple
rules in single option separted by ":".

Say -o remap_xattr="security.selinux.:trusted."

> 
> > I doubt we need to care about being able to remap xattrs of
> > other filesystems like virtio-9p.
> 
> Well that's the thing; there's at least 9p and crosvm's setup; both
> of which are different, and it would make sense if someone wanted
> to transition their existing on disk container to a virtiofs setup
> from a 9p setup without having to change all their xattr's.
> That was my main reason for wanting the flexibility.

> 
> > I also have some questions about how this will be used.
> > 
> > Overlay
> > -------
> > - So for non nested guests, we can have two instances of overlay. Lets
> >   call these ovl0 and ovl1. (ovl0 being on host, and ovl1 being inside
> >   guest). Fs hierarcy might look as follows.
> > 
> >   ext4-->ovl0-->virtiofsd0-->ovl1
> > 
> >   This case does not work by default even if virtiofsd has CAP_SYS_ADMIN
> >   by default as overlay does not allow nesting. So when ovl1 tries to
> >   set trusted.overlay, ovl0 will deny it.
> > 
> >   We could simple pass extra directory from host which does not go through
> >   overlay on host and use that as upper inside guest.
> > 
> >   ext4-->ovl0-->virtiofsd0-->ovl1
> >   ext4-->ovl0/upper-->virtiofsd0-->ovl1
> >   (/upper used as upper directory of ovl1)
> 
> If I understand correctly that does mean that the L1 has to understand
> it's an L1 and do things differently.

Yes. I could not find a way to avoid it.

> 
> >   I guess remapping "trusted.overlay" will allow us not to have a separate
> >   ovl0/upper. And following itself will work. Have you tested it? Does
> >   this work.
> 
> Not tried, but that is my hope.
> 
> > Basically we are creating nested overlay configuration with
> >   virtiofs in between. Is "trusted.overlay" only conflict. I wonder
> >   there might be others. Just that "trusted.overlay" is first failure
> >   we noticed.
> 
> I think there's a whole bunch of trusted.overlay.* stuff but I didn't
> find anything else (I think jt's a define as the prefix).
> Note also, that if someone has an existing fuse-overlayfs setup that
> nested by using user.fuseoverlayfs you might be able to use the rule
> system to map it back.
> 
> > 
> > Nested Overlay
> > --------------
> > - For now I will assume that we are using separate upper dir.
> > 
> >   ext4-->ovl0-->virtiofsd0-->ovl1-->virtiofsd1-->ovl2
> >   ext4-->ovl0/upper1-->virtiofsd0-->ovl1(uses upper1 as upperdir)
> >   ext4-->ovl0/upper2-->virtiofsd0-->ovl1-->virtiofsd1-->ovl2 (users upper2
> >   as upper dir)
> > 
> >   Basically create two directories upper1 and upper2 on regular filesystem
> >   say ext4/xfs. Bind mount them on ovl0/upper1 and ovl0/upper2 respectively.
> >   And now ovl1 uses ovl0/upper1 as upperdir and ovl2 uses ovl0/upper2 as
> >   upperdir. This should make sure ovl0, ovl1 and ovl2 are not nested from
> >   sharing upper perspective.
> > 
> >   Now virtiofsd1 will run with '-o remap_xattr="trusted.overlay"' and
> >   virtiofsd0 will run with '-o remap_xattr="user.virtiofs.trusted.overlay"'
> 
> You could tell both layers the same thing; prefix/strip everything with
> user.virtiofs.   and then you can do the same thing at both layers and
> they don't need to know which layer they're at.

Right that should work. But this will prefix user.virtiofs for every
xattr. If we want to prefix it on a specific xattr, then it become
little more tricky. Because inner most layer will do
setxattr(trusted.foo.) and next layer will do
setxattr(user.virtiofs.trusted.foo). So question is what's the common
syntax which works for both.


I have been thinking little more of nested overlay use case.

If we make sure that "upper" for each overlay instance is
separate (and not coming from stacked overlay), then following should
work well for nested configurations.

To reiterate, I think something like this should work for nested
overlay configuration.

- On host, create lower0, upper0, upper1 and upper2 dirs.
  
  mkdir -p lower0 lower0/lower1 work0 upper1 work1 upper2 work2 ovl0

- Create ovl0 on host (L0)

  mount -t overlay -o lowerdir=lower0,upperdir=upper0,workdir=work0 none ovl0 
  
- Bind mount upper and work dirs for ovl1 and ovl2.

  mkdir -p ovl0/upper1 ovl0/work1 ovl0/upper2 ovl0/work2
  mount --bind upper1 ovl0/upper1
  mount --bind work1 ovl0/work1
  mount --bind upper2 ovl0/upper2
  mount --bind work2 ovl0/work2

- Run virtiofsd0 on ovl0 with "-o remap_xattr="trusted.overlay."

- Inside L1 guest say ovl0 is mounted at "/". Create second overlay.

  mkdir ovl1
  mount -t overlay -o lowerdir=lower1,upperdir=upper1,workdir=work1 none ovl1

- Bind mount upper2 and work2 inside ovl1.

  mkdir -p ovl1/upper2 ovl1/work2
  mount --bind upper2 ovl1/upper2
  mount --bind work2 ovl1/work2

- Run virtiofsd1 on ovl1 with -o "remap_xattr="trusted.overlay."

- Inisde L2 guest say virtiofs is mounted at "/"

  mkdir ovl2
  mount -t overlay -o lowerdir=lower1,upperdir=upper2,workdir=work2 none ovl2

  Now upper for overlayfs are not stacked through overlayfs file systems.

Thanks
Vivek

