Date: Wed, 9 Feb 2022 10:08:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YgPY8FMA9ikejw0L@redhat.com>
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEZDOcFr80tZGWd@redhat.com> <YgGM6pA2sXEAMa3a@redhat.com>
	<YgIw+juiHLCXEhNn@redhat.com>
	<CAJh=p+65FWDbze_86RqBKtd=at_Cj6E2YmUz=5pE29fd--zzwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJh=p+65FWDbze_86RqBKtd=at_Cj6E2YmUz=5pE29fd--zzwA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v5 0/9] virtiofsd: Add support for file
 security context at file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-devel@nongnu.org

On Wed, Feb 09, 2022 at 11:24:29AM +0100, German Maglione wrote:
> On Tue, Feb 8, 2022 at 11:44 PM Daniel P. Berrang=E9 <berrange@redhat.com>
> wrote:
>=20
> > On Mon, Feb 07, 2022 at 04:19:38PM -0500, Vivek Goyal wrote:
> > > On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrang=E9 wrote:
> > > > On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
> > > > > Hi,
> > > > >
> > > > > This is V5 of the patches. I posted V4 here.
> > > > >
> > > > >
> > https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> > > > >
> > > > > These will allow us to support SELinux with virtiofs. This will s=
end
> > > > > SELinux context at file creation to server and server can set it =
on
> > > > > file.
> > > >
> > > > I've not entirely figured it out from the code, so easier for me
> > > > to ask...
> > > >
> > > > How is the SELinux labelled stored on the host side ? It is stored
> > > > directly in the security.* xattr namespace,
> > >
> > > [ CC Dan Walsh ]
> > >
> > > I just tried to test the mode where I don't do xattr remapping and try
> > > to set /proc/pid/attr/fscreate with the context I want to set. It will
> > > set security.selinux xattr on host.
> > >
> > > But write to /proc/pid/attr/fscreate fails if host does not recognize
> > > the label sent by guest. I am running virtiofsd with unconfined_t but
> > > it still fails because guest is trying to create a file with
> > > "test_filesystem_filetranscon_t" and host does not recognize this
> > > label. Seeing following in audit logs.
> > >
> > > type=3DSELINUX_ERR msg=3Daudit(1644268262.666:8111): op=3Dfscreate
> > invalid_context=3D"unconfined_u:object_r:test_filesystem_filetranscon_t=
:s0"
> >
> > Yes, that's to be expected if the host policy doesn't know about the
> > label that the guest is using.
> >
> > IOW, non-mapping case is only useful if you have a very good match
> > between host + guest OS policy. This could be useful for an app
> > like Kata because their guest is not a full OS, it is something
> > special purpose and tightly controlled.
> >
> > > So if we don't remap xattrs and host has SELinux enabled, then it
> > probably
> > > work in very limited circumstances where host and guest policies don't
> > > conflict. I guess its like running fedora 34 guest on fedora 34 host.
> > > I suspect that this will see very limited use. Though I have put the
> > > code in for the sake of completeness.
> >
> > For general purpose guest OS virtualization remapping is going to be
> > effectuively mandatory.  The non-mapped case only usable when you tight=
ly
> > control the guest OS packages from the host.
> >
>=20
>=20
> If remap is recommended, why not make it mandatory or automatic?,
> for instance, '-o security_label' either requires '-o xattrmap=3D' or
> automatically makes
> the mapping with the 'trusted' prefix, while  '-o security_label=3Dnomap'
> doesn't, so you
> can choose whatever you want.

It is a recommended settings but not a mandatory setting. So enforcing
any kind of policy will work for some and not for others.

We could refine it down the line depending on how it is used and where
people find it useful.

For now, primary focus is to get basic support patches in the tree.

Thanks
Vivek

>=20
> (I'm not suggesting the 'nomap' name, I'm terrible choosing names)
>=20
> --=20
> German

