Date: Mon, 7 Feb 2022 08:24:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YgEdeGud4xlZEAwy@redhat.com>
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
> directly in the security.* xattr namespace, or is is subject to
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

I am expecting users to configure virtiofsd to remap "security.selinux"
to "trusted.virtiofsd.security.selinux" and that will allow guest
and host security selinux to co-exist and allow separate SELinux policies
for guest and host.

I agree that my preference for a default behavior is remapping as well.
That makes most sense.=20

One downside of mapping to trusted namespace is that it requires
CAP_SYS_ADMIN for virtiofsd.

Having said that, these patches don't enforce the remapping default. That
has to come from the user because it also needs to be given CAP_SYS_ADMIN.
So out of box default is no remapping and passthrough SELinux.

Thanks
Vivek

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

