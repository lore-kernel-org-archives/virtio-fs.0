Date: Wed, 9 Sep 2020 13:35:53 +0200
From: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Message-ID: <20200909113553.GE1377607@lpt>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-7-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
Content-Disposition: inline
In-Reply-To: <20200827153657.111098-7-dgilbert@redhat.com>
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
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On a Thursday in 2020, Dr. David Alan Gilbert (git) wrote:
>From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
>Add a few examples of xattrmaps to the documentation.
>
>Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>---
> docs/tools/virtiofsd.rst | 49 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)
>
>diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
>index 2efa16d3c5..a138549862 100644
>--- a/docs/tools/virtiofsd.rst
>+++ b/docs/tools/virtiofsd.rst
>@@ -161,6 +161,55 @@ in which case a 'server' rule will always match on al=
l names from
> the server.
>
>
>+xattr-mapping Examples
>+----------------------
>+
>+1) Prefix all attributes with 'user.virtiofs.'
>+
>+::
>+
>+-o xattrmap=3D":all:prefix::user.virtiofs.::all:bad:::"
>+
>+
>+This uses two rules, using : as the field separator;
>+the first rule prefixes and strips 'user.virtiofs.',
>+the second rule hides any non-prefixed attributes that
>+the host set.
>+
>+2) Prefix 'trusted.' attributes, allow others through
>+
>+::
>+
>+   "/all/prefix/trusted./user.virtiofs./
>+    /server/bad//trusted./
>+    /client/bad/user.virtiofs.trusted.//
>+    /all/ok///"
>+
>+
>+Here there are four rules, using / as the field
>+separator, and also demonstrating that new lines can
>+be included between rules.
>+The first rule is the prefixing of 'trusted.'.
>+The second rule hides unprefixed 'trusted.' attributes
>+on the host.
>+The third rule stops a guest from explicitily setting

explicitly

>+the 'user.viritofs.trusted.' path directly.
>+Finally, the fourth rule lets all remaining attributes
>+through.
>+
>+3) Hide 'security.' attributes, and allow everything else
>+
>+::
>+
>+    "/all/bad/security./security./
>+     /all/ok///'
>+
>+The first rule combines what could be separate client and server
>+rules into a single 'all' rule, matching 'security.' in either
>+client arguments or lists returned from the host.  This stops
>+the client seeing any 'security.' attributes on the server and
>+stops it setting  any.

extra space.

Reviewed-by: J=E1n Tomko <jtomko@redhat.com>

Jano

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE7DTm0WabvfIr7YZ4Ak1z5KIMl5QFAl9YvhQACgkQAk1z5KIM
l5QUKwf/ZBaLC62OyOmi7Ngv4ZNoHuNaNrtyfzD1D2nZCk+UG476FQQovF9zvol6
AYQhfWSdai8I5fJnCSGSt4XrbBxx5Y03zCWb7v6Dg+KoUHpOq+FANhSWKWJqbVz0
xqelEzZFXX28TBgXCOwCJ490F4oWnarlVc/Z4hxTYgnPlGKs4L3oM51WZpLw6Ocs
u+a2E/+GH0+zLJAVqNyvpF7hVNzW2r7bH9uk1DshV6cNc2qnLmYwgsgMDiAcUyGi
M4IH+15pgLZ5KgzGkAAHHLcbFfWT/YcOp0OQHSCoBs7llyKNxfoOe1GE3gpY4ZSa
IgzD+RvwjuxbDGKY3/f5nouQIpVySw==
=LUKL
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--

