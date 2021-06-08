Date: Tue, 8 Jun 2021 16:55:03 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YL+S13wU+C4cmNZu@work-vm>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
	<0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
	<20210604134439.GB269481@redhat.com> <YLoxwQIyqAazPHqf@redhat.com>
	<YL4p62JFkItB9l9K@redhat.com>
	<50f271ef-cc5e-e016-e9b6-8bb8ed5055dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <50f271ef-cc5e-e016-e9b6-8bb8ed5055dd@gmail.com>
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
>=20
> On 6/7/21 9:15 AM, Daniel P. Berrang=E9 wrote:
> > On Fri, Jun 04, 2021 at 02:59:29PM +0100, Daniel P. Berrang=E9 wrote:
> >> On Fri, Jun 04, 2021 at 09:44:39AM -0400, Vivek Goyal wrote:
> >>> On Thu, Jun 03, 2021 at 10:14:24PM -0400, Link Dupont wrote:
> >>>> On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont <link@sub-pop.n=
et>
> >>>> wrote:
> >>>>>  reproducible scenarios
> >>>> Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a
> >>>> virtiofs filesystem and with xattr on), the type of files in the mou=
nted
> >>>> hierarchy are unlabeled_t. I can work around that by switching SELin=
ux in
> >>>> the guest to permissive or disabled.
> >>> cc Dan Walsh. I was discussing this with Dan Walsh yesterday in gener=
al.
> >>>
> >>> In general, if we want to enable SELinux both on host and guest, then
> >>> both host and guest should have same SELinux policy. Otherwise there
> >>> will be lot of different kind of conflicts because both host and
> >>> guest will try to work with same selinux label. I guess that in
> >>> practice this will be very hard to achieve as people will run
> >>> different host and guest flavors and these might have different
> >>> policies.
> >> Yeah, I think there's little to no chance of people keeping the
> >> same SELinux policy in host/guest, except in very tightly controlled
> >> narrow use cases where the host admin exerts direct control over
> >> the precise guest config.
> >>
> >>
> >>> So another option is to rename selinux xattr in virtiofs so that
> >>> any selinux xattr coming from guest is saved as
> >>> user.virtiofs.security.selinux xattr on host. That way host and guest
> >>> can have their separate labels without interfering with each other.
> >>> David Gilbert already has added support for this. I can't remember
> >>> the exact syntax but you can figure it out from documentation here
> >>> in xattr remappig section.
> >> For general purpose virt usage, I think remapping in some way is
> >> likely to be needed as the default strategy.
> >>
> >>> https://github.com/qemu/qemu/blob/master/docs/tools/virtiofsd.rst
> >>>
> >>> But I have question with selinux xattr remapping. What will happen
> >>> to initial labels when fs is exported. I mean until and unless
> >>> some process in guest labels all the exported files, they all
> >>> with either be unlabeled or pick some generic label for all the
> >>> files.
> >> I'd say you need some mechanism to force a re-label inside the
> >> guest. Normally a relabel will be done in /.autorelabel file
> >> is present, or in certain other scenarios like selinux policy
> >> RPM updates.
> >>
> >> We wouldn't want to force a relabel neccesarily for the entire
> >> FS if we're just hotplugging a new virtiofs export though. So
> >> perhaps there's scope for supporting usage of a per-mount
> >> point relabel trigger. eg Host creates $VIRTIOFS-ROOT/.autorelabel
> >> and whenever the guest sees a new virtiofs export arriving, it
> >> can look for $VIRTIOFS-MOUNT-POINT/.autorelabel
> >>
> >>> Another option is, can we use a single label for whole of the
> >>> virtiofs (using context=3D<label>) option in guest. That way nothing
> >>> is saved in files as such. But this means that processes in guest
> >>> can't have different selinux labels on different virtiofs dir/files.
> >> Forcing a single label for the entire export is passable as a
> >> fallback plan. This is what people have done for years with
> >> NFS v3 mounts. It has annoying usage limitations though, so
> >> if at all possible remapping is a preferrable approach.
> > Another thing we should bear in mind is that it is entirely plausible f=
or
> > users to want SELinux in their guest, wihle the host is not using SELin=
ux
> > at all. eg running a RHEL guest, on a cloud running Ubuntu hosts.
> >
> > In such a case SELinux essentially won't exist from the POV of the
> > host OS / admin using. Anything related to labelling will have to be
> > exclusively done by the guest. If we provide a general purpose way
> > to remap XAttrs, then this ought to be viable by having a generic
> > remap rule for anything the guest does.
> >
> > Regards,
> > Daniel
>=20
> Three cheers -- As someone who has to deal with various host/guest
> distros, including specifically rhel/centos/fedora guests on
> debian/ubuntu/etc hosts:=A0 Notice I think all concerned want a 'host
> snapshot' of a rhel running guest directory tree to do the right thing
> if 'sent' to another server which is selinux enabled.=A0 The ability
> virtiofsd has to map xattrs is pretty good, and the virtiofs team should
> make sure that mapping system works on both selinux and non-selinux
> hosts.=A0 Whether the host enforces those can be left to the host.

As long as they map to user.something (e.g. user.virtiofsd.) then
my understanding is the host should allow the virtiofsd to do what it
likes with those; it wouldn't be able to see the host labels though.

Note that there are weird mappings I'd probably caution against; for
example you can probably get the mapping engine to write any
security.something as user.virtiofsd.security.something but then
to see the visibility of both an original and a remapped name
as security.something inside the guest;  that might let you see
both host's labels and your own - which could be both convenient and
also very confusing.

Dave

> Regards,
>=20
> Harry
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

