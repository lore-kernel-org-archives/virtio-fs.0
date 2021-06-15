Date: Tue, 15 Jun 2021 15:57:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210615195740.GC965196@redhat.com>
References: <20210611120427.49736-1-berrange@redhat.com>
	<20210611154222.GA761698@redhat.com> <YMjLZUqZ5nhihJ1X@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YMjLZUqZ5nhihJ1X@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] docs: describe the security considerations
 with virtiofsd xattr mapping
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

On Tue, Jun 15, 2021 at 04:46:45PM +0100, Daniel P. Berrang=E9 wrote:
> On Fri, Jun 11, 2021 at 11:42:22AM -0400, Vivek Goyal wrote:
> > On Fri, Jun 11, 2021 at 01:04:27PM +0100, Daniel P. Berrang=E9 wrote:
> > > Different guest xattr prefixes have distinct access control rules app=
lied
> > > by the guest. When remapping a guest xattr care must be taken that the
> > > remapping does not allow the a guest user to bypass guest kernel acce=
ss
> > > control rules.
> > >=20
> > > For example if 'trusted.*' which requires CAP_SYS_ADMIN is remapped
> > > to 'user.virtiofs.trusted.*', an unprivileged guest user which can
> > > write to 'user.*' can bypass the CAP_SYS_ADMIN control. Thus the
> > > target of any remapping must be explicitly blocked from read/writes
> > > by the guest, to prevent access control bypass.
> > >=20
> > > The examples shown in the virtiofsd man page already do the right
> > > thing and ensure safety, but the security implications of getting
> > > this wrong were not made explicit. This could lead to host admins
> > > and apps unwittingly creating insecure configurations.
> > >=20
> > > Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>
> > > ---
> > >  docs/tools/virtiofsd.rst | 55 ++++++++++++++++++++++++++++++++++++--=
--
> > >  1 file changed, 50 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > > index 00554c75bd..6370ab927c 100644
> > > --- a/docs/tools/virtiofsd.rst
> > > +++ b/docs/tools/virtiofsd.rst
> > > @@ -127,8 +127,8 @@ Options
> > >    timeout.  ``always`` sets a long cache lifetime at the expense of =
coherency.
> > >    The default is ``auto``.
> > > =20
> > > -xattr-mapping
> > > --------------
> > > +Extended attribute (xattr) mapping
> > > +----------------------------------
> > > =20
> > >  By default the name of xattr's used by the client are passed through=
 to the server
> > >  file system.  This can be a problem where either those xattr names a=
re used
> > > @@ -136,6 +136,9 @@ by something on the server (e.g. selinux client/s=
erver confusion) or if the
> > >  virtiofsd is running in a container with restricted privileges where=
 it cannot
> > >  access some attributes.
> > > =20
> > > +Mapping syntax
> > > +~~~~~~~~~~~~~~
> > > +
> > >  A mapping of xattr names can be made using -o xattrmap=3Dmapping whe=
re the ``mapping``
> > >  string consists of a series of rules.
> > > =20
> > > @@ -232,8 +235,48 @@ Note: When the 'security.capability' xattr is re=
mapped, the daemon has to do
> > >  extra work to remove it during many operations, which the host kerne=
l normally
> > >  does itself.
> > > =20
> > > -xattr-mapping Examples
> > > -----------------------
> > > +Security considerations
> > > +~~~~~~~~~~~~~~~~~~~~~~~
> > > +
> > > +Operating systems typically partition the xattr namespace using
> > > +well defined name prefixes. Each partition may have different
> > > +access controls applied. For example, on Linux there are multiple
> > > +partitions
> > > +
> > > + * ``system.*`` - access varies depending on attribute & filesystem
> > > + * ``security.*`` - only processes with CAP_SYS_ADMIN
> > > + * ``trusted.*`` - only processes with CAP_SYS_ADMIN
> > > + * ``user.*`` - any process granted by file permissions / ownership
> > > +
> > > +While other OS such as FreeBSD have different name prefixes
> > > +and access control rules.
> > > +
> > > +When remapping attributes on the host, it is important to
> > > +ensure that the remapping does not allow a guest user to
> > > +evade the guest access control rules.
> > > +
> > > +Consider if ``trusted.*`` from the guest was remapped to
> > > +``user.virtiofs.trusted*`` in the host. An unprivileged
> > > +user in a Linux guest has the ability to write to xattrs
> > > +under ``user.*``. Thus the user can evade the access
> > > +control restriction on ``trusted.*`` by instead writing
> > > +to ``user.virtiofs.trusted.*``.
> > > +
> > > +As noted above, the partitions used and access controls
> > > +applied, will vary across guest OS, so it is not wise to
> > > +try to predict what the guest OS will use.
> > > +
> > > +The simplest way to avoid an insecure configuration is
> > > +to remap all xattrs at once, to a given fixed prefix.
> >=20
> > Remapping all xattrs seem to make sense. It probably will lead
> > to less confusion. Nested guests add another level of redirection.
> >=20
> > BTW, remapping xattr has limitation that it does not work on
> > symlinks. So "user.*" can't be set on symlink. And that means
> > selinux relabeling of symlinks fails with remapped xattrs.
> >=20
> > Not sure how to address this limitation. Host kernel imposes
> > this limit. (man xattr).
>=20
> Oh fun, I had not noticed this limitation before :-(
>=20
> Here are some ideas I had, none especially nice
>=20
>  - Use 'trusted.*' namespace for remapping instead of 'user.'
> =20
>    virtiofsd needs to have CAP_SYS_ADMIN though which is
>    quite horrible if your goal is to confine its privileges
>    in any meaningful way
>=20
>  - Store a symlinks' xattr on the target of the symlink
>=20
>    if the symlink has dev:inode  54:224, and points to
>    a file 'foo', then on 'foo' create an xattr
>    "user.virtiofs.link:54:224.<original xattrpath>"
>=20
>    This gets quite horrendous when you have symlinks
>    pointing to symlinks pointing to symlinks. Does
>    not work too well if the 'st_dev' value is
>    not stable across reboots either.
>=20
>  - Don't use xattrs at all for remapping, instead use
>    hidden files.
>=20
>    eg for a file 'foo', if an xattr is set then create
>    a file '.foo.xattr' in the same directory and store
>    the xattrs in that file in some format. Need to hide
>    this lookaside files from the guest of course.

I kind of like this idea of creating a regular file, say
.user.virtiofs.foo.xattr. So any file prefixed by ".user.virtiofs" will
be hidden from guest.

And probably same can be done for selinux labels for special files (device
nodes, pipes, sockets etc).=20

Thanks
Vivek

