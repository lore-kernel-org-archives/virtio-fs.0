Date: Tue, 20 Oct 2020 10:07:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201020090755.GA140014@stefanha-x1.localdomain>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/5] tools/virtiofsd: xattr name
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
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2020 at 07:02:05PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add an option to define mappings of xattr names so that
> the client and server filesystems see different views.
> This can be used to have different SELinux mappings as
> seen by the guest, to run the virtiofsd with less privileges
> (e.g. in a case where it can't set trusted/system/security
> xattrs but you want the guest to be able to), or to isolate
> multiple users of the same name; e.g. trusted attributes
> used by stacking overlayfs.
>=20
> A mapping engine is used wit 3 simple rules; the rules can

s/wit/with/

> +``:type:scope:key:prepend:``
> +
> +**type** is one of:
> +
> +- 'prefix' - If 'key' matches the client then the 'prepend'
> +  is added before the name is passed to the server.
> +  For a server case, the prepend is tested and stripped
> +  if matching.

It may be clearer to document rule types like this:

  - :prefix:client:key:prepend: - Add 'prepend' before the name if it
                                  starts with 'key'.

  - :prefix:server::prepend: - Strip 'prepend' if the name starts with
                               it.

The client vs server behavior is independent so it's clearer to list
them as separate cases. In addition, using the full rule syntax shows
which fields are valid arguments and which ones are ignored.

The 'all' scope can be documented later as "Combines both the 'client'
and 'server' scope behavior".

> +
> +- 'ok' - The attribute name is OK and passed through to
> +  the server unchanged.

The documentation isn't explicit but I think the default behavior is to
allow all xattr names?

What is the purpose of the 'ok' rule? I guess it's to define an
exception to a later 'prefix' or 'bad' rule. It would be nice to make
this clear.

The documentation only mentions :client: behavior, leaving :server:
undefined. Please indicate whether this rule has an effect in server
scope.

> +
> +- 'bad' - If a client tries to use this name it's
> +  denied using EPERM; when the server passes an attribute
> +  name matching it's hidden.
> +
> +**scope** is:
> +
> +- 'client' - match 'key' against a xattr name from the client for
> +             setxattr/getxattr/removexattr
> +- 'server' - match 'prepend' against a xattr name from the server
> +             for listxattr
> +- 'all' - can be used to match both cases.
> +
> +**key** is a string tested as a prefix on an attribute name originating
> +on the client.  It maybe empty in which case a 'client' rule
> +will always match on client names.

Is there a way to match a full string instead of a prefix (regexp
^<pattern>$ instead of ^<pattern>)?

> @@ -2010,6 +2020,169 @@ static void lo_flock(fuse_req_t req, fuse_ino_t i=
no, struct fuse_file_info *fi,
>      fuse_reply_err(req, res =3D=3D -1 ? errno : 0);
>  }
> =20
> +/*
> + * Exit; process attribute unmodified if matched.
> + * An empty key applies to all.
> + */
> +#define XATTR_MAP_FLAG_END_OK  (1 <<  0)
> +/*
> + * The attribute is unwanted;
> + * EPERM on write hidden on read.

Making this sentence easier to parse:

s/write hidden/write, hidden/

> + */
> +#define XATTR_MAP_FLAG_END_BAD (1 <<  1)
> +/*
> + * For attr that start with 'key' prepend 'prepend'
> + * 'key' maybe empty to prepend for all attrs

s/maybe/may be/

> +    /* Add a terminator to error in cases the user hasn't specified */
> +    tmp_entry.flags =3D XATTR_MAP_FLAG_ALL | XATTR_MAP_FLAG_END_BAD |
> +                      XATTR_MAP_FLAG_LAST;

The comment is slightly misleading. This entry must be added in all
cases since it terminates the lo->xattr_map_list with the
XATTR_MAP_FLAG_LAST flag. If we don't add this entry then
free_xattrmap() will iterate beyond the end of lo->xattr_map_list.

Another approach is to set XATTR_MAP_FLAG_LAST in add_xattrmap_entry()
(and clear it on the previous last entry). That way adding the 'bad'
catch-all truly is optional and just for cases where the user hasn't
defined a catch-all rule themselves.

> +    tmp_entry.key =3D g_strdup("");
> +    tmp_entry.prepend =3D g_strdup("");
> +    lo->xattr_map_list =3D add_xattrmap_entry(lo->xattr_map_list, &nentr=
ies,
> +                                            &tmp_entry);
> +
> +    return res;
> +}
> +
>  static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
>                          size_t size)
>  {
> @@ -2806,6 +2979,8 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
>          close(lo->root.fd);
>      }
> =20
> +    free(lo->xattrmap);
> +    free_xattrmap(lo->xattr_map_list);
>      free(lo->source);
>  }
> =20
> @@ -2906,6 +3081,11 @@ int main(int argc, char *argv[])
>      } else {
>          lo.source =3D strdup("/");
>      }
> +
> +    if (lo.xattrmap) {
> +        lo.xattr_map_list =3D parse_xattrmap(&lo);
> +    }

The function always returns NULL. Has this been tested?

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+OqOsACgkQnKSrs4Gr
c8go4ggAic/86MvVgjCIFR1IN4EcPlPw5sJhcC7OvyOvt6S7eKNnWD5nuzDVQELr
+18eWtIMbMT5y8HkyLxvLFVG3tSZYx2kMmobRLhP3dbFxbDOObZ7srslv+45tYVe
aKDTNWVg40vVgZ9PT8YwOcjlVs8rsgrKINXljIGd7Z6BvylggUqNrCCIDeTc9i4H
nUFS2BEeLqzyEww6A9SDCMbNwNUcXlCERHKbAIXlTN5GFB3Iwgvk37iKuTN383yG
mb3aWb9Lx/ctGb4vxATxrVh2QtehWTo26Ny2+JYWX3bNicMRqQPv1+1x2yLSM8K8
YxHpHfSs2fVHCTS4W/SP64TMNcukQQ==
=xgA4
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--

