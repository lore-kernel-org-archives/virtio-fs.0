Date: Thu, 19 Nov 2020 13:16:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201119181635.GA3300@redhat.com>
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
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

On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
> Hello virtiofs team.=A0 I need clarification about a 'restorecon' selinux
> guest giving an 'operation not supported' response.
>=20
> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
> running SELinux,

I suspect that on host setxattr(security.selinux) is failing with=20
"operation not supported".=20

What do you mean by host "not running SELinux". SElinux is not compiled
in? Or it is disabled or in passive mode?

Is it working with filesystems other than btrfs, say ext4 or xfs.

Now qemu supports xattr remapping. You might want to run virtiofsd
to remap security.selinux. I think that might get you going till
the root cause of the issue is found.

Vivek

> and the guest has virtiofs root with selinux active,
> what version [if any] for virtiofs is necessary before I can expect the
> restorecon command to operate properly?=A0 (Or, maybe I've missed a config
> setting somewhere?)=A0
>=20
> Packages such as freeipa fail to install because they issue dozens of
> 'restorecon' calls which fail using virtiofs.
>=20
> Thanks,
>=20
> Harry Coin
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

