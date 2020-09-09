Date: Wed, 9 Sep 2020 13:20:12 +0200
From: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Message-ID: <20200909112012.GD1377607@lpt>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <20200827153657.111098-4-dgilbert@redhat.com>
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
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On a Thursday in 2020, Dr. David Alan Gilbert (git) wrote:
>From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
>Add an option to define mappings of xattr names so that
>the client and server filesystems see different views.
>This can be used to have different SELinux mappings as
>seen by the guest, to run the virtiofsd with less privileges
>(e.g. in a case where it can't set trusted/system/security
>xattrs but you want the guest to be able to), or to isolate
>multiple users of the same name; e.g. trusted attributes
>used by stacking overlayfs.
>
>A mapping engine is used wit 3 simple rules; the rules can
>be combined to allow most useful mapping scenarios.
>The ruleset is defined by -o xattrmap='rules...'.
>
>This patch doesn't use the rule maps yet.
>
>Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>---
> docs/tools/virtiofsd.rst         |  55 ++++++++++++
> tools/virtiofsd/passthrough_ll.c | 148 +++++++++++++++++++++++++++++++
> 2 files changed, 203 insertions(+)
>
>diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
>index 824e713491..2efa16d3c5 100644
>--- a/docs/tools/virtiofsd.rst
>+++ b/docs/tools/virtiofsd.rst
>@@ -107,6 +107,60 @@ Options
>   performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
>   timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
>
>+xattr-mapping
>+-------------
>+
>+By default the name of xattr's used by the client are passed through to the server
>+file system.  This can be a problem where either those xattr names are used
>+by something on the server (e.g. selinux client/server confusion) or if the
>+virtiofsd is running in a container with restricted priviliges where it cannot

privileges

>+access some attributes.
>+
>+A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
>+string consists of a series of rules.
>+
>+The first matching rule terminates the mapping.
>+
>+Each rule consists of a number of fields separated with a separator that is the
>+first non-white space character in the rule.  This separator must then be used
>+for the whole rule.
>+White space may be added before and after each rule.
>+Using ':' as the separator a rule is of the form:
>+
>+``:scope:type:key:prepend:``
>+
>+**scope** is:
>+
>+- 'client' - match 'key' against a xattr name from the client for
>+             setxattr/getxattr/removexattr
>+- 'server' - match 'prepend' against a xattr name from the server
>+             for listxattr
>+- 'all' - can be used to match both cases.
>+
>+**type** is one of:
>+
>+- 'prefix' - If 'key' matches the client then the 'prepend'
>+  is added before the name is passed to the server.
>+  For a server case, the prepend is tested and stripped
>+  if matching.
>+
>+- 'ok' - The attribute name is OK and passed through to
>+  the server unchanged.
>+
>+- 'bad' - If a client tries to use this name it's
>+  denied using EPERM; when the server passes an attribute
>+  name matching it's hidden.
>+
>+**key** is a string tested as a prefix on an attribute name originating
>+on the client.  It maybe empty in which case a 'client' rule
>+will always match on client names.
>+
>+**prepend** is a string tested as a prefix on an attribute name originiating

originating

>+on the server, and used as a new prefix.  It maybe empty

may be

>+in which case a 'server' rule will always match on all names from
>+the server.
>+
>+
> Examples
> --------
>
>@@ -123,3 +177,4 @@ Export ``/var/lib/fs/vm001/`` on vhost-user UNIX domain socket
>       -numa node,memdev=mem \
>       ...
>   guest# mount -t virtiofs myfs /mnt
>+

git complains about trailing whitespace at EOF

Jano

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE7DTm0WabvfIr7YZ4Ak1z5KIMl5QFAl9YumsACgkQAk1z5KIM
l5Ry0Af/Zjbvzw4apmipGfIqkDHTdj3ujBEvABtzHkR/E3gnyB1kpVHQX2WI/kCv
DkMGNF1GjV3B7Tn1TGv/32Sel9xU0V2pIZNCjUNRGlJ9V2ct4kFDjfeVNyUKX9SS
mE/OxS3aJ2whyS0kZvWBbQAqZXf8h52ffgaiSBFM3wdB5SW7KdT8SOh0IVQl4Smc
A7uwojQfYI2JE3rxqJcu2Uq+dOzVCak8ZIcG5D0Vlq9upf3dSVB5+uKw8cPs0A0F
F4fZCFVFCp53j4YudCPk+PDIrgjiUA0ize0pTpkriU+HUyl9yM1X1y9NNfvebonx
DKIA+QxHdcS2AgtRcxcHrLm7ExRY/w==
=fIpH
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--

