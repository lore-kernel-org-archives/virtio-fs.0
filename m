Date: Wed, 21 Oct 2020 18:39:19 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201021173919.GF3671@work-vm>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-5-dgilbert@redhat.com>
	<20201020144041.GC380917@redhat.com>
	<20201020153443.GD2962@work-vm>
	<20201020175600.GE380917@redhat.com>
	<20201020190237.GG2962@work-vm>
	<20201021134408.GA442437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021134408.GA442437@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 4/5] tools/virtiofsd: xattr name mapping
	examples
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Tue, Oct 20, 2020 at 08:02:37PM +0100, Dr. David Alan Gilbert wrote:
> 
> [..]
> > > > > > +2) Prefix 'trusted.' attributes, allow others through
> > > > > > +
> > > > > > +::
> > > > > > +
> > > > > > +   "/prefix/all/trusted./user.virtiofs./
> > > > > > +    /bad/server//trusted./
> > > > > > +    /bad/client/user.virtiofs.//
> > > > > > +    /ok/all///"
> > > > > > +
> > > > > > +
> > > > > > +Here there are four rules, using / as the field
> > > > > > +separator, and also demonstrating that new lines can
> > > > > > +be included between rules.
> > > > > > +The first rule is the prefixing of 'trusted.' and
> > > > > > +stripping of 'user.virtiofs.'.
> > > > > 
> > > > > So this is bidrectional rule, right. For setxattr(), "trusted."
> > > > > will be replaced with "user.virtiofs" and for listxattr(),
> > > > > server will replace user.virtiofs with trusted. ?
> > > > 
> > > > prefixed not replaced; so it'll turn "trusted." into
> > > > "user.virtiofs.trusted." and strip it back off for listxattr.
> > > 
> > > Ok. Got it. I am wondering how will I specify these rules so that
> > > they work in nested configuration. Say I have L0 host, L1 guest and
> > > L2 guest. Say virtiofsd0 is running on L0 and virtiofsd1 is running
> > > on L1. 
> > > 
> > > I am wondering how will I specify the rules on virtiofsd0 and virtiofsd1
> > > so that it works. Will it be same or rules are level dependent.
> > 
> > I'm hoping it'll be the same, see below.
> > 
> > > > 
> > > > > > +The second rule hides unprefixed 'trusted.' attributes
> > > > > > +on the host.
> > > > > 
> > > > > If host has "trusted.*", we are not hiding it and as per first
> > > > > rule we are converting it to "user.virtiofs.trusted.*", right?
> > > > > So why this second rule is needed.
> > > > 
> > > > No, the first rule will only prefix strings provided by the guest
> > > > and strip strings provided by the server. This rule hides
> > > > existing server 'trusted.' xattrs - so if the guest sets
> > > > trusted.foo it's not confused by also seeing a server trusted.foo
> > > > 
> > > > > > +The third rule stops a guest from explicitly setting
> > > > > > +the 'user.viritofs.' path directly.
> > > > > > +Finally, the fourth rule lets all remaining attributes
> > > > > > +through.
> > > > > 
> > > > > So If I don't specify third rule, and client does
> > > > > setxattr(user.virtiofs.*), it will simply be a passthrough?
> > > > 
> > > > Right; and that's dangerous, because a non-privileged guest
> > > > process can set a user. xattr; so a non-priv guest process could
> > > > set user.virtiofs.trusted.foo and then it would get read back
> > > > and be used as trusted.foo that has an impact on priviliged processes.
> > > 
> > > Right. We don't want unpriviliged process to be able to setup
> > > user.virtiofs.trusted.*. But that's what precisely happen in
> > > a nested configuration.
> > > 
> > > In above example, L2 will set trusted.foo, virtiofsd1 wil convert it
> > > to user.virtiofs.trusted.foo and virtiofsd0 will reject it, breaking
> > > the nested virtiofs.
> > 
> > So to allow nesting you need to nest the user.virtiofs. as well, not
> > just the trusted. So either you do an all, or if you want to be more
> > selective then I think the following would work:
> > 
> >  1  /prefix/client/trusted./user.virtiofs./
> >  2  /prefix/client/user.virtiofs./user.virtiofs./
> 
> Ok, so basically instead of blocking user.virtiofs.trusted. from client,
> prefix it with "user.virtiofs." one more time. IOW, allow client to
> set user.virtiofs.trusted. because it will get back user.virtiofs.trusted.
> and not "trusted." which is ok. Now client user space can't fool client
> kernel with setting arbitrary user.virtiofs.trusted xattrs.

Right.

> And if client kernel sends, trusted., it will get back trusted.

Right.

> Only thing which can happen is that client1 sets user.virtiofs.trusted.
> and nested client2 will get it as trusted. So client1 user space can
> fool nested client's kernel. But given client1 has launched nested
> client2, we should be able to trust some user on client1 and make
> sure other users can't see this shared dir and this probably is
> not an issue.

Yes, that does depend a bit on how you're intending to share your
filesystems etc

> >  3  /prefix/server//user.virtiofs./
> >  4  /bad/server//trusted./
> >  5  /ok/all///
> > 
> > 1 causes any getattr/setattr to convert 'trusted.'
> >                                    to   'user.virtiofs.trusted.'
> > 2 causes any getattr/setattr to convert 'user.virtiofs.'
> >                                    to   'user.virtiofs.user.virtiofs.'
> > 3 causes any listattr to lose a layer of user.virtiofs.
> > 4 blocks any trusted. from the layer beneath
> > 5 lets anything else through
> > 
> > (I'm trying to convince myself if we need a
> > /bad/server//user.virtiofs.trusted.  to stop the previous level being
> > visible).
> 
> user.virtiofs.trusted on server will be converted to trusted., right?
> Can't block it otherwise L1 client breaks, isn't it?

True.

Dave

> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

