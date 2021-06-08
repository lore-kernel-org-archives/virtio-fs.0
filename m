Date: Tue, 8 Jun 2021 15:26:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210608192617.GC504497@redhat.com>
References: <20210608153524.GB504497@redhat.com>
	<8929c252-3d99-8cdb-1c56-5fdb1fd29fc2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8929c252-3d99-8cdb-1c56-5fdb1fd29fc2@gmail.com>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>"
 syntax for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

On Tue, Jun 08, 2021 at 01:38:56PM -0500, Harry G. Coin wrote:
> On 6/8/21 10:35 AM, Vivek Goyal wrote:
> > We want to be able to mount virtiofs as rootfs and pass appropriate
> > kernel command line. Right now there does not seem to be a good way
> > to do that. If I specify "root=3Dmyfs rootfstype=3Dvirtiofs", system
> > panics.
> >
> > virtio-fs: tag </dev/root> not found
> > ..
> > ..
> > [ end Kernel panic - not syncing: VFS: Unable to mount root fs on unkno=
wn-block(0,0) ]
>=20
> Whatever the best direction forward might be for kernel patches
> regarding 'not block device as root', it would ease learning curves if
> 'the patterns that set config issue X' were the same across root 'not
> block device options' whether cephfs, nfs, 9p, virtiofs.

I think achieveing same pattern for all non-block options is pretty
hard. There are too many varieits, mtd, ubifs, nfs, cifs, and you
just mentioned cephfs.

It would be nice if somebody can achieve it. But that should not be
a blocker for this patch. Goal of this patch is to take care of virtiofs
and 9p. And any other filesystem which can work with this pattern.

I think ubi and mtd should be able to work with "root=3Dfstag:<tag>"
as well. Something like "root=3Dfstag:ubi:foo". And then ubi:foo
will should be passed to ubifs. I think only thing missing is
that current code assumes there is one filesystem passed in
rootfstype. If we want to try mounting device with multiple
filesystems then one can modify the code to call do_mount_root()
in a loop from a filesystem list.

Right now I did not need it, so I did not add it.

> All of them
> will have to handle the selinux xattr/issue, posix and flock issues,
> caching etc.

Filesystem specific flags will be passed by rootflags=3D.

> While by definition virtiofs has to exist only in a vm
> guest, the others could be baremetal or vm guest roots.=A0 (How much 9p's
> other-than-guest transports are used I don't know).
>=20
> FYI (though patching the kernel may be the best option)=A0 there is a case
> that does not have those kernel panics for virtiofs-root and 9p root
> using stock fc34.=A0 As 9p, the virtiofs method uses the initrd creation
> mechanisms provided by 'dracut' or 'initramfs' to provide the 'sysroot
> pivot glue'.
>=20
> On the fc34 guest a successful 'direct kernel boot' today looks like:
>=20
> kernel path: /vmsystems/fedora_generic/boot/vmlinuz
>=20
> initrd path: /vmsystems/fedora_generic/boot/initrd.img
>=20
> Kernel args: root=3Dvirtiofs:myfs rd.shell rd.fstab

Does it work with upstream dracut or you have modified dracut to
parse "root=3Dvirtiofs:myfs" option.

I think it probably is better that both kernel and dracut parse
and understand same "root=3D" format string and I will try to
avoid creating a "root=3D" option which dracut understands but
not kernel. Or try creating two different wasy to mount=20
virtiofs using "root=3D" for kernel and dracut.

That's why I am first trying to get this new syntax in the kernel
and once it works, I want to follow up with dracut folks to
parse "root=3Dfstag:<tag>" and be able to mount virtiofs/9p/foo
filesystem.

Thanks
Vivek

>=20
>=20
> The xml to pass through virtio-fs is:
>=20
> <filesystem type=3D"mount" accessmode=3D"passthrough">
> =A0 <driver type=3D"virtiofs" queue=3D"1024"/>
> =A0 <binary xattr=3D"on">
> =A0=A0=A0 <lock posix=3D"on" flock=3D"on"/>
> =A0 </binary>
> =A0 <source dir=3D"/vmsystems/fedora_generic"/>
> =A0 <target dir=3D"myfs"/>
> </filesystem>
>=20
> The guest fstab is:
>=20
> myfs / virtiofs defaults 0 0
>=20
> HTH
>=20
> Harry Coin
>=20
>=20
>=20

