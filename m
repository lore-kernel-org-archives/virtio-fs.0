Date: Mon, 28 Jun 2021 13:22:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210628172240.GE1803896@redhat.com>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
	<20210628131708.GA1803896@redhat.com>
	<1b446468-dcf8-9e21-58d3-c032686eeee5@redhat.com>
	<5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
 symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Schaufler,
	Casey" <casey.schaufler@intel.com>

On Mon, Jun 28, 2021 at 09:04:40AM -0700, Casey Schaufler wrote:

[..]
> > on a host without SELinux support but the VM has SELinux enabled, then =
virtiofsd needs CAP_SYS_ADMIN.=A0 It would be much more secure if it only n=
eeded CAP_SYS_RESOURCE.
>=20
> I don't know, so I'm asking. Does virtiofsd really get run with limited c=
apabilities,
> or does it get run as root like most system daemons? If it runs as root t=
he argument
> has no legs.

It runs as root but we give it a set of minimum required capabilities by
default and want to avoid giving it CAP_SYS_ADMIN.

>=20
> > =A0 If the host has SELinux enabled then it can run without CAP_SYS_ADM=
IN or CAP_SYS_RESOURCE, but it will only be allowed to write labels that th=
e host system understands, any label not understood will be blocked. Not on=
ly this, but the label that is running virtiofsd pretty much has to run as =
unconfined, since it could be writing any SELinux label.
>=20
> You could fix that easily enough by teaching SELinux about the proper
> use of CAP_MAC_ADMIN. Alas, I understand that there's no way that's
> going to happen, and why it would be considered philosophically repugnant
> in the SELinux community.=20
>=20
> >
> > If virtiofsd is writing Userxattrs with CAP_SYS_RESOURCE, then we can r=
un with a confined SELinux label only allowing it to sexattr on the content=
 in the designated directory, make the container/vm much more secure.
> >
> User xattrs are less protected than security xattrs. You are exposing the
> security xattrs on the guest to the possible whims of a malicious, unpriv=
ileged
> actor on the host. All it needs is the right UID.

One of the security tenets of virtiofs is that this shared directory should
be hidden from unprivliged users. Otherwise guest can drop setuid root
binaries in shared directory and unprivliged user on host executes it and
gets control of the host.

So unpriviliged actor on host having access to these shared directory
contents is wrong configuration.

>=20
> We have unused xattr namespaces. Would using the "trusted" namespace
> work for your purposes?

That requires giving CAP_SYS_ADMIN to daemon and one of the goals is
to give as little capabilities as possible to virtiofsd. In fact people
have been asking for the capablities to run virtiofsd unpriviliged
as well as run inside a user namespace etc.

Anyway, remapping LSM xattrs to "trusted.*" space should work as long
as virtiofsd has CAP_SYS_ADMIN.

Thanks
Vivek

