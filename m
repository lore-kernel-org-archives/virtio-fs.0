Date: Thu, 10 Sep 2020 19:42:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200910184229.GP2814@work-vm>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-7-dgilbert@redhat.com>
	<20200909113553.GE1377607@lpt>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200909113553.GE1377607@lpt>
Subject: Re: [Virtio-fs] [PATCH v2 6/6] tools/virtiofsd: xattr name mapping
	examples
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
> > Add a few examples of xattrmaps to the documentation.
> >=20
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> > docs/tools/virtiofsd.rst | 49 ++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 49 insertions(+)
> >=20
> > diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> > index 2efa16d3c5..a138549862 100644
> > --- a/docs/tools/virtiofsd.rst
> > +++ b/docs/tools/virtiofsd.rst
> > @@ -161,6 +161,55 @@ in which case a 'server' rule will always match on=
 all names from
> > the server.
> >=20
> >=20
> > +xattr-mapping Examples
> > +----------------------
> > +
> > +1) Prefix all attributes with 'user.virtiofs.'
> > +
> > +::
> > +
> > +-o xattrmap=3D":all:prefix::user.virtiofs.::all:bad:::"
> > +
> > +
> > +This uses two rules, using : as the field separator;
> > +the first rule prefixes and strips 'user.virtiofs.',
> > +the second rule hides any non-prefixed attributes that
> > +the host set.
> > +
> > +2) Prefix 'trusted.' attributes, allow others through
> > +
> > +::
> > +
> > +   "/all/prefix/trusted./user.virtiofs./
> > +    /server/bad//trusted./
> > +    /client/bad/user.virtiofs.trusted.//
> > +    /all/ok///"
> > +
> > +
> > +Here there are four rules, using / as the field
> > +separator, and also demonstrating that new lines can
> > +be included between rules.
> > +The first rule is the prefixing of 'trusted.'.
> > +The second rule hides unprefixed 'trusted.' attributes
> > +on the host.
> > +The third rule stops a guest from explicitily setting
>=20
> explicitly

Thanks, I'll save that spare 'i' for another time.

> > +the 'user.viritofs.trusted.' path directly.
> > +Finally, the fourth rule lets all remaining attributes
> > +through.
> > +
> > +3) Hide 'security.' attributes, and allow everything else
> > +
> > +::
> > +
> > +    "/all/bad/security./security./
> > +     /all/ok///'
> > +
> > +The first rule combines what could be separate client and server
> > +rules into a single 'all' rule, matching 'security.' in either
> > +client arguments or lists returned from the host.  This stops
> > +the client seeing any 'security.' attributes on the server and
> > +stops it setting  any.
>=20
> extra space.

Gone.

> Reviewed-by: J=E1n Tomko <jtomko@redhat.com>

Thanks!

>=20
> Jano


--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

