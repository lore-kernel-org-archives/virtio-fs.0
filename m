Date: Tue, 20 Oct 2020 20:02:37 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201020190237.GG2962@work-vm>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-5-dgilbert@redhat.com>
	<20201020144041.GC380917@redhat.com>
	<20201020153443.GD2962@work-vm>
	<20201020175600.GE380917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020175600.GE380917@redhat.com>
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
> On Tue, Oct 20, 2020 at 04:34:43PM +0100, Dr. David Alan Gilbert wrote:
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > On Wed, Oct 14, 2020 at 07:02:08PM +0100, Dr. David Alan Gilbert (git) wrote:
> > > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > > > 
> > > > Add a few examples of xattrmaps to the documentation.
> > > > 
> > > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > ---
> > > >  docs/tools/virtiofsd.rst | 50 ++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 50 insertions(+)
> > > > 
> > > > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > > > index a3a120da2f..5cb64612ed 100644
> > > > --- a/docs/tools/virtiofsd.rst
> > > > +++ b/docs/tools/virtiofsd.rst
> > > > @@ -163,6 +163,56 @@ in which case a 'server' rule will always match on all names from
> > > >  the server.
> > > >  
> > > >  
> > > > +xattr-mapping Examples
> > > > +----------------------
> > > > +
> > > > +1) Prefix all attributes with 'user.virtiofs.'
> > > > +
> > > > +::
> > > > +
> > > > +-o xattrmap=":prefix:all::user.virtiofs.::bad:all:::"
> > > > +
> > > 
> > > Staring at rule.
> > > 
> > > ":bad:all:::"
> > > 
> > > and trying to map this to ":type:scope:key:prepend:"
> > > 
> > > type==bad
> > > scope==all
> > > key==""
> > > prepend==""
> > 
> > Correct.
> > 
> > > > +
> > > > +This uses two rules, using : as the field separator;
> > > > +the first rule prefixes and strips 'user.virtiofs.',
> > > > +the second rule hides any non-prefixed attributes that
> > > > +the host set.
> > > 
> > > What is non-prefixed xattr in this context. If client sends
> > > "security.selinux", is prefixed or non-prefixed.
> > 
> > Note that anything originating at the client (i.e. starting with "")
> > will get caught by the first rule and be prefixed with 'user.virtiofs.'
> 
> So first rule is.
> 
> :prefix:all::user.virtiofs.:
> 
> scope="all"
> key==""
> prepend="user.virtiofs."
> 
> Given scope, rule applies to both client and server. Given key is "",
> any income setxattr() request will be prefixed with "user.virtiofs".
> And how does this rule work for server (listxattr()). It will match
> prepend "user.virtiofs" and if that matches it will be stripped?

Right; 'prefix' strips for server, adds for client (as long as you have
'all', you can select either one on it's own with server/client rather
than all).

> 
> 
> > This second rule will only be triggered by an xattr name coming
> > from the server (i.e a listxattr) for a name that doesn't begin
> > with user.virtiofs. (i.e. didn't match the 1st rule for a server xattr).
> > This makes sure that only guest created xattr's (that were set and
> > had a prefix added) are then visible to the guest.
> 
> Ok, so if an xattr does not match first rule, then second rule says
> key="", prepend="" and that will match all xattrs. So anything which
> is not caught by first rule, will be caught by second rule and
> either rejected or filtered out.

Right.

> > 
> > > Documentation in first patch said.
> > > 
> > > +- 'bad' - If a client tries to use this name it's
> > > +  denied using EPERM; when the server passes an attribute
> > > +  name matching it's hidden.
> > > 
> > > I am not sure which xattr name will be blocked if key=="" and prepend==""
> > 
> > All of them; they're still matched at the beginning; as the first
> > patch says 'It maybe empty in which case a 'client' rule will always
> > match on client names'
> 
> Ok.
> 
> > 
> > > > +2) Prefix 'trusted.' attributes, allow others through
> > > > +
> > > > +::
> > > > +
> > > > +   "/prefix/all/trusted./user.virtiofs./
> > > > +    /bad/server//trusted./
> > > > +    /bad/client/user.virtiofs.//
> > > > +    /ok/all///"
> > > > +
> > > > +
> > > > +Here there are four rules, using / as the field
> > > > +separator, and also demonstrating that new lines can
> > > > +be included between rules.
> > > > +The first rule is the prefixing of 'trusted.' and
> > > > +stripping of 'user.virtiofs.'.
> > > 
> > > So this is bidrectional rule, right. For setxattr(), "trusted."
> > > will be replaced with "user.virtiofs" and for listxattr(),
> > > server will replace user.virtiofs with trusted. ?
> > 
> > prefixed not replaced; so it'll turn "trusted." into
> > "user.virtiofs.trusted." and strip it back off for listxattr.
> 
> Ok. Got it. I am wondering how will I specify these rules so that
> they work in nested configuration. Say I have L0 host, L1 guest and
> L2 guest. Say virtiofsd0 is running on L0 and virtiofsd1 is running
> on L1. 
> 
> I am wondering how will I specify the rules on virtiofsd0 and virtiofsd1
> so that it works. Will it be same or rules are level dependent.

I'm hoping it'll be the same, see below.

> > 
> > > > +The second rule hides unprefixed 'trusted.' attributes
> > > > +on the host.
> > > 
> > > If host has "trusted.*", we are not hiding it and as per first
> > > rule we are converting it to "user.virtiofs.trusted.*", right?
> > > So why this second rule is needed.
> > 
> > No, the first rule will only prefix strings provided by the guest
> > and strip strings provided by the server. This rule hides
> > existing server 'trusted.' xattrs - so if the guest sets
> > trusted.foo it's not confused by also seeing a server trusted.foo
> > 
> > > > +The third rule stops a guest from explicitly setting
> > > > +the 'user.viritofs.' path directly.
> > > > +Finally, the fourth rule lets all remaining attributes
> > > > +through.
> > > 
> > > So If I don't specify third rule, and client does
> > > setxattr(user.virtiofs.*), it will simply be a passthrough?
> > 
> > Right; and that's dangerous, because a non-privileged guest
> > process can set a user. xattr; so a non-priv guest process could
> > set user.virtiofs.trusted.foo and then it would get read back
> > and be used as trusted.foo that has an impact on priviliged processes.
> 
> Right. We don't want unpriviliged process to be able to setup
> user.virtiofs.trusted.*. But that's what precisely happen in
> a nested configuration.
> 
> In above example, L2 will set trusted.foo, virtiofsd1 wil convert it
> to user.virtiofs.trusted.foo and virtiofsd0 will reject it, breaking
> the nested virtiofs.

So to allow nesting you need to nest the user.virtiofs. as well, not
just the trusted. So either you do an all, or if you want to be more
selective then I think the following would work:

 1  /prefix/client/trusted./user.virtiofs./
 2  /prefix/client/user.virtiofs./user.virtiofs./
 3  /prefix/server//user.virtiofs./
 4  /bad/server//trusted./
 5  /ok/all///

1 causes any getattr/setattr to convert 'trusted.'
                                   to   'user.virtiofs.trusted.'
2 causes any getattr/setattr to convert 'user.virtiofs.'
                                   to   'user.virtiofs.user.virtiofs.'
3 causes any listattr to lose a layer of user.virtiofs.
4 blocks any trusted. from the layer beneath
5 lets anything else through

(I'm trying to convince myself if we need a
/bad/server//user.virtiofs.trusted.  to stop the previous level being
visible).

Dave



> Thanks
> Vivek
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

