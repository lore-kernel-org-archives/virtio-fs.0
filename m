Date: Thu, 10 Sep 2020 19:38:46 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200910183846.GO2814@work-vm>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-4-dgilbert@redhat.com>
	<20200909112012.GD1377607@lpt>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200909112012.GD1377607@lpt>
Subject: Re: [Virtio-fs] [PATCH v2 3/6] tools/virtiofsd: xattr name
	mappings: Add option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* J=E1n Tomko (jtomko@redhat.com) wrote:
> On a Thursday in 2020, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> >=20
> > Add an option to define mappings of xattr names so that
> > the client and server filesystems see different views.
> > This can be used to have different SELinux mappings as
> > seen by the guest, to run the virtiofsd with less privileges
> > (e.g. in a case where it can't set trusted/system/security
> > xattrs but you want the guest to be able to), or to isolate
> > multiple users of the same name; e.g. trusted attributes
> > used by stacking overlayfs.
> >=20
> > A mapping engine is used wit 3 simple rules; the rules can
> > be combined to allow most useful mapping scenarios.
> > The ruleset is defined by -o xattrmap=3D'rules...'.
> >=20
> > This patch doesn't use the rule maps yet.
> >=20
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> > docs/tools/virtiofsd.rst         |  55 ++++++++++++
> > tools/virtiofsd/passthrough_ll.c | 148 +++++++++++++++++++++++++++++++
> > 2 files changed, 203 insertions(+)
> >=20
> > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > index 824e713491..2efa16d3c5 100644
> > --- a/docs/tools/virtiofsd.rst
> > +++ b/docs/tools/virtiofsd.rst
> > @@ -107,6 +107,60 @@ Options
> >   performance.  ``auto`` acts similar to NFS with a 1 second metadata c=
ache
> >   timeout.  ``always`` sets a long cache lifetime at the expense of coh=
erency.
> >=20
> > +xattr-mapping
> > +-------------
> > +
> > +By default the name of xattr's used by the client are passed through t=
o the server
> > +file system.  This can be a problem where either those xattr names are=
 used
> > +by something on the server (e.g. selinux client/server confusion) or i=
f the
> > +virtiofsd is running in a container with restricted priviliges where i=
t cannot
>=20
> privileges

Fixed.

> > +access some attributes.
> > +
> > +A mapping of xattr names can be made using -o xattrmap=3Dmapping where=
 the ``mapping``
> > +string consists of a series of rules.
> > +
> > +The first matching rule terminates the mapping.
> > +
> > +Each rule consists of a number of fields separated with a separator th=
at is the
> > +first non-white space character in the rule.  This separator must then=
 be used
> > +for the whole rule.
> > +White space may be added before and after each rule.
> > +Using ':' as the separator a rule is of the form:
> > +
> > +``:scope:type:key:prepend:``
> > +
> > +**scope** is:
> > +
> > +- 'client' - match 'key' against a xattr name from the client for
> > +             setxattr/getxattr/removexattr
> > +- 'server' - match 'prepend' against a xattr name from the server
> > +             for listxattr
> > +- 'all' - can be used to match both cases.
> > +
> > +**type** is one of:
> > +
> > +- 'prefix' - If 'key' matches the client then the 'prepend'
> > +  is added before the name is passed to the server.
> > +  For a server case, the prepend is tested and stripped
> > +  if matching.
> > +
> > +- 'ok' - The attribute name is OK and passed through to
> > +  the server unchanged.
> > +
> > +- 'bad' - If a client tries to use this name it's
> > +  denied using EPERM; when the server passes an attribute
> > +  name matching it's hidden.
> > +
> > +**key** is a string tested as a prefix on an attribute name originating
> > +on the client.  It maybe empty in which case a 'client' rule
> > +will always match on client names.
> > +
> > +**prepend** is a string tested as a prefix on an attribute name origin=
iating
>=20
> originating

Done.

> > +on the server, and used as a new prefix.  It maybe empty
>=20
> may be

OK

> > +in which case a 'server' rule will always match on all names from
> > +the server.
> > +
> > +
> > Examples
> > --------
> >=20
> > @@ -123,3 +177,4 @@ Export ``/var/lib/fs/vm001/`` on vhost-user UNIX do=
main socket
> >       -numa node,memdev=3Dmem \
> >       ...
> >   guest# mount -t virtiofs myfs /mnt
> > +
>=20
> git complains about trailing whitespace at EOF

Eaten.

Dave

> Jano


--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

