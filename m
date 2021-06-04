Date: Fri, 4 Jun 2021 15:52:01 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YLo+Ef4pSi5xf4a6@redhat.com>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
	<0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
	<20210604134439.GB269481@redhat.com> <YLoxwQIyqAazPHqf@redhat.com>
	<20210604144313.GE269481@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604144313.GE269481@redhat.com>
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com, Link Dupont <link@sub-pop.net>

On Fri, Jun 04, 2021 at 10:43:13AM -0400, Vivek Goyal wrote:
> On Fri, Jun 04, 2021 at 02:59:29PM +0100, Daniel P. Berrangé wrote:
> > On Fri, Jun 04, 2021 at 09:44:39AM -0400, Vivek Goyal wrote:
> > > On Thu, Jun 03, 2021 at 10:14:24PM -0400, Link Dupont wrote:
> > > > On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont <link@sub-pop.net>
> > > > wrote:
> > > > >  reproducible scenarios
> > > > 
> > > > Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a
> > > > virtiofs filesystem and with xattr on), the type of files in the mounted
> > > > hierarchy are unlabeled_t. I can work around that by switching SELinux in
> > > > the guest to permissive or disabled.
> > > 
> > > cc Dan Walsh. I was discussing this with Dan Walsh yesterday in general.
> > > 
> > > In general, if we want to enable SELinux both on host and guest, then
> > > both host and guest should have same SELinux policy. Otherwise there
> > > will be lot of different kind of conflicts because both host and
> > > guest will try to work with same selinux label. I guess that in
> > > practice this will be very hard to achieve as people will run
> > > different host and guest flavors and these might have different
> > > policies.
> > 
> > Yeah, I think there's little to no chance of people keeping the
> > same SELinux policy in host/guest, except in very tightly controlled
> > narrow use cases where the host admin exerts direct control over
> > the precise guest config.
> > 
> > 
> > > So another option is to rename selinux xattr in virtiofs so that
> > > any selinux xattr coming from guest is saved as
> > > user.virtiofs.security.selinux xattr on host. That way host and guest
> > > can have their separate labels without interfering with each other.
> > > David Gilbert already has added support for this. I can't remember
> > > the exact syntax but you can figure it out from documentation here
> > > in xattr remappig section.
> > 
> > For general purpose virt usage, I think remapping in some way is
> > likely to be needed as the default strategy.
> > 
> > > https://github.com/qemu/qemu/blob/master/docs/tools/virtiofsd.rst
> > > 
> > > But I have question with selinux xattr remapping. What will happen
> > > to initial labels when fs is exported. I mean until and unless
> > > some process in guest labels all the exported files, they all
> > > with either be unlabeled or pick some generic label for all the
> > > files.
> > 
> > I'd say you need some mechanism to force a re-label inside the
> > guest. Normally a relabel will be done in /.autorelabel file
> > is present, or in certain other scenarios like selinux policy
> > RPM updates.
> > 
> > We wouldn't want to force a relabel neccesarily for the entire
> > FS if we're just hotplugging a new virtiofs export though. So
> > perhaps there's scope for supporting usage of a per-mount
> > point relabel trigger. eg Host creates $VIRTIOFS-ROOT/.autorelabel
> > and whenever the guest sees a new virtiofs export arriving, it
> > can look for $VIRTIOFS-MOUNT-POINT/.autorelabel
> 
> Per mount point auto relabel seems interesting. Will it relabel
> everytime virtiofs export shows up. Or it will intelligence to
> figure out exported fs is already labeled (say from previous boot)
> and no need to relabel again.

Normal behaviour with the existing global /.autorelabel is that
selinux deletes the file once the relabel is complete, so it is
a one-time thing.

Essentially anytime you need to force[1] a one-time only relabel you
just do

   "touch /.autorelabel && reboot"


DanW does however recommend that you configure your system such
that the labels are always correct and thus don't need the global
relabel. https://danwalsh.livejournal.com/38157.html

None the less I think the virtiofs situation is slightly different
and justifies a way to force relabel, provided it can be scoped
to just that one filesystem mount.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

