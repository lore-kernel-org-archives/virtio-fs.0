Date: Thu, 19 Nov 2020 14:44:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201119194424.GD3300@redhat.com>
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
	<04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
	<20201119183841.GB3300@redhat.com>
	<20201119184436.GC3300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201119184436.GC3300@redhat.com>
Subject: Re: [Virtio-fs] restorcon/SELinux virtiofs question
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

On Thu, Nov 19, 2020 at 01:44:36PM -0500, Vivek Goyal wrote:
> On Thu, Nov 19, 2020 at 01:38:41PM -0500, Vivek Goyal wrote:
> > On Thu, Nov 19, 2020 at 12:27:20PM -0600, Harry G. Coin wrote:
> > >=20
> > > On 11/19/20 12:16 PM, Vivek Goyal wrote:
> > > > On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
> > > >> Hello virtiofs team.=C2=A0 I need clarification about a 'restoreco=
n' selinux
> > > >> guest giving an 'operation not supported' response.
> > > >>
> > > >> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
> > > >> running SELinux,
> > > > I suspect that on host setxattr(security.selinux) is failing with=20
> > > > "operation not supported".=20
> > > >
> > > > What do you mean by host "not running SELinux". SElinux is not comp=
iled
> > > > in? Or it is disabled or in passive mode?
> > > >
> > > > Is it working with filesystems other than btrfs, say ext4 or xfs.
> > > >
> > > > Now qemu supports xattr remapping. You might want to run virtiofsd
> > > > to remap security.selinux. I think that might get you going till
> > > > the root cause of the issue is found.
> > > >
> > > > Vivek
> > >=20
> > > Thank you for the focus.=A0=A0 The host os in this instance is not fr=
om the
> > > fedora/rhel/centos world with selinux running.=A0 My case is a debian
> > > sourced distro (ubuntu).=A0 That world uses 'apparmor' by default, not
> > > selinux.=A0=A0 I think it's reasonable to suppose there are a lot of =
servers
> > > out there not running selinux that have lots of vms running on them, =
not
> > > all using virtiofs.=A0 There should be a documented way to allow the
> > > 'restorcon' command on one of many guests on such hosts to work.=A0 I
> > > suppose to wrap this up:
> > >=20
> > > For the future readers who got here by searching,=A0 could you give t=
he
> > > first kernel version that supports a non-selinux host supporting an
> > > selinux enabled guest and the virtiofsd command line necessary to get
> > > the restorecon command to work normally?
> >=20
> > I don't know yet. Because I don't know what's the root cause of the
> > issue.
> >=20
> > The way you are explaining it, looks like host kernel somehow is
> > blocking setxattr(security.selinux). And I have no idea why. Is it
> > apparmor or something else.
> >=20
> > If no selinux module is loaded on host, then as long as virtiofsd
> > process has CAP_SYS_ADMIN, it should be able to set security.selinux.
> >=20
> > "Operation not supported" means error "EOPNOTSUP". I am assuming
> > you are running virtiofsd with "-o xattr" to make sure virtiofsd
> > supports xattr. If that's the case somehow kernel is returning
> > "EOPNOTSUP".
> >=20
> > Can you run virtiofsd with debug option -d and try to install that
> > package in guest and capture outout of virtiofsd and post here. It
> > might confirm that host kernel is returning error.
>=20
> I tried doing "chcon unconfined_u:object_r:admin_home_t:s0 bar.txt"=20
> on a file in virtiofs and got "Operation not supported". I think
> guest kernel failed this. Will need to debug further.

Ok, Dan Walsh says that it probably is due to the fact that selinux
policy in guest is not aware of virtiofs. He has opened a PR to
add that.

https://github.com/fedora-selinux/selinux-policy/pull/478

I am not sure what distribution you are running as guest but it
probably will require similar changes. Once this package is built
I will give it a try.

Thanks
Vivek

