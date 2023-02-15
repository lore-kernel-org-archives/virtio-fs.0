Return-Path: <stefanha@redhat.com>
Date: Wed, 15 Feb 2023 15:03:14 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y+06giqYYsASQOWM@fedora>
References: <20230215184310.161283-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="go+pgMJNfGgD2z5M"
Content-Disposition: inline
In-Reply-To: <20230215184310.161283-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/4] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org


--go+pgMJNfGgD2z5M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2023 at 06:43:06PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> We deprecated the C virtiofsd in commit 34deee7b6a1418f3d62a
> in v7.0 in favour of the Rust implementation at
> =20
>   https://gitlab.com/virtio-fs/virtiofsd
> =20
> since then, the Rust version has had more development and
> has held up well.  It's time to say goodbye to the C version
> that got us going.
>=20
> v2:
>   After comments on the v1 series, I've removed the Avocado
> test.
>=20
> Dr. David Alan Gilbert (4):
>   virtiofsd: Remove test
>   virtiofsd: Remove build and docs glue
>   virtiofsd: Remove source
>   virtiofsd: Swing deprecated message to removed-features
>=20
>  MAINTAINERS                                   |    2 -
>  docs/about/deprecated.rst                     |   18 -
>  docs/about/removed-features.rst               |   13 +
>  docs/conf.py                                  |    4 -
>  docs/meson.build                              |    1 -
>  docs/tools/index.rst                          |    1 -
>  docs/tools/virtiofsd.rst                      |  403 --
>  meson.build                                   |    1 -
>  meson_options.txt                             |    2 -
>  .../ci/org.centos/stream/8/x86_64/configure   |    2 -
>  .../org.centos/stream/8/x86_64/test-avocado   |    7 -
>  scripts/coverity-scan/COMPONENTS.md           |    3 -
>  scripts/meson-buildoptions.sh                 |    3 -
>  tests/avocado/virtiofs_submounts.py           |  217 -
>  tools/meson.build                             |   13 -
>  tools/virtiofsd/50-qemu-virtiofsd.json.in     |    5 -
>  tools/virtiofsd/buffer.c                      |  350 --
>  tools/virtiofsd/fuse_common.h                 |  837 ---
>  tools/virtiofsd/fuse_i.h                      |  107 -
>  tools/virtiofsd/fuse_log.c                    |   40 -
>  tools/virtiofsd/fuse_log.h                    |   75 -
>  tools/virtiofsd/fuse_lowlevel.c               | 2732 ----------
>  tools/virtiofsd/fuse_lowlevel.h               | 1988 --------
>  tools/virtiofsd/fuse_misc.h                   |   59 -
>  tools/virtiofsd/fuse_opt.c                    |  446 --
>  tools/virtiofsd/fuse_opt.h                    |  272 -
>  tools/virtiofsd/fuse_signals.c                |   93 -
>  tools/virtiofsd/fuse_virtio.c                 | 1081 ----
>  tools/virtiofsd/fuse_virtio.h                 |   33 -
>  tools/virtiofsd/helper.c                      |  409 --
>  tools/virtiofsd/meson.build                   |   18 -
>  tools/virtiofsd/passthrough_helpers.h         |   51 -
>  tools/virtiofsd/passthrough_ll.c              | 4521 -----------------
>  tools/virtiofsd/passthrough_seccomp.c         |  182 -
>  tools/virtiofsd/passthrough_seccomp.h         |   14 -
>  35 files changed, 13 insertions(+), 13990 deletions(-)
>  delete mode 100644 docs/tools/virtiofsd.rst
>  delete mode 100644 tests/avocado/virtiofs_submounts.py
>  delete mode 100644 tools/virtiofsd/50-qemu-virtiofsd.json.in
>  delete mode 100644 tools/virtiofsd/buffer.c
>  delete mode 100644 tools/virtiofsd/fuse_common.h
>  delete mode 100644 tools/virtiofsd/fuse_i.h
>  delete mode 100644 tools/virtiofsd/fuse_log.c
>  delete mode 100644 tools/virtiofsd/fuse_log.h
>  delete mode 100644 tools/virtiofsd/fuse_lowlevel.c
>  delete mode 100644 tools/virtiofsd/fuse_lowlevel.h
>  delete mode 100644 tools/virtiofsd/fuse_misc.h
>  delete mode 100644 tools/virtiofsd/fuse_opt.c
>  delete mode 100644 tools/virtiofsd/fuse_opt.h
>  delete mode 100644 tools/virtiofsd/fuse_signals.c
>  delete mode 100644 tools/virtiofsd/fuse_virtio.c
>  delete mode 100644 tools/virtiofsd/fuse_virtio.h
>  delete mode 100644 tools/virtiofsd/helper.c
>  delete mode 100644 tools/virtiofsd/meson.build
>  delete mode 100644 tools/virtiofsd/passthrough_helpers.h
>  delete mode 100644 tools/virtiofsd/passthrough_ll.c
>  delete mode 100644 tools/virtiofsd/passthrough_seccomp.c
>  delete mode 100644 tools/virtiofsd/passthrough_seccomp.h
>=20
> --=20
> 2.39.1
>=20

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--go+pgMJNfGgD2z5M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPtOoIACgkQnKSrs4Gr
c8jeOQf7Biys2/BZNcoXT80IJu1CtgtYF3z3krJ2VlkoXghwLbTmt70NQmg/QRA1
BJXgbYvBFsLVINRM1FYliMEVU0KxxOrox2VV4pZnJhQr9N87dmYKiBDkxRLNNeGK
CtqJQu+XBRKsOh8NXYNzUDekqXDOhG9v85VZ3AwIUX4lIYS6Mv8C0iO+8tDamXBB
o/UfB4VJljvHD5hKDnAZs+PgcRZJJnnoofkQSaLPt/FSY19ZXzMIg406WTHO18bd
o+eUIo2B0ck0YCGGZmxCRS0VpqynetmKKYGhRFUiAgdvYyiJ9QaftmNCnsJVwFp+
0r0DAJuuq9Zly6CL2Ti1QCM9W5z0kA==
=DW2p
-----END PGP SIGNATURE-----

--go+pgMJNfGgD2z5M--
