Date: Wed, 5 Aug 2020 13:47:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200805124749.GH361702@stefanha-x1.localdomain>
References: <20200803191511.45261-1-dgilbert@redhat.com>
	<20200803191511.45261-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline
In-Reply-To: <20200803191511.45261-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] tools/virtiofsd: xattr name mappings:
	Add option
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


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2020 at 08:15:09PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
> index 824e713491..82b6f6d90a 100644
> --- a/docs/tools/virtiofsd.rst
> +++ b/docs/tools/virtiofsd.rst
> @@ -107,6 +107,51 @@ Options
>    performance.  ``auto`` acts similar to NFS with a 1 second metadata ca=
che
>    timeout.  ``always`` sets a long cache lifetime at the expense of cohe=
rency.
> =20
> +xattr-mapping
> +-------------
> +
> +By default the name of xattr's used by the client are passe through to t=
he host
> +file system.  This can be a problem where either those xattr names are u=
sed
> +by something on the host (e.g. selinux guest/host confusion) or if the
> +virtiofsd is running in a container with restricted priviliges where it =
cannot
> +access some attributes.
> +
> +A mapping of xattr names can be made using -o xattrmap=3Dmapping where t=
he ``mapping``
> +string consists of a series of rules.
> +
> +Each rule starts and ends with a ':'.  The mapping stops on a matching
> +rule.  White space may be added before and after each rule.
> +
> +:scope:type:key:prepend:
> +
> +scope=3D 'c' - match 'key' against a xattr name from the client
> +            for setxattr/getxattr/removexattr
> +       'h' - match 'prepend' against a xattr name from the host
> +            for listxattr
> +       both letters can be included to match both cases.
> +
> +type is one of:
> +       'p' Prefixing: If 'key' matches the client then the 'prepend'
> +           is added before the name is passed to the host.
> +           For a host case, the prepend is tested and stripped
> +           if matching.
> +
> +       'o' OK: The attribute name is OK and passed through to
> +           the host unchanged.
> +
> +       'b' Bad: If a client tries to use this name it's
> +           denied using EPERM; when the host passes an attribute
> +           name matching it's hidden.
> +
> +key is a string tested as a prefix on an attribute name originating
> +       on the client.  It maybe empty in which case a 'c' rule
> +       will always match on client names.
> +
> +prepend is a string tested as a prefix on an attribute name originiating
> +       on the host, and used as a new prefix by 'p'.  It maybe empty
> +       in which case a 'h' rule will always match on host names.

This syntax and the documentation is hard to understand. Defining
concrete commands instead of a single super-command would make it more
straightforward.

Here is the functionality I've been able to extract from the
documentation:

1. Rewrite client xattrs

   rewrite OLD NEW -> s/^OLD/NEW/

2. Allow client xattrs

   allow PREFIX -> allow if matching

3. Deny client xattrs

   deny PREFIX -> EPERM if matching

4. Unprefix server xattrs

   unprefix PREFIX -> s/^PREFIX//

5. Hide server xattrs

   hide PREFIX -> skip if matching

Did I miss any functionality?

I suggest using "client" and "server" terminology instead of "client"
and "host".

Prefix syntax: xattr names are matched by prefix. The empty string
matches all xattr names. How is ':' escaped?

It is unclear whether 'o' terminates processing immediately. Will later
'p' rules still execute?

It is unclear whether 'o'/'b' match the original client name or the
rewritten name after a 'p' command.

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8qqnUACgkQnKSrs4Gr
c8g8rgf/f1wYLasnqqi1EWMrYj1WL9+0vvyGPEteDMK46Gclq8K+e7AsoLOaq5hf
DQOdFyC/IwkiBfFD1dVBXnRKeUN47rtRCgOK0czLtcBCR8LREvwTpKBKRX+8Lcpz
UAtP+x2/Aik5+cwOzdFC0lilY191gMrB4xP8M6vfEnynOTRkWsP9QY9ccej3IFJY
J8EfGBFQeXrLYYPtKZOkE+sPp2lfi/dK9kWV2/MfUhd2l/naLOah3Z3R+2HaveAO
RR5BeLNAOb1r+0oDntgmfsjfSImWn75ZCxlvkUQbT+ZeMCcHkxLkR4yc3c21ZYJB
kMnJ5DNLdXV0bJ8lIiJMtf3M41N80Q==
=qN12
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--

