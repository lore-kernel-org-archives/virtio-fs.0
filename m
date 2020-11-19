Date: Thu, 19 Nov 2020 13:38:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201119183841.GB3300@redhat.com>
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
	<04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
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

On Thu, Nov 19, 2020 at 12:27:20PM -0600, Harry G. Coin wrote:
>=20
> On 11/19/20 12:16 PM, Vivek Goyal wrote:
> > On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
> >> Hello virtiofs team.=C2=A0 I need clarification about a 'restorecon' s=
elinux
> >> guest giving an 'operation not supported' response.
> >>
> >> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
> >> running SELinux,
> > I suspect that on host setxattr(security.selinux) is failing with=20
> > "operation not supported".=20
> >
> > What do you mean by host "not running SELinux". SElinux is not compiled
> > in? Or it is disabled or in passive mode?
> >
> > Is it working with filesystems other than btrfs, say ext4 or xfs.
> >
> > Now qemu supports xattr remapping. You might want to run virtiofsd
> > to remap security.selinux. I think that might get you going till
> > the root cause of the issue is found.
> >
> > Vivek
>=20
> Thank you for the focus.=A0=A0 The host os in this instance is not from t=
he
> fedora/rhel/centos world with selinux running.=A0 My case is a debian
> sourced distro (ubuntu).=A0 That world uses 'apparmor' by default, not
> selinux.=A0=A0 I think it's reasonable to suppose there are a lot of serv=
ers
> out there not running selinux that have lots of vms running on them, not
> all using virtiofs.=A0 There should be a documented way to allow the
> 'restorcon' command on one of many guests on such hosts to work.=A0 I
> suppose to wrap this up:
>=20
> For the future readers who got here by searching,=A0 could you give the
> first kernel version that supports a non-selinux host supporting an
> selinux enabled guest and the virtiofsd command line necessary to get
> the restorecon command to work normally?

I don't know yet. Because I don't know what's the root cause of the
issue.

The way you are explaining it, looks like host kernel somehow is
blocking setxattr(security.selinux). And I have no idea why. Is it
apparmor or something else.

If no selinux module is loaded on host, then as long as virtiofsd
process has CAP_SYS_ADMIN, it should be able to set security.selinux.

"Operation not supported" means error "EOPNOTSUP". I am assuming
you are running virtiofsd with "-o xattr" to make sure virtiofsd
supports xattr. If that's the case somehow kernel is returning
"EOPNOTSUP".

Can you run virtiofsd with debug option -d and try to install that
package in guest and capture outout of virtiofsd and post here. It
might confirm that host kernel is returning error.

Thanks
Vivek

>=20
> Thanks in advance!!=A0 (And thanks for the work -- can't wait for dax to
> make it into standard kernels!!)
>=20
> Harry Coin
>=20
>=20
>=20
>=20
> >
> >> and the guest has virtiofs root with selinux active,
> >> what version [if any] for virtiofs is necessary before I can expect the
> >> restorecon command to operate properly?=C2=A0 (Or, maybe I've missed a=
 config
> >> setting somewhere?)=C2=A0
> >>
> >> Packages such as freeipa fail to install because they issue dozens of
> >> 'restorecon' calls which fail using virtiofs.
> >>
> >> Thanks,
> >>
> >> Harry Coin
> >>
> >>
> >>
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://www.redhat.com/mailman/listinfo/virtio-fs
>=20

