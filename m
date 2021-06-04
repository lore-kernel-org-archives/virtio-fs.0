Date: Fri, 4 Jun 2021 10:11:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210604141147.GD269481@redhat.com>
References: <2234280.ElGaqSPkdT@subpop>
	<ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
	<9W25UQ.OHKWX78P32DI3@sub-pop.net> <YLksUpVCCovgUAtq@work-vm>
	<MYJ5UQ.562L1XU7LNSJ3@sub-pop.net>
	<0KN5UQ.JVDR5LJRMJIQ3@sub-pop.net>
	<8440ac8b-e72d-b9c4-9b43-1d788b9041b1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8440ac8b-e72d-b9c4-9b43-1d788b9041b1@gmail.com>
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

On Fri, Jun 04, 2021 at 08:30:26AM -0500, Harry G. Coin wrote:
>=20
> On 6/3/21 9:14 PM, Link Dupont wrote:
> > On Thu, Jun 3 2021 at 08:56:46 PM -0400, Link Dupont
> > <link@sub-pop.net> wrote:
> >> =A0reproducible scenarios
> >
> > Alright. I reran my tests with a CentOS 8 guest. On CentOS 8 (with a
> > virtiofs filesystem and with xattr on), the type of files in the
> > mounted hierarchy are unlabeled_t. I can work around that by switching
> > SELinux in the guest to permissive or disabled.
> >
> > With a CentOS 7 guest, things get less usable. I digested this to a
> > reproducible scenario.
> >
> > Build a disk image with `virt-builder`, configuring the CentOS Plus
> > kernel to get 9p support.
> >
> > virt-builder centos-7.8 \
> > --root-password password:centos \
> > --output centos-7.8.qcow2 \
> > --install yum-utils \
> > --run-command 'yum-config-manager --enable centosplus' \
> > --run-command 'sed -ie
> > "s/DEFAULTKERNEL=3Dkernel/DEFAULTKERNEL=3Dkernel-plus/"
> > /etc/sysconfig/kernel' \
> > --append-line
> > '/etc/dracut.conf.d/virtio.conf:add_drivers+=3D"virtio_scsi virtio_pci
> > virtio_console"' \
> > --append-line '/etc/modules-load.d/9pnet_virtio.conf:9pnet_virtio' \
> > --install kernel-plus \
> > --append-line '/etc/fstab:home /home 9p trans=3Dvirtio,version=3D9p2000=
.L
> > 0 0'
> >
> > Install the volume into the `default` pool.
> >
> > sudo install -m644 centos-7.8.qcow2 /var/lib/libvirt/images
> >
> > Next, define a domain using the disk image (using `virt-install` here
> > for "easy mode").
> >
> > virt-install \
> > --import \
> > --os-variant centos7.0 \
> > --name centos \
> > --ram 2048 \
> > --disk path=3D/var/lib/libvirt/images/centos-7.8.qcow2 \
> > --memorybacking access.mode=3Dshared \
> > --filesystem source=3D/home,target=3Dhome,accessmode=3Dpassthrough \
> > --autoconsole none
> >
> > Now with SELinux enforcing, I cannot list the contents of the
> > directories in the mounted hierarchy.
> >
> > [root@localhost ~]# ls -lZ /home/link
> > ls: cannot open directory /home/link: Permission denied
> >
> >
> Link, You have four choices right now:
>=20
> 1) Stick with rhel/centos/fedora type distros and ignore virtiofs for at
> least 6 months, more like a year, for virtiofs to be implemented
> properly by the typical GUI enabled virt-manager/qemu/kvm resources you
> know about, and also not just wedge (worse than crash) your system by
> breaking things like 'dnf' and 'rpm' randomly when upgrades happen --
> blocking upgrades (and that's with 'permissive'). =A0 The big speed
> advantage to virtiofs comes with a feature termed 'dax', and what it
> takes to make that work is a whole lot of 'by hand' right now.=A0 It's
> going to be so fast I bet nearly everyone will migrate to it in due
> course, but it's not ready for non-experts yet.
>=20
> 2) Switch to debian type distros (ubuntu, mint, debian, etc.) which do
> not have selinux, instead apparmor, and enjoy virtiofs without dax in a
> fairly stable way so long as you're ok with the promise of 'dax' coming
> and it will all 'just work and get super fast almost automagically' with
> typical upgrades in due course.=A0 Just know that good operations will
> only happen if the shared directory on the host is not used by anything
> whatsoever of importance on the host while the guest is running.=A0 You
> can take 'snapshots' on the host that 'back up' the (not then running)
> guest very easily.
>=20
> 3) Make virtiofs an area you want to develop deep knowledge about, be
> willing to accept your systems won't be stable enough for anything
> outside a lab or workshop, at least one thing you care about will break
> in some way at least=A0 one time per every four 'dnf upgrades' and switch
> to fedora.

You are using virtiofs as rootfs and upgrade breaks? If virtiofs is
being used only as volumes, then its outside the upgrade path. Will
like to know what broke for you. Was it all SELinux related or something
else.

> You'll have to learn a fair few quite obscure selinux
> commands to get it to comprehend virtiofs is a filesystem and not flood
> your logs, use the 'xml' features of virtual machine manager to get the
> bits of virtiofs you want enabled properly (like 'numa',

I am assumig libvirt takes care of specifying "numa" stuff? Is that
not the case?

> learn what
> 'hugepages' are and do the math on each host to set enough of those
> aside with in sysctl.d (e.g. vm.nr_hugepages =3D 11776) ,

What's the virtiofs dependency on vm.nr_hugepages? I think I am not
aware of this aspect.


> and also accept
> some versions of hosts and guests will develop incompatibilities so
> severe you'll have to restore to backups and downgrades from time to
> time.=A0 And you won't be able to use virtiofs as a root filesystem
> without patching dracut config directories (search this list) or
> compiling your own custom kernel.=A0 But you will learn a whole lot.

Agreed that dracut does not seem to have support to mount virtiofs
as rootfs. That's one TODO item.=20

I am assuming you prefer using virtiofs as rootfs for your VMs and
that's why running into these dracut related issues.

Thanks
Vivek

>=20
> 4)=A0 Stick with rhel/fedora/centos, create a file on the host (check on
> fallocate and chattr +C) use that as a block disk image for the guest,
> and watch and wait until virtiofs becomes 'real' on stable systems, then
> bring the guest down, unpack the file into a directory tree, use the
> then available 'all good' drop down list to 'pick' virtiofs and have a
> rocket -- about a year from now or so.
>=20
> That's pretty much where we are today I think.
>=20
> Harry
>=20
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

