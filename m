Date: Tue, 1 Jun 2021 09:02:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210601130245.GA24846@redhat.com>
References: <e1437314-4870-a3a3-e866-8be50282ce3c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e1437314-4870-a3a3-e866-8be50282ce3c@gmail.com>
Subject: Re: [Virtio-fs] regression: lsetfilecon fails, breaks rpm, dpkg,
 dnf in virtiofs guests.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>

On Sat, May 29, 2021 at 01:42:50PM -0500, Harry G. Coin wrote:
> Some regression in virtio-fs has led to rpm/dnf/yum failing=A0 in the same
> guest it previously worked.
>=20
> linux 5.11.19-300.fc34.x86_64
>=20
> Specifically, all attempts to use dnf/yum lead to examples similar to thi=
s:
>=20
> Error unpacking rpm package dnf-4.7.0-1.fc34.noarch
> =A0 Upgrading=A0=A0=A0=A0=A0=A0=A0 :
> python3-dnf-plugins-core-4.0.21-1.fc34.noarch=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> 8/20
> error: unpacking of archive failed on file /usr/bin/dnf;60b1b277: cpio:
> (error 0x2)
> error: dnf-4.7.0-1.fc34.noarch: install failed
> error: lsetfilecon: (/etc/dnf/plugins/copr.conf,
> system_u:object_r:etc_t:s0) Operation not permitted
> error: Plugin selinux: hook fsm_file_prepare failed

CCing Dan Walsh and Ondrej. They might have an idea.

Thanks
Vivek

>=20
> (
>=20
> For all packages.=A0 No updates are possible.=A0 Possibly related to:
> https://github.com/fedora-selinux/selinux-policy/pull/478/files/21a2df26c=
d605c55de7edc80e16907fcb76ccf08=A0
> ?=A0 What really gets me, is this error exists even though
>=20
> # getenforce
> Permissive
>=20
> )
>=20
> The host is running btrfs.=A0 ... virtiofsd --fd=3D50 -o
> source=3D/vmsystems/fedora_generic,xattr,flock,posix_lock
>=20
> same effect with=A0 .... virtiofsd --fd=3D36 -o
> source=3D/vmsystems/dbl1,xattr,flock,no_posix_lock
>=20
> /etc/fstab:
>=20
> myfs / virtiofs seclabel 0 0
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

