Date: Mon, 7 Feb 2022 16:19:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YgGM6pA2sXEAMa3a@redhat.com>
References: <20220202193935.268777-1-vgoyal@redhat.com>
	<YgEZDOcFr80tZGWd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YgEZDOcFr80tZGWd@redhat.com>
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
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Feb 07, 2022 at 01:05:16PM +0000, Daniel P. Berrang=E9 wrote:
> On Wed, Feb 02, 2022 at 02:39:26PM -0500, Vivek Goyal wrote:
> > Hi,
> >=20
> > This is V5 of the patches. I posted V4 here.
> >=20
> > https://listman.redhat.com/archives/virtio-fs/2022-January/msg00041.html
> >=20
> > These will allow us to support SELinux with virtiofs. This will send
> > SELinux context at file creation to server and server can set it on
> > file.
>=20
> I've not entirely figured it out from the code, so easier for me
> to ask...
>=20
> How is the SELinux labelled stored on the host side ? It is stored
> directly in the security.* xattr namespace,

[ CC Dan Walsh ]

I just tried to test the mode where I don't do xattr remapping and try
to set /proc/pid/attr/fscreate with the context I want to set. It will
set security.selinux xattr on host.

But write to /proc/pid/attr/fscreate fails if host does not recognize
the label sent by guest. I am running virtiofsd with unconfined_t but
it still fails because guest is trying to create a file with
"test_filesystem_filetranscon_t" and host does not recognize this
label. Seeing following in audit logs.

type=3DSELINUX_ERR msg=3Daudit(1644268262.666:8111): op=3Dfscreate invalid_=
context=3D"unconfined_u:object_r:test_filesystem_filetranscon_t:s0"

So if we don't remap xattrs and host has SELinux enabled, then it probably
work in very limited circumstances where host and guest policies don't
conflict. I guess its like running fedora 34 guest on fedora 34 host.=20
I suspect that this will see very limited use. Though I have put the
code in for the sake of completeness.

Thanks
Vivek

> or is is subject to
> xattr remapping that virtiofsd already supports.
>=20
> Storing directly means virtiofsd has to run in an essentially
> unconfined context, to let it do arbitrary  changes on security.*
> xattrs without being blocked by SELinux) and has risk that guest
> initiated changes can open holes in the host confinement if
> the exported FS is generally visible to processes on the host.
>=20
>=20
> Using remapping lets virtiofsd be strictly isolated by SELinux
> policy on the host, and ensures that guest context changes
> can't open up holes in the host.
>=20
> Both are valid use cases, so I'd ultimately expect us to want
> to support both, but my preference for a "default" behaviour
> would be remapping.
>=20
> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
>=20

